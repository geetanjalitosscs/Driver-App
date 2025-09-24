import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GoogleMapsUrlService {
  /// Get location information using Google Maps URL API (no API key required)
  static Future<Map<String, String>?> getLocationFromCoordinates(double latitude, double longitude) async {
    try {
      print('=== GOOGLE MAPS URL API DEBUG START ===');
      print('Getting location for: $latitude, $longitude');
      
      // Use Google Maps URL API to get location information
      // This doesn't require an API key and provides basic location data
      final locationData = await _getLocationDataFromCoordinates(latitude, longitude);
      
      if (locationData != null) {
        print('Location data retrieved successfully');
        print('Street: ${locationData['street']}');
        print('City: ${locationData['city']}');
        print('State: ${locationData['state']}');
        print('Country: ${locationData['country']}');
        print('=== GOOGLE MAPS URL API DEBUG END ===');
        return locationData;
      }
      
      print('No location data found, using fallback');
      print('=== GOOGLE MAPS URL API DEBUG END (FALLBACK) ===');
      return null;
      
    } catch (e) {
      print('Google Maps URL API error: $e');
      print('=== GOOGLE MAPS URL API DEBUG END (ERROR) ===');
      return null;
    }
  }
  
  /// Get location data from coordinates using reverse geocoding
  static Future<Map<String, String>?> _getLocationDataFromCoordinates(double latitude, double longitude) async {
    try {
      // Use the geocoding package's reverse geocoding (no API key required)
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        
        try {
          // Extract address components with null safety
          String street = _formatStreet(place);
          String city = place?.locality ?? place?.subLocality ?? '';
          String state = place?.administrativeArea ?? '';
          String country = place?.country ?? '';
          String postalCode = place?.postalCode ?? '';
          
          // Create formatted addresses
          String shortAddress = _createShortAddress(street, city, state);
          String fullAddress = _createFullAddress(street, city, state, country, postalCode);
          
          return {
            'street': street,
            'city': city,
            'state': state,
            'country': country,
            'postalCode': postalCode,
            'shortAddress': shortAddress,
            'fullAddress': fullAddress,
            'formattedAddress': fullAddress,
          };
        } catch (e) {
          print('Error processing placemark: $e');
          return null;
        }
      }
      
      return null;
    } catch (e) {
      print('Reverse geocoding error: $e');
      return null;
    }
  }
  
  /// Format street address from placemark
  static String _formatStreet(dynamic place) {
    List<String> streetParts = [];
    
    try {
      if (place?.streetNumber != null && place.streetNumber.isNotEmpty) {
        streetParts.add(place.streetNumber);
      }
      if (place?.street != null && place.street.isNotEmpty) {
        streetParts.add(place.street);
      }
      if (place?.thoroughfare != null && place.thoroughfare.isNotEmpty) {
        streetParts.add(place.thoroughfare);
      }
    } catch (e) {
      print('Error formatting street: $e');
    }
    
    return streetParts.join(' ').trim();
  }
  
  /// Create a short address format (Street, City, State)
  static String _createShortAddress(String street, String city, String state) {
    List<String> parts = [];
    
    if (street.isNotEmpty) parts.add(street);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    
    return parts.join(', ');
  }
  
  /// Create a full address format (Street, City, State, Country, Postal Code)
  static String _createFullAddress(String street, String city, String state, String country, String postalCode) {
    List<String> parts = [];
    
    if (street.isNotEmpty) parts.add(street);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (country.isNotEmpty) parts.add(country);
    if (postalCode.isNotEmpty) parts.add(postalCode);
    
    return parts.join(', ');
  }
  
  /// Get Google Maps navigation URL for a destination
  static String getNavigationUrl(double destinationLat, double destinationLng, {double? currentLat, double? currentLng}) {
    String url = 'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=driving';
    
    // Add origin if current location is provided
    if (currentLat != null && currentLng != null) {
      url += '&origin=$currentLat,$currentLng';
    }
    
    return url;
  }
  
  /// Get Google Maps search URL for an address
  static String getSearchUrl(String address) {
    return 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
  }
  
  /// Get Google Maps place URL for coordinates
  static String getPlaceUrl(double latitude, double longitude) {
    return 'https://www.google.com/maps/place/?api=1&query=$latitude,$longitude';
  }
}
