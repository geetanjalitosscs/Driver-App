<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch(PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

$driverId = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;
$limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 10;

if ($driverId <= 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid driver ID']);
    exit;
}

try {
    $stmt = $pdo->prepare("
        SELECT 
            e.id,
            e.driver_id,
            e.amount,
            e.earning_date,
            e.created_time,
            t.location,
            t.client_name
        FROM earnings e
        LEFT JOIN trips t ON e.driver_id = t.driver_id
        WHERE e.driver_id = ?
        ORDER BY e.created_time DESC
        LIMIT ?
    ");
    
    $stmt->execute([$driverId, $limit]);
    $earnings = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Format the response
    $formattedEarnings = array_map(function($earning) {
        return [
            'earning_id' => (int)$earning['earning_id'],
            'driver_id' => (int)$earning['driver_id'],
            'trip_id' => (int)$earning['trip_id'],
            'amount' => (float)$earning['amount'],
            'earning_date' => $earning['earning_date'],
            'created_at' => $earning['created_at'],
            'start_location' => $earning['start_location'] ?? 'Unknown',
            'end_location' => $earning['end_location'] ?? 'Unknown',
        ];
    }, $earnings);

    echo json_encode([
        'success' => true,
        'earnings' => $formattedEarnings,
        'count' => count($formattedEarnings)
    ]);

} catch(PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Database operation failed: ' . $e->getMessage()]);
}
?>
