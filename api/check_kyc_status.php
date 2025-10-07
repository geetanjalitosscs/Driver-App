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
if (!isset($input['driver_id']) || empty($input['driver_id'])) {
    sendErrorResponse('Driver ID is required');
}

$driverId = $input['driver_id'];

try {
    // Get driver data with current KYC status
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

    if (!$driver) {
        sendErrorResponse('Driver not found');
    }

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
        'message' => 'KYC status retrieved successfully',
        'driver' => $driverData
    ]);

} catch (PDOException $e) {
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>
