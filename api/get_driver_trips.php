<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch(PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get driver ID from query parameter
$driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;

if ($driver_id <= 0) {
    echo json_encode(['error' => 'Invalid driver ID']);
    exit;
}

// Check driver status before proceeding
checkDriverStatus($driver_id);

try {
    // Fetch all trips for the driver
    $stmt = $pdo->prepare("
        SELECT 
            history_id,
            driver_id,
            client_name,
            location,
            timing,
            duration,
            start_time,
            end_time,
            start_latitude,
            start_longitude,
            end_latitude,
            end_longitude,
            created_at
        FROM trips 
        WHERE driver_id = ? 
        ORDER BY 
            CASE 
                WHEN end_time IS NOT NULL THEN end_time
                WHEN start_time IS NOT NULL THEN start_time
                WHEN timing IS NOT NULL THEN timing
                ELSE created_at
            END DESC
    ");
    
    $stmt->execute([$driver_id]);
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Convert data types
    foreach ($trips as &$trip) {
        $trip['history_id'] = (int)$trip['history_id'];
        $trip['driver_id'] = (int)$trip['driver_id'];
        $trip['duration'] = (int)$trip['duration'];
    }
    
    echo json_encode($trips);
    
} catch(PDOException $e) {
    echo json_encode(['error' => 'Database query failed: ' . $e->getMessage()]);
}
?>
