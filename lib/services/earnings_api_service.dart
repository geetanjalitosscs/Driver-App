import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/earning.dart';
import '../config/database_config.dart';

class EarningsApiService {
  static const String _baseUrl = DatabaseConfig.baseUrl;

  /// Fetch earnings for a specific driver and time period
  static Future<List<Earning>> fetchDriverEarnings({
    required int driverId,
    required String period, // 'today', 'week', 'month', 'year'
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_driver_earnings.php?driver_id=$driverId&period=$period'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['earnings'] != null) {
          return (data['earnings'] as List)
              .map((json) => Earning.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching driver earnings: $e');
      return [];
    }
  }

  /// Fetch all earnings for a driver (for recent transactions)
  static Future<List<Earning>> fetchRecentEarnings({
    required int driverId,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_recent_earnings.php?driver_id=$driverId&limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['earnings'] != null) {
          return (data['earnings'] as List)
              .map((json) => Earning.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching recent earnings: $e');
      return [];
    }
  }

  /// Fetch earnings summary for a driver
  static Future<Map<String, dynamic>> fetchEarningsSummary({
    required int driverId,
    required String period,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_earnings_summary.php?driver_id=$driverId&period=$period'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data;
        }
      }
      return {
        'total_earnings': 0.0,
        'total_trips': 0,
        'average_per_trip': 0.0,
        'total_hours': 0.0,
      };
    } catch (e) {
      print('Error fetching earnings summary: $e');
      return {
        'total_earnings': 0.0,
        'total_trips': 0,
        'average_per_trip': 0.0,
        'total_hours': 0.0,
      };
    }
  }

  /// Fetch weekly earnings data for chart
  static Future<List<Map<String, dynamic>>> fetchWeeklyEarnings({
    required int driverId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_weekly_earnings.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['weekly_data'] != null) {
          return List<Map<String, dynamic>>.from(data['weekly_data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching weekly earnings: $e');
      return [];
    }
  }
}
