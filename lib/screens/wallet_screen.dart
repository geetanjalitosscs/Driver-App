import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';
import '../providers/wallet_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/navigation_provider.dart';
import '../models/withdrawal.dart';
import '../widgets/withdrawal_dialog.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String _selectedPeriod = 'today';
  final List<Map<String, String>> _periods = [
    {'value': 'today', 'label': 'Today'},
    {'value': 'week', 'label': 'This Week'},
    {'value': 'month', 'label': 'This Month'},
    {'value': 'year', 'label': 'This Year'},
  ];

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    
    if (profileProvider.profile.driverId.isNotEmpty) {
      await walletProvider.loadWalletData(int.parse(profileProvider.profile.driverId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // Navigate back to home screen using NavigationProvider
            final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
            navigationProvider.navigateToHome();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          padding: const EdgeInsets.all(16),
        ),
        title: Text(
          'Wallet',
          style: AppTheme.heading3.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadWalletData,
            icon: const Icon(Icons.refresh, color: Colors.white),
            padding: const EdgeInsets.all(16),
          ),
        ],
      ),
      body: Consumer2<WalletProvider, ProfileProvider>(
        builder: (context, walletProvider, profileProvider, child) {
          if (walletProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (walletProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppTheme.accentRed, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    walletProvider.errorMessage!,
                    style: AppTheme.bodyMedium.copyWith(color: AppTheme.accentRed),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadWalletData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet Balance Card
                _buildWalletBalanceCard(walletProvider),
                const SizedBox(height: 16),

                // Action Buttons
                _buildActionButtons(),
                const SizedBox(height: 16),

                // Transaction History Section
                _buildTransactionHistorySection(walletProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWalletBalanceCard(WalletProvider walletProvider) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Balance',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.neutralGreyLight,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: AppTheme.accentGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                walletProvider.wallet?.formattedBalance ?? '₹0.00',
                style: AppTheme.heading1.copyWith(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _showWithdrawalDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance, size: 20),
            const SizedBox(width: 8),
            const Text('Withdraw Money'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistorySection(WalletProvider walletProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Withdrawals',
              style: AppTheme.heading3,
            ),
            _buildPeriodDropdown(),
          ],
        ),
        const SizedBox(height: 12),
        if (walletProvider.filteredWithdrawals.isEmpty)
          AppCard(
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.receipt_long, color: AppTheme.neutralGreyLight, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'No withdrawals found',
                    style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutralGrey),
                  ),
                ],
              ),
            ),
          )
        else
          ...walletProvider.filteredWithdrawals.map((withdrawal) => _buildWithdrawalCard(withdrawal)).toList(),
      ],
    );
  }

  Widget _buildPeriodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.neutralGreyLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          icon: Icon(Icons.keyboard_arrow_down, color: AppTheme.neutralGrey),
          style: AppTheme.bodyMedium,
          items: _periods.map((period) {
            return DropdownMenuItem<String>(
              value: period['value'],
              child: Text(period['label']!),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            if (newValue != null && newValue != _selectedPeriod) {
              setState(() {
                _selectedPeriod = newValue;
              });
              
              final walletProvider = Provider.of<WalletProvider>(context, listen: false);
              await walletProvider.setPeriod(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildWithdrawalCard(Withdrawal withdrawal) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accentRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.account_balance,
              color: AppTheme.accentRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Withdrawal to Bank',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${withdrawal.bankName} - ${withdrawal.accountHolderName}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.neutralGreyLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(withdrawal.requestedAt),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.neutralGreyLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${withdrawal.status}',
                  style: AppTheme.bodySmall.copyWith(
                    color: _getStatusColor(withdrawal.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-₹${withdrawal.amount.toStringAsFixed(2)}',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.accentRed,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.accentOrange;
      case 'approved':
        return AppTheme.accentGreen;
      case 'rejected':
        return AppTheme.accentRed;
      default:
        return AppTheme.neutralGrey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }


  void _showWithdrawalDialog() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    
    if (walletProvider.wallet?.balance == 0 || walletProvider.wallet?.balance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient balance for withdrawal'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => WithdrawalDialog(
        walletBalance: walletProvider.wallet!.balance,
        onWithdraw: (amount, bankDetails) async {
          Navigator.of(context).pop();
          
      final success = await walletProvider.requestWithdrawal(
        amount: amount,
        bankAccountNumber: bankDetails['accountNumber']!,
        bankName: bankDetails['bankName']!,
        ifscCode: bankDetails['ifscCode']!,
        accountHolderName: bankDetails['accountHolderName']!,
      );
          
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Withdrawal request submitted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _loadWalletData(); // Refresh data
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(walletProvider.errorMessage ?? 'Failed to submit withdrawal request'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}
