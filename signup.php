<?php
require_once 'db_config.php';

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
            rc_photo
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");
    
    $stmt->execute([
        $driverName,
        $email,
        $password, // In production, hash this password
        $phone,
        $address,
        $vehicleType,
        $vehicleNumber,
        $aadharPhoto,
        $licencePhoto,
        $rcPhoto
    ]);

    $driverId = $pdo->lastInsertId();

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
