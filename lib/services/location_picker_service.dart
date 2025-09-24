import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'google_maps_url_service.dart';

class LocationPickerService {
  // Get current location with high accuracy
  static Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      print('=== LOCATION DEBUG START ===');
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Location services enabled: $serviceEnabled');
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable location services in your device settings.');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      print('Initial permission: $permission');
      
      if (permission == LocationPermission.denied) {
        print('Requesting location permission...');
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission');
        
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied. Please allow location access in app settings.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied. Please enable location access in device settings.');
      }

      print('Getting current position...');
      
      // For Windows desktop, use a more lenient approach
      Position position;
      if (Platform.isWindows) {
        print('Windows platform detected - using lenient location settings');
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 20),
        );
      } else {
        // Get current position with high accuracy for mobile
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        );
      }
      
      print('Position obtained: ${position.latitude}, ${position.longitude}');
      print('Accuracy: ${position.accuracy}m');

      // Reverse geocode to get address using Google Maps URL API (no API key required)
      print('Reverse geocoding with Google Maps URL API...');
      String address = 'Unknown Location';
      Map<String, String>? addressDetails;
      
      try {
        // Try Google Maps URL service first (no API key required)
        addressDetails = await GoogleMapsUrlService.getLocationFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        if (addressDetails != null) {
          address = addressDetails['shortAddress'] ?? addressDetails['formattedAddress'] ?? 'Unknown Location';
          print('Google Maps URL API address found: $address');
        } else {
          print('Google Maps URL API failed, trying local geocoding...');
          
          // Fallback to local geocoding
          try {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );

            print('Placemarks received: ${placemarks.length}');
            if (placemarks.isNotEmpty) {
              Placemark place = placemarks[0];
              print('Placemark details:');
              print('  Street: ${place.street}');
              print('  Locality: ${place.locality}');
              print('  AdministrativeArea: ${place.administrativeArea}');
              print('  Country: ${place.country}');
              
              address = _formatAddress(place);
              print('Local geocoding address found: $address');
            } else {
              print('No address found, using mock address');
              address = _getMockAddressFromCoordinates(position.latitude, position.longitude);
            }
          } catch (localGeocodingError) {
            print('Local geocoding also failed: $localGeocodingError');
            print('Using mock address as final fallback');
            address = _getMockAddressFromCoordinates(position.latitude, position.longitude);
          }
        }
      } catch (geocodingError) {
        print('Geocoding error: $geocodingError');
        print('Error type: ${geocodingError.runtimeType}');
        
        // Try to get a readable address using mock data based on coordinates
        address = _getMockAddressFromCoordinates(position.latitude, position.longitude);
        print('Using mock address: $address');
      }

      print('=== LOCATION DEBUG END ===');
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
        'accuracy': position.accuracy,
        'timestamp': position.timestamp,
        // Add detailed address information if available
        'street': addressDetails?['street'] ?? '',
        'city': addressDetails?['city'] ?? '',
        'state': addressDetails?['state'] ?? '',
        'country': addressDetails?['country'] ?? '',
        'postalCode': addressDetails?['postalCode'] ?? '',
        'formattedAddress': addressDetails?['formattedAddress'] ?? address,
        'shortAddress': addressDetails?['shortAddress'] ?? address,
        'fullAddress': addressDetails?['fullAddress'] ?? address,
      };
    } catch (e) {
      print('=== LOCATION ERROR ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('=== LOCATION ERROR END ===');
      return null;
    }
  }

  // Get mock address from coordinates when geocoding fails
  static String _getMockAddressFromCoordinates(double latitude, double longitude) {
    // Check if coordinates match known locations
    if ((latitude >= 22.6 && latitude <= 22.8) && (longitude >= 75.8 && longitude <= 76.0)) {
      return 'Indore, Madhya Pradesh, India';
    } else if ((latitude >= 23.1 && latitude <= 23.3) && (longitude >= 79.9 && longitude <= 80.1)) {
      return 'Jabalpur, Madhya Pradesh, India';
    } else if ((latitude >= 23.0 && latitude <= 23.1) && (longitude >= 81.3 && longitude <= 81.4)) {
      return 'Beohari, Madhya Pradesh, India';
    } else if ((latitude >= 28.5 && latitude <= 28.8) && (longitude >= 77.0 && longitude <= 77.3)) {
      return 'New Delhi, Delhi, India';
    } else if ((latitude >= 19.0 && latitude <= 19.2) && (longitude >= 72.8 && longitude <= 73.0)) {
      return 'Mumbai, Maharashtra, India';
    } else if ((latitude >= 12.9 && latitude <= 13.0) && (longitude >= 77.5 && longitude <= 77.7)) {
      return 'Bangalore, Karnataka, India';
    } else if ((latitude >= 23.2 && latitude <= 23.3) && (longitude >= 77.3 && longitude <= 77.5)) {
      return 'Bhopal, Madhya Pradesh, India';
    } else if ((latitude >= 26.1 && latitude <= 26.3) && (longitude >= 78.0 && longitude <= 78.3)) {
      return 'Gwalior, Madhya Pradesh, India';
    } else {
      // For any other coordinates, provide a generic location
      return 'Current Location (${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)})';
    }
  }

  // Format address from placemark
  static String _formatAddress(Placemark place) {
    List<String> addressParts = [];
    
    try {
      // Safely check each field without null check operators
      String? street = place.street;
      String? locality = place.locality;
      String? administrativeArea = place.administrativeArea;
      String? country = place.country;
      
      if (street != null && street.isNotEmpty) {
        addressParts.add(street);
      }
      if (locality != null && locality.isNotEmpty) {
        addressParts.add(locality);
      }
      if (administrativeArea != null && administrativeArea.isNotEmpty) {
        addressParts.add(administrativeArea);
      }
      if (country != null && country.isNotEmpty) {
        addressParts.add(country);
      }
      
      String formattedAddress = addressParts.join(', ');
      print('Formatted address: $formattedAddress');
      return formattedAddress.isEmpty ? 'Unknown Location' : formattedAddress;
    } catch (e) {
      print('Error formatting address: $e');
      print('Error type: ${e.runtimeType}');
      return 'Unknown Location';
    }
  }

  // Search for location by address
  static Future<List<Map<String, dynamic>>> searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      
      List<Map<String, dynamic>> results = [];
      for (Location location in locations) {
        // Get address for each location
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        
        String address = 'Unknown Location';
        if (placemarks.isNotEmpty) {
          address = _formatAddress(placemarks[0]);
        }
        
        results.add({
          'latitude': location.latitude,
          'longitude': location.longitude,
          'address': address,
        });
      }
      
      return results;
    } catch (e) {
      print('Error searching location: $e');
      return [];
    }
  }

  // Get address from coordinates
  static Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        return _formatAddress(placemarks[0]);
      }
      return 'Unknown Location';
    } catch (e) {
      print('Error getting address from coordinates: $e');
      return 'Unknown Location';
    }
  }
}
