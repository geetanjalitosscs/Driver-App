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

try {
    // Calculate total earnings for this driver
    $stmt = $pdo->prepare("SELECT COALESCE(SUM(amount), 0) as total_earnings FROM earnings WHERE driver_id = ?");
    $stmt->execute([$driver_id]);
    $totalEarnings = $stmt->fetch(PDO::FETCH_ASSOC)['total_earnings'];

    // Calculate total withdrawals for this driver
    $stmt = $pdo->prepare("SELECT COALESCE(SUM(amount), 0) as total_withdrawals FROM withdrawals WHERE driver_id = ? AND status = 'completed'");
    $stmt->execute([$driver_id]);
    $totalWithdrawals = $stmt->fetch(PDO::FETCH_ASSOC)['total_withdrawals'];

    // Calculate current balance: Total Earnings - Total Withdrawals
    $currentBalance = $totalEarnings - $totalWithdrawals;

    // Check if wallet exists for this driver
    $stmt = $pdo->prepare("SELECT * FROM wallet WHERE driver_id = ?");
    $stmt->execute([$driver_id]);
    $wallet = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$wallet) {
        // Create a new wallet for the driver if it doesn't exist
        $stmt = $pdo->prepare("INSERT INTO wallet (driver_id, balance, total_earned, total_withdrawn, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())");
        $stmt->execute([$driver_id, $currentBalance, $totalEarnings, $totalWithdrawals]);
        
        // Get the newly created wallet
        $stmt = $pdo->prepare("SELECT * FROM wallet WHERE driver_id = ?");
        $stmt->execute([$driver_id]);
        $wallet = $stmt->fetch(PDO::FETCH_ASSOC);
    } else {
        // Update the existing wallet with correct balance
        $stmt = $pdo->prepare("UPDATE wallet SET balance = ?, total_earned = ?, total_withdrawn = ?, updated_at = NOW() WHERE driver_id = ?");
        $stmt->execute([$currentBalance, $totalEarnings, $totalWithdrawals, $driver_id]);
        
        // Get the updated wallet
        $stmt = $pdo->prepare("SELECT * FROM wallet WHERE driver_id = ?");
        $stmt->execute([$driver_id]);
        $wallet = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Format the wallet data
    $wallet_data = [
        'wallet_id' => (int)$wallet['wallet_id'],
        'driver_id' => (int)$wallet['driver_id'],
        'balance' => (float)$wallet['balance'],
        'created_at' => $wallet['created_at'],
        'updated_at' => $wallet['updated_at']
    ];

    echo json_encode([
        'success' => true,
        'wallet' => $wallet_data
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
