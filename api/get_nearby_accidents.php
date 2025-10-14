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

if (!$input || !isset($input['driver_id']) || !isset($input['latitude']) || !isset($input['longitude'])) {
    sendErrorResponse('Driver ID, latitude, and longitude are required');
}

$driver_id = (int)$input['driver_id'];
$driver_latitude = (float)$input['latitude'];
$driver_longitude = (float)$input['longitude'];
$radius_km = 0.005; // Fixed 5 meters radius (0.005 km)

if ($driver_id <= 0) {
    sendErrorResponse('Invalid driver ID');
}

try {
    // Calculate distance using Haversine formula - Fixed 10km radius
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
            a.photo,
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
        WHERE a.status = 'pending'
        HAVING distance_km <= ?
        ORDER BY distance_km ASC, a.created_at DESC
        LIMIT 50
    ");
    
    $stmt->execute([$driver_latitude, $driver_longitude, $driver_latitude, $radius_km]);
    $accidents = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Get accident photos for each accident
    foreach ($accidents as &$accident) {
        $accident['distance_km'] = round((float)$accident['distance_km'], 2);
        
        // Get photos for this accident
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
        'message' => 'Nearby accidents retrieved successfully',
        'data' => [
            'accidents' => $accidents,
            'driver_location' => [
                'latitude' => $driver_latitude,
                'longitude' => $driver_longitude
            ],
            'search_radius_km' => $radius_km,
            'total_found' => count($accidents)
        ]
    ]);
    
} catch (PDOException $e) {
    sendErrorResponse('Database query failed: ' . $e->getMessage());
}
?>
