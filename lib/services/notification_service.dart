import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  static FirebaseMessaging? _firebaseMessaging;
  static StreamSubscription<RemoteMessage>? _messageSubscription;
  static StreamSubscription<RemoteMessage>? _backgroundMessageSubscription;
  
  // Notification state
  static bool _isInitialized = false;
  static String? _fcmToken;
  static final List<NotificationData> _notificationHistory = [];
  
  // Callbacks
  static Function(NotificationData)? onNotificationReceived;
  static Function(NotificationData)? onNotificationTapped;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      _firebaseMessaging = FirebaseMessaging.instance;
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Request permissions
      await _requestPermissions();
      
      // Get FCM token
      await _getFCMToken();
      
      // Set up message handlers
      await _setupMessageHandlers();
      
      _isInitialized = true;
      print('✅ NotificationService initialized successfully');
    } catch (e) {
      print('❌ Error initializing NotificationService: $e');
    }
  }

  /// Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Request notification permissions
  static Future<void> _requestPermissions() async {
    // Request FCM permissions
    final NotificationSettings settings = await _firebaseMessaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('FCM Permission status: ${settings.authorizationStatus}');
    
    // Request local notification permissions
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Get FCM token
  static Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging!.getToken();
      print('FCM Token: $_fcmToken');
      
      // Save token to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', _fcmToken ?? '');
      
      // Send token to your server (optional)
      await _sendTokenToServer(_fcmToken);
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  /// Send FCM token to server
  static Future<void> _sendTokenToServer(String? token) async {
    if (token == null) return;
    
    try {
      // You can implement this to send the token to your backend
      // so you can send notifications from your website
      print('Sending FCM token to server: $token');
      
      // Example API call (uncomment and modify as needed):
      /*
      final response = await http.post(
        Uri.parse('https://your-api.com/register-device'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': token,
          'platform': 'android', // or 'ios'
          'app_version': '1.0.0',
        }),
      );
      
      if (response.statusCode == 200) {
        print('Token sent to server successfully');
      }
      */
    } catch (e) {
      print('Error sending token to server: $e');
    }
  }

  /// Set up message handlers
  static Future<void> _setupMessageHandlers() async {
    // Handle foreground messages
    _messageSubscription = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    
    // Handle notification taps when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    
    // Handle notification tap when app is terminated
    final RemoteMessage? initialMessage = await _firebaseMessaging!.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// Handle foreground messages
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Received foreground message: ${message.messageId}');
    
    final notificationData = NotificationData.fromRemoteMessage(message);
    _notificationHistory.insert(0, notificationData);
    
    // Show local notification
    await _showLocalNotification(notificationData);
    
    // Call callback
    onNotificationReceived?.call(notificationData);
  }

  /// Handle background messages
  @pragma('vm:entry-point')
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Received background message: ${message.messageId}');
    
    final notificationData = NotificationData.fromRemoteMessage(message);
    
    // Save to shared preferences for later retrieval
    final prefs = await SharedPreferences.getInstance();
    final List<String> notifications = prefs.getStringList('notification_history') ?? [];
    notifications.insert(0, json.encode(notificationData.toJson()));
    
    // Keep only last 50 notifications
    if (notifications.length > 50) {
      notifications.removeRange(50, notifications.length);
    }
    
    await prefs.setStringList('notification_history', notifications);
  }

  /// Handle notification tap
  static Future<void> _handleNotificationTap(RemoteMessage message) async {
    print('Notification tapped: ${message.messageId}');
    
    final notificationData = NotificationData.fromRemoteMessage(message);
    
    // Call callback
    onNotificationTapped?.call(notificationData);
  }

  /// Handle local notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    print('Local notification tapped: ${response.payload}');
    
    if (response.payload != null) {
      try {
        final Map<String, dynamic> data = json.decode(response.payload!);
        final notificationData = NotificationData.fromJson(data);
        onNotificationTapped?.call(notificationData);
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  /// Show local notification
  static Future<void> _showLocalNotification(NotificationData data) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'accident_reports',
      'Accident Reports',
      channelDescription: 'Notifications for new accident reports',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF2196F3),
      playSound: true,
      enableVibration: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      data.id.hashCode,
      data.title,
      data.body,
      details,
      payload: json.encode(data.toJson()),
    );
  }

  /// Show test notification
  static Future<void> showTestNotification() async {
    final testData = NotificationData(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Notification',
      body: 'This is a test notification from your Driver App',
      type: 'test',
      data: {'test': 'true'},
      timestamp: DateTime.now(),
    );
    
    await _showLocalNotification(testData);
    _notificationHistory.insert(0, testData);
  }

  /// Get notification history
  static List<NotificationData> getNotificationHistory() {
    return List.from(_notificationHistory);
  }

  /// Clear notification history
  static Future<void> clearNotificationHistory() async {
    _notificationHistory.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notification_history');
  }

  /// Get FCM token
  static String? getFCMToken() => _fcmToken;

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final settings = await _firebaseMessaging?.getNotificationSettings();
    return settings?.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Dispose resources
  static Future<void> dispose() async {
    await _messageSubscription?.cancel();
    await _backgroundMessageSubscription?.cancel();
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  await NotificationService._handleBackgroundMessage(message);
}

/// Notification data model
class NotificationData {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.timestamp,
  });

  factory NotificationData.fromRemoteMessage(RemoteMessage message) {
    return NotificationData(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'New Accident Report',
      body: message.notification?.body ?? 'A new accident has been reported',
      type: message.data['type'] ?? 'accident_report',
      data: message.data,
      timestamp: DateTime.now(),
    );
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
      data: Map<String, dynamic>.from(json['data']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
