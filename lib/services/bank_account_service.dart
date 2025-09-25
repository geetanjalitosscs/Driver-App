import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/database_config.dart';

class BankAccountService {
  static const String _baseUrl = DatabaseConfig.baseUrl;

  // Get saved bank accounts for a driver
  static Future<List<BankAccount>> getDriverBankAccounts(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_driver_bank_accounts.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return (data['accounts'] as List)
              .map((account) => BankAccount.fromJson(account))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Failed to fetch bank accounts');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching bank accounts: $e');
    }
  }

  // Check if driver has any saved bank accounts
  static Future<bool> hasSavedAccounts(int driverId) async {
    try {
      final accounts = await getDriverBankAccounts(driverId);
      return accounts.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

class BankAccount {
  final String accountNumber;
  final String bankName;
  final String ifscCode;
  final String accountHolderName;
  final String lastUsed;
  final String displayName;

  BankAccount({
    required this.accountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.accountHolderName,
    required this.lastUsed,
    required this.displayName,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountNumber: json['account_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      lastUsed: json['last_used'] ?? '',
      displayName: json['display_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'bank_name': bankName,
      'ifsc_code': ifscCode,
      'account_holder_name': accountHolderName,
      'last_used': lastUsed,
      'display_name': displayName,
    };
  }
}
