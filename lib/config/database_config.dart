/// Centralized Configuration for Driver App
/// 
/// All API endpoints and app settings are centralized here
class DatabaseConfig {
  // ============================================================================
  // API CONFIGURATION
  // ============================================================================
  
  // Main Driver App API Base URL
  static const String baseUrl = 'http://localhost/Driver-App/api/';
  
  // Accident API Base URL (separate service)
  static const String accidentBaseUrl = 'http://localhost/Driver-App/api/';
  
  // Google Maps API Configuration
  static const String googleMapsApiKey = 'AIzaSyBvOkBwJcJkK8jL9mN2pQ3rS4tU5vW6xY7z';
  
  // ============================================================================
  // LOCATION TRACKING CONFIGURATION
  // ============================================================================
  
  static const int locationUpdateInterval = 30; // seconds
  static const double minimumMovementDistance = 10.0; // meters
  
  // ============================================================================
  // UTILITY METHODS
  // ============================================================================
  
  /// Get full API URL for a specific endpoint
  static String getApiUrl(String endpoint) {
    return '$baseUrl/$endpoint';
  }
  
  /// Get full accident API URL for a specific endpoint
  static String getAccidentApiUrl(String endpoint) {
    return '$accidentBaseUrl$endpoint';
  }
}