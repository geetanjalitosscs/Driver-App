import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/database_config.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class KycNotificationService {
  static final KycNotificationService _instance = KycNotificationService._internal();
  factory KycNotificationService() => _instance;
  KycNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  Timer? _statusCheckTimer;
  bool _isInitialized = false;

  // Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    print('🔔 KYC Notification Service initialized');
  }

  // Start monitoring KYC status changes
  Future<void> startMonitoring(String driverId) async {
    await initialize();
    
    // Stop any existing timer
    stopMonitoring();
    
    print('🔔 Starting KYC status monitoring for driver: $driverId');
    
    // Check immediately
    await _checkKycStatus(driverId);
    
    // Then check every 5 seconds for faster updates
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkKycStatus(driverId);
    });
  }

  // Stop monitoring
  void stopMonitoring() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = null;
    print('🔔 Stopped KYC status monitoring');
  }

  // Check KYC status and send notification if changed
  Future<void> _checkKycStatus(String driverId) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.baseUrl}check_kyc_status_change.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'driver_id': driverId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['data']['status_changed'] == true) {
          await _showKycNotification(data['data']);
        }
      }
    } catch (e) {
      print('Error checking KYC status: $e');
    }
  }

  // Show KYC notification
  Future<void> _showKycNotification(Map<String, dynamic> data) async {
    final String title = data['title'];
    final String message = data['message'];
    final String type = data['type'];
    final String kycStatus = data['kyc_status'];
    
    // Update the app's internal state
    await _updateAppKycStatus(data);

    // Create notification details
    const androidDetails = AndroidNotificationDetails(
      'kyc_notifications',
      'KYC Status Updates',
      channelDescription: 'Notifications for KYC status changes',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show the notification
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      notificationDetails,
      payload: json.encode({
        'type': 'kyc_status_change',
        'kyc_status': kycStatus,
        'driver_id': data['driver_id'],
        'action': kycStatus == 'approved' ? 'navigate_to_login' : 'navigate_to_help',
      }),
    );

    print('🔔 KYC notification sent: $title');
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    try {
      final payload = json.decode(response.payload ?? '{}');
      final action = payload['action'] as String?;
      
      print('🔔 KYC notification tapped: $action');
      
      // Handle different actions
      switch (action) {
        case 'navigate_to_login':
          // Navigate to login screen for approved users
          _navigateToLogin();
          break;
        case 'navigate_to_help':
          // Navigate to help screen for rejected users
          _navigateToHelp();
          break;
        default:
          print('Unknown notification action: $action');
      }
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }

  // Navigate to login screen
  void _navigateToLogin() {
    // This will be handled by the main app navigation
    print('🔔 Navigating to login screen');
  }

  // Navigate to help screen
  void _navigateToHelp() {
    // This will be handled by the main app navigation
    print('🔔 Navigating to help screen');
  }

  // Force immediate KYC status check
  Future<void> forceImmediateCheck(String driverId) async {
    print('🔔 Force immediate KYC check for driver: $driverId');
    await _checkKycStatus(driverId);
  }

  // Manual check for KYC status (can be called from UI)
  Future<Map<String, dynamic>?> checkKycStatusManually(String driverId) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.baseUrl}check_kyc_status_change.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'driver_id': driverId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          return data['data'];
        }
      }
    } catch (e) {
      print('Error checking KYC status manually: $e');
    }
    
    return null;
  }

  // Update app's internal KYC status
  Future<void> _updateAppKycStatus(Map<String, dynamic> data) async {
    try {
      // Get the current context to access AuthProvider
      // Since we can't access BuildContext directly, we'll use a different approach
      // We'll store the status change and let the app check it on next interaction
      
      final prefs = await SharedPreferences.getInstance();
      final driverId = data['driver_id'].toString();
      final newStatus = data['kyc_status'];
      
      // Store the status change for the app to pick up
      await prefs.setString('kyc_status_change_$driverId', json.encode({
        'status': newStatus,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'title': data['title'],
        'message': data['message'],
        'type': data['type']
      }));
      
      print('🔔 Stored KYC status change: $newStatus for driver $driverId');
    } catch (e) {
      print('Error updating app KYC status: $e');
    }
  }

  // Clean up resources
  void dispose() {
    stopMonitoring();
  }
}
