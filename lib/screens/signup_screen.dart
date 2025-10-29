import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/centered_api.dart';
import 'kyc_verification_screen.dart';
import 'otp_verification_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import '../main.dart';
import '../widgets/common/app_error_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedVehicleType = 'Ambulance';
  final _vehicleNumberController = TextEditingController();
  
  // Account details controllers
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  
  // File upload fields
  String? _aadharPhotoPath; // full file path
  String? _licencePhotoPath; // full file path
  String? _rcPhotoPath; // full file path
  
  // Scroll controller for scrolling to top
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _vehicleNumberController.dispose();
    
    // Account details controllers
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    _accountHolderNameController.dispose();
    
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate photos are selected
    if (_aadharPhotoPath == null) {
      _showErrorSnackBar('Please select Aadhar Card photo');
      return;
    }
    
    if (_licencePhotoPath == null) {
      _showErrorSnackBar('Please select Driving Licence photo');
      return;
    }
    
    if (_rcPhotoPath == null) {
      _showErrorSnackBar('Please select RC photo');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Convert selected photos to base64 data URIs so backend can save files
      final uploadedAadhar = await _encodePhotoAsBase64(_aadharPhotoPath);
      final uploadedLicence = await _encodePhotoAsBase64(_licencePhotoPath);
      final uploadedRc = await _encodePhotoAsBase64(_rcPhotoPath);
      
      // Double-check that photos were encoded successfully
      if (uploadedAadhar == null || uploadedAadhar.isEmpty) {
        _showErrorSnackBar('Failed to process Aadhar Card photo. Please try again.');
        return;
      }
      
      if (uploadedLicence == null || uploadedLicence.isEmpty) {
        _showErrorSnackBar('Failed to process Driving Licence photo. Please try again.');
        return;
      }
      
      if (uploadedRc == null || uploadedRc.isEmpty) {
        _showErrorSnackBar('Failed to process RC photo. Please try again.');
        return;
      }

      final success = await authProvider.signup(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        address: _addressController.text.trim(),
        vehicleType: _selectedVehicleType,
        vehicleNumber: _vehicleNumberController.text.trim(),
        aadharPhoto: uploadedAadhar ?? '',
        licencePhoto: uploadedLicence ?? '',
        rcPhoto: uploadedRc ?? '',
        accountNumber: _accountNumberController.text.trim(),
        bankName: _bankNameController.text.trim(),
        ifscCode: _ifscCodeController.text.trim(),
        accountHolderName: _accountHolderNameController.text.trim(),
      );

      if (success && mounted) {
        // Check if OTP was sent
        if (authProvider.lastSignupResponse?['otp_sent'] == true) {
          // Collect all form data to pass to OTP screen
          final signupData = {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'password': _passwordController.text,
            'address': _addressController.text.trim(),
            'vehicleType': _selectedVehicleType,
            'vehicleNumber': _vehicleNumberController.text.trim(),
            'accountNumber': _accountNumberController.text.trim(),
            'bankName': _bankNameController.text.trim(),
            'ifscCode': _ifscCodeController.text.trim(),
            'accountHolderName': _accountHolderNameController.text.trim(),
            'aadharPhotoPath': _aadharPhotoPath,
            'licencePhotoPath': _licencePhotoPath,
            'rcPhotoPath': _rcPhotoPath,
          };
          
          // Navigate to OTP verification screen (use push instead of pushReplacement to allow going back)
          final phone = _phoneController.text.trim();
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                phone: phone,
                signupData: signupData,
              ),
            ),
          );
          
          // If we get data back, restore the form
          if (result != null && result is Map<String, dynamic> && mounted) {
            _restoreFormData(result);
            // Scroll to top after a brief delay to ensure widget is rebuilt
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted && _scrollController.hasClients) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        } else {
          // Old flow - direct to KYC (shouldn't happen now)
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const KycVerificationScreen()),
          );
        }
      } else if (mounted) {
        AppErrorDialog.show(context, authProvider.errorMessage ?? 'Signup failed');
      }
    } catch (e) {
      if (mounted) {
        AppErrorDialog.show(context, 'Signup failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Restore form data when returning from OTP screen
  void _restoreFormData(Map<String, dynamic> data) {
    setState(() {
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _passwordController.text = data['password'] ?? '';
      _confirmPasswordController.text = data['password'] ?? '';
      _addressController.text = data['address'] ?? '';
      _selectedVehicleType = data['vehicleType'] ?? 'Ambulance';
      _vehicleNumberController.text = data['vehicleNumber'] ?? '';
      _accountNumberController.text = data['accountNumber'] ?? '';
      _bankNameController.text = data['bankName'] ?? '';
      _ifscCodeController.text = data['ifscCode'] ?? '';
      _accountHolderNameController.text = data['accountHolderName'] ?? '';
      _aadharPhotoPath = data['aadharPhotoPath'];
      _licencePhotoPath = data['licencePhotoPath'];
      _rcPhotoPath = data['rcPhotoPath'];
    });
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
          'Create Account',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Title
              Text(
                'Join as a Driver',
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Fill in your details to get started',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Signup Form
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        enableInteractiveSelection: true,
                        enableSuggestions: true,
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person_outlined),
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
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
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
                      
                      const SizedBox(height: 12),
                      
                      // Phone Field
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Only allow numbers
                          LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                        ],
                        enableInteractiveSelection: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: const Icon(Icons.phone_outlined),
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
                            return 'Please enter your phone number';
                          }
                          // Value is already digits only due to input formatter
                          if (value.length != 10) {
                            return 'Phone number must be exactly 10 digits';
                          }
                          if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
                            return 'Phone number must start with 6, 7, 8, or 9';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Address Field
                      TextFormField(
                        controller: _addressController,
                        enableInteractiveSelection: true,
                        enableSuggestions: true,
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          prefixIcon: const Icon(Icons.location_on_outlined),
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
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Vehicle Type Field (Dropdown)
                      DropdownButtonFormField<String>(
                        value: _selectedVehicleType,
                        decoration: InputDecoration(
                          labelText: 'Vehicle Type',
                          prefixIcon: const Icon(Icons.directions_car_outlined),
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
                        items: const [
                          'Ambulance',
                          'Sedan',
                          'SUV',
                          'Hatchback',
                          'Van',
                          'Pickup',
                          'Motorbike',
                          'Auto Rickshaw',
                          'Truck',
                        ].map(
                          (t) => DropdownMenuItem<String>(
                            value: t,
                            child: Text(t),
                          ),
                        ).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedVehicleType = val ?? _selectedVehicleType;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Vehicle Number Field
                      TextFormField(
                        controller: _vehicleNumberController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // Only alphanumeric
                        ],
                        enableInteractiveSelection: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Vehicle Number',
                          prefixIcon: const Icon(Icons.confirmation_number_outlined),
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
                            return 'Please enter your vehicle number';
                          }
                          // Validate alphanumeric only
                          if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                            return 'Vehicle number must contain only letters and numbers';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Account Details Section
                      Text(
                        'Bank Account Details',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Account Holder Name
                      TextFormField(
                        controller: _accountHolderNameController,
                        enableInteractiveSelection: true,
                        enableSuggestions: true,
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: 'Account Holder Name',
                          prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account holder name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Bank Name
                      TextFormField(
                        controller: _bankNameController,
                        enableInteractiveSelection: true,
                        enableSuggestions: true,
                        autocorrect: true,
                        decoration: InputDecoration(
                          labelText: 'Bank Name',
                          prefixIcon: const Icon(Icons.account_balance_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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
                        enableInteractiveSelection: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Account Number',
                          prefixIcon: const Icon(Icons.credit_card_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account number';
                          }
                          if (value.length < 9) {
                            return 'Account number must be at least 9 digits';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // IFSC Code
                      TextFormField(
                        controller: _ifscCodeController,
                        enableInteractiveSelection: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: 'IFSC Code',
                          prefixIcon: const Icon(Icons.qr_code_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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
                      
                      const SizedBox(height: 12),
                      
                      // Document Upload Section
                      Text(
                        'Upload Documents',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Aadhar Photo Upload
                      _buildFileUploadField(
                        'Aadhar Card Photo',
                        _aadharPhotoPath,
                        (path) => setState(() => _aadharPhotoPath = path),
                        Icons.credit_card,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // License Photo Upload
                      _buildFileUploadField(
                        'Driving License Photo',
                        _licencePhotoPath,
                        (path) => setState(() => _licencePhotoPath = path),
                        Icons.card_membership,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // RC Photo Upload
                      _buildFileUploadField(
                        'RC (Registration Certificate) Photo',
                        _rcPhotoPath,
                        (path) => setState(() => _rcPhotoPath = path),
                        Icons.description,
                      ),
                      
                      const SizedBox(height: 12),
                      
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
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        enableInteractiveSelection: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Signup Button
                      AppButton(
                        text: 'Create Account',
                        onPressed: _isLoading ? null : _handleSignup,
                        isLoading: _isLoading,
                        variant: AppButtonVariant.primary,
                        isFullWidth: true,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Login Link
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.roboto(
                              color: Colors.grey[600],
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign In',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadField(String label, String? filePath, Function(String) onFileSelected, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _selectFile(label, onFileSelected),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (filePath != null)
                          ? (filePath.split('\\').last.split('/').last)
                          : 'Tap to select file',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: filePath != null ? AppTheme.primaryBlue : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.upload_file,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectFile(String label, Function(String) onFileSelected) async {
    try {
      print('🔍 Starting file picker for: $label');
      
      // Show options dialog
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Select $label'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, 'gallery'),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () => Navigator.pop(context, 'camera'),
              ),
            ],
          ),
        ),
      );

      if (result == null) {
        print('🔍 User cancelled selection');
        return;
      }

      String? filePath;
      
      if (result == 'gallery') {
        // Use file picker for gallery
        FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        
        if (pickerResult != null && pickerResult.files.single.path != null) {
          filePath = pickerResult.files.single.path!;
        }
      } else if (result == 'camera') {
        // Use image picker for camera
        try {
          final ImagePicker picker = ImagePicker();
          final XFile? photo = await picker.pickImage(source: ImageSource.camera);
          if (photo != null) {
            filePath = photo.path;
          }
        } catch (e) {
          print('🔍 Camera error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Camera not available: $e'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      print('🔍 File picker result: ${filePath != null ? 'SUCCESS' : 'CANCELLED'}');
      
      if (filePath != null) {
        print('🔍 Selected file path: $filePath');
        print('🔍 File exists: ${File(filePath).existsSync()}');
        print('🔍 File size: ${File(filePath).lengthSync()} bytes');
        
        onFileSelected(filePath);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label selected'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      } else {
        print('🔍 No file selected or path is null');
      }
    } catch (e) {
      print('🔍 File picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Future<String?> _uploadPhotoIfAny(String? filePath, String photoType) async {
    try {
      if (filePath == null) return null;
      final uri = Uri.parse('${DatabaseConfig.accidentBaseUrl}/upload_photo.php');
      final request = http.MultipartRequest('POST', uri);
      // driver_id unknown before signup; use 0, server will still save and later profile update can fix.
      request.fields['driver_id'] = '0';
      request.fields['photo_type'] = photoType;
      request.files.add(await http.MultipartFile.fromPath('photo', filePath));
      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data['success'] == true) {
          return data['data']['filename'];
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _encodePhotoAsBase64(String? filePath) async {
    try {
      print('🔍 Encoding photo: $filePath');
      if (filePath == null) {
        print('🔍 File path is null, returning null');
        return null;
      }
      
      final file = File(filePath);
      if (!file.existsSync()) {
        print('🔍 File does not exist: $filePath');
        return null;
      }
      
      final bytes = await file.readAsBytes();
      print('🔍 File size: ${bytes.length} bytes');
      
      if (bytes.isEmpty) {
        print('🔍 File is empty');
        return null;
      }
      
      final mime = filePath.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
      final b64 = base64Encode(bytes);
      final result = 'data:$mime;base64,$b64';
      
      print('🔍 Base64 length: ${b64.length}');
      print('🔍 MIME type: $mime');
      print('🔍 Result preview: ${result.substring(0, 50)}...');
      
      return result;
  } catch (e) {
    print('🔍 Error encoding photo: $e');
    return null;
  }
}
