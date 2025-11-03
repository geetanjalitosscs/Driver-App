import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_error_dialog.dart';
import '../services/api_service_endpoints.dart';
import 'reset_password_screen.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String phone;
  final String? sessionCookie;

  const ForgotPasswordOtpScreen({
    super.key,
    required this.phone,
    this.sessionCookie,
  });

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  int _resendCooldown = 0;
  Timer? _resendTimer;
  String? _sessionCookie;

  @override
  void initState() {
    super.initState();
    _resendCooldown = 30;
    _sessionCookie = widget.sessionCookie;
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        setState(() {
          _resendCooldown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_resendCooldown > 0) return;

    setState(() {
      _isResending = true;
    });

    try {
      // Use existing session cookie when resending to maintain session
      final response = await CentralizedApiService.forgotPassword(
        phone: widget.phone,
        sessionCookie: _sessionCookie, // Pass existing session cookie
      );
      
      // Update session cookie if a new one is provided (should be same if session maintained)
      if (response['session_cookie'] != null) {
        _sessionCookie = response['session_cookie'];
      }

      if (response['success'] == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP resent successfully to ${widget.phone}'),
            backgroundColor: AppTheme.accentGreen,
            duration: const Duration(seconds: 2),
          ),
        );
        
        setState(() {
          _resendCooldown = 30;
        });
        _startResendTimer();
      } else if (mounted) {
        AppErrorDialog.show(context, response['error'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      if (mounted) {
        AppErrorDialog.show(context, 'Failed to resend OTP: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 4) {
      AppErrorDialog.show(context, 'Please enter a valid 4-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await CentralizedApiService.verifyForgotPasswordOtp(
        otp: _otpController.text.trim(),
        phone: widget.phone,
        sessionCookie: _sessionCookie,
      );

      if (response['success'] == true && response['verified'] == true && mounted) {
        // Navigate to reset password screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              phone: widget.phone,
              sessionCookie: _sessionCookie,
            ),
          ),
        );
      } else if (mounted) {
        AppErrorDialog.show(context, response['error'] ?? response['message'] ?? 'Invalid OTP. Please check and try again.');
      }
    } catch (e) {
      if (mounted) {
        // Extract clean error message from exception
        String errorMessage = 'Invalid OTP. Please check and try again.';
        String errorString = e.toString();
        
        if (errorString.contains('Invalid OTP')) {
          errorMessage = 'Invalid OTP. Please check and try again.';
        } else if (errorString.contains('expired')) {
          errorMessage = 'OTP has expired. Please request a new one.';
        } else if (errorString.contains('session expired')) {
          errorMessage = 'OTP session expired. Please request a new one.';
        } else if (errorString.isNotEmpty) {
          // Try to extract the actual error message
          final match = RegExp(r'Exception:\s*(.+)').firstMatch(errorString);
          if (match != null) {
            errorMessage = match.group(1) ?? errorMessage;
          }
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
          'Verify OTP',
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
              
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            Icons.person_outline,
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
                                'Verify your identity to continue',
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
                    
                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.accentGreen,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.accentGreen,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'OTP sent to ${widget.phone}. Please check your SMS.',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: AppTheme.accentGreen700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            color: AppTheme.accentOrange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Verify OTP',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Enter the 4-digit OTP sent to ${widget.phone}',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                        color: AppTheme.primaryBlue,
                      ),
                      decoration: InputDecoration(
                        labelText: 'OTP Code *',
                        hintText: 'Enter 4-digit OTP',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppTheme.primaryBlueLight.withOpacity(0.5)),
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
                      onFieldSubmitted: (_) => _verifyOtp(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    AppButton(
                      text: 'Verify OTP',
                      onPressed: _isLoading ? null : _verifyOtp,
                      isLoading: _isLoading,
                      variant: AppButtonVariant.primary,
                      isFullWidth: true,
                      icon: Icons.check_circle_outline,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            "Didn't receive OTP? ",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_resendCooldown > 0)
                          Flexible(
                            child: Text(
                              'Resend in $_resendCooldown${_resendCooldown == 1 ? ' second' : ' seconds'}',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: AppTheme.accentOrange,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        else
                          TextButton(
                            onPressed: _isResending ? null : _resendOtp,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: _isResending
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  )
                                : Text(
                                    'Resend OTP',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: AppTheme.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

