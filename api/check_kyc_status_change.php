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
$requiredFields = ['driver_id'];
foreach ($requiredFields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        sendErrorResponse("Field '$field' is required");
    }
}

$driver_id = (int)$input['driver_id'];

try {
    // Connect to database
    $pdo = getDatabaseConnection();
    
    // Get current KYC status
    $stmt = $pdo->prepare("SELECT id, driver_name, email, kyc_status FROM drivers WHERE id = ?");
    $stmt->execute([$driver_id]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$driver) {
        sendErrorResponse('Driver not found');
    }
    
    // Check if there's a previous status stored in a simple file
    $status_file = "kyc_status_{$driver_id}.txt";
    $previous_status = null;
    
    if (file_exists($status_file)) {
        $previous_status = trim(file_get_contents($status_file));
    }
    
    $current_status = $driver['kyc_status'];
    
    // Update the status file
    file_put_contents($status_file, $current_status);
    
    // Check if status changed
    $status_changed = ($previous_status !== null && $previous_status !== $current_status);
    
    // Prepare notification data
    $notification_data = [
        'driver_id' => $driver_id,
        'driver_name' => $driver['driver_name'],
        'email' => $driver['email'],
        'kyc_status' => $current_status,
        'status_changed' => $status_changed,
        'previous_status' => $previous_status,
        'timestamp' => date('Y-m-d H:i:s')
    ];
    
    // Add notification message based on status
    if ($current_status === 'approved') {
        $notification_data['title'] = '✅ KYC Verification Approved';
        $notification_data['message'] = 'Your KYC Verification is approved! You can now use your profile and access all app features.';
        $notification_data['type'] = 'success';
    } elseif ($current_status === 'rejected') {
        $notification_data['title'] = '❌ KYC Verification Rejected';
        $notification_data['message'] = 'Your KYC Verification has been rejected. Please contact support for more information.';
        $notification_data['type'] = 'error';
    } else {
        $notification_data['title'] = '⏳ KYC Verification Pending';
        $notification_data['message'] = 'Your KYC Verification is still pending. Please wait for admin approval.';
        $notification_data['type'] = 'warning';
    }
    
    // Log the status check
    error_log("KYC Status Check: Driver ID $driver_id, Status: $current_status, Changed: " . ($status_changed ? 'Yes' : 'No'));
    
    // Return response
    echo json_encode([
        'success' => true,
        'message' => 'KYC status checked successfully',
        'data' => $notification_data
    ]);
    
} catch (Exception $e) {
    error_log("Error checking KYC status: " . $e->getMessage());
    sendErrorResponse('Failed to check KYC status: ' . $e->getMessage());
}

function sendErrorResponse($message) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $message
    ]);
    exit;
}

function setApiHeaders() {
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    
    // Handle preflight requests
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        http_response_code(200);
        exit();
    }
}
?>

