class Trip {
  final int tripId;
  final int driverId;
  final int userId;
  final String startLocation;
  final String endLocation;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? distanceKm;
  final double fareAmount;
  final String status; // 'pending', 'ongoing', 'completed', 'cancelled'
  final bool verified;
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
    required this.tripId,
    required this.driverId,
    required this.userId,
    required this.startLocation,
    required this.endLocation,
    this.startTime,
    this.endTime,
    this.distanceKm,
    required this.fareAmount,
    required this.status,
    required this.verified,
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
      tripId: json['trip_id'] ?? 0,
      driverId: json['driver_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      startLocation: json['start_location'] ?? '',
      endLocation: json['end_location'] ?? '',
      startTime: json['start_time'] != null ? DateTime.parse(json['start_time']) : null,
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      distanceKm: json['distance_km']?.toDouble(),
      fareAmount: (json['fare_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      verified: json['verified'] == 1 || json['verified'] == true,
      createdAt: DateTime.parse(json['created_at']),
      startLatitude: json['start_latitude']?.toDouble(),
      startLongitude: json['start_longitude']?.toDouble(),
      endLatitude: json['end_latitude']?.toDouble(),
      endLongitude: json['end_longitude']?.toDouble(),
      currentLatitude: json['current_latitude']?.toDouble(),
      currentLongitude: json['current_longitude']?.toDouble(),
      lastLocationUpdate: json['last_location_update'] != null ? DateTime.parse(json['last_location_update']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'driver_id': driverId,
      'user_id': userId,
      'start_location': startLocation,
      'end_location': endLocation,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'distance_km': distanceKm,
      'fare_amount': fareAmount,
      'status': status,
      'verified': verified ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Trip copyWith({
    int? tripId,
    int? driverId,
    int? userId,
    String? startLocation,
    String? endLocation,
    DateTime? startTime,
    DateTime? endTime,
    double? distanceKm,
    double? fareAmount,
    String? status,
    bool? verified,
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
      tripId: tripId ?? this.tripId,
      driverId: driverId ?? this.driverId,
      userId: userId ?? this.userId,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distanceKm: distanceKm ?? this.distanceKm,
      fareAmount: fareAmount ?? this.fareAmount,
      status: status ?? this.status,
      verified: verified ?? this.verified,
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

  bool get isCompleted => status == 'completed';
  bool get isOngoing => status == 'ongoing';
  bool get isPending => status == 'pending';
  bool get isCancelled => status == 'cancelled';

  Duration? get tripDuration {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return null;
  }

  String get formattedDuration {
    final duration = tripDuration;
    if (duration == null) return 'N/A';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get formattedDistance {
    if (distanceKm == null) return 'N/A';
    return '${distanceKm!.toStringAsFixed(1)} km';
  }
}
