import 'dart:math';
import '../services/api_service_endpoints.dart';
import '../models/accident_report.dart';

class LocationAccidentService {
  
  /// Get nearby accidents for a driver based on their current location
  static Future<List<AccidentReport>> getNearbyAccidents({
    required int driverId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      return await CentralizedApiService.getNearbyAccidents(
        driverId: driverId,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      throw Exception('Error fetching nearby accidents: $e');
    }
  }

  /// Get accidents by specific location coordinates
  static Future<List<AccidentReport>> getAccidentsByLocation({
    required int driverId,
    required double latitude,
    required double longitude,
    String status = 'pending',
  }) async {
    try {
      return await CentralizedApiService.getAccidentsByLocation(
        driverId: driverId,
        latitude: latitude,
        longitude: longitude,
        status: status,
      );
    } catch (e) {
      throw Exception('Error fetching accidents by location: $e');
    }
  }

  /// Update driver's current location
  static Future<Map<String, dynamic>> updateDriverLocation({
    required int driverId,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    try {
      return await CentralizedApiService.updateDriverLocation(
        driverId: driverId,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
    } catch (e) {
      throw Exception('Error updating driver location: $e');
    }
  }

  /// Get nearby accidents for a driver (using stored location)
  static Future<List<AccidentReport>> getDriverNearbyAccidents({
    required int driverId,
  }) async {
    try {
      return await CentralizedApiService.getDriverNearbyAccidents(
        driverId: driverId,
      );
    } catch (e) {
      throw Exception('Error fetching driver nearby accidents: $e');
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  static double calculateDistance(
    double lat1, double lon1, double lat2, double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    
    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(lat1)) *
        cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) *
        sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    
    return distance;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  /// Filter accidents by distance
  static List<Map<String, dynamic>> filterAccidentsByDistance(
    List<Map<String, dynamic>> accidents,
    double driverLatitude,
    double driverLongitude,
    double maxDistanceKm,
  ) {
    return accidents.where((accident) {
      double accidentLat = double.parse(accident['latitude'].toString());
      double accidentLon = double.parse(accident['longitude'].toString());
      
      double distance = calculateDistance(
        driverLatitude, driverLongitude, accidentLat, accidentLon,
      );
      
      return distance <= maxDistanceKm;
    }).toList();
  }
}
