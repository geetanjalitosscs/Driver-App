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
    // Check if wallet exists for this driver
    $stmt = $pdo->prepare("SELECT * FROM wallet WHERE driver_id = ?");
    $stmt->execute([$driver_id]);
    $wallet = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$wallet) {
        // Create a new wallet for the driver if it doesn't exist
        $stmt = $pdo->prepare("INSERT INTO wallet (driver_id, balance, created_at, updated_at) VALUES (?, 0.00, NOW(), NOW())");
        $stmt->execute([$driver_id]);
        
        // Get the newly created wallet
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
