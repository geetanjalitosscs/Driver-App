import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_item.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationItem> _notifications = [];
  Set<String> _notificationIds = {}; // Track unique notification IDs
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasSeenNotifications = false; // Track if user has seen notifications (clears main indicator)

  // Getters
  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasSeenNotifications => _hasSeenNotifications;
  
  // Main indicator shows unread count only if user hasn't seen notifications yet
  int get unreadCount {
    // Show count if there are unread notifications and user hasn't seen the notifications page recently
    final unreadNotifications = _notifications.where((n) => !n.isRead).length;
    return unreadNotifications > 0 && !_hasSeenNotifications ? unreadNotifications : 0;
  }

  /// Update app badge count based on unread notifications
  Future<void> _updateAppBadge() async {
    try {
      final count = unreadCount;
      await NotificationService.setAppBadgeCount(count);
      print('📱 App badge updated: $count unread notifications');
    } catch (e) {
      print('❌ Failed to update app badge: $e');
    }
  }

  /// Manually update app badge (for testing or external calls)
  Future<void> updateAppBadge() async {
    await _updateAppBadge();
  }
  
  List<NotificationItem> get filteredNotifications {
    return _notifications;
  }

  List<NotificationItem> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // Initialize notifications from storage for specific driver
  Future<void> initializeNotifications(String driverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getString('driver_notifications_$driverId');
      
      if (notificationsJson != null) {
        final List<dynamic> notificationsList = json.decode(notificationsJson);
        _notifications = notificationsList
            .map((json) => NotificationItem.fromJson(json))
            .toList();
        
        // Update notification IDs set
        _notificationIds = _notifications.map((n) => n.id).toSet();
        
        notifyListeners();
        
        // Update app badge count after loading notifications
        _updateAppBadge();
        
        print('Loaded ${_notifications.length} notifications for driver $driverId from storage');
      } else {
        print('No notifications found for driver $driverId');
        // Update app badge count even if no notifications
        _updateAppBadge();
      }
    } catch (e) {
      print('Error loading notifications for driver $driverId: $e');
    }
  }

  // Save notifications to storage for specific driver
  Future<void> _saveNotifications(String driverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = json.encode(
        _notifications.map((n) => n.toJson()).toList(),
      );
      await prefs.setString('driver_notifications_$driverId', notificationsJson);
      print('Saved ${_notifications.length} notifications for driver $driverId to storage');
    } catch (e) {
      print('Error saving notifications for driver $driverId: $e');
    }
  }

  // Add a new notification (ensures uniqueness)
  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
    required Map<String, dynamic> actionData,
    required String driverId,
    String? id,
  }) {
    final notificationId = id ?? DateTime.now().millisecondsSinceEpoch.toString();
    
    // Check if notification already exists
    if (_notificationIds.contains(notificationId)) {
      print('Notification $notificationId already exists, skipping...');
      return;
    }

    final notification = NotificationItem(
      id: notificationId,
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
      actionData: actionData,
    );

    _notifications.insert(0, notification); // Add to beginning
    _notificationIds.add(notificationId); // Track ID
    
    // Mark that there are unseen notifications (show red indicator)
    _hasSeenNotifications = false;
    
    print('🔔 Added notification: $title - Unread count: ${unreadCount}');
    
    notifyListeners();
    
    // Update app badge count
    _updateAppBadge();
    
    // Save to persistent storage
    _saveNotifications(driverId);
  }

  // Mark notification as read
  void markAsRead(String id, String driverId) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
      
      // Update app badge count
      _updateAppBadge();
      
      _saveNotifications(driverId); // Save to persistent storage
    }
  }

  // Mark all notifications as read
  void markAllAsRead(String driverId) {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
    
    // Update app badge count
    _updateAppBadge();
    
    _saveNotifications(driverId); // Save to persistent storage
  }

  // Mark all notifications as read immediately (for navigation)
  void markAllAsReadImmediately() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
    
    // Update app badge count
    _updateAppBadge();
  }

  // Mark notifications as "seen" (clears main indicator but keeps individual dots)
  void markNotificationsAsSeen() {
    _hasSeenNotifications = true;
    notifyListeners();
    
    // Update app badge count
    _updateAppBadge();
  }

  // Clear main notification indicator (for bottom navigation) without affecting individual dots
  void clearMainIndicator() {
    // This method can be used to clear the main red indicator in bottom navigation
    // without affecting the individual notification dots
    markNotificationsAsSeen();
  }

  // Remove notification
  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  // Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    _notificationIds.clear();
    notifyListeners();
    
    // Update app badge count
    _updateAppBadge();
  }

  // Clear old notifications (older than 30 days) - but keep them longer for account persistence
  void clearOldNotifications(String driverId) {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    _notifications.removeWhere((n) => n.timestamp.isBefore(thirtyDaysAgo));
    notifyListeners();
    _saveNotifications(driverId);
  }

  // Clear ALL notifications for a driver (for account deletion)
  Future<void> clearAllNotificationsForDriver(String driverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('driver_notifications_$driverId');
      _notifications.clear();
      _notificationIds.clear();
      notifyListeners();
      
      // Update app badge count
      _updateAppBadge();
      
      print('Cleared all notifications for driver $driverId');
    } catch (e) {
      print('Error clearing notifications for driver $driverId: $e');
    }
  }

  // Notification methods for different events
  
  // Complete Notification Flow Methods
  
  // 1. New Accident Report Added
  void addAccidentReportNotification({
    required String location,
    required int accidentId,
    required String clientName,
    required String driverId,
  }) {
    addNotification(
      id: 'accident_report_$accidentId',
      title: 'New Accident Report Added',
      message: 'Accident report #$accidentId at $location by $clientName',
      type: NotificationType.accident,
      actionData: {
        'accident_id': accidentId,
        'location': location,
        'client_name': clientName,
        'action': 'view_accident',
      },
      driverId: driverId,
    );
  }

  // 2. Accident Report Accepted
  void addAccidentAcceptedNotification({
    required int accidentId,
    required String location,
    required String clientName,
    required String driverId,
  }) {
    addNotification(
      id: 'accident_accepted_$accidentId',
      title: 'Accident Report Accepted',
      message: 'You accepted accident #$accidentId at $location for $clientName',
      type: NotificationType.trip,
      actionData: {
        'accident_id': accidentId,
        'location': location,
        'client_name': clientName,
        'action': 'navigate_to_trip',
      },
      driverId: driverId,
    );
  }

  // 3. Accident Report Rejected
  void addAccidentRejectedNotification({
    required int accidentId,
    required String location,
    required String clientName,
    required String driverId,
  }) {
    addNotification(
      id: 'accident_rejected_$accidentId',
      title: 'Accident Report Rejected',
      message: 'You rejected accident #$accidentId at $location for $clientName',
      type: NotificationType.accident,
      actionData: {
        'accident_id': accidentId,
        'location': location,
        'client_name': clientName,
        'action': 'view_home',
      },
      driverId: driverId,
    );
  }

  // 4. Accident Report Cancelled
  void addAccidentCancelledNotification({
    required int accidentId,
    required String location,
    required String clientName,
    required String driverId,
  }) {
    addNotification(
      id: 'accident_cancelled_$accidentId',
      title: 'Accident Report Cancelled',
      message: 'You cancelled accident #$accidentId at $location for $clientName',
      type: NotificationType.accident,
      actionData: {
        'accident_id': accidentId,
        'location': location,
        'client_name': clientName,
        'action': 'view_home',
      },
      driverId: driverId,
    );
  }

  // Trip Acceptance Notifications
  void addTripAcceptedNotification({
    required String location,
    required int accidentId,
    required String driverId,
  }) {
    addNotification(
      id: 'trip_accepted_$accidentId',
      title: 'Accident Report Accepted',
      message: 'You accepted accident #$accidentId at $location. Navigate to complete the trip.',
      type: NotificationType.trip,
      actionData: {
        'accident_id': accidentId,
        'location': location,
        'action': 'navigate_to_trip',
      },
      driverId: driverId,
    );
  }

  // Trip Completion Notifications - Only for newly completed trips
  void addTripCompletedNotification({
    required String location,
    required int tripId,
    required String driverId,
    String? vehicleNumber,
  }) {
    addNotification(
      id: 'trip_completed_$tripId',
      title: 'Trip Completed',
      message: 'Trip #$tripId completed for vehicle ${vehicleNumber ?? 'unknown'}.',
      type: NotificationType.trip,
      actionData: {
        'trip_id': tripId,
        'location': location,
        'vehicle_number': vehicleNumber,
        'action': 'view_trips',
      },
      driverId: driverId,
    );
  }

  // Earnings Notifications - Only for new earnings, not existing ones
  void addEarningsNotification({
    required double amount,
    required String period,
    required int totalTrips,
    required String driverId,
    bool isNewEarning = true, // Only add notification for new earnings
  }) {
    if (!isNewEarning) {
      print('Skipping earnings notification - not a new earning');
      return;
    }
    
    addNotification(
      id: 'earnings_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Earnings Update',
      message: '₹${amount.toStringAsFixed(0)} earned in $period from $totalTrips trips',
      type: NotificationType.earning,
      actionData: {
        'amount': amount,
        'period': period,
        'total_trips': totalTrips,
        'action': 'view_earnings',
      },
      driverId: driverId,
    );
  }

  // KYC Approval Notifications
  void addKycApprovalNotification({
    required String status,
    required String driverId,
    String? customMessage,
  }) {
    String title;
    String message;
    String action;
    
    switch (status.toLowerCase()) {
      case 'approved':
        title = 'KYC Verification Approved';
        message = customMessage ?? 'Your KYC Verification is approved! You can now use your profile and access all app features.';
        action = 'navigate_to_login';
        break;
      case 'rejected':
        title = 'KYC Verification Rejected';
        message = customMessage ?? 'Your KYC Verification has been rejected. Please contact support for more information.';
        action = 'navigate_to_help';
        break;
      default:
        title = 'KYC Verification Update';
        message = customMessage ?? 'Your KYC Verification status has been updated to: $status';
        action = 'navigate_to_help';
    }
    
    addNotification(
      id: 'kyc_${status}_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: NotificationType.system,
      actionData: {
        'kyc_status': status,
        'action': action,
        'type': 'kyc_$status',
      },
      driverId: driverId,
    );
  }

  // Withdrawal Notifications
  void addWithdrawalNotification({
    required double amount,
    required String status,
    required String withdrawalId,
    required String driverId,
  }) {
    String message;
    switch (status.toLowerCase()) {
      case 'pending':
        message = 'Withdrawal request of ₹${amount.toStringAsFixed(0)} is pending approval.';
        break;
      case 'approved':
        message = 'Withdrawal of ₹${amount.toStringAsFixed(0)} has been approved and will be processed within 2-3 business days.';
        break;
      case 'completed':
        message = 'Withdrawal of ₹${amount.toStringAsFixed(0)} has been completed and credited to your account.';
        break;
      case 'rejected':
        message = 'Withdrawal request of ₹${amount.toStringAsFixed(0)} has been rejected. Please contact support.';
        break;
      default:
        message = 'Withdrawal request of ₹${amount.toStringAsFixed(0)} status updated to $status.';
    }

    addNotification(
      id: 'withdrawal_$withdrawalId',
      title: 'Withdrawal $status',
      message: message,
      type: NotificationType.wallet,
      actionData: {
        'amount': amount,
        'status': status,
        'withdrawal_id': withdrawalId,
        'action': 'view_wallet',
      },
      driverId: driverId,
    );
  }

  // Wallet Balance Notifications - Only for significant changes
  void addWalletBalanceNotification({
    required double balance,
    required double previousBalance,
    required String driverId,
    bool isSignificantChange = true, // Only notify for significant changes
  }) {
    if (!isSignificantChange) {
      print('Skipping wallet balance notification - not a significant change');
      return;
    }
    
    final difference = balance - previousBalance;
    String message;
    
    if (difference > 0) {
      message = 'Your wallet balance has increased by ₹${difference.toStringAsFixed(0)}. Current balance: ₹${balance.toStringAsFixed(0)}.';
    } else if (difference < 0) {
      message = 'Your wallet balance has decreased by ₹${(-difference).toStringAsFixed(0)}. Current balance: ₹${balance.toStringAsFixed(0)}.';
    } else {
      message = 'Your wallet balance is ₹${balance.toStringAsFixed(0)}.';
    }

    addNotification(
      id: 'wallet_balance_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Wallet Balance Updated',
      message: message,
      type: NotificationType.wallet,
      actionData: {
        'balance': balance,
        'previous_balance': previousBalance,
        'difference': difference,
        'action': 'view_wallet',
      },
      driverId: driverId,
    );
  }

  // System Notifications
  void addSystemNotification({
    required String title,
    required String message,
    required String driverId,
    String? action,
  }) {
    addNotification(
      id: 'system_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: NotificationType.system,
      actionData: {
        'action': action ?? 'view_system',
      },
      driverId: driverId,
    );
  }

  // Load notifications from storage (for persistence)
  Future<void> loadNotifications(String driverId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Initialize notifications for the driver
      await initializeNotifications(driverId);
    } catch (e) {
      _errorMessage = 'Failed to load notifications: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save notifications to storage (for persistence)
  Future<void> saveNotifications(String driverId) async {
    try {
      // Save notifications for the driver
      await _saveNotifications(driverId);
    } catch (e) {
      _errorMessage = 'Failed to save notifications: $e';
      notifyListeners();
    }
  }

  // Initialize with some sample notifications
  void initializeWithSampleNotifications(String driverId) {
    // Check if old welcome notification exists and update it
    final oldWelcomeIndex = _notifications.indexWhere((n) => 
      n.title.toLowerCase().contains('welcome') || 
      n.title.toLowerCase().contains('apatkal')
    );
    
    // Define new welcome notification details
    const newWelcomeTitle = 'Welcome to APATKAL App';
    const newWelcomeMessage = 'You\'re all set! Start by accepting accident reports to begin trips.';
    
    if (oldWelcomeIndex != -1) {
      // Old welcome notification exists - update it with new message
      final oldNotification = _notifications[oldWelcomeIndex];
      
      // Check if it needs updating
      if (oldNotification.title != newWelcomeTitle || oldNotification.message != newWelcomeMessage) {
        // Remove old notification
        _notifications.removeAt(oldWelcomeIndex);
        _notificationIds.remove(oldNotification.id);
        notifyListeners(); // Update UI immediately
        
        // Add updated welcome notification
        addSystemNotification(
          title: newWelcomeTitle,
          message: newWelcomeMessage,
          driverId: driverId,
          action: 'view_accident', // Navigate to home page when clicked
        );
        
        print('🔄 Updated old welcome notification to new version');
      }
    } else if (_notifications.isEmpty) {
      // No notifications at all - add new welcome notification
      addSystemNotification(
        title: newWelcomeTitle,
        message: newWelcomeMessage,
        driverId: driverId,
        action: 'view_accident', // Navigate to home page when clicked
      );
    }
  }
}

