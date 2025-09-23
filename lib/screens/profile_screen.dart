import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../providers/profile_provider.dart';
import 'help_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  // Text controllers
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late TextEditingController _vehicleController;
  late TextEditingController _vehicleNumberController;
  
  // Vehicle type selection
  String _selectedVehicleType = 'Ambulance';
  final List<String> _vehicleTypes = [
    'Ambulance',
    'Emergency Vehicle',
    'Medical Transport',
    'Rescue Vehicle',
    'Mobile ICU',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _contactController = TextEditingController();
    _addressController = TextEditingController();
    _vehicleController = TextEditingController();
    _vehicleNumberController = TextEditingController();
    
    // Initialize controllers with current profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllers();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _vehicleController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final profile = profileProvider.profile;
    
    _nameController.text = profile.driverName;
    _contactController.text = profile.contact;
    _addressController.text = profile.address;
    _vehicleController.text = profile.vehicleType;
    _vehicleNumberController.text = profile.vehicleNumber;
    _selectedVehicleType = profile.vehicleType;
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final success = await profileProvider.updateProfileFields(
      driverName: _nameController.text,
      contact: _contactController.text,
      address: _addressController.text,
      vehicleType: _selectedVehicleType,
      vehicleNumber: _vehicleNumberController.text,
    );
    
    if (success) {
      setState(() {
        _isEditing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileProvider.error ?? 'Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;
        
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
            actions: [
              if (_isEditing) ...[
                TextButton(
                  onPressed: _toggleEdit,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: profileProvider.isLoading ? null : _saveChanges,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: profileProvider.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Save',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ] else
                TextButton(
                  onPressed: _toggleEdit,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Edit',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
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
                
                // Performance Card
                _buildPerformanceCard(profile),
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
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 60,
              color: AppTheme.primaryBlue,
            ),
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
              profile.driverName,
              style: AppTheme.heading2,
            ),
          const SizedBox(height: 8),
          Text(
            'Driver ID: ${profile.driverId}',
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
          Text(
            'Personal Information',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 16),
          if (_isEditing) ...[
            _buildPhoneNumberField(),
            const SizedBox(height: 16),
            _buildEditableInfoRow(
              icon: Icons.location_on,
              label: 'Address',
              controller: _addressController,
            ),
          ] else ...[
            _buildInfoRow(
              icon: Icons.phone,
              text: 'Contact: +91 ${profile.contact}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.location_on,
              text: 'Address: ${profile.address}',
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
          if (_isEditing) ...[
            _buildVehicleTypeDropdown(),
            const SizedBox(height: 12),
            _buildEditableInfoRow(
              icon: Icons.confirmation_number,
              label: 'Vehicle Number',
              controller: _vehicleNumberController,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.star,
              text: 'Model Average Rating ${profile.averageRating}',
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.directions_car,
                    text: 'Type: ${profile.vehicleType}',
                  ),
                ),
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.confirmation_number,
                    text: 'Number: ${profile.vehicleNumber}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.star,
              text: 'Model Average Rating ${profile.averageRating}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(profile) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance',
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
                      icon: Icons.emoji_events,
                      text: 'Total Trips: ${profile.totalTrips}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Average Rating',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ),
                      );
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

  Widget _buildEditableInfoRow({
    required IconData icon,
    required String label,
    required TextEditingController controller,
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
          child: TextField(
            controller: controller,
            style: AppTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: label,
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                  ),
                );
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

  // Vehicle type dropdown
  Widget _buildVehicleTypeDropdown() {
    return Row(
      children: [
        Icon(
          Icons.directions_car,
          color: AppTheme.neutralGreyLight,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedVehicleType,
            decoration: InputDecoration(
              labelText: 'Vehicle Type',
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _vehicleTypes.map((String vehicleType) {
              return DropdownMenuItem<String>(
                value: vehicleType,
                child: Text(vehicleType),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedVehicleType = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
