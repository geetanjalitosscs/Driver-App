<?php
require_once './db_config.php';

setApiHeaders();

// Start session for OTP storage
session_start();

try {
    $pdo = getDatabaseConnection();
} catch (PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input) {
    sendErrorResponse('Invalid input data');
}

// Validate required fields
$requiredFields = ['driver_name', 'email', 'password', 'number', 'address', 'vehicle_type', 'vehicle_number', 'aadhar_photo', 'licence_photo', 'rc_photo', 'account_number', 'bank_name', 'ifsc_code', 'account_holder_name'];
foreach ($requiredFields as $field) {
    if (!isset($input[$field]) || empty($input[$field])) {
        sendErrorResponse("Field '$field' is required");
    }
}

$driverName = $input['driver_name'];
$email = $input['email'];
$password = $input['password'];
$phone = $input['number'];
$address = $input['address'];
$vehicleType = $input['vehicle_type'];
$vehicleNumber = $input['vehicle_number'];
$aadharPhoto = $input['aadhar_photo'];
$licencePhoto = $input['licence_photo'];
$rcPhoto = $input['rc_photo'];

// Account details
$accountNumber = $input['account_number'];
$bankName = $input['bank_name'];
$ifscCode = $input['ifsc_code'];
$accountHolderName = $input['account_holder_name'];

// Validate email format
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    sendErrorResponse('Invalid email format');
}

// Validate password length
if (strlen($password) < 6) {
    sendErrorResponse('Password must be at least 6 characters long');
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
    
    // Log for debugging (remove in production)
    error_log("SMS API Response: HTTP $httpCode, Response: $response, Error: $curlError");
    
    // Check if SMS was sent successfully
    return ($httpCode == 200 && $response !== false);
}

try {
    // Check if email already exists
    $stmt = $pdo->prepare("SELECT id FROM drivers WHERE email = ?");
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        sendErrorResponse('Email already exists');
    }

    // Check if phone already exists
    $stmt = $pdo->prepare("SELECT id FROM drivers WHERE number = ?");
    $stmt->execute([$phone]);
    if ($stmt->fetch()) {
        sendErrorResponse('Phone number already exists');
    }

    // Generate 4-digit OTP
    $otp = str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);
    
    // Send OTP via SMS
    $smsSent = sendOTP($phone, $otp, $driverName);
    if (!$smsSent) {
        error_log("Warning: Failed to send OTP SMS to $phone, but continuing...");
        // Continue anyway - OTP will be stored in session
    }
    
    // Store signup data and OTP in session (expires in 10 minutes)
    $_SESSION['signup_data'] = $input;
    $_SESSION['signup_otp'] = $otp;
    $_SESSION['signup_otp_time'] = time();
    $_SESSION['signup_phone'] = $phone;
    
    error_log("OTP generated for phone $phone: $otp");
    
    // Return success with OTP sent message
    echo json_encode([
        'success' => true,
        'message' => 'OTP sent successfully',
        'otp_sent' => true,
        'phone' => $phone
    ]);
    exit;

} catch (PDOException $e) {
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>
