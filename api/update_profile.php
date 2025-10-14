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

if (!$input || !isset($input['driver_id'])) {
    sendErrorResponse('Driver ID is required');
}

$driverId = (int)$input['driver_id'];
$driverName = $input['driver_name'] ?? '';
$email = $input['email'] ?? '';
$phone = $input['number'] ?? '';
$address = $input['address'] ?? '';
$vehicleType = $input['vehicle_type'] ?? '';
$vehicleNumber = $input['vehicle_number'] ?? '';

try {
    // Update driver profile
    $stmt = $pdo->prepare("
        UPDATE drivers 
        SET 
            driver_name = ?,
            email = ?,
            number = ?,
            address = ?,
            vehicle_type = ?,
            vehicle_number = ?
        WHERE id = ?
    ");
    
    $stmt->execute([
        $driverName,
        $email,
        $phone,
        $address,
        $vehicleType,
        $vehicleNumber,
        $driverId
    ]);

    if ($stmt->rowCount() === 0) {
        sendErrorResponse('Driver not found');
    }

    // Get updated driver data
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
        'aadhar_photo' => getUploadsUrl($driver['aadhar_photo']),
        'licence_photo' => getUploadsUrl($driver['licence_photo']),
        'rc_photo' => getUploadsUrl($driver['rc_photo']),
        'created_at' => $driver['created_at'],
    ];

    echo json_encode([
        'success' => true,
        'message' => 'Profile updated successfully',
        'driver' => $driverData
    ]);

} catch (PDOException $e) {
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>
