<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get driver ID from query parameter
$driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;

if ($driver_id <= 0) {
    sendErrorResponse('Invalid driver ID');
}

// Function to calculate dynamic radius based on accident age
function calculateDynamicRadius($created_at) {
    $now = new DateTime();
    $accident_time = new DateTime($created_at);
    $age_seconds = $now->getTimestamp() - $accident_time->getTimestamp();
    
    // Start with 500m, increase by 500m every 15 seconds
    $base_radius_km = 0.5; // 500 meters (0.5 kilometers)
    $expansion_km = 0.5; // 500 meters per expansion
    $expansion_interval_seconds = 15; // Every 15 seconds
    
    $expansions = floor($age_seconds / $expansion_interval_seconds);
    $dynamic_radius_km = $base_radius_km + ($expansions * $expansion_km);
    
    // No maximum cap - keep expanding
    return $dynamic_radius_km;
}

// Check driver status before proceeding
checkDriverStatus($driver_id);

try {
    // First, get driver's current location
    $stmt = $pdo->prepare("
        SELECT latitude, longitude, address, updated_at
        FROM driver_locations 
        WHERE driver_id = ?
        ORDER BY updated_at DESC 
        LIMIT 1
    ");
    $stmt->execute([$driver_id]);
    $driver_location = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$driver_location) {
        sendErrorResponse('Driver location not found. Please update your location first.');
    }
    
    $driver_latitude = (float)$driver_location['latitude'];
    $driver_longitude = (float)$driver_location['longitude'];
    
    // Find nearby accidents using Haversine formula with dynamic radius
    // First get all pending accidents with their distances
    $stmt = $pdo->prepare("
        SELECT 
            a.id,
            a.fullname,
            a.phone,
            a.vehicle,
            a.accident_date,
            a.location,
            a.latitude,
            a.longitude,
            a.description,
            a.created_at,
            a.status,
            (
                6371 * acos(
                    cos(radians(?)) * 
                    cos(radians(a.latitude)) * 
                    cos(radians(a.longitude) - radians(?)) + 
                    sin(radians(?)) * 
                    sin(radians(a.latitude))
                )
            ) AS distance_km
        FROM accidents a
        INNER JOIN clients c ON LOWER(a.vehicle) COLLATE utf8mb4_general_ci = LOWER(c.vehicle_no) COLLATE utf8mb4_general_ci
        WHERE a.status = 'pending' 
        AND c.status = 'paid'
        ORDER BY distance_km ASC, a.created_at DESC
    ");
    
    $stmt->execute([$driver_latitude, $driver_longitude, $driver_latitude]);
    $all_accidents = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Filter accidents based on dynamic radius
    $filtered_accidents = [];
    foreach ($all_accidents as $accident) {
        $dynamic_radius = calculateDynamicRadius($accident['created_at']);
        if ($accident['distance_km'] <= $dynamic_radius) {
            $accident['dynamic_radius_km'] = $dynamic_radius;
            $filtered_accidents[] = $accident;
        }
    }
    
    // Limit to 20 results
    $accidents = array_slice($filtered_accidents, 0, 20);
    
    // Add photos for each accident
    foreach ($accidents as &$accident) {
        $accident['distance_km'] = round((float)$accident['distance_km'], 2);
        $accident['dynamic_radius_km'] = round((float)$accident['dynamic_radius_km'], 2);
        
        // Get photos and convert to full URLs (only first photo)
        $photo_stmt = $pdo->prepare("
            SELECT photo 
            FROM accident_photos 
            WHERE accident_id = ?
            LIMIT 1
        ");
        $photo_stmt->execute([$accident['id']]);
        $photoFilename = $photo_stmt->fetchColumn();
        
        // Convert filename to full URL (only if photo exists)
        if (!empty($photoFilename)) {
            $baseUrl = getUploadsBaseUrl();
            $accident['photos'] = [$baseUrl . $photoFilename];
        } else {
            $accident['photos'] = [];
        }
    }
    
    echo json_encode([
        'success' => true,
        'message' => 'Nearby accidents for driver retrieved successfully',
        'data' => [
            'driver_id' => $driver_id,
            'driver_location' => [
                'latitude' => $driver_latitude,
                'longitude' => $driver_longitude,
                'address' => $driver_location['address'],
                'last_updated' => $driver_location['updated_at']
            ],
            'accidents' => $accidents,
            'search_radius_info' => [
                'base_radius_km' => 0.5,
                'expansion_interval_seconds' => 15,
                'expansion_increment_km' => 0.5,
                'dynamic_radius_enabled' => true
            ],
            'total_found' => count($accidents),
            'total_available' => count($filtered_accidents)
        ]
    ]);
    
} catch (PDOException $e) {
    sendErrorResponse('Database query failed: ' . $e->getMessage());
}
?>
