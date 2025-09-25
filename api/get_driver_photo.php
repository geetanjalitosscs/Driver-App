<?php
require_once '../db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch(PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get parameters
$driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;
$photo_type = isset($_GET['type']) ? $_GET['type'] : '';

if ($driver_id <= 0) {
    sendErrorResponse('Invalid driver ID');
}

if (!in_array($photo_type, ['aadhar', 'licence', 'rc'])) {
    sendErrorResponse('Invalid photo type. Must be: aadhar, licence, or rc');
}

try {
    // Get driver photo path
    $stmt = $pdo->prepare("SELECT driver_name, {$photo_type}_photo FROM drivers WHERE id = ?");
    $stmt->execute([$driver_id]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$driver) {
        sendErrorResponse('Driver not found');
    }

    $photo_path = $driver["{$photo_type}_photo"];
    $driver_name = $driver['driver_name'];

    // Check if photo file exists
    $full_path = __DIR__ . '/uploads/' . $photo_path;
    
    if (!file_exists($full_path)) {
        // Return default photo info
        sendSuccessResponse([
            'driver_name' => $driver_name,
            'photo_type' => $photo_type,
            'photo_url' => null,
            'message' => 'Photo not found'
        ]);
    }

    // Get file info
    $file_info = pathinfo($full_path);
    $mime_type = mime_content_type($full_path);
    
    // Return photo info
    sendSuccessResponse([
        'driver_name' => $driver_name,
        'photo_type' => $photo_type,
        'photo_url' => 'http://localhost/Driver-App/uploads/' . $photo_path,
        'file_size' => filesize($full_path),
        'mime_type' => $mime_type,
        'file_name' => $photo_path
    ]);

} catch (PDOException $e) {
    sendErrorResponse('Database error: ' . $e->getMessage());
}
?>
