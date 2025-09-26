import 'package:flutter/foundation.dart';
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
        _currentUser = ProfileData.fromJson(data['driver']);
        _setLoading(false);
        return true;
      } else {
        _setError(data['message'] ?? 'Login failed');
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
  void logout() {
    _currentUser = null;
    _errorMessage = null;
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
