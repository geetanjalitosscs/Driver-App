<?php
require_once '../db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get parameters from query string
$latitude = isset($_GET['latitude']) ? (float)$_GET['latitude'] : null;
$longitude = isset($_GET['longitude']) ? (float)$_GET['longitude'] : null;
$radius_km = 10.0; // Fixed 10km radius
$status = isset($_GET['status']) ? $_GET['status'] : 'pending';

if ($latitude === null || $longitude === null) {
    sendErrorResponse('Latitude and longitude are required');
}

try {
    // Query to find accidents within specified radius
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
        WHERE a.status = ?
        HAVING distance_km <= ?
        ORDER BY distance_km ASC, a.created_at DESC
    ");
    
    $stmt->execute([$latitude, $longitude, $latitude, $status, $radius_km]);
    $accidents = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Add photos for each accident
    foreach ($accidents as &$accident) {
        $accident['distance_km'] = round((float)$accident['distance_km'], 2);
        
        // Get photos
        $photo_stmt = $pdo->prepare("
            SELECT photo 
            FROM accident_photos 
            WHERE accident_id = ?
        ");
        $photo_stmt->execute([$accident['id']]);
        $photos = $photo_stmt->fetchAll(PDO::FETCH_COLUMN);
        $accident['photos'] = $photos;
    }
    
    echo json_encode([
        'success' => true,
        'message' => 'Accidents found within ' . $radius_km . 'km radius',
        'data' => [
            'accidents' => $accidents,
            'search_location' => [
                'latitude' => $latitude,
                'longitude' => $longitude
            ],
            'search_radius_km' => $radius_km,
            'status_filter' => $status,
            'total_found' => count($accidents)
        ]
    ]);
    
} catch (PDOException $e) {
    sendErrorResponse('Database query failed: ' . $e->getMessage());
}
?>
