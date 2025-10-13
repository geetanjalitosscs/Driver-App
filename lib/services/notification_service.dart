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
  
  // Callback to save notifications to NotificationProvider
  static Function(String title, String body, String type, Map<String, dynamic> actionData)? _saveToProviderCallback;

  /// Set callback to save notifications to NotificationProvider
  static void setSaveToProviderCallback(Function(String title, String body, String type, Map<String, dynamic> actionData) callback) {
    _saveToProviderCallback = callback;
  }

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize local notifications only
      await _initializeLocalNotifications();
      
      // Request permissions (with error handling)
      try {
        await _requestPermissions();
      } catch (e) {
        print('⚠️ Permission request failed: $e');
        // Continue without permissions
      }
      
      _isInitialized = true;
      print('✅ NotificationService initialized successfully');
    } catch (e) {
      print('❌ Error initializing NotificationService: $e');
      // Set as initialized even if failed to prevent retry loops
      _isInitialized = true;
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

    // Create notification channel for Android (required for Android 8.0+)
    await _createNotificationChannel();
  }

  /// Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'driver_app_channel',
      'Driver App Notifications',
      description: 'Notifications for accident reports, trips, earnings, and withdrawals',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
      ledColor: Color(0xFF2196F3), // Blue LED color
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(channel);
      print('✅ Android notification channel created successfully');
    }
  }

  /// Request permissions
  static Future<void> _requestPermissions() async {
    // Request local notification permissions
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      // Request notification permission for Android 13+
      await androidImplementation.requestNotificationsPermission();
      
      // Removed requestExactAlarmsPermission() to avoid "Alarms and Reminders" dialog
      // This permission is not needed for basic notifications
      
      print('✅ Android notification permissions requested');
    }

    // For iOS, permissions are requested in DarwinInitializationSettings
    print('✅ iOS notification permissions requested');
  }

  /// Handle notification tap
  static void _onNotificationTap(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Handle notification tap logic here
  }

  /// Show local notification (system notification outside app)
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

    // Check if push notifications are enabled in settings
    final prefs = await SharedPreferences.getInstance();
    final pushNotificationsEnabled = prefs.getBool('push_notifications') ?? true;
    
    if (!pushNotificationsEnabled) {
      print('📱 Push notifications disabled - saving to in-app notifications only');
      // Still save to provider for in-app notifications
      if (_saveToProviderCallback != null) {
        _saveToProviderCallback!(title, body, type, {'payload': payload});
      }
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'driver_app_channel',
      'Driver App Notifications',
      channelDescription: 'Notifications for the Driver App',
      importance: Importance.max, // Maximum importance for better visibility
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      autoCancel: false, // Don't auto-cancel so it stays in notification tray
      ongoing: false,
      visibility: NotificationVisibility.public, // Show on lock screen
      fullScreenIntent: true, // Show full screen intent for important notifications
      category: AndroidNotificationCategory.message, // Categorize as message
      channelShowBadge: true, // Show badge on app icon
      icon: '@mipmap/ic_launcher', // Use app icon
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'), // Large icon
      styleInformation: BigTextStyleInformation(''), // Allow expandable text
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'view',
          'View',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'dismiss',
          'Dismiss',
          cancelNotification: true,
        ),
      ],
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical, // Critical level for better visibility
      sound: 'default', // Use default system sound
      badgeNumber: 1, // Show badge number
      threadIdentifier: 'driver_app_notifications', // Group notifications
      categoryIdentifier: 'driver_app_category', // Category for actions
      attachments: <DarwinNotificationAttachment>[], // No attachments for now
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      print('📱 System notification shown successfully: $title');

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

      // Also save to NotificationProvider if callback is set
      if (_saveToProviderCallback != null) {
        try {
          Map<String, dynamic> actionData = {};
          if (payload != null) {
            try {
              actionData = json.decode(payload);
            } catch (e) {
              print('⚠️ Failed to parse payload: $e');
            }
          }
          
          _saveToProviderCallback!(title, body, type, actionData);
          print('✅ Notification saved to NotificationProvider');
        } catch (e) {
          print('❌ Failed to save to NotificationProvider: $e');
        }
      }
    } catch (e) {
      print('❌ Failed to show system notification: $e');
    }
  }

  // Cancel notification
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Get notification history
  static List<NotificationData> getNotificationHistory() {
    return List.from(_notificationHistory);
  }

  // Clear notification history
  static void clearNotificationHistory() {
    _notificationHistory.clear();
  }

  // Set app badge count (Android and iOS)
  static Future<void> setAppBadgeCount(int count) async {
    if (!_isInitialized) return;
    
    try {
      // For Android, we use a persistent notification with badge count
      if (count > 0) {
        final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          'driver_app_channel',
          'Driver App Notifications',
          channelDescription: 'Notifications for the Driver App',
          importance: Importance.low,
          priority: Priority.low,
          showWhen: false,
          enableVibration: false,
          playSound: false,
          autoCancel: false,
          ongoing: true,
          silent: true,
          visibility: NotificationVisibility.private,
          channelShowBadge: true,
          icon: '@mipmap/ic_launcher',
        );

        final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: true,
          presentSound: false,
        );

        final NotificationDetails notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await _localNotifications.show(
          999999, // Special ID for badge notification
          '', // Empty title
          '', // Empty body
          notificationDetails,
        );
        
        print('📱 App badge count set to: $count');
      } else {
        // Clear badge by canceling the special notification
        await _localNotifications.cancel(999999);
        print('📱 App badge cleared');
      }
    } catch (e) {
      print('❌ Failed to set app badge count: $e');
    }
  }

  // Clear app badge
  static Future<void> clearAppBadge() async {
    await setAppBadgeCount(0);
  }

  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    // For local notifications, we assume they're enabled if initialized
    return _isInitialized;
  }

  // ===== NOTIFICATION METHODS FOR DIFFERENT EVENTS =====

  // Show notification for new accident reports
  static Future<void> showNewAccidentNotification({
    required int accidentId,
    required String vehicle,
    required String location,
    double? latitude,
    double? longitude,
  }) async {
    final title = "🚨 New Accident Report #$accidentId";
    final message = "Accident reported for vehicle $vehicle at $location";
    
    print('🔔 Creating notification for accident ID: $accidentId');
    
    await showNotification(
      id: accidentId,
      title: title,
      body: message,
      payload: json.encode({
        'type': 'new_accident',
        'accident_id': accidentId,
        'vehicle': vehicle,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
      }),
      type: 'new_accident',
    );
  }

  // Show notification for trip completion
  static Future<void> showTripCompletedNotification({
    required int tripId,
    required String vehicle,
    required String location,
    required double earnings,
  }) async {
    final title = "✅ Trip Completed";
    final message = "Trip #$tripId completed for vehicle $vehicle. Earnings: ₹$earnings";
    
    print('🔔 Creating notification for completed trip ID: $tripId');
    
    await showNotification(
      id: tripId,
      title: title,
      body: message,
      payload: json.encode({
        'type': 'trip_completed',
        'trip_id': tripId,
        'vehicle': vehicle,
        'location': location,
        'earnings': earnings,
      }),
      type: 'trip_completed',
    );
  }

  // Show notification for earnings - Only for new earnings
  static Future<void> showEarningsNotification({
    required double amount,
    required String period,
    required int tripCount,
    bool isNewEarning = true, // Only show for new earnings
  }) async {
    if (!isNewEarning) {
      print('Skipping earnings notification - not a new earning');
      return;
    }
    
    final title = "💰 Earnings Update";
    final message = "₹$amount earned in $period from $tripCount trips";
    
    print('🔔 Creating notification for new earnings: ₹$amount');
    
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Use timestamp as ID
      title: title,
      body: message,
      payload: json.encode({
        'type': 'earnings',
        'amount': amount,
        'period': period,
        'trip_count': tripCount,
      }),
      type: 'earnings',
    );
  }

  // Show notification for KYC approval
  static Future<void> showKycApprovalNotification({
    required String status,
    String? message,
  }) async {
    String title;
    String body;
    String type;
    
    if (status == 'approved') {
      title = "✅ KYC Verification Approved";
      body = message ?? "Your KYC Verification is approved! You can now use your profile and access all app features.";
      type = 'kyc_approved';
    } else if (status == 'rejected') {
      title = "❌ KYC Verification Rejected";
      body = message ?? "Your KYC Verification has been rejected. Please contact support for more information.";
      type = 'kyc_rejected';
    } else {
      title = "⏳ KYC Verification Update";
      body = message ?? "Your KYC Verification status has been updated to: $status";
      type = 'kyc_update';
    }
    
    print('🔔 Creating KYC notification: $status');
    
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Use timestamp as ID
      title: title,
      body: body,
      payload: json.encode({
        'type': type,
        'kyc_status': status,
        'action': status == 'approved' ? 'navigate_to_login' : 'navigate_to_help',
      }),
      type: type,
    );
  }

  // Show notification for withdrawal
  static Future<void> showWithdrawalNotification({
    required double amount,
    required String status,
    required String method,
  }) async {
    String title;
    String message;
    
    if (status == 'completed') {
      title = "✅ Withdrawal Completed";
      message = "₹${amount.toStringAsFixed(0)} has been successfully withdrawn to your bank account";
    } else {
      title = "💳 Withdrawal $status";
      message = "₹$amount withdrawal via $method is $status";
    }
    
    print('🔔 Creating notification for withdrawal: ₹$amount');
    
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Use timestamp as ID
      title: title,
      body: message,
      payload: json.encode({
        'type': 'withdrawal',
        'amount': amount,
        'status': status,
        'method': method,
        'action': 'view_wallet',
      }),
      type: 'withdrawal',
    );
  }

  // Show notification for accident accepted
  static Future<void> showAccidentAcceptedNotification({
    required int accidentId,
    required String location,
    required String clientName,
  }) async {
    await showNotification(
      id: accidentId + 1000,
      title: 'Accident Report Accepted',
      body: 'You accepted accident #$accidentId at $location for $clientName',
      type: 'accident_accepted',
    );
  }

  // Show notification for accident rejected
  static Future<void> showAccidentRejectedNotification({
    required int accidentId,
    required String location,
    required String clientName,
  }) async {
    await showNotification(
      id: accidentId + 2000,
      title: 'Accident Report Rejected',
      body: 'You rejected accident #$accidentId at $location for $clientName',
      type: 'accident_rejected',
    );
  }

  // Show notification for accident cancelled
  static Future<void> showAccidentCancelledNotification({
    required int accidentId,
    required String location,
    required String clientName,
  }) async {
    await showNotification(
      id: accidentId + 3000,
      title: 'Accident Report Cancelled',
      body: 'You cancelled accident #$accidentId at $location for $clientName',
      type: 'accident_cancelled',
    );
  }

  // Show notification for earning added
  static Future<void> showEarningAddedNotification({
    required int tripId,
    required double amount,
    required String clientName,
  }) async {
    await showNotification(
      id: tripId + 5000,
      title: 'Earning Added',
      body: 'Earning of ₹${amount.toStringAsFixed(0)} added for trip #$tripId with $clientName',
      type: 'earning_added',
    );
  }

  // Show notification for withdrawal requested
  static Future<void> showWithdrawalRequestedNotification({
    required int withdrawalId,
    required double amount,
  }) async {
    await showNotification(
      id: withdrawalId + 6000,
      title: 'Withdrawal Requested',
      body: 'Withdrawal of ₹${amount.toStringAsFixed(0)} has been requested',
      type: 'withdrawal_requested',
    );
  }

  // Show notification for withdrawal completed
  static Future<void> showWithdrawalCompletedNotification({
    required int withdrawalId,
    required double amount,
  }) async {
    await showNotification(
      id: withdrawalId + 7000,
      title: 'Withdrawal Completed',
      body: 'Withdrawal of ₹${amount.toStringAsFixed(0)} has been completed',
      type: 'withdrawal_completed',
    );
  }

  // Show notification for wallet balance updated
  static Future<void> showWalletBalanceNotification({
    required double newBalance,
    required double amount,
    required String transactionType,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Wallet Balance Updated',
      body: 'Wallet balance is now ₹${newBalance.toStringAsFixed(0)} ($transactionType: ₹${amount.toStringAsFixed(0)})',
      type: 'wallet_balance',
    );
  }
}

// Notification data model
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