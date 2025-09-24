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
$dbname = 'apatkal_driver_app';
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
            $dateCondition = "DATE(e.earning_date) = CURDATE()";
            break;
        case 'week':
            $dateCondition = "e.earning_date >= DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)";
            break;
        case 'month':
            $dateCondition = "MONTH(e.earning_date) = MONTH(CURDATE()) AND YEAR(e.earning_date) = YEAR(CURDATE())";
            break;
        case 'year':
            $dateCondition = "YEAR(e.earning_date) = YEAR(CURDATE())";
            break;
        default:
            $dateCondition = "DATE(e.earning_date) = CURDATE()";
    }

    // Get earnings summary
    $stmt = $pdo->prepare("
        SELECT 
            COALESCE(SUM(e.amount), 0) as total_earnings,
            COUNT(e.earning_id) as total_trips,
            COALESCE(AVG(e.amount), 0) as average_per_trip
        FROM earnings e
        WHERE e.driver_id = ? AND $dateCondition
    ");
    
    $stmt->execute([$driverId]);
    $summary = $stmt->fetch(PDO::FETCH_ASSOC);

    // Calculate total hours worked (assuming 1 hour per trip for simplicity)
    // You can modify this based on your actual trip duration data
    $totalHours = $summary['total_trips'] * 1.0; // Default 1 hour per trip

    echo json_encode([
        'success' => true,
        'total_earnings' => (float)$summary['total_earnings'],
        'total_trips' => (int)$summary['total_trips'],
        'average_per_trip' => (float)$summary['average_per_trip'],
        'total_hours' => $totalHours,
        'period' => $period
    ]);

} catch(PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Database operation failed: ' . $e->getMessage()]);
}
?>
