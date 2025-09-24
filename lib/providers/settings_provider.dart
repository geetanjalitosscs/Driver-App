import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // Profile Settings
  String _driverName = 'Rajash Sharma';
  String _phoneNumber = '+91-9876543210';
  String _email = 'rajash.sharma@example.com';
  String _vehicleNumber = 'MH-12-AB-1234';

  // App Settings
  bool _pushNotificationsEnabled = true;
  bool _locationServicesEnabled = true;
  bool _autoAcceptTrips = false;
  bool _darkModeEnabled = false;

  // Trip Settings
  double _maxTripDistance = 25.0;
  double _minFareAmount = 100.0;
  bool _gpsTrackingEnabled = true;

  // Getters
  String get driverName => _driverName;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get vehicleNumber => _vehicleNumber;
  
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;
  bool get locationServicesEnabled => _locationServicesEnabled;
  bool get autoAcceptTrips => _autoAcceptTrips;
  bool get darkModeEnabled => _darkModeEnabled;
  
  double get maxTripDistance => _maxTripDistance;
  double get minFareAmount => _minFareAmount;
  bool get gpsTrackingEnabled => _gpsTrackingEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load profile settings
      _driverName = prefs.getString('driver_name') ?? 'Rajash Sharma';
      _phoneNumber = prefs.getString('phone_number') ?? '+91-9876543210';
      _email = prefs.getString('email') ?? 'rajash.sharma@example.com';
      _vehicleNumber = prefs.getString('vehicle_number') ?? 'MH-12-AB-1234';
      
      // Load app settings
      _pushNotificationsEnabled = prefs.getBool('push_notifications') ?? true;
      _locationServicesEnabled = prefs.getBool('location_services') ?? true;
      _autoAcceptTrips = prefs.getBool('auto_accept_trips') ?? false;
      _darkModeEnabled = prefs.getBool('dark_mode') ?? false;
      
      // Load trip settings
      _maxTripDistance = prefs.getDouble('max_trip_distance') ?? 25.0;
      _minFareAmount = prefs.getDouble('min_fare_amount') ?? 100.0;
      _gpsTrackingEnabled = prefs.getBool('gps_tracking') ?? true;
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading settings: $e');
      }
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save profile settings
      await prefs.setString('driver_name', _driverName);
      await prefs.setString('phone_number', _phoneNumber);
      await prefs.setString('email', _email);
      await prefs.setString('vehicle_number', _vehicleNumber);
      
      // Save app settings
      await prefs.setBool('push_notifications', _pushNotificationsEnabled);
      await prefs.setBool('location_services', _locationServicesEnabled);
      await prefs.setBool('auto_accept_trips', _autoAcceptTrips);
      await prefs.setBool('dark_mode', _darkModeEnabled);
      
      // Save trip settings
      await prefs.setDouble('max_trip_distance', _maxTripDistance);
      await prefs.setDouble('min_fare_amount', _minFareAmount);
      await prefs.setBool('gps_tracking', _gpsTrackingEnabled);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving settings: $e');
      }
    }
  }

  // Profile update methods
  Future<void> updateDriverName(String name) async {
    _driverName = name;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updatePhoneNumber(String phone) async {
    _phoneNumber = phone;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateEmail(String email) async {
    _email = email;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateVehicleNumber(String vehicle) async {
    _vehicleNumber = vehicle;
    await _saveSettings();
    notifyListeners();
  }

  // App settings update methods
  Future<void> updatePushNotifications(bool enabled) async {
    _pushNotificationsEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateLocationServices(bool enabled) async {
    _locationServicesEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateAutoAcceptTrips(bool enabled) async {
    _autoAcceptTrips = enabled;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateDarkMode(bool enabled) async {
    _darkModeEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Trip settings update methods
  Future<void> updateMaxTripDistance(double distance) async {
    _maxTripDistance = distance;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateMinFareAmount(double amount) async {
    _minFareAmount = amount;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateGpsTracking(bool enabled) async {
    _gpsTrackingEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }

  // Reset all settings to default
  Future<void> resetToDefaults() async {
    _driverName = 'Rajash Sharma';
    _phoneNumber = '+91-9876543210';
    _email = 'rajash.sharma@example.com';
    _vehicleNumber = 'MH-12-AB-1234';
    
    _pushNotificationsEnabled = true;
    _locationServicesEnabled = true;
    _autoAcceptTrips = false;
    _darkModeEnabled = false;
    
    _maxTripDistance = 25.0;
    _minFareAmount = 100.0;
    _gpsTrackingEnabled = true;
    
    await _saveSettings();
    notifyListeners();
  }
}
