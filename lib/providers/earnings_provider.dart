import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/earning.dart';
import '../config/centered_api.dart';
import '../services/notification_service.dart';

class EarningsProvider extends ChangeNotifier {
  List<Earning> _earnings = [];
  List<Earning> _recentEarnings = [];
  Map<String, dynamic> _summary = {};
  Map<String, dynamic> _allTimeSummary = {}; // Always shows all-time data
  List<Map<String, dynamic>> _weeklyData = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedPeriod = 'all';

  // Getters
  List<Earning> get earnings => _earnings;
  List<Earning> get recentEarnings => _recentEarnings;
  Map<String, dynamic> get summary => _summary;
  Map<String, dynamic> get allTimeSummary => _allTimeSummary; // Always shows all-time data
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
      if (period == 'week') {
        // For week period, load all data and filter client-side to ensure last 7 days
        final response = await http.get(
          Uri.parse('${DatabaseConfig.baseUrl}/get_driver_earnings.php?driver_id=$driverId&period=all'),
          headers: {'Content-Type': 'application/json'},
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success'] == true) {
            final List<dynamic> earningsData = data['earnings'];
            final allEarnings = earningsData.map((earning) => Earning.fromJson(earning)).toList();
            
            // Filter for last 7 days
            final now = DateTime.now();
            final sevenDaysAgo = now.subtract(const Duration(days: 7));
            
            _earnings = allEarnings.where((earning) {
              return earning.earningDate.isAfter(sevenDaysAgo);
            }).toList();
            
            print('Loaded ${allEarnings.length} total earnings, filtered to ${_earnings.length} for last 7 days');
          }
        }
      } else {
        final response = await http.get(
          Uri.parse('${DatabaseConfig.baseUrl}/get_driver_earnings.php?driver_id=$driverId&period=$period'),
          headers: {'Content-Type': 'application/json'},
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success'] == true) {
            final List<dynamic> earningsData = data['earnings'];
            _earnings = earningsData.map((earning) => Earning.fromJson(earning)).toList();
            print('Loaded ${_earnings.length} earnings');
          }
        }
      }

      // Calculate summary from filtered earnings data
      await _calculateSummaryWithTrips(driverId);

      // Load all-time data for summary card (only if not already loaded or if period is 'all')
      if (_allTimeSummary.isEmpty || period == 'all') {
        final response = await http.get(
          Uri.parse('${DatabaseConfig.baseUrl}/get_driver_earnings.php?driver_id=$driverId&period=all'),
          headers: {'Content-Type': 'application/json'},
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success'] == true) {
            final List<dynamic> earningsData = data['earnings'];
            final allTimeEarnings = earningsData.map((earning) => Earning.fromJson(earning)).toList();
            await _calculateAllTimeSummaryWithTrips(driverId, allTimeEarnings);
          }
        }
      }

      // Use earnings as recent earnings for now
      _recentEarnings = _earnings.take(10).toList();

      // Clear weekly data for now
      _weeklyData = [];

      print('Summary: $_summary');
      print('All-time Summary: $_allTimeSummary');
      
      // Note: Earnings notifications should only be triggered when new earnings are actually added,
      // not when loading existing data. This prevents persistent notifications on page visits.
      
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

  // Calculate all-time summary from earnings data with trip information
  Future<void> _calculateAllTimeSummaryWithTrips(int driverId, List<Earning> allTimeEarnings) async {
    if (allTimeEarnings.isEmpty) {
      _allTimeSummary = {
        'total_earnings': 0.0,
        'total_trips': 0,
        'average_per_trip': 0.0,
        'total_hours': 0.0,
      };
      return;
    }

    try {
      // Calculate basic earnings summary
      final totalEarnings = allTimeEarnings.fold(0.0, (sum, earning) => sum + earning.amount);
      final totalTrips = allTimeEarnings.length;
      final averagePerTrip = totalTrips > 0 ? totalEarnings / totalTrips : 0.0;

      // Calculate total hours from trip data
      final totalHours = await _calculateTotalHoursFromTrips(driverId);

      _allTimeSummary = {
        'total_earnings': totalEarnings,
        'total_trips': totalTrips,
        'average_per_trip': averagePerTrip,
        'total_hours': totalHours,
      };

      print('All-time summary calculated: $_allTimeSummary');
    } catch (e) {
      print('Error calculating all-time summary: $e');
      _allTimeSummary = {
        'total_earnings': 0.0,
        'total_trips': 0,
        'average_per_trip': 0.0,
        'total_hours': 0.0,
      };
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

  // Add earnings notification only when new earnings are actually added
  void addNewEarningsNotification({
    required double amount,
    required String period,
    required int totalTrips,
    required String driverId,
  }) {
    // This method should be called only when new earnings are actually added,
    // not when loading existing data
    print('Adding new earnings notification: ₹$amount for $totalTrips trips');
    
    // Get NotificationProvider from context and add notification
    // Note: This should be called from UI context where NotificationProvider is available
  }

  // Get formatted period name
  String getPeriodDisplayName() {
    switch (_selectedPeriod) {
      case 'all':
        return 'All';
      case 'today':
        return 'Today';
      case 'week':
        return 'Last 7 Days';
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

  // Get all-time total earnings (for summary card)
  double get allTimeTotalEarnings => _allTimeSummary['total_earnings']?.toDouble() ?? 0.0;

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

  // Get all-time total trips (for summary card)
  int get allTimeTotalTrips => _allTimeSummary['total_trips'] ?? 0;

  // Get average per trip
  double get averagePerTrip => _summary['average_per_trip']?.toDouble() ?? 0.0;

  // Get all-time average per trip (for summary card)
  double get allTimeAveragePerTrip => _allTimeSummary['average_per_trip']?.toDouble() ?? 0.0;

  // Get total hours worked
  double get totalHours => _summary['total_hours']?.toDouble() ?? 0.0;

  // Get all-time total hours (for summary card)
  double get allTimeTotalHours => _allTimeSummary['total_hours']?.toDouble() ?? 0.0;

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
