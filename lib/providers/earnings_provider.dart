import 'package:flutter/foundation.dart';
import '../models/earning.dart';
import '../services/earnings_api_service.dart';

class EarningsProvider extends ChangeNotifier {
  List<Earning> _earnings = [];
  List<Earning> _recentEarnings = [];
  Map<String, dynamic> _summary = {};
  List<Map<String, dynamic>> _weeklyData = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedPeriod = 'today';

  // Getters
  List<Earning> get earnings => _earnings;
  List<Earning> get recentEarnings => _recentEarnings;
  Map<String, dynamic> get summary => _summary;
  List<Map<String, dynamic>> get weeklyData => _weeklyData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedPeriod => _selectedPeriod;

  // Load earnings for a specific driver and period
  Future<void> loadDriverEarnings(int driverId, String period) async {
    _setLoading(true);
    _clearError();
    _selectedPeriod = period;

    try {
      // Load earnings for the selected period
      _earnings = await EarningsApiService.fetchDriverEarnings(
        driverId: driverId,
        period: period,
      );

      // Load summary data
      _summary = await EarningsApiService.fetchEarningsSummary(
        driverId: driverId,
        period: period,
      );

      // Load recent earnings (always show last 10)
      _recentEarnings = await EarningsApiService.fetchRecentEarnings(
        driverId: driverId,
        limit: 10,
      );

      // Load weekly data for chart (if period is week or longer)
      if (period == 'week' || period == 'month' || period == 'year') {
        _weeklyData = await EarningsApiService.fetchWeeklyEarnings(
          driverId: driverId,
        );
      } else {
        _weeklyData = [];
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load earnings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh earnings data
  Future<void> refreshEarnings(int driverId) async {
    await loadDriverEarnings(driverId, _selectedPeriod);
  }

  // Change period and reload data
  Future<void> changePeriod(int driverId, String period) async {
    if (period != _selectedPeriod) {
      await loadDriverEarnings(driverId, period);
    }
  }

  // Get formatted period name
  String getPeriodDisplayName() {
    switch (_selectedPeriod) {
      case 'today':
        return 'Today';
      case 'week':
        return 'This Week';
      case 'month':
        return 'This Month';
      case 'year':
        return 'This Year';
      default:
        return 'Today';
    }
  }

  // Get total earnings for current period
  double get totalEarnings => _summary['total_earnings']?.toDouble() ?? 0.0;

  // Get total trips for current period
  int get totalTrips => _summary['total_trips'] ?? 0;

  // Get average per trip
  double get averagePerTrip => _summary['average_per_trip']?.toDouble() ?? 0.0;

  // Get total hours worked
  double get totalHours => _summary['total_hours']?.toDouble() ?? 0.0;

  // Get weekly total for chart
  double get weeklyTotal {
    if (_weeklyData.isEmpty) return 0.0;
    return _weeklyData.fold(0.0, (sum, day) => sum + (day['amount']?.toDouble() ?? 0.0));
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
