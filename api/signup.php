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
$requiredFields = ['driver_name', 'email', 'password', 'number', 'address', 'vehicle_type', 'vehicle_number', 'aadhar_photo', 'licence_photo', 'rc_photo'];
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
            kyc_status
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')
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
        'pending_rc' // Placeholder for rc photo
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

    // Create wallet entry for new driver
    $stmt = $pdo->prepare("
        INSERT INTO wallet (driver_id, balance, total_earned, total_withdrawn) 
        VALUES (?, 0.00, 0.00, 0.00)
    ");
    $stmt->execute([$driverId]);

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
