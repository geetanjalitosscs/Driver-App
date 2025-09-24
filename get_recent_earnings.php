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
$limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 10;

if ($driverId <= 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid driver ID']);
    exit;
}

try {
    $stmt = $pdo->prepare("
        SELECT 
            e.earning_id,
            e.driver_id,
            e.trip_id,
            e.amount,
            e.earning_date,
            e.created_at,
            t.start_location,
            t.end_location
        FROM earnings e
        LEFT JOIN trips t ON e.trip_id = t.trip_id
        WHERE e.driver_id = ?
        ORDER BY e.created_at DESC
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
