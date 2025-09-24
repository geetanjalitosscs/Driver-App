import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  // Google Geocoding API key - replace with your actual API key
  static const String _apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

  // Get address from coordinates
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?latlng=$latitude,$longitude&key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        } else {
          return 'Unknown Location';
        }
      } else {
        return 'Unknown Location';
      }
    } catch (e) {
      return 'Unknown Location';
    }
  }

  // Validate and geocode location
  static Future<Map<String, dynamic>> validateAndGeocodeLocation(String location) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?address=${Uri.encodeComponent(location)}&key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final geometry = result['geometry'];
          final location = geometry['location'];
          
          return {
            'isValid': true,
            'latitude': location['lat'],
            'longitude': location['lng'],
            'formattedAddress': result['formatted_address'],
            'placeId': result['place_id'],
          };
        } else if (data['status'] == 'ZERO_RESULTS') {
          return {
            'isValid': false,
            'error': 'Location not found. Please enter a valid location.',
          };
        } else {
          return {
            'isValid': false,
            'error': 'Unable to validate location. Please try again.',
          };
        }
      } else {
        return {
          'isValid': false,
          'error': 'Network error. Please check your connection.',
        };
      }
    } catch (e) {
      return {
        'isValid': false,
        'error': 'Failed to validate location: $e',
      };
    }
  }

  // For simulation purposes, return mock data when API key is not available
  static Future<Map<String, dynamic>> validateAndGeocodeLocationSimulation(String location) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock validation - in real app, this would be replaced with actual API call
    final locationLower = location.toLowerCase().trim();
    
    // Check for obviously invalid locations
    if (locationLower.length < 3 || 
        locationLower.contains('dg') || 
        locationLower.contains('test') ||
        locationLower.length < 5 ||
        locationLower == 'location' ||
        locationLower == 'address') {
      return {
        'isValid': false,
        'error': 'Enter a valid location with proper address (e.g., "Jabalpur, Madhya Pradesh" or "Mumbai, Maharashtra").',
      };
    }
    
    // Mock coordinates for different locations
    Map<String, dynamic> coordinates;
    
    if (locationLower.contains('indore')) {
      coordinates = {
        'latitude': 22.7196,
        'longitude': 75.8577,
        'formattedAddress': 'Indore, Madhya Pradesh, India',
      };
    } else if (locationLower.contains('jabalpur')) {
      coordinates = {
        'latitude': 23.1815,
        'longitude': 79.9864,
        'formattedAddress': 'Jabalpur, Madhya Pradesh, India',
      };
    } else if (locationLower.contains('beohari')) {
      coordinates = {
        'latitude': 23.0225,
        'longitude': 81.3784,
        'formattedAddress': 'Beohari, Madhya Pradesh, India',
      };
    } else if (locationLower.contains('mumbai') || locationLower.contains('maharashtra')) {
      coordinates = {
        'latitude': 19.0760,
        'longitude': 72.8777,
        'formattedAddress': 'Mumbai, Maharashtra, India',
      };
    } else if (locationLower.contains('delhi') || locationLower.contains('new delhi')) {
      coordinates = {
        'latitude': 28.6139,
        'longitude': 77.2090,
        'formattedAddress': 'New Delhi, Delhi, India',
      };
    } else if (locationLower.contains('bangalore') || locationLower.contains('karnataka')) {
      coordinates = {
        'latitude': 12.9716,
        'longitude': 77.5946,
        'formattedAddress': 'Bangalore, Karnataka, India',
      };
    } else if (locationLower.contains('bhopal')) {
      coordinates = {
        'latitude': 23.2599,
        'longitude': 77.4126,
        'formattedAddress': 'Bhopal, Madhya Pradesh, India',
      };
    } else if (locationLower.contains('gwalior')) {
      coordinates = {
        'latitude': 26.2183,
        'longitude': 78.1828,
        'formattedAddress': 'Gwalior, Madhya Pradesh, India',
      };
    } else {
      // Default to Indore for any other valid location
      coordinates = {
        'latitude': 22.7196,
        'longitude': 75.8577,
        'formattedAddress': 'Indore, Madhya Pradesh, India',
      };
    }
    
    return {
      'isValid': true,
      'latitude': coordinates['latitude'],
      'longitude': coordinates['longitude'],
      'formattedAddress': coordinates['formattedAddress'],
      'placeId': 'mock_place_id_${locationLower.hashCode}',
    };
  }

  // Get coordinates for a location
  static Future<Map<String, double>?> getCoordinates(String location) async {
    final result = await validateAndGeocodeLocationSimulation(location);
    
    if (result['isValid'] == true) {
      return {
        'latitude': result['latitude'].toDouble(),
        'longitude': result['longitude'].toDouble(),
      };
    }
    
    return null;
  }
}
