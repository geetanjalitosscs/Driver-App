import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_error_dialog.dart';
import 'kyc_verification_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final Map<String, dynamic>? signupData; // Store signup form data

  const OtpVerificationScreen({
    super.key,
    required this.phone,
    this.signupData,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  int _resendCooldown = 0; // Cooldown in seconds
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    // Start with 30 second cooldown
    _resendCooldown = 30;
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.resendOtp(phone: widget.phone);

      if (success && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP resent successfully to ${widget.phone}'),
            backgroundColor: AppTheme.accentGreen,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Reset cooldown
        setState(() {
          _resendCooldown = 30;
        });
        _startResendTimer();
      } else if (mounted) {
        AppErrorDialog.show(context, authProvider.errorMessage ?? 'Failed to resend OTP');
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.verifyOtp(
        otp: _otpController.text.trim(),
        phone: widget.phone,
      );

      if (success && mounted) {
        // Navigate to KYC verification screen after successful signup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const KycVerificationScreen()),
        );
      } else if (mounted) {
        AppErrorDialog.show(context, authProvider.errorMessage ?? 'OTP verification failed');
      }
    } catch (e) {
      if (mounted) {
        AppErrorDialog.show(context, 'OTP verification failed: $e');
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
              
              // Main Card
              AppCard(
                padding: const EdgeInsets.all(24),
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
                                'Driver Registration',
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Join Apatkal and manage your trips of accident reports',
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
                    
                    // OTP Sent Confirmation
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
                    
                    // Verify OTP Section
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
                    
                    // OTP Input Field
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
                    
                    // Verify Button
                    AppButton(
                      text: 'Verify OTP & Register',
                      onPressed: _isLoading ? null : _verifyOtp,
                      isLoading: _isLoading,
                      variant: AppButtonVariant.primary,
                      isFullWidth: true,
                      icon: Icons.check_circle_outline,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Resend OTP Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive OTP? ",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        if (_resendCooldown > 0)
                          Text(
                            'Resend in $_resendCooldown${_resendCooldown == 1 ? ' second' : ' seconds'}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: AppTheme.accentOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          TextButton(
                            onPressed: _isResending ? null : _resendOtp,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
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
              
              // Back Link
              TextButton(
                onPressed: () {
                  // Return signup data when going back
                  Navigator.of(context).pop(widget.signupData);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, size: 16, color: AppTheme.primaryBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Back to Registration Form',
                      style: GoogleFonts.roboto(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

