<?php
require_once './db_config.php';

try {
    $pdo = getDatabaseConnection();
    
    echo "=== INVESTIGATING DUPLICATE VEHICLE NUMBERS ===\n";
    
    // Check all accidents with the same vehicle numbers as the matching ones
    $stmt = $pdo->prepare("
        SELECT id, vehicle, status, driver_status, created_at 
        FROM accidents 
        WHERE vehicle IN ('MP20PH2265', 'mp20ab2010') 
        ORDER BY vehicle, created_at DESC
    ");
    $stmt->execute();
    $duplicates = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "All accidents with matching vehicle numbers:\n";
    foreach ($duplicates as $accident) {
        echo "ID: {$accident['id']}, Vehicle: '{$accident['vehicle']}', Status: '{$accident['status']}', Driver Status: " . ($accident['driver_status'] ?? 'NULL') . ", Created: {$accident['created_at']}\n";
    }
    
    echo "\n";
    
    // Check what the API query returns
    $stmt = $pdo->prepare("
        SELECT a.id, a.vehicle, a.status, a.driver_status, a.created_at
        FROM accidents a 
        INNER JOIN clients c ON LOWER(a.vehicle) = LOWER(c.vehicle_no)
        WHERE a.status = 'pending' 
        AND (a.driver_status IS NULL OR a.driver_status = 'available')
        ORDER BY a.created_at DESC
    ");
    $stmt->execute();
    $apiResults = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "API query results:\n";
    foreach ($apiResults as $result) {
        echo "ID: {$result['id']}, Vehicle: '{$result['vehicle']}', Status: '{$result['status']}', Driver Status: " . ($result['driver_status'] ?? 'NULL') . ", Created: {$result['created_at']}\n";
    }
    
    echo "\n";
    
    // Check if there are any accidents with driver_status = 'assigned' or 'completed'
    $stmt = $pdo->prepare("
        SELECT id, vehicle, status, driver_status, created_at 
        FROM accidents 
        WHERE vehicle IN ('MP20PH2265', 'mp20ab2010') 
        AND driver_status IN ('assigned', 'completed')
        ORDER BY vehicle, created_at DESC
    ");
    $stmt->execute();
    $assigned = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "Accidents with assigned/completed status:\n";
    foreach ($assigned as $accident) {
        echo "ID: {$accident['id']}, Vehicle: '{$accident['vehicle']}', Status: '{$accident['status']}', Driver Status: '{$accident['driver_status']}', Created: {$accident['created_at']}\n";
    }
    
    echo "\n";
    
    // Check the most recent accidents
    $stmt = $pdo->prepare("
        SELECT id, vehicle, status, driver_status, created_at 
        FROM accidents 
        ORDER BY created_at DESC 
        LIMIT 10
    ");
    $stmt->execute();
    $recent = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "Most recent 10 accidents:\n";
    foreach ($recent as $accident) {
        echo "ID: {$accident['id']}, Vehicle: '{$accident['vehicle']}', Status: '{$accident['status']}', Driver Status: " . ($accident['driver_status'] ?? 'NULL') . ", Created: {$accident['created_at']}\n";
    }
    
} catch (PDOException $e) {
    echo "Database error: " . $e->getMessage() . "\n";
}
?>
