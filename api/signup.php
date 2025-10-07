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
    if (empty($base64Data) || !preg_match('/^data:image\/(jpeg|jpg|png|gif);base64,/', $base64Data)) {
        return null;
    }
    
    // Extract image data and type
    $image_data = explode(',', $base64Data);
    $image_info = explode(';', $image_data[0]);
    $image_type = explode('/', $image_info[0])[1];
    $base64_content = $image_data[1];
    
    // Decode base64 data
    $decoded_data = base64_decode($base64_content);
    if ($decoded_data === false) {
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

    // Insert new driver
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
        $aadharPhoto,
        $licencePhoto,
        $rcPhoto
    ]);

    $driverId = $pdo->lastInsertId();

    // Create uploads directory if it doesn't exist
    $uploads_dir = __DIR__ . '/uploads/';
    if (!is_dir($uploads_dir)) {
        if (!mkdir($uploads_dir, 0755, true)) {
            error_log('Warning: Failed to create uploads directory');
        }
    }

    // Save photos to files and update database with filenames
    $saved_aadhar = saveBase64Image($aadharPhoto, $driverId, 'aadhar', $uploads_dir);
    $saved_licence = saveBase64Image($licencePhoto, $driverId, 'licence', $uploads_dir);
    $saved_rc = saveBase64Image($rcPhoto, $driverId, 'rc', $uploads_dir);

    // Update database with saved photo filenames
    if ($saved_aadhar || $saved_licence || $saved_rc) {
        $update_fields = [];
        $update_values = [];
        
        if ($saved_aadhar) {
            $update_fields[] = 'aadhar_photo = ?';
            $update_values[] = $saved_aadhar;
        }
        if ($saved_licence) {
            $update_fields[] = 'licence_photo = ?';
            $update_values[] = $saved_licence;
        }
        if ($saved_rc) {
            $update_fields[] = 'rc_photo = ?';
            $update_values[] = $saved_rc;
        }
        
        if (!empty($update_fields)) {
            $update_values[] = $driverId;
            $stmt = $pdo->prepare("UPDATE drivers SET " . implode(', ', $update_fields) . " WHERE id = ?");
            $stmt->execute($update_values);
        }
    }

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
        'aadhar_photo' => $driver['aadhar_photo'],
        'licence_photo' => $driver['licence_photo'],
        'rc_photo' => $driver['rc_photo'],
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
