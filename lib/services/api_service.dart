import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/accident_report.dart';
import '../models/earning.dart';
import '../models/trip.dart';
import '../models/payment.dart';
import '../models/wallet.dart';
import '../models/withdrawal.dart';
import '../models/profile_data.dart';
import '../config/database_config.dart';

/// Centralized API Service - All API calls are handled from this single service
class CentralizedApiService {
  static const String _baseUrl = DatabaseConfig.baseUrl;
  static const String _accidentBaseUrl = DatabaseConfig.accidentBaseUrl;

  // ============================================================================
  // AUTHENTICATION APIs
  // ============================================================================

  /// Login API
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Signup API
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String vehicleNumber,
    required String vehicleType,
    required String licenseNumber,
    required String aadharNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/signup.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'vehicle_number': vehicleNumber,
          'vehicle_type': vehicleType,
          'license_number': licenseNumber,
          'aadhar_number': aadharNumber,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Signup failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Signup error: $e');
    }
  }

  /// Update Profile API
  static Future<Map<String, dynamic>> updateProfile({
    required int driverId,
    required String name,
    required String email,
    required String phone,
    required String vehicleNumber,
    required String vehicleType,
    required String licenseNumber,
    required String aadharNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/update_profile.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'name': name,
          'email': email,
          'phone': phone,
          'vehicle_number': vehicleNumber,
          'vehicle_type': vehicleType,
          'license_number': licenseNumber,
          'aadhar_number': aadharNumber,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Profile update failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Profile update error: $e');
    }
  }

  /// Change Password API
  static Future<Map<String, dynamic>> changePassword({
    required int driverId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/change_password.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Password change failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Password change error: $e');
    }
  }

  // ============================================================================
  // EARNINGS APIs
  // ============================================================================

  /// Get Driver Earnings API
  static Future<List<Earning>> getDriverEarnings({
    required int driverId,
    required String period, // 'today', 'week', 'month', 'year', 'all'
  }) async {
    try {
      final url = '$_baseUrl/get_driver_earnings.php?driver_id=$driverId&period=$period';
      print('Fetching earnings from: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['earnings'] != null) {
          final earnings = (data['earnings'] as List)
              .map((json) => Earning.fromJson(json))
              .toList();
          print('Parsed ${earnings.length} earnings');
          return earnings;
        } else {
          print('API returned success=false or no earnings data');
        }
      }
      return [];
    } catch (e) {
      print('Error fetching driver earnings: $e');
      return [];
    }
  }

  /// Get Recent Earnings API
  static Future<List<Earning>> getRecentEarnings({
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

  /// Get Weekly Earnings API
  static Future<List<Earning>> getWeeklyEarnings({
    required int driverId,
    required String week,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_weekly_earnings.php?driver_id=$driverId&week=$week'),
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
      print('Error fetching weekly earnings: $e');
      return [];
    }
  }

  /// Get Earnings Summary API
  static Future<Map<String, dynamic>> getEarningsSummary({
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
      return {'success': false, 'message': 'Failed to fetch earnings summary'};
    } catch (e) {
      print('Error fetching earnings summary: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ============================================================================
  // TRIP APIs
  // ============================================================================

  /// Get Driver Trips API
  static Future<List<Trip>> getDriverTrips(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_driver_trips.php?driver_id=$driverId'),
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

  /// Get Completed Trips API
  static Future<List<Trip>> getCompletedTrips(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_completed_trips.php?driver_id=$driverId'),
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

  /// Accept Trip API
  static Future<Map<String, dynamic>> acceptTrip({
    required int tripId,
    required int driverId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/accept_trip.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trip_id': tripId,
          'driver_id': driverId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to accept trip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error accepting trip: $e');
    }
  }

  /// Complete Trip API
  static Future<Map<String, dynamic>> completeTrip({
    required int tripId,
    required int driverId,
    required double endLatitude,
    required double endLongitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/complete_trip.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trip_id': tripId,
          'driver_id': driverId,
          'end_latitude': endLatitude,
          'end_longitude': endLongitude,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to complete trip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error completing trip: $e');
    }
  }


  /// Create Trip from Accident API
  static Future<Map<String, dynamic>> createTripFromAccident({
    required int accidentId,
    required int driverId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/create_trip_from_accident.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'accident_id': accidentId,
          'driver_id': driverId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create trip from accident: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating trip from accident: $e');
    }
  }

  // ============================================================================
  // WALLET APIs
  // ============================================================================

  /// Get Wallet API
  static Future<Wallet?> getWallet(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_wallet.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['wallet'] != null) {
          return Wallet.fromJson(data['wallet']);
        }
      }
      return null;
    } catch (e) {
      print('Error getting wallet: $e');
      return null;
    }
  }

  /// Get Wallet Transactions API
  static Future<List<Payment>> getWalletTransactions(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_wallet_transactions.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['transactions'] != null) {
          return (data['transactions'] as List)
              .map((json) => Payment.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting wallet transactions: $e');
      return [];
    }
  }

  /// Get Withdrawals API
  static Future<List<Withdrawal>> getWithdrawals(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_withdrawals.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['withdrawals'] != null) {
          return (data['withdrawals'] as List)
              .map((json) => Withdrawal.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting withdrawals: $e');
      return [];
    }
  }

  /// Request Withdrawal API
  static Future<Map<String, dynamic>> requestWithdrawal({
    required int driverId,
    required double amount,
    required String bankAccountId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/request_withdrawal.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'amount': amount,
          'bank_account_id': bankAccountId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to request withdrawal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error requesting withdrawal: $e');
    }
  }


  // ============================================================================
  // ACCIDENT APIs
  // ============================================================================

  /// Get Accidents API
  static Future<List<AccidentReport>> getAccidents() async {
    try {
      final urls = [
        '$_accidentBaseUrl/get_accidents.php',
        '$_accidentBaseUrl/get_accidents.php',
      ];
      
      http.Response? response;
      String? workingUrl;
      
      for (final url in urls) {
        try {
          print('Trying URL: $url');
          response = await http.get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );
          
          print('Response status: ${response.statusCode}');
          print('Response body preview: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}');
          
          if (response.statusCode == 200) {
            if (!response.body.trim().startsWith('<?php') && 
                !response.body.trim().startsWith('<')) {
              workingUrl = url;
              break;
            } else if (response.body.contains('header("Content-Type: application/json");')) {
              workingUrl = url;
              break;
            }
          }
        } catch (e) {
          print('URL $url failed: $e');
          continue;
        }
      }
      
      if (response == null || workingUrl == null) {
        throw Exception('All API endpoints failed. Using mock data.');
      }
      
      print('Using working URL: $workingUrl');
      
      final data = json.decode(response.body);
      
      if (data['success'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => AccidentReport.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching accidents: $e');
      return [];
    }
  }

  /// Update Accident Status API
  static Future<bool> updateAccidentStatus(int accidentId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('$_accidentBaseUrl/update_accident.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': accidentId,
          'status': status,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating accident status: $e');
      return false;
    }
  }

  /// Get Driver Photo API
  static Future<String?> getDriverPhoto({
    required int driverId,
    required String type, // 'aadhar', 'licence', 'rc'
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_driver_photo.php?driver_id=$driverId&type=$type'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['photo_url'] != null) {
          return data['photo_url'];
        }
      }
      return null;
    } catch (e) {
      print('Error getting driver photo: $e');
      return null;
    }
  }

  // ============================================================================
  // NOTIFICATION APIs
  // ============================================================================

  /// Send Notification API
  static Future<Map<String, dynamic>> sendNotification({
    required int driverId,
    required String title,
    required String message,
    required String type,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send_notification.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'title': title,
          'message': message,
          'type': type,
        }),
      );

    if (response.statusCode == 200) {
        return json.decode(response.body);
    } else {
        throw Exception('Failed to send notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending notification: $e');
    }
  }

  // ============================================================================
  // BANK ACCOUNT APIs
  // ============================================================================

  /// Get Driver Bank Accounts API
  static Future<List<BankAccount>> getDriverBankAccounts(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_driver_bank_accounts.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['accounts'] != null) {
          return (data['accounts'] as List)
              .map((account) => BankAccount.fromJson(account))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting bank accounts: $e');
      return [];
    }
  }

  /// Check if driver has saved bank accounts
  static Future<bool> hasSavedBankAccounts(int driverId) async {
    try {
      final accounts = await getDriverBankAccounts(driverId);
      return accounts.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // LOCATION TRACKING APIs
  // ============================================================================

  /// Update Trip Location API (for location tracking)
  static Future<bool> updateTripLocation({
    required int tripId,
    required int driverId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required double speed,
  }) async {
    try {
    final response = await http.post(
        Uri.parse('$_baseUrl/update_trip_location.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'trip_id': tripId,
          'driver_id': driverId,
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': DateTime.now().toIso8601String(),
          'accuracy': accuracy,
          'speed': speed,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating trip location: $e');
      return false;
    }
  }

  /// Get Current Location
  static Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Calculate Distance Between Two Points
  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Check if location is within radius
  static Future<bool> isWithinRadius(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
    double radiusInMeters,
  ) async {
    final distance = calculateDistance(lat1, lng1, lat2, lng2);
    return distance <= radiusInMeters;
  }

  /// Start location tracking (placeholder for compatibility)
  static Future<void> startTracking({
    required Function(Position) onLocationUpdate,
    required Function(String) onError,
  }) async {
    // This would start location tracking
    // For now, it's a placeholder for compatibility
    try {
      final position = await getCurrentLocation();
      if (position != null) {
        onLocationUpdate(position);
      }
    } catch (e) {
      onError('Location tracking error: $e');
    }
  }

  /// Stop location tracking (placeholder for compatibility)
  static void stopTracking() {
    // This would stop any ongoing location tracking
    // For now, it's a placeholder for compatibility
  }

  // ============================================================================
  // GOOGLE MAPS APIs
  // ============================================================================

  /// Get Route from Google Maps Directions API
  static Future<Route?> getRoute(LatLng start, LatLng end) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=${DatabaseConfig.googleMapsApiKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];
          
          // Decode polyline
          final points = _decodePolyline(route['overview_polyline']['points']);
          
          // Extract steps
          final steps = <RouteStep>[];
          for (final step in leg['steps']) {
            steps.add(RouteStep(
              instructions: step['html_instructions'].toString().replaceAll(RegExp(r'<[^>]*>'), ''),
              distance: step['distance']['text'],
              duration: step['duration']['text'],
            ));
          }
          
          return Route(
            points: points,
            distance: leg['distance']['text'],
            duration: leg['duration']['text'],
            steps: steps,
          );
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting route: $e');
      return null;
    }
  }

  /// Geocode Address using Google Maps Geocoding API
  static Future<LatLng?> geocodeAddress(String address) async {
    try {
      final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=${DatabaseConfig.googleMapsApiKey}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
      
      return null;
    } catch (e) {
      print('Error geocoding address: $e');
      return null;
    }
  }

  /// Decode Google Maps Polyline
  static List<LatLng> _decodePolyline(String polyline) {
    final List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polyline.length) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  // ============================================================================
  // PROFILE APIs
  // ============================================================================

  /// Get Profile Data (with local storage fallback)
  static Future<ProfileData> getProfile() async {
    try {
      // Try to load from local storage first
      final localProfile = await loadProfileFromLocal();
      if (localProfile != null) {
        return localProfile;
      }
      
      // If no local data, return default
      return ProfileData.getDefault();
    } catch (e) {
      return ProfileData.getDefault();
    }
  }

  /// Save Profile Data to Local Storage
  static Future<void> saveProfileToLocal(ProfileData profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(profile.toJson());
      await prefs.setString('profile_data', profileJson);
    } catch (e) {
      print('Error saving profile to local storage: $e');
    }
  }

  /// Load Profile Data from Local Storage
  static Future<ProfileData?> loadProfileFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('profile_data');
      if (profileJson != null) {
        final profileMap = json.decode(profileJson) as Map<String, dynamic>;
        return ProfileData.fromJson(profileMap);
      }
    } catch (e) {
      print('Error loading profile from local storage: $e');
    }
    return null;
  }

}

// ============================================================================
// SUPPORTING CLASSES
// ============================================================================

/// Bank Account Model
class BankAccount {
  final String accountNumber;
  final String bankName;
  final String ifscCode;
  final String accountHolderName;
  final String lastUsed;
  final String displayName;

  BankAccount({
    required this.accountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.accountHolderName,
    required this.lastUsed,
    required this.displayName,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountNumber: json['account_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      lastUsed: json['last_used'] ?? '',
      displayName: json['display_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'bank_name': bankName,
      'ifsc_code': ifscCode,
      'account_holder_name': accountHolderName,
      'last_used': lastUsed,
      'display_name': displayName,
    };
  }
}

/// Route Model for Google Maps
class Route {
  final List<LatLng> points;
  final String distance;
  final String duration;
  final List<RouteStep> steps;

  Route({
    required this.points,
    required this.distance,
    required this.duration,
    required this.steps,
  });
}

/// Route Step Model
class RouteStep {
  final String instructions;
  final String distance;
  final String duration;

  RouteStep({
    required this.instructions,
    required this.distance,
    required this.duration,
  });
}
