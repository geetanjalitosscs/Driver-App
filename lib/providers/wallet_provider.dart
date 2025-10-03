import 'package:flutter/foundation.dart';
import '../models/wallet.dart';
import '../models/withdrawal.dart';
import '../services/api_service.dart';

class WalletProvider extends ChangeNotifier {
  Wallet? _wallet;
  List<Withdrawal> _withdrawals = [];
  List<Map<String, dynamic>> _transactions = [];
  String _currentPeriod = 'all';
  
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Wallet? get wallet => _wallet;
  List<Withdrawal> get withdrawals => _withdrawals;
  List<Map<String, dynamic>> get transactions => _transactions;
  String get currentPeriod => _currentPeriod;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get filtered withdrawals based on current period
  List<Withdrawal> get filteredWithdrawals {
    // For 'all' period, return all withdrawals
    if (_currentPeriod.toLowerCase() == 'all') {
      return _withdrawals;
    }

    final now = DateTime.now();
    DateTime startDate;

    switch (_currentPeriod.toLowerCase()) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'year':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        return _withdrawals; // Return all for unknown periods
    }

    return _withdrawals.where((withdrawal) {
      return withdrawal.requestedAt.isAfter(startDate);
    }).toList();
  }

  // Get total withdrawals amount
  double get totalWithdrawals {
    return _withdrawals.fold(0.0, (sum, withdrawal) => sum + withdrawal.amount);
  }

  // Get pending withdrawals count
  int get pendingWithdrawalsCount {
    return _withdrawals.where((w) => w.status.toLowerCase() == 'pending').length;
  }

  // Get approved withdrawals count
  int get approvedWithdrawalsCount {
    return _withdrawals.where((w) => w.status.toLowerCase() == 'approved').length;
  }

  // Load wallet data for a driver
  Future<void> loadWalletData(int driverId, {String period = 'all', String status = 'all'}) async {
    _setLoading(true);
    _clearError();
    _currentPeriod = period;

    try {
      // Load wallet balance
      final wallet = await CentralizedApiService.getWallet(driverId);
      _wallet = wallet;

      // Load withdrawals with filters
      final withdrawals = await CentralizedApiService.getWithdrawals(driverId);
      _withdrawals = withdrawals;

      // Load transactions (earnings, payments, etc.)
      final transactions = await CentralizedApiService.getWalletTransactions(driverId);
      _transactions = transactions.map((payment) => payment.toJson()).toList();

      // Add wallet balance notification if balance changed
      if (_wallet != null) {
        _addWalletBalanceNotification();
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load wallet data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add earnings to wallet
  Future<void> addEarnings(int driverId, double amount) async {
    try {
      // Reload wallet data to get updated balance
      await loadWalletData(driverId);
    } catch (e) {
      print('Error updating wallet after adding earnings: $e');
    }
  }

  // Request a withdrawal
  Future<bool> requestWithdrawal({
    required double amount,
    required String bankAccountNumber,
    required String bankName,
    required String ifscCode,
    required String accountHolderName,
  }) async {
    if (_wallet == null) {
      _setError('Wallet not loaded');
      return false;
    }

    if (amount > _wallet!.balance) {
      _setError('Insufficient balance');
      return false;
    }

    if (amount <= 0) {
      _setError('Invalid withdrawal amount');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // Note: Using placeholder bank account ID since centralized service expects it
      final result = await CentralizedApiService.requestWithdrawal(
        driverId: _wallet!.driverId,
        amount: amount,
        bankAccountId: '1', // Placeholder - should be proper bank account ID
      );
      final success = result['success'] == true;

      if (success) {
        // Reload wallet data to get updated balance and new withdrawal
        await loadWalletData(_wallet!.driverId);
        return true;
      } else {
        _setError('Failed to submit withdrawal request');
        return false;
      }
    } catch (e) {
      _setError('Error submitting withdrawal request: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Set period for filtering withdrawals
  Future<void> setPeriod(String period) async {
    _currentPeriod = period;
    notifyListeners();
  }

  // Add a transaction (for testing or manual addition)
  void addTransaction(Map<String, dynamic> transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  // Update wallet balance (for testing or manual updates)
  void updateWalletBalance(double newBalance) {
    if (_wallet != null) {
      _wallet = Wallet(
        walletId: _wallet!.walletId,
        driverId: _wallet!.driverId,
        balance: newBalance,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Clear all data (for logout)
  void clearAllData() {
    _wallet = null;
    _withdrawals.clear();
    _currentPeriod = 'all';
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Get wallet statistics for different time periods
  Map<String, double> getWalletStatistics(String period) {
    final now = DateTime.now();
    DateTime startDate;

    switch (period.toLowerCase()) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'yesterday':
        startDate = DateTime(now.year, now.month, now.day - 1);
        break;
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      default:
        startDate = DateTime(now.year, now.month, now.day);
    }

    double totalCredits = 0;
    double totalDebits = 0;
    double totalWithdrawals = 0;

    // Calculate credits and debits from transactions
    for (final transaction in _transactions) {
      final transactionDate = DateTime.parse(transaction['created_at']);
      if (transactionDate.isAfter(startDate)) {
        if (transaction['type'] == 'credit') {
          totalCredits += (transaction['amount'] as num).toDouble();
        } else if (transaction['type'] == 'debit') {
          totalDebits += (transaction['amount'] as num).toDouble();
        }
      }
    }

    // Calculate withdrawals
    for (final withdrawal in _withdrawals) {
      if (withdrawal.requestedAt.isAfter(startDate)) {
        totalWithdrawals += withdrawal.amount;
      }
    }

    return {
      'credits': totalCredits,
      'debits': totalDebits,
      'withdrawals': totalWithdrawals,
      'net': totalCredits - totalDebits - totalWithdrawals,
    };
  }

  // Add wallet balance notification
  void _addWalletBalanceNotification() {
    // This will be called from the UI context where NotificationProvider is available
    print('Wallet balance notification should be added for balance ${_wallet?.balance}');
  }
}
