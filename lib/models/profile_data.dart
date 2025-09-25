class ProfileData {
  final String driverName;
  final String driverId;
  final String email;
  final String phone;
  final String address;
  final String vehicleType;
  final String vehicleNumber;
  final double rating;
  final String aadharPhoto;
  final String licencePhoto;
  final String rcPhoto;
  final String createdAt;

  ProfileData({
    required this.driverName,
    required this.driverId,
    required this.email,
    required this.phone,
    required this.address,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.rating,
    required this.aadharPhoto,
    required this.licencePhoto,
    required this.rcPhoto,
    required this.createdAt,
  });

  // Getter for compatibility
  String get contact => phone;
  double get averageRating => rating;

  // Default profile data
  static ProfileData getDefault() {
    return ProfileData(
      driverName: 'Demo Driver',
      driverId: '1',
      email: 'driver@demo.com',
      phone: '9876543210',
      address: '123, Demo Street, Demo City',
      vehicleType: 'Sedan',
      vehicleNumber: 'DL01AB1234',
      rating: 4.8,
      aadharPhoto: 'placeholder_aadhar.jpg',
      licencePhoto: 'placeholder_licence.jpg',
      rcPhoto: 'placeholder_rc.jpg',
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  // Create a copy with updated fields
  ProfileData copyWith({
    String? driverName,
    String? driverId,
    String? email,
    String? phone,
    String? address,
    String? vehicleType,
    String? vehicleNumber,
    double? rating,
    String? aadharPhoto,
    String? licencePhoto,
    String? rcPhoto,
    String? createdAt,
  }) {
    return ProfileData(
      driverName: driverName ?? this.driverName,
      driverId: driverId ?? this.driverId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      rating: rating ?? this.rating,
      aadharPhoto: aadharPhoto ?? this.aadharPhoto,
      licencePhoto: licencePhoto ?? this.licencePhoto,
      rcPhoto: rcPhoto ?? this.rcPhoto,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'driverId': driverId,
      'email': email,
      'phone': phone,
      'address': address,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'rating': rating,
      'aadharPhoto': aadharPhoto,
      'licencePhoto': licencePhoto,
      'rcPhoto': rcPhoto,
      'createdAt': createdAt,
    };
  }

  // Create from JSON from backend
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      driverName: json['driver_name'] ?? '',
      driverId: json['driver_id']?.toString() ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      aadharPhoto: json['aadhar_photo'] ?? '',
      licencePhoto: json['licence_photo'] ?? '',
      rcPhoto: json['rc_photo'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
