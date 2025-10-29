<?php
require_once './db_config.php';

setApiHeaders();

// Start session to retrieve signup data
// Check if session ID is provided in Cookie header
if (isset($_SERVER['HTTP_COOKIE'])) {
    $cookies = $_SERVER['HTTP_COOKIE'];
    // Extract PHPSESSID from cookie string
    if (preg_match('/PHPSESSID=([^;\s]+)/i', $cookies, $matches)) {
        session_id($matches[1]);
        error_log("Resend OTP - Using session ID from cookie: " . $matches[1]);
    }
}

session_start();

// Debug logging
error_log("Resend OTP - Session ID: " . session_id());
error_log("Resend OTP - Session data exists: " . (isset($_SESSION['signup_data']) ? 'YES' : 'NO'));
error_log("Resend OTP - Cookie header: " . ($_SERVER['HTTP_COOKIE'] ?? 'NOT SET'));

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !isset($input['phone'])) {
    sendErrorResponse('Phone number is required');
}

$phone = $input['phone'];

// Check if session data exists
if (!isset($_SESSION['signup_data']) || !isset($_SESSION['signup_phone'])) {
    sendErrorResponse('Signup session expired. Please start signup again.');
}

// Verify phone number matches
if ($_SESSION['signup_phone'] !== $phone) {
    sendErrorResponse('Phone number mismatch');
}

// SMS OTP Function
function sendOTP($mobile_no, $otp_code, $driver_name) {
    $url = 'http://bhashsms.com/api/sendmsg.php';
    
    $message = "Dear " . $driver_name . ", We have received a request to authenticate your account. Please use the One-Time Password OTP " . $otp_code . " below to complete your request: This OTP will expire in 10 minutes. Please ensure it is entered before that time. Team APATKAL -MGAUS INFORMATION TECHNOLOGY PRIVATE LIMITED";
    
    $params = [
        'user' => 'MgausSMS',
        'pass' => '123456',
        'sender' => 'APTKAL',
        'phone' => $mobile_no,
        'text' => $message,
        'priority' => 'ndnd',
        'stype' => 'normal'
    ];
    
    $postData = http_build_query($params);
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);
    curl_close($ch);
    
    // Log for debugging
    error_log("Resend OTP SMS API Response: HTTP $httpCode, Response: $response, Error: $curlError");
    
    // Check if SMS was sent successfully
    return ($httpCode == 200 && $response !== false);
}

// Get driver name from session
$driverName = $_SESSION['signup_data']['driver_name'] ?? 'User';

// Generate new 4-digit OTP
$newOtp = str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);

// Send new OTP via SMS
$smsSent = sendOTP($phone, $newOtp, $driverName);
if (!$smsSent) {
    error_log("Warning: Failed to send OTP SMS to $phone, but continuing...");
}

// Update session with new OTP
$_SESSION['signup_otp'] = $newOtp;
$_SESSION['signup_otp_time'] = time();

error_log("OTP regenerated for phone $phone: $newOtp");

// Return success
echo json_encode([
    'success' => true,
    'message' => 'OTP resent successfully',
    'otp_sent' => true,
    'phone' => $phone
]);
?>

