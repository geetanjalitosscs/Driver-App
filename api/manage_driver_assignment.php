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
$required_fields = ['action', 'accident_id'];
foreach ($required_fields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        echo json_encode(['success' => false, 'message' => "Missing required field: $field"]);
        exit;
    }
}

$action = $input['action'];
$accident_id = (int)$input['accident_id'];

if ($accident_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid accident ID']);
    exit;
}

try {
    // Get accident details first
    $stmt = $pdo->prepare("
        SELECT id, latitude, longitude, created_at, status, driver_status, driver_details
        FROM accidents 
        WHERE id = ?
    ");
    $stmt->execute([$accident_id]);
    $accident = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$accident) {
        echo json_encode(['success' => false, 'message' => 'Accident not found']);
        exit;
    }
    
    if ($action === 'assign_driver') {
        // Assign driver to accident
        $driver_id = isset($input['driver_id']) ? (int)$input['driver_id'] : 0;
        $vehicle_number = isset($input['vehicle_number']) ? trim($input['vehicle_number']) : '';
        
        if ($driver_id <= 0) {
            echo json_encode(['success' => false, 'message' => 'Invalid driver ID']);
            exit;
        }
        
        // Get driver details
        $driverStmt = $pdo->prepare("SELECT driver_name FROM drivers WHERE id = ?");
        $driverStmt->execute([$driver_id]);
        $driver = $driverStmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$driver) {
            echo json_encode(['success' => false, 'message' => 'Driver not found']);
            exit;
        }
        
        $driver_name = $driver['driver_name'];
        $driver_details = "Driver: " . $driver_name . " | Vehicle: " . $vehicle_number;
        
        // Update accident - assign driver
        $updateStmt = $pdo->prepare("UPDATE accidents SET 
            driver_details = ?, 
            driver_status = 'assigned',
            status = 'investigating',
            accepted_at = NOW()
            WHERE id = ? AND status = 'pending'");
        
        if ($updateStmt->execute([$driver_details, $accident_id])) {
            $affected_rows = $updateStmt->rowCount();
            if ($affected_rows > 0) {
                error_log("Driver $driver_id assigned to accident $accident_id");
                echo json_encode([
                    'success' => true, 
                    'message' => 'Driver assigned successfully',
                    'data' => [
                        'accident_id' => $accident_id,
                        'driver_id' => $driver_id,
                        'driver_name' => $driver_name,
                        'vehicle_number' => $vehicle_number,
                        'assigned_at' => date('Y-m-d H:i:s')
                    ]
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'No rows updated - accident may not be in pending status']);
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to assign driver']);
        }
        
    } elseif ($action === 'reject_assignment') {
        // Driver rejects the assignment - reset to pending for next driver
        $driver_id = isset($input['driver_id']) ? (int)$input['driver_id'] : 0;
        $reason = isset($input['reason']) ? trim($input['reason']) : 'No reason provided';
        
        // Log the rejection
        error_log("Driver $driver_id rejected accident $accident_id. Reason: $reason");
        
        // Reset accident to pending status for next driver assignment
        $updateStmt = $pdo->prepare("UPDATE accidents SET 
            driver_status = NULL,
            driver_details = NULL,
            accepted_at = NULL,
            status = 'pending'
            WHERE id = ? AND status = 'investigating'");
        
        if ($updateStmt->execute([$accident_id])) {
            $affected_rows = $updateStmt->rowCount();
            if ($affected_rows > 0) {
                echo json_encode([
                    'success' => true, 
                    'message' => 'Assignment rejected successfully. Accident is now available for other drivers.',
                    'data' => [
                        'accident_id' => $accident_id,
                        'driver_id' => $driver_id,
                        'rejection_reason' => $reason,
                        'rejected_at' => date('Y-m-d H:i:s')
                    ]
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'No rows updated - accident may not be in investigating status']);
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to reject assignment']);
        }
        
    } elseif ($action === 'cancel_assignment') {
        // Cancel assignment (similar to reject but different context)
        $driver_id = isset($input['driver_id']) ? (int)$input['driver_id'] : 0;
        $reason = isset($input['reason']) ? trim($input['reason']) : 'Assignment cancelled';
        
        // Log the cancellation
        error_log("Assignment cancelled for accident $accident_id by driver $driver_id. Reason: $reason");
        
        // Reset accident to pending status
        $updateStmt = $pdo->prepare("UPDATE accidents SET 
            driver_status = NULL,
            driver_details = NULL,
            accepted_at = NULL,
            completed_at = NULL,
            completion_confirmed = FALSE,
            status = 'pending'
            WHERE id = ?");
        
        if ($updateStmt->execute([$accident_id])) {
            $affected_rows = $updateStmt->rowCount();
            if ($affected_rows > 0) {
                echo json_encode([
                    'success' => true, 
                    'message' => 'Assignment cancelled successfully. Accident is now available for other drivers.',
                    'data' => [
                        'accident_id' => $accident_id,
                        'driver_id' => $driver_id,
                        'cancellation_reason' => $reason,
                        'cancelled_at' => date('Y-m-d H:i:s')
                    ]
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'No rows updated - accident may not exist']);
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to cancel assignment']);
        }
        
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid action. Supported actions: assign_driver, reject_assignment, cancel_assignment']);
    }

} catch (PDOException $e) {
    error_log("Error in driver assignment: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error occurred']);
}
?>
