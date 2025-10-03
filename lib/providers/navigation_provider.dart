import 'package:flutter/foundation.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void navigateToScreen(int index) {
    _currentIndex = index;
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
}
