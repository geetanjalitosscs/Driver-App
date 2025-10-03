<?php
require_once './db_config.php';

try {
    $pdo = getDatabaseConnection();
    
    echo "=== VERIFYING API RESULTS ===\n";
    
    // Test the exact API query
    $stmt = $pdo->prepare("
        SELECT a.id, a.vehicle, a.status, a.driver_status, a.created_at
        FROM accidents a 
        INNER JOIN clients c ON LOWER(a.vehicle) COLLATE utf8mb4_general_ci = LOWER(c.vehicle_no) COLLATE utf8mb4_general_ci
        WHERE a.status = 'pending' 
        AND (a.driver_status IS NULL OR a.driver_status = 'available')
        ORDER BY a.created_at DESC
    ");
    $stmt->execute();
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "API query results: " . count($results) . " accidents\n";
    foreach ($results as $result) {
        echo "ID: {$result['id']}, Vehicle: '{$result['vehicle']}', Status: '{$result['status']}', Driver Status: " . ($result['driver_status'] ?? 'NULL') . ", Created: {$result['created_at']}\n";
    }
    
    echo "\n";
    
    // Check each potential match individually
    $potentialMatches = [
        ['id' => 0, 'vehicle' => 'Mp20ZB6308'],
        ['id' => 30, 'vehicle' => 'MP20PH2265'],
        ['id' => 35, 'vehicle' => 'MP20PH2265'],
        ['id' => 38, 'vehicle' => 'mp20ab2010'],
        ['id' => 40, 'vehicle' => 'Mp20nm2713']
    ];
    
    echo "=== CHECKING EACH POTENTIAL MATCH ===\n";
    foreach ($potentialMatches as $accident) {
        $stmt = $pdo->prepare("
            SELECT a.id, a.vehicle, a.status, a.driver_status 
            FROM accidents a 
            INNER JOIN clients c ON LOWER(a.vehicle) COLLATE utf8mb4_general_ci = LOWER(c.vehicle_no) COLLATE utf8mb4_general_ci
            WHERE a.id = ? AND a.status = 'pending' 
            AND (a.driver_status IS NULL OR a.driver_status = 'available')
        ");
        $stmt->execute([$accident['id']]);
        $match = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($match) {
            echo "✅ ID {$accident['id']} ('{$accident['vehicle']}') - MATCHES\n";
        } else {
            echo "❌ ID {$accident['id']} ('{$accident['vehicle']}') - NO MATCH\n";
        }
    }
    
} catch (PDOException $e) {
    echo "Database error: " . $e->getMessage() . "\n";
}
?>
