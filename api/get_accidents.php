<?php
require_once '../db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
    
    // Fetch accidents
    $stmt = $pdo->prepare("SELECT * FROM accidents WHERE status = 'pending' ORDER BY created_at DESC");
    $stmt->execute();
    $accidents = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Fetch photos for each accident
    foreach ($accidents as &$accident) {
        $photoStmt = $pdo->prepare("SELECT photo FROM accident_photos WHERE accident_id = ?");
        $photoStmt->execute([$accident['id']]);
        $photos = $photoStmt->fetchAll(PDO::FETCH_COLUMN);
        $accident['photos'] = $photos;
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
