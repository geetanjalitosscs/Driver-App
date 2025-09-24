class Withdrawal {
  final int withdrawalId;
  final int driverId;
  final double amount;
  final String bankAccountNumber;
  final String bankName;
  final String ifscCode;
  final String accountHolderName;
  final String status; // 'pending', 'approved', 'rejected', 'completed'
  final DateTime requestedAt;
  final DateTime? processedAt;

  Withdrawal({
    required this.withdrawalId,
    required this.driverId,
    required this.amount,
    required this.bankAccountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.accountHolderName,
    required this.status,
    required this.requestedAt,
    this.processedAt,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      withdrawalId: json['withdrawal_id'] ?? 0,
      driverId: json['driver_id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      bankAccountNumber: json['bank_account_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      status: json['status'] ?? 'pending',
      requestedAt: DateTime.parse(json['requested_at']),
      processedAt: json['processed_at'] != null ? DateTime.parse(json['processed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'withdrawal_id': withdrawalId,
      'driver_id': driverId,
      'amount': amount,
      'bank_account_number': bankAccountNumber,
      'bank_name': bankName,
      'ifsc_code': ifscCode,
      'account_holder_name': accountHolderName,
      'status': status,
      'requested_at': requestedAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isCompleted => status == 'completed';

  String get formattedAmount {
    return '₹${amount.toStringAsFixed(2)}';
  }
}
