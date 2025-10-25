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

if (!$input || !isset($input['driver_id']) || !isset($input['latitude']) || !isset($input['longitude'])) {
    sendErrorResponse('Driver ID, latitude, and longitude are required');
}

$driver_id = (int)$input['driver_id'];
$latitude = (float)$input['latitude'];
$longitude = (float)$input['longitude'];
$timestamp = date('Y-m-d H:i:s');

if ($driver_id <= 0) {
    sendErrorResponse('Invalid driver ID');
}

// Check driver status before proceeding
checkDriverStatus($driver_id);

try {
    // Create or update driver location table
    $stmt = $pdo->prepare("
        CREATE TABLE IF NOT EXISTS driver_locations (
            id INT PRIMARY KEY AUTO_INCREMENT,
            driver_id INT NOT NULL UNIQUE,
            latitude DECIMAL(10, 8) NOT NULL,
            longitude DECIMAL(11, 8) NOT NULL,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE
        )
    ");
    $stmt->execute();
    
    // Insert or update driver location
    $stmt = $pdo->prepare("
        INSERT INTO driver_locations (driver_id, latitude, longitude, updated_at)
        VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            latitude = VALUES(latitude),
            longitude = VALUES(longitude),
            updated_at = VALUES(updated_at)
    ");
    
    $stmt->execute([$driver_id, $latitude, $longitude, $timestamp]);
    
    echo json_encode([
        'success' => true,
        'message' => 'Driver location updated successfully',
        'data' => [
            'driver_id' => $driver_id,
            'latitude' => $latitude,
            'longitude' => $longitude,
            'updated_at' => $timestamp
        ]
    ]);
    
} catch (PDOException $e) {
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>
