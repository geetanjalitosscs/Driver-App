import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/api_service_endpoints.dart';

class WithdrawalDialog extends StatefulWidget {
  final double walletBalance;
  final Function(double amount, Map<String, String> bankDetails) onWithdraw;

  const WithdrawalDialog({
    super.key,
    required this.walletBalance,
    required this.onWithdraw,
  });

  @override
  State<WithdrawalDialog> createState() => _WithdrawalDialogState();
}

class _WithdrawalDialogState extends State<WithdrawalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _accountHolderController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingAccounts = true;
  bool _hasSavedAccounts = false;
  bool _showNewAccountForm = false;
  List<BankAccount> _savedAccounts = [];
  BankAccount? _selectedAccount;

  @override
  void initState() {
    super.initState();
    _loadBankAccounts();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  Future<void> _loadBankAccounts() async {
    try {
      final accounts = await CentralizedApiService.getDriverBankAccounts(1); // Using driver ID = 1 for testing
      setState(() {
        _savedAccounts = accounts;
        _hasSavedAccounts = accounts.isNotEmpty;
        _isLoadingAccounts = false;
        if (_hasSavedAccounts) {
          _selectedAccount = accounts.first; // Select the most recent account by default
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingAccounts = false;
        _hasSavedAccounts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
          maxWidth: MediaQuery.of(context).size.width * 0.95,  // 95% of screen width for better button space
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.account_balance,
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Withdraw Money',
                          style: AppTheme.heading3,
                        ),
                        Text(
                          'Available Balance: ₹${widget.walletBalance.toStringAsFixed(2)}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.neutralGreyLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'Withdrawal Amount',
                  hintText: 'Enter amount to withdraw',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.primaryBlue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter withdrawal amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  if (amount > widget.walletBalance) {
                    return 'Amount exceeds available balance';
                  }
                  if (amount < 100) {
                    return 'Minimum withdrawal amount is ₹100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Bank Account Selection
              if (_isLoadingAccounts)
                const Center(child: CircularProgressIndicator())
              else if (_hasSavedAccounts && !_showNewAccountForm)
                _buildSavedAccountSelection()
              else
                _buildNewAccountForm(),

              const SizedBox(height: 12),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleWithdrawal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(_isLoading ? 'Processing...' : 'Withdraw', style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedAccountSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Bank Account',
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGreyDark,
          ),
        ),
        const SizedBox(height: 12),
        
        // Account Selection Dropdown
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BankAccount>(
              value: _selectedAccount,
              isExpanded: true,
              items: _savedAccounts.map((account) {
                return DropdownMenuItem<BankAccount>(
                  value: account,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        account.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Account Holder: ${account.accountHolderName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (BankAccount? newValue) {
                setState(() {
                  _selectedAccount = newValue;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Add New Account Button
        TextButton.icon(
          onPressed: () {
            setState(() {
              _showNewAccountForm = true;
            });
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add New Account'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildNewAccountForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank Account Details',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGreyDark,
              ),
            ),
            if (_hasSavedAccounts) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showNewAccountForm = false;
                  });
                },
                child: const Text('Use Saved Account'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        
        // Bank Name
        TextFormField(
          controller: _bankNameController,
          decoration: InputDecoration(
            labelText: 'Bank Name',
            hintText: 'Enter bank name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryBlue),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter bank name';
            }
            return null;
          },
        ),
              const SizedBox(height: 8),
              
              // Account Number
        TextFormField(
          controller: _accountNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(20),
          ],
          decoration: InputDecoration(
            labelText: 'Account Number',
            hintText: 'Enter account number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryBlue),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account number';
            }
            if (value.length < 9 || value.length > 20) {
              return 'Account number must be 9-20 digits';
            }
            return null;
          },
        ),
              const SizedBox(height: 8),
              
              // IFSC Code
        TextFormField(
          controller: _ifscCodeController,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
          decoration: InputDecoration(
            labelText: 'IFSC Code',
            hintText: 'Enter IFSC code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryBlue),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter IFSC code';
            }
            if (value.length != 11) {
              return 'IFSC code must be 11 characters';
            }
            return null;
          },
        ),
              const SizedBox(height: 8),
              
              // Account Holder Name
        TextFormField(
          controller: _accountHolderController,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Account Holder Name',
            hintText: 'Enter account holder name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryBlue),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account holder name';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _handleWithdrawal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      Map<String, String> bankDetails;

      if (_hasSavedAccounts && !_showNewAccountForm && _selectedAccount != null) {
        // Use selected saved account
        bankDetails = {
          'accountNumber': _selectedAccount!.accountNumber,
          'bankName': _selectedAccount!.bankName,
          'ifscCode': _selectedAccount!.ifscCode,
          'accountHolderName': _selectedAccount!.accountHolderName,
        };
      } else {
        // Use new account details
        bankDetails = {
          'accountNumber': _accountNumberController.text,
          'bankName': _bankNameController.text,
          'ifscCode': _ifscCodeController.text,
          'accountHolderName': _accountHolderController.text,
        };
      }

      // Show confirmation dialog
      final confirmed = await _showConfirmationDialog(amount, bankDetails);
      
      if (confirmed) {
        widget.onWithdraw(amount, bankDetails);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _showConfirmationDialog(double amount, Map<String, String> bankDetails) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Withdrawal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Withdrawal Amount',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '₹${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bank Details:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('Bank: ${bankDetails['bankName']}'),
            Text('Account: ****${bankDetails['accountNumber']!.substring(bankDetails['accountNumber']!.length - 4)}'),
            Text('IFSC: ${bankDetails['ifscCode']}'),
            Text('Holder: ${bankDetails['accountHolderName']}'),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to proceed with this withdrawal?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ) ?? false;
  }
}
