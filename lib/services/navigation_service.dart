import 'package:url_launcher/url_launcher.dart';

class NavigationService {
  // Open Google Maps with directions
  static Future<void> openGoogleMaps({
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
  }) async {
    String url;
    
    // Always use the detailed location name for better accuracy
    if (destinationName != null && destinationName.isNotEmpty) {
      final String encodedDestination = Uri.encodeComponent(destinationName);
      url = 'https://www.google.com/maps/search/?api=1&query=$encodedDestination';
    } else if (_areValidCoordinates(destinationLat, destinationLng)) {
      // Fallback to coordinates if no name provided
      url = 'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=driving';
    } else {
      // Last resort fallback
      url = 'https://www.google.com/maps/search/?api=1&query=Destination';
    }
    
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch Google Maps');
      }
    } catch (e) {
      throw Exception('Failed to open Google Maps: $e');
    }
  }

  // Open Google Maps with current location and destination
  static Future<void> openGoogleMapsWithCurrentLocation({
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
  }) async {
    String url;

    if (destinationName != null && destinationName.isNotEmpty) {
      final String encodedDestination = Uri.encodeComponent(destinationName);

      // ❌ Do NOT include origin, so Google Maps shows "Your location"
      url =
          'https://www.google.com/maps/dir/?api=1&destination=$encodedDestination&travelmode=driving&dir_action=navigate';
    } else if (_areValidCoordinates(destinationLat, destinationLng)) {
      // ❌ Same here — no origin
      url =
          'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=driving&dir_action=navigate';
    } else {
      throw Exception('Invalid coordinates provided');
    }

    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch Google Maps');
      }
    } catch (e) {
      throw Exception('Failed to open Google Maps: $e');
    }
  }

  // Get current location (simulated for now)
  static Future<Map<String, double>> getCurrentLocation() async {
    // In a real app, you would use geolocator package
    // For simulation, return Delhi coordinates (driver's current location)
    return {
      'latitude': 28.6139,
      'longitude': 77.2090,
    };
  }

  // Validate coordinates before opening maps
  static bool _areValidCoordinates(double? lat, double? lng) {
    return lat != null && 
           lng != null && 
           lat >= -90 && lat <= 90 && 
           lng >= -180 && lng <= 180 &&
           !(lat == 0.0 && lng == 0.0); // Exclude 0,0 coordinates (Atlantic Ocean)
  }
}
