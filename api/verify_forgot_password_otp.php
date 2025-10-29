<?php
require_once './db_config.php';

setApiHeaders();

// Start session to retrieve OTP
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

if (!$input || !isset($input['otp']) || !isset($input['phone'])) {
    sendErrorResponse('OTP and phone number are required');
}

$enteredOtp = $input['otp'];
$phone = $input['phone'];

// Debug logging
error_log("Verify Forgot Password OTP - Session ID: " . session_id());
error_log("Verify Forgot Password OTP - Session keys: " . implode(', ', array_keys($_SESSION)));
error_log("Verify Forgot Password OTP - Cookie header: " . ($_SERVER['HTTP_COOKIE'] ?? 'NOT SET'));

// Check if session data exists
if (!isset($_SESSION['forgot_password_phone']) || !isset($_SESSION['forgot_password_otp']) || !isset($_SESSION['forgot_password_otp_time'])) {
    error_log("Verify Forgot Password OTP - Session data missing");
    error_log("Verify Forgot Password OTP - Phone in session: " . ($_SESSION['forgot_password_phone'] ?? 'NOT SET'));
    error_log("Verify Forgot Password OTP - OTP in session: " . (isset($_SESSION['forgot_password_otp']) ? 'SET' : 'NOT SET'));
    sendErrorResponse('OTP session expired. Please request a new one.');
}

// Verify phone number matches
if ($_SESSION['forgot_password_phone'] !== $phone) {
    error_log("Verify Forgot Password OTP - Phone mismatch. Expected: " . $_SESSION['forgot_password_phone'] . ", Got: $phone");
    sendErrorResponse('Phone number mismatch');
}

// Check OTP expiration (10 minutes = 600 seconds)
$otpAge = time() - $_SESSION['forgot_password_otp_time'];
if ($otpAge > 600) {
    unset($_SESSION['forgot_password_phone']);
    unset($_SESSION['forgot_password_otp']);
    unset($_SESSION['forgot_password_otp_time']);
    unset($_SESSION['forgot_password_driver_id']);
    sendErrorResponse('OTP has expired. Please request a new one.');
}

// Debug: Log OTP comparison (without logging actual values for security)
error_log("Verify Forgot Password OTP - OTP length match: " . (strlen($_SESSION['forgot_password_otp']) === strlen($enteredOtp) ? 'YES' : 'NO'));
error_log("Verify Forgot Password OTP - OTP entered: " . str_pad('', strlen($enteredOtp), '*'));

// Verify OTP
if ($_SESSION['forgot_password_otp'] !== $enteredOtp) {
    error_log("Verify Forgot Password OTP - OTP mismatch. Stored OTP length: " . strlen($_SESSION['forgot_password_otp']) . ", Entered OTP length: " . strlen($enteredOtp));
    sendErrorResponse('Invalid OTP. Please check and try again.');
}

// OTP verified successfully
// Mark the session as verified for password reset
$_SESSION['forgot_password_verified'] = true;

echo json_encode([
    'success' => true,
    'message' => 'OTP verified successfully',
    'verified' => true
]);
?>
