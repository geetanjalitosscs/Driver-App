<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input) {
    sendErrorResponse('Invalid input data');
}

// Validate required fields
$requiredFields = ['driver_name', 'email', 'password', 'number', 'address', 'vehicle_type', 'vehicle_number', 'aadhar_photo', 'licence_photo', 'rc_photo', 'account_number', 'bank_name', 'ifsc_code', 'account_holder_name'];
foreach ($requiredFields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        sendErrorResponse("Field '$field' is required");
    }
}

$driverName = $input['driver_name'];
$email = $input['email'];
$password = $input['password'];
$phone = $input['number'];
$address = $input['address'];
$vehicleType = $input['vehicle_type'];
$vehicleNumber = $input['vehicle_number'];
$aadharPhoto = $input['aadhar_photo'];
$licencePhoto = $input['licence_photo'];
$rcPhoto = $input['rc_photo'];

// Account details
$accountNumber = $input['account_number'];
$bankName = $input['bank_name'];
$ifscCode = $input['ifsc_code'];
$accountHolderName = $input['account_holder_name'];

// Function to save base64 image to file
function saveBase64Image($base64Data, $driverId, $photoType, $uploadsDir) {
    error_log("saveBase64Image called for driver $driverId, type $photoType");
    
    if (empty($base64Data)) {
        error_log("saveBase64Image: Empty base64 data for driver $driverId, type $photoType");
        return null;
    }
    
    // Check if it's a data URI format
    if (preg_match('/^data:image\/(jpeg|jpg|png|gif);base64,/', $base64Data)) {
        // Extract image data and type from data URI
        $image_data = explode(',', $base64Data);
        $image_info = explode(';', $image_data[0]);
        $image_type = explode('/', $image_info[0])[1];
        $base64_content = $image_data[1];
        error_log("saveBase64Image: Detected data URI format, type: $image_type");
    } else {
        // Assume it's raw base64 data
        $base64_content = $base64Data;
        $image_type = 'jpg'; // Default to jpg
        error_log("saveBase64Image: Detected raw base64 data, assuming type: $image_type");
    }
    
    // Decode base64 data
    $decoded_data = base64_decode($base64_content);
    if ($decoded_data === false) {
        error_log("saveBase64Image: Failed to decode base64 data for driver $driverId, type $photoType");
        return null;
    }
    
    // Check if decoded data is valid
    if (empty($decoded_data)) {
        error_log("saveBase64Image: Decoded data is empty for driver $driverId, type $photoType");
        return null;
    }
    
    // Generate unique filename
    $unique_filename = $driverId . '_' . $photoType . '_' . time() . '_' . uniqid() . '.' . $image_type;
    $file_path = $uploadsDir . $unique_filename;
    
    error_log("saveBase64Image: Attempting to save file: $file_path");
    
    // Save file
    if (file_put_contents($file_path, $decoded_data) !== false) {
        $file_size = filesize($file_path);
        error_log("saveBase64Image: Successfully saved photo for driver $driverId, type $photoType, file: $unique_filename, size: $file_size bytes");
        return $unique_filename;
    } else {
        error_log("saveBase64Image: Failed to save file for driver $driverId, type $photoType, path: $file_path");
        return null;
    }
}

// Validate email format
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendErrorResponse('Invalid email format');
}

// Validate password length
if (strlen($password) < 6) {
    sendErrorResponse('Password must be at least 6 characters long');
}

try {
    // Check if email already exists
    $stmt = $pdo->prepare("SELECT id FROM drivers WHERE email = ?");
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        sendErrorResponse('Email already exists');
    }

    // Check if phone already exists
    $stmt = $pdo->prepare("SELECT id FROM drivers WHERE number = ?");
    $stmt->execute([$phone]);
    if ($stmt->fetch()) {
        sendErrorResponse('Phone number already exists');
    }

    // Insert new driver with placeholder photo values
    $stmt = $pdo->prepare("
        INSERT INTO drivers (
            driver_name, 
            email, 
            password, 
            number, 
            address, 
            vehicle_type, 
            vehicle_number,
            aadhar_photo,
            licence_photo,
            rc_photo,
            account_number,
            bank_name,
            ifsc_code,
            account_holder_name,
            kyc_status
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')
    ");
    
    // Hash the password before storing
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    
    $stmt->execute([
        $driverName,
        $email,
        $hashedPassword, // Store hashed password
        $phone,
        $address,
        $vehicleType,
        $vehicleNumber,
        'pending_aadhar', // Placeholder for aadhar photo
        'pending_licence', // Placeholder for licence photo
        'pending_rc', // Placeholder for rc photo
        $accountNumber,
        $bankName,
        $ifscCode,
        $accountHolderName,
    ]);

    $driverId = $pdo->lastInsertId();

    // Create uploads directory if it doesn't exist
    $uploads_dir = __DIR__ . '/uploads/';
    if (!is_dir($uploads_dir)) {
        if (!mkdir($uploads_dir, 0755, true)) {
            error_log('Warning: Failed to create uploads directory');
        }
    }

    // Debug: Log the received photo data
    error_log("=== PHOTO DEBUG FOR DRIVER $driverId ===");
    error_log("Aadhar photo length: " . strlen($aadharPhoto));
    error_log("Aadhar photo preview: " . substr($aadharPhoto, 0, 100) . "...");
    error_log("Licence photo length: " . strlen($licencePhoto));
    error_log("Licence photo preview: " . substr($licencePhoto, 0, 100) . "...");
    error_log("RC photo length: " . strlen($rcPhoto));
    error_log("RC photo preview: " . substr($rcPhoto, 0, 100) . "...");
    error_log("Uploads directory: " . $uploads_dir);
    error_log("Uploads directory exists: " . (is_dir($uploads_dir) ? 'YES' : 'NO'));
    error_log("Uploads directory writable: " . (is_writable($uploads_dir) ? 'YES' : 'NO'));

    // Save photos to files and update database with filenames
    $saved_aadhar = saveBase64Image($aadharPhoto, $driverId, 'aadhar', $uploads_dir);
    $saved_licence = saveBase64Image($licencePhoto, $driverId, 'licence', $uploads_dir);
    $saved_rc = saveBase64Image($rcPhoto, $driverId, 'rc', $uploads_dir);

    // Log photo saving results
    error_log("Photo saving results for driver $driverId:");
    error_log("Aadhar: " . ($saved_aadhar ?: 'FAILED'));
    error_log("Licence: " . ($saved_licence ?: 'FAILED'));
    error_log("RC: " . ($saved_rc ?: 'FAILED'));
    error_log("=== END PHOTO DEBUG ===");

    // Update database with saved photo filenames (only successful ones)
    $update_fields = [];
    $update_values = [];
    
    if ($saved_aadhar) {
        $update_fields[] = 'aadhar_photo = ?';
        $update_values[] = $saved_aadhar;
    } else {
        $update_fields[] = 'aadhar_photo = ?';
        $update_values[] = 'default_aadhar.jpg';
    }
    
    if ($saved_licence) {
        $update_fields[] = 'licence_photo = ?';
        $update_values[] = $saved_licence;
    } else {
        $update_fields[] = 'licence_photo = ?';
        $update_values[] = 'default_licence.jpg';
    }
    
    if ($saved_rc) {
        $update_fields[] = 'rc_photo = ?';
        $update_values[] = $saved_rc;
    } else {
        $update_fields[] = 'rc_photo = ?';
        $update_values[] = 'default_rc.jpg';
    }
    
    // Always update the database with either filenames or default values
    $update_values[] = $driverId;
    $stmt = $pdo->prepare("UPDATE drivers SET " . implode(', ', $update_fields) . " WHERE id = ?");
    $stmt->execute($update_values);


    // Store driver location if provided during signup
    if (isset($_POST['latitude']) && isset($_POST['longitude'])) {
        $latitude = (float)$_POST['latitude'];
        $longitude = (float)$_POST['longitude'];
        $location_address = $_POST['address'] ?? null;
        
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
            
            // Insert driver location
            $stmt = $pdo->prepare("
                INSERT INTO driver_locations (driver_id, latitude, longitude, address, updated_at)
                VALUES (?, ?, ?, ?, NOW())
            ");
            $stmt->execute([$driverId, $latitude, $longitude, $location_address]);
            
            error_log("Signup - Driver location stored: Driver {$driverId}, Lat: {$latitude}, Lng: {$longitude}");
        } catch (Exception $e) {
            error_log("Signup - Failed to store driver location: " . $e->getMessage());
        }
    }

    // Store device session if provided during signup
    $device_id = $input['device_id'] ?? null;
    $device_name = $input['device_name'] ?? 'Unknown Device';
    $ip_address = $_SERVER['REMOTE_ADDR'] ?? null;
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? null;
    
    // Debug logging for device information
    error_log("Signup - Device ID: " . ($device_id ?? 'NULL'));
    error_log("Signup - Device Name: " . ($device_name ?? 'NULL'));
    error_log("Signup - IP Address: " . ($ip_address ?? 'NULL'));
    error_log("Signup - All input data: " . json_encode($input));
    
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
            
            // Insert device session
            $stmt = $pdo->prepare("
                INSERT INTO device_sessions (driver_id, device_id, device_name, ip_address, user_agent, is_active)
                VALUES (?, ?, ?, ?, ?, TRUE)
            ");
            $stmt->execute([$driverId, $device_id, $device_name, $ip_address, $user_agent]);
            
            error_log("Signup - Device session created: Driver {$driverId}, Device: {$device_id} ({$device_name})");
        } catch (Exception $e) {
            error_log("Signup - Failed to create device session: " . $e->getMessage());
        }
    }

    // Get the created driver data
    $stmt = $pdo->prepare("
        SELECT 
            id,
            driver_name,
            email,
            number,
            address,
            vehicle_type,
            vehicle_number,
            model_rating,
            aadhar_photo,
            licence_photo,
            rc_photo,
            kyc_status,
            created_at
        FROM drivers 
        WHERE id = ?
    ");
    $stmt->execute([$driverId]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);

    // Format driver data for response (matching ProfileData.fromJson expectations)
    $driverData = [
        'driver_id' => $driver['id'],
        'driver_name' => $driver['driver_name'],
        'email' => $driver['email'],
        'phone' => $driver['number'],
        'address' => $driver['address'],
        'vehicle_type' => $driver['vehicle_type'],
        'vehicle_number' => $driver['vehicle_number'],
        'model_rating' => (float)($driver['model_rating'] ?? 0.0),
        'aadhar_photo' => getUploadsUrl($driver['aadhar_photo']),
        'licence_photo' => getUploadsUrl($driver['licence_photo']),
        'rc_photo' => getUploadsUrl($driver['rc_photo']),
        'kyc_status' => $driver['kyc_status'],
        'created_at' => $driver['created_at'],
    ];

    echo json_encode([
        'success' => true,
        'message' => 'Account created successfully',
        'driver' => $driverData
    ]);

} catch (PDOException $e) {
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>
