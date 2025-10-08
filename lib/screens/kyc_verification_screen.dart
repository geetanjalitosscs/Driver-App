import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../main.dart';
import 'login_screen.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({Key? key}) : super(key: key);

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndCheckStatus();
  }

  Future<void> _initializeAndCheckStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    print('🔄 Initializing KYC screen...');
    
    // Wait for auth to be initialized
    await authProvider.initializeAuth();
    
    // Check if user data is available
    if (authProvider.currentUser != null) {
      print('✅ User data available, checking KYC status');
      _checkKycStatus();
    } else {
      print('❌ No user data available, showing error');
      _showErrorDialog();
    }
  }

  Future<void> _checkKycStatus({bool showDialog = false}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    print('🔄 Starting KYC status check from UI...');
    print('👤 Current user: ${authProvider.currentUser?.driverName}');
    print('🆔 Driver ID: ${authProvider.currentUser?.driverIdAsInt}');
    print('📊 Current KYC status: ${authProvider.kycStatus}');
    
    try {
      await authProvider.checkKycStatus();
      
      print('✅ KYC status check completed');
      print('📊 New KYC status: ${authProvider.kycStatus}');
      
      if (showDialog) {
        _maybeShowStatusDialog(authProvider.kycStatus);
      }
    } catch (e) {
      print('❌ Error in KYC status check: $e');
      // Show error dialog without mounted check
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Error', style: AppTheme.heading1),
        content: Text('Failed to check KYC status. Please try again.', style: AppTheme.bodyLarge),
        backgroundColor: Colors.red.shade50,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _maybeShowStatusDialog(String status) {
    String? message;
    Color? backgroundColor;
    Color? textColor;
    IconData? icon;
    
    if (status == 'rejected') {
      message = 'Your application is rejected';
      backgroundColor = Colors.red.shade50;
      textColor = Colors.red.shade700;
      icon = Icons.cancel_outlined;
    } else if (status == 'approved') {
      message = 'Your application is approved! You will be redirected to the app.';
      backgroundColor = Colors.green.shade50;
      textColor = Colors.green.shade700;
      icon = Icons.check_circle_outline;
    } else if (status != 'approved') {
      message = 'Your application is pending';
      backgroundColor = Colors.orange.shade50;
      textColor = Colors.orange.shade700;
      icon = Icons.pending_outlined;
    }
    
    if (message != null) {
      showDialog(
        context: context,
        barrierDismissible: false, // Don't allow dismissing by tapping outside
        builder: (ctx) => AlertDialog(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              Icon(icon, color: textColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'KYC Status',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            message!,
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (status == 'approved') {
                  // KYC approved - automatically login and go to home screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                }
              },
              child: Text(
                'OK',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final bool isSmallHeight = constraints.maxHeight < 700;
                final double maxWidth = constraints.maxWidth < 520 ? constraints.maxWidth : 520;
                final double iconSize = constraints.maxWidth < 360 ? 48 : 60;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: isSmallHeight ? MainAxisAlignment.start : MainAxisAlignment.center,
                        children: [
                  // KYC Icon
                  Container(
                    width: iconSize * 2,
                    height: iconSize * 2,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified_user_outlined,
                      size: iconSize,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    authProvider.kycStatus == 'rejected' 
                        ? 'KYC Verification Rejected'
                        : 'KYC Verification Pending',
                    style: AppTheme.heading1.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: authProvider.kycStatus == 'rejected' 
                          ? Colors.red.shade700
                          : AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    authProvider.kycStatus == 'rejected'
                        ? 'Your KYC verification has been rejected. Please contact our support team for more information about the rejection reason.\n\nYou may need to resubmit your documents with corrections.'
                        : 'Your KYC documents have been submitted successfully and are currently under review by our verification team.\n\nPlease allow up to 24–48 hours for verification. You\'ll be notified once your profile is approved and activated.',
                    style: AppTheme.bodyLarge.copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Warning/Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: authProvider.kycStatus == 'rejected' 
                          ? Colors.red.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: authProvider.kycStatus == 'rejected'
                            ? Colors.red.withOpacity(0.3)
                            : Colors.orange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          authProvider.kycStatus == 'rejected'
                              ? Icons.error_outline
                              : Icons.warning_amber_outlined,
                          color: authProvider.kycStatus == 'rejected'
                              ? Colors.red
                              : Colors.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            authProvider.kycStatus == 'rejected'
                                ? 'Please contact support for assistance with resubmitting your documents.'
                                : 'Please do not update your documents, ensure the uploaded copies are clear and valid.',
                            style: AppTheme.bodyLarge.copyWith(
                              color: authProvider.kycStatus == 'rejected'
                                  ? Colors.red.shade700
                                  : Colors.orange.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppTheme.primaryBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Status:',
                              style: AppTheme.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: authProvider.kycStatus == 'rejected'
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: authProvider.kycStatus == 'rejected'
                                      ? Colors.red
                                      : Colors.orange,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                authProvider.kycStatus == 'rejected'
                                    ? 'Rejected'
                                    : 'Pending Review',
                                style: AppTheme.bodyLarge.copyWith(
                                  color: authProvider.kycStatus == 'rejected'
                                      ? Colors.red.shade700
                                      : Colors.orange.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Icon(
                              Icons.next_plan_outlined,
                              color: AppTheme.primaryBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Next Step:',
                              style: AppTheme.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              authProvider.kycStatus == 'rejected'
                                  ? 'Contact support for assistance'
                                  : 'Wait for admin approval',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Thank you message
                  Text(
                    'Thank you for your patience and cooperation.',
                    style: AppTheme.bodyLarge.copyWith(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Refresh button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        
                        // Ensure user data is available
                        if (authProvider.currentUser == null) {
                          await authProvider.initializeAuth();
                        }
                        
                        if (authProvider.currentUser != null) {
                          await _checkKycStatus(showDialog: true);
                        } else {
                          _showErrorDialog();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Check Status',
                        style: AppTheme.buttonText,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Logout button
                  TextButton(
                    onPressed: () {
                      authProvider.logout();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
