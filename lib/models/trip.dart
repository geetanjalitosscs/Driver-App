import 'dart:math';
import 'package:geolocator/geolocator.dart';

class Trip {
  final int historyId;
  final int driverId;
  final String clientName;
  final String location;
  final DateTime? timing;
  final int duration; // in minutes
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime createdAt;
  
  // Location tracking fields
  final double? startLatitude;
  final double? startLongitude;
  final double? endLatitude;
  final double? endLongitude;
  final double? currentLatitude;
  final double? currentLongitude;
  final DateTime? lastLocationUpdate;

  Trip({
    required this.historyId,
    required this.driverId,
    required this.clientName,
    required this.location,
    this.timing,
    required this.duration,
    this.startTime,
    this.endTime,
    required this.createdAt,
    this.startLatitude,
    this.startLongitude,
    this.endLatitude,
    this.endLongitude,
    this.currentLatitude,
    this.currentLongitude,
    this.lastLocationUpdate,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      historyId: json['history_id'] ?? 0,
      driverId: json['driver_id'] ?? 0,
      clientName: json['client_name'] ?? '',
      location: json['location'] ?? '',
      timing: json['timing'] != null ? DateTime.parse(json['timing']) : null,
      duration: json['duration'] ?? 0,
      startTime: json['start_time'] != null ? DateTime.parse(json['start_time']) : null,
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      createdAt: DateTime.parse(json['created_at']),
      startLatitude: json['start_latitude'] != null ? double.tryParse(json['start_latitude'].toString()) : null,
      startLongitude: json['start_longitude'] != null ? double.tryParse(json['start_longitude'].toString()) : null,
      endLatitude: json['end_latitude'] != null ? double.tryParse(json['end_latitude'].toString()) : null,
      endLongitude: json['end_longitude'] != null ? double.tryParse(json['end_longitude'].toString()) : null,
      currentLatitude: json['current_latitude'] != null ? double.tryParse(json['current_latitude'].toString()) : null,
      currentLongitude: json['current_longitude'] != null ? double.tryParse(json['current_longitude'].toString()) : null,
      lastLocationUpdate: json['last_location_update'] != null ? DateTime.parse(json['last_location_update']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'history_id': historyId,
      'driver_id': driverId,
      'client_name': clientName,
      'location': location,
      'timing': timing?.toIso8601String(),
      'duration': duration,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Trip copyWith({
    int? historyId,
    int? driverId,
    String? clientName,
    String? location,
    DateTime? timing,
    int? duration,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    double? currentLatitude,
    double? currentLongitude,
    DateTime? lastLocationUpdate,
  }) {
    return Trip(
      historyId: historyId ?? this.historyId,
      driverId: driverId ?? this.driverId,
      clientName: clientName ?? this.clientName,
      location: location ?? this.location,
      timing: timing ?? this.timing,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      endLatitude: endLatitude ?? this.endLatitude,
      endLongitude: endLongitude ?? this.endLongitude,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
    );
  }

  bool get isCompleted => endTime != null;
  bool get isOngoing => startTime != null && endTime == null;
  bool get isPending => startTime == null && endTime == null;

  Duration? get tripDuration {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return null;
  }

  String get formattedDuration {
    // First try to calculate from startTime and endTime
    if (startTime != null && endTime != null) {
      final actualDuration = endTime!.difference(startTime!);
      
      // If the calculated duration is 0 (same times), use the database duration field
      if (actualDuration.inSeconds == 0 && duration != null && duration! > 0) {
        // Duration is now stored in seconds, not minutes
        final totalSeconds = duration!;
        final hours = totalSeconds ~/ 3600;
        final minutes = (totalSeconds % 3600) ~/ 60;
        final seconds = totalSeconds % 60;
        
        if (hours > 0) {
          return '${hours}h ${minutes}m ${seconds}s';
        } else if (minutes > 0) {
          return '${minutes}m ${seconds}s';
        } else {
          return '${seconds}s';
        }
      }
      
      // Otherwise use the calculated duration
      final hours = actualDuration.inHours;
      final minutes = actualDuration.inMinutes % 60;
      final seconds = actualDuration.inSeconds % 60;
      
      if (hours > 0) {
        return '${hours}h ${minutes}m ${seconds}s';
      } else if (minutes > 0) {
        return '${minutes}m ${seconds}s';
      } else {
        return '${seconds}s';
      }
    }
    
    // Fallback to database duration field (now in seconds)
    if (duration != null && duration! > 0) {
      final totalSeconds = duration!;
      final hours = totalSeconds ~/ 3600;
      final minutes = (totalSeconds % 3600) ~/ 60;
      final seconds = totalSeconds % 60;
      
      if (hours > 0) {
        return '${hours}h ${minutes}m ${seconds}s';
      } else if (minutes > 0) {
        return '${minutes}m ${seconds}s';
      } else {
        return '${seconds}s';
      }
    }
    
    return 'N/A';
  }

  // Getter for tripId - returns historyId for compatibility
  int get tripId => historyId;

  // Location getters for UI compatibility
  String get startLocation => location; // Using location as start location
  String get endLocation => location; // Using location as end location for now
  
  // Distance getters - calculate from coordinates if available
  double? get distanceKm {
    if (startLatitude != null && startLongitude != null && 
        endLatitude != null && endLongitude != null) {
      // Use Geolocator's built-in distance calculation
      return Geolocator.distanceBetween(
        startLatitude!, startLongitude!,
        endLatitude!, endLongitude!
      ) / 1000; // Convert meters to kilometers
    }
    return null;
  }
  
  String get formattedDistance {
    final distance = distanceKm;
    if (distance == null) return 'N/A';
    return '${distance.toStringAsFixed(2)} km';
  }
}
