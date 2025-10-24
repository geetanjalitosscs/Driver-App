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
$required_fields = ['accident_id'];
foreach ($required_fields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        echo json_encode(['success' => false, 'message' => "Missing required field: $field"]);
        exit;
    }
}

$accident_id = (int)$input['accident_id'];

if ($accident_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid accident ID']);
    exit;
}

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
    // First, get accident details
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
        echo json_encode(['success' => false, 'message' => 'Accident is not in pending status']);
        exit;
    }
    
    // Calculate dynamic radius for this accident
    $dynamic_radius_km = calculateDynamicRadius($accident['created_at']);
    
    // Find nearby available drivers within the dynamic radius
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
        AND dl.updated_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR) -- Location updated within last hour
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
    
    if (empty($available_drivers)) {
        echo json_encode([
            'success' => false, 
            'message' => 'No available drivers found within radius',
            'data' => [
                'accident_id' => $accident_id,
                'dynamic_radius_km' => $dynamic_radius_km,
                'available_drivers_count' => 0
            ]
        ]);
        exit;
    }
    
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
        'message' => 'Available drivers found successfully',
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

} catch (PDOException $e) {
    error_log("Error finding available drivers: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error occurred']);
}
?>
