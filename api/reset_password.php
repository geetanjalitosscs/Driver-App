<?php
require_once './db_config.php';

setApiHeaders();

// Start session to verify reset is authorized
if (isset($_SERVER['HTTP_COOKIE'])) {
    $cookies = $_SERVER['HTTP_COOKIE'];
    if (preg_match('/PHPSESSID=([^;\s]+)/i', $cookies, $matches)) {
        session_id($matches[1]);
    }
}

session_start();

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !isset($input['phone']) || !isset($input['new_password'])) {
    sendErrorResponse('Phone number and new password are required');
}

$phone = $input['phone'];
$newPassword = $input['new_password'];

// Validate password length
if (strlen($newPassword) < 6) {
    sendErrorResponse('Password must be at least 6 characters long');
}

// Check if session is verified
if (!isset($_SESSION['forgot_password_verified']) || $_SESSION['forgot_password_verified'] !== true) {
    sendErrorResponse('OTP verification required. Please verify OTP first.');
}

// Check if phone number matches
if (!isset($_SESSION['forgot_password_phone']) || $_SESSION['forgot_password_phone'] !== $phone) {
    sendErrorResponse('Phone number mismatch');
}

$driverId = $_SESSION['forgot_password_driver_id'] ?? null;

if (!$driverId) {
    sendErrorResponse('Session expired. Please start the password reset process again.');
}

try {
    // Hash the new password
    $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
    
    // Update password in database
    $stmt = $pdo->prepare("UPDATE drivers SET password = ? WHERE id = ?");
    $stmt->execute([$hashedPassword, $driverId]);
    
    if ($stmt->rowCount() === 0) {
        sendErrorResponse('Failed to update password. Driver not found.');
    }
    
    // Clear forgot password session data
    unset($_SESSION['forgot_password_phone']);
    unset($_SESSION['forgot_password_otp']);
    unset($_SESSION['forgot_password_otp_time']);
    unset($_SESSION['forgot_password_driver_id']);
    unset($_SESSION['forgot_password_verified']);
    
    error_log("Password reset successful for driver ID: $driverId");
    
    echo json_encode([
        'success' => true,
        'message' => 'Password reset successfully'
    ]);
    
} catch (PDOException $e) {
    error_log("Reset Password - Database operation failed: " . $e->getMessage());
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>

