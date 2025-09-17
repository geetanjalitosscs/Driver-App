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
    required double currentLat,
    required double currentLng,
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
  }) async {
    String url;
    
    // Use a URL format that forces "Your location" to be displayed
    if (destinationName != null && destinationName.isNotEmpty) {
      final String encodedDestination = Uri.encodeComponent(destinationName);
      
      // Use "My Location" as origin to force "Your location" display
      url = 'https://www.google.com/maps/dir/?api=1&origin=My+Location&destination=$encodedDestination&travelmode=driving';
      
      print('Opening Google Maps with URL: $url');
      print('Current location: $currentLat, $currentLng');
      print('Destination: $destinationName');
      
    } else if (_areValidCoordinates(currentLat, currentLng) && 
               _areValidCoordinates(destinationLat, destinationLng)) {
      // Use "My Location" as origin to force "Your location" display
      url = 'https://www.google.com/maps/dir/?api=1&origin=My+Location&destination=$destinationLat,$destinationLng&travelmode=driving';
      
      print('Opening Google Maps with URL: $url');
      print('Current location: $currentLat, $currentLng');
      print('Destination coordinates: $destinationLat, $destinationLng');
      
    } else {
      throw Exception('Invalid coordinates provided');
    }
    
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: Try alternative URL format with "My Location"
        String fallbackUrl;
        if (destinationName != null && destinationName.isNotEmpty) {
          final String encodedDestination = Uri.encodeComponent(destinationName);
          fallbackUrl = 'https://maps.google.com/maps?daddr=$encodedDestination&saddr=My+Location';
        } else {
          fallbackUrl = 'https://maps.google.com/maps?daddr=$destinationLat,$destinationLng&saddr=My+Location';
        }
        
        print('Trying fallback URL: $fallbackUrl');
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('Could not launch Google Maps');
        }
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
