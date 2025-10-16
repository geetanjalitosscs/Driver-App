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
$required_fields = ['driver_id', 'account_number', 'bank_name', 'ifsc_code', 'account_holder_name'];
foreach ($required_fields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        echo json_encode(['success' => false, 'message' => "Missing required field: $field"]);
        exit;
    }
}

$driver_id = (int)$input['driver_id'];
$account_number = trim($input['account_number']);
$bank_name = trim($input['bank_name']);
$ifsc_code = trim($input['ifsc_code']);
$account_holder_name = trim($input['account_holder_name']);

// Validate input
if ($driver_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid driver ID']);
    exit;
}

if (!preg_match('/^[A-Z]{4}0[A-Z0-9]{6}$/', $ifsc_code)) {
    echo json_encode(['success' => false, 'message' => 'Invalid IFSC code format']);
    exit;
}

if (strlen($account_number) < 9 || strlen($account_number) > 20) {
    echo json_encode(['success' => false, 'message' => 'Account number must be 9-20 digits']);
    exit;
}

try {
    // Check if driver exists
    $stmt = $pdo->prepare("SELECT id FROM drivers WHERE id = ?");
    $stmt->execute([$driver_id]);
    if (!$stmt->fetch()) {
        echo json_encode(['success' => false, 'message' => 'Driver not found']);
        exit;
    }

    // Update driver's account details in separate columns
    $stmt = $pdo->prepare("
        UPDATE drivers 
        SET 
            account_number = ?,
            bank_name = ?,
            ifsc_code = ?,
            account_holder_name = ?,
            updated_at = NOW()
        WHERE id = ?
    ");
    $stmt->execute([
        $account_number,
        $bank_name,
        $ifsc_code,
        $account_holder_name,
        $driver_id
    ]);

    echo json_encode([
        'success' => true,
        'message' => 'Account details saved successfully',
        'account_details' => [
            'account_number' => $account_number,
            'bank_name' => $bank_name,
            'ifsc_code' => $ifsc_code,
            'account_holder_name' => $account_holder_name,
        ]
    ]);

} catch (PDOException $e) {
    error_log("Error saving account details: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error occurred']);
}
?>
