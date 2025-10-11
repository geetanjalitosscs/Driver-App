<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
    
    // Get trip ID from request
    $trip_id = isset($_GET['trip_id']) ? intval($_GET['trip_id']) : 0;
    
    if ($trip_id <= 0) {
        echo json_encode(['success' => false, 'message' => 'Invalid trip ID']);
        exit;
    }
    
    // Get vehicle number from accidents table using trip ID (since trip ID = accident ID)
    $accidentStmt = $pdo->prepare("SELECT vehicle FROM accidents WHERE id = ?");
    $accidentStmt->execute([$trip_id]);
    $accident = $accidentStmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$accident) {
        echo json_encode(['success' => false, 'message' => 'Accident not found for trip ID: ' . $trip_id]);
        exit;
    }
    
    $vehicle_number = $accident['vehicle'];
    
    // Get client mobile number from clients table using vehicle number
    $clientStmt = $pdo->prepare("SELECT mobile_no, full_name FROM clients WHERE LOWER(vehicle_no) COLLATE utf8mb4_general_ci = LOWER(?) COLLATE utf8mb4_general_ci");
    $clientStmt->execute([$vehicle_number]);
    $client = $clientStmt->fetch(PDO::FETCH_ASSOC);
    
    if ($client) {
        echo json_encode([
            'success' => true,
            'mobile_no' => $client['mobile_no'],
            'client_name' => $client['full_name'],
            'vehicle_number' => $vehicle_number
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Client not found for vehicle number: ' . $vehicle_number
        ]);
    }
    
} catch (Exception $e) {
    error_log("Error fetching client mobile by vehicle from trip: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error occurred']);
}
?>
