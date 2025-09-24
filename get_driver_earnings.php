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

$driverId = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;
$period = isset($_GET['period']) ? $_GET['period'] : 'today';

if ($driverId <= 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid driver ID']);
    exit;
}

try {
    // Build date condition based on period
    $dateCondition = '';
    switch ($period) {
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
            $dateCondition = "DATE(earning_date) = CURDATE()";
    }

    $stmt = $pdo->prepare("
        SELECT 
            earning_id,
            driver_id,
            trip_id,
            amount,
            earning_date,
            created_at
        FROM earnings 
        WHERE driver_id = ? AND $dateCondition
        ORDER BY earning_date DESC, created_at DESC
    ");
    
    $stmt->execute([$driverId]);
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
