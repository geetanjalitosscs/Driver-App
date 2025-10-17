import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/accident_report.dart';
import '../models/earning.dart';
import '../models/trip.dart';
import '../models/payment.dart';
import '../models/wallet.dart';
import '../models/withdrawal.dart';
import '../models/profile_data.dart';
import '../config/centered_api.dart';

/// Centralized API Endpoints - All API endpoints are defined here
class ApiEndpoints {
  // Base URLs
  static const String baseUrl = DatabaseConfig.baseUrl;
  static const String accidentBaseUrl = DatabaseConfig.accidentBaseUrl;
  
  // ============================================================================
  // AUTHENTICATION ENDPOINTS
  // ============================================================================
  static const String login = 'login.php';
  static const String signup = 'signup.php';
  static const String checkKycStatus = 'check_kyc_status.php';
  static const String updateProfile = 'update_profile.php';
  static const String changePassword = 'change_password.php';
  static const String deleteAccount = 'delete_account.php';
  
  // ============================================================================
  // EARNINGS ENDPOINTS
  // ============================================================================
  static const String getDriverEarnings = 'get_driver_earnings.php';
  static const String getRecentEarnings = 'get_recent_earnings.php';
  static const String getWeeklyEarnings = 'get_weekly_earnings.php';
  static const String getEarningsSummary = 'get_earnings_summary.php';
  
  // ============================================================================
  // TRIP ENDPOINTS
  // ============================================================================
  static const String getDriverTrips = 'get_driver_trips.php';
  static const String getCompletedTrips = 'get_completed_trips.php';
  // Note: acceptTrip, completeTrip, createTripFromAccident endpoints may not exist as separate PHP files
  // They might be handled through other endpoints with action parameters
  
  // ============================================================================
  // WALLET ENDPOINTS
  // ============================================================================
  static const String getWallet = 'get_wallet.php';
  static const String getWalletTransactions = 'get_wallet_transactions.php';
  static const String getWithdrawals = 'get_withdrawals.php';
  static const String requestWithdrawal = 'request_withdrawal.php';
  
  // ============================================================================
  // LOCATION-BASED ACCIDENT ENDPOINTS
  // ============================================================================
  static const String getNearbyAccidents = 'get_nearby_accidents.php';
  static const String getAccidentsByLocation = 'get_accidents_by_location.php';
  static const String updateDriverLocation = 'update_driver_location.php';
  static const String getDriverNearbyAccidents = 'get_driver_nearby_accidents.php';
  
  // ============================================================================
  // ACCIDENT ENDPOINTS
  // ============================================================================
  static const String getAccidents = 'get_accidents.php';
  // Note: updateAccidentStatus endpoint may not exist as separate PHP file
  // It might be handled through get_accidents.php with action parameters
  static const String getDriverPhoto = 'get_driver_photo.php';
  
  // ============================================================================
  // NOTIFICATION ENDPOINTS
  // ============================================================================
  static const String sendNotification = 'send_notification.php';
  
  // ============================================================================
  // BANK ACCOUNT ENDPOINTS
  // ============================================================================
  static const String getDriverBankAccounts = 'get_driver_bank_accounts.php';
  
  // ============================================================================
  // LOCATION TRACKING ENDPOINTS
  // ============================================================================
  static const String updateTripLocation = 'update_trip_location.php';
  
  // ============================================================================
  // ACCOUNT DETAILS ENDPOINTS
  // ============================================================================
  static const String getAccountDetails = 'get_account_details.php';
  static const String saveAccountDetails = 'save_account_details.php';
  
  // ============================================================================
  // CLIENT MOBILE ENDPOINTS
  // ============================================================================
  static const String getClientMobile = 'get_client_mobile.php';
  static const String getClientMobileByVehicleFromTrip = 'get_client_mobile_by_vehicle_from_trip.php';
  
  // ============================================================================
  // PHOTO UPLOAD ENDPOINTS
  // ============================================================================
  static const String uploadPhoto = 'upload_photo.php';
  static const String uploadPhotoBase64 = 'upload_photo_base64.php';
  
  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  /// Get full URL for accident API endpoint
  static String getAccidentUrl(String endpoint) {
    return '$accidentBaseUrl$endpoint';
  }
  
  /// Get full URL for main API endpoint
  static String getMainUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
  
  /// Get full URL with query parameters
  static String getUrlWithParams(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$accidentBaseUrl$endpoint');
    return uri.replace(queryParameters: params.map((key, value) => MapEntry(key, value.toString()))).toString();
  }
}

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
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.login)),
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
    required String aadharPhoto,
    required String licencePhoto,
    required String rcPhoto,
    String address = 'Default Address',
    required String accountNumber,
    required String bankName,
    required String ifscCode,
    required String accountHolderName,
  }) async {
    try {
      final requestBody = {
        'driver_name': name,
        'email': email,
        'number': phone,
        'password': password,
        'vehicle_number': vehicleNumber,
        'vehicle_type': vehicleType,
        'aadhar_photo': aadharPhoto,
        'licence_photo': licencePhoto,
        'rc_photo': rcPhoto,
        'address': address,
        'account_number': accountNumber,
        'bank_name': bankName,
        'ifsc_code': ifscCode,
        'account_holder_name': accountHolderName,
      };
      
      final url = ApiEndpoints.getAccidentUrl(ApiEndpoints.signup);
      
      print('🔐 SIGNUP DEBUG START');
      print('📡 API URL: $url');
      print('📤 Request Body Keys: ${requestBody.keys.toList()}');
      print('📤 Driver Name: $name');
      print('📤 Email: $email');
      print('📤 Phone: $phone');
      print('📤 Vehicle Number: $vehicleNumber');
      print('📤 Vehicle Type: $vehicleType');
      print('📤 Address: $address');
      print('📤 Aadhar photo length: ${aadharPhoto.length}');
      print('📤 Licence photo length: ${licencePhoto.length}');
      print('📤 RC photo length: ${rcPhoto.length}');
      print('🌐 Base URL: ${ApiEndpoints.accidentBaseUrl}');
      print('🔗 Endpoint: ${ApiEndpoints.signup}');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      print('📥 Signup Response Status: ${response.statusCode}');
      print('📥 Signup Response Headers: ${response.headers}');
      print('📥 Signup Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('✅ Signup Success: $responseData');
        return responseData;
      } else {
        print('❌ Signup Failed - Status: ${response.statusCode}');
        print('❌ Error Response: ${response.body}');
        
        // Try to parse the error response as JSON
        try {
          final errorData = json.decode(response.body);
          if (errorData['error'] != null) {
            throw Exception(errorData['error']);
          }
        } catch (jsonError) {
          // If JSON parsing fails, use the raw response
        }
        
        throw Exception('Signup failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('💥 Signup Exception: $e');
      print('💥 Exception Type: ${e.runtimeType}');
      if (e is http.ClientException) {
        print('💥 Client Exception Details: ${e.message}');
      }
      throw Exception('Signup error: $e');
    }
  }

  /// Check KYC Status API
  static Future<Map<String, dynamic>> checkKycStatus({
    required int driverId,
  }) async {
    try {
      print('🌐 Making KYC status API call for driver ID: $driverId');
      print('🔗 API URL: ${ApiEndpoints.getAccidentUrl(ApiEndpoints.checkKycStatus)}');
      
      final requestBody = {'driver_id': driverId};
      print('📤 Request body: $requestBody');
      
      final response = await http.post(
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.checkKycStatus)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      print('📡 KYC status response code: ${response.statusCode}');
      print('📄 KYC status response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final decodedResponse = json.decode(response.body);
          print('✅ Successfully decoded response: $decodedResponse');
          return decodedResponse;
        } catch (jsonError) {
          print('❌ JSON decode error: $jsonError');
          print('📄 Raw response body: ${response.body}');
          throw Exception('Invalid JSON response: $jsonError');
        }
      } else {
        print('❌ HTTP error: ${response.statusCode}');
        print('📄 Error response: ${response.body}');
        throw Exception('KYC status check failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('💥 KYC status API error: $e');
      print('🔍 Error type: ${e.runtimeType}');
      throw Exception('KYC status error: $e');
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
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.updateProfile)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'driver_name': name,
          'email': email,
          'number': phone,
          'vehicle_number': vehicleNumber,
          'vehicle_type': vehicleType,
          'license_number': licenseNumber,
          'aadhar_number': aadharNumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Check if the response indicates an error (even with 200 status)
        if (data['success'] == false) {
          // Extract the error message from our API response format
          String errorMessage = data['error'] ?? data['message'] ?? 'Profile update failed';
          throw Exception(errorMessage);
        }
        
        return data;
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
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.changePassword)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Check if the response indicates an error (even with 200 status)
        if (data['success'] == false) {
          // Extract the error message from our API response format
          String errorMessage = data['error'] ?? data['message'] ?? 'Password change failed';
          throw Exception(errorMessage);
        }
        
        return data;
      } else {
        throw Exception('Password change failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Password change error: $e');
    }
  }

  /// Delete Account API
  static Future<Map<String, dynamic>> deleteAccount({
    required int driverId,
  }) async {
    try {
      final url = ApiEndpoints.getMainUrl(ApiEndpoints.deleteAccount);
      print('Deleting account for driver ID: $driverId');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
        }),
      );
      
      print('Delete account response status: ${response.statusCode}');
      print('Delete account response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to delete account: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Account deletion error: $e');
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
      final url = ApiEndpoints.getUrlWithParams(ApiEndpoints.getDriverEarnings, {
        'driver_id': driverId,
        'period': period,
      });
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getRecentEarnings, {
          'driver_id': driverId,
          'limit': limit,
        })),
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getWeeklyEarnings, {
          'driver_id': driverId,
          'week': week,
        })),
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getEarningsSummary, {
          'driver_id': driverId,
          'period': period,
        })),
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getDriverTrips, {
          'driver_id': driverId,
        })),
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getCompletedTrips, {
          'driver_id': driverId,
        })),
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
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidents)),
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
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidents)),
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
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidents)),
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getWallet, {
          'driver_id': driverId,
        })),
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getWalletTransactions, {
          'driver_id': driverId,
        })),
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getWithdrawals, {
          'driver_id': driverId,
        })),
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
    required String bankAccountNumber,
    required String bankName,
    required String ifscCode,
    required String accountHolderName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.requestWithdrawal)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'amount': amount,
          'bank_account_number': bankAccountNumber,
          'bank_name': bankName,
          'ifsc_code': ifscCode,
          'account_holder_name': accountHolderName,
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
  // LOCATION-BASED ACCIDENT APIs
  // ============================================================================

  /// Get Nearby Accidents API (with driver location)
  static Future<List<AccidentReport>> getNearbyAccidents({
    required int driverId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.getNearbyAccidents)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null && data['data']['accidents'] != null) {
          return (data['data']['accidents'] as List)
              .map((json) => AccidentReport.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching nearby accidents: $e');
      return [];
    }
  }

  /// Get Accidents by Location API
  static Future<List<AccidentReport>> getAccidentsByLocation({
    required int driverId,
    required double latitude,
    required double longitude,
    String status = 'pending',
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidentsByLocation)).replace(
        queryParameters: {
          'driver_id': driverId.toString(),
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'status': status,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null && data['data']['accidents'] != null) {
          return (data['data']['accidents'] as List)
              .map((json) => AccidentReport.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching accidents by location: $e');
      return [];
    }
  }

  /// Update Driver Location API
  static Future<Map<String, dynamic>> updateDriverLocation({
    required int driverId,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.updateDriverLocation)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update driver location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating driver location: $e');
    }
  }

  /// Get Driver Nearby Accidents API (using stored location)
  static Future<List<AccidentReport>> getDriverNearbyAccidents({
    required int driverId,
  }) async {
    try {
      final uri = Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.getDriverNearbyAccidents)).replace(
        queryParameters: {
          'driver_id': driverId.toString(),
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null && data['data']['accidents'] != null) {
          return (data['data']['accidents'] as List)
              .map((json) => AccidentReport.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching driver nearby accidents: $e');
      return [];
    }
  }

  // ============================================================================
  // ACCIDENT APIs
  // ============================================================================

  /// Get Accidents API
  static Future<List<AccidentReport>> getAccidents({int? driverId}) async {
    try {
      // Driver ID is required for this API
      if (driverId == null) {
        throw Exception('Driver ID is required for getAccidents API');
      }
      
      // Build URL with driver_id parameter
      String baseUrl = ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidents);
      baseUrl += '?driver_id=$driverId';
      
      final urls = [
        baseUrl,
        baseUrl, // Keep duplicate for fallback
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
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidents)),
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getDriverPhoto, {
          'driver_id': driverId,
          'type': type,
        })),
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
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.sendNotification)),
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
        Uri.parse(ApiEndpoints.getUrlWithParams(ApiEndpoints.getDriverBankAccounts, {
          'driver_id': driverId,
        })),
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
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.updateTripLocation)),
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

  /// Get current location with detailed address information
  static Future<Map<String, dynamic>?> getCurrentLocationDetailed() async {
    try {
      print('=== LOCATION DEBUG START ===');
      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Location services enabled: $serviceEnabled');
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable location services in your device settings.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      print('Initial permission: $permission');
      
      if (permission == LocationPermission.denied) {
        print('Requesting location permission...');
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission');
        
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied. Please allow location access in app settings.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied. Please enable location access in device settings.');
      }

      print('Getting current position...');
      
      Position position;
      if (Platform.isWindows) {
        print('Windows platform detected - using lenient location settings');
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 20),
        );
      } else {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        );
      }
      
      print('Position obtained: ${position.latitude}, ${position.longitude}');
      print('Accuracy: ${position.accuracy}m');

      print('Reverse geocoding...');
      String address = 'Unknown Location';
      Map<String, String>? addressDetails;
      
      try {
        addressDetails = await getLocationFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        if (addressDetails != null) {
          address = addressDetails['shortAddress'] ?? addressDetails['formattedAddress'] ?? 'Unknown Location';
          print('Address found: $address');
        } else {
          print('No address found, using mock address');
          address = _getMockAddressFromCoordinates(position.latitude, position.longitude);
        }
      } catch (geocodingError) {
        print('Geocoding error: $geocodingError');
        address = _getMockAddressFromCoordinates(position.latitude, position.longitude);
        print('Using mock address: $address');
      }

      print('=== LOCATION DEBUG END ===');
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
        'accuracy': position.accuracy,
        'timestamp': position.timestamp,
        'street': addressDetails?['street'] ?? '',
        'city': addressDetails?['city'] ?? '',
        'state': addressDetails?['state'] ?? '',
        'country': addressDetails?['country'] ?? '',
        'postalCode': addressDetails?['postalCode'] ?? '',
        'formattedAddress': addressDetails?['formattedAddress'] ?? address,
        'shortAddress': addressDetails?['shortAddress'] ?? address,
        'fullAddress': addressDetails?['fullAddress'] ?? address,
      };
    } catch (e) {
      print('=== LOCATION ERROR ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('=== LOCATION ERROR END ===');
      return null;
    }
  }

  /// Get location information using reverse geocoding
  static Future<Map<String, String>?> getLocationFromCoordinates(double latitude, double longitude) async {
    try {
      print('=== GOOGLE MAPS URL API DEBUG START ===');
      print('Getting location for: $latitude, $longitude');
      
      final locationData = await _getLocationDataFromCoordinates(latitude, longitude);
      
      if (locationData != null) {
        print('Location data retrieved successfully');
        print('Street: ${locationData['street']}');
        print('City: ${locationData['city']}');
        print('State: ${locationData['state']}');
        print('Country: ${locationData['country']}');
        print('=== GOOGLE MAPS URL API DEBUG END ===');
        return locationData;
      }
      
      print('No location data found, using fallback');
      print('=== GOOGLE MAPS URL API DEBUG END (FALLBACK) ===');
      return null;
      
    } catch (e) {
      print('Google Maps URL API error: $e');
      print('=== GOOGLE MAPS URL API DEBUG END (ERROR) ===');
      return null;
    }
  }
  
  /// Get location data from coordinates using reverse geocoding
  static Future<Map<String, String>?> _getLocationDataFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        
        try {
          String street = _formatStreet(place);
          String city = place?.locality ?? place?.subLocality ?? '';
          String state = place?.administrativeArea ?? '';
          String country = place?.country ?? '';
          String postalCode = place?.postalCode ?? '';
          
          String shortAddress = _createShortAddress(street, city, state);
          String fullAddress = _createFullAddress(street, city, state, country, postalCode);
          
          return {
            'street': street,
            'city': city,
            'state': state,
            'country': country,
            'postalCode': postalCode,
            'shortAddress': shortAddress,
            'fullAddress': fullAddress,
            'formattedAddress': fullAddress,
          };
        } catch (e) {
          print('Error processing placemark: $e');
          return null;
        }
      }
      
      return null;
    } catch (e) {
      print('Reverse geocoding error: $e');
      return null;
    }
  }
  
  /// Format street address from placemark
  static String _formatStreet(dynamic place) {
    List<String> streetParts = [];
    
    try {
      if (place?.streetNumber != null && place.streetNumber.isNotEmpty) {
        streetParts.add(place.streetNumber);
      }
      if (place?.street != null && place.street.isNotEmpty) {
        streetParts.add(place.street);
      }
      if (place?.thoroughfare != null && place.thoroughfare.isNotEmpty) {
        streetParts.add(place.thoroughfare);
      }
    } catch (e) {
      print('Error formatting street: $e');
    }
    
    return streetParts.join(' ').trim();
  }
  
  /// Create a short address format (Street, City, State)
  static String _createShortAddress(String street, String city, String state) {
    List<String> parts = [];
    
    if (street.isNotEmpty) parts.add(street);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    
    return parts.join(', ');
  }
  
  /// Create a full address format (Street, City, State, Country, Postal Code)
  static String _createFullAddress(String street, String city, String state, String country, String postalCode) {
    List<String> parts = [];
    
    if (street.isNotEmpty) parts.add(street);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (country.isNotEmpty) parts.add(country);
    if (postalCode.isNotEmpty) parts.add(postalCode);
    
    return parts.join(', ');
  }

  /// Get mock address from coordinates when geocoding fails
  static String _getMockAddressFromCoordinates(double latitude, double longitude) {
    if ((latitude >= 22.6 && latitude <= 22.8) && (longitude >= 75.8 && longitude <= 76.0)) {
      return 'Indore, Madhya Pradesh, India';
    } else if ((latitude >= 23.1 && latitude <= 23.3) && (longitude >= 79.9 && longitude <= 80.1)) {
      return 'Jabalpur, Madhya Pradesh, India';
    } else if ((latitude >= 23.0 && latitude <= 23.1) && (longitude >= 81.3 && longitude <= 81.4)) {
      return 'Beohari, Madhya Pradesh, India';
    } else if ((latitude >= 28.5 && latitude <= 28.8) && (longitude >= 77.0 && longitude <= 77.3)) {
      return 'New Delhi, Delhi, India';
    } else if ((latitude >= 19.0 && latitude <= 19.2) && (longitude >= 72.8 && longitude <= 73.0)) {
      return 'Mumbai, Maharashtra, India';
    } else if ((latitude >= 12.9 && latitude <= 13.0) && (longitude >= 77.5 && longitude <= 77.7)) {
      return 'Bangalore, Karnataka, India';
    } else if ((latitude >= 23.2 && latitude <= 23.3) && (longitude >= 77.3 && longitude <= 77.5)) {
      return 'Bhopal, Madhya Pradesh, India';
    } else if ((latitude >= 26.1 && latitude <= 26.3) && (longitude >= 78.0 && longitude <= 78.3)) {
      return 'Gwalior, Madhya Pradesh, India';
    } else {
      return 'Current Location (${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)})';
    }
  }

  /// Get Google Maps navigation URL for a destination
  static String getNavigationUrl(double destinationLat, double destinationLng, {double? currentLat, double? currentLng}) {
    String url = 'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=driving';
    
    if (currentLat != null && currentLng != null) {
      url += '&origin=$currentLat,$currentLng';
    }
    
    return url;
  }
  
  /// Get Google Maps search URL for an address
  static String getSearchUrl(String address) {
    return 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
  }
  
  /// Get Google Maps place URL for coordinates
  static String getPlaceUrl(double latitude, double longitude) {
    return 'https://www.google.com/maps/place/?api=1&query=$latitude,$longitude';
  }

  /// Search for location by address
  static Future<List<Map<String, dynamic>>> searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      
      List<Map<String, dynamic>> results = [];
      for (Location location in locations) {
        // Get address for each location
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        
        String address = 'Unknown Location';
        if (placemarks.isNotEmpty) {
          address = _formatAddress(placemarks[0]);
        }
        
        results.add({
          'latitude': location.latitude,
          'longitude': location.longitude,
          'address': address,
        });
      }
      
      return results;
    } catch (e) {
      print('Error searching location: $e');
      return [];
    }
  }

  /// Format address from placemark
  static String _formatAddress(Placemark place) {
    List<String> addressParts = [];
    
    try {
      String? street = place.street;
      String? locality = place.locality;
      String? administrativeArea = place.administrativeArea;
      String? country = place.country;
      
      if (street != null && street.isNotEmpty) {
        addressParts.add(street);
      }
      if (locality != null && locality.isNotEmpty) {
        addressParts.add(locality);
      }
      if (administrativeArea != null && administrativeArea.isNotEmpty) {
        addressParts.add(administrativeArea);
      }
      if (country != null && country.isNotEmpty) {
        addressParts.add(country);
      }
      
      String formattedAddress = addressParts.join(', ');
      return formattedAddress.isEmpty ? 'Unknown Location' : formattedAddress;
    } catch (e) {
      print('Error formatting address: $e');
      return 'Unknown Location';
    }
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

  // ============================================================================
  // ACCIDENT DRIVER ACCEPTANCE APIs
  // ============================================================================

  /// Accept an accident report
  static Future<Map<String, dynamic>> acceptAccident({
    required int accidentId,
    required int driverId,
    required String vehicleNumber,
  }) async {
    try {
      print('=== API SERVICE ACCEPT ACCIDENT ===');
      print('URL: ${ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidents)}');
      print('Accident ID: $accidentId');
      print('Driver ID: $driverId');
      print('Vehicle Number: $vehicleNumber');
      
      final response = await http.post(
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidents)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'accept_accident',
          'accident_id': accidentId,
          'driver_id': driverId,
          'vehicle_number': vehicleNumber,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('Parsed result: $result');
        return result;
      } else {
        print('HTTP Error: ${response.statusCode}');
        throw Exception('Accept accident failed: ${response.statusCode}');
      }
    } catch (e) {
      print('API Service Error: $e');
      throw Exception('Accept accident error: $e');
    }
  }

  /// Complete an accident report
  static Future<Map<String, dynamic>> completeAccident({
    required int accidentId,
    required int driverId,
    required bool confirmed,
    double? driverLatitude,
    double? driverLongitude,
  }) async {
    try {
      print('=== API SERVICE COMPLETE ACCIDENT ===');
      print('URL: ${ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidents)}');
      print('Accident ID: $accidentId');
      print('Driver ID: $driverId');
      print('Confirmed: $confirmed');
      print('Driver Location: $driverLatitude, $driverLongitude');
      
      final requestBody = {
        'action': 'complete_accident',
        'accident_id': accidentId,
        'driver_id': driverId,
        'confirmed': confirmed,
      };
      
      // Add location if provided
      if (driverLatitude != null && driverLongitude != null) {
        requestBody['driver_latitude'] = driverLatitude;
        requestBody['driver_longitude'] = driverLongitude;
      }
      
      final response = await http.post(
        Uri.parse(ApiEndpoints.getAccidentUrl(ApiEndpoints.getAccidents)),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('Parsed result: $result');
        return result;
      } else {
        print('HTTP Error: ${response.statusCode}');
        throw Exception('Complete accident failed: ${response.statusCode}');
      }
    } catch (e) {
      print('API Service Error: $e');
      throw Exception('Complete accident error: $e');
    }
  }

}

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