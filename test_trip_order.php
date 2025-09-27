<?php
require_once 'db_config.php';

try {
    $pdo = getDatabaseConnection();
    
    echo "<h2>Current Trip Ordering Test</h2>";
    
    // Test 1: Order by end_time DESC (most recent first)
    echo "<h3>1. Order by end_time DESC (Most Recent First)</h3>";
    $stmt = $pdo->query("
        SELECT 
            history_id, 
            client_name, 
            end_time, 
            created_at,
            amount
        FROM trips 
        WHERE end_time IS NOT NULL 
        ORDER BY end_time DESC
        LIMIT 10
    ");
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<table border='1' style='border-collapse: collapse; width: 100%;'>";
    echo "<tr><th>ID</th><th>Client</th><th>End Time</th><th>Created At</th><th>Amount</th></tr>";
    
    foreach ($trips as $trip) {
        echo "<tr>";
        echo "<td>{$trip['history_id']}</td>";
        echo "<td>{$trip['client_name']}</td>";
        echo "<td>{$trip['end_time']}</td>";
        echo "<td>{$trip['created_at']}</td>";
        echo "<td>₹{$trip['amount']}</td>";
        echo "</tr>";
    }
    echo "</table>";
    
    // Test 2: Order by created_at DESC
    echo "<h3>2. Order by created_at DESC</h3>";
    $stmt = $pdo->query("
        SELECT 
            history_id, 
            client_name, 
            end_time, 
            created_at,
            amount
        FROM trips 
        WHERE end_time IS NOT NULL 
        ORDER BY created_at DESC
        LIMIT 10
    ");
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<table border='1' style='border-collapse: collapse; width: 100%;'>";
    echo "<tr><th>ID</th><th>Client</th><th>End Time</th><th>Created At</th><th>Amount</th></tr>";
    
    foreach ($trips as $trip) {
        echo "<tr>";
        echo "<td>{$trip['history_id']}</td>";
        echo "<td>{$trip['client_name']}</td>";
        echo "<td>{$trip['end_time']}</td>";
        echo "<td>{$trip['created_at']}</td>";
        echo "<td>₹{$trip['amount']}</td>";
        echo "</tr>";
    }
    echo "</table>";
    
    // Test 3: Check if dates are being parsed correctly
    echo "<h3>3. Date Parsing Test</h3>";
    $stmt = $pdo->query("
        SELECT 
            history_id, 
            client_name, 
            end_time,
            DATE(end_time) as end_date,
            TIME(end_time) as end_time_only,
            UNIX_TIMESTAMP(end_time) as timestamp
        FROM trips 
        WHERE end_time IS NOT NULL 
        ORDER BY end_time DESC
        LIMIT 5
    ");
    $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<table border='1' style='border-collapse: collapse; width: 100%;'>";
    echo "<tr><th>ID</th><th>Client</th><th>End Time</th><th>Date</th><th>Time</th><th>Timestamp</th></tr>";
    
    foreach ($trips as $trip) {
        echo "<tr>";
        echo "<td>{$trip['history_id']}</td>";
        echo "<td>{$trip['client_name']}</td>";
        echo "<td>{$trip['end_time']}</td>";
        echo "<td>{$trip['end_date']}</td>";
        echo "<td>{$trip['end_time_only']}</td>";
        echo "<td>{$trip['timestamp']}</td>";
        echo "</tr>";
    }
    echo "</table>";
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?>
