class Earning {
  final int earningId;
  final int driverId;
  final int tripId;
  final double amount;
  final DateTime earningDate;
  final DateTime createdAt;

  Earning({
    required this.earningId,
    required this.driverId,
    required this.tripId,
    required this.amount,
    required this.earningDate,
    required this.createdAt,
  });

  factory Earning.fromJson(Map<String, dynamic> json) {
    return Earning(
      earningId: json['earning_id'] ?? 0,
      driverId: json['driver_id'] ?? 0,
      tripId: json['trip_id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      earningDate: DateTime.parse(json['earning_date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'earning_id': earningId,
      'driver_id': driverId,
      'trip_id': tripId,
      'amount': amount,
      'earning_date': earningDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
