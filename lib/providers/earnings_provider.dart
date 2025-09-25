import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/earning.dart';
import '../services/earnings_api_service.dart';
import '../config/database_config.dart';

class EarningsProvider extends ChangeNotifier {
  List<Earning> _earnings = [];
  List<Earning> _recentEarnings = [];
  Map<String, dynamic> _summary = {};
  List<Map<String, dynamic>> _weeklyData = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedPeriod = 'all';

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
    print('Loading earnings for driver $driverId, period: $period');
    _setLoading(true);
    _clearError();
    _selectedPeriod = period;

    try {
      // Load earnings for the selected period
      _earnings = await EarningsApiService.fetchDriverEarnings(
        driverId: driverId,
        period: period,
      );

      print('Loaded ${_earnings.length} earnings');

      // Calculate summary from earnings data
      await _calculateSummaryWithTrips(driverId);

      // Use earnings as recent earnings for now
      _recentEarnings = _earnings.take(10).toList();

      // Clear weekly data for now
      _weeklyData = [];

      print('Summary: $_summary');
      notifyListeners();
    } catch (e) {
      print('Error in loadDriverEarnings: $e');
      _setError('Failed to load earnings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Calculate summary from earnings data with trip information
  Future<void> _calculateSummaryWithTrips(int driverId) async {
    if (_earnings.isEmpty) {
      _summary = {
        'total_earnings': 0.0,
        'total_trips': 0,
        'average_per_trip': 0.0,
        'total_hours': 0.0,
      };
      return;
    }

    double totalEarnings = _earnings.fold(0.0, (sum, earning) => sum + earning.amount);
    int totalTrips = _earnings.length;
    double averagePerTrip = totalTrips > 0 ? totalEarnings / totalTrips : 0.0;

    // Calculate total hours from trip data
    double totalHours = await _calculateTotalHoursFromTrips(driverId);

    _summary = {
      'total_earnings': totalEarnings,
      'total_trips': totalTrips,
      'average_per_trip': averagePerTrip,
      'total_hours': totalHours,
    };
  }

  // Calculate total hours from trip data
  Future<double> _calculateTotalHoursFromTrips(int driverId) async {
    try {
      // Fetch completed trips to calculate total hours
      final response = await http.get(
        Uri.parse('${DatabaseConfig.baseUrl}/get_completed_trips.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> tripsData = json.decode(response.body);
        double totalHours = 0.0;

        for (var tripData in tripsData) {
          // Calculate hours from trip duration or start/end times
          if (tripData['duration'] != null) {
            totalHours += (tripData['duration'] as num).toDouble() / 60.0; // Convert minutes to hours
          } else if (tripData['start_time'] != null && tripData['end_time'] != null) {
            final startTime = DateTime.parse(tripData['start_time']);
            final endTime = DateTime.parse(tripData['end_time']);
            final duration = endTime.difference(startTime).inMinutes;
            totalHours += duration / 60.0; // Convert minutes to hours
          }
        }

        return totalHours;
      }
    } catch (e) {
      print('Error calculating total hours: $e');
    }
    
    return 0.0;
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
      case 'all':
        return 'All';
      case 'today':
        return 'Today';
      case 'week':
        return 'This Week';
      case 'month':
        return 'This Month';
      case 'year':
        return 'This Year';
      default:
        return 'All';
    }
  }

  // Get total earnings for current period
  double get totalEarnings => _summary['total_earnings']?.toDouble() ?? 0.0;

  // Get today's earnings specifically
  double get todayEarnings {
    final today = DateTime.now();
    return _earnings.where((earning) {
      return earning.earningDate.year == today.year &&
             earning.earningDate.month == today.month &&
             earning.earningDate.day == today.day;
    }).fold(0.0, (sum, earning) => sum + earning.amount);
  }

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

  // Clear all data (for logout)
  void clearAllData() {
    _earnings.clear();
    _summary = {};
    _selectedPeriod = 'all';
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
