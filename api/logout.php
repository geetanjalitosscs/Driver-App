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

if (!$input || !isset($input['driver_id']) || !isset($input['device_id'])) {
    sendErrorResponse('Driver ID and Device ID are required');
}

$driver_id = (int)$input['driver_id'];
$device_id = $input['device_id'];

if ($driver_id <= 0) {
    sendErrorResponse('Invalid driver ID');
}

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
    
    // Delete the device session record completely
    $stmt = $pdo->prepare("
        DELETE FROM device_sessions 
        WHERE driver_id = ? AND device_id = ?
    ");
    $stmt->execute([$driver_id, $device_id]);
    
    $deleted_rows = $stmt->rowCount();
    
    if ($deleted_rows > 0) {
        echo json_encode([
            'success' => true,
            'message' => 'Logout successful - device session deleted',
            'data' => [
                'driver_id' => $driver_id,
                'device_id' => $device_id,
                'logout_time' => date('Y-m-d H:i:s')
            ]
        ]);
        
        error_log("Logout - Device session deleted: Driver {$driver_id}, Device: {$device_id}");
    } else {
        echo json_encode([
            'success' => true,
            'message' => 'Logout successful - no device session found to delete',
            'data' => [
                'driver_id' => $driver_id,
                'device_id' => $device_id,
                'logout_time' => date('Y-m-d H:i:s')
            ]
        ]);
        
        error_log("Logout - No device session found to delete: Driver {$driver_id}, Device: {$device_id}");
    }
    
} catch (PDOException $e) {
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>
