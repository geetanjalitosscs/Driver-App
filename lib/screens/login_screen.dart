import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../providers/auth_provider.dart';
import '../widgets/common/app_error_dialog.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'kyc_verification_screen.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        // Check if KYC is approved before navigating
        if (authProvider.isKycApproved) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          // Show KYC status popup instead of bottom banner
          _showKycStatusDialog(authProvider.kycStatus);
        }
      } else if (mounted) {
        // Check if it's a KYC-related error
        if (authProvider.errorMessage?.contains('KYC verification') == true) {
          // Extract the KYC status from the error message
          String kycStatus = 'pending';
          if (authProvider.errorMessage!.contains('rejected')) {
            kycStatus = 'rejected';
          } else if (authProvider.errorMessage!.contains('pending')) {
            kycStatus = 'pending';
          }
          _showKycStatusDialog(kycStatus);
        } else {
          AppErrorDialog.show(context, authProvider.errorMessage ?? 'Login failed');
        }
      }
    } catch (e) {
      if (mounted) {
        AppErrorDialog.show(context, 'Login failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  

  void _showKycStatusDialog(String status) {
    String title;
    String message;
    Color backgroundColor;
    Color textColor;
    IconData icon;

    if (status == 'rejected') {
      title = 'KYC Verification Rejected';
      message = 'Your KYC verification has been rejected. Please contact support for assistance.';
      backgroundColor = Colors.red.shade50;
      textColor = Colors.red.shade700;
      icon = Icons.cancel_outlined;
    } else {
      title = 'KYC Verification Pending';
      message = 'Your KYC verification is still pending. Please wait for admin approval.';
      backgroundColor = Colors.orange.shade50;
      textColor = Colors.orange.shade700;
      icon = Icons.pending_outlined;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // For rejected users, stay on login screen
              // For pending users, go to KYC screen
              if (status == 'rejected') {
                // Stay on login screen - do nothing
              } else {
                // Navigate to KYC verification screen for pending
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const KycVerificationScreen()),
                );
              }
            },
            child: Text(
              'OK',
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Logo and Title
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Image.asset(
                      'assets/APATKAL_LOGO.jpeg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'APATKAL',
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to your account',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Login Form
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enableInteractiveSelection: true,
                        enableSuggestions: true,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppTheme.primaryBlue,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        enableInteractiveSelection: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppTheme.primaryBlue,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Login Button
                      AppButton(
                        text: 'Sign In',
                        onPressed: _isLoading ? null : _handleLogin,
                        isLoading: _isLoading,
                        variant: AppButtonVariant.primary,
                        isFullWidth: true,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Forgot Password Link
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.roboto(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.roboto(
                              color: Colors.grey[600],
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                              style: GoogleFonts.roboto(
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Demo Account Info
              // AppCard(
              //   padding: const EdgeInsets.all(16),
              //   child: Column(
              //     children: [
              //       Text(
              //         'Demo Account',
              //         style: GoogleFonts.roboto(
              //           fontSize: 16,
              //           fontWeight: FontWeight.w600,
              //           color: AppTheme.primaryBlue,
              //         ),
              //       ),
              //       const SizedBox(height: 8),
              //       Text(
              //         'Email: rajesh.sharma90@gmail.com\nPassword: Raj@123',
              //         style: GoogleFonts.roboto(
              //           fontSize: 14,
              //           color: Colors.grey[700],
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
