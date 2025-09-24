/// Google Maps Configuration
/// 
/// Update this file with your actual Google Maps API key
class MapsConfig {
  // Google Maps API Key - Replace with your actual API key
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // Directions API settings
  static const String directionsApiUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  static const String geocodingApiUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  
  // Location tracking settings
  static const int locationUpdateInterval = 30; // seconds
  static const double minimumMovementDistance = 50.0; // meters
  static const double tripCompletionRadius = 100.0; // meters
  static const int minimumTripDuration = 2; // minutes
  
  // Map settings
  static const double defaultZoom = 15.0;
  static const double navigationZoom = 16.0;
  
  /// Check if API key is configured
  static bool get isConfigured => googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY';
  
  /// Get directions URL
  static String getDirectionsUrl({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    String mode = 'driving',
  }) {
    return '$directionsApiUrl?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$googleMapsApiKey&mode=$mode';
  }
  
  /// Get geocoding URL
  static String getGeocodingUrl(String address) {
    return '$geocodingApiUrl?address=${Uri.encodeComponent(address)}&key=$googleMapsApiKey';
  }
}
