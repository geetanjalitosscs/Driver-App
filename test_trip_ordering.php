<?php
require_once 'db_config.php';

try {
    $pdo = getDatabaseConnection();
    
    echo "<h2>Current Trip Data (All Trips)</h2>";
    $stmt = $pdo->query("
        SELECT 
            history_id, 
            client_name, 
            timing, 
            start_time, 
            end_time, 
            created_at,
            COALESCE(end_time, start_time, created_at) as sort_time
        FROM trips 
        ORDER BY COALESCE(end_time, start_time, created_at) DESC
    ");
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<table border='1' style='border-collapse: collapse; width: 100%;'>";
    echo "<tr><th>ID</th><th>Client</th><th>Timing</th><th>Start Time</th><th>End Time</th><th>Created At</th><th>Sort Time</th></tr>";
    
    foreach ($trips as $trip) {
        echo "<tr>";
        echo "<td>{$trip['history_id']}</td>";
        echo "<td>{$trip['client_name']}</td>";
        echo "<td>{$trip['timing']}</td>";
        echo "<td>{$trip['start_time']}</td>";
        echo "<td>{$trip['end_time']}</td>";
        echo "<td>{$trip['created_at']}</td>";
        echo "<td>{$trip['sort_time']}</td>";
        echo "</tr>";
    }
    echo "</table>";
    
    echo "<h2>Testing Different Ordering Methods</h2>";
    
    // Test 1: Order by timing DESC
    echo "<h3>1. Order by timing DESC</h3>";
    $stmt = $pdo->query("SELECT history_id, client_name, timing FROM trips ORDER BY timing DESC LIMIT 5");
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo "<ul>";
    foreach ($trips as $trip) {
        echo "<li>ID: {$trip['history_id']}, Client: {$trip['client_name']}, Timing: {$trip['timing']}</li>";
    }
    echo "</ul>";
    
    // Test 2: Order by start_time DESC
    echo "<h3>2. Order by start_time DESC</h3>";
    $stmt = $pdo->query("SELECT history_id, client_name, start_time FROM trips ORDER BY start_time DESC LIMIT 5");
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo "<ul>";
    foreach ($trips as $trip) {
        echo "<li>ID: {$trip['history_id']}, Client: {$trip['client_name']}, Start: {$trip['start_time']}</li>";
    }
    echo "</ul>";
    
    // Test 3: Order by end_time DESC
    echo "<h3>3. Order by end_time DESC</h3>";
    $stmt = $pdo->query("SELECT history_id, client_name, end_time FROM trips ORDER BY end_time DESC LIMIT 5");
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo "<ul>";
    foreach ($trips as $trip) {
        echo "<li>ID: {$trip['history_id']}, Client: {$trip['client_name']}, End: {$trip['end_time']}</li>";
    }
    echo "</ul>";
    
    // Test 4: Order by created_at DESC
    echo "<h3>4. Order by created_at DESC</h3>";
    $stmt = $pdo->query("SELECT history_id, client_name, created_at FROM trips ORDER BY created_at DESC LIMIT 5");
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo "<ul>";
    foreach ($trips as $trip) {
        echo "<li>ID: {$trip['history_id']}, Client: {$trip['client_name']}, Created: {$trip['created_at']}</li>";
    }
    echo "</ul>";
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?>
