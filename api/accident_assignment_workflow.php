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
$required_fields = ['action'];
foreach ($required_fields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        echo json_encode(['success' => false, 'message' => "Missing required field: $field"]);
        exit;
    }
}

$action = $input['action'];

// Function to calculate dynamic radius based on accident age
function calculateDynamicRadius($created_at) {
    $now = new DateTime();
    $accident_time = new DateTime($created_at);
    $age_seconds = $now->getTimestamp() - $accident_time->getTimestamp();
    
    // Start with 5m (0.005km), increase by 5m every 15 seconds
    $base_radius_km = 0.005; // 5 meters
    $expansion_km = 0.005; // 5 meters per expansion
    $expansion_interval_seconds = 15; // Every 15 seconds
    
    $expansions = floor($age_seconds / $expansion_interval_seconds);
    $dynamic_radius_km = $base_radius_km + ($expansions * $expansion_km);
    
    // Cap at maximum 10km radius
    $max_radius_km = 10.0;
    if ($dynamic_radius_km > $max_radius_km) {
        $dynamic_radius_km = $max_radius_km;
    }
    
    return $dynamic_radius_km;
}

try {
    if ($action === 'submit_report') {
        // Submit new accident report
        $required_fields = ['fullname', 'phone', 'vehicle', 'accident_date', 'location', 'latitude', 'longitude', 'description'];
        foreach ($required_fields as $field) {
            if (!isset($input[$field]) || empty($input[$field])) {
                echo json_encode(['success' => false, 'message' => "Missing required field: $field"]);
                exit;
            }
        }
        
        $fullname = trim($input['fullname']);
        $phone = trim($input['phone']);
        $vehicle = trim($input['vehicle']);
        $accident_date = trim($input['accident_date']);
        $location = trim($input['location']);
        $latitude = (float)$input['latitude'];
        $longitude = (float)$input['longitude'];
        $description = trim($input['description']);
        $photo = isset($input['photo']) ? trim($input['photo']) : '';
        
        // Insert accident report
        $stmt = $pdo->prepare("
            INSERT INTO accidents 
            (fullname, phone, vehicle, accident_date, location, latitude, longitude, description, photo, created_at, status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), 'pending')
        ");
        
        $result = $stmt->execute([
            $fullname, $phone, $vehicle, $accident_date, $location, 
            $latitude, $longitude, $description, $photo
        ]);
        
        if ($result) {
            $accident_id = $pdo->lastInsertId();
            
            // Log the accident submission
            error_log("New accident report submitted: ID=$accident_id, Name=$fullname, Location=$location");
            
            echo json_encode([
                'success' => true,
                'message' => 'Accident report submitted successfully',
                'data' => [
                    'accident_id' => $accident_id,
                    'status' => 'pending',
                    'created_at' => date('Y-m-d H:i:s'),
                    'assignment_info' => [
                        'initial_radius_km' => 0.005,
                        'radius_expansion_enabled' => true,
                        'expansion_interval_seconds' => 15,
                        'max_radius_km' => 10.0
                    ]
                ]
            ]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to submit accident report']);
        }
        
    } elseif ($action === 'get_available_drivers') {
        // Get available drivers for an accident
        $accident_id = isset($input['accident_id']) ? (int)$input['accident_id'] : 0;
        
        if ($accident_id <= 0) {
            echo json_encode(['success' => false, 'message' => 'Invalid accident ID']);
            exit;
        }
        
        // Get accident details
        $stmt = $pdo->prepare("
            SELECT id, latitude, longitude, created_at, status, driver_status
            FROM accidents 
            WHERE id = ?
        ");
        $stmt->execute([$accident_id]);
        $accident = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$accident) {
            echo json_encode(['success' => false, 'message' => 'Accident not found']);
            exit;
        }
        
        if ($accident['status'] !== 'pending') {
            echo json_encode(['success' => false, 'message' => 'Accident is not available for assignment']);
            exit;
        }
        
        // Calculate dynamic radius
        $dynamic_radius_km = calculateDynamicRadius($accident['created_at']);
        
        // Find nearby available drivers
        $stmt = $pdo->prepare("
            SELECT 
                d.id as driver_id,
                d.driver_name,
                d.phone,
                d.vehicle_number,
                dl.latitude,
                dl.longitude,
                dl.updated_at as location_updated_at,
                (
                    6371 * acos(
                        cos(radians(?)) * 
                        cos(radians(dl.latitude)) * 
                        cos(radians(dl.longitude) - radians(?)) + 
                        sin(radians(?)) * 
                        sin(radians(dl.latitude))
                    )
                ) AS distance_km
            FROM drivers d
            INNER JOIN driver_locations dl ON d.id = dl.driver_id
            WHERE d.status = 'active' 
            AND dl.latitude IS NOT NULL 
            AND dl.longitude IS NOT NULL
            AND dl.updated_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
            HAVING distance_km <= ?
            ORDER BY distance_km ASC
            LIMIT 10
        ");
        
        $stmt->execute([
            $accident['latitude'], 
            $accident['longitude'], 
            $accident['latitude'], 
            $dynamic_radius_km
        ]);
        $available_drivers = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Format driver data
        $formatted_drivers = [];
        foreach ($available_drivers as $driver) {
            $formatted_drivers[] = [
                'driver_id' => (int)$driver['driver_id'],
                'driver_name' => $driver['driver_name'],
                'phone' => $driver['phone'],
                'vehicle_number' => $driver['vehicle_number'],
                'distance_km' => round((float)$driver['distance_km'], 2),
                'location_updated_at' => $driver['location_updated_at']
            ];
        }
        
        echo json_encode([
            'success' => true,
            'message' => 'Available drivers retrieved successfully',
            'data' => [
                'accident_id' => $accident_id,
                'dynamic_radius_km' => $dynamic_radius_km,
                'available_drivers' => $formatted_drivers,
                'total_drivers_found' => count($formatted_drivers),
                'radius_info' => [
                    'base_radius_km' => 0.005,
                    'expansion_interval_seconds' => 15,
                    'max_radius_km' => 10.0,
                    'current_radius_km' => $dynamic_radius_km
                ]
            ]
        ]);
        
    } elseif ($action === 'assign_driver') {
        // Assign driver to accident
        $accident_id = isset($input['accident_id']) ? (int)$input['accident_id'] : 0;
        $driver_id = isset($input['driver_id']) ? (int)$input['driver_id'] : 0;
        $vehicle_number = isset($input['vehicle_number']) ? trim($input['vehicle_number']) : '';
        
        if ($accident_id <= 0 || $driver_id <= 0) {
            echo json_encode(['success' => false, 'message' => 'Invalid accident ID or driver ID']);
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
        // Driver rejects assignment - make available for next driver
        $accident_id = isset($input['accident_id']) ? (int)$input['accident_id'] : 0;
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
        // Cancel assignment - make available for next driver
        $accident_id = isset($input['accident_id']) ? (int)$input['accident_id'] : 0;
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
        echo json_encode([
            'success' => false, 
            'message' => 'Invalid action. Supported actions: submit_report, get_available_drivers, assign_driver, reject_assignment, cancel_assignment'
        ]);
    }

} catch (PDOException $e) {
    error_log("Error in accident assignment workflow: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error occurred']);
}
?>
