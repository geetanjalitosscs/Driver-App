<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Firebase Server Key (you need to get this from Firebase Console)
// Go to Project Settings > Cloud Messaging > Server Key
$firebase_server_key = 'YOUR_FIREBASE_SERVER_KEY_HERE';

// Function to send push notification
function sendPushNotification($title, $body, $data = []) {
    global $firebase_server_key;
    
    // FCM endpoint
    $url = 'https://fcm.googleapis.com/fcm/send';
    
    // Notification payload
    $notification = [
        'title' => $title,
        'body' => $body,
        'icon' => '@mipmap/ic_launcher',
        'color' => '#2196F3',
        'sound' => 'default',
        'click_action' => 'FLUTTER_NOTIFICATION_CLICK'
    ];
    
    // Data payload
    $data_payload = array_merge([
        'type' => 'accident_report',
        'timestamp' => date('Y-m-d H:i:s')
    ], $data);
    
    // Message payload
    $message = [
        'notification' => $notification,
        'data' => $data_payload,
        'priority' => 'high',
        'time_to_live' => 3600 // 1 hour
    ];
    
    // For testing, we'll send to a topic instead of specific tokens
    // In production, you should store FCM tokens in your database
    $message['to'] = '/topics/accident_reports';
    
    // Alternative: Send to specific device tokens
    // $message['registration_ids'] = ['DEVICE_TOKEN_1', 'DEVICE_TOKEN_2'];
    
    $headers = [
        'Authorization: key=' . $firebase_server_key,
        'Content-Type: application/json'
    ];
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($message));
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    
    $result = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    return [
        'success' => $http_code == 200,
        'http_code' => $http_code,
        'response' => json_decode($result, true),
        'raw_response' => $result
    ];
}

// Handle POST request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!$input) {
        echo json_encode([
            'success' => false,
            'message' => 'Invalid JSON input'
        ]);
        exit();
    }
    
    // Extract data from input
    $title = $input['title'] ?? 'New Accident Report';
    $body = $input['body'] ?? 'A new accident has been reported in your area';
    $data = $input['data'] ?? [];
    
    // Add accident report details to data
    if (isset($input['accident_id'])) {
        $data['accident_id'] = $input['accident_id'];
    }
    if (isset($input['location'])) {
        $data['location'] = $input['location'];
    }
    if (isset($input['severity'])) {
        $data['severity'] = $input['severity'];
    }
    
    // Send notification
    $result = sendPushNotification($title, $body, $data);
    
    echo json_encode([
        'success' => $result['success'],
        'message' => $result['success'] ? 'Notification sent successfully' : 'Failed to send notification',
        'details' => $result
    ]);
    
} else {
    // Handle GET request - show usage info
    echo json_encode([
        'success' => true,
        'message' => 'Push Notification Service',
        'usage' => [
            'method' => 'POST',
            'content_type' => 'application/json',
            'body' => [
                'title' => 'Notification title',
                'body' => 'Notification body',
                'data' => [
                    'accident_id' => '123',
                    'location' => 'Main Street',
                    'severity' => 'high'
                ]
            ]
        ],
        'example' => [
            'title' => 'New Accident Report',
            'body' => 'Accident reported on Main Street - High Priority',
            'data' => [
                'accident_id' => '123',
                'location' => 'Main Street, Downtown',
                'severity' => 'high',
                'type' => 'accident_report'
            ]
        ]
    ]);
}
?>
