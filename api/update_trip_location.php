<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

// Database configuration
$host = '127.0.0.1';
$dbname = 'edueyeco_apatkal';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input) {
    echo json_encode(['success' => false, 'error' => 'Invalid JSON input']);
    exit;
}

$latitude = isset($input['latitude']) ? (float)$input['latitude'] : 0;
$longitude = isset($input['longitude']) ? (float)$input['longitude'] : 0;
$timestamp = isset($input['timestamp']) ? $input['timestamp'] : date('Y-m-d H:i:s');
$accuracy = isset($input['accuracy']) ? (float)$input['accuracy'] : 0;
$speed = isset($input['speed']) ? (float)$input['speed'] : 0;
$trip_id = isset($input['trip_id']) ? (int)$input['trip_id'] : 0;

if ($latitude == 0 || $longitude == 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid coordinates']);
    exit;
}

try {
    // Start transaction
    $pdo->beginTransaction();
    
    if ($trip_id > 0) {
        // Update specific trip location
        $stmt = $pdo->prepare("
            UPDATE trips 
            SET 
                current_latitude = ?,
                current_longitude = ?,
                last_location_update = ?
            WHERE trip_id = ? AND status = 'ongoing'
        ");
        
        $stmt->execute([$latitude, $longitude, $timestamp, $trip_id]);
        
        if ($stmt->rowCount() == 0) {
            $pdo->rollBack();
            echo json_encode(['success' => false, 'error' => 'Trip not found or not ongoing']);
            exit;
        }
    }
    
    // Log location update
    $stmt = $pdo->prepare("
        INSERT INTO location_updates (
            trip_id,
            latitude,
            longitude,
            accuracy,
            speed,
            timestamp,
            created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
    ");
    
    $stmt->execute([
        $trip_id,
        $latitude,
        $longitude,
        $accuracy,
        $speed,
        $timestamp,
        date('Y-m-d H:i:s')
    ]);
    
    // Commit transaction
    $pdo->commit();
    
    echo json_encode([
        'success' => true,
        'message' => 'Location updated successfully',
        'timestamp' => $timestamp
    ]);
    
} catch(PDOException $e) {
    $pdo->rollBack();
    echo json_encode(['success' => false, 'error' => 'Database operation failed: ' . $e->getMessage()]);
}
?>
