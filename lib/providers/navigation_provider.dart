import 'package:flutter/foundation.dart';
import 'notification_provider.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  NotificationProvider? _notificationProvider;

  int get currentIndex => _currentIndex;

  void setNotificationProvider(NotificationProvider provider) {
    _notificationProvider = provider;
  }

  void navigateToScreen(int index) {
    _currentIndex = index;
    
    // If navigating to notifications screen (index 4), mark as seen (clears main indicator)
    if (index == 4) {
      _notificationProvider?.markNotificationsAsSeen();
    }
    
    notifyListeners();
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
