<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch(PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

$driverId = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;
$period = isset($_GET['period']) ? $_GET['period'] : 'all';
$tripId = isset($_GET['trip_id']) ? $_GET['trip_id'] : 'all';

if ($driverId <= 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid driver ID']);
    exit;
}

try {
    // Build date condition based on period
    $dateCondition = '';
    switch ($period) {
        case 'all':
            $dateCondition = "1=1"; // Show all records
            break;
        case 'today':
            $dateCondition = "DATE(earning_date) = CURDATE()";
            break;
        case 'week':
            $dateCondition = "earning_date >= DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)";
            break;
        case 'month':
            $dateCondition = "MONTH(earning_date) = MONTH(CURDATE()) AND YEAR(earning_date) = YEAR(CURDATE())";
            break;
        case 'year':
            $dateCondition = "YEAR(earning_date) = YEAR(CURDATE())";
            break;
        default:
            $dateCondition = "1=1"; // Default to all records
    }

    // Build trip condition
    $tripCondition = '';
    if ($tripId !== 'all') {
        $tripCondition = " AND trip_id = " . (int)$tripId;
    }

    $stmt = $pdo->prepare("
        SELECT 
            e.id,
            e.driver_id,
            e.trip_id,
            e.amount,
            e.earning_date,
            e.created_time,
            t.end_time as trip_completion_time
        FROM earnings e
        LEFT JOIN trips t ON e.trip_id = t.history_id
        WHERE e.driver_id = ? AND $dateCondition $tripCondition
        ORDER BY COALESCE(t.end_time, e.created_time) DESC
    ");
    
    $stmt->execute([$driverId]);
    $earnings = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Format the response
    $formattedEarnings = array_map(function($earning) {
        return [
            'id' => (int)$earning['id'],
            'driver_id' => (int)$earning['driver_id'],
            'trip_id' => (int)$earning['trip_id'],
            'amount' => (float)$earning['amount'],
            'earning_date' => $earning['earning_date'],
            'created_time' => $earning['created_time'],
            'trip_completion_time' => $earning['trip_completion_time'],
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
