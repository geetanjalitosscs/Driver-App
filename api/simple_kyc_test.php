<?php
/**
 * Simple test to check KYC status API
 */

echo "=== Simple KYC Status Test ===\n\n";

// Test data
$driver_id = 1;

echo "Testing KYC status for Driver ID: $driver_id\n\n";

// Test the API directly
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
echo "Response: $response\n\n";

$result = json_decode($response, true);

if ($http_code == 200 && $result) {
    echo "✅ API Response:\n";
    echo "   - Success: " . ($result['success'] ? 'YES' : 'NO') . "\n";
    if ($result['success']) {
        echo "   - Driver ID: " . $result['driver']['driver_id'] . "\n";
        echo "   - Driver Name: " . $result['driver']['driver_name'] . "\n";
        echo "   - KYC Status: " . $result['driver']['kyc_status'] . "\n";
    } else {
        echo "   - Error: " . $result['message'] . "\n";
    }
} else {
    echo "❌ API Error\n";
}

echo "\n=== Test Complete ===\n";
?>

