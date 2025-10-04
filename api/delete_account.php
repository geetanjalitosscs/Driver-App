<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit();
}

require_once './db_config.php';

// Check if database connection is available
if (!$conn) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Database connection failed']);
    exit();
}

try {
    // Get JSON input
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!$input || !isset($input['driver_id'])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Driver ID is required']);
        exit();
    }
    
    $driver_id = intval($input['driver_id']);
    
    if ($driver_id <= 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Invalid driver ID']);
        exit();
    }
    
    // Start transaction
    $conn->begin_transaction();
    
    try {
        // 1. Delete from trips table
        $stmt = $conn->prepare("DELETE FROM trips WHERE driver_id = ?");
        $stmt->bind_param("i", $driver_id);
        $stmt->execute();
        $trips_deleted = $stmt->affected_rows;
        
        // 2. Delete from earnings table
        $stmt = $conn->prepare("DELETE FROM earnings WHERE driver_id = ?");
        $stmt->bind_param("i", $driver_id);
        $stmt->execute();
        $earnings_deleted = $stmt->affected_rows;
        
        // 3. Delete from wallet_transactions table
        $stmt = $conn->prepare("DELETE FROM wallet_transactions WHERE wallet_id IN (SELECT wallet_id FROM wallet WHERE driver_id = ?)");
        $stmt->bind_param("i", $driver_id);
        $stmt->execute();
        $transactions_deleted = $stmt->affected_rows;
        
        // 4. Delete from withdrawals table
        $stmt = $conn->prepare("DELETE FROM withdrawals WHERE driver_id = ?");
        $stmt->bind_param("i", $driver_id);
        $stmt->execute();
        $withdrawals_deleted = $stmt->affected_rows;
        
        // 5. Delete from wallet table
        $stmt = $conn->prepare("DELETE FROM wallet WHERE driver_id = ?");
        $stmt->bind_param("i", $driver_id);
        $stmt->execute();
        $wallet_deleted = $stmt->affected_rows;
        
        // 6. Update accidents table (set driver_status to available for any assigned accidents)
        $stmt = $conn->prepare("UPDATE accidents SET driver_status = 'available', driver_details = NULL, accepted_at = NULL, completed_at = NULL, completion_confirmed = FALSE WHERE driver_details LIKE ?");
        $driver_pattern = "%driver_id:$driver_id%";
        $stmt->bind_param("s", $driver_pattern);
        $stmt->execute();
        $accidents_updated = $stmt->affected_rows;
        
        // 7. Delete from drivers table (main driver record)
        $stmt = $conn->prepare("DELETE FROM drivers WHERE driver_id = ?");
        $stmt->bind_param("i", $driver_id);
        $stmt->execute();
        $driver_deleted = $stmt->affected_rows;
        
        if ($driver_deleted === 0) {
            throw new Exception("Driver not found or already deleted");
        }
        
        // Commit transaction
        $conn->commit();
        
        // Log the deletion
        error_log("Account deletion completed for driver ID: $driver_id");
        error_log("Deleted: $trips_deleted trips, $earnings_deleted earnings, $transactions_deleted transactions, $withdrawals_deleted withdrawals, $wallet_deleted wallet, $accidents_updated accidents updated");
        
        echo json_encode([
            'success' => true,
            'message' => 'Account deleted successfully',
            'deleted_records' => [
                'trips' => $trips_deleted,
                'earnings' => $earnings_deleted,
                'transactions' => $transactions_deleted,
                'withdrawals' => $withdrawals_deleted,
                'wallet' => $wallet_deleted,
                'accidents_updated' => $accidents_updated,
                'driver' => $driver_deleted
            ]
        ]);
        
    } catch (Exception $e) {
        // Rollback transaction on error
        $conn->rollback();
        throw $e;
    }
    
} catch (Exception $e) {
    error_log("Account deletion error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Account deletion failed: ' . $e->getMessage()
    ]);
}

$conn->close();
?>
