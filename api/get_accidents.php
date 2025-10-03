<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
    
    // Handle POST requests for updating accident status
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true);
        
        if (isset($input['action'])) {
            if ($input['action'] === 'accept_accident') {
                // Accept accident
                $accident_id = intval($input['accident_id']);
                $driver_id = intval($input['driver_id']);
                $vehicle_number = trim($input['vehicle_number']);
                
                $driver_details = "Driver ID: " . $driver_id . " | Vehicle: " . $vehicle_number;
                
                // Update accident - driver_status starts as NULL, so we check for NULL or 'available'
                $updateStmt = $pdo->prepare("UPDATE accidents SET 
                    driver_details = ?, 
                    driver_status = 'assigned',
                    accepted_at = NOW()
                    WHERE id = ? AND status = 'pending' AND (driver_status IS NULL OR driver_status = 'available')");
                
                if ($updateStmt->execute([$driver_details, $accident_id])) {
                    $affected_rows = $updateStmt->rowCount();
                    if ($affected_rows > 0) {
                        echo json_encode(['success' => true, 'message' => 'Accident accepted successfully', 'affected_rows' => $affected_rows]);
                    } else {
                        echo json_encode(['success' => false, 'message' => 'No rows updated - accident may not exist or already assigned', 'affected_rows' => $affected_rows]);
                    }
                } else {
                    echo json_encode(['success' => false, 'message' => 'Failed to accept accident - SQL execution failed']);
                }
                exit;
                
            } elseif ($input['action'] === 'complete_accident') {
                // Complete accident
                $accident_id = intval($input['accident_id']);
                $driver_id = intval($input['driver_id']);
                $confirmed = $input['confirmed'] ?? false;
                
                if ($confirmed) {
                    $updateStmt = $pdo->prepare("UPDATE accidents SET 
                        driver_status = 'completed',
                        completed_at = NOW(),
                        completion_confirmed = TRUE,
                        status = 'resolved'
                        WHERE id = ?");
                    
                    if ($updateStmt->execute([$accident_id])) {
                        echo json_encode(['success' => true, 'message' => 'Accident completed successfully']);
                    } else {
                        echo json_encode(['success' => false, 'message' => 'Failed to complete accident']);
                    }
                } else {
                    // Cancel accident - reset all driver-related fields to NULL
                    $cancelStmt = $pdo->prepare("UPDATE accidents SET 
                        driver_status = NULL,
                        driver_details = NULL,
                        accepted_at = NULL,
                        completed_at = NULL,
                        completion_confirmed = FALSE
                        WHERE id = ?");
                    
                    if ($cancelStmt->execute([$accident_id])) {
                        echo json_encode(['success' => true, 'message' => 'Accident cancelled successfully']);
                    } else {
                        echo json_encode(['success' => false, 'message' => 'Failed to cancel accident']);
                    }
                }
                exit;
            }
        }
    }
    
    // First check if driver_status column exists
    $checkColumn = $pdo->prepare("SHOW COLUMNS FROM accidents LIKE 'driver_status'");
    $checkColumn->execute();
    $columnExists = $checkColumn->fetch();
    
    if ($columnExists) {
        // Column exists - use the full query with case-insensitive client filtering and collation fix
        $stmt = $pdo->prepare("
            SELECT a.* FROM accidents a 
            INNER JOIN clients c ON LOWER(a.vehicle) COLLATE utf8mb4_general_ci = LOWER(c.vehicle_no) COLLATE utf8mb4_general_ci
            WHERE a.status = 'pending' 
            AND (a.driver_status IS NULL OR a.driver_status = 'available')
            ORDER BY a.created_at DESC
        ");
        error_log("Using driver_status filter with case-insensitive client matching (collation fixed)");
    } else {
        // Column doesn't exist - use simple query with case-insensitive client filtering and collation fix
        $stmt = $pdo->prepare("
            SELECT a.* FROM accidents a 
            INNER JOIN clients c ON LOWER(a.vehicle) COLLATE utf8mb4_general_ci = LOWER(c.vehicle_no) COLLATE utf8mb4_general_ci
            WHERE a.status = 'pending' 
            ORDER BY a.created_at DESC
        ");
        error_log("Driver_status column not found, using simple query with case-insensitive client matching (collation fixed)");
    }
    
    $stmt->execute();
    $accidents = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Fetch photos for each accident
    foreach ($accidents as &$accident) {
        $photoStmt = $pdo->prepare("SELECT photo FROM accident_photos WHERE accident_id = ?");
        $photoStmt->execute([$accident['id']]);
        $photos = $photoStmt->fetchAll(PDO::FETCH_COLUMN);
        $accident['photos'] = $photos;
    }
    
    // Debug logging for coordinates
    error_log("API Debug - Returning " . count($accidents) . " accidents");
    foreach ($accidents as $accident) {
        error_log("Accident ID: " . $accident['id'] . ", Lat: " . $accident['latitude'] . ", Lng: " . $accident['longitude']);
    }
    
    echo json_encode([
        "success" => true,
        "data" => $accidents,
        "count" => count($accidents)
    ]);
    
} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "error" => "Database connection failed: " . $e->getMessage(),
        "data" => []
    ]);
} catch (Exception $e) {
    echo json_encode([
        "success" => false,
        "error" => "Server error: " . $e->getMessage(),
        "data" => []
    ]);
}
?>
