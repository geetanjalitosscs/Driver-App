import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_data.dart';

class ProfileService {
  // Replace with your actual backend URL
  static const String _baseUrl = 'https://your-backend-api.com/api';
  
  // Simulate API calls for now - replace with actual implementation
  static Future<ProfileData> getProfile() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For now, return default data
      // In real implementation, make HTTP GET request to your backend
      // final response = await http.get(Uri.parse('$_baseUrl/profile'));
      // if (response.statusCode == 200) {
      //   return ProfileData.fromJson(json.decode(response.body));
      // }
      
      return ProfileData.getDefault();
    } catch (e) {
      // If API fails, return default data
      return ProfileData.getDefault();
    }
  }

  static Future<bool> updateProfile(ProfileData profile) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For now, always return success
      // In real implementation, make HTTP PUT request to your backend
      // final response = await http.put(
      //   Uri.parse('$_baseUrl/profile'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode(profile.toJson()),
      // );
      // return response.statusCode == 200;
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Save to local storage (SharedPreferences) as backup
  static Future<void> saveToLocal(ProfileData profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(profile.toJson());
      await prefs.setString('profile_data', profileJson);
    } catch (e) {
      // Handle error silently for now
    }
  }

  // Load from local storage
  static Future<ProfileData?> loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('profile_data');
      if (profileJson != null) {
        final profileMap = json.decode(profileJson) as Map<String, dynamic>;
        return ProfileData.fromJson(profileMap);
      }
    } catch (e) {
      // Handle error silently for now
    }
    return null;
  }
}
