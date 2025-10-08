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
$radius_km = 0.01; // Fixed 10 meters radius (0.01 km)

if ($driver_id <= 0) {
    sendErrorResponse('Invalid driver ID');
}

try {
    // First, get driver's current location
    $stmt = $pdo->prepare("
        SELECT latitude, longitude, updated_at
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
    
    // Find nearby accidents using Haversine formula
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
        WHERE a.status = 'pending'
        HAVING distance_km <= ?
        ORDER BY distance_km ASC, a.created_at DESC
        LIMIT 20
    ");
    
    $stmt->execute([$driver_latitude, $driver_longitude, $driver_latitude, $radius_km]);
    $accidents = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Add photos for each accident
    foreach ($accidents as &$accident) {
        $accident['distance_km'] = round((float)$accident['distance_km'], 2);
        
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
            $baseUrl = 'https://tossconsultancyservices.com/apatkal/uploads/';
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
                'last_updated' => $driver_location['updated_at']
            ],
            'accidents' => $accidents,
            'search_radius_km' => $radius_km,
            'total_found' => count($accidents)
        ]
    ]);
    
} catch (PDOException $e) {
    sendErrorResponse('Database query failed: ' . $e->getMessage());
}
?>
