import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wallet.dart';
import '../models/withdrawal.dart';
import '../config/database_config.dart';

class WalletApiService {
  static const String _baseUrl = DatabaseConfig.baseUrl;

  // Get wallet information for a driver
  static Future<Wallet?> getWallet(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_wallet.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['wallet'] != null) {
          return Wallet.fromJson(data['wallet']);
        }
      }
      return null;
    } catch (e) {
      print('Error getting wallet: $e');
      return null;
    }
  }

  // Get withdrawals for a driver with optional filters
  static Future<List<Withdrawal>> getWithdrawals(int driverId, {String period = 'all', String status = 'all'}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_withdrawals.php?driver_id=$driverId&period=$period&status=$status'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['withdrawals'] != null) {
          final List<dynamic> withdrawalsJson = data['withdrawals'];
          return withdrawalsJson.map((json) => Withdrawal.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting withdrawals: $e');
      return [];
    }
  }

  // Get transactions (earnings, payments, etc.) for a driver
  static Future<List<Map<String, dynamic>>> getTransactions(int driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_wallet_transactions.php?driver_id=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['transactions'] != null) {
          final List<dynamic> transactionsJson = data['transactions'];
          return transactionsJson.cast<Map<String, dynamic>>();
        }
      }
      return [];
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }

  // Request a withdrawal
  static Future<bool> requestWithdrawal({
    required int driverId,
    required double amount,
    required String bankAccountNumber,
    required String bankName,
    required String ifscCode,
    required String accountHolderName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/request_withdrawal.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'amount': amount,
          'bank_account_number': bankAccountNumber,
          'bank_name': bankName,
          'ifsc_code': ifscCode,
          'account_holder_name': accountHolderName,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error requesting withdrawal: $e');
      return false;
    }
  }

  // Update wallet balance (for admin or system use)
  static Future<bool> updateWalletBalance({
    required int driverId,
    required double newBalance,
    required String reason,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/update_wallet_balance.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'new_balance': newBalance,
          'reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error updating wallet balance: $e');
      return false;
    }
  }

  // Add a transaction to wallet (for system use)
  static Future<bool> addTransaction({
    required int driverId,
    required double amount,
    required String type, // 'credit' or 'debit'
    required String description,
    required String referenceId, // trip_id, earning_id, etc.
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/add_wallet_transaction.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'driver_id': driverId,
          'amount': amount,
          'type': type,
          'description': description,
          'reference_id': referenceId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error adding transaction: $e');
      return false;
    }
  }

  // Get wallet statistics for different periods
  static Future<Map<String, dynamic>> getWalletStatistics({
    required int driverId,
    required String period, // 'today', 'yesterday', 'week', 'month'
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_wallet_statistics.php?driver_id=$driverId&period=$period'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['statistics'];
        }
      }
      return {};
    } catch (e) {
      print('Error getting wallet statistics: $e');
      return {};
    }
  }
}
