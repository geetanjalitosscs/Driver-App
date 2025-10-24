import 'package:flutter/foundation.dart';
import '../models/profile_data.dart';
import '../services/api_service_endpoints.dart';

class ProfileProvider with ChangeNotifier {
  ProfileData _profile = ProfileData.getDefault();
  bool _isLoading = false;
  String? _error;

  ProfileData get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize profile data
  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to load from backend first
      _profile = await CentralizedApiService.getProfile();
    } catch (e) {
      _error = 'Failed to load profile: ${e.toString()}';
      // Keep default profile if loading fails
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update profile data
  Future<bool> updateProfile(ProfileData newProfile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Update backend
      final result = await CentralizedApiService.updateProfile(
        driverId: _profile.driverIdAsInt,
        name: newProfile.driverName,
        email: newProfile.email,
        phone: newProfile.phone,
        address: newProfile.address,
        vehicleNumber: newProfile.vehicleNumber,
        vehicleType: newProfile.vehicleType,
        licenseNumber: newProfile.licencePhoto,
        aadharNumber: newProfile.aadharPhoto,
      );
      
      bool success = result['success'] == true;
      
      if (success) {
        _profile = newProfile;
        // Also save to local storage as backup
        await CentralizedApiService.saveProfileToLocal(newProfile);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to update profile on server';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Failed to update profile: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update specific fields
  Future<bool> updateProfileFields({
    String? driverName,
    String? contact,
    String? address,
    String? vehicleType,
    String? vehicleNumber,
  }) async {
    ProfileData updatedProfile = _profile.copyWith(
      driverName: driverName,
      phone: contact,
      address: address,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
    );

    return await updateProfile(updatedProfile);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
