import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationTrackingService {
  static final LocationTrackingService _instance = LocationTrackingService._internal();
  factory LocationTrackingService() => _instance;
  LocationTrackingService._internal();

  Timer? _locationTimer;
  bool _isTracking = false;
  int? _currentDriverId;
  Position? _lastKnownPosition;
  
  // Location update interval (2 seconds as requested)
  static const Duration _updateInterval = Duration(seconds: 2);
  
  // Minimum distance change to trigger update (in meters)
  static const double _minimumDistanceChange = 5.0;

  /// Start automatic location tracking for a driver
  Future<bool> startLocationTracking(int driverId) async {
    if (_isTracking && _currentDriverId == driverId) {
      debugPrint('Location tracking already active for driver $driverId');
      return true;
    }

    // Stop any existing tracking
    await stopLocationTracking();

    // Check location permissions
    if (!await _checkLocationPermissions()) {
      debugPrint('Location permissions not granted');
      return false;
    }

    _currentDriverId = driverId;
    _isTracking = true;

    // Get initial location
    try {
      _lastKnownPosition = await _getCurrentPosition();
      if (_lastKnownPosition != null) {
        await _updateDriverLocation(_lastKnownPosition!);
        debugPrint('Initial location updated for driver $driverId');
      }
    } catch (e) {
      debugPrint('Failed to get initial location: $e');
    }

    // Start periodic updates
    _locationTimer = Timer.periodic(_updateInterval, (timer) async {
      await _updateLocationPeriodically();
    });

    debugPrint('Location tracking started for driver $driverId');
    return true;
  }

  /// Stop automatic location tracking
  Future<void> stopLocationTracking() async {
    _locationTimer?.cancel();
    _locationTimer = null;
    _isTracking = false;
    _currentDriverId = null;
    _lastKnownPosition = null;
    debugPrint('Location tracking stopped');
  }

  /// Check if location tracking is active
  bool get isTracking => _isTracking;

  /// Get current driver ID being tracked
  int? get currentDriverId => _currentDriverId;

  /// Check location permissions
  Future<bool> _checkLocationPermissions() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled');
      return false;
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied');
      return false;
    }

    return true;
  }

  /// Get current position
  Future<Position?> _getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      debugPrint('Error getting current position: $e');
      return null;
    }
  }

  /// Update location periodically
  Future<void> _updateLocationPeriodically() async {
    if (!_isTracking || _currentDriverId == null) {
      return;
    }

    try {
      Position? currentPosition = await _getCurrentPosition();
      if (currentPosition == null) {
        debugPrint('Failed to get current position for periodic update');
        return;
      }

      // Check if position has changed significantly
      if (_lastKnownPosition != null) {
        double distance = Geolocator.distanceBetween(
          _lastKnownPosition!.latitude,
          _lastKnownPosition!.longitude,
          currentPosition.latitude,
          currentPosition.longitude,
        );

        // Only update if moved more than minimum distance
        if (distance < _minimumDistanceChange) {
          debugPrint('Position change too small ($distance m), skipping update');
          return;
        }
      }

      // Update location
      await _updateDriverLocation(currentPosition);
      _lastKnownPosition = currentPosition;
      
      debugPrint('Location updated: ${currentPosition.latitude}, ${currentPosition.longitude}');
    } catch (e) {
      debugPrint('Error in periodic location update: $e');
    }
  }

  /// Update driver location on server
  Future<void> _updateDriverLocation(Position position) async {
    if (_currentDriverId == null) return;

    try {
      final response = await http.post(
        Uri.parse('https://tossconsultancyservices.com/apatkal/api/update_driver_location.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': _currentDriverId,
          'latitude': position.latitude,
          'longitude': position.longitude,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          debugPrint('Driver location updated successfully on server');
        } else {
          debugPrint('Server error updating location: ${data['message']}');
        }
      } else {
        debugPrint('HTTP error updating location: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating driver location on server: $e');
    }
  }

  /// Get current location (for manual use)
  Future<Position?> getCurrentLocation() async {
    if (!await _checkLocationPermissions()) {
      return null;
    }
    return await _getCurrentPosition();
  }

  /// Update location manually (for immediate updates)
  Future<bool> updateLocationManually(int driverId) async {
    if (!await _checkLocationPermissions()) {
      return false;
    }

    try {
      Position? position = await _getCurrentPosition();
      if (position != null) {
        _currentDriverId = driverId;
        await _updateDriverLocation(position);
        _lastKnownPosition = position;
        return true;
      }
    } catch (e) {
      debugPrint('Error in manual location update: $e');
    }
    return false;
  }

  /// Dispose resources
  void dispose() {
    stopLocationTracking();
  }
}
