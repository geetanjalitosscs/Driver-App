<?php
header("Content-Type: application/json");

// Test local database connection
$host = "localhost";
$dbname = "edueyeco_apatkal";
$username = "root";
$password = "";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo json_encode([
        "success" => true,
        "message" => "Database connection successful",
        "database" => $dbname
    ]);
    
} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "error" => "Database connection failed: " . $e->getMessage(),
        "database" => $dbname
    ]);
}
?>
