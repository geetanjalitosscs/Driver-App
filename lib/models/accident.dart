class Accident {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String vehicleNumber;
  final String location;
  final String description;
  final String photo;
  final String status;

  Accident({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.vehicleNumber,
    required this.location,
    required this.description,
    required this.photo,
    required this.status,
  });

  factory Accident.fromJson(Map<String, dynamic> json) {
    return Accident(
      id: int.parse(json['id']),
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      vehicleNumber: json['vehicle_number'],
      location: json['accident_location'],
      description: json['accident_description'],
      photo: json['photo_path'] ?? "",
      status: json['status'],
    );
  }
}
