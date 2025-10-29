<?php
require_once './db_config.php';

setApiHeaders();

// Start session for OTP storage
// Check if session ID is provided in Cookie header
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

if (!$input || !isset($input['phone'])) {
    sendErrorResponse('Phone number is required');
}

$phone = $input['phone'];

// Validate phone number format
if (!preg_match('/^[6-9][0-9]{9}$/', $phone)) {
    sendErrorResponse('Invalid phone number format');
}

try {
    // Check if session already exists (resend case)
    $driverId = null;
    $driverName = null;
    
    if (isset($_SESSION['forgot_password_phone']) && $_SESSION['forgot_password_phone'] === $phone) {
        // Resend case - use existing session data
        $driverId = $_SESSION['forgot_password_driver_id'] ?? null;
        if ($driverId) {
            $stmt = $pdo->prepare("SELECT driver_name FROM drivers WHERE id = ?");
            $stmt->execute([$driverId]);
            $driver = $stmt->fetch(PDO::FETCH_ASSOC);
            if ($driver) {
                $driverName = $driver['driver_name'];
            }
        }
    }
    
    // If no session or driver not found, check by phone number
    if (!$driverId || !$driverName) {
        $stmt = $pdo->prepare("SELECT id, driver_name FROM drivers WHERE number = ?");
        $stmt->execute([$phone]);
        $driver = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$driver) {
            sendErrorResponse('Phone number not found in our records');
        }
        
        $driverId = $driver['id'];
        $driverName = $driver['driver_name'];
    }
    
    // Generate 4-digit OTP
    $otp = str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);
    
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
    
    // Send OTP via SMS
    $smsSent = sendOTP($phone, $otp, $driverName);
    if (!$smsSent) {
        error_log("Warning: Failed to send OTP SMS to $phone, but continuing...");
        // Continue anyway - OTP will be stored in session
    }
    
    // Store forgot password data and OTP in session (expires in 10 minutes)
    $_SESSION['forgot_password_phone'] = $phone;
    $_SESSION['forgot_password_otp'] = $otp;
    $_SESSION['forgot_password_otp_time'] = time();
    $_SESSION['forgot_password_driver_id'] = $driverId;
    
    error_log("Forgot Password - Session ID: " . session_id());
    error_log("Forgot Password - Cookie header: " . ($_SERVER['HTTP_COOKIE'] ?? 'NOT SET'));
    error_log("Forgot Password - Driver ID: $driverId, Driver Name: $driverName");
    error_log("Forgot Password OTP generated for phone $phone: $otp");
    
    // Return success with OTP sent message (include OTP for debugging - remove in production)
    echo json_encode([
        'success' => true,
        'message' => 'OTP sent successfully',
        'otp_sent' => true,
        'phone' => $phone,
        'debug_otp' => $otp  // For testing - shows OTP on screen
    ]);
    
} catch (PDOException $e) {
    error_log("Forgot Password - Database operation failed: " . $e->getMessage());
    sendErrorResponse('Database operation failed: ' . $e->getMessage());
}
?>
