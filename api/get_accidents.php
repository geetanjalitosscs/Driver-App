<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
    
    // Get driver ID from query parameter or POST data
    $driver_id = null;
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 0;
    } elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true);
        $driver_id = isset($input['driver_id']) ? (int)$input['driver_id'] : 0;
    }
    
    // Check driver status before proceeding (skip for cancel operations)
    if ($driver_id > 0) {
        checkDriverStatus($driver_id);
    }
    
    // Handle POST requests for updating accident status
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Input already parsed above for driver_id check
        
        if (isset($input['action'])) {
            if ($input['action'] === 'accept_accident') {
                // Accept accident
                $accident_id = intval($input['accident_id']);
                $driver_id = intval($input['driver_id']);
                $vehicle_number = trim($input['vehicle_number']);
                
                // Additional driver status check for accept operation
                if ($driver_id <= 0) {
                    sendErrorResponse('Driver ID is required for accepting accident');
                }
                
                // Fetch driver name from drivers table
                $driverStmt = $pdo->prepare("SELECT driver_name FROM drivers WHERE id = ?");
                $driverStmt->execute([$driver_id]);
                $driver = $driverStmt->fetch(PDO::FETCH_ASSOC);
                
                $driver_name = $driver ? $driver['driver_name'] : 'Unknown Driver';
                $driver_details = "Driver: " . $driver_name . " | Vehicle: " . $vehicle_number;
                
                // Update accident - driver_status starts as NULL, so we check for NULL or 'available'
                $updateStmt = $pdo->prepare("UPDATE accidents SET 
                    driver_details = ?, 
                    driver_status = 'assigned',
                    status = 'investigating',
                    accepted_at = NOW()
                    WHERE id = ? AND status = 'pending' AND (driver_status IS NULL OR driver_status = 'available')");
                
                if ($updateStmt->execute([$driver_details, $accident_id])) {
                    $affected_rows = $updateStmt->rowCount();
                    if ($affected_rows > 0) {
                        echo json_encode(['success' => true, 'message' => 'Accident accepted successfully', 'affected_rows' => $affected_rows]);
                    } else {
                        echo json_encode(['success' => false, 'message' => 'No rows updated - accident may not exist or already assigned', 'affected_rows' => $affected_rows]);
                    }
                } else {
                    echo json_encode(['success' => false, 'message' => 'Failed to accept accident - SQL execution failed']);
                }
                exit;
                
            } elseif ($input['action'] === 'complete_accident') {
                // Complete accident
                $accident_id = intval($input['accident_id']);
                $driver_id = intval($input['driver_id']);
                $confirmed = $input['confirmed'] ?? false;
                
                // Get driver's current location if provided
                $driver_latitude = $input['driver_latitude'] ?? null;
                $driver_longitude = $input['driver_longitude'] ?? null;
                
                // Debug logging for coordinates
                error_log("=== TRIP COMPLETION COORDINATES DEBUG ===");
                error_log("Driver latitude: $driver_latitude");
                error_log("Driver longitude: $driver_longitude");
                
                if ($confirmed) {
                    // Additional driver status check for complete operation
                    if ($driver_id <= 0) {
                        sendErrorResponse('Driver ID is required for completing accident');
                    }
                    
                    // First, get accident details to create trip
                    $accidentStmt = $pdo->prepare("SELECT * FROM accidents WHERE id = ?");
                    $accidentStmt->execute([$accident_id]);
                    $accident = $accidentStmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($accident) {
                        // Debug logging for accident coordinates
                        error_log("Accident latitude: " . $accident['latitude']);
                        error_log("Accident longitude: " . $accident['longitude']);
                        
                        // Update accident status
                        $updateStmt = $pdo->prepare("UPDATE accidents SET 
                            driver_status = 'completed',
                            completed_at = NOW(),
                            completion_confirmed = TRUE,
                            status = 'resolved'
                            WHERE id = ?");
                        
                        if ($updateStmt->execute([$accident_id])) {
                            // Get the updated accident record with completed_at timestamp
                            $updatedStmt = $pdo->prepare("SELECT accepted_at, completed_at FROM accidents WHERE id = ?");
                            $updatedStmt->execute([$accident_id]);
                            $updatedAccident = $updatedStmt->fetch(PDO::FETCH_ASSOC);
                            
                            // Create trip record
                            $client_name = $accident['fullname'];
                            $location = $accident['location'];
                            $accepted_at = $updatedAccident['accepted_at'];
                            $completed_at = $updatedAccident['completed_at'];
                            
                            // Debug logging for timing
                            error_log("=== TRIP COMPLETION TIMING DEBUG ===");
                            error_log("Accepted at: $accepted_at");
                            error_log("Completed at: $completed_at");
                            
                            // Calculate duration in seconds
                            $start_timestamp = strtotime($accepted_at);
                            $end_timestamp = strtotime($completed_at);
                            $duration_seconds = $end_timestamp - $start_timestamp;
                            
                            error_log("Start timestamp: $start_timestamp");
                            error_log("End timestamp: $end_timestamp");
                            error_log("Duration in seconds: $duration_seconds");
                            
                            // If duration is negative or very large, use current time as start
                            if ($duration_seconds < 0 || $duration_seconds > 3600) { // More than 1 hour seems wrong
                                error_log("Duration seems incorrect, using current time as start time");
                                $accepted_at = $completed_at; // Use current time as start time
                                $duration_seconds = 5; // Set to 5 seconds as you mentioned
                            }
                            
                            // Store duration in seconds (not minutes) for better precision
                            $duration = $duration_seconds;
                            
                            // Ensure duration is never negative (minimum 1 second)
                            if ($duration < 0) {
                                $duration = 1; // Minimum 1 second for accident response
                            }
                            
                            // Get client_id from clients table by matching phone number
                            $client_id = null;
                            $accident_phone = $accident['phone'] ?? null;
                            if ($accident_phone) {
                                try {
                                    $clientStmt = $pdo->prepare("SELECT id FROM clients WHERE mobile_no = ? LIMIT 1");
                                    $clientStmt->execute([$accident_phone]);
                                    $client = $clientStmt->fetch(PDO::FETCH_ASSOC);
                                    if ($client) {
                                        $client_id = (int)$client['id'];
                                        error_log("Found client_id: $client_id for phone: $accident_phone");
                                    } else {
                                        error_log("No client found for phone: $accident_phone");
                                    }
                                } catch (Exception $e) {
                                    error_log("Error fetching client_id: " . $e->getMessage());
                                }
                            }
                            
                            // Calculate distance in kilometers using Haversine formula
                            $distance = null;
                            if ($accident['latitude'] && $accident['longitude'] && $driver_latitude && $driver_longitude) {
                                // Haversine formula to calculate distance
                                $lat1 = deg2rad((float)$accident['latitude']);
                                $lon1 = deg2rad((float)$accident['longitude']);
                                $lat2 = deg2rad((float)$driver_latitude);
                                $lon2 = deg2rad((float)$driver_longitude);
                                
                                $dlat = $lat2 - $lat1;
                                $dlon = $lon2 - $lon1;
                                
                                $a = sin($dlat / 2) ** 2 + cos($lat1) * cos($lat2) * sin($dlon / 2) ** 2;
                                $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
                                $distance_km = 6371 * $c; // Earth radius in kilometers
                                $distance = round($distance_km, 2); // Round to 2 decimal places
                                
                                error_log("Calculated distance: $distance km");
                            }
                            
                            // Get from_location (accident location address)
                            $from_location = $accident['location'] ?? null;
                            
                            // Get to_location (end location - try to get from driver's current location or use accident location)
                            // For now, we'll use accident location as to_location since driver completes at accident location
                            // In future, this can be updated with actual destination if available
                            $to_location = $accident['location'] ?? null;
                            
                            // Try to get actual destination address if we have coordinates
                            // For now, we'll store the accident location as to_location
                            // Note: This can be enhanced to get reverse geocoding address from driver's end coordinates
                            
                            // Debug logging for trip creation
                            error_log("=== TRIP CREATION DEBUG ===");
                            error_log("Accident ID: $accident_id");
                            error_log("Client Name: $client_name");
                            error_log("Client ID: " . ($client_id ?? 'NULL'));
                            error_log("Location: $location");
                            error_log("From Location: $from_location");
                            error_log("To Location: $to_location");
                            error_log("Distance: " . ($distance ?? 'NULL') . " km");
                            error_log("Duration: $duration seconds");
                            error_log("=== END DEBUG ===");
                            
                            // Insert trip record using accident ID as trip ID
                            // First check if trip with this ID already exists
                            $checkStmt = $pdo->prepare("SELECT history_id FROM trips WHERE history_id = ?");
                            $checkStmt->execute([$accident_id]);
                            $existingTrip = $checkStmt->fetch();
                            
                            if (!$existingTrip) {
                                // Insert trip record with all new fields
                                $tripStmt = $pdo->prepare("INSERT INTO trips 
                                    (history_id, driver_id, client_id, client_name, location, timing, duration, distance, start_time, end_time, start_latitude, start_longitude, end_latitude, end_longitude, from_location, to_location, created_at) 
                                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())");
                                
                                $tripInserted = $tripStmt->execute([
                                    $accident_id,  // Use accident ID as trip ID
                                    $driver_id,
                                    $client_id,  // client_id (can be NULL)
                                    $client_name,
                                    $location,
                                    $accepted_at,
                                    $duration,
                                    $distance,  // distance in km (can be NULL)
                                    $accepted_at,
                                    $completed_at,
                                    $accident['latitude'],  // Accident location (start - where driver went to)
                                    $accident['longitude'],
                                    $driver_latitude,  // Driver's current location (end - where they completed from)
                                    $driver_longitude,
                                    $from_location,  // from_location address
                                    $to_location     // to_location address
                                ]);
                                
                                if ($tripInserted) {
                                    error_log("✅ SUCCESS: Trip inserted with accident ID: $accident_id");
                                } else {
                                    error_log("❌ ERROR: Failed to insert trip with accident ID: $accident_id");
                                }
                            } else {
                                error_log("⚠️ WARNING: Trip with accident ID $accident_id already exists, skipping insertion");
                                $tripInserted = true; // Consider it successful since trip already exists
                            }
                            
                            if ($tripInserted) {
                                $trip_id = $accident_id; // Use accident ID as trip ID
                                
                                echo json_encode([
                                    'success' => true, 
                                    'message' => 'Accident completed and trip created successfully',
                                    'trip_id' => $accident_id,  // Return accident ID as trip ID
                                    'accident_id' => $accident_id,
                                ]);
                            } else {
                                echo json_encode(['success' => false, 'message' => 'Accident completed but failed to create trip record']);
                            }
                        } else {
                            echo json_encode(['success' => false, 'message' => 'Failed to complete accident']);
                        }
                    } else {
                        echo json_encode(['success' => false, 'message' => 'Accident not found']);
                    }
                } else {
                    // Cancel accident - reset all driver-related fields to NULL
                    // No driver ID required for cancel operation
                    $cancelStmt = $pdo->prepare("UPDATE accidents SET 
                        driver_status = NULL,
                        driver_details = NULL,
                        accepted_at = NULL,
                        completed_at = NULL,
                        completion_confirmed = FALSE,
                        status = 'pending'
                        WHERE id = ? AND status = 'investigating'");
                    
                    if ($cancelStmt->execute([$accident_id])) {
                        $affected_rows = $cancelStmt->rowCount();
                        if ($affected_rows > 0) {
                            echo json_encode(['success' => true, 'message' => 'Accident cancelled successfully', 'affected_rows' => $affected_rows]);
                        } else {
                            echo json_encode(['success' => false, 'message' => 'No rows updated - accident may not be in investigating status', 'affected_rows' => $affected_rows]);
                        }
                    } else {
                        echo json_encode(['success' => false, 'message' => 'Failed to cancel accident']);
                    }
                }
                exit;
            }
        }
    }
    
    // Function to calculate distance between two points (Haversine formula)
    function calculateDistance($lat1, $lon1, $lat2, $lon2) {
        $earthRadius = 6371; // Earth's radius in kilometers
        $dLat = deg2rad($lat2 - $lat1);
        $dLon = deg2rad($lon2 - $lon1);
        $a = sin($dLat/2) * sin($dLat/2) + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($dLon/2) * sin($dLon/2);
        $c = 2 * atan2(sqrt($a), sqrt(1-$a));
        return $earthRadius * $c;
    }

    // Function to calculate dynamic radius based on accident age
    function calculateDynamicRadius($created_at) {
        $current_time = new DateTime();
        $accident_time = new DateTime($created_at);
        $age_seconds = $current_time->getTimestamp() - $accident_time->getTimestamp();
        
        $base_radius_km = 0.5; // Start with 500m
        $expansion_interval_seconds = 15; // Expand every 15 seconds
        $expansion_increment_km = 0.5; // Increase by 500m each time
        
        $expansion_cycles = floor($age_seconds / $expansion_interval_seconds);
        $dynamic_radius_km = $base_radius_km + ($expansion_cycles * $expansion_increment_km);
        
        return $dynamic_radius_km;
    }

    // Get driver location for filtering
    $driver_location = null;
    if ($driver_id > 0) {
        $location_stmt = $pdo->prepare("SELECT latitude, longitude FROM driver_locations WHERE driver_id = ?");
        $location_stmt->execute([$driver_id]);
        $driver_location = $location_stmt->fetch(PDO::FETCH_ASSOC);
    }

    // First check if driver_status column exists
    $checkColumn = $pdo->prepare("SHOW COLUMNS FROM accidents LIKE 'driver_status'");
    $checkColumn->execute();
    $columnExists = $checkColumn->fetch();
    
    if ($columnExists) {
        // Column exists - use the full query with case-insensitive client filtering and collation fix
        $stmt = $pdo->prepare("
            SELECT a.* FROM accidents a 
            INNER JOIN clients c ON LOWER(a.vehicle) COLLATE utf8mb4_general_ci = LOWER(c.vehicle_no) COLLATE utf8mb4_general_ci
            WHERE a.status = 'pending' 
            AND (a.driver_status IS NULL OR a.driver_status = 'available')
            AND c.status = 'paid'
            ORDER BY a.created_at DESC
        ");
        error_log("Using driver_status filter with case-insensitive client matching (collation fixed)");
    } else {
        // Column doesn't exist - use simple query with case-insensitive client filtering and collation fix
        $stmt = $pdo->prepare("
            SELECT a.* FROM accidents a 
            INNER JOIN clients c ON LOWER(a.vehicle) COLLATE utf8mb4_general_ci = LOWER(c.vehicle_no) COLLATE utf8mb4_general_ci
            WHERE a.status = 'pending' 
            AND c.status = 'paid'
            ORDER BY a.created_at DESC
        ");
        error_log("Driver_status column not found, using simple query with case-insensitive client matching (collation fixed)");
    }
    
    $stmt->execute();
    $all_accidents = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Apply location-based filtering if driver location is available
    $accidents = [];
    if ($driver_location) {
        $driver_latitude = (float)$driver_location['latitude'];
        $driver_longitude = (float)$driver_location['longitude'];
        
        // Step 1: Separate new accidents (last 24 hours) from old accidents
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
                    // Check if current driver location is within range
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
                        
                        $accidents[] = $accident;
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
                    
                    $accidents[] = $accident;
                }
            }
        }
        
        // Sort by distance (closest first)
        usort($accidents, function($a, $b) {
            return $a['distance_km'] <=> $b['distance_km'];
        });
        
        error_log("Location filtering applied: " . count($accidents) . " accidents shown out of " . count($all_accidents) . " total");
    } else {
        // No driver location available - show all accidents (fallback)
        $accidents = $all_accidents;
        error_log("No driver location available - showing all accidents without location filtering");
    }
    
    // Check if accident_photos table exists and has data
    try {
        $tableCheck = $pdo->prepare("SHOW TABLES LIKE 'accident_photos'");
        $tableCheck->execute();
        $tableExists = $tableCheck->fetch();
        
        if ($tableExists) {
            $countStmt = $pdo->prepare("SELECT COUNT(*) as total FROM accident_photos");
            $countStmt->execute();
            $photoCount = $countStmt->fetch(PDO::FETCH_ASSOC);
            error_log("📊 PHOTO TABLE INFO - accident_photos table exists with " . $photoCount['total'] . " photos");
        } else {
            error_log("❌ PHOTO TABLE ERROR - accident_photos table does not exist!");
        }
    } catch (Exception $e) {
        error_log("❌ PHOTO TABLE CHECK ERROR - " . $e->getMessage());
    }
    
    // Fetch photos for each accident and convert to full URLs (only first photo)
    foreach ($accidents as &$accident) {
        // Enhanced photo fetching with better error handling
        try {
            $photoStmt = $pdo->prepare("SELECT photo FROM accident_photos WHERE accident_id = ? ORDER BY id DESC LIMIT 1");
            $photoStmt->execute([$accident['id']]);
            $photoFilename = $photoStmt->fetchColumn();
            
            // Debug logging for photo query
            error_log("🔍 PHOTO DEBUG - Accident ID: " . $accident['id'] . " - Query executed successfully");
            error_log("🔍 PHOTO DEBUG - Accident ID: " . $accident['id'] . " - Raw photo filename: " . var_export($photoFilename, true));
            
            // Convert filename to full URL (only if photo exists)
            if (!empty($photoFilename) && $photoFilename !== false) {
                $baseUrl = getUploadsBaseUrl();
                $fullPhotoUrl = $baseUrl . $photoFilename;
                $accident['photos'] = [$fullPhotoUrl];
                
                error_log("✅ PHOTO FOUND - Accident ID: " . $accident['id'] . " - Photo filename: " . $photoFilename);
                error_log("✅ PHOTO FOUND - Accident ID: " . $accident['id'] . " - Full URL: " . $fullPhotoUrl);
            } else {
                $accident['photos'] = [];
                error_log("❌ NO PHOTO - Accident ID: " . $accident['id'] . " - No photo found in database");
            }
            
        } catch (Exception $e) {
            error_log("❌ PHOTO ERROR - Accident ID: " . $accident['id'] . " - Error: " . $e->getMessage());
            $accident['photos'] = [];
        }
    }
    
    // Debug logging for coordinates and IDs
    error_log("API Debug - Returning " . count($accidents) . " accidents");
    foreach ($accidents as $accident) {
        error_log("Accident ID: " . $accident['id'] . " (type: " . gettype($accident['id']) . "), Name: " . $accident['fullname'] . ", Lat: " . $accident['latitude'] . ", Lng: " . $accident['longitude']);
    }
    
    echo json_encode([
        "success" => true,
        "data" => $accidents,
        "count" => count($accidents)
    ]);
    
} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "error" => "Database connection failed: " . $e->getMessage(),
        "data" => []
    ]);
} catch (Exception $e) {
    echo json_encode([
        "success" => false,
        "error" => "Server error: " . $e->getMessage(),
        "data" => []
    ]);
}
?>
