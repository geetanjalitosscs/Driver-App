import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/notification_item.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  
  List<NotificationItem> get filteredNotifications {
    return _notifications;
  }

  List<NotificationItem> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // Add a new notification
  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
    required Map<String, dynamic> actionData,
    String? id,
  }) {
    final notification = NotificationItem(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
      actionData: actionData,
    );

    _notifications.insert(0, notification); // Add to beginning
    notifyListeners();
  }

  // Mark notification as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  // Remove notification
  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  // Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Clear old notifications (older than 7 days)
  void clearOldNotifications() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    _notifications.removeWhere((n) => n.timestamp.isBefore(sevenDaysAgo));
    notifyListeners();
  }

  // Notification methods for different events
  
  // Accident Report Notifications
  void addAccidentReportNotification({
    required String location,
    required int accidentId,
    required String clientName,
  }) {
    addNotification(
      id: 'accident_$accidentId',
      title: 'New Accident Report',
      message: 'Accident reported at $location by $clientName. Click to accept.',
      type: NotificationType.accident,
      actionData: {
        'accident_id': accidentId,
        'location': location,
        'client_name': clientName,
        'action': 'view_accident',
      },
    );
  }

  // Trip Acceptance Notifications
  void addTripAcceptedNotification({
    required String location,
    required int accidentId,
    required double amount,
  }) {
    addNotification(
      id: 'trip_accepted_$accidentId',
      title: 'Trip Accepted',
      message: 'You have accepted the accident report at $location. Navigate to complete the trip.',
      type: NotificationType.trip,
      actionData: {
        'accident_id': accidentId,
        'location': location,
        'amount': amount,
        'action': 'navigate_to_trip',
      },
    );
  }

  // Trip Completion Notifications
  void addTripCompletedNotification({
    required String location,
    required double amount,
    required int tripId,
  }) {
    addNotification(
      id: 'trip_completed_$tripId',
      title: 'Trip Completed',
      message: 'Trip completed successfully! Fare: ₹${amount.toStringAsFixed(0)} has been added to your earnings.',
      type: NotificationType.earning,
      actionData: {
        'trip_id': tripId,
        'amount': amount,
        'location': location,
        'action': 'view_earnings',
      },
    );
  }

  // Earnings Notifications
  void addEarningsNotification({
    required double amount,
    required String period,
    required int totalTrips,
  }) {
    addNotification(
      id: 'earnings_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Earnings Updated',
      message: 'Your $period earnings: ₹${amount.toStringAsFixed(0)} from $totalTrips trips. Keep up the great work!',
      type: NotificationType.earning,
      actionData: {
        'amount': amount,
        'period': period,
        'total_trips': totalTrips,
        'action': 'view_earnings',
      },
    );
  }

  // Withdrawal Notifications
  void addWithdrawalNotification({
    required double amount,
    required String status,
    required String withdrawalId,
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
    );
  }

  // Wallet Balance Notifications
  void addWalletBalanceNotification({
    required double balance,
    required double previousBalance,
  }) {
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
    );
  }

  // System Notifications
  void addSystemNotification({
    required String title,
    required String message,
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
    );
  }

  // Load notifications from storage (for persistence)
  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, you would load from local storage or API
      // For now, we'll just clear old notifications
      clearOldNotifications();
    } catch (e) {
      _errorMessage = 'Failed to load notifications: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save notifications to storage (for persistence)
  Future<void> saveNotifications() async {
    try {
      // In a real app, you would save to local storage or API
      // For now, we'll just clear old notifications
      clearOldNotifications();
    } catch (e) {
      _errorMessage = 'Failed to save notifications: $e';
      notifyListeners();
    }
  }

  // Initialize with some sample notifications
  void initializeWithSampleNotifications() {
    if (_notifications.isEmpty) {
      addSystemNotification(
        title: 'Welcome to Apatkal Driver App',
        message: 'You\'re all set! Start by accepting accident reports to begin earning.',
      );
    }
  }
}
