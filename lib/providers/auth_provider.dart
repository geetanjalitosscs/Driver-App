import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/profile_data.dart';
import '../services/api_service.dart';
import '../services/kyc_notification_service.dart';

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
        print('Driver ID from storage: ${userJson['driverId']} (type: ${userJson['driverId'].runtimeType})'); // Debug log
        
        // Check if driverId is empty or invalid
        if (userJson['driverId'] == null || userJson['driverId'].toString().isEmpty) {
          print('Invalid driver ID in stored data, clearing storage');
          await _clearUserData();
          return;
        }
        
        _currentUser = ProfileData.fromJson(userJson);
        print('Restored user name: ${_currentUser?.driverName}'); // Debug log
        print('Restored driver ID: ${_currentUser?.driverId} (type: ${_currentUser?.driverId.runtimeType})'); // Debug log
        
        // Check for any stored KYC status changes
        await checkStoredKycStatusChange();
        
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved user data: $e');
      // Clear corrupted data
      await _clearUserData();
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
      print('Cleared stored user data');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  // Debug method to check stored data
  Future<void> debugStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      print('Stored user data: $userData');
      if (userData != null) {
        final userJson = json.decode(userData);
        print('Parsed driver ID: ${userJson['driverId']} (type: ${userJson['driverId'].runtimeType})');
      }
    } catch (e) {
      print('Error checking stored data: $e');
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
      
      print('Login response data: $data'); // Debug log
      
      if (data['success'] == true) {
        print('Driver data from API: ${data['driver']}'); // Debug log
        print('Driver ID from API: ${data['driver']['driver_id']} (type: ${data['driver']['driver_id'].runtimeType})'); // Debug log
        _currentUser = ProfileData.fromJson(data['driver']);
        print('Parsed user data: ${_currentUser?.driverName}'); // Debug log
        print('Parsed driver ID: ${_currentUser?.driverId} (type: ${_currentUser?.driverId.runtimeType})'); // Debug log
        await _saveUserData(); // Save user data to storage
        await _setDefaultOfflineState(); // Set default offline state on login
        
        // Check for any stored KYC status changes
        await checkStoredKycStatusChange();
        
        // Start KYC monitoring for the logged-in user
        if (_currentUser?.driverId != null) {
          await KycNotificationService().startMonitoring(_currentUser!.driverId);
        }
        
        _setLoading(false);
        return true;
      } else if (data['kyc_pending'] == true) {
        // Handle KYC pending/rejected status
        print('KYC status issue: ${data['kyc_status']}'); // Debug log
        _setError('KYC verification ${data['kyc_status']}');
        _setLoading(false);
        return false;
      } else {
        print('Login failed: ${data['message']}'); // Debug log
        _setError(data['message'] ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Login error: $e'); // Debug log
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
        aadharPhoto: aadharPhoto,
        licencePhoto: licencePhoto,
        rcPhoto: rcPhoto,
        address: address,
      );
      
      print('Signup API response: $data'); // Debug log
      
      if (data['success'] == true) {
        _currentUser = ProfileData.fromJson(data['driver']);
        await _saveUserData(); // Save user data to storage
        await _setDefaultOfflineState(); // Set default offline state on signup
        _setLoading(false);
        return true;
      } else {
        print('Signup failed: ${data['message']}'); // Debug log
        _setError(data['message'] ?? 'Signup failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Signup error: $e'); // Debug log
      // Check if it's a signup error (400 status) and show appropriate message
      if (e.toString().contains('400') || e.toString().contains('signup failed')) {
        _setError('Invalid credentials');
      } else {
        _setError('Network error: $e');
      }
      _setLoading(false);
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    // Stop KYC monitoring
    KycNotificationService().stopMonitoring();
    
    _currentUser = null;
    _errorMessage = null;
    await _clearUserData(); // Clear stored user data
    await _clearOnlineState(); // Clear online/offline state
    notifyListeners();
  }

  // Clear online/offline state from storage
  Future<void> _clearOnlineState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_on_duty', false); // Set to offline instead of removing
      print('Set user to offline on logout');
    } catch (e) {
      print('Error setting offline state: $e');
    }
  }

  // Set default offline state on login/signup
  Future<void> _setDefaultOfflineState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_on_duty', false); // Set to offline by default
      print('Set default offline state on login/signup');
    } catch (e) {
      print('Error setting default offline state: $e');
    }
  }

  // Delete account method (clears all data including notifications)
  Future<bool> deleteAccount() async {
    if (_currentUser == null) {
      _setError('No user logged in');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // Call API to delete account from server
      final data = await CentralizedApiService.deleteAccount(
        driverId: _currentUser!.driverIdAsInt,
      );
      
      if (data['success'] == true) {
        // Clear all local data including notifications
        await _clearAllUserData();
        
        _currentUser = null;
        _setLoading(false);
        return true;
      } else {
        _setError(data['message'] ?? 'Account deletion failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error: $e');
      _setLoading(false);
      return false;
    }
  }

  // Clear all user data including notifications
  Future<void> _clearAllUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear user data
      await prefs.remove('user_data');
      
      // Clear online/offline state
      await prefs.setBool('is_on_duty', false);
      
      // Clear notifications for this driver
      final driverId = _currentUser?.driverId ?? '';
      if (driverId.isNotEmpty) {
        await prefs.remove('driver_notifications_$driverId');
        print('Cleared notifications for driver $driverId');
      }
      
      print('Cleared all user data and notifications');
    } catch (e) {
      print('Error clearing all user data: $e');
    }
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
        driverId: _currentUser!.driverIdAsInt,
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
        driverId: _currentUser!.driverIdAsInt,
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

  // Check KYC status
  Future<void> checkKycStatus() async {
    if (_currentUser == null) return;
    
    try {
      final response = await CentralizedApiService.checkKycStatus(
        driverId: _currentUser!.driverIdAsInt,
      );
      
      print('KYC status check response: $response'); // Debug log
      
      if (response['success'] == true) {
        final driverData = response['driver'];
        _currentUser = ProfileData.fromJson(driverData);
        await _saveUserData();
        notifyListeners();
        print('KYC status updated to: ${_currentUser?.kycStatus}'); // Debug log
      } else {
        print('KYC status check failed: ${response['message']}'); // Debug log
      }
    } catch (e) {
      print('Error checking KYC status: $e');
    }
  }

  // Force immediate KYC status check
  Future<void> forceKycStatusCheck() async {
    if (_currentUser?.driverId == null) {
      print('❌ Cannot check KYC status: No current user or driver ID');
      return;
    }
    
    print('🔄 Starting force KYC status check for driver: ${_currentUser!.driverId}');
    
    try {
      // Directly check KYC status from database
      final response = await CentralizedApiService.checkKycStatus(
        driverId: _currentUser!.driverIdAsInt,
      );
      
      print('🔄 API Response: $response');
      
      if (response['success'] == true) {
        final driverData = response['driver'];
        print('🔄 Driver data from API: $driverData');
        
        _currentUser = ProfileData.fromJson(driverData);
        await _saveUserData();
        notifyListeners();
        
        print('🔄 Forced immediate KYC status check completed: ${_currentUser?.kycStatus}');
      } else {
        print('❌ Forced KYC status check failed: ${response['message']}');
      }
      
      // Also check stored changes
      await checkStoredKycStatusChange();
      
    } catch (e) {
      print('❌ Error forcing KYC status check: $e');
    }
  }

  // Check for stored KYC status changes
  Future<void> checkStoredKycStatusChange() async {
    if (_currentUser == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final driverId = _currentUser!.driverId;
      final storedChange = prefs.getString('kyc_status_change_$driverId');
      
      if (storedChange != null) {
        final changeData = json.decode(storedChange);
        final newStatus = changeData['status'] as String;
        
        // Update the current user's KYC status
        if (_currentUser != null) {
          _currentUser = ProfileData.fromJson({
            ..._currentUser!.toJson(),
            'kyc_status': newStatus,
          });
          await _saveUserData();
          notifyListeners();
          
          print('🔄 Updated KYC status from stored change: $newStatus');
        }
        
        // Clear the stored change
        await prefs.remove('kyc_status_change_$driverId');
      }
    } catch (e) {
      print('Error checking stored KYC status change: $e');
    }
  }

  // Getter for KYC status
  String get kycStatus => _currentUser?.kycStatus ?? 'pending';
  bool get isKycApproved => kycStatus == 'approved';
}
