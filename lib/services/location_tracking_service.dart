import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/maps_config.dart';

class LocationTrackingService {
  static StreamSubscription<Position>? _positionStream;
  static Timer? _updateTimer;
  static Position? _lastPosition;
  static DateTime? _lastUpdateTime;
  
  // Callbacks
  static Function(Position)? _onLocationUpdate;
  static Function(String)? _onError;

  static Future<void> startTracking({
    required Function(Position) onLocationUpdate,
    required Function(String) onError,
  }) async {
    _onLocationUpdate = onLocationUpdate;
    _onError = onError;

    try {
      // Check permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _onError?.call('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _onError?.call('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _onError?.call('Location permissions are permanently denied');
        return;
      }

      // Start location stream
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        ),
      ).listen(
        (Position position) {
          _lastPosition = position;
          _onLocationUpdate?.call(position);
        },
        onError: (error) {
          _onError?.call('Location error: $error');
        },
      );

      // Start periodic backend updates
      _startBackendUpdates();

    } catch (e) {
      _onError?.call('Error starting location tracking: $e');
    }
  }

  static void _startBackendUpdates() {
    _updateTimer = Timer.periodic(Duration(seconds: MapsConfig.locationUpdateInterval), (timer) {
      if (_lastPosition != null) {
        _updateBackendLocation(_lastPosition!);
      }
    });
  }

  static Future<void> _updateBackendLocation(Position position) async {
    try {
      // Only update if moved more than minimum distance or time interval has passed
      if (_lastUpdateTime != null) {
        final timeDiff = DateTime.now().difference(_lastUpdateTime!);
        if (timeDiff.inSeconds < MapsConfig.locationUpdateInterval) {
          return;
        }
      }

      // Check distance from last update
      if (_lastUpdateTime != null && _lastPosition != null) {
        final distance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        
        if (distance < MapsConfig.minimumMovementDistance) {
          return;
        }
      }

      // Update backend
      await _sendLocationUpdate(position);
      
      _lastUpdateTime = DateTime.now();
    } catch (e) {
      print('Error updating backend location: $e');
    }
  }

  static Future<void> _sendLocationUpdate(Position position) async {
    try {
      final url = Uri.parse('http://localhost/apatkal_driver_app/api/update_trip_location.php');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': DateTime.now().toIso8601String(),
          'accuracy': position.accuracy,
          'speed': position.speed,
        }),
      );

      if (response.statusCode != 200) {
        print('Failed to update location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending location update: $e');
    }
  }

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

  static void stopTracking() {
    _positionStream?.cancel();
    _updateTimer?.cancel();
    _positionStream = null;
    _updateTimer = null;
    _lastPosition = null;
    _lastUpdateTime = null;
  }

  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

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
}
