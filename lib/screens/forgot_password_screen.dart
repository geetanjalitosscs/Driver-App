import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_error_dialog.dart';
import '../services/api_service_endpoints.dart';
import 'forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await CentralizedApiService.forgotPassword(
        phone: _phoneController.text.trim(),
      );
      
      if (response['success'] == true && response['otp_sent'] == true && mounted) {
        // Navigate to OTP verification screen with session cookie and debug OTP
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForgotPasswordOtpScreen(
              phone: _phoneController.text.trim(),
              sessionCookie: response['session_cookie'],
            ),
          ),
        );
      } else if (mounted) {
        AppErrorDialog.show(context, response['error'] ?? response['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      if (mounted) {
        // Extract clean error message
        String errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11);
        }
        
        // Check for phone number not registered
        if (errorMessage.toLowerCase().contains('phone number not found') || 
            errorMessage.toLowerCase().contains('not found in our records') ||
            errorMessage.toLowerCase().contains('not registered')) {
          errorMessage = 'Phone number is not registered';
        }
        
        AppErrorDialog.show(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Forgot Password',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Main Card
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              Icons.lock_reset_outlined,
                              color: AppTheme.primaryBlue,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reset Password',
                                  style: GoogleFonts.roboto(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Enter your phone number to receive OTP',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Phone Number Field
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: 'Phone Number *',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppTheme.primaryBlueLight.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppTheme.primaryBlue,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length != 10) {
                            return 'Phone number must be exactly 10 digits';
                          }
                          if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
                            return 'Phone number must start with 6, 7, 8, or 9';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _handleSendOtp(),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Send OTP Button
                      AppButton(
                        text: 'Send OTP',
                        onPressed: _isLoading ? null : _handleSendOtp,
                        isLoading: _isLoading,
                        variant: AppButtonVariant.primary,
                        isFullWidth: true,
                        icon: Icons.send_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

