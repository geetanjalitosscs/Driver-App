<?php
/**
 * Test file for location-based accident filtering
 * This file tests the new API endpoints for nearby accidents
 */

require_once 'db_config.php';

echo "<h1>Testing Location-Based Accident Filtering</h1>";

try {
    $pdo = getDatabaseConnection();
    echo "<p style='color: green;'>✓ Database connection successful</p>";
} catch (PDOException $e) {
    echo "<p style='color: red;'>✗ Database connection failed: " . $e->getMessage() . "</p>";
    exit;
}

// Test 1: Check if driver_locations table exists
echo "<h2>Test 1: Driver Locations Table</h2>";
try {
    $stmt = $pdo->query("SHOW TABLES LIKE 'driver_locations'");
    if ($stmt->rowCount() > 0) {
        echo "<p style='color: green;'>✓ driver_locations table exists</p>";
        
        // Show table structure
        $stmt = $pdo->query("DESCRIBE driver_locations");
        echo "<h3>Table Structure:</h3><ul>";
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "<li>{$row['Field']} - {$row['Type']}</li>";
        }
        echo "</ul>";
    } else {
        echo "<p style='color: orange;'>⚠ driver_locations table doesn't exist yet (will be created on first use)</p>";
    }
} catch (PDOException $e) {
    echo "<p style='color: red;'>✗ Error checking driver_locations table: " . $e->getMessage() . "</p>";
}

// Test 2: Check accidents table
echo "<h2>Test 2: Accidents Table</h2>";
try {
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM accidents");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "<p style='color: green;'>✓ Accidents table has {$result['count']} records</p>";
    
    // Show sample accidents with coordinates
    $stmt = $pdo->query("SELECT id, fullname, location, latitude, longitude, status FROM accidents WHERE latitude IS NOT NULL AND longitude IS NOT NULL LIMIT 5");
    echo "<h3>Sample Accidents with Coordinates:</h3><ul>";
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "<li>ID: {$row['id']}, Name: {$row['fullname']}, Status: {$row['status']}, Location: {$row['location']}, Coords: {$row['latitude']}, {$row['longitude']}</li>";
    }
    echo "</ul>";
} catch (PDOException $e) {
    echo "<p style='color: red;'>✗ Error checking accidents table: " . $e->getMessage() . "</p>";
}

// Test 3: Test distance calculation
echo "<h2>Test 3: Distance Calculation</h2>";
try {
    // Test coordinates (Indore, Madhya Pradesh)
    $test_lat = 22.7170;
    $test_lng = 75.8337;
    
    $stmt = $pdo->prepare("
        SELECT 
            id,
            fullname,
            location,
            latitude,
            longitude,
            (
                6371 * acos(
                    cos(radians(?)) * 
                    cos(radians(latitude)) * 
                    cos(radians(longitude) - radians(?)) + 
                    sin(radians(?)) * 
                    sin(radians(latitude))
                )
            ) AS distance_km
        FROM accidents
        WHERE latitude IS NOT NULL AND longitude IS NOT NULL
        HAVING distance_km <= 50
        ORDER BY distance_km ASC
        LIMIT 10
    ");
    
    $stmt->execute([$test_lat, $test_lng, $test_lat]);
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<p style='color: green;'>✓ Distance calculation working. Found " . count($results) . " accidents within 50km of test location</p>";
    
    echo "<h3>Nearby Accidents (within 50km):</h3><ul>";
    foreach ($results as $accident) {
        echo "<li>{$accident['fullname']} - " . round($accident['distance_km'], 2) . "km away - {$accident['location']}</li>";
    }
    echo "</ul>";
    
} catch (PDOException $e) {
    echo "<p style='color: red;'>✗ Error testing distance calculation: " . $e->getMessage() . "</p>";
}

// Test 4: Test API endpoints
echo "<h2>Test 4: API Endpoints</h2>";

// Test get_nearby_accidents.php
echo "<h3>Testing get_nearby_accidents.php</h3>";
$test_data = [
    'driver_id' => 1,
    'latitude' => 22.7170,
    'longitude' => 75.8337,
    'radius_km' => 10.0
];

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'http://localhost/Driver-App/api/get_nearby_accidents.php');
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($test_data));
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($http_code == 200) {
    $result = json_decode($response, true);
    if ($result && isset($result['success']) && $result['success']) {
        echo "<p style='color: green;'>✓ get_nearby_accidents.php working - Found " . count($result['data']['accidents']) . " nearby accidents</p>";
    } else {
        echo "<p style='color: red;'>✗ get_nearby_accidents.php returned error: " . ($result['error'] ?? 'Unknown error') . "</p>";
    }
} else {
    echo "<p style='color: red;'>✗ get_nearby_accidents.php HTTP error: $http_code</p>";
}

// Test get_accidents_by_location.php
echo "<h3>Testing get_accidents_by_location.php</h3>";
$url = "http://localhost/Driver-App/api/get_accidents_by_location.php?latitude=22.7170&longitude=75.8337&radius_km=10&status=pending";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($http_code == 200) {
    $result = json_decode($response, true);
    if ($result && isset($result['success']) && $result['success']) {
        echo "<p style='color: green;'>✓ get_accidents_by_location.php working - Found " . count($result['data']['accidents']) . " accidents by location</p>";
    } else {
        echo "<p style='color: red;'>✗ get_accidents_by_location.php returned error: " . ($result['error'] ?? 'Unknown error') . "</p>";
    }
} else {
    echo "<p style='color: red;'>✗ get_accidents_by_location.php HTTP error: $http_code</p>";
}

echo "<h2>Summary</h2>";
echo "<p>The location-based accident filtering system is ready to use!</p>";
echo "<p><strong>New API Endpoints:</strong></p>";
echo "<ul>";
echo "<li><code>get_nearby_accidents.php</code> - Get accidents near driver's current location</li>";
echo "<li><code>get_accidents_by_location.php</code> - Get accidents by specific coordinates</li>";
echo "<li><code>update_driver_location.php</code> - Update driver's current location</li>";
echo "<li><code>get_driver_nearby_accidents.php</code> - Get nearby accidents using stored driver location</li>";
echo "</ul>";

echo "<p><strong>Flutter Components:</strong></p>";
echo "<ul>";
echo "<li><code>LocationAccidentService</code> - Service for API calls</li>";
echo "<li><code>LocationAccidentProvider</code> - State management</li>";
echo "<li><code>NearbyAccidentsWidget</code> - UI widget for displaying nearby accidents</li>";
echo "<li><code>NearbyAccidentsScreen</code> - Full screen for nearby accidents</li>";
echo "</ul>";

echo "<p style='color: blue;'><strong>How it works:</strong></p>";
echo "<ol>";
echo "<li>Driver updates their location using GPS or manual input</li>";
echo "<li>System calculates distance to all pending accidents using Haversine formula</li>";
echo "<li>Only accidents within specified radius (default 10km) are shown to the driver</li>";
echo "<li>Accidents are sorted by distance (closest first)</li>";
echo "<li>Driver can adjust search radius (5km, 10km, 15km, 20km)</li>";
echo "</ol>";
?>
