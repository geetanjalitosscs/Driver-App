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

$trip_id = isset($input['trip_id']) ? (int)$input['trip_id'] : 0;
$driver_id = isset($input['driver_id']) ? (int)$input['driver_id'] : 0;
$start_time = isset($input['start_time']) ? $input['start_time'] : date('Y-m-d H:i:s');

if ($trip_id <= 0 || $driver_id <= 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid trip ID or driver ID']);
    exit;
}

try {
    // Start transaction
    $pdo->beginTransaction();
    
    // Update trip status to ongoing and set start time
    $stmt = $pdo->prepare("
        UPDATE trips 
        SET status = 'ongoing', start_time = ? 
        WHERE trip_id = ? AND driver_id = ? AND status = 'pending'
    ");
    
    $result = $stmt->execute([$start_time, $trip_id, $driver_id]);
    
    if ($stmt->rowCount() == 0) {
        $pdo->rollBack();
        echo json_encode(['success' => false, 'error' => 'Trip not found or already processed']);
        exit;
    }
    
    // Commit transaction
    $pdo->commit();
    
    echo json_encode([
        'success' => true, 
        'message' => 'Trip accepted successfully',
        'trip_id' => $trip_id,
        'status' => 'ongoing'
    ]);
    
} catch(PDOException $e) {
    $pdo->rollBack();
    echo json_encode(['success' => false, 'error' => 'Database operation failed: ' . $e->getMessage()]);
}
?>
