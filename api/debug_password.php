<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
    
    // Get driver by email
    $stmt = $pdo->prepare("SELECT id, driver_name, email, password FROM drivers WHERE email = ?");
    $stmt->execute(['rajesh.sharma90@gmail.com']);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($driver) {
        echo json_encode([
            'success' => true,
            'driver_id' => $driver['id'],
            'driver_name' => $driver['driver_name'],
            'email' => $driver['email'],
            'password_hash' => $driver['password'],
            'password_length' => strlen($driver['password'])
        ]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Driver not found']);
    }
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
?>
