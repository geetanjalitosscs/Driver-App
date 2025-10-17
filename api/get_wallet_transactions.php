<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
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

// Check driver status before proceeding
checkDriverStatus($driver_id);

try {
    // Get wallet transactions (earnings, payments, withdrawals, etc.)
    // This combines data from earnings, payments, and withdrawals tables
    $stmt = $pdo->prepare("
        SELECT 
            'earning' as transaction_type,
            earning_id as transaction_id,
            driver_id,
            amount,
            earning_date as transaction_date,
            'Trip Payment' as description,
            'credit' as type,
            created_at
        FROM earnings 
        WHERE driver_id = ?
        
        UNION ALL
        
        SELECT 
            'payment' as transaction_type,
            payment_id as transaction_id,
            driver_id,
            amount,
            payment_date as transaction_date,
            CONCAT('Payment - ', payment_method) as description,
            'credit' as type,
            created_at
        FROM payments 
        WHERE driver_id = ?
        
        UNION ALL
        
        SELECT 
            'withdrawal' as transaction_type,
            withdrawal_id as transaction_id,
            driver_id,
            amount,
            requested_at as transaction_date,
            CONCAT('Withdrawal - ', bank_name, ' (', status, ')') as description,
            'debit' as type,
            created_at
        FROM withdrawals 
        WHERE driver_id = ?
        
        ORDER BY transaction_date DESC, created_at DESC
        LIMIT 50
    ");
    $stmt->execute([$driver_id, $driver_id, $driver_id]);
    $transactions = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Format the transactions data
    $formatted_transactions = [];
    foreach ($transactions as $transaction) {
        $formatted_transactions[] = [
            'transaction_type' => $transaction['transaction_type'],
            'transaction_id' => (int)$transaction['transaction_id'],
            'driver_id' => (int)$transaction['driver_id'],
            'amount' => (float)$transaction['amount'],
            'description' => $transaction['description'],
            'type' => $transaction['type'],
            'transaction_date' => $transaction['transaction_date'],
            'created_at' => $transaction['created_at']
        ];
    }

    echo json_encode([
        'success' => true,
        'transactions' => $formatted_transactions,
        'count' => count($formatted_transactions)
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
