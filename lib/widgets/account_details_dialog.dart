import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/common/app_error_dialog.dart';
import '../config/database_config.dart';

class AccountDetailsDialog extends StatefulWidget {
  const AccountDetailsDialog({super.key});

  @override
  State<AccountDetailsDialog> createState() => _AccountDetailsDialogState();
}

class _AccountDetailsDialogState extends State<AccountDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _accountHolderController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingDetails = true;
  bool _hasAccountDetails = false;

  @override
  void initState() {
    super.initState();
    _loadAccountDetails();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  Future<void> _loadAccountDetails() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final driverId = authProvider.currentUser?.driverId;
      
      if (driverId == null) {
        AppErrorDialog.show(context, 'Driver not found');
        return;
      }

      final response = await http.get(
        Uri.parse('${DatabaseConfig.baseUrl}get_account_details.php?driver_id=$driverId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          setState(() {
            _hasAccountDetails = data['has_account_details'];
            _isLoadingDetails = false;
          });

          if (_hasAccountDetails && data['account_details'] != null) {
            final details = data['account_details'];
            _accountNumberController.text = details['account_number'] ?? '';
            _bankNameController.text = details['bank_name'] ?? '';
            _ifscCodeController.text = details['ifsc_code'] ?? '';
            _accountHolderController.text = details['account_holder_name'] ?? '';
          }
        } else {
          AppErrorDialog.show(context, data['message'] ?? 'Failed to load account details');
        }
      } else {
        AppErrorDialog.show(context, 'Failed to load account details');
      }
    } catch (e) {
      AppErrorDialog.show(context, 'Error loading account details: $e');
    } finally {
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  Future<void> _saveAccountDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final driverId = authProvider.currentUser?.driverId;
      
      if (driverId == null) {
        AppErrorDialog.show(context, 'Driver not found');
        return;
      }

      final accountDetails = {
        'driver_id': driverId,
        'account_number': _accountNumberController.text.trim(),
        'bank_name': _bankNameController.text.trim(),
        'ifsc_code': _ifscCodeController.text.trim(),
        'account_holder_name': _accountHolderController.text.trim(),
      };

      final response = await http.post(
        Uri.parse('${DatabaseConfig.baseUrl}save_account_details.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(accountDetails),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account details saved successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        } else {
          AppErrorDialog.show(context, data['message'] ?? 'Failed to save account details');
        }
      } else {
        AppErrorDialog.show(context, 'Failed to save account details');
      }
    } catch (e) {
      AppErrorDialog.show(context, 'Error saving account details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.account_balance,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'Account Details',
            style: AppTheme.heading3.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: _isLoadingDetails
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    const SizedBox(height: 12),
                    
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
                    const SizedBox(height: 12),
                    
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
                        if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
                          return 'Invalid IFSC code format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    
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
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveAccountDetails,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
