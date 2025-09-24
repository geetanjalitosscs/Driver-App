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
$dbname = 'apatkal_driver_app';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed']);
    exit;
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

    // Check for pending withdrawals (limit to 3 pending withdrawals)
    $stmt = $pdo->prepare("SELECT COUNT(*) as pending_count FROM withdrawals WHERE driver_id = ? AND status = 'pending'");
    $stmt->execute([$driver_id]);
    $pending_count = $stmt->fetch(PDO::FETCH_ASSOC)['pending_count'];

    if ($pending_count >= 3) {
        echo json_encode(['success' => false, 'message' => 'You have reached the maximum number of pending withdrawals (3)']);
        exit;
    }

    // Create withdrawal request
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
            created_at
        ) VALUES (?, ?, ?, ?, ?, ?, 'pending', NOW(), NOW())
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

    // Add a transaction record for the withdrawal
    $stmt = $pdo->prepare("
        INSERT INTO wallet_transactions (
            driver_id,
            amount,
            type,
            description,
            reference_id,
            created_at
        ) VALUES (?, ?, 'debit', 'Withdrawal Request', ?, NOW())
    ");
    $stmt->execute([$driver_id, $amount, $withdrawal_id]);

    // Commit transaction
    $pdo->commit();

    echo json_encode([
        'success' => true,
        'message' => 'Withdrawal request submitted successfully',
        'withdrawal_id' => $withdrawal_id,
        'new_balance' => $new_balance
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
