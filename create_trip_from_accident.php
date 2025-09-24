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

$driver_id = isset($input['driver_id']) ? (int)$input['driver_id'] : 0;
$accident_id = isset($input['accident_id']) ? (int)$input['accident_id'] : 0;
$start_location = isset($input['start_location']) ? $input['start_location'] : '';
$end_location = isset($input['end_location']) ? $input['end_location'] : '';
$fare_amount = isset($input['fare_amount']) ? (float)$input['fare_amount'] : 500.0;

if ($driver_id <= 0 || $accident_id <= 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid driver ID or accident ID']);
    exit;
}

try {
    // Start transaction
    $pdo->beginTransaction();
    
    // Create trip from accident report
    $stmt = $pdo->prepare("
        INSERT INTO trips (
            driver_id, 
            user_id, 
            start_location, 
            end_location, 
            fare_amount, 
            status, 
            start_time, 
            created_at
        ) VALUES (?, ?, ?, ?, ?, 'ongoing', NOW(), NOW())
    ");
    
    $stmt->execute([
        $driver_id,
        1, // Default user ID for accident reports
        $start_location,
        $end_location,
        $fare_amount
    ]);
    
    $trip_id = $pdo->lastInsertId();
    
    // Commit transaction
    $pdo->commit();
    
    echo json_encode([
        'success' => true, 
        'message' => 'Trip created successfully from accident report',
        'trip_id' => $trip_id,
        'status' => 'ongoing'
    ]);
    
} catch(PDOException $e) {
    $pdo->rollBack();
    echo json_encode(['success' => false, 'error' => 'Database operation failed: ' . $e->getMessage()]);
}
?>
