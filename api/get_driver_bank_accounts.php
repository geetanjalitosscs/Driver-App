<?php
require_once '../db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch(PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get driver ID from query parameters
$driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;

if ($driver_id <= 0) {
    echo json_encode(['success' => false, 'error' => 'Invalid driver ID']);
    exit;
}

try {
    // Get bank accounts for the driver, ordered by most recent first
    $stmt = $pdo->prepare("
        SELECT DISTINCT
            bank_account_number,
            bank_name,
            ifsc_code,
            account_holder_name,
            MAX(requested_at) as last_used
        FROM withdrawals 
        WHERE driver_id = ? 
        GROUP BY bank_account_number, bank_name, ifsc_code, account_holder_name
        ORDER BY last_used DESC
    ");
    $stmt->execute([$driver_id]);
    $accounts = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Format the accounts data
    $formatted_accounts = [];
    foreach ($accounts as $account) {
        $formatted_accounts[] = [
            'account_number' => $account['bank_account_number'],
            'bank_name' => $account['bank_name'],
            'ifsc_code' => $account['ifsc_code'],
            'account_holder_name' => $account['account_holder_name'],
            'last_used' => $account['last_used'],
            'display_name' => $account['bank_name'] . ' - ****' . substr($account['bank_account_number'], -4),
        ];
    }

    echo json_encode([
        'success' => true,
        'accounts' => $formatted_accounts,
        'count' => count($formatted_accounts)
    ]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Database operation failed: ' . $e->getMessage()]);
}
?>
