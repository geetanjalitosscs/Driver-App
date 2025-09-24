import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../config/maps_config.dart';

class DirectionsService {

  static Future<Route?> getRoute(LatLng start, LatLng end) async {
    try {
      final url = Uri.parse(
        MapsConfig.getDirectionsUrl(
          startLat: start.latitude,
          startLng: start.longitude,
          endLat: end.latitude,
          endLng: end.longitude,
        ),
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];
          
          // Decode polyline
          final points = _decodePolyline(route['overview_polyline']['points']);
          
          // Extract steps
          final steps = <RouteStep>[];
          for (final step in leg['steps']) {
            steps.add(RouteStep(
              instructions: step['html_instructions'].toString().replaceAll(RegExp(r'<[^>]*>'), ''),
              distance: step['distance']['text'],
              duration: step['duration']['text'],
            ));
          }
          
          return Route(
            points: points,
            distance: leg['distance']['text'],
            duration: leg['duration']['text'],
            steps: steps,
          );
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting route: $e');
      return null;
    }
  }

  static Future<LatLng?> geocodeAddress(String address) async {
    try {
      final url = Uri.parse(MapsConfig.getGeocodingUrl(address));

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
      
      return null;
    } catch (e) {
      print('Error geocoding address: $e');
      return null;
    }
  }

  static List<LatLng> _decodePolyline(String polyline) {
    final List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polyline.length) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}

class Route {
  final List<LatLng> points;
  final String distance;
  final String duration;
  final List<RouteStep> steps;

  Route({
    required this.points,
    required this.distance,
    required this.duration,
    required this.steps,
  });
}

class RouteStep {
  final String instructions;
  final String distance;
  final String duration;

  RouteStep({
    required this.instructions,
    required this.distance,
    required this.duration,
  });
}
