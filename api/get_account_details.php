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
    // Get driver's account details from separate columns
    $stmt = $pdo->prepare("
        SELECT 
            account_number,
            bank_name,
            ifsc_code,
            account_holder_name
        FROM drivers 
        WHERE id = ?
    ");
    $stmt->execute([$driver_id]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$driver) {
        echo json_encode(['success' => false, 'message' => 'Driver not found']);
        exit;
    }

    // Check if account details exist (any of the fields is not null/empty)
    $has_account_details = !empty($driver['account_number']) || 
                          !empty($driver['bank_name']) || 
                          !empty($driver['ifsc_code']) || 
                          !empty($driver['account_holder_name']);

    $account_details = null;
    if ($has_account_details) {
        $account_details = [
            'account_number' => $driver['account_number'] ?? '',
            'bank_name' => $driver['bank_name'] ?? '',
            'ifsc_code' => $driver['ifsc_code'] ?? '',
            'account_holder_name' => $driver['account_holder_name'] ?? '',
        ];
    }

    echo json_encode([
        'success' => true,
        'account_details' => $account_details,
        'has_account_details' => $has_account_details
    ]);

} catch (PDOException $e) {
    error_log("Error fetching account details: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error occurred']);
}
?>
