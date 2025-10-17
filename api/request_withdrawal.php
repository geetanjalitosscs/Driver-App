<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input) {
    echo json_encode(['success' => false, 'message' => 'Invalid JSON input']);
    exit;
}

// Validate required fields
$required_fields = ['driver_id', 'amount', 'bank_account_number', 'bank_name', 'ifsc_code', 'account_holder_name'];
foreach ($required_fields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        echo json_encode(['success' => false, 'message' => "Missing required field: $field"]);
        exit;
    }
}

// Check driver status before proceeding
checkDriverStatus($input['driver_id']);

$driver_id = (int)$input['driver_id'];
$amount = (float)$input['amount'];
$bank_account_number = trim($input['bank_account_number']);
$bank_name = trim($input['bank_name']);
$ifsc_code = trim($input['ifsc_code']);
$account_holder_name = trim($input['account_holder_name']);

// Validate input
if ($driver_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid driver ID']);
    exit;
}

if ($amount <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid withdrawal amount']);
    exit;
}

if ($amount < 100) {
    echo json_encode(['success' => false, 'message' => 'Minimum withdrawal amount is ₹100']);
    exit;
}

if (!preg_match('/^[A-Z]{4}0[A-Z0-9]{6}$/', $ifsc_code)) {
    echo json_encode(['success' => false, 'message' => 'Invalid IFSC code format']);
    exit;
}

try {
    // Start transaction
    $pdo->beginTransaction();

    // Check wallet balance
    $stmt = $pdo->prepare("SELECT balance FROM wallet WHERE driver_id = ?");
    $stmt->execute([$driver_id]);
    $wallet = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$wallet) {
        echo json_encode(['success' => false, 'message' => 'Wallet not found']);
        exit;
    }

    $current_balance = (float)$wallet['balance'];
    if ($current_balance < $amount) {
        echo json_encode(['success' => false, 'message' => 'Insufficient balance']);
        exit;
    }

    // No need to check for pending withdrawals since we process immediately

    // Create withdrawal request (auto-approved)
    $stmt = $pdo->prepare("
        INSERT INTO withdrawals (
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
        ) VALUES (?, ?, ?, ?, ?, ?, 'completed', NOW(), NOW(), NOW())
    ");
    
    $stmt->execute([
        $driver_id,
        $amount,
        $bank_account_number,
        $bank_name,
        $ifsc_code,
        $account_holder_name
    ]);

    $withdrawal_id = $pdo->lastInsertId();

    // Update wallet balance (subtract the withdrawal amount)
    $new_balance = $current_balance - $amount;
    $stmt = $pdo->prepare("UPDATE wallet SET balance = ?, updated_at = NOW() WHERE driver_id = ?");
    $stmt->execute([$new_balance, $driver_id]);

    // Add a transaction record for the withdrawal (using withdrawals table)
    // Note: This creates a transaction record in the same withdrawals table
    // If you have a separate transactions table, please let me know the correct table name

    // Commit transaction
    $pdo->commit();

    echo json_encode([
        'success' => true,
        'message' => 'Withdrawal completed successfully',
        'withdrawal_id' => $withdrawal_id,
        'new_balance' => (float)$new_balance,
        'status' => 'completed'
    ]);

} catch (PDOException $e) {
    $pdo->rollBack();
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
} catch (Exception $e) {
    $pdo->rollBack();
    echo json_encode([
        'success' => false,
        'message' => 'Error: ' . $e->getMessage()
    ]);
}
?>
