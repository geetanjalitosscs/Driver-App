<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Database configuration
$host = '127.0.0.1';
$dbname = 'edueyeco_apatkal';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

// Get driver ID from query parameter
$driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;

if ($driver_id <= 0) {
    echo json_encode(['error' => 'Invalid driver ID']);
    exit;
}

try {
    // Fetch all trips for the driver
    $stmt = $pdo->prepare("
        SELECT 
            history_id,
            driver_id,
            client_name,
            location,
            timing,
            amount,
            duration,
            start_time,
            end_time,
            created_at
        FROM trips 
        WHERE driver_id = ? 
        ORDER BY created_at DESC
    ");
    
    $stmt->execute([$driver_id]);
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Convert data types
    foreach ($trips as &$trip) {
        $trip['history_id'] = (int)$trip['history_id'];
        $trip['driver_id'] = (int)$trip['driver_id'];
        $trip['amount'] = (float)$trip['amount'];
        $trip['duration'] = (int)$trip['duration'];
    }
    
    echo json_encode($trips);
    
} catch(PDOException $e) {
    echo json_encode(['error' => 'Database query failed: ' . $e->getMessage()]);
}
?>
