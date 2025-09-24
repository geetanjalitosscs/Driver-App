import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';
import '../models/earning.dart';
import '../models/payment.dart';
import '../models/wallet.dart';
import '../models/withdrawal.dart';
import '../config/database_config.dart';

class TripApiService {
  static const String baseUrl = DatabaseConfig.baseUrl;

  // Fetch all trips for a driver
  static Future<List<Trip>> fetchDriverTrips(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_driver_trips.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Trip.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch trips: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching trips: $e');
    }
  }

  // Fetch completed trips for a driver
  static Future<List<Trip>> fetchCompletedTrips(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_completed_trips.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Trip.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch completed trips: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching completed trips: $e');
    }
  }

  // Fetch ongoing trips for a driver
  static Future<List<Trip>> fetchOngoingTrips(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_ongoing_trips.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Trip.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch ongoing trips: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ongoing trips: $e');
    }
  }

  // Accept a trip (change status to ongoing)
  static Future<bool> acceptTrip(int tripId, int driverId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accept_trip.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trip_id': tripId,
          'driver_id': driverId,
          'status': 'ongoing',
          'start_time': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] == true;
      } else {
        throw Exception('Failed to accept trip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error accepting trip: $e');
    }
  }

  // Complete a trip with validation
  static Future<Map<String, dynamic>> completeTrip({
    required int tripId,
    required int driverId,
    required double endLatitude,
    required double endLongitude,
    required String endLocation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/complete_trip.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trip_id': tripId,
          'driver_id': driverId,
          'end_latitude': endLatitude,
          'end_longitude': endLongitude,
          'end_location': endLocation,
          'end_time': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to complete trip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error completing trip: $e');
    }
  }

  // Cancel a trip
  static Future<bool> cancelTrip(int tripId, int driverId, String reason) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cancel_trip.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trip_id': tripId,
          'driver_id': driverId,
          'status': 'cancelled',
          'cancellation_reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] == true;
      } else {
        throw Exception('Failed to cancel trip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error cancelling trip: $e');
    }
  }

  // Fetch driver earnings
  static Future<List<Earning>> fetchDriverEarnings(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_driver_earnings.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Earning.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch earnings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching earnings: $e');
    }
  }

  // Fetch driver wallet
  static Future<Wallet?> fetchDriverWallet(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_driver_wallet.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['wallet'] != null) {
          return Wallet.fromJson(data['wallet']);
        }
        return null;
      } else {
        throw Exception('Failed to fetch wallet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching wallet: $e');
    }
  }

  // Request withdrawal
  static Future<bool> requestWithdrawal(int driverId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request_withdrawal.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] == true;
      } else {
        throw Exception('Failed to request withdrawal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error requesting withdrawal: $e');
    }
  }

  // Fetch withdrawal history
  static Future<List<Withdrawal>> fetchWithdrawalHistory(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_withdrawal_history.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Withdrawal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch withdrawal history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching withdrawal history: $e');
    }
  }

  // Validate trip completion
  static Future<Map<String, dynamic>> validateTripCompletion({
    required int tripId,
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validate_trip_completion.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trip_id': tripId,
          'start_latitude': startLatitude,
          'start_longitude': startLongitude,
          'end_latitude': endLatitude,
          'end_longitude': endLongitude,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to validate trip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error validating trip: $e');
    }
  }
}
