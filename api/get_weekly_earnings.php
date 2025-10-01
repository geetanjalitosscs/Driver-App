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

if ($driverId <= 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid driver ID']);
    exit;
}

try {
    // Get earnings for the current week (Monday to Sunday)
    $stmt = $pdo->prepare("
        SELECT 
            DAYNAME(earning_date) as day_name,
            DAYOFWEEK(earning_date) as day_number,
            DATE(earning_date) as date,
            COALESCE(SUM(amount), 0) as amount,
            COUNT(earning_id) as trip_count
        FROM earnings 
        WHERE driver_id = ? 
        AND earning_date >= DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)
        AND earning_date <= DATE_ADD(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 6 DAY)
        GROUP BY DATE(earning_date), DAYNAME(earning_date), DAYOFWEEK(earning_date)
        ORDER BY DAYOFWEEK(earning_date)
    ");
    
    $stmt->execute([$driverId]);
    $weeklyData = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Create a complete week array with all days
    $days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    $dayNumbers = [2, 3, 4, 5, 6, 7, 1]; // MySQL DAYOFWEEK numbers
    $completeWeek = [];

    foreach ($dayNumbers as $index => $dayNum) {
        $dayName = $days[$index];
        $found = false;
        
        foreach ($weeklyData as $data) {
            if ($data['day_number'] == $dayNum) {
                $completeWeek[] = [
                    'day_name' => $dayName,
                    'day_short' => substr($dayName, 0, 3),
                    'day_number' => $dayNum,
                    'amount' => (float)$data['amount'],
                    'trip_count' => (int)$data['trip_count'],
                    'date' => $data['date']
                ];
                $found = true;
                break;
            }
        }
        
        if (!$found) {
            $completeWeek[] = [
                'day_name' => $dayName,
                'day_short' => substr($dayName, 0, 3),
                'day_number' => $dayNum,
                'amount' => 0.0,
                'trip_count' => 0,
                'date' => null
            ];
        }
    }

    echo json_encode([
        'success' => true,
        'weekly_data' => $completeWeek,
        'week_total' => array_sum(array_column($completeWeek, 'amount'))
    ]);

} catch(PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Database operation failed: ' . $e->getMessage()]);
}
?>
