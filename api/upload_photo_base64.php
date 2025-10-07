<?php
require_once './db_config.php';

setApiHeaders();

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Check if request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendErrorResponse('Only POST method is allowed');
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input) {
    sendErrorResponse('Invalid input data');
}

// Validate required fields
$requiredFields = ['driver_id', 'photo_type', 'photo_data'];
foreach ($requiredFields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        sendErrorResponse("Field '$field' is required");
    }
}

$driver_id = (int)$input['driver_id'];
$photo_type = $input['photo_type'];
$photo_data = $input['photo_data'];

// Validate inputs
if ($driver_id <= 0) {
    sendErrorResponse('Invalid driver ID');
}

if (!in_array($photo_type, ['aadhar', 'licence', 'rc'])) {
    sendErrorResponse('Invalid photo type. Must be: aadhar, licence, or rc');
}

// Validate base64 data
if (!preg_match('/^data:image\/(jpeg|jpg|png|gif);base64,/', $photo_data)) {
    sendErrorResponse('Invalid photo data format. Expected base64 encoded image');
}

// Extract image data and type
$image_data = explode(',', $photo_data);
$image_info = explode(';', $image_data[0]);
$image_type = explode('/', $image_info[0])[1];
$base64_data = $image_data[1];

// Decode base64 data
$decoded_data = base64_decode($base64_data);

if ($decoded_data === false) {
    sendErrorResponse('Failed to decode base64 image data');
}

// Validate file size (max 5MB)
$max_size = 5 * 1024 * 1024; // 5MB
if (strlen($decoded_data) > $max_size) {
    sendErrorResponse('Image too large. Maximum size is 5MB');
}

try {
    // Connect to database
    $pdo = getDatabaseConnection();
    
    // Check if driver exists
    $stmt = $pdo->prepare("SELECT id, driver_name FROM drivers WHERE id = ?");
    $stmt->execute([$driver_id]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$driver) {
        sendErrorResponse('Driver not found');
    }
    
    // Create uploads directory if it doesn't exist
    $uploads_dir = __DIR__ . '/uploads/';
    if (!is_dir($uploads_dir)) {
        if (!mkdir($uploads_dir, 0755, true)) {
            sendErrorResponse('Failed to create uploads directory');
        }
    }
    
    // Generate unique filename
    $unique_filename = $driver_id . '_' . $photo_type . '_' . time() . '_' . uniqid() . '.' . $image_type;
    $file_path = $uploads_dir . $unique_filename;
    
    // Save decoded data to file
    if (file_put_contents($file_path, $decoded_data) === false) {
        sendErrorResponse('Failed to save image file');
    }
    
    // Update database with new photo filename
    $stmt = $pdo->prepare("UPDATE drivers SET {$photo_type}_photo = ? WHERE id = ?");
    $result = $stmt->execute([$unique_filename, $driver_id]);
    
    if (!$result) {
        // If database update fails, delete the uploaded file
        unlink($file_path);
        sendErrorResponse('Failed to update database with photo information');
    }
    
    // Get file info
    $file_size = filesize($file_path);
    $photo_url = 'http://localhost/Driver-App/uploads/' . $unique_filename;
    
    // Log successful upload
    error_log("Base64 photo uploaded successfully: Driver ID $driver_id, Type: $photo_type, File: $unique_filename, Size: $file_size bytes");
    
    // Return success response
    echo json_encode([
        'success' => true,
        'message' => 'Photo uploaded successfully',
        'data' => [
            'driver_id' => $driver_id,
            'photo_type' => $photo_type,
            'filename' => $unique_filename,
            'photo_url' => $photo_url,
            'file_size' => $file_size,
            'mime_type' => 'image/' . $image_type,
            'format' => 'base64'
        ]
    ]);

} catch (PDOException $e) {
    // If database error, try to delete the uploaded file
    if (isset($file_path) && file_exists($file_path)) {
        unlink($file_path);
    }
    sendErrorResponse('Database error: ' . $e->getMessage());
} catch (Exception $e) {
    // If any other error, try to delete the uploaded file
    if (isset($file_path) && file_exists($file_path)) {
        unlink($file_path);
    }
    sendErrorResponse('Server error: ' . $e->getMessage());
}
?>
