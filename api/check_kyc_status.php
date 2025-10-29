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
error_log("KYC Status Check - Input received: " . json_encode($input));

if (!$input) {
    sendErrorResponse('Invalid input data');
}

// Validate required fields
if (!isset($input['driver_id']) || empty($input['driver_id'])) {
    sendErrorResponse('Driver ID is required');
}

$driverId = $input['driver_id'];

// Debug logging
error_log("KYC Status Check - Driver ID: " . $driverId);

// Note: We don't call checkDriverStatus() here because this endpoint
// is specifically for checking status, including rejected status.
// The status check blocking should happen in other APIs (login, trips, etc.)
// but NOT in the status check endpoint itself.

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

    // Debug logging
    error_log("KYC Status Check - Driver found: " . json_encode($driver));

    if (!$driver) {
        sendErrorResponse('Driver not found');
    }

    // Format driver data for response (matching ProfileData.fromJson expectations)
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

    // Debug logging
    error_log("KYC Status Check - Response data: " . json_encode($driverData));

    echo json_encode([
        'success' => true,
        'message' => 'KYC status retrieved successfully',
        'driver' => $driverData
    ]);

} catch (PDOException $e) {
    error_log("KYC Status Check - Database error: " . $e->getMessage());
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>