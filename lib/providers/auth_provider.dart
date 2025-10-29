import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/profile_data.dart';
import '../services/api_service_endpoints.dart';
import '../services/location_tracking_service.dart';
import '../services/device_id_service.dart';
import 'package:geolocator/geolocator.dart';

class AuthProvider extends ChangeNotifier {
  ProfileData? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _lastSignupResponse; // Store last signup response

  ProfileData? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  Map<String, dynamic>? get lastSignupResponse => _lastSignupResponse;

  // Initialize authentication state from storage
  Future<void> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      print('🔄 Initializing auth from storage...'); // Debug log
      print('📦 Stored user data: $userData'); // Debug log
      
      if (userData != null) {
        final userJson = json.decode(userData);
        print('📋 Loaded user data from storage: $userJson'); // Debug log
        print('🆔 Driver ID from storage: ${userJson['driverId']} (type: ${userJson['driverId'].runtimeType})'); // Debug log
        
        // Check if driverId is empty or invalid
        if (userJson['driverId'] == null || userJson['driverId'].toString().isEmpty) {
          print('❌ Invalid driver ID in stored data, clearing storage');
          await _clearUserData();
          return;
        }
        
        _currentUser = ProfileData.fromJson(userJson);
        print('✅ Restored user name: ${_currentUser?.driverName}'); // Debug log
        print('✅ Restored driver ID: ${_currentUser?.driverId} (type: ${_currentUser?.driverId.runtimeType})'); // Debug log
        print('✅ Restored KYC status: ${_currentUser?.kycStatus}'); // Debug log
        notifyListeners();
      } else {
        print('ℹ️ No user data found in storage');
      }
    } catch (e) {
      print('❌ Error loading saved user data: $e');
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
        print('💾 Saving user data to storage: $userJson'); // Debug log
        await prefs.setString('user_data', userJson);
        print('✅ User data saved successfully'); // Debug log
      } catch (e) {
        print('❌ Error saving user data: $e');
      }
    } else {
      print('❌ Cannot save user data - _currentUser is null');
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
      // Get current location and device info before login
      Position? currentLocation = await LocationTrackingService().getCurrentLocation();
      String deviceId = await DeviceIdService().getDeviceId();
      String deviceName = await DeviceIdService().getDeviceName();
      
      // Debug logging for device information
      print('🔍 Login Debug - Device ID: $deviceId');
      print('🔍 Login Debug - Device Name: $deviceName');
      print('🔍 Login Debug - Location: ${currentLocation?.latitude}, ${currentLocation?.longitude}');
      
      final data = await CentralizedApiService.login(
        email, 
        password,
        latitude: currentLocation?.latitude,
        longitude: currentLocation?.longitude,
        address: null, // Could be enhanced to get address from coordinates
        deviceId: deviceId,
        deviceName: deviceName,
      );
      
      print('✅ Login API Response received: $data');
      print('✅ Success field: ${data['success']}');
      print('✅ KYC pending field: ${data['kyc_pending']}');
      print('✅ Driver data present: ${data['driver'] != null}');
      
      if (data['success'] == true) {
        print('Login response data: $data'); // Debug log
        print('Driver data from API: ${data['driver']}'); // Debug log
        print('Driver ID from API: ${data['driver']['driver_id']} (type: ${data['driver']['driver_id'].runtimeType})'); // Debug log
        print('Address from API: "${data['driver']['address']}"'); // Debug log
        _currentUser = ProfileData.fromJson(data['driver']);
        print('Parsed user data: ${_currentUser?.driverName}'); // Debug log
        print('Parsed driver ID: ${_currentUser?.driverId} (type: ${_currentUser?.driverId.runtimeType})'); // Debug log
        print('Parsed address: "${_currentUser?.address}"'); // Debug log
        await _saveUserData(); // Save user data to storage
        await _setDefaultOfflineState(); // Set default offline state on login
        
        // Start location tracking after successful login
        await _startLocationTracking();
        
        _setLoading(false);
        return true;
      } else if (data['kyc_pending'] == true) {
        // Handle KYC pending/rejected case - still set user data but return false
        print('🔄 KYC pending response: $data'); // Debug log
        if (data['driver'] != null) {
          print('📋 Setting user data for KYC pending...'); // Debug log
          _currentUser = ProfileData.fromJson(data['driver']);
          print('✅ Set user data for KYC pending: ${_currentUser?.driverName}'); // Debug log
          print('✅ Set driver ID for KYC pending: ${_currentUser?.driverId}'); // Debug log
          print('✅ Set KYC status for KYC pending: ${_currentUser?.kycStatus}'); // Debug log
          await _saveUserData(); // Save user data to storage
          print('💾 User data saved for KYC pending case'); // Debug log
        } else {
          print('❌ No driver data in KYC pending response'); // Debug log
        }
        _setError('KYC verification ${data['kyc_status'] ?? 'pending'}');
        _setLoading(false);
        return false;
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
    required String accountNumber,
    required String bankName,
    required String ifscCode,
    required String accountHolderName,
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
        accountNumber: accountNumber,
        bankName: bankName,
        ifscCode: ifscCode,
        accountHolderName: accountHolderName,
      );
      
      print('Signup API response: $data'); // Debug log
      
      // Store the response for later use
      _lastSignupResponse = data;
      
      if (data['success'] == true && data['otp_sent'] == true) {
        // OTP sent successfully - return true to navigate to OTP screen
        _setLoading(false);
        return true;
      } else if (data['success'] == true && data['driver'] != null) {
        // Old flow - direct account creation (backward compatibility)
        _currentUser = ProfileData.fromJson(data['driver']);
        await _saveUserData();
        await _setDefaultOfflineState();
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
      print('Signup error type: ${e.runtimeType}'); // Debug log
      print('Signup error string: ${e.toString()}'); // Debug log
      
      // More specific error handling
      String errorMessage = 'Network error: $e';
      
      // Check if the error message contains specific API error messages
      if (e.toString().contains('Email already exists')) {
        errorMessage = 'Email already exists';
      } else if (e.toString().contains('Phone number already exists')) {
        errorMessage = 'Phone number already exists';
      } else if (e.toString().contains('Invalid email format')) {
        errorMessage = 'Invalid email format';
      } else if (e.toString().contains('Password must be at least 6 characters')) {
        errorMessage = 'Password must be at least 6 characters long';
      } else if (e.toString().contains('400')) {
        errorMessage = 'Bad request - please check your information';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Unauthorized - please try again';
      } else if (e.toString().contains('403')) {
        errorMessage = 'Forbidden - access denied';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Service not found - please try again later';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error - please try again later';
      } else if (e.toString().contains('ClientException')) {
        errorMessage = 'Network connection failed - please check your internet connection';
      }
      
      _setError(errorMessage);
      _setLoading(false);
      return false;
    }
  }

  // Verify OTP method
  Future<bool> verifyOtp({
    required String otp,
    required String phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Get session cookie from last signup response
      String? sessionCookie = _lastSignupResponse?['session_cookie'];
      
      final data = await CentralizedApiService.verifyOtp(
        otp: otp,
        phone: phone,
        sessionCookie: sessionCookie,
      );
      
      print('Verify OTP API response: $data'); // Debug log
      
      if (data['success'] == true) {
        if (data['driver'] != null) {
          _currentUser = ProfileData.fromJson(data['driver']);
          await _saveUserData(); // Save user data to storage
          await _setDefaultOfflineState(); // Set default offline state on signup
          _lastSignupResponse = null; // Clear stored response
          _setLoading(false);
          return true;
        } else {
          _setError('Account created but driver data not received');
          _setLoading(false);
          return false;
        }
      } else {
        print('OTP verification failed: ${data['message']}'); // Debug log
        _setError(data['message'] ?? 'OTP verification failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Verify OTP error: $e'); // Debug log
      
      // More specific error handling
      String errorMessage = 'OTP verification error: $e';
      if (e.toString().contains('Invalid OTP')) {
        errorMessage = 'Invalid OTP. Please check and try again.';
      } else if (e.toString().contains('expired')) {
        errorMessage = 'OTP has expired. Please request a new one.';
      } else if (e.toString().contains('session expired')) {
        errorMessage = 'OTP session expired. Please start signup again.';
      }
      
      _setError(errorMessage);
      _setLoading(false);
      return false;
    }
  }

  // Resend OTP method
  Future<bool> resendOtp({
    required String phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Get session cookie from last signup response
      String? sessionCookie = _lastSignupResponse?['session_cookie'];
      
      final data = await CentralizedApiService.resendOtp(
        phone: phone,
        sessionCookie: sessionCookie,
      );
      
      print('Resend OTP API response: $data'); // Debug log
      
      if (data['success'] == true && data['otp_sent'] == true) {
        // Update session cookie if provided
        if (data['session_cookie'] != null) {
          _lastSignupResponse?['session_cookie'] = data['session_cookie'];
        }
        _setLoading(false);
        return true;
      } else {
        print('Resend OTP failed: ${data['message']}'); // Debug log
        _setError(data['message'] ?? 'Failed to resend OTP');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('Resend OTP error: $e'); // Debug log
      _setError('Resend OTP error: $e');
      _setLoading(false);
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    // Stop location tracking before logout
    await _stopLocationTracking();
    
    // Call logout API to clear device session
    if (_currentUser?.driverIdAsInt != null) {
      try {
        String deviceId = await DeviceIdService().getDeviceId();
        await CentralizedApiService.logout(_currentUser!.driverIdAsInt, deviceId);
        print('Logout API called successfully');
      } catch (e) {
        print('Error calling logout API: $e');
        // Continue with logout even if API call fails
      }
    }
    
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
        address: address,
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
      // Extract the actual error message from the exception
      String errorMessage = _cleanErrorMessage(e.toString());
      _setError(errorMessage);
      _setLoading(false);
      return false;
    }
  }

  // Helper method to clean error messages
  String _cleanErrorMessage(String errorMessage) {
    // Remove common exception prefixes
    if (errorMessage.contains('Exception: ')) {
      errorMessage = errorMessage.split('Exception: ').last;
    }
    
    // Remove common API error prefixes
    List<String> prefixesToRemove = [
      'Password change error: Exception: ',
      'Password change error: ',
      'Profile update error: ',
      'Network error: ',
      'Login error: ',
      'Signup error: ',
    ];
    
    for (String prefix in prefixesToRemove) {
      if (errorMessage.contains(prefix)) {
        errorMessage = errorMessage.replaceFirst(prefix, '');
      }
    }
    
    return errorMessage.trim();
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
      // Extract the actual error message from the exception
      String errorMessage = _cleanErrorMessage(e.toString());
      _setError(errorMessage);
      _setLoading(false);
      return false;
    }
  }

  // Check KYC status
  Future<void> checkKycStatus() async {
    if (_currentUser == null) {
      print('❌ No current user found for KYC status check');
      return;
    }
    
    print('🔍 Starting KYC status check for driver ID: ${_currentUser!.driverIdAsInt}');
    print('🔍 Current KYC status before check: ${_currentUser!.kycStatus}');
    
    try {
      final response = await CentralizedApiService.checkKycStatus(
        driverId: _currentUser!.driverIdAsInt,
      );
      
      print('📡 KYC status check response: $response');
      
      if (response['success'] == true && response['driver'] != null) {
        final driverData = response['driver'];
        print('✅ Driver data received: $driverData');
        print('📊 KYC status in response: ${driverData['kyc_status']}');
        
        // Store old status for comparison
        final oldStatus = _currentUser!.kycStatus;
        
        // Update current user data
        _currentUser = ProfileData.fromJson(driverData);
        await _saveUserData();
        notifyListeners();
        
        print('🔄 KYC status updated from "$oldStatus" to "${_currentUser?.kycStatus}"');
        print('💾 User data saved to local storage');
        
        // Show success message
        if (oldStatus != _currentUser?.kycStatus) {
          print('🎉 KYC status changed! Old: $oldStatus, New: ${_currentUser?.kycStatus}');
        } else {
          print('ℹ️ KYC status unchanged: ${_currentUser?.kycStatus}');
        }
      } else {
        print('❌ KYC status check failed');
        print('📊 Success: ${response['success']}');
        print('📝 Message: ${response['message']}');
        print('📄 Full response: $response');
      }
    } catch (e) {
      print('💥 Error checking KYC status: $e');
      print('🔍 Error type: ${e.runtimeType}');
      print('📋 Stack trace: ${StackTrace.current}');
    }
  }

  // Getter for KYC status
  String get kycStatus => _currentUser?.kycStatus ?? 'pending';
  bool get isKycApproved => kycStatus == 'approved';

  /**
   * @description Send TGH trade data message
   * @return void
   * @author dong.zhao
   * @date 2024/12/6
   */
  void sendTghSubmitTradeDataMsg(String driverId, String txAcctNo) {
    // TODO: Implement TGH trade data message
    print('Sending TGH trade data message for driver: $driverId, account: $txAcctNo');
  }

  /// Start location tracking for the current user
  Future<void> _startLocationTracking() async {
    if (_currentUser?.driverIdAsInt == null) {
      print('Cannot start location tracking: No driver ID');
      return;
    }

    try {
      bool started = await LocationTrackingService().startLocationTracking(_currentUser!.driverIdAsInt);
      if (started) {
        print('Location tracking started for driver ${_currentUser!.driverIdAsInt}');
      } else {
        print('Failed to start location tracking for driver ${_currentUser!.driverIdAsInt}');
      }
    } catch (e) {
      print('Error starting location tracking: $e');
    }
  }

  /// Stop location tracking
  Future<void> _stopLocationTracking() async {
    try {
      await LocationTrackingService().stopLocationTracking();
      print('Location tracking stopped');
    } catch (e) {
      print('Error stopping location tracking: $e');
    }
  }

  /// Update location manually (for immediate updates)
  Future<bool> updateLocationManually() async {
    if (_currentUser?.driverIdAsInt == null) {
      print('Cannot update location: No driver ID');
      return false;
    }

    try {
      return await LocationTrackingService().updateLocationManually(_currentUser!.driverIdAsInt);
    } catch (e) {
      print('Error updating location manually: $e');
      return false;
    }
  }

  /// Get current location (for manual use)
  Future<Position?> getCurrentLocation() async {
    try {
      return await LocationTrackingService().getCurrentLocation();
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }
}