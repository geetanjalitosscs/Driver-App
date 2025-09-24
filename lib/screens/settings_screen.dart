import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_button.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // Navigate back to previous screen
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
          'Settings',
          style: AppTheme.heading3.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Settings
                _buildSettingsSection(
                  'Profile Settings',
                  Icons.person,
                  [
                    _buildSettingTile(
                      'Driver Name',
                      settingsProvider.driverName,
                      Icons.badge,
                      () => _showEditDialog('Driver Name', settingsProvider.driverName, (value) {
                        settingsProvider.updateDriverName(value);
                      }),
                    ),
                    _buildSettingTile(
                      'Phone Number',
                      settingsProvider.phoneNumber,
                      Icons.phone,
                      () => _showEditDialog('Phone Number', settingsProvider.phoneNumber, (value) {
                        settingsProvider.updatePhoneNumber(value);
                      }),
                    ),
                    _buildSettingTile(
                      'Email Address',
                      settingsProvider.email,
                      Icons.email,
                      () => _showEditDialog('Email Address', settingsProvider.email, (value) {
                        settingsProvider.updateEmail(value);
                      }),
                    ),
                    _buildSettingTile(
                      'Vehicle Number',
                      settingsProvider.vehicleNumber,
                      Icons.directions_car,
                      () => _showEditDialog('Vehicle Number', settingsProvider.vehicleNumber, (value) {
                        settingsProvider.updateVehicleNumber(value);
                      }),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // App Settings
                _buildSettingsSection(
                  'App Settings',
                  Icons.settings,
                  [
                    _buildSwitchTile(
                      'Push Notifications',
                      'Receive notifications for new trips and updates',
                      Icons.notifications,
                      settingsProvider.pushNotificationsEnabled,
                      (value) => settingsProvider.updatePushNotifications(value),
                    ),
                    _buildSwitchTile(
                      'Location Services',
                      'Allow app to access your location',
                      Icons.location_on,
                      settingsProvider.locationServicesEnabled,
                      (value) => settingsProvider.updateLocationServices(value),
                    ),
                    _buildSwitchTile(
                      'Auto Accept Trips',
                      'Automatically accept nearby trips',
                      Icons.auto_awesome,
                      settingsProvider.autoAcceptTrips,
                      (value) => settingsProvider.updateAutoAcceptTrips(value),
                    ),
                    _buildSwitchTile(
                      'Dark Mode',
                      'Use dark theme for the app',
                      Icons.dark_mode,
                      settingsProvider.darkModeEnabled,
                      (value) => settingsProvider.updateDarkMode(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Trip Settings
                _buildSettingsSection(
                  'Trip Settings',
                  Icons.directions_car,
                  [
                    _buildSliderTile(
                      'Maximum Trip Distance',
                      '${settingsProvider.maxTripDistance.toInt()} km',
                      Icons.straighten,
                      settingsProvider.maxTripDistance,
                      5.0,
                      50.0,
                      (value) => settingsProvider.updateMaxTripDistance(value),
                    ),
                    _buildSliderTile(
                      'Minimum Fare Amount',
                      '₹${settingsProvider.minFareAmount.toInt()}',
                      Icons.currency_rupee,
                      settingsProvider.minFareAmount,
                      50.0,
                      500.0,
                      (value) => settingsProvider.updateMinFareAmount(value),
                    ),
                    _buildSwitchTile(
                      'GPS Tracking',
                      'Track location during trips',
                      Icons.gps_fixed,
                      settingsProvider.gpsTrackingEnabled,
                      (value) => settingsProvider.updateGpsTracking(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Privacy & Security
                _buildSettingsSection(
                  'Privacy & Security',
                  Icons.security,
                  [
                    _buildSettingTile(
                      'Change Password',
                      'Update your account password',
                      Icons.lock,
                      () => _showChangePasswordDialog(),
                    ),
                    _buildSettingTile(
                      'Privacy Policy',
                      'View our privacy policy',
                      Icons.privacy_tip,
                      () => _showPrivacyPolicy(),
                    ),
                    _buildSettingTile(
                      'Terms of Service',
                      'View terms and conditions',
                      Icons.description,
                      () => _showTermsOfService(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Account Actions
                _buildSettingsSection(
                  'Account Actions',
                  Icons.account_circle,
                  [
                    _buildActionTile(
                      'Export Data',
                      'Download your trip and earnings data',
                      Icons.download,
                      Colors.blue,
                      () => _exportData(),
                    ),
                    _buildActionTile(
                      'Clear Cache',
                      'Free up storage space',
                      Icons.cleaning_services,
                      Colors.orange,
                      () => _clearCache(),
                    ),
                    _buildActionTile(
                      'Logout',
                      'Sign out of your account',
                      Icons.logout,
                      Colors.red,
                      () => _logout(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // App Version
                Center(
                  child: Text(
                    'App Version: 1.0.0',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.neutralGreyLight,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTheme.heading3.copyWith(
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: AppTheme.bodySmall.copyWith(color: AppTheme.neutralGreyLight)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.neutralGrey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: AppTheme.bodySmall.copyWith(color: AppTheme.neutralGreyLight)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryBlue,
      ),
    );
  }

  Widget _buildSliderTile(String title, String value, IconData icon, double currentValue, double min, double max, Function(double) onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTheme.bodySmall.copyWith(color: AppTheme.neutralGreyLight)),
          Slider(
            value: currentValue,
            min: min,
            max: max,
            divisions: ((max - min) / 5).round(),
            onChanged: onChanged,
            activeColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: AppTheme.bodySmall.copyWith(color: AppTheme.neutralGreyLight)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.neutralGrey),
      onTap: onTap,
    );
  }

  void _showEditDialog(String fieldName, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $fieldName'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: fieldName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$fieldName updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'This app collects and uses your location data to provide trip services. '
            'Your personal information is protected and will not be shared with third parties '
            'without your consent. We use your data only to improve our services and provide '
            'better trip experiences.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using this app, you agree to our terms of service. You are responsible for '
            'providing accurate information and following all applicable laws and regulations. '
            'We reserve the right to modify these terms at any time.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export started. You will receive an email when ready.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data and free up storage space. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
