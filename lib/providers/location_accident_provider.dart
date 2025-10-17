import 'package:flutter/foundation.dart';
import '../services/location_accident_service.dart';

class LocationAccidentProvider with ChangeNotifier {
  List<Map<String, dynamic>> _nearbyAccidents = [];
  Map<String, dynamic>? _driverLocation;
  bool _isLoading = false;
  String? _error;
  double _searchRadius = 10.0; // Default 10km radius

  // Getters
  List<Map<String, dynamic>> get nearbyAccidents => _nearbyAccidents;
  Map<String, dynamic>? get driverLocation => _driverLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get searchRadius => _searchRadius;

  /// Set search radius for nearby accidents
  void setSearchRadius(double radiusKm) {
    _searchRadius = radiusKm;
    notifyListeners();
  }

  /// Update driver's current location
  Future<void> updateDriverLocation({
    required int driverId,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await LocationAccidentService.updateDriverLocation(
        driverId: driverId,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      if (result['success'] == true) {
        _driverLocation = result['data'];
        notifyListeners();
      } else {
        _setError(result['error'] ?? 'Failed to update location');
      }
    } catch (e) {
      _setError('Error updating driver location: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get nearby accidents for a driver based on current location
  Future<void> getNearbyAccidents({
    required int driverId,
    required double latitude,
    required double longitude,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final accidents = await LocationAccidentService.getNearbyAccidents(
        driverId: driverId,
        latitude: latitude,
        longitude: longitude,
      );

      _nearbyAccidents = accidents.map((accident) => accident.toJson()).toList();
      _driverLocation = {
        'latitude': latitude,
        'longitude': longitude,
      };
      notifyListeners();
    } catch (e) {
      _setError('Error fetching nearby accidents: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get nearby accidents using stored driver location
  Future<void> getDriverNearbyAccidents({
    required int driverId,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final accidents = await LocationAccidentService.getDriverNearbyAccidents(
        driverId: driverId,
      );

      _nearbyAccidents = accidents.map((accident) => accident.toJson()).toList();
      notifyListeners();
    } catch (e) {
      _setError('Error fetching nearby accidents: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get accidents by specific location
  Future<void> getAccidentsByLocation({
    required int driverId,
    required double latitude,
    required double longitude,
    String status = 'pending',
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final accidents = await LocationAccidentService.getAccidentsByLocation(
        driverId: driverId,
        latitude: latitude,
        longitude: longitude,
        status: status,
      );

      _nearbyAccidents = accidents.map((accident) => accident.toJson()).toList();
      notifyListeners();
    } catch (e) {
      _setError('Error fetching accidents by location: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh nearby accidents for current driver location
  Future<void> refreshNearbyAccidents({
    required int driverId,
    required double latitude,
    required double longitude,
  }) async {
    await getNearbyAccidents(
      driverId: driverId,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Clear all data
  void clearData() {
    _nearbyAccidents.clear();
    _driverLocation = null;
    _clearError();
    notifyListeners();
  }

  /// Get accidents within a specific distance
  List<Map<String, dynamic>> getAccidentsWithinDistance(double maxDistanceKm) {
    if (_driverLocation == null) return [];

    double driverLat = _driverLocation!['latitude'];
    double driverLon = _driverLocation!['longitude'];

    return _nearbyAccidents.where((accident) {
      double accidentLat = double.parse(accident['latitude'].toString());
      double accidentLon = double.parse(accident['longitude'].toString());
      
      double distance = LocationAccidentService.calculateDistance(
        driverLat, driverLon, accidentLat, accidentLon,
      );
      
      return distance <= maxDistanceKm;
    }).toList();
  }

  /// Get closest accident
  Map<String, dynamic>? getClosestAccident() {
    if (_nearbyAccidents.isEmpty) return null;

    return _nearbyAccidents.reduce((closest, current) {
      double closestDistance = double.parse(closest['distance_km'].toString());
      double currentDistance = double.parse(current['distance_km'].toString());
      
      return currentDistance < closestDistance ? current : closest;
    });
  }

  /// Get accidents sorted by distance
  List<Map<String, dynamic>> getAccidentsSortedByDistance() {
    List<Map<String, dynamic>> sortedAccidents = List.from(_nearbyAccidents);
    sortedAccidents.sort((a, b) {
      double distanceA = double.parse(a['distance_km'].toString());
      double distanceB = double.parse(b['distance_km'].toString());
      return distanceA.compareTo(distanceB);
    });
    return sortedAccidents;
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
