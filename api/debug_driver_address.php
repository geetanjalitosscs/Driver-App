<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
    
    // Get driver ID from query parameter
    $driver_id = isset($_GET['driver_id']) ? (int)$_GET['driver_id'] : 1;
    
    // Get driver data
    $stmt = $pdo->prepare("SELECT id, driver_name, email, number, address FROM drivers WHERE id = ?");
    $stmt->execute([$driver_id]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($driver) {
        echo json_encode([
            'success' => true,
            'driver' => $driver,
            'address_value' => $driver['address'],
            'address_is_null' => is_null($driver['address']),
            'address_is_empty' => empty($driver['address']),
            'address_length' => strlen($driver['address'] ?? '')
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Driver not found'
        ]);
    }
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
?>
