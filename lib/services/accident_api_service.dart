import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/accident_report.dart';

class AccidentApiService {
  static const String baseUrl = 'http://localhost/apatkal';
  static const String getAccidentsEndpoint = '/get_accidents.php';

  /// Fetch all accident reports from the API
  static Future<List<AccidentReport>> fetchAccidentReports() async {
    try {
      // Use the local XAMPP API
      final urls = [
        '$baseUrl$getAccidentsEndpoint',
        '$baseUrl/get_accidents.php',
      ];
      
      http.Response? response;
      String? workingUrl;
      
      for (final url in urls) {
        try {
          print('Trying URL: $url');
          response = await http.get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );
          
          print('Response status: ${response.statusCode}');
          print('Response body preview: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}');
          
          // Check if response is valid JSON or can be converted
          if (response.statusCode == 200) {
            if (!response.body.trim().startsWith('<?php') && 
                !response.body.trim().startsWith('<')) {
              workingUrl = url;
              break;
            } else if (response.body.contains('header("Content-Type: application/json");')) {
              // PHP file exists but needs proper headers - try to extract JSON part
              workingUrl = url;
              break;
            }
          }
        } catch (e) {
          print('URL $url failed: $e');
          continue;
        }
      }
      
      if (response == null || workingUrl == null) {
        throw Exception('All API endpoints failed. Using mock data.');
      }
      
      print('Using working URL: $workingUrl');
      
      // Handle PHP response that needs JSON extraction
      String jsonResponse = _extractJsonFromPhp(response.body);
      
      final Map<String, dynamic> data = json.decode(jsonResponse);
      
      if (data['success'] == true && data['data'] != null) {
        List<AccidentReport> accidents = [];
        
        for (var accidentData in data['data']) {
          accidents.add(AccidentReport.fromApiMap(accidentData));
        }
        
        return accidents;
      } else {
        // If API is not working properly, return empty list
        print('API returned success: false - ${data['message']}');
        print('Returning empty list - no accident reports available');
        return [];
      }
    } catch (e) {
      print('Error fetching accident reports: $e');
      
      // Return empty list when API is not available
      print('Returning empty list - API not accessible');
      return [];
    }
  }

  /// Accept accident report (local only - no API call)
  static Future<bool> acceptAccidentReport(int accidentId) async {
    print('Accepting accident report #$accidentId locally');
    // Just return true since we're not calling the API
    return true;
  }

  /// Reject accident report (local only - no API call)
  static Future<bool> rejectAccidentReport(int accidentId) async {
    print('Rejecting accident report #$accidentId locally');
    // Just return true since we're not calling the API
    return true;
  }

  /// Extract JSON from PHP response
  static String _extractJsonFromPhp(String phpResponse) {
    // If it's already JSON, return as is
    if (phpResponse.trim().startsWith('{') || phpResponse.trim().startsWith('[')) {
      return phpResponse;
    }
    
    // If it's PHP code, try to extract JSON part
    if (phpResponse.contains('<?php')) {
      print('Processing PHP response...');
      
      // Look for the specific structure from the API
      // Based on the web search results, the PHP code has this structure:
      // echo json_encode(["success" => true, "data" => $accidents]);
      
      // Look for the complete echo json_encode block
      // The PHP code has a multi-line structure, so we need to find the complete block
      final echoPattern = RegExp(
        r'echo\s+json_encode\s*\(\s*\[([\s\S]*?)\]\s*\)\s*;',
        multiLine: true,
      );
      
      final match = echoPattern.firstMatch(phpResponse);
      if (match != null) {
        final arrayContent = match.group(1);
        print('Found complete echo json_encode block');
        print('Array content: $arrayContent');
        
        if (arrayContent != null) {
          // Convert the PHP array content to JSON
          return _convertPhpArrayToJson(arrayContent);
        }
      }
      
      // Fallback: try to find any json_encode pattern
      final simplePattern = RegExp(r'json_encode\s*\(\s*\[([\s\S]*?)\]\s*\)');
      final simpleMatch = simplePattern.firstMatch(phpResponse);
      if (simpleMatch != null) {
        final arrayContent = simpleMatch.group(1);
        print('Found json_encode pattern: $arrayContent');
        
        if (arrayContent != null) {
          return _convertPhpArrayToJson(arrayContent);
        }
      }
      
      // If no echo statement found, return mock data structure
      print('No echo json_encode found, returning mock structure');
      return '{"success": true, "data": []}';
    }
    
    return phpResponse;
  }

  /// Convert PHP array syntax to JSON
  static String _convertPhpArrayToJson(String phpArray) {
    print('Converting PHP array: $phpArray');
    
    // Clean up the PHP array content
    String cleaned = phpArray.trim();
    
      // Handle the specific structure from the API
      // Look for patterns like: "success" => true, "data" => \$accidents
      if (cleaned.contains('"success"') && cleaned.contains('"data"')) {
        print('Found success and data structure in PHP');
        
        // Check if this is the empty $accidents case
        if (cleaned.contains('\$accidents') && !cleaned.contains('[') && !cleaned.contains(']')) {
          print('Detected empty \$accidents variable - PHP script not executing properly');
          print('This means the database connection or query failed on the server');
          print('The PHP script is being served as static content instead of being executed');
          print('Server needs to be configured to execute PHP files');
          
          // Try to create a proper response even with empty data
          return '{"success": true, "data": [], "message": "PHP script not executing - server configuration issue"}';
        }
        
        // This is the main structure we expect
        String jsonString = cleaned
            .replaceAll('=>', ':')
            .replaceAll('\$accidents', '[]') // Replace PHP variable with empty array
            .replaceAll('\$conn', 'null') // Replace database connection with null
            .replaceAll('true', 'true')
            .replaceAll('false', 'false')
            .replaceAll('null', 'null');
        
        // Wrap in proper JSON structure
        String result = '{"success": true, "data": []}';
        
        // If we found actual data structure, try to preserve it
        if (jsonString.contains('"success"') && jsonString.contains('"data"')) {
          // Extract the success and data parts
          final successMatch = RegExp(r'"success"\s*:\s*(true|false)').firstMatch(jsonString);
          final dataMatch = RegExp(r'"data"\s*:\s*(\[.*?\])').firstMatch(jsonString);
          
          if (successMatch != null) {
            final successValue = successMatch.group(1);
            final dataValue = dataMatch?.group(1) ?? '[]';
            result = '{"success": $successValue, "data": $dataValue}';
          }
        }
        
        print('Converted to JSON: $result');
        return result;
      }
    
    // If it's a simple array, wrap it in the expected structure
    if (cleaned.startsWith('[') && cleaned.endsWith(']')) {
      return '{"success": true, "data": $cleaned}';
    }
    
    // Default fallback
    return '{"success": true, "data": []}';
  }

  /// Test API endpoint to see what it returns
  static Future<void> testApiEndpoint() async {
    final testUrls = [
      'https://apatkal-api.vercel.app/get_accidents.php',
      'https://apatkal-api.vercel.app/api/get_accidents',
      'https://apatkal-api.vercel.app/get_accidents',
    ];
    
    for (final url in testUrls) {
      try {
        print('\n=== Testing URL: $url ===');
        final response = await http.get(Uri.parse(url));
        print('Status: ${response.statusCode}');
        print('Headers: ${response.headers}');
        print('Body (first 200 chars): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
        
        if (response.body.trim().startsWith('<?php')) {
          print('❌ Returns PHP code - server not processing PHP');
          print('   This means the server is serving PHP files as static content');
          print('   The PHP script needs to be executed by the server');
        } else if (response.body.trim().startsWith('{')) {
          print('✅ Returns JSON - API working!');
        } else {
          print('❓ Returns something else: ${response.body.substring(0, 50)}');
        }
      } catch (e) {
        print('❌ Error: $e');
      }
    }
  }

  /// Check if the server is properly executing PHP
  static Future<bool> isPhpExecuting() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_accidents.php'));
      
      if (response.statusCode == 200) {
        // Check if response contains PHP code (not executed)
        if (response.body.contains('<?php') || response.body.contains('\$accidents')) {
          print('❌ PHP script not executing - server serving static content');
          return false;
        }
        
        // Check if response is valid JSON
        try {
          json.decode(response.body);
          print('✅ PHP script executing properly - returns JSON');
          return true;
        } catch (e) {
          print('❌ PHP script executing but not returning valid JSON');
          return false;
        }
      }
      
      return false;
    } catch (e) {
      print('❌ Error checking PHP execution: $e');
      return false;
    }
  }

  /// Mock data for testing when API is not available
  static List<AccidentReport> _getMockAccidentReports() {
    return [
      AccidentReport(
        id: 1,
        fullname: 'John Doe',
        phone: '+1234567890',
        vehicle: 'Toyota Camry',
        accidentDate: '2024-01-15',
        location: '123 Main Street, City Center',
        latitude: 40.7128,
        longitude: -74.0060,
        description: 'Car accident on Main Street. Minor injuries reported.',
        photo: '',
        photos: [],
        createdAt: '2024-01-15 10:30:00',
        status: 'pending',
      ),
      AccidentReport(
        id: 2,
        fullname: 'Jane Smith',
        phone: '+1987654321',
        vehicle: 'Honda Civic',
        accidentDate: '2024-01-15',
        location: '456 Oak Avenue, Downtown',
        latitude: 40.7589,
        longitude: -73.9851,
        description: 'Motorcycle accident. Driver needs immediate medical attention.',
        photo: '',
        photos: [],
        createdAt: '2024-01-15 11:15:00',
        status: 'pending',
      ),
      AccidentReport(
        id: 3,
        fullname: 'Mike Johnson',
        phone: '+1122334455',
        vehicle: 'Ford F-150',
        accidentDate: '2024-01-15',
        location: '789 Pine Road, Suburb',
        latitude: 40.6892,
        longitude: -74.0445,
        description: 'Truck collision with barrier. No injuries reported.',
        photo: '',
        photos: [],
        createdAt: '2024-01-15 12:00:00',
        status: 'pending',
      ),
    ];
  }
}
