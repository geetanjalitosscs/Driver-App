class Wallet {
  final int walletId;
  final int driverId;
  final double balance;
  final DateTime updatedAt;

  Wallet({
    required this.walletId,
    required this.driverId,
    required this.balance,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      walletId: json['wallet_id'] ?? 0,
      driverId: json['driver_id'] ?? 0,
      balance: (json['balance'] ?? 0).toDouble(),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_id': walletId,
      'driver_id': driverId,
      'balance': balance,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedBalance {
    return '₹${balance.toStringAsFixed(2)}';
  }
}
