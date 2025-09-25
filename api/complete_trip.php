<?php
require_once '../db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
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
$end_latitude = isset($input['end_latitude']) ? (float)$input['end_latitude'] : 0;
$end_longitude = isset($input['end_longitude']) ? (float)$input['end_longitude'] : 0;
$end_location = isset($input['end_location']) ? $input['end_location'] : '';
$end_time = isset($input['end_time']) ? $input['end_time'] : date('Y-m-d H:i:s');

if ($trip_id <= 0 || $driver_id <= 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid trip ID or driver ID']);
    exit;
}

try {
    // Start transaction
    $pdo->beginTransaction();
    
    // Get trip details for validation
    $stmt = $pdo->prepare("
        SELECT start_time, start_location, fare_amount 
        FROM trips 
        WHERE trip_id = ? AND driver_id = ? AND status = 'ongoing'
    ");
    
    $stmt->execute([$trip_id, $driver_id]);
    $trip = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$trip) {
        $pdo->rollBack();
        echo json_encode(['success' => false, 'error' => 'Trip not found or not in ongoing status']);
        exit;
    }
    
    // Calculate trip duration
    $start_time = new DateTime($trip['start_time']);
    $end_time_obj = new DateTime($end_time);
    $duration = $end_time_obj->diff($start_time);
    $duration_minutes = $duration->i + ($duration->h * 60);
    
    // Basic validation rules
    $validation_errors = [];
    
    // Check minimum trip duration (5 minutes)
    if ($duration_minutes < 5) {
        $validation_errors[] = 'Trip duration too short (minimum 5 minutes required)';
    }
    
    // Check if end location is provided
    if (empty($end_location)) {
        $validation_errors[] = 'End location is required';
    }
    
    // Check if GPS coordinates are valid
    if ($end_latitude == 0 || $end_longitude == 0) {
        $validation_errors[] = 'Valid GPS coordinates are required';
    }
    
    if (!empty($validation_errors)) {
        $pdo->rollBack();
        echo json_encode([
            'success' => false, 
            'error' => 'Trip completion validation failed',
            'validation_errors' => $validation_errors
        ]);
        exit;
    }
    
    // Update trip status to completed
    $stmt = $pdo->prepare("
        UPDATE trips 
        SET status = 'completed', 
            end_time = ?, 
            end_location = ?
        WHERE trip_id = ? AND driver_id = ?
    ");
    
    $stmt->execute([$end_time, $end_location, $trip_id, $driver_id]);
    
    // Create earning record
    $stmt = $pdo->prepare("
        INSERT INTO earnings (driver_id, trip_id, amount, earning_date, created_at) 
        VALUES (?, ?, ?, ?, ?)
    ");
    
    $earning_date = date('Y-m-d');
    $stmt->execute([$driver_id, $trip_id, $trip['fare_amount'], $earning_date, $end_time]);
    
    // Update wallet balance
    $stmt = $pdo->prepare("
        INSERT INTO wallet (driver_id, balance, updated_at) 
        VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE 
        balance = balance + VALUES(balance),
        updated_at = VALUES(updated_at)
    ");
    
    $stmt->execute([$driver_id, $trip['fare_amount'], $end_time]);
    
    // Commit transaction
    $pdo->commit();
    
    echo json_encode([
        'success' => true, 
        'message' => 'Trip completed successfully',
        'trip_id' => $trip_id,
        'status' => 'completed',
        'fare_amount' => $trip['fare_amount'],
        'duration_minutes' => $duration_minutes
    ]);
    
} catch(PDOException $e) {
    $pdo->rollBack();
    echo json_encode(['success' => false, 'error' => 'Database operation failed: ' . $e->getMessage()]);
}
?>
