import 'package:flutter/foundation.dart';
import '../models/emergency_request.dart';

class EmergencyProvider with ChangeNotifier {
  EmergencyRequest? _currentEmergency;
  bool _isSimulationMode = false;
  int _timerSeconds = 30; // Start with 30 seconds
  bool _isTimerRunning = false;
  bool _isAccepted = false;
  bool _isDeclined = false;

  EmergencyRequest? get currentEmergency => _currentEmergency;
  bool get isSimulationMode => _isSimulationMode;
  int get timerSeconds => _timerSeconds;
  bool get isTimerRunning => _isTimerRunning;
  bool get isAccepted => _isAccepted;
  bool get isDeclined => _isDeclined;
  bool get hasActiveEmergency => _currentEmergency != null && _currentEmergency!.status == 'pending' && !_isAccepted && !_isDeclined;

  // Start simulation mode
  void startSimulation() {
    _isSimulationMode = true;
    notifyListeners();
  }

  // Stop simulation mode
  void stopSimulation() {
    _isSimulationMode = false;
    _currentEmergency = null;
    _stopTimer();
    notifyListeners();
  }

  // Create new emergency request
  void createEmergencyRequest(EmergencyRequest request) {
    _currentEmergency = request;
    _isAccepted = false;
    _isDeclined = false;
    _timerSeconds = 30; // Reset to 30 seconds
    _startTimer();
    notifyListeners();
  }

  // Accept emergency request
  void acceptEmergency() {
    if (_currentEmergency != null) {
      _isAccepted = true;
      _isDeclined = false;
      _currentEmergency = _currentEmergency!.copyWith(status: 'accepted');
      _stopTimer();
      notifyListeners();
    }
  }

  // Decline emergency request
  void declineEmergency() {
    if (_currentEmergency != null) {
      _isAccepted = false;
      _isDeclined = true;
      _currentEmergency = _currentEmergency!.copyWith(status: 'declined');
      _stopTimer();
      notifyListeners();
    }
  }

  // Cancel accept/decline (give another chance)
  void cancelDecision() {
    _isAccepted = false;
    _isDeclined = false;
    _timerSeconds = 30; // Reset timer
    _startTimer();
    notifyListeners();
  }

  // Clear current emergency
  void clearEmergency() {
    _currentEmergency = null;
    _stopTimer();
    notifyListeners();
  }

  // Start timer
  void _startTimer() {
    _timerSeconds = 30;
    _isTimerRunning = true;
    _updateTimer();
  }

  // Stop timer
  void _stopTimer() {
    _isTimerRunning = false;
  }

  // Update timer
  void _updateTimer() {
    if (_isTimerRunning) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isTimerRunning) {
          _timerSeconds--;
          notifyListeners();
          
          // Auto-decline when timer reaches 0
          if (_timerSeconds <= 0) {
            _isTimerRunning = false;
            _isDeclined = true;
            _isAccepted = false;
            if (_currentEmergency != null) {
              _currentEmergency = _currentEmergency!.copyWith(status: 'declined');
            }
            notifyListeners();
          } else {
            _updateTimer();
          }
        }
      });
    }
  }

  // Get formatted timer string
  String get formattedTimer {
    final minutes = _timerSeconds ~/ 60;
    final seconds = _timerSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
