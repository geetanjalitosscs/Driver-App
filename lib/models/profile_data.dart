class ProfileData {
  final String driverName;
  final String driverId;
  final String contact;
  final String address;
  final String vehicleType;
  final double averageRating;
  final int totalTrips;

  ProfileData({
    required this.driverName,
    required this.driverId,
    required this.contact,
    required this.address,
    required this.vehicleType,
    required this.averageRating,
    required this.totalTrips,
  });

  // Default profile data
  static ProfileData getDefault() {
    return ProfileData(
      driverName: 'Rajash Sharma',
      driverId: 'AMB789',
      contact: '+91 9874210',
      address: '123, Gandhi Marg, Sue Delhi',
      vehicleType: 'Force Traveller',
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
    double? averageRating,
    int? totalTrips,
  }) {
    return ProfileData(
      driverName: driverName ?? this.driverName,
      driverId: driverId ?? this.driverId,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      vehicleType: vehicleType ?? this.vehicleType,
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
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalTrips: json['totalTrips'] ?? 0,
    );
  }
}
