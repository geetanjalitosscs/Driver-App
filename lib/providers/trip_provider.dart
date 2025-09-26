import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/trip.dart';
import '../models/earning.dart';
import '../models/wallet.dart';
import '../models/withdrawal.dart';
import '../services/api_service.dart';
import '../config/database_config.dart';

class TripProvider extends ChangeNotifier {
  List<Trip> _allTrips = [];
  List<Trip> _completedTrips = [];
  List<Trip> _ongoingTrips = [];
  List<Earning> _earnings = [];
  Wallet? _wallet;
  List<Withdrawal> _withdrawals = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  Trip? _currentTrip;
  String _selectedPeriod = 'all';

  // Getters
  List<Trip> get allTrips => _allTrips;
  List<Trip> get completedTrips => _completedTrips;
  List<Trip> get ongoingTrips => _ongoingTrips;
  List<Earning> get earnings => _earnings;
  Wallet? get wallet => _wallet;
  List<Withdrawal> get withdrawals => _withdrawals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Trip? get currentTrip => _currentTrip;
  String get selectedPeriod => _selectedPeriod;

  // Get filtered completed trips based on selected period
  List<Trip> get filteredCompletedTrips {
    if (_selectedPeriod == 'all') {
      return _completedTrips;
    }

    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'year':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        return _completedTrips;
    }

    return _completedTrips.where((trip) {
      return trip.endTime != null && trip.endTime!.isAfter(startDate);
    }).toList();
  }

  // Get current ongoing trip (should be only one)
  Trip? get currentOngoingTrip {
    if (_ongoingTrips.isNotEmpty) {
      return _ongoingTrips.first;
    }
    return null;
  }

  // Get total earnings
  double get totalEarnings {
    return _earnings.fold(0.0, (sum, earning) => sum + earning.amount);
  }

  // Get today's earnings
  double get todayEarnings {
    final today = DateTime.now();
    return _earnings.where((earning) {
      return earning.earningDate.year == today.year &&
             earning.earningDate.month == today.month &&
             earning.earningDate.day == today.day;
    }).fold(0.0, (sum, earning) => sum + earning.amount);
  }

  // Get this week's earnings
  double get weekEarnings {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return _earnings.where((earning) {
      return earning.earningDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
             earning.earningDate.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).fold(0.0, (sum, earning) => sum + earning.amount);
  }

  // Get this month's earnings
  double get monthEarnings {
    final now = DateTime.now();
    return _earnings.where((earning) {
      return earning.earningDate.year == now.year &&
             earning.earningDate.month == now.month;
    }).fold(0.0, (sum, earning) => sum + earning.amount);
  }

  // Load all trips for a driver
  Future<void> loadDriverTrips(int driverId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _allTrips = await CentralizedApiService.getDriverTrips(driverId);
      _completedTrips = _allTrips.where((trip) => trip.isCompleted).toList();
      _ongoingTrips = _allTrips.where((trip) => trip.isOngoing).toList();
      
      // Sort trips by creation date (newest first)
      _completedTrips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _ongoingTrips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load trips: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load completed trips only
  Future<void> loadCompletedTrips(int driverId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _completedTrips = await CentralizedApiService.getCompletedTrips(driverId);
      _completedTrips.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      _setError('Failed to load completed trips: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Set period for filtering trips
  void setPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  // Load ongoing trips only
  Future<void> loadOngoingTrips(int driverId) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Get all trips and filter ongoing ones
      final allTrips = await CentralizedApiService.getDriverTrips(driverId);
      _ongoingTrips = allTrips.where((trip) => trip.isOngoing).toList();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load ongoing trips: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Accept a trip
  Future<bool> acceptTrip(int tripId, int driverId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await CentralizedApiService.acceptTrip(tripId: tripId, driverId: driverId);
      final success = result['success'] == true;
      if (success) {
        // Reload trips to get updated status
        await loadDriverTrips(driverId);
        _setCurrentTrip(tripId);
      }
      return success;
    } catch (e) {
      _setError('Failed to accept trip: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Complete a trip
  Future<Map<String, dynamic>> completeTrip({
    required int tripId,
    required int driverId,
    required double endLatitude,
    required double endLongitude,
    required String endLocation,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await CentralizedApiService.completeTrip(
        tripId: tripId,
        driverId: driverId,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );
      
      if (result['success'] == true) {
        // Reload trips to get updated status
        await loadDriverTrips(driverId);
        _clearCurrentTrip();
      }
      
      return result;
    } catch (e) {
      _setError('Failed to complete trip: $e');
      return {'success': false, 'message': 'Error completing trip: $e'};
    } finally {
      _setLoading(false);
    }
  }

  // Cancel a trip
  Future<bool> cancelTrip(int tripId, int driverId, String reason) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Note: Cancel trip functionality needs to be implemented in centralized service
      // For now, we'll simulate success
      final success = true;
      if (success) {
        // Reload trips to get updated status
        await loadDriverTrips(driverId);
        _clearCurrentTrip();
      }
      return success;
    } catch (e) {
      _setError('Failed to cancel trip: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load driver earnings
  Future<void> loadDriverEarnings(int driverId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _earnings = await CentralizedApiService.getDriverEarnings(driverId: driverId, period: 'all');
      _earnings.sort((a, b) => b.earningDate.compareTo(a.earningDate));
      notifyListeners();
    } catch (e) {
      _setError('Failed to load earnings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load driver wallet
  Future<void> loadDriverWallet(int driverId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _wallet = await CentralizedApiService.getWallet(driverId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load wallet: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Request withdrawal
  Future<bool> requestWithdrawal(int driverId, double amount) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Note: Request withdrawal needs bank account ID - using placeholder for now
      final result = await CentralizedApiService.requestWithdrawal(
        driverId: driverId,
        amount: amount,
        bankAccountId: '1', // Placeholder - should be selected by user
      );
      final success = result['success'] == true;
      if (success) {
        // Reload wallet and withdrawal history
        await loadDriverWallet(driverId);
        await loadWithdrawalHistory(driverId);
      }
      return success;
    } catch (e) {
      _setError('Failed to request withdrawal: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load withdrawal history
  Future<void> loadWithdrawalHistory(int driverId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _withdrawals = await CentralizedApiService.getWithdrawals(driverId);
      _withdrawals.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
      notifyListeners();
    } catch (e) {
      _setError('Failed to load withdrawal history: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Validate trip completion
  Future<Map<String, dynamic>> validateTripCompletion({
    required int tripId,
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    try {
      // Note: Trip validation logic needs to be implemented
      // For now, return a simple validation
      return {
        'success': true,
        'message': 'Trip validation passed',
        'distance': 0.0,
        'duration': 0,
      };
    } catch (e) {
      return {'success': false, 'message': 'Validation error: $e'};
    }
  }

  // Set current trip
  void _setCurrentTrip(int historyId) {
    _currentTrip = _allTrips.firstWhere(
      (trip) => trip.historyId == historyId,
      orElse: () => _ongoingTrips.firstWhere(
        (trip) => trip.historyId == historyId,
      ),
    );
    notifyListeners();
  }

  // Clear current trip
  void _clearCurrentTrip() {
    _currentTrip = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear all data (for logout)
  void clearAllData() {
    _allTrips.clear();
    _completedTrips.clear();
    _ongoingTrips.clear();
    _earnings.clear();
    _wallet = null;
    _withdrawals.clear();
    _currentTrip = null;
    _selectedPeriod = 'all';
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Update trip location
  Future<void> updateTripLocation(int tripId, double latitude, double longitude) async {
    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.baseUrl}/update_trip_location.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trip_id': tripId,
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Update local trip data
          final tripIndex = _allTrips.indexWhere((trip) => trip.historyId == tripId);
          if (tripIndex != -1) {
            _allTrips[tripIndex] = _allTrips[tripIndex].copyWith(
              currentLatitude: latitude,
              currentLongitude: longitude,
              lastLocationUpdate: DateTime.now(),
            );
            notifyListeners();
          }
        }
      }
    } catch (e) {
      print('Error updating trip location: $e');
    }
  }

  // Refresh all data for a driver
  Future<void> refreshAllData(int driverId) async {
    await Future.wait([
      loadDriverTrips(driverId),
      loadDriverEarnings(driverId),
      loadDriverWallet(driverId),
      loadWithdrawalHistory(driverId),
    ]);
  }
}
