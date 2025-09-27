import 'dart:typed_data';

class AccidentReport {
  final int id;
  final String fullname;
  final String phone;
  final String vehicle;
  final String accidentDate;
  final String location;
  final double latitude;
  final double longitude;
  final String description;
  final String photo;
  final List<String> photos; // Multiple photos from API
  final String createdAt;
  final String status;

  AccidentReport({
    required this.id,
    required this.fullname,
    required this.phone,
    required this.vehicle,
    required this.accidentDate,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.photo,
    required this.photos,
    required this.createdAt,
    required this.status,
  });

  factory AccidentReport.fromMap(Map<String, dynamic> map) {
    // Helper function to safely convert any type to string
    String safeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is Uint8List) return String.fromCharCodes(value);
      return value.toString();
    }

    // Helper function to safely convert to double
    double safeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Helper function to safely convert to int
    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return AccidentReport(
      id: safeInt(map['id']),
      fullname: safeString(map['fullname']),
      phone: safeString(map['phone']),
      vehicle: safeString(map['vehicle']),
      accidentDate: safeString(map['accident_date']),
      location: safeString(map['location']),
      latitude: safeDouble(map['latitude']),
      longitude: safeDouble(map['longitude']),
      description: safeString(map['description']),
      photo: safeString(map['photo']),
      photos: map['photos'] != null ? List<String>.from(map['photos']) : [],
      createdAt: safeString(map['created_at']),
      status: safeString(map['status']),
    );
  }

  /// Factory method for JSON data
  factory AccidentReport.fromJson(Map<String, dynamic> map) {
    return AccidentReport.fromApiMap(map);
  }

  /// Factory method for API data
  factory AccidentReport.fromApiMap(Map<String, dynamic> map) {
    String safeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return value.toString();
    }

    double safeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return AccidentReport(
      id: safeInt(map['id']),
      fullname: safeString(map['fullname']),
      phone: safeString(map['phone']),
      vehicle: safeString(map['vehicle']),
      accidentDate: safeString(map['accident_date']),
      location: safeString(map['location']),
      latitude: safeDouble(map['latitude']),
      longitude: safeDouble(map['longitude']),
      description: safeString(map['description']),
      photo: safeString(map['photo']),
      photos: map['photos'] != null ? List<String>.from(map['photos']) : [],
      createdAt: safeString(map['created_at']),
      status: 'pending', // Default status for API data
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'phone': phone,
      'vehicle': vehicle,
      'accident_date': accidentDate,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'photo': photo,
      'photos': photos,
      'created_at': createdAt,
      'status': status,
    };
  }

  AccidentReport copyWith({
    int? id,
    String? fullname,
    String? phone,
    String? vehicle,
    String? accidentDate,
    String? location,
    double? latitude,
    double? longitude,
    String? description,
    String? photo,
    List<String>? photos,
    String? createdAt,
    String? status,
  }) {
    return AccidentReport(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      phone: phone ?? this.phone,
      vehicle: vehicle ?? this.vehicle,
      accidentDate: accidentDate ?? this.accidentDate,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'phone': phone,
      'vehicle': vehicle,
      'accidentDate': accidentDate,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'photo': photo,
      'photos': photos,
      'createdAt': createdAt,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'AccidentReport(id: $id, fullname: $fullname, phone: $phone, vehicle: $vehicle, accidentDate: $accidentDate, location: $location, latitude: $latitude, longitude: $longitude, description: $description, photo: $photo, createdAt: $createdAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccidentReport &&
        other.id == id &&
        other.fullname == fullname &&
        other.phone == phone &&
        other.vehicle == vehicle &&
        other.accidentDate == accidentDate &&
        other.location == location &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.description == description &&
        other.photo == photo &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullname.hashCode ^
        phone.hashCode ^
        vehicle.hashCode ^
        accidentDate.hashCode ^
        location.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        description.hashCode ^
        photo.hashCode ^
        createdAt.hashCode ^
        status.hashCode;
  }
}
