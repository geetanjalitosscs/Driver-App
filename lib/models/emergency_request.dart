class EmergencyRequest {
  final String id;
  final String patientName;
  final int patientAge;
  final String location;
  final String description;
  final DateTime requestTime;
  final String status; // 'pending', 'accepted', 'declined'
  final double? latitude;
  final double? longitude;

  EmergencyRequest({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.location,
    required this.description,
    required this.requestTime,
    this.status = 'pending',
    this.latitude,
    this.longitude,
  });

  // Create from form data
  factory EmergencyRequest.fromForm({
    required String patientName,
    required int patientAge,
    required String location,
    required String description,
    double? latitude,
    double? longitude,
  }) {
    return EmergencyRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientName: patientName,
      patientAge: patientAge,
      location: location,
      description: description,
      requestTime: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'patientAge': patientAge,
      'location': location,
      'description': description,
      'requestTime': requestTime.toIso8601String(),
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Create from JSON
  factory EmergencyRequest.fromJson(Map<String, dynamic> json) {
    return EmergencyRequest(
      id: json['id'] ?? '',
      patientName: json['patientName'] ?? '',
      patientAge: json['patientAge'] ?? 0,
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      requestTime: DateTime.parse(json['requestTime'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'pending',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  // Create a copy with updated status
  EmergencyRequest copyWith({
    String? status,
  }) {
    return EmergencyRequest(
      id: id,
      patientName: patientName,
      patientAge: patientAge,
      location: location,
      description: description,
      requestTime: requestTime,
      status: status ?? this.status,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
