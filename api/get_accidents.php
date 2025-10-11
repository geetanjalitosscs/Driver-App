<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
    
    // Handle POST requests for updating accident status
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = json_decode(file_get_contents('php://input'), true);
        
        if (isset($input['action'])) {
            if ($input['action'] === 'accept_accident') {
                // Accept accident
                $accident_id = intval($input['accident_id']);
                $driver_id = intval($input['driver_id']);
                $vehicle_number = trim($input['vehicle_number']);
                
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
                
                if ($confirmed) {
                    // First, get accident details to create trip
                    $accidentStmt = $pdo->prepare("SELECT * FROM accidents WHERE id = ?");
                    $accidentStmt->execute([$accident_id]);
                    $accident = $accidentStmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($accident) {
                        // Update accident status
                        $updateStmt = $pdo->prepare("UPDATE accidents SET 
                            driver_status = 'completed',
                            completed_at = NOW(),
                            completion_confirmed = TRUE,
                            status = 'resolved'
                            WHERE id = ?");
                        
                        if ($updateStmt->execute([$accident_id])) {
                            // Create trip record
                            $client_name = $accident['fullname'];
                            $location = $accident['location'];
                            $accepted_at = $accident['accepted_at'];
                            $completed_at = date('Y-m-d H:i:s'); // Current time
                            
                            // Calculate duration in minutes
                            $start_timestamp = strtotime($accepted_at);
                            $end_timestamp = strtotime($completed_at);
                            $duration = round(($end_timestamp - $start_timestamp) / 60); // Duration in minutes
                            
                            // Ensure duration is never negative (minimum 1 minute)
                            if ($duration < 0) {
                                $duration = 1; // Minimum 1 minute for accident response
                            }
                            
                            // Calculate amount (Base fare + per minute charge)
                            // Using ₹500 base fare instead of ₹1500
                            $base_fare = 500.00; // Base fare for accident response
                            $per_minute_rate = 5.00; // Per minute charge
                            $amount = $base_fare + ($duration * $per_minute_rate);
                            
                            // Ensure amount is never negative
                            if ($amount < 0) {
                                $amount = $base_fare; // At least base fare
                            }
                            
                            // Debug logging for amount calculation
                            error_log("Amount Calculation Debug:");
                            error_log("Base Fare: ₹$base_fare");
                            error_log("Duration: $duration minutes");
                            error_log("Per Minute Rate: ₹$per_minute_rate");
                            error_log("Calculated Amount: ₹$amount");
                            error_log("Accident ID: $accident_id");
                            error_log("Client Name: $client_name");
                            error_log("Location: $location");
                            error_log("Accepted At: $accepted_at");
                            error_log("Completed At: $completed_at");
                            error_log("Start Timestamp: $start_timestamp");
                            error_log("End Timestamp: $end_timestamp");
                            error_log("Duration Calculation: ($end_timestamp - $start_timestamp) / 60 = $duration");
                            
                            // Debug logging for ID consistency
                            error_log("ID Consistency Debug:");
                            error_log("Accident ID: $accident_id");
                            error_log("Using Accident ID as Trip ID: $accident_id");
                            error_log("Trip Amount: ₹$amount");
                            
                            // Insert trip record using accident ID as trip ID
                            // Temporarily disable auto-increment to force specific ID
                            $pdo->exec("SET SESSION sql_mode = 'NO_AUTO_VALUE_ON_ZERO'");
                            
                            // First check if trip with this ID already exists
                            $checkStmt = $pdo->prepare("SELECT history_id FROM trips WHERE history_id = ?");
                            $checkStmt->execute([$accident_id]);
                            $existingTrip = $checkStmt->fetch();
                            
                            if (!$existingTrip) {
                                // Insert trip record using accident ID as trip ID
                                $tripStmt = $pdo->prepare("INSERT INTO trips 
                                    (history_id, driver_id, client_name, location, timing, amount, duration, start_time, end_time, created_at) 
                                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())");
                                
                                $tripInserted = $tripStmt->execute([
                                    $accident_id,  // Use accident ID as trip ID
                                    $driver_id,
                                    $client_name,
                                    $location,
                                    $accepted_at,
                                    $amount,
                                    $duration,
                                    $accepted_at,
                                    $completed_at
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
                                
                                // Create earning record using accident ID as trip ID
                                $earningStmt = $pdo->prepare("INSERT INTO earnings 
                                    (driver_id, trip_id, amount, earning_date, created_at) 
                                    VALUES (?, ?, ?, CURDATE(), NOW())");
                                
                                $earningInserted = $earningStmt->execute([
                                    $driver_id,
                                    $accident_id,  // Use accident ID as trip ID
                                    $amount
                                ]);
                                
                                // Update wallet balance
                                $walletStmt = $pdo->prepare("UPDATE wallet 
                                    SET balance = balance + ? 
                                    WHERE driver_id = ?");
                                $walletStmt->execute([$amount, $driver_id]);
                                
                                // Create wallet transaction using accident ID
                                $transactionStmt = $pdo->prepare("INSERT INTO wallet_transactions 
                                    (wallet_id, transaction_type, amount, description, transaction_date) 
                                    SELECT wallet_id, 'credit', ?, CONCAT('Trip #', ?, ' - ', ?), NOW() 
                                    FROM wallet WHERE driver_id = ?");
                                $transactionStmt->execute([$amount, $accident_id, $client_name, $driver_id]);
                                
                                echo json_encode([
                                    'success' => true, 
                                    'message' => 'Accident completed and trip created successfully',
                                    'trip_id' => $accident_id,  // Return accident ID as trip ID
                                    'accident_id' => $accident_id,
                                    'earning_inserted' => $earningInserted
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
                    $cancelStmt = $pdo->prepare("UPDATE accidents SET 
                        driver_status = NULL,
                        driver_details = NULL,
                        accepted_at = NULL,
                        completed_at = NULL,
                        completion_confirmed = FALSE
                        WHERE id = ?");
                    
                    if ($cancelStmt->execute([$accident_id])) {
                        echo json_encode(['success' => true, 'message' => 'Accident cancelled successfully']);
                    } else {
                        echo json_encode(['success' => false, 'message' => 'Failed to cancel accident']);
                    }
                }
                exit;
            }
        }
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
            ORDER BY a.created_at DESC
        ");
        error_log("Using driver_status filter with case-insensitive client matching (collation fixed)");
    } else {
        // Column doesn't exist - use simple query with case-insensitive client filtering and collation fix
        $stmt = $pdo->prepare("
            SELECT a.* FROM accidents a 
            INNER JOIN clients c ON LOWER(a.vehicle) COLLATE utf8mb4_general_ci = LOWER(c.vehicle_no) COLLATE utf8mb4_general_ci
            WHERE a.status = 'pending' 
            ORDER BY a.created_at DESC
        ");
        error_log("Driver_status column not found, using simple query with case-insensitive client matching (collation fixed)");
    }
    
    $stmt->execute();
    $accidents = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
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
                $baseUrl = 'https://tossconsultancyservices.com/apatkal/uploads/';
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
