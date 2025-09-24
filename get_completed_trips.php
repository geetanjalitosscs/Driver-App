<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Database configuration
$host = '127.0.0.1';
$dbname = 'apatkal_driver_app';
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
    // Fetch completed trips for the driver
    $stmt = $pdo->prepare("
        SELECT 
            trip_id,
            driver_id,
            user_id,
            start_location,
            end_location,
            start_time,
            end_time,
            distance_km,
            fare_amount,
            status,
            verified,
            created_at
        FROM trips 
        WHERE driver_id = ? AND status = 'completed'
        ORDER BY created_at DESC
    ");
    
    $stmt->execute([$driver_id]);
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Convert data types
    foreach ($trips as &$trip) {
        $trip['trip_id'] = (int)$trip['trip_id'];
        $trip['driver_id'] = (int)$trip['driver_id'];
        $trip['user_id'] = (int)$trip['user_id'];
        $trip['distance_km'] = $trip['distance_km'] ? (float)$trip['distance_km'] : null;
        $trip['fare_amount'] = (float)$trip['fare_amount'];
        $trip['verified'] = (bool)$trip['verified'];
    }
    
    echo json_encode($trips);
    
} catch(PDOException $e) {
    echo json_encode(['error' => 'Database query failed: ' . $e->getMessage()]);
}
?>
