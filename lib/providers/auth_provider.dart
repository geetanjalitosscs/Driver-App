import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/database_config.dart';
import '../models/profile_data.dart';

class AuthProvider extends ChangeNotifier {
  ProfileData? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileData? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Login method
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.baseUrl}/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          _currentUser = ProfileData.fromJson(data['driver']);
          _setLoading(false);
          return true;
        } else {
          _setError(data['message'] ?? 'Login failed');
          _setLoading(false);
          return false;
        }
      } else {
        _setError('Server error: ${response.statusCode}');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error: $e');
      _setLoading(false);
      return false;
    }
  }

  // Signup method
  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
    required String vehicleType,
    required String vehicleNumber,
    required String aadharPhoto,
    required String licencePhoto,
    required String rcPhoto,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.baseUrl}/signup.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_name': name,
          'email': email,
          'password': password,
          'number': phone,
          'address': address,
          'vehicle_type': vehicleType,
          'vehicle_number': vehicleNumber,
          'aadhar_photo': aadharPhoto,
          'licence_photo': licencePhoto,
          'rc_photo': rcPhoto,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          _currentUser = ProfileData.fromJson(data['driver']);
          _setLoading(false);
          return true;
        } else {
          _setError(data['message'] ?? 'Signup failed');
          _setLoading(false);
          return false;
        }
      } else {
        _setError('Server error: ${response.statusCode}');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error: $e');
      _setLoading(false);
      return false;
    }
  }

  // Logout method
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Update profile method
  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String vehicleType,
    required String vehicleNumber,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final response = await http.post(
        Uri.parse('${DatabaseConfig.baseUrl}/update_profile.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': _currentUser!.driverId,
          'driver_name': name,
          'number': phone,
          'address': address,
          'vehicle_type': vehicleType,
          'vehicle_number': vehicleNumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          // Update current user data
          _currentUser = ProfileData.fromJson(data['driver']);
          _setLoading(false);
          return true;
        } else {
          _setError(data['message'] ?? 'Profile update failed');
          _setLoading(false);
          return false;
        }
      } else {
        _setError('Server error: ${response.statusCode}');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error: $e');
      _setLoading(false);
      return false;
    }
  }
}
