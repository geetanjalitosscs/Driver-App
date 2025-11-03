<?php
// Enable error reporting for debugging (remove in production or set to 0)
error_reporting(E_ALL);
ini_set('display_errors', 0); // Don't display errors to users
ini_set('log_errors', 1);

require_once './db_config.php';

setApiHeaders();

// SMS OTP Function - EXACT SAME AS signup.php (2-parameter version that works!)
function sendOTP($mobile_no, $otp_code) {
    $url = 'http://bhashsms.com/api/sendmsg.php';

    $message = "Dear sir/mam We have received a request to authenticate your account. Please use the One-Time Password OTP " . $otp_code . " below to complete your request: This OTP will expire in 10 minutes. Please ensure it is entered before that time. Team APATKAL -MGAUS INFORMATION TECHNOLOGY PRIVATE LIMITED";

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

    // Log for debugging (same format as signup.php)
    error_log("Resend OTP SMS API Response: HTTP $httpCode, Response: $response, Error: $curlError");

    // Check if SMS was sent successfully
    return ($httpCode == 200 && $response !== false);
}

try {
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

    // Database connection (not required for resend, but check if available)
    try {
        $pdo = getDatabaseConnection();
    } catch (PDOException $e) {
        error_log("Resend OTP - Database error (non-fatal): " . $e->getMessage());
        // Don't fail if database connection fails - we don't need it for resend
    }

    // Get JSON input - with fallback for form-data
    $rawInput = file_get_contents('php://input');
    
    // Debug: Log what we received to file for troubleshooting
    $logFile = __DIR__ . '/app_request.log';
    $logEntry = date('d-m-Y H:i:s') . " => " . ($rawInput ?: 'EMPTY') . PHP_EOL;
    file_put_contents($logFile, $logEntry, FILE_APPEND);
    
    // Debug: Log what we received
    error_log("Resend OTP - Raw Input Received: " . ($rawInput ?: 'EMPTY'));
    error_log("Resend OTP - Content-Type: " . ($_SERVER['CONTENT_TYPE'] ?? 'NOT SET'));
    error_log("Resend OTP - POST Data: " . print_r($_POST, true));
    error_log("Resend OTP - GET Data: " . print_r($_GET, true));
    
    // Additional debug: Check if it looks like JSON or form-data
    if (!empty($rawInput)) {
        $firstChar = substr(trim($rawInput), 0, 1);
        if ($firstChar === '{' || $firstChar === '[') {
            error_log("✅ Resend OTP - Input looks like JSON");
        } else {
            error_log("⚠️ Resend OTP - Input does NOT look like JSON (starts with: $firstChar)");
            error_log("   This suggests app is sending form-data instead of JSON!");
        }
    }
    
    if ($rawInput === false || empty($rawInput)) {
        // Fallback: Try POST/GET if JSON is empty
        if (!empty($_POST['phone'])) {
            $input = $_POST;
            error_log("Resend OTP - Using POST fallback: phone = " . $_POST['phone']);
        } elseif (!empty($_GET['phone'])) {
            $input = $_GET;
            error_log("Resend OTP - Using GET fallback: phone = " . $_GET['phone']);
        } else {
            error_log("Resend OTP - Failed to read input (both JSON and form-data empty)");
            sendErrorResponse('Failed to read request data', 500);
        }
    } else {
        $input = json_decode($rawInput, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            error_log("Resend OTP - JSON decode error: " . json_last_error_msg());
            // Fallback to POST/GET
            if (!empty($_POST['phone'])) {
                $input = $_POST;
                error_log("Resend OTP - JSON decode failed, using POST fallback");
            } elseif (!empty($_GET['phone'])) {
                $input = $_GET;
                error_log("Resend OTP - JSON decode failed, using GET fallback");
            } else {
                sendErrorResponse('Invalid JSON data: ' . json_last_error_msg(), 400);
            }
        }
    }

    if (!$input || !isset($input['phone'])) {
        error_log("Resend OTP - Missing phone number in request. Input keys: " . implode(', ', array_keys($input ?? [])));
        sendErrorResponse('Phone number is required', 400);
    }

    $phone = trim($input['phone']);
    if (empty($phone)) {
        error_log("Resend OTP - Empty phone number");
        sendErrorResponse('Phone number cannot be empty', 400);
    }

    // Check if session data exists
    if (!isset($_SESSION['signup_data']) || !isset($_SESSION['signup_phone'])) {
        error_log("Resend OTP - Session expired for phone: $phone");
        error_log("Resend OTP - Session keys: " . implode(', ', array_keys($_SESSION ?? [])));
        sendErrorResponse('Signup session expired. Please start signup again.', 400);
    }

    // Verify phone number matches - LOG BOTH VALUES for debugging
    $sessionPhone = $_SESSION['signup_phone'] ?? 'NULL';
    error_log("Resend OTP - Phone Comparison:");
    error_log("   Session phone (stored): '$sessionPhone' (length: " . strlen($sessionPhone) . ")");
    error_log("   Request phone (received): '$phone' (length: " . strlen($phone) . ")");
    error_log("   Exact match: " . ($sessionPhone === $phone ? 'YES' : 'NO'));
    
    if ($sessionPhone !== $phone) {
        error_log("❌ Resend OTP - Phone mismatch. Session phone: '$sessionPhone', Request phone: '$phone'");
        error_log("   This will prevent OTP from being sent!");
        sendErrorResponse('Phone number mismatch', 400);
    } else {
        error_log("✅ Resend OTP - Phone numbers match! Proceeding to send OTP...");
    }

    // Get driver name from session
    $driverName = $_SESSION['signup_data']['driver_name'] ?? 'User';
    
    // Validate driver name is not empty
    if (empty($driverName)) {
        $driverName = 'User';
    }

    // Generate new 4-digit OTP
    $newOtp = str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);

    // Debug logging before sending OTP
    error_log("Resend OTP - Preparing to send OTP:");
    error_log("  Phone (original): $phone");
    error_log("  Phone (trimmed): " . trim($phone));
    error_log("  OTP: $newOtp");
    error_log("  Function will be called as: sendOTP('" . trim($phone) . "', '$newOtp')");
    error_log("  Function signature expects: sendOTP(\$mobile_no, \$otp_code) - 2 parameters");

    // Send new OTP via SMS - Using 2-parameter function (same as signup.php)
    error_log("🚀 Resend OTP - CALLING sendOTP() function NOW...");
    $smsSent = sendOTP(trim($phone), $newOtp);
    error_log("🔙 Resend OTP - sendOTP() function RETURNED: " . ($smsSent ? 'TRUE (success)' : 'FALSE (failed)'));
    
    // Enhanced logging for SMS result
    if ($smsSent) {
        error_log("✅ SUCCESS: OTP SMS sent successfully to $phone");
    } else {
        error_log("❌ WARNING: Failed to send OTP SMS to $phone, but continuing...");
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
    
} catch (Exception $e) {
    error_log("Resend OTP - Fatal error: " . $e->getMessage());
    error_log("Resend OTP - Stack trace: " . $e->getTraceAsString());
    sendErrorResponse('Server error: ' . $e->getMessage(), 500);
} catch (Error $e) {
    // Catch PHP 7+ fatal errors (like undefined variables, etc.)
    error_log("Resend OTP - PHP Fatal error: " . $e->getMessage());
    error_log("Resend OTP - Stack trace: " . $e->getTraceAsString());
    sendErrorResponse('Server error: ' . $e->getMessage(), 500);
}
?>
