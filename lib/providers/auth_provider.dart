import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/profile_data.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  ProfileData? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileData? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Initialize authentication state from storage
  Future<void> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        final userJson = json.decode(userData);
        print('Loaded user data from storage: $userJson'); // Debug log
        _currentUser = ProfileData.fromJson(userJson);
        print('Restored user name: ${_currentUser?.driverName}'); // Debug log
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved user data: $e');
    }
  }

  // Save user data to storage
  Future<void> _saveUserData() async {
    if (_currentUser != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final userJson = json.encode(_currentUser!.toJson());
        await prefs.setString('user_data', userJson);
      } catch (e) {
        print('Error saving user data: $e');
      }
    }
  }

  // Clear user data from storage
  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

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
      final data = await CentralizedApiService.login(email, password);
      
      if (data['success'] == true) {
        print('Login response data: $data'); // Debug log
        _currentUser = ProfileData.fromJson(data['driver']);
        print('Parsed user data: ${_currentUser?.driverName}'); // Debug log
        await _saveUserData(); // Save user data to storage
        _setLoading(false);
        return true;
      } else {
        _setError(data['message'] ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      // Check if it's a login error (400 status) and show appropriate message
      if (e.toString().contains('400') || e.toString().contains('login failed')) {
        _setError('Invalid credentials');
      } else {
        _setError('Network error: $e');
      }
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
      final data = await CentralizedApiService.signup(
        name: name,
        email: email,
        phone: phone,
        password: password,
        vehicleNumber: vehicleNumber,
        vehicleType: vehicleType,
        licenseNumber: licencePhoto, // Using photo as license number for now
        aadharNumber: aadharPhoto, // Using photo as aadhar number for now
      );
      
      if (data['success'] == true) {
        _currentUser = ProfileData.fromJson(data['driver']);
        _setLoading(false);
        return true;
      } else {
        _setError(data['message'] ?? 'Signup failed');
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
  Future<void> logout() async {
    _currentUser = null;
    _errorMessage = null;
    await _clearUserData(); // Clear stored user data
    notifyListeners();
  }

  // Update profile method
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String vehicleType,
    required String vehicleNumber,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final data = await CentralizedApiService.updateProfile(
        driverId: int.parse(_currentUser!.driverId),
        name: name,
        email: email,
        phone: phone,
        vehicleNumber: vehicleNumber,
        vehicleType: vehicleType,
        licenseNumber: _currentUser!.licencePhoto,
        aadharNumber: _currentUser!.aadharPhoto,
      );
      
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
    } catch (e) {
      _setError('Network error: $e');
      _setLoading(false);
      return false;
    }
  }

  // Change password method
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      _setError('No user logged in');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      final data = await CentralizedApiService.changePassword(
        driverId: int.parse(_currentUser!.driverId),
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      if (data['success'] == true) {
        _setLoading(false);
        return true;
      } else {
        _setError(data['error'] ?? 'Password change failed');
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
