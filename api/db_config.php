<?php
/**
 * Common Database Configuration
 * 
 * This file contains the database connection settings used by all PHP files.
 * Update these values to match your database setup.
 */

// Database connection settings
$db_config = [
    'host' => 'localhost',
    'dbname' => 'edueyeco_apatkal2',
    'username' => 'edueyeco_apatkal2',
    'password' => 'edueyeco_apatkal2',
    'charset' => 'utf8mb4'
];

// API Configuration - Centralized URL settings
$api_config = [
    'base_url' => 'https://tossconsultancyservices.com/apatkal/api/',
    'uploads_url' => 'https://tossconsultancyservices.com/apatkal/api/uploads/',
    'uploads_base_url' => 'https://tossconsultancyservices.com/apatkal/uploads/',
    'site_url' => 'https://tossconsultancyservices.com/apatkal/'
];

/**
 * Get database connection
 * 
 * @return PDO Database connection object
 * @throws PDOException If connection fails
 */
function getDatabaseConnection() {
    global $db_config;
    
    $dsn = "mysql:host={$db_config['host']};dbname={$db_config['dbname']};charset={$db_config['charset']}";
    
    $pdo = new PDO($dsn, $db_config['username'], $db_config['password']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    
    return $pdo;
}

/**
 * Test database connection
 * 
 * @return array Connection test result
 */
function testDatabaseConnection() {
    try {
        $pdo = getDatabaseConnection();
        return [
            'success' => true,
            'message' => 'Database connection successful',
            'host' => $db_config['host'],
            'database' => $db_config['dbname']
        ];
    } catch (PDOException $e) {
        return [
            'success' => false,
            'message' => 'Database connection failed: ' . $e->getMessage(),
            'error' => $e->getMessage()
        ];
    }
}

// Set common headers for API responses
function setApiHeaders() {
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    
    // Handle preflight OPTIONS request
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        exit(0);
    }
}

// Common error response function
function sendErrorResponse($message, $httpCode = 400) {
    http_response_code($httpCode);
    echo json_encode([
        'success' => false,
        'error' => $message
    ]);
    exit;
}

// Common success response function
function sendSuccessResponse($data, $message = 'Success') {
    echo json_encode([
        'success' => true,
        'message' => $message,
        'data' => $data
    ]);
    exit;
}

/**
 * Get API configuration
 * 
 * @return array API configuration array
 */
function getApiConfig() {
    global $api_config;
    return $api_config;
}

/**
 * Get uploads URL for a file
 * 
 * @param string $filename The filename
 * @return string Full URL to the uploaded file
 */
function getUploadsUrl($filename) {
    global $api_config;
    return $api_config['uploads_url'] . $filename;
}

/**
 * Get uploads base URL (without filename)
 * 
 * @return string Base uploads URL
 */
function getUploadsBaseUrl() {
    global $api_config;
    return $api_config['uploads_base_url'];
}

/**
 * Get API base URL
 * 
 * @return string API base URL
 */
function getApiBaseUrl() {
    global $api_config;
    return $api_config['base_url'];
}

/**
 * Get site URL
 * 
 * @return string Site URL
 */
function getSiteUrl() {
    global $api_config;
    return $api_config['site_url'];
}
?>
