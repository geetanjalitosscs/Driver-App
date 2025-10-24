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

// Validate input
if (strlen($fullname) < 2 || strlen($fullname) > 100) {
    echo json_encode(['success' => false, 'message' => 'Full name must be 2-100 characters']);
    exit;
}

if (!preg_match('/^[0-9]{10}$/', $phone)) {
    echo json_encode(['success' => false, 'message' => 'Phone number must be 10 digits']);
    exit;
}

if (strlen($vehicle) < 5 || strlen($vehicle) > 50) {
    echo json_encode(['success' => false, 'message' => 'Vehicle number must be 5-50 characters']);
    exit;
}

if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $accident_date)) {
    echo json_encode(['success' => false, 'message' => 'Invalid accident date format']);
    exit;
}

if (strlen($location) < 5 || strlen($location) > 500) {
    echo json_encode(['success' => false, 'message' => 'Location must be 5-500 characters']);
    exit;
}

if ($latitude < -90 || $latitude > 90) {
    echo json_encode(['success' => false, 'message' => 'Invalid latitude']);
    exit;
}

if ($longitude < -180 || $longitude > 180) {
    echo json_encode(['success' => false, 'message' => 'Invalid longitude']);
    exit;
}

if (strlen($description) < 5 || strlen($description) > 1000) {
    echo json_encode(['success' => false, 'message' => 'Description must be 5-1000 characters']);
    exit;
}

try {
    // Insert accident report into accidents table
    $stmt = $pdo->prepare("
        INSERT INTO accidents 
        (fullname, phone, vehicle, accident_date, location, latitude, longitude, description, photo, created_at, status) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), 'pending')
    ");
    
    $result = $stmt->execute([
        $fullname,
        $phone,
        $vehicle,
        $accident_date,
        $location,
        $latitude,
        $longitude,
        $description,
        $photo
    ]);
    
    if ($result) {
        $accident_id = $pdo->lastInsertId();
        
        // Log the accident submission
        error_log("New accident report submitted: ID=$accident_id, Name=$fullname, Location=$location");
        
        echo json_encode([
            'success' => true,
            'message' => 'Accident report submitted successfully',
            'accident_id' => $accident_id,
            'data' => [
                'id' => $accident_id,
                'fullname' => $fullname,
                'phone' => $phone,
                'vehicle' => $vehicle,
                'accident_date' => $accident_date,
                'location' => $location,
                'latitude' => $latitude,
                'longitude' => $longitude,
                'description' => $description,
                'photo' => $photo,
                'status' => 'pending',
                'created_at' => date('Y-m-d H:i:s')
            ]
        ]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to submit accident report']);
    }

} catch (PDOException $e) {
    error_log("Error submitting accident report: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error occurred']);
}
?>
