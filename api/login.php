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
        'message' => 'Login successful',
        'driver' => $driverData
    ]);

} catch (PDOException $e) {
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>
