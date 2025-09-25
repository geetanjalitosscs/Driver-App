import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  // Notification state
  static bool _isInitialized = false;
  static final List<NotificationData> _notificationHistory = [];

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize local notifications only
      await _initializeLocalNotifications();
      
      // Request permissions
      await _requestPermissions();
      
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
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  /// Request permissions
  static Future<void> _requestPermissions() async {
    // Request local notification permissions
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Handle notification tap
  static void _onNotificationTap(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Handle notification tap logic here
  }

  /// Show local notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String type = 'general',
  }) async {
    if (!_isInitialized) {
      print('❌ NotificationService not initialized');
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'driver_app_channel',
      'Driver App Notifications',
      channelDescription: 'Notifications for the Driver App',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    // Add to history
    _notificationHistory.insert(0, NotificationData(
      id: id,
      title: title,
      body: body,
      timestamp: DateTime.now(),
      payload: payload,
      type: type,
    ));

    // Keep only last 50 notifications
    if (_notificationHistory.length > 50) {
      _notificationHistory.removeRange(50, _notificationHistory.length);
    }
  }

  // Scheduled notifications removed to avoid timezone dependency issues

  /// Cancel notification
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Get notification history
  static List<NotificationData> getNotificationHistory() {
    return List.from(_notificationHistory);
  }

  /// Clear notification history
  static void clearNotificationHistory() {
    _notificationHistory.clear();
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    // For local notifications, we assume they're enabled if initialized
    return _isInitialized;
  }
}

/// Notification data model
class NotificationData {
  final int id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String? payload;
  final String type;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.payload,
    this.type = 'general',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'payload': payload,
      'type': type,
    };
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
      payload: json['payload'],
      type: json['type'] ?? 'general',
    );
  }
}