<?php
require_once 'db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get driver ID and filters from query parameters
$driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;
$period = isset($_GET['period']) ? $_GET['period'] : 'all';
$status = isset($_GET['status']) ? $_GET['status'] : 'all';

if ($driver_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid driver ID']);
    exit;
}

try {
    // Build date condition based on period
    $dateCondition = '';
    switch ($period) {
        case 'all':
            $dateCondition = "1=1"; // Show all records
            break;
        case 'today':
            $dateCondition = "DATE(requested_at) = CURDATE()";
            break;
        case 'week':
            $dateCondition = "requested_at >= DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)";
            break;
        case 'month':
            $dateCondition = "MONTH(requested_at) = MONTH(CURDATE()) AND YEAR(requested_at) = YEAR(CURDATE())";
            break;
        case 'year':
            $dateCondition = "YEAR(requested_at) = YEAR(CURDATE())";
            break;
        default:
            $dateCondition = "1=1"; // Default to all records
    }

    // Build status condition
    $statusCondition = '';
    if ($status !== 'all') {
        $statusCondition = " AND status = '" . $status . "'";
    }

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
            notes
        FROM withdrawals 
        WHERE driver_id = ? AND $dateCondition $statusCondition
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
            'notes' => $withdrawal['notes']
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
