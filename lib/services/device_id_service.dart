import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DeviceIdService {
  static final DeviceIdService _instance = DeviceIdService._internal();
  factory DeviceIdService() => _instance;
  DeviceIdService._internal();

  static const String _deviceIdKey = 'device_id';
  static const String _deviceNameKey = 'device_name';
  
  String? _cachedDeviceId;
  String? _cachedDeviceName;

  /// Get unique device ID for this device
  Future<String> getDeviceId() async {
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String? storedDeviceId = prefs.getString(_deviceIdKey);
      
      if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
        _cachedDeviceId = storedDeviceId;
        return storedDeviceId;
      }

      // Generate new device ID
      String newDeviceId = await _generateDeviceId();
      
      // Store in preferences
      await prefs.setString(_deviceIdKey, newDeviceId);
      _cachedDeviceId = newDeviceId;
      
      debugPrint('Generated new device ID: $newDeviceId');
      return newDeviceId;
    } catch (e) {
      debugPrint('Error getting device ID: $e');
      // Fallback to a random ID
      String fallbackId = _generateFallbackId();
      _cachedDeviceId = fallbackId;
      return fallbackId;
    }
  }

  /// Get device name for display purposes
  Future<String> getDeviceName() async {
    if (_cachedDeviceName != null) {
      return _cachedDeviceName!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String? storedDeviceName = prefs.getString(_deviceNameKey);
      
      if (storedDeviceName != null && storedDeviceName.isNotEmpty) {
        _cachedDeviceName = storedDeviceName;
        return storedDeviceName;
      }

      // Generate device name based on platform
      String deviceName = await _generateDeviceName();
      
      // Store in preferences
      await prefs.setString(_deviceNameKey, deviceName);
      _cachedDeviceName = deviceName;
      
      debugPrint('Generated device name: $deviceName');
      return deviceName;
    } catch (e) {
      debugPrint('Error getting device name: $e');
      String fallbackName = _generateFallbackName();
      _cachedDeviceName = fallbackName;
      return fallbackName;
    }
  }

  /// Generate unique device ID based on device characteristics
  Future<String> _generateDeviceId() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String deviceInfoString = '';
      
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceInfoString = '${androidInfo.model}_${androidInfo.brand}_${androidInfo.device}_${androidInfo.id}';
        debugPrint('Android device info: $deviceInfoString');
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceInfoString = '${iosInfo.model}_${iosInfo.name}_${iosInfo.identifierForVendor}';
        debugPrint('iOS device info: $deviceInfoString');
      } else {
        // For other platforms, use a combination of available info
        deviceInfoString = '${Platform.operatingSystem}_${DateTime.now().millisecondsSinceEpoch}';
        debugPrint('Other platform device info: $deviceInfoString');
      }
      
      // Create hash from device info
      var bytes = utf8.encode(deviceInfoString);
      var digest = sha256.convert(bytes);
      
      String deviceId = digest.toString().substring(0, 16);
      debugPrint('Generated device ID: $deviceId');
      return deviceId;
    } catch (e) {
      debugPrint('Error generating device ID: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return _generateFallbackId();
    }
  }

  /// Generate device name for display
  Future<String> _generateDeviceName() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        String deviceName = '${androidInfo.brand} ${androidInfo.model}';
        debugPrint('Android device name: $deviceName');
        return deviceName;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        String deviceName = '${iosInfo.name} (${iosInfo.model})';
        debugPrint('iOS device name: $deviceName');
        return deviceName;
      } else {
        String deviceName = '${Platform.operatingSystem} Device';
        debugPrint('Other platform device name: $deviceName');
        return deviceName;
      }
    } catch (e) {
      debugPrint('Error generating device name: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return _generateFallbackName();
    }
  }

  /// Generate fallback device ID
  String _generateFallbackId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 1000000).toString().padLeft(6, '0');
    return 'fallback_${random}';
  }

  /// Generate fallback device name
  String _generateFallbackName() {
    if (Platform.isAndroid) {
      return 'Android Device';
    } else if (Platform.isIOS) {
      return 'iOS Device';
    } else {
      return '${Platform.operatingSystem} Device';
    }
  }

  /// Clear cached device info (for testing or reset)
  Future<void> clearDeviceInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_deviceIdKey);
      await prefs.remove(_deviceNameKey);
      
      _cachedDeviceId = null;
      _cachedDeviceName = null;
      
      debugPrint('Device info cleared');
    } catch (e) {
      debugPrint('Error clearing device info: $e');
    }
  }

  /// Get device info for debugging
  Future<Map<String, String>> getDeviceInfo() async {
    return {
      'device_id': await getDeviceId(),
      'device_name': await getDeviceName(),
      'platform': Platform.operatingSystem,
      'is_android': Platform.isAndroid.toString(),
      'is_ios': Platform.isIOS.toString(),
    };
  }
}
