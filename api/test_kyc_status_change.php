<?php
/**
 * Test script to verify KYC status change detection
 * This script simulates changing a driver's KYC status and tests the API
 */

echo "=== KYC Status Change Test ===\n\n";

// Test data
$test_driver_id = 1; // Change this to an existing driver ID

echo "Testing KYC status change detection for Driver ID: $test_driver_id\n\n";

// Step 1: Check current status
echo "Step 1: Checking current KYC status...\n";
$current_status = checkKycStatus($test_driver_id);
echo "Current status: $current_status\n\n";

// Step 2: Simulate status change
echo "Step 2: Simulating KYC status change...\n";
$new_status = ($current_status === 'approved') ? 'rejected' : 'approved';
echo "Changing status from '$current_status' to '$new_status'\n";

// Update the database
updateKycStatus($test_driver_id, $new_status);
echo "Database updated successfully\n\n";

// Step 3: Test the API multiple times to simulate app checking
echo "Step 3: Testing API response (simulating app checks)...\n";
for ($i = 1; $i <= 3; $i++) {
    echo "Check #$i: ";
    $result = testKycApi($test_driver_id);
    if ($result) {
        echo "Status change detected: " . ($result['status_changed'] ? 'YES' : 'NO') . "\n";
        if ($result['status_changed']) {
            echo "  - New status: " . $result['kyc_status'] . "\n";
            echo "  - Title: " . $result['title'] . "\n";
            echo "  - Message: " . $result['message'] . "\n";
        }
    } else {
        echo "API Error\n";
    }
    echo "\n";
    
    // Wait 1 second between checks
    sleep(1);
}

// Step 4: Restore original status
echo "Step 4: Restoring original status...\n";
updateKycStatus($test_driver_id, $current_status);
echo "Status restored to: $current_status\n\n";

echo "=== Test Complete ===\n";
echo "\nExpected behavior:\n";
echo "1. First check should detect status change (status_changed = true)\n";
echo "2. Subsequent checks should not detect change (status_changed = false)\n";
echo "3. App should receive notification and update internal state\n";

/**
 * Check current KYC status
 */
function checkKycStatus($driver_id) {
    try {
        require_once './db_config.php';
        $pdo = getDatabaseConnection();
        
        $stmt = $pdo->prepare("SELECT kyc_status FROM drivers WHERE id = ?");
        $stmt->execute([$driver_id]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        
        return $result ? $result['kyc_status'] : 'unknown';
    } catch (Exception $e) {
        echo "Error checking status: " . $e->getMessage() . "\n";
        return 'error';
    }
}

/**
 * Update KYC status in database
 */
function updateKycStatus($driver_id, $status) {
    try {
        require_once './db_config.php';
        $pdo = getDatabaseConnection();
        
        $stmt = $pdo->prepare("UPDATE drivers SET kyc_status = ? WHERE id = ?");
        $result = $stmt->execute([$status, $driver_id]);
        
        if ($result) {
            echo "Status updated to: $status\n";
        } else {
            echo "Failed to update status\n";
        }
    } catch (Exception $e) {
        echo "Error updating status: " . $e->getMessage() . "\n";
    }
}

/**
 * Test the KYC API
 */
function testKycApi($driver_id) {
    $data = ['driver_id' => $driver_id];
    $json_data = json_encode($data);
    
    $url = 'http://localhost/Driver-App/api/check_kyc_status_change.php';
    $ch = curl_init();
    
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $json_data);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Content-Length: ' . strlen($json_data)
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    
    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    $result = json_decode($response, true);
    
    if ($http_code == 200 && $result && $result['success']) {
        return $result['data'];
    } else {
        echo "API Error: HTTP $http_code, Response: $response\n";
        return false;
    }
}
?>

