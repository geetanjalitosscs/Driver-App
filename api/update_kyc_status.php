<?php
require_once './db_config.php';
require_once './send_notification.php';

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
$requiredFields = ['driver_id', 'kyc_status', 'admin_key'];
foreach ($requiredFields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        sendErrorResponse("Field '$field' is required");
    }
}

$driver_id = (int)$input['driver_id'];
$kyc_status = $input['kyc_status'];
$admin_key = $input['admin_key'];

// Validate admin key (in production, use proper authentication)
if ($admin_key !== 'admin123') {
    sendErrorResponse('Unauthorized access');
}

// Validate KYC status
if (!in_array($kyc_status, ['pending', 'approved', 'rejected'])) {
    sendErrorResponse('Invalid KYC status. Must be: pending, approved, or rejected');
}

try {
    // Connect to database
    $pdo = getDatabaseConnection();
    
    // Check if driver exists
    $stmt = $pdo->prepare("SELECT id, driver_name, email, number, kyc_status FROM drivers WHERE id = ?");
    $stmt->execute([$driver_id]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$driver) {
        sendErrorResponse('Driver not found');
    }
    
    // Check if status is actually changing
    if ($driver['kyc_status'] === $kyc_status) {
        echo json_encode([
            'success' => true,
            'message' => 'KYC status unchanged',
            'data' => [
                'driver_id' => $driver_id,
                'kyc_status' => $kyc_status,
                'driver_name' => $driver['driver_name']
            ]
        ]);
        exit;
    }
    
    // Update KYC status
    $stmt = $pdo->prepare("UPDATE drivers SET kyc_status = ? WHERE id = ?");
    $result = $stmt->execute([$kyc_status, $driver_id]);
    
    if (!$result) {
        sendErrorResponse('Failed to update KYC status');
    }
    
    // Send notification based on status
    $notification_sent = false;
    $notification_message = '';
    
    if ($kyc_status === 'approved') {
        $notification_message = 'Your KYC Verification is approved! You can now use your profile and access all app features.';
        
        // Send system notification
        $notification_data = [
            'driver_id' => $driver_id,
            'title' => 'KYC Verification Approved',
            'message' => $notification_message,
            'type' => 'kyc_approved',
            'action_data' => [
                'action' => 'navigate_to_login',
                'kyc_status' => 'approved'
            ]
        ];
        
        $notification_result = sendNotification($notification_data);
        $notification_sent = $notification_result['success'] ?? false;
        
        // Log the approval
        error_log("KYC Approved: Driver ID $driver_id, Name: {$driver['driver_name']}, Email: {$driver['email']}");
        
    } elseif ($kyc_status === 'rejected') {
        $notification_message = 'Your KYC Verification has been rejected. Please contact support for more information.';
        
        // Send system notification
        $notification_data = [
            'driver_id' => $driver_id,
            'title' => 'KYC Verification Rejected',
            'message' => $notification_message,
            'type' => 'kyc_rejected',
            'action_data' => [
                'action' => 'navigate_to_help',
                'kyc_status' => 'rejected'
            ]
        ];
        
        $notification_result = sendNotification($notification_data);
        $notification_sent = $notification_result['success'] ?? false;
        
        // Log the rejection
        error_log("KYC Rejected: Driver ID $driver_id, Name: {$driver['driver_name']}, Email: {$driver['email']}");
    }
    
    // Return success response
    echo json_encode([
        'success' => true,
        'message' => 'KYC status updated successfully',
        'data' => [
            'driver_id' => $driver_id,
            'driver_name' => $driver['driver_name'],
            'email' => $driver['email'],
            'old_status' => $driver['kyc_status'],
            'new_status' => $kyc_status,
            'notification_sent' => $notification_sent,
            'notification_message' => $notification_message
        ]
    ]);

} catch (PDOException $e) {
    sendErrorResponse('Database error: ' . $e->getMessage());
} catch (Exception $e) {
    sendErrorResponse('Server error: ' . $e->getMessage());
}
?>
