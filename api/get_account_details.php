<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get driver ID from query parameters
$driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;

if ($driver_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid driver ID']);
    exit;
}

try {
    // Get driver's account details
    $stmt = $pdo->prepare("SELECT account_details FROM drivers WHERE id = ?");
    $stmt->execute([$driver_id]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$driver) {
        echo json_encode(['success' => false, 'message' => 'Driver not found']);
        exit;
    }

    $account_details = null;
    if (!empty($driver['account_details'])) {
        $account_details = json_decode($driver['account_details'], true);
    }

    echo json_encode([
        'success' => true,
        'account_details' => $account_details,
        'has_account_details' => !empty($account_details)
    ]);

} catch (PDOException $e) {
    error_log("Error fetching account details: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error occurred']);
}
?>
