import 'package:flutter/foundation.dart';
import '../models/accident_report.dart';
import '../services/accident_service.dart';
import '../services/accident_api_service.dart';
import '../services/database_helper.dart';
import '../services/navigation_service.dart';

class AccidentProvider extends ChangeNotifier {
  List<AccidentReport> _accidentList = [];
  AccidentReport? _currentAccident;
  bool _isLoading = false;
  String? _errorMessage;
  int _pendingCount = 0;

  // Getters
  List<AccidentReport> get accidentList => _accidentList;
  AccidentReport? get currentAccident => _currentAccident;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get pendingCount => _pendingCount;
  bool get hasCurrentAccident => _currentAccident != null;
  bool get hasMoreAccidents => _accidentList.length > 1;

  /// Load all pending accidents from API
  Future<void> loadAccidents() async {
    _setLoading(true);
    _clearError();

    try {
      final allAccidents = await AccidentApiService.fetchAccidentReports();
      
      // Filter only pending accidents
      _accidentList = allAccidents.where((accident) => accident.status == 'pending').toList();
      _pendingCount = _accidentList.length;
      
      if (_accidentList.isNotEmpty) {
        _currentAccident = _accidentList[0];
      } else {
        _currentAccident = null;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load accidents: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Accept current accident report
  Future<bool> acceptCurrentAccident({
    bool showNext = true,
    double? currentLat,
    double? currentLng,
  }) async {
    if (_currentAccident == null) return false;

    try {
      final success = await AccidentApiService.acceptAccidentReport(_currentAccident!.id);

      if (success) {
        // Open location in Google Maps with current location for navigation
        if (currentLat != null && currentLng != null) {
          await NavigationService.openGoogleMapsWithCurrentLocation(
            currentLat: currentLat,
            currentLng: currentLng,
            destinationLat: _currentAccident!.latitude,
            destinationLng: _currentAccident!.longitude,
            destinationName: _currentAccident!.location,
          );
        } else {
          // Fallback to simple navigation without current location
          await NavigationService.openGoogleMaps(
            destinationLat: _currentAccident!.latitude,
            destinationLng: _currentAccident!.longitude,
            destinationName: _currentAccident!.location,
          );
        }

        _moveToNextAccident();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to accept accident: $e');
      return false;
    }
  }

  /// Reject current accident report
  Future<bool> rejectCurrentAccident() async {
    if (_currentAccident == null) return false;

    try {
      final success = await AccidentApiService.rejectAccidentReport(_currentAccident!.id);

      if (success) {
        _moveToNextAccident();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to reject accident: $e');
      return false;
    }
  }

  /// Move to next accident in the list
  void _moveToNextAccident() {
    if (_accidentList.length > 1) {
      _accidentList.removeAt(0);
      _currentAccident = _accidentList[0];
      _pendingCount = _accidentList.length;
    } else {
      _currentAccident = null;
      _pendingCount = 0;
    }
    notifyListeners();
  }

  /// Refresh pending count from API
  Future<void> refreshPendingCount() async {
    try {
      final allAccidents = await AccidentApiService.fetchAccidentReports();
      
      // Filter only pending accidents
      _accidentList = allAccidents.where((accident) => accident.status == 'pending').toList();
      _pendingCount = _accidentList.length;
      
      if (_accidentList.isNotEmpty && _currentAccident == null) {
        _currentAccident = _accidentList[0];
      } else if (_accidentList.isEmpty) {
        _currentAccident = null;
      }
      
      notifyListeners();
    } catch (e) {
      print('Error refreshing pending count: $e');
    }
  }

  /// Refresh accident list
  Future<void> refreshAccidents() async {
    await loadAccidents();
  }

  /// Clear current accident (when all are processed)
  void clearCurrentAccident() {
    _currentAccident = null;
    notifyListeners();
  }

  /// Cancel all remaining reports (only when explicitly declining after accept)
  Future<void> cancelAllRemainingReports() async {
    if (_currentAccident == null) return;
    
    try {
      // Cancel all remaining pending reports
      final conn = await DatabaseHelper.connect();
      await conn.query(
        'UPDATE accidents SET status = "cancelled" WHERE status = "pending" AND id > ?', 
        [_currentAccident!.id]
      );
      await DatabaseHelper.closeConnection(conn);
      
      _currentAccident = null;
      _pendingCount = 0;
      _accidentList.clear();
      notifyListeners();
    } catch (e) {
      _setError('Failed to cancel remaining reports: $e');
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
  }

  /// Get accident details for navigation
  Map<String, dynamic> getAccidentDetails() {
    if (_currentAccident == null) return {};
    
    return {
      'id': _currentAccident!.id,
      'fullname': _currentAccident!.fullname,
      'phone': _currentAccident!.phone,
      'vehicle': _currentAccident!.vehicle,
      'accidentDate': _currentAccident!.accidentDate,
      'location': _currentAccident!.location,
      'latitude': _currentAccident!.latitude,
      'longitude': _currentAccident!.longitude,
      'description': _currentAccident!.description,
      'photo': _currentAccident!.photo,
      'createdAt': _currentAccident!.createdAt,
    };
  }
}
