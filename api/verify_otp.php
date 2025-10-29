<?php
require_once './db_config.php';

setApiHeaders();

// Start session to retrieve OTP
// Check if session ID is provided in Cookie header
if (isset($_SERVER['HTTP_COOKIE'])) {
    $cookies = $_SERVER['HTTP_COOKIE'];
    // Extract PHPSESSID from cookie string
    if (preg_match('/PHPSESSID=([^;\s]+)/i', $cookies, $matches)) {
        session_id($matches[1]);
        error_log("Verify OTP - Using session ID from cookie: " . $matches[1]);
    }
}

session_start();

// Debug logging
error_log("Verify OTP - Session ID: " . session_id());
error_log("Verify OTP - Session data exists: " . (isset($_SESSION['signup_data']) ? 'YES' : 'NO'));
error_log("Verify OTP - Cookie header: " . ($_SERVER['HTTP_COOKIE'] ?? 'NOT SET'));

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !isset($input['otp']) || !isset($input['phone'])) {
    sendErrorResponse('OTP and phone number are required');
}

$enteredOtp = $input['otp'];
$phone = $input['phone'];

// Check if session data exists
if (!isset($_SESSION['signup_data']) || !isset($_SESSION['signup_otp']) || !isset($_SESSION['signup_otp_time'])) {
    error_log("Verify OTP - Session data missing. Session keys: " . implode(', ', array_keys($_SESSION)));
    sendErrorResponse('OTP session expired. Please start signup again.');
}

// Verify phone number matches
if ($_SESSION['signup_phone'] !== $phone) {
    sendErrorResponse('Phone number mismatch');
}

// Check OTP expiration (10 minutes = 600 seconds)
$otpAge = time() - $_SESSION['signup_otp_time'];
if ($otpAge > 600) {
    // Clear expired session
    unset($_SESSION['signup_data']);
    unset($_SESSION['signup_otp']);
    unset($_SESSION['signup_otp_time']);
    unset($_SESSION['signup_phone']);
    sendErrorResponse('OTP has expired. Please request a new one.');
}

// Verify OTP
if ($_SESSION['signup_otp'] !== $enteredOtp) {
    sendErrorResponse('Invalid OTP. Please check and try again.');
}

// OTP verified - proceed with account creation
$signupData = $_SESSION['signup_data'];

$driverName = $signupData['driver_name'];
$email = $signupData['email'];
$password = $signupData['password'];
$address = $signupData['address'];
$vehicleType = $signupData['vehicle_type'];
$vehicleNumber = $signupData['vehicle_number'];
$aadharPhoto = $signupData['aadhar_photo'];
$licencePhoto = $signupData['licence_photo'];
$rcPhoto = $signupData['rc_photo'];
$accountNumber = $signupData['account_number'];
$bankName = $signupData['bank_name'];
$ifscCode = $signupData['ifsc_code'];
$accountHolderName = $signupData['account_holder_name'];

// Function to save base64 image to file
function saveBase64Image($base64Data, $driverId, $photoType, $uploadsDir) {
    if (empty($base64Data)) {
        return null;
    }
    
    // Check if it's a data URI format
    if (preg_match('/^data:image\/(jpeg|jpg|png|gif);base64,/', $base64Data)) {
        // Extract image data and type from data URI
        $image_data = explode(',', $base64Data);
        $image_info = explode(';', $image_data[0]);
        $image_type = explode('/', $image_info[0])[1];
        $base64_content = $image_data[1];
    } else {
        // Assume it's raw base64 data
        $base64_content = $base64Data;
        $image_type = 'jpg'; // Default to jpg
    }
    
    // Decode base64 data
    $decoded_data = base64_decode($base64_content, true);
    if ($decoded_data === false || empty($decoded_data)) {
        return null;
    }
    
    // Generate unique filename
    $unique_filename = $driverId . '_' . $photoType . '_' . time() . '_' . uniqid() . '.' . $image_type;
    $file_path = $uploadsDir . $unique_filename;
    
    // Save file
    if (file_put_contents($file_path, $decoded_data) !== false) {
        return $unique_filename;
    }
    
    return null;
}

// SMS Greeting Function
function sendGreetingSMS($mobile_no, $client_name) {
    $url = 'http://bhashsms.com/api/sendmsg.php';
    
    $message = "Dear " . $driver_name . ", On behalf of the entire team at APATKAL, I would like to extend our sincere thanks for your trust . We value the opportunity to serve you and look forward to continuing our service MGAUS INFORMATION TECHNOLOGY PRIVATE LIMITED";
    
    $params = [
        'user' => 'MgausSMS',
        'pass' => '123456',
        'sender' => 'APTKAL',
        'phone' => $mobile_no,
        'text' => $message,
        'tmplid' => '1707174350438685298',
        'priority' => 'ndnd',
        'stype' => 'normal'
    ];
    
    $postData = http_build_query($params);
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);
    curl_close($ch);
    
    // Log for debugging
    error_log("Greeting SMS API Response: HTTP $httpCode, Response: $response, Error: $curlError");
    
    // Check if SMS was sent successfully
    return ($httpCode == 200 && $response !== false);
}

try {
    // Double-check if email/phone still don't exist (in case someone registered in the meantime)
    $stmt = $pdo->prepare("SELECT id FROM drivers WHERE email = ?");
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        // Clear session
        session_destroy();
        sendErrorResponse('Email already exists');
    }

    $stmt = $pdo->prepare("SELECT id FROM drivers WHERE number = ?");
    $stmt->execute([$phone]);
    if ($stmt->fetch()) {
        // Clear session
        session_destroy();
        sendErrorResponse('Phone number already exists');
    }

    // Hash the password before storing
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    
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
    
    $stmt->execute([
        $driverName,
        $email,
        $hashedPassword,
        $phone,
        $address,
        $vehicleType,
        $vehicleNumber,
        'pending_aadhar', // Placeholder
        'pending_licence', // Placeholder
        'pending_rc', // Placeholder
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

    // Save photos to files
    $saved_aadhar = saveBase64Image($aadharPhoto, $driverId, 'aadhar', $uploads_dir);
    $saved_licence = saveBase64Image($licencePhoto, $driverId, 'licence', $uploads_dir);
    $saved_rc = saveBase64Image($rcPhoto, $driverId, 'rc', $uploads_dir);

    // Update database with saved photo filenames
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
    
    // Update the database with photo filenames
    $update_values[] = $driverId;
    $stmt = $pdo->prepare("UPDATE drivers SET " . implode(', ', $update_fields) . " WHERE id = ?");
    $stmt->execute($update_values);

    // Store driver location if provided
    if (isset($signupData['latitude']) && isset($signupData['longitude'])) {
        $latitude = (float)$signupData['latitude'];
        $longitude = (float)$signupData['longitude'];
        $location_address = $signupData['address'] ?? null;
        
        try {
            // Insert driver location (assuming table already exists)
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

    // Store device session if provided
    $device_id = $signupData['device_id'] ?? null;
    $device_name = $signupData['device_name'] ?? 'Unknown Device';
    $ip_address = $_SERVER['REMOTE_ADDR'] ?? null;
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? null;
    
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
            
            // Insert device session for new user
            $stmt = $pdo->prepare("
                INSERT INTO device_sessions (driver_id, device_id, device_name, ip_address, user_agent, is_active)
                VALUES (?, ?, ?, ?, ?, TRUE)
            ");
            $stmt->execute([$driverId, $device_id, $device_name, $ip_address, $user_agent]);
            
            error_log("Signup - Device session created: Driver {$driverId}, Device: {$device_id} ({$device_name})");
        } catch (Exception $e) {
            error_log("Signup - Failed to create device session: " . $e->getMessage());
            // Don't fail signup if device session creation fails
        }
    }

    // Send greeting SMS
    sendGreetingSMS($phone, $driverName);

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

    // Format driver data for response
    $driverData = [
        'driver_id' => (int)$driver['id'],  // Ensure it's an integer, not string
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

    // Clear session after successful signup
    unset($_SESSION['signup_data']);
    unset($_SESSION['signup_otp']);
    unset($_SESSION['signup_otp_time']);
    unset($_SESSION['signup_phone']);

    echo json_encode([
        'success' => true,
        'message' => 'Account created successfully',
        'driver' => $driverData
    ]);

} catch (PDOException $e) {
    // Clear session on error
    session_destroy();
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>

