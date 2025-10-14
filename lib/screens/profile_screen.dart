import 'package:flutter/material.dart';
import '../widgets/common/app_error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../providers/auth_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/earnings_provider.dart';
import '../providers/wallet_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/account_details_dialog.dart';
import '../config/centered_api.dart';
import 'help_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  File? _profilePhoto;
  final ImagePicker _picker = ImagePicker();

  // Text controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
    
    // Initialize controllers with current profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllers();
      _loadProfilePhoto();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profile = authProvider.currentUser;
    
    if (profile != null) {
      _nameController.text = profile.driverName;
      _emailController.text = profile.email;
      _contactController.text = profile.contact;
      _addressController.text = profile.address;
    }
  }

  // Load profile photo from local storage
  Future<void> _loadProfilePhoto() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photoPath = prefs.getString('profile_photo_path');
      if (photoPath != null && photoPath.isNotEmpty) {
        final file = File(photoPath);
        if (await file.exists()) {
          setState(() {
            _profilePhoto = file;
          });
        }
      }
    } catch (e) {
      print('Error loading profile photo: $e');
    }
  }

  // Save profile photo to local storage
  Future<void> _saveProfilePhoto(String photoPath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_photo_path', photoPath);
    } catch (e) {
      print('Error saving profile photo: $e');
    }
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        final File imageFile = File(image.path);
        await _saveProfilePhoto(image.path);
        setState(() {
          _profilePhoto = imageFile;
        });
        
        if (mounted) {
          // Profile photo updated successfully - no SnackBar needed
          // Trigger home screen refresh by calling a static method
          HomeScreen.refreshProfilePhoto();
        }
      }
    } catch (e) {
      if (mounted) {
        AppErrorDialog.show(context, 'Error picking image: $e');
      }
    }
  }

  // Show image picker options
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              if (_profilePhoto != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removeProfilePhoto();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  // Remove profile photo
  Future<void> _removeProfilePhoto() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_photo_path');
      
      if (_profilePhoto != null && await _profilePhoto!.exists()) {
        await _profilePhoto!.delete();
      }
      
      setState(() {
        _profilePhoto = null;
      });
      
      if (mounted) {
        // Profile photo removed successfully - no SnackBar needed
        // Trigger home screen refresh by calling a static method
        HomeScreen.refreshProfilePhoto();
      }
    } catch (e) {
      if (mounted) {
        AppErrorDialog.show(context, 'Error removing photo: $e');
      }
    }
  }

  // Show full profile photo with cross button (like Aadhar card viewer)
  void _showFullProfilePhoto() {
    if (_profilePhoto == null) return;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.file(
                  _profilePhoto!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset controllers to current values when canceling
        _updateControllers();
      }
    });
  }

  // Phone number validation
  bool _isValidPhoneNumber(String phone) {
    // Remove any non-digit characters
    String digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length == 10;
  }

  Future<void> _saveChanges() async {
    // Validate phone number
    if (!_isValidPhoneNumber(_contactController.text)) {
      AppErrorDialog.show(context, 'Please enter a valid 10-digit phone number');
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentProfile = authProvider.currentUser;
    final success = await authProvider.updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _contactController.text,
      address: _addressController.text,
      vehicleType: currentProfile?.vehicleType ?? '', // Keep original values
      vehicleNumber: currentProfile?.vehicleNumber ?? '', // Keep original values
    );
    
    if (success) {
      setState(() {
        _isEditing = false;
      });
      
      if (mounted) {
        // Profile updated successfully - no SnackBar needed
      }
    } else {
      if (mounted) {
        AppErrorDialog.show(context, authProvider.errorMessage ?? 'Failed to update profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final profile = authProvider.currentUser;
        
        // If user is not authenticated, show loading or redirect
        if (profile == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryBlue,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
              padding: const EdgeInsets.all(16),
            ),
            title: Text(
              'My Profile',
              style: AppTheme.heading3.copyWith(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actionsIconTheme: const IconThemeData(
              size: 24,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(profile),
                const SizedBox(height: 24),
                
                // Personal Information Card
                _buildPersonalInfoCard(profile),
                const SizedBox(height: 16),
                
                // Vehicle Information Card
                _buildVehicleInfoCard(profile),
                const SizedBox(height: 16),
                
                // Account Details Card
                _buildAccountDetailsCard(),
                const SizedBox(height: 16),
                
                // Driver Photos Card
                _buildDriverPhotosCard(profile),
                const SizedBox(height: 16),
                
                // Help & Support Card
                _buildHelpSupportCard(),
                const SizedBox(height: 32),
                
                // Log Out Button
                _buildLogOutButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(profile) {
    return AppCard(
      child: Column(
        children: [
          Stack(
            children: [
              MouseRegion(
                cursor: _profilePhoto != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
                child: GestureDetector(
                  onTap: _profilePhoto != null ? _showFullProfilePhoto : null,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                    backgroundImage: _profilePhoto != null 
                        ? FileImage(_profilePhoto!) 
                        : null,
                    child: _profilePhoto == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: AppTheme.primaryBlue,
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditing)
            TextField(
              controller: _nameController,
              style: AppTheme.heading2,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.primaryBlueLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            )
          else
            Text(
              profile?.driverName ?? 'Unknown Driver',
              style: AppTheme.heading2,
            ),
          const SizedBox(height: 8),
          Text(
            'Driver ID: ${profile?.driverId ?? 'N/A'}',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.neutralGreyLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(profile) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Personal Information',
                  style: AppTheme.heading3,
                ),
              ),
              if (_isEditing) ...[
                TextButton(
                  onPressed: _toggleEdit,
                  child: Text(
                    'Cancel',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: Provider.of<AuthProvider>(context, listen: false).isLoading ? null : _saveChanges,
                  child: Provider.of<AuthProvider>(context, listen: false).isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                          ),
                        )
                      : Text(
                          'Save',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ] else
                TextButton(
                  onPressed: _toggleEdit,
                  child: Text(
                    'Edit',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditing) ...[
            // Full Name Field
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
            ),
            const SizedBox(height: 12),
            
            // Phone Number Field
            _buildPhoneNumberField(),
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
            ),
          ] else ...[
            _buildInfoRow(
              icon: Icons.person,
              text: 'Name: ${profile?.driverName ?? 'N/A'}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.email,
              text: 'Email: ${profile?.email ?? 'N/A'}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.phone,
              text: 'Contact: +91 ${profile?.contact ?? 'N/A'}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.location_on,
              text: 'Address: ${profile?.address ?? 'N/A'}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVehicleInfoCard(profile) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Information',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.directions_car,
                  text: 'Type: ${profile?.vehicleType ?? 'N/A'}',
                ),
              ),
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.confirmation_number,
                  text: 'Number: ${profile?.vehicleNumber ?? 'N/A'}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Account Details',
                  style: AppTheme.heading3,
                ),
              ),
              FutureBuilder<Map<String, dynamic>?>(
                future: _loadAccountDetails(),
                builder: (context, snapshot) {
                  final hasAccountDetails = snapshot.data != null;
                  return TextButton(
                    onPressed: () => _showAccountDetailsDialog(),
                    child: Text(
                      hasAccountDetails ? 'Edit' : 'Add',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<Map<String, dynamic>?>(
            future: _loadAccountDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final accountDetails = snapshot.data;
              final hasAccountDetails = accountDetails != null;

              if (hasAccountDetails) {
                return Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.account_balance,
                      text: 'Bank: ${accountDetails!['bank_name'] ?? 'N/A'}',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.confirmation_number,
                      text: 'Account: ${accountDetails['account_number'] != null && accountDetails['account_number'].toString().isNotEmpty 
                          ? '****${accountDetails['account_number'].toString().substring(accountDetails['account_number'].toString().length - 4)}'
                          : '****N/A'}',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.account_balance_wallet,
                      text: 'IFSC: ${accountDetails['ifsc_code'] ?? 'N/A'}',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.person,
                      text: 'Holder: ${accountDetails['account_holder_name'] ?? 'N/A'}',
                    ),
                  ],
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No account details added yet',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSupportCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help & Support',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      icon: Icons.help_outline,
                      text: 'Need assistance?',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get help with your account or app issues',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.neutralGreyLight,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to help screen using NavigationProvider and close current screen
                      final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
                      navigationProvider.navigateToHelp();
                      Navigator.of(context).pop(); // Close the profile screen
                    },
                    child: Text(
                      'Help & Support',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> _loadAccountDetails() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final driverId = authProvider.currentUser?.driverId;
      
      if (driverId == null) return null;

      final response = await http.get(
        Uri.parse('${DatabaseConfig.baseUrl}get_account_details.php?driver_id=$driverId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true && data['has_account_details']) {
          return data['account_details'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _showAccountDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) => const AccountDetailsDialog(),
    ).then((_) {
      // Refresh the account details section after dialog closes
      setState(() {});
    });
  }

  Widget _buildDriverPhotosCard(profile) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Driver Documents',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 16),
          
          // Aadhar Card Photo
          _buildPhotoRow(
            title: 'Aadhar Card',
            photoPath: profile?.aadharPhoto,
            driverId: profile?.driverId ?? 'N/A',
            type: 'aadhar',
            icon: Icons.credit_card,
          ),
          const SizedBox(height: 12),
          
          // Driving Licence Photo
          _buildPhotoRow(
            title: 'Driving Licence',
            photoPath: profile?.licencePhoto,
            driverId: profile?.driverId ?? 'N/A',
            type: 'licence',
            icon: Icons.card_membership,
          ),
          const SizedBox(height: 12),
          
          // RC Photo
          _buildPhotoRow(
            title: 'RC (Registration Certificate)',
            photoPath: profile?.rcPhoto,
            driverId: profile?.driverId ?? 'N/A',
            type: 'rc',
            icon: Icons.description,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoRow({
    required String title,
    required String photoPath,
    required String driverId,
    required String type,
    required IconData icon,
  }) {
    // Convert photo path to URL and validate
    String photoUrl = '';
    bool hasValidPhoto = false;
    
    if (photoPath.isNotEmpty && !photoPath.contains('default_')) {
      if (photoPath.startsWith('http')) {
        photoUrl = photoPath;
        hasValidPhoto = true;
      } else {
        photoUrl = 'https://tossconsultancyservices.com/apatkal/api/uploads/$photoPath';
        hasValidPhoto = true;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with icon
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _viewPhoto(driverId, type, title, photoUrl),
              icon: Icon(
                Icons.visibility,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
              tooltip: 'View Photo',
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Photo thumbnail below the title
        if (hasValidPhoto) ...[
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppTheme.backgroundLight,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.backgroundLight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Image not available',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ] else ...[
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.neutralGreyLight.withOpacity(0.3),
                width: 1,
              ),
              color: AppTheme.backgroundLight,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppTheme.neutralGreyLight,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No photo uploaded',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.neutralGreyLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _viewPhoto(String driverId, String type, String title, String photoUrl) {
    if (photoUrl.isEmpty) {
      // Show error dialog if no photo
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 64,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No photo available',
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Driver ID: $driverId',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.neutralGreyLight,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Show full screen photo viewer
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              right: 80, // Add right margin to prevent clashing with close button
              child: Text(
                title,
                style: AppTheme.heading3.copyWith(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.neutralGreyLight,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodyMedium,
          ),
        ),
      ],
    );
  }


  Widget _buildLogOutButton(BuildContext context) {
    return AppButton(
      text: 'Log Out',
      icon: Icons.logout,
      variant: AppButtonVariant.danger,
      size: AppButtonSize.large,
      isFullWidth: true,
      onPressed: () {
        _showLogOutDialog(context);
      },
    );
  }

  void _showLogOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Log Out',
            style: AppTheme.heading3,
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: AppTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.neutralGreyLight,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout logic here
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final tripProvider = Provider.of<TripProvider>(context, listen: false);
                final earningsProvider = Provider.of<EarningsProvider>(context, listen: false);
                final walletProvider = Provider.of<WalletProvider>(context, listen: false);
                
                // Clear all provider data
                tripProvider.clearAllData();
                earningsProvider.clearAllData();
                walletProvider.clearAllData();
                
                // Reset home screen online state
                HomeScreen.resetOnlineState();
                
                // Logout user
                authProvider.logout();
                
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
                // Logged out successfully - no SnackBar needed
              },
              child: Text(
                'Log Out',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.accentRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Phone number input field with validation
  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Icon(
          Icons.phone,
          color: AppTheme.neutralGreyLight,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _contactController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            style: AppTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Phone Number (10 digits)',
              prefixText: '+91 ',
              prefixStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.neutralGreyLight,
              ),
              labelStyle: AppTheme.bodySmall.copyWith(
                color: AppTheme.neutralGreyLight,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.neutralGreyLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              counterText: '', // Hide character counter
            ),
            onChanged: (value) {
              // Only allow digits and limit to 10 characters
              String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
              if (digitsOnly != value) {
                _contactController.value = TextEditingValue(
                  text: digitsOnly,
                  selection: TextSelection.collapsed(offset: digitsOnly.length),
                );
              }
            },
          ),
        ),
      ],
    );
  }

}
