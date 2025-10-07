<?php
/**
 * Debug script to test Check Status functionality
 * This will help identify why Check Status button is not working
 */

echo "=== Check Status Debug Test ===\n\n";

$test_driver_id = 1; // Change this to an existing driver ID

echo "Testing Check Status for Driver ID: $test_driver_id\n\n";

// Step 1: Check what's in the database
echo "Step 1: Database check...\n";
$db_status = checkDatabaseStatus($test_driver_id);
echo "Database KYC status: $db_status\n\n";

// Step 2: Test the API directly
echo "Step 2: Testing check_kyc_status.php API...\n";
$api_result = testCheckKycStatusApi($test_driver_id);
if ($api_result) {
    echo "✅ API Response:\n";
    echo "   - Success: " . ($api_result['success'] ? 'YES' : 'NO') . "\n";
    echo "   - Driver ID: " . $api_result['driver']['driver_id'] . "\n";
    echo "   - Driver Name: " . $api_result['driver']['driver_name'] . "\n";
    echo "   - KYC Status: " . $api_result['driver']['kyc_status'] . "\n";
    echo "   - Status matches DB: " . ($api_result['driver']['kyc_status'] === $db_status ? 'YES' : 'NO') . "\n";
} else {
    echo "❌ API Error\n";
}
echo "\n";

// Step 3: Test with different driver ID
echo "Step 3: Testing with different driver ID...\n";
$other_driver_id = 2;
$other_db_status = checkDatabaseStatus($other_driver_id);
echo "Driver $other_driver_id DB status: $other_db_status\n";

$other_api_result = testCheckKycStatusApi($other_driver_id);
if ($other_api_result) {
    echo "✅ API Response for Driver $other_driver_id:\n";
    echo "   - KYC Status: " . $other_api_result['driver']['kyc_status'] . "\n";
} else {
    echo "❌ API Error for Driver $other_driver_id\n";
}
echo "\n";

// Step 4: Check if kyc_status column exists
echo "Step 4: Checking database schema...\n";
checkDatabaseSchema();

echo "\n=== Debug Complete ===\n";

function checkDatabaseStatus($driver_id) {
    try {
        require_once './db_config.php';
        $pdo = getDatabaseConnection();
        
        $stmt = $pdo->prepare("SELECT id, driver_name, kyc_status FROM drivers WHERE id = ?");
        $stmt->execute([$driver_id]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($result) {
            echo "Driver found: {$result['driver_name']}, Status: {$result['kyc_status']}\n";
            return $result['kyc_status'];
        } else {
            echo "Driver not found\n";
            return 'not_found';
        }
    } catch (Exception $e) {
        echo "Database error: " . $e->getMessage() . "\n";
        return 'error';
    }
}

function testCheckKycStatusApi($driver_id) {
    $data = ['driver_id' => $driver_id];
    $json_data = json_encode($data);
    
    $url = 'http://localhost/Driver-App/api/check_kyc_status.php';
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
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    
    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    echo "HTTP Code: $http_code\n";
    echo "Response: $response\n";
    
    $result = json_decode($response, true);
    
    if ($http_code == 200 && $result) {
        return $result;
    } else {
        return false;
    }
}

function checkDatabaseSchema() {
    try {
        require_once './db_config.php';
        $pdo = getDatabaseConnection();
        
        // Check if kyc_status column exists
        $stmt = $pdo->prepare("DESCRIBE drivers");
        $stmt->execute();
        $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        $kyc_status_exists = false;
        foreach ($columns as $column) {
            if ($column['Field'] === 'kyc_status') {
                $kyc_status_exists = true;
                echo "✅ kyc_status column exists: {$column['Type']}, Default: {$column['Default']}\n";
                break;
            }
        }
        
        if (!$kyc_status_exists) {
            echo "❌ kyc_status column does not exist!\n";
        }
        
        // Show all drivers and their kyc_status
        $stmt = $pdo->prepare("SELECT id, driver_name, kyc_status FROM drivers");
        $stmt->execute();
        $drivers = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo "\nAll drivers:\n";
        foreach ($drivers as $driver) {
            echo "  ID: {$driver['id']}, Name: {$driver['driver_name']}, KYC: {$driver['kyc_status']}\n";
        }
        
    } catch (Exception $e) {
        echo "Schema check error: " . $e->getMessage() . "\n";
    }
}
?>

