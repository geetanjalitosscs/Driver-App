class Payment {
  final int paymentId;
  final int tripId;
  final int driverId;
  final double amount;
  final String paymentMethod;
  final String paymentStatus; // 'pending', 'completed', 'failed'
  final String? transactionId;
  final DateTime? paidAt;

  Payment({
    required this.paymentId,
    required this.tripId,
    required this.driverId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.transactionId,
    this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['payment_id'] ?? 0,
      tripId: json['trip_id'] ?? 0,
      driverId: json['driver_id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'] ?? 'pending',
      transactionId: json['transaction_id'],
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'trip_id': tripId,
      'driver_id': driverId,
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'transaction_id': transactionId,
      'paid_at': paidAt?.toIso8601String(),
    };
  }

  bool get isCompleted => paymentStatus == 'completed';
  bool get isPending => paymentStatus == 'pending';
  bool get isFailed => paymentStatus == 'failed';
}
