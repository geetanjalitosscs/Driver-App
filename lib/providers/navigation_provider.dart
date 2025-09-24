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
}
