class Trip {
  final int historyId;
  final int driverId;
  final String clientName;
  final String location;
  final DateTime? timing;
  final double amount;
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
    required this.amount,
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
      amount: (json['amount'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      startTime: json['start_time'] != null ? DateTime.parse(json['start_time']) : null,
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
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
      'history_id': historyId,
      'driver_id': driverId,
      'client_name': clientName,
      'location': location,
      'timing': timing?.toIso8601String(),
      'amount': amount,
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
    double? amount,
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
      amount: amount ?? this.amount,
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
    if (duration == 0) return 'N/A';
    
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Getter for tripId - returns historyId for compatibility
  int get tripId => historyId;

  // Location getters for UI compatibility
  String get startLocation => location; // Using location as start location
  String get endLocation => location; // Using location as end location for now
  
  // Distance getters (placeholder - would need actual distance calculation)
  double? get distanceKm => null; // Placeholder - would need to calculate from coordinates
  
  String get formattedDistance => 'N/A'; // Placeholder
}
