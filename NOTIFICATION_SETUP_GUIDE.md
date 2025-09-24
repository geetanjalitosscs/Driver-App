# Push Notification Setup Guide

This guide will help you set up push notifications for your Driver App so that when someone submits an accident report from the website, users with your app installed will receive notifications.

## 🚀 Quick Start

### 1. Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Create a project"
   - Name it "Driver App Notifications" (or any name you prefer)
   - Enable Google Analytics (optional)

2. **Add Android App**
   - Click "Add app" and select Android
   - Package name: `com.example.driver_app` (or your actual package name)
   - App nickname: "Driver App"
   - Download `google-services.json` and replace the one in `android/app/`

3. **Get Server Key**
   - Go to Project Settings > Cloud Messaging
   - Copy the "Server key" (this is your FCM server key)
   - Update `send_notification.php` with your server key

### 2. Update Configuration Files

#### Update `android/app/google-services.json`
Replace the placeholder file with your actual Firebase configuration file.

#### Update `send_notification.php`
```php
// Replace this line with your actual Firebase server key
$firebase_server_key = 'YOUR_ACTUAL_FIREBASE_SERVER_KEY_HERE';
```

#### Update Package Name (if needed)
If your app uses a different package name, update:
- `android/app/google-services.json` (package_name field)
- `android/app/build.gradle.kts` (applicationId)

### 3. Install Dependencies

Run this command in your project root:
```bash
flutter pub get
```

### 4. Test the Setup

1. **Build and install the app**:
   ```bash
   flutter run
   ```

2. **Test notifications**:
   - Open the app and go to the Home screen
   - Tap "Go Online" to enable the driver status
   - Tap "Test Notification" button
   - You should see both a system notification and an in-app banner

3. **Test from website**:
   - Open `test_notification.html` in your browser
   - Fill in the form and click "Send Notification"
   - Check your phone for the notification

## 📱 Features Implemented

### ✅ What's Working
- **Firebase Cloud Messaging (FCM)** integration
- **Local notifications** for testing
- **In-app notification banners** that appear at the top
- **System notifications** when app is in background/closed
- **Notification history** tracking
- **Test notification** button for easy testing
- **Web interface** to send notifications from website

### 🎯 Notification Types
- **Accident Reports**: When new accidents are reported
- **Emergency Alerts**: For urgent situations
- **Test Notifications**: For testing the system

### 🔧 Technical Details
- Notifications work when app is:
  - ✅ **Foreground**: Shows in-app banner + system notification
  - ✅ **Background**: Shows system notification
  - ✅ **Closed**: Shows system notification
- Auto-dismiss after 5 seconds
- Tap to dismiss or interact
- Notification history stored locally

## 🛠️ Troubleshooting

### Common Issues

1. **"Firebase not initialized" error**
   - Make sure `google-services.json` is in the correct location
   - Check that Firebase dependencies are installed

2. **Notifications not appearing**
   - Check notification permissions in device settings
   - Verify Firebase server key is correct
   - Check internet connection

3. **"Invalid server key" error**
   - Double-check the Firebase server key in `send_notification.php`
   - Make sure there are no extra spaces or characters

4. **App crashes on startup**
   - Check that all dependencies are installed: `flutter pub get`
   - Verify Firebase configuration files

### Debug Steps

1. **Check Firebase Console**
   - Go to Firebase Console > Cloud Messaging
   - Check if messages are being sent successfully

2. **Check App Logs**
   ```bash
   flutter logs
   ```
   Look for notification-related messages

3. **Test FCM Token**
   - The app prints the FCM token to console
   - You can use this token to send direct notifications

## 🔗 Integration with Your Website

### Option 1: Use the PHP Script
1. Upload `send_notification.php` to your web server
2. Update the Firebase server key in the script
3. Call the script when accident reports are submitted:

```javascript
// Example: Send notification when form is submitted
fetch('send_notification.php', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
        title: 'New Accident Report',
        body: 'Accident reported on Main Street',
        data: {
            accident_id: '123',
            location: 'Main Street',
            severity: 'high'
        }
    })
});
```

### Option 2: Integrate with Your Backend
Modify your existing accident report submission code to call the notification service:

```php
// After saving accident report to database
$notificationData = [
    'title' => 'New Accident Report',
    'body' => "Accident reported at: " . $location,
    'data' => [
        'accident_id' => $accidentId,
        'location' => $location,
        'severity' => $severity
    ]
];

// Send notification
$notificationResult = sendPushNotification(
    $notificationData['title'],
    $notificationData['body'],
    $notificationData['data']
);
```

## 📋 Next Steps

1. **Customize Notifications**
   - Modify notification sounds, icons, and colors
   - Add more notification types (emergency, maintenance, etc.)

2. **Add User Management**
   - Store FCM tokens in your database
   - Send notifications to specific drivers
   - Add driver online/offline status

3. **Enhanced Features**
   - Rich notifications with images
   - Action buttons (Accept/Decline)
   - Notification scheduling
   - Analytics and tracking

## 🆘 Support

If you encounter any issues:
1. Check the troubleshooting section above
2. Verify all configuration files are correct
3. Test with the provided test interface
4. Check Firebase Console for delivery status

## 📝 Notes

- The notification system works independently of your existing accident reporting
- Notifications are sent to all devices subscribed to the "accident_reports" topic
- For production use, consider implementing user-specific notifications
- The system is designed to be reliable and handle network issues gracefully
