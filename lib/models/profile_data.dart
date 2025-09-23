class ProfileData {
  final String driverName;
  final String driverId;
  final String contact;
  final String address;
  final String vehicleType;
  final String vehicleNumber;
  final double averageRating;
  final int totalTrips;

  ProfileData({
    required this.driverName,
    required this.driverId,
    required this.contact,
    required this.address,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.averageRating,
    required this.totalTrips,
  });

  // Default profile data
  static ProfileData getDefault() {
    return ProfileData(
      driverName: 'Rajash Sharma',
      driverId: 'AMB789',
      contact: '9876543210',
      address: '123, Gandhi Marg, Sue Delhi',
      vehicleType: 'Ambulance',
      vehicleNumber: 'DL01AB1234',
      averageRating: 4.8,
      totalTrips: 452,
    );
  }

  // Create a copy with updated fields
  ProfileData copyWith({
    String? driverName,
    String? driverId,
    String? contact,
    String? address,
    String? vehicleType,
    String? vehicleNumber,
    double? averageRating,
    int? totalTrips,
  }) {
    return ProfileData(
      driverName: driverName ?? this.driverName,
      driverId: driverId ?? this.driverId,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      averageRating: averageRating ?? this.averageRating,
      totalTrips: totalTrips ?? this.totalTrips,
    );
  }

  // Convert to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'driverId': driverId,
      'contact': contact,
      'address': address,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'averageRating': averageRating,
      'totalTrips': totalTrips,
    };
  }

  // Create from JSON from backend
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      driverName: json['driverName'] ?? '',
      driverId: json['driverId'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalTrips: json['totalTrips'] ?? 0,
    );
  }
}
