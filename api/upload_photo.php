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

// Check if file was uploaded
if (!isset($_FILES['photo']) || $_FILES['photo']['error'] !== UPLOAD_ERR_OK) {
    $error_messages = [
        UPLOAD_ERR_INI_SIZE => 'File too large (exceeds upload_max_filesize)',
        UPLOAD_ERR_FORM_SIZE => 'File too large (exceeds MAX_FILE_SIZE)',
        UPLOAD_ERR_PARTIAL => 'File was only partially uploaded',
        UPLOAD_ERR_NO_FILE => 'No file was uploaded',
        UPLOAD_ERR_NO_TMP_DIR => 'Missing temporary folder',
        UPLOAD_ERR_CANT_WRITE => 'Failed to write file to disk',
        UPLOAD_ERR_EXTENSION => 'File upload stopped by extension'
    ];
    
    $error_code = $_FILES['photo']['error'] ?? UPLOAD_ERR_NO_FILE;
    $error_message = $error_messages[$error_code] ?? 'Unknown upload error';
    sendErrorResponse("Upload failed: $error_message");
}

// Get form data
$driver_id = isset($_POST['driver_id']) ? (int)$_POST['driver_id'] : 0;
$photo_type = isset($_POST['photo_type']) ? $_POST['photo_type'] : '';

// Validate inputs
if ($driver_id <= 0) {
    sendErrorResponse('Invalid driver ID');
}

if (!in_array($photo_type, ['aadhar', 'licence', 'rc'])) {
    sendErrorResponse('Invalid photo type. Must be: aadhar, licence, or rc');
}

$file = $_FILES['photo'];

// Validate file type
$allowed_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
$file_type = mime_content_type($file['tmp_name']);

if (!in_array($file_type, $allowed_types)) {
    sendErrorResponse('Invalid file type. Only JPEG, PNG, and GIF images are allowed');
}

// Validate file size (max 5MB)
$max_size = 5 * 1024 * 1024; // 5MB
if ($file['size'] > $max_size) {
    sendErrorResponse('File too large. Maximum size is 5MB');
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
    $file_extension = pathinfo($file['name'], PATHINFO_EXTENSION);
    $unique_filename = $driver_id . '_' . $photo_type . '_' . time() . '_' . uniqid() . '.' . $file_extension;
    $file_path = $uploads_dir . $unique_filename;
    
    // Move uploaded file to uploads directory
    if (!move_uploaded_file($file['tmp_name'], $file_path)) {
        sendErrorResponse('Failed to save uploaded file');
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
    error_log("Photo uploaded successfully: Driver ID $driver_id, Type: $photo_type, File: $unique_filename, Size: $file_size bytes");
    
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
            'mime_type' => $file_type,
            'original_name' => $file['name']
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
