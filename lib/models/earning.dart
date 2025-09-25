class Earning {
  final int id;
  final int driverId;
  final int tripId;
  final double amount;
  final DateTime earningDate;
  final DateTime createdTime;

  Earning({
    required this.id,
    required this.driverId,
    required this.tripId,
    required this.amount,
    required this.earningDate,
    required this.createdTime,
  });

  factory Earning.fromJson(Map<String, dynamic> json) {
    return Earning(
      id: json['id'] ?? 0,
      driverId: json['driver_id'] ?? 0,
      tripId: json['trip_id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      earningDate: DateTime.parse(json['earning_date']),
      createdTime: DateTime.parse(json['created_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'trip_id': tripId,
      'amount': amount,
      'earning_date': earningDate.toIso8601String(),
      'created_time': createdTime.toIso8601String(),
    };
  }

  // Getter for compatibility with existing code
  int get earningId => id;
  DateTime get createdAt => createdTime;
}
