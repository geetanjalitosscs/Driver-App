<?php
require_once './db_config.php';

setApiHeaders();

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

// Debug logging
error_log("Login - Input received: " . json_encode($input));
error_log("Login - Device ID in input: " . ($input['device_id'] ?? 'NOT_FOUND'));
error_log("Login - Device Name in input: " . ($input['device_name'] ?? 'NOT_FOUND'));

if (!$input || !isset($input['email']) || !isset($input['password'])) {
    sendErrorResponse('Email and password are required');
}

$email = $input['email'];
$password = $input['password'];

// Debug logging
error_log("Login - Email: " . $email);

try {
    // Check if driver exists
    $stmt = $pdo->prepare("
        SELECT 
            id,
            driver_name,
            email,
            password,
            number,
            address,
            vehicle_type,
            vehicle_number,
            model_rating,
            aadhar_photo,
            licence_photo,
            rc_photo,
            kyc_status,
            account_number,
            bank_name,
            ifsc_code,
            account_holder_name,
            created_at
        FROM drivers 
        WHERE email = ?
    ");
    $stmt->execute([$email]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);

    // Debug logging
    error_log("Login - Driver found: " . json_encode($driver));

    if (!$driver) {
        sendErrorResponse('Invalid email or password');
    }

    // Verify password using password_verify (for hashed passwords)
    if (!password_verify($password, $driver['password'])) {
        sendErrorResponse('Invalid email or password');
    }

    // Debug logging
    error_log("Login - KYC Status: " . $driver['kyc_status']);

    // Check KYC status
    if ($driver['kyc_status'] !== 'approved') {
        error_log("Login - KYC not approved, returning pending response");
        
        // Remove password from response
        unset($driver['password']);
        
        // Format driver data for response (matching ProfileData.fromJson expectations)
        $driverData = [
            'driver_id' => $driver['id'],
            'driver_name' => $driver['driver_name'],
            'email' => $driver['email'],
            'phone' => $driver['number'],
            'address' => !empty($driver['address']) ? $driver['address'] : null,
            'vehicle_type' => $driver['vehicle_type'],
            'vehicle_number' => $driver['vehicle_number'],
            'model_rating' => (float)($driver['model_rating'] ?? 0.0),
            'aadhar_photo' => $driver['aadhar_photo'],
            'licence_photo' => $driver['licence_photo'],
            'rc_photo' => $driver['rc_photo'],
            'kyc_status' => $driver['kyc_status'],
            'account_number' => $driver['account_number'],
            'bank_name' => $driver['bank_name'],
            'ifsc_code' => $driver['ifsc_code'],
            'account_holder_name' => $driver['account_holder_name'],
            'created_at' => $driver['created_at'],
        ];
        
        echo json_encode([
            'success' => false,
            'kyc_pending' => true,
            'message' => 'KYC verification pending',
            'kyc_status' => $driver['kyc_status'],
            'driver' => $driverData
        ]);
        exit;
    }

    // Remove password from response
    unset($driver['password']);

    // Debug logging for address
    error_log("Login - Driver address from DB: " . ($driver['address'] ?? 'NULL'));
    
    // Device session management for single device login
    $device_id = $input['device_id'] ?? null;
    $device_name = $input['device_name'] ?? 'Unknown Device';
    $ip_address = $_SERVER['REMOTE_ADDR'] ?? null;
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? null;
    
    // Debug logging for device information
    error_log("Login - Device ID: " . ($device_id ?? 'NULL'));
    error_log("Login - Device Name: " . ($device_name ?? 'NULL'));
    error_log("Login - IP Address: " . ($ip_address ?? 'NULL'));
    error_log("Login - All input data: " . json_encode($input));
    
    if ($device_id) {
        try {
            // Create device_sessions table if not exists
            $stmt = $pdo->prepare("
                CREATE TABLE IF NOT EXISTS device_sessions (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    driver_id INT NOT NULL,
                    device_id VARCHAR(255) NOT NULL,
                    device_name VARCHAR(255) DEFAULT NULL,
                    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    is_active BOOLEAN DEFAULT TRUE,
                    ip_address VARCHAR(45) DEFAULT NULL,
                    user_agent TEXT DEFAULT NULL,
                    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
                    UNIQUE KEY unique_driver_device (driver_id, device_id)
                )
            ");
            $stmt->execute();
            
            // Check if driver is already logged in on another device
            $stmt = $pdo->prepare("
                SELECT device_id, device_name, login_time 
                FROM device_sessions 
                WHERE driver_id = ? AND is_active = TRUE AND device_id != ?
            ");
            $stmt->execute([$driver['id'], $device_id]);
            $existing_session = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($existing_session) {
                // Driver is already logged in on another device
                sendErrorResponse("Account is already logged in on another device: {$existing_session['device_name']} (since {$existing_session['login_time']})");
            }
            
            // Deactivate any existing sessions for this driver
            $stmt = $pdo->prepare("UPDATE device_sessions SET is_active = FALSE WHERE driver_id = ?");
            $stmt->execute([$driver['id']]);
            
            // Create new session for this device
            $stmt = $pdo->prepare("
                INSERT INTO device_sessions (driver_id, device_id, device_name, ip_address, user_agent, is_active)
                VALUES (?, ?, ?, ?, ?, TRUE)
                ON DUPLICATE KEY UPDATE
                    device_name = VALUES(device_name),
                    login_time = CURRENT_TIMESTAMP,
                    last_activity = CURRENT_TIMESTAMP,
                    is_active = TRUE,
                    ip_address = VALUES(ip_address),
                    user_agent = VALUES(user_agent)
            ");
            $stmt->execute([$driver['id'], $device_id, $device_name, $ip_address, $user_agent]);
            
            error_log("Login - Device session created: Driver {$driver['id']}, Device: {$device_id} ({$device_name})");
        } catch (Exception $e) {
            error_log("Login - Failed to manage device session: " . $e->getMessage());
            // Don't fail login if device session management fails
        }
    }
    
    // Store/update driver location if provided
    if (isset($_POST['latitude']) && isset($_POST['longitude'])) {
        $latitude = (float)$_POST['latitude'];
        $longitude = (float)$_POST['longitude'];
        $address = $_POST['address'] ?? null;
        
        try {
            // Create driver_locations table if not exists
            $stmt = $pdo->prepare("
                CREATE TABLE IF NOT EXISTS driver_locations (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    driver_id INT NOT NULL UNIQUE,
                    latitude DECIMAL(10, 8) NOT NULL,
                    longitude DECIMAL(11, 8) NOT NULL,
                    address TEXT NULL,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE
                )
            ");
            $stmt->execute();
            
            // Insert or update driver location
            $stmt = $pdo->prepare("
                INSERT INTO driver_locations (driver_id, latitude, longitude, address, updated_at)
                VALUES (?, ?, ?, ?, NOW())
                ON DUPLICATE KEY UPDATE
                    latitude = VALUES(latitude),
                    longitude = VALUES(longitude),
                    address = VALUES(address),
                    updated_at = NOW()
            ");
            $stmt->execute([$driver['id'], $latitude, $longitude, $address]);
            
            error_log("Login - Driver location updated: Driver {$driver['id']}, Lat: {$latitude}, Lng: {$longitude}");
        } catch (Exception $e) {
            error_log("Login - Failed to update driver location: " . $e->getMessage());
        }
    }
    
        // Format driver data for response (matching ProfileData.fromJson expectations)
        $driverData = [
            'driver_id' => $driver['id'],
            'driver_name' => $driver['driver_name'],
            'email' => $driver['email'],
            'phone' => $driver['number'],
            'address' => !empty($driver['address']) ? $driver['address'] : null,
            'vehicle_type' => $driver['vehicle_type'],
        'vehicle_number' => $driver['vehicle_number'],
        'model_rating' => (float)($driver['model_rating'] ?? 0.0),
        'aadhar_photo' => getUploadsUrl($driver['aadhar_photo']),
        'licence_photo' => getUploadsUrl($driver['licence_photo']),
        'rc_photo' => getUploadsUrl($driver['rc_photo']),
        'kyc_status' => $driver['kyc_status'],
        'account_number' => $driver['account_number'],
        'bank_name' => $driver['bank_name'],
        'ifsc_code' => $driver['ifsc_code'],
        'account_holder_name' => $driver['account_holder_name'],
        'created_at' => $driver['created_at'],
    ];

    echo json_encode([
        'success' => true,
        'message' => 'Login successful',
        'driver' => $driverData
    ]);

} catch (PDOException $e) {
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>
