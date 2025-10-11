<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
    
    // Get accident ID from request
    $accident_id = isset($_GET['accident_id']) ? intval($_GET['accident_id']) : 0;
    
    if ($accident_id <= 0) {
        echo json_encode(['success' => false, 'message' => 'Invalid accident ID']);
        exit;
    }
    
    // Get accident details first
    $accidentStmt = $pdo->prepare("SELECT vehicle FROM accidents WHERE id = ?");
    $accidentStmt->execute([$accident_id]);
    $accident = $accidentStmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$accident) {
        echo json_encode(['success' => false, 'message' => 'Accident not found']);
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
    error_log("Error fetching client mobile: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error occurred']);
}
?>
