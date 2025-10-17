import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/common/app_error_dialog.dart';
import 'login_screen.dart';

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
                // App Settings - Only useful settings that actually work
                _buildSettingsSection(
                  'App Settings',
                  Icons.settings,
                  [
                    // _buildSwitchTile(
                    //   'Push Notifications',
                    //   'Receive notifications for new trips and updates',
                    //   Icons.notifications,
                    //   settingsProvider.pushNotificationsEnabled,
                    //   (value) async {
                    //     await settingsProvider.updatePushNotifications(value);
                    //   },
                    // ), // Hidden push notifications toggle
                    _buildSwitchTile(
                      'Location Services',
                      'Allow app to access your location',
                      Icons.location_on,
                      settingsProvider.locationServicesEnabled,
                      (value) async {
                        await settingsProvider.updateLocationServices(value);
                        if (mounted && !value) {
                          // Show popup when location services are turned off
                          _showLocationPermissionDialog();
                        }
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Privacy & Security - Only useful settings
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
                    _buildActionTile(
                      'Logout',
                      'Sign out of your account',
                      Icons.logout,
                      Colors.red,
                      () => _logout(),
                    ),
                  ],
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
            Icon(icon, color: AppTheme.primaryBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTheme.heading3.copyWith(color: AppTheme.primaryBlue),
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

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title, style: AppTheme.bodyLarge),
      subtitle: Text(subtitle, style: AppTheme.bodySmall),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryBlue,
      ),
    );
  }


  Widget _buildSettingTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title, style: AppTheme.bodyLarge),
      subtitle: Text(subtitle, style: AppTheme.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: AppTheme.bodyLarge),
      subtitle: Text(subtitle, style: AppTheme.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog() {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                enableInteractiveSelection: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                enableInteractiveSelection: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                enableInteractiveSelection: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                
                final success = await authProvider.changePassword(
                  currentPassword: _currentPasswordController.text,
                  newPassword: _newPasswordController.text,
                );
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                } else if (mounted) {
                  AppErrorDialog.show(context, authProvider.errorMessage ?? 'Password change failed');
                }
              }
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(
              Icons.location_off,
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Location Services',
              style: AppTheme.heading3.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Please do not turn off the location permission',
          style: AppTheme.bodyMedium.copyWith(
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              // Automatically turn ON location permission
              final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
              await settingsProvider.updateLocationServices(true);
            },
            child: Text(
              'OK',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
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
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
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