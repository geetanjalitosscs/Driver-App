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

// Function to calculate distance between two points (Haversine formula)
function calculateDistance($lat1, $lon1, $lat2, $lon2) {
    $earthRadius = 6371; // Earth's radius in kilometers
    
    $dLat = deg2rad($lat2 - $lat1);
    $dLon = deg2rad($lon2 - $lon1);
    
    $a = sin($dLat/2) * sin($dLat/2) + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($dLon/2) * sin($dLon/2);
    $c = 2 * atan2(sqrt($a), sqrt(1-$a));
    
    return $earthRadius * $c; // Distance in kilometers
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
    // Step 1: Get driver's current location
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
    
    // Step 2: Get all pending accidents from paid clients
    // Only apply dynamic radius logic to accidents created in the last 24 hours (new reports)
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
            a.status
        FROM accidents a
        INNER JOIN clients c ON LOWER(a.vehicle) COLLATE utf8mb4_general_ci = LOWER(c.vehicle_no) COLLATE utf8mb4_general_ci
        WHERE a.status = 'pending' 
        AND c.status = 'paid'
        ORDER BY a.created_at DESC
    ");
    $stmt->execute();
    $all_accidents = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Step 3: Separate new accidents (last 24 hours) from old accidents
    $available_accidents = [];
    $current_time = new DateTime();
    $twenty_four_hours_ago = (new DateTime())->modify('-24 hours');
    
    foreach ($all_accidents as $accident) {
        $accident_lat = (float)$accident['latitude'];
        $accident_lon = (float)$accident['longitude'];
        $accident_created_at = new DateTime($accident['created_at']);
        
        // Check if this is a new accident (created within last 24 hours)
        $is_new_accident = $accident_created_at >= $twenty_four_hours_ago;
        
        // Debug logging
        error_log("Accident ID {$accident['id']}: Created at {$accident['created_at']}, Is new: " . ($is_new_accident ? 'YES' : 'NO'));
        
        if ($is_new_accident) {
            // NEW ACCIDENT LOGIC: Apply dynamic radius and driver availability check
            $dynamic_radius_km = calculateDynamicRadius($accident['created_at']);
            
            // Get all available drivers and check if any are within range
            $stmt = $pdo->prepare("
                SELECT dl.driver_id, dl.latitude, dl.longitude, d.driver_name, d.kyc_status
                FROM driver_locations dl
                INNER JOIN drivers d ON dl.driver_id = d.id
                WHERE d.kyc_status = 'approved'
            ");
            $stmt->execute();
            $all_drivers = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            $drivers_in_range = [];
            foreach ($all_drivers as $driver) {
                $distance_km = calculateDistance(
                    $accident_lat, 
                    $accident_lon, 
                    (float)$driver['latitude'], 
                    (float)$driver['longitude']
                );
                
                if ($distance_km <= $dynamic_radius_km) {
                    $drivers_in_range[] = [
                        'driver_id' => $driver['driver_id'],
                        'driver_name' => $driver['driver_name'],
                        'distance_km' => round($distance_km, 3)
                    ];
                }
            }
            
            // Only include accident if there are drivers within range
            if (!empty($drivers_in_range)) {
                // Check if current driver is within range
                $driver_distance_km = calculateDistance(
                    $accident_lat, 
                    $accident_lon, 
                    $driver_latitude, 
                    $driver_longitude
                );
                
                if ($driver_distance_km <= $dynamic_radius_km) {
                    $accident['distance_km'] = round($driver_distance_km, 2);
                    $accident['dynamic_radius_km'] = round($dynamic_radius_km, 2);
                    $accident['drivers_in_range_count'] = count($drivers_in_range);
                    $accident['is_new_accident'] = true;
                    $accident['logic_applied'] = 'Dynamic radius with driver availability check';
                    
                    // Add photos for this accident
                    $photo_stmt = $pdo->prepare("
                        SELECT photo 
                        FROM accident_photos 
                        WHERE accident_id = ?
                        LIMIT 1
                    ");
                    $photo_stmt->execute([$accident['id']]);
                    $photoFilename = $photo_stmt->fetchColumn();
                    
                    if (!empty($photoFilename)) {
                        $baseUrl = getUploadsBaseUrl();
                        $accident['photos'] = [$baseUrl . $photoFilename];
                    } else {
                        $accident['photos'] = [];
                    }
                    
                    $available_accidents[] = $accident;
                }
            }
        } else {
            // OLD ACCIDENT LOGIC: Show to all drivers within reasonable distance (5km)
            $driver_distance_km = calculateDistance(
                $accident_lat, 
                $accident_lon, 
                $driver_latitude, 
                $driver_longitude
            );
            
            // Debug logging for old accidents
            error_log("OLD Accident ID {$accident['id']}: Distance from driver: {$driver_distance_km}km, Within 10km: " . ($driver_distance_km <= 10.0 ? 'YES' : 'NO'));
            
            // Show old accidents to drivers within 10km
            if ($driver_distance_km <= 10.0) {
                $accident['distance_km'] = round($driver_distance_km, 2);
                $accident['is_new_accident'] = false;
                $accident['logic_applied'] = 'Fixed 10km radius for old accidents';
                
                // Add photos for this accident
                $photo_stmt = $pdo->prepare("
                    SELECT photo 
                    FROM accident_photos 
                    WHERE accident_id = ?
                    LIMIT 1
                ");
                $photo_stmt->execute([$accident['id']]);
                $photoFilename = $photo_stmt->fetchColumn();
                
                if (!empty($photoFilename)) {
                    $baseUrl = getUploadsBaseUrl();
                    $accident['photos'] = [$baseUrl . $photoFilename];
                } else {
                    $accident['photos'] = [];
                }
                
                $available_accidents[] = $accident;
            }
        }
    }
    
    // Step 6: Sort by distance (closest first) and limit results
    usort($available_accidents, function($a, $b) {
        return $a['distance_km'] <=> $b['distance_km'];
    });
    
    $accidents = array_slice($available_accidents, 0, 20);
    
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
            'search_radius_info' => [
                'base_radius_km' => 0.5,
                'expansion_interval_seconds' => 15,
                'expansion_increment_km' => 0.5,
                'dynamic_radius_enabled' => true,
                'new_accident_logic' => 'Dynamic radius with driver availability check (last 24 hours)',
                'old_accident_logic' => 'Fixed 10km radius for accidents older than 24 hours',
                'time_threshold_hours' => 24
            ],
            'total_found' => count($accidents),
            'total_checked' => count($all_accidents)
        ]
    ]);
    
} catch (PDOException $e) {
    sendErrorResponse('Database query failed: ' . $e->getMessage());
}
?>
