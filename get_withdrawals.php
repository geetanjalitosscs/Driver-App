<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

// Database configuration
$host = 'localhost';
$dbname = 'edueyeco_apatkal';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed']);
    exit;
}

// Get driver ID from query parameters
$driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;

if ($driver_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid driver ID']);
    exit;
}

try {
    // Get withdrawals for the driver, ordered by most recent first
    $stmt = $pdo->prepare("
        SELECT 
            withdrawal_id,
            driver_id,
            amount,
            bank_account_number,
            bank_name,
            ifsc_code,
            account_holder_name,
            status,
            requested_at,
            processed_at,
            created_at
        FROM withdrawals 
        WHERE driver_id = ? 
        ORDER BY requested_at DESC
    ");
    $stmt->execute([$driver_id]);
    $withdrawals = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Format the withdrawals data
    $formatted_withdrawals = [];
    foreach ($withdrawals as $withdrawal) {
        $formatted_withdrawals[] = [
            'withdrawal_id' => (int)$withdrawal['withdrawal_id'],
            'driver_id' => (int)$withdrawal['driver_id'],
            'amount' => (float)$withdrawal['amount'],
            'bank_account_number' => $withdrawal['bank_account_number'],
            'bank_name' => $withdrawal['bank_name'],
            'ifsc_code' => $withdrawal['ifsc_code'],
            'account_holder_name' => $withdrawal['account_holder_name'],
            'status' => $withdrawal['status'],
            'requested_at' => $withdrawal['requested_at'],
            'processed_at' => $withdrawal['processed_at'],
            'created_at' => $withdrawal['created_at']
        ];
    }

    echo json_encode([
        'success' => true,
        'withdrawals' => $formatted_withdrawals,
        'count' => count($formatted_withdrawals)
    ]);

} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Error: ' . $e->getMessage()
    ]);
}
?>
