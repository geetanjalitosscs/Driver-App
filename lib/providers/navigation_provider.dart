import 'package:flutter/foundation.dart';
import 'notification_provider.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  NotificationProvider? _notificationProvider;
  final List<int> _navigationHistory = [0]; // Start with home screen

  int get currentIndex => _currentIndex;
  List<int> get navigationHistory => List.unmodifiable(_navigationHistory);

  void setNotificationProvider(NotificationProvider provider) {
    _notificationProvider = provider;
  }

  void navigateToScreen(int index) {
    if (_currentIndex != index) {
      // Add current index to history before navigating
      if (_navigationHistory.isEmpty || _navigationHistory.last != _currentIndex) {
        _navigationHistory.add(_currentIndex);
      }
      
      _currentIndex = index;
      
      // If navigating to notifications screen (index 4), mark as seen (clears main indicator)
      if (index == 4) {
        _notificationProvider?.markNotificationsAsSeen();
      }
      
      notifyListeners();
    }
  }

  bool navigateBack() {
    if (_navigationHistory.length > 1) {
      // Remove current screen from history
      _navigationHistory.removeLast();
      // Navigate to previous screen
      _currentIndex = _navigationHistory.last;
      notifyListeners();
      return true;
    }
    return false; // No more history, allow app to exit
  }

  void navigateToHome() {
    _currentIndex = 0;
    notifyListeners();
  }

  void navigateToTrips() {
    _currentIndex = 1;
    notifyListeners();
  }

  void navigateToEarnings() {
    _currentIndex = 2;
    notifyListeners();
  }

  void navigateToWallet() {
    _currentIndex = 3;
    notifyListeners();
  }

  void navigateToHelp() {
    _currentIndex = 5;
    notifyListeners();
  }

  void navigateToNotifications() {
    _currentIndex = 4;
    // Mark notifications as seen (clears main indicator but keeps individual dots)
    _notificationProvider?.markNotificationsAsSeen();
    notifyListeners();
  }
}
