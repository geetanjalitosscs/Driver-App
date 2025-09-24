import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/emergency_simulation_dialog.dart';
import '../providers/profile_provider.dart';
import '../providers/emergency_provider.dart';
import '../providers/accident_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/earnings_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_picker_service.dart';
import '../widgets/api_accident_report_dialog.dart';
import '../widgets/trip_completion_dialog.dart';
import '../models/trip.dart';
import 'profile_screen.dart';
import 'accident_list_screen.dart';
import 'trip_navigation_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnDuty = false;
  final String _nextShift = 'Tomorrow, 07:00 AM';
  
  // Location variables
  double? _currentLatitude;
  double? _currentLongitude;
  String _currentAddress = 'Getting location...';
  bool _isLoadingLocation = true;
  
  // Detailed address variables
  String _currentStreet = '';
  String _currentCity = '';
  String _currentState = '';
  String _currentCountry = '';
  String _currentPostalCode = '';
  String _currentFormattedAddress = '';
  
  // Timer for refreshing accident count
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startRefreshTimer();
    _loadInitialAccidentCount();
    _loadOngoingTrips();
    _loadStatisticsData();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startRefreshTimer() {
    // Refresh accident count every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
        accidentProvider.refreshPendingCount();
      }
    });
  }

  void _loadInitialAccidentCount() {
    // Load accident count immediately when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
        accidentProvider.refreshPendingCount();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoadingLocation = true;
      });

      final locationData = await LocationPickerService.getCurrentLocation();
      
      if (locationData != null) {
        setState(() {
          _currentLatitude = locationData['latitude'];
          _currentLongitude = locationData['longitude'];
          _currentAddress = locationData['address'] ?? 'Unknown Location';
          
          // Store detailed address information
          _currentStreet = locationData['street'] ?? '';
          _currentCity = locationData['city'] ?? '';
          _currentState = locationData['state'] ?? '';
          _currentCountry = locationData['country'] ?? '';
          _currentPostalCode = locationData['postalCode'] ?? '';
          _currentFormattedAddress = locationData['formattedAddress'] ?? _currentAddress;
          
          _isLoadingLocation = false;
        });
      } else {
        setState(() {
          _currentAddress = 'Location unavailable';
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _currentAddress = 'Location unavailable';
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _refreshLocation() async {
    await _getCurrentLocation();
  }

  Future<void> _loadOngoingTrips() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    
    if (profileProvider.profile.driverId.isNotEmpty) {
      await tripProvider.loadOngoingTrips(int.parse(profileProvider.profile.driverId));
    }
  }

  Future<void> _loadStatisticsData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final earningsProvider = Provider.of<EarningsProvider>(context, listen: false);
    
    if (profileProvider.profile.driverId.isNotEmpty) {
      final driverId = int.parse(profileProvider.profile.driverId);
      
      // Load completed trips for today
      await tripProvider.loadCompletedTrips(driverId);
      
      // Load today's earnings
      await earningsProvider.loadDriverEarnings(driverId, 'today');
    }
  }

  Future<void> _navigateToTrip(trip) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TripNavigationScreen(trip: trip),
      ),
    );
  }

  Future<void> _showTripCompletionDialog(trip) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TripCompletionDialog(trip: trip),
    );
    
    if (result == true) {
      // Trip completed successfully, refresh ongoing trips
      await _loadOngoingTrips();
    }
  }

  void _showAccidentReports() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ApiAccidentReportDialog(
          currentLat: _currentLatitude,
          currentLng: _currentLongitude,
        );
      },
    );
  }


  void _showSimulationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const EmergencySimulationDialog();
      },
    );
  }

  Future<void> _handleAcceptEmergency() async {
    final emergencyProvider = Provider.of<EmergencyProvider>(context, listen: false);
    final emergency = emergencyProvider.currentEmergency;
    
    if (emergency != null) {
      emergencyProvider.acceptEmergency();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ambulance is coming!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Open Google Maps for navigation
      try {
        // Debug: Print emergency details
        print("=== EMERGENCY NAVIGATION DEBUG ===");
        print("Emergency location: ${emergency.location}");
        print("Emergency coordinates: ${emergency.latitude}, ${emergency.longitude}");
        
        // Validate emergency coordinates
        if (emergency.latitude == null || emergency.longitude == null) {
          throw Exception('Invalid emergency location coordinates');
        }
        
        // Use destination-only navigation to avoid confusion with current location
        final googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=${emergency.latitude},${emergency.longitude}&travelmode=driving';
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl));
        } else {
          throw Exception('Could not launch Google Maps');
        }
        
        print("Navigation opened successfully to: ${emergency.location}");
        print("=== EMERGENCY NAVIGATION DEBUG END ===");
      } catch (e) {
        print("Navigation error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open navigation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleDeclineEmergency() {
    final emergencyProvider = Provider.of<EmergencyProvider>(context, listen: false);
    emergencyProvider.declineEmergency();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ambulance is not coming'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleCancelDecision() {
    final emergencyProvider = Provider.of<EmergencyProvider>(context, listen: false);
    emergencyProvider.cancelDecision();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Decision cancelled. You can choose again.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyProvider>(
      builder: (context, emergencyProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Profile and Online Status
                  _buildHeader(),
                  const SizedBox(height: 16),
                  
                  // Current Status Card
                  _buildCurrentStatusCard(),
                  const SizedBox(height: 16),
                  
                  // Action Buttons (only when online)
                  if (_isOnDuty) _buildActionButtons(),
                  if (_isOnDuty) const SizedBox(height: 16),
                  
                  // Ongoing Trips Section
                  _buildOngoingTripsSection(),
                  
                  // Emergency Request Card (dynamic)
                  if (emergencyProvider.hasActiveEmergency)
                    _buildDynamicEmergencyCard(emergencyProvider.currentEmergency!),
                  if (emergencyProvider.hasActiveEmergency) const SizedBox(height: 16),
                  
                  // Statistics Cards
                  _buildStatisticsCards(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;
        
        return AppCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 28,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello Driver!',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.neutralGreyLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.driverName,
                      style: AppTheme.heading3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // Online/Offline Toggle
                  AnimatedContainer(
                    duration: AppAnimations.shortDuration,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isOnDuty ? AppTheme.accentGreen : AppTheme.accentRed,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (_isOnDuty ? AppTheme.accentGreen : AppTheme.accentRed).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isOnDuty ? 'Online' : 'Offline',
                          style: AppTheme.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Settings Icon
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.settings,
                          color: AppTheme.primaryBlue,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentStatusCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Driver Status',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Go Online',
                  icon: Icons.play_circle_fill,
                  variant: _isOnDuty ? AppButtonVariant.secondary : AppButtonVariant.outline,
                  onPressed: () {
                    setState(() {
                      _isOnDuty = true;
                    });
                    // Refresh accident count when going online
                    final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
                    accidentProvider.refreshPendingCount();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: 'Go Offline',
                  icon: Icons.pause_circle_filled,
                  variant: !_isOnDuty ? AppButtonVariant.danger : AppButtonVariant.outline,
                  onPressed: () {
                    setState(() {
                      _isOnDuty = false;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryBlue.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.neutralGreyLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_isLoadingLocation)
                        Row(
                          children: [
                            AppLoadingIndicator(
                              size: AppLoadingSize.small,
                              color: AppTheme.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Getting location...',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.neutralGreyLight,
                  ),
                ),
              ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main address display
                            Text(
                              _currentAddress,
                              style: AppTheme.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            
                            // Detailed address breakdown if available
                            if (_currentStreet.isNotEmpty || _currentCity.isNotEmpty || _currentState.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              if (_currentStreet.isNotEmpty)
                                Text(
                                  '📍 $_currentStreet',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.primaryBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              if (_currentCity.isNotEmpty && _currentState.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  '🏙️ $_currentCity, $_currentState',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.accentGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ] else if (_currentCity.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  '🏙️ $_currentCity',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.accentGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              if (_currentCountry.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  '🌍 $_currentCountry',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.accentOrange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
                  if (!_isLoadingLocation)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _refreshLocation,
      child: Container(
                          padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.refresh,
                            color: AppTheme.primaryBlue,
                            size: 18,
                          ),
                        ),
              ),
            ),
          ],
        ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Consumer<AccidentProvider>(
            builder: (context, accidentProvider, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  String buttonText;
                  if (constraints.maxWidth < 300) {
                    buttonText = 'Reports (${accidentProvider.pendingCount})';
                  } else if (constraints.maxWidth < 400) {
                    buttonText = 'Accident Reports (${accidentProvider.pendingCount})';
                  } else {
                    buttonText = 'View Accident Reports (${accidentProvider.pendingCount})';
                  }
                  
                  return AppButton(
                    text: buttonText,
                    icon: Icons.report_problem,
                    variant: AppButtonVariant.danger,
                    size: AppButtonSize.large,
                    isFullWidth: true,
                    onPressed: () {
                      _showAccidentReports();
                      // Refresh count in background
                      accidentProvider.refreshPendingCount();
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
          // View All Reports button
          AppButton(
            text: 'View All Reports',
            icon: Icons.list_alt,
            variant: AppButtonVariant.outline,
            size: AppButtonSize.medium,
            isFullWidth: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccidentListScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicEmergencyCard(emergency) {
    return Consumer<EmergencyProvider>(
      builder: (context, emergencyProvider, child) {
        // Determine card color and status based on state
        Color statusColor = AppTheme.accentRed;
        String statusText = 'EMERGENCY REQUEST';
        
        if (emergencyProvider.isAccepted) {
          statusColor = AppTheme.accentGreen;
          statusText = 'ACCEPTED';
        } else if (emergencyProvider.isDeclined) {
          statusColor = AppTheme.accentOrange;
          statusText = 'DECLINED';
        }
        
        return StatusCard(
          statusColor: statusColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        emergencyProvider.isAccepted ? Icons.check_circle : 
                        emergencyProvider.isDeclined ? Icons.cancel : Icons.local_hospital,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        statusText,
                      style: AppTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (!emergencyProvider.isAccepted && !emergencyProvider.isDeclined) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            emergencyProvider.formattedTimer,
                          style: AppTheme.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 350) {
                    // Stack vertically for very small screens
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Details',
                          style: AppTheme.heading3,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow('Patient', '${emergency.patientName} (${emergency.patientAge} years)'),
                        _buildDetailRow('Location', emergency.location),
                        _buildDetailRow('Description', emergency.description),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.accentGreen.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: AppTheme.accentGreen,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Avg Response',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppTheme.neutralGreyLight,
                                    ),
                                  ),
                                  Text(
                                    '4.5 min',
                                    style: AppTheme.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.accentGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Use horizontal layout for larger screens
                    return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Details',
                                style: AppTheme.heading3,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow('Patient', '${emergency.patientName} (${emergency.patientAge} years)'),
                          _buildDetailRow('Location', emergency.location),
                          _buildDetailRow('Description', emergency.description),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.accentGreen.withOpacity(0.3),
                            ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.timer,
                                color: AppTheme.accentGreen,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Avg Response',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.neutralGreyLight,
                            ),
                          ),
                          Text(
                            '4.5 min',
                                style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                    );
                  }
                },
                ),
                const SizedBox(height: 20),
                
                // Show different buttons based on state
                if (!emergencyProvider.isAccepted && !emergencyProvider.isDeclined) ...[
                  // Pending state - show Accept/Decline buttons
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 300) {
                      // Stack vertically for very small screens
                      return Column(
                        children: [
                          AppButton(
                            text: 'Accept',
                            icon: Icons.check_circle,
                            variant: AppButtonVariant.secondary,
                            isFullWidth: true,
                            onPressed: _handleAcceptEmergency,
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            text: 'Decline',
                            icon: Icons.cancel,
                            variant: AppButtonVariant.outline,
                            isFullWidth: true,
                            onPressed: _handleDeclineEmergency,
                          ),
                        ],
                      );
                    } else {
                      // Use horizontal layout for larger screens
                      return Row(
                    children: [
                      Expanded(
                            child: AppButton(
                              text: 'Accept',
                              icon: Icons.check_circle,
                              variant: AppButtonVariant.secondary,
                              onPressed: _handleAcceptEmergency,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                            child: AppButton(
                              text: 'Decline',
                              icon: Icons.cancel,
                              variant: AppButtonVariant.outline,
                              onPressed: _handleDeclineEmergency,
                        ),
                      ),
                    ],
                      );
                    }
                  },
                  ),
                ] else ...[
                  // Accepted or Declined state - show Cancel button
                AppButton(
                  text: 'Cancel Decision',
                  icon: Icons.undo,
                  variant: AppButtonVariant.ghost,
                  isFullWidth: true,
                  onPressed: _handleCancelDecision,
                  ),
                ],
              ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.neutralGreyLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer2<TripProvider, EarningsProvider>(
        builder: (context, tripProvider, earningsProvider, child) {
          // Get today's completed trips count
          final todayTrips = _getTodayTripsCount(tripProvider.completedTrips);
          
          // Get today's earnings
          final todayEarnings = earningsProvider.totalEarnings ?? 0.0;
          
          return Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 400) {
                    // Stack vertically for small screens
                    return Column(
                      children: [
                        _buildStatCard(
                          'Today\'s Trips',
                          '$todayTrips',
                          Icons.directions_car,
                          AppTheme.primaryBlue,
                          _getTripsSubtitle(todayTrips),
                        ),
                        const SizedBox(height: 12),
                        _buildStatCard(
                          'Earnings',
                          '₹${todayEarnings.toStringAsFixed(2)}',
                          Icons.currency_rupee,
                          AppTheme.accentGreen,
                          _getEarningsSubtitle(todayEarnings),
                        ),
                      ],
                    );
                  } else {
                    // Use horizontal layout for larger screens
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Today\'s Trips',
                            '$todayTrips',
                            Icons.directions_car,
                            AppTheme.primaryBlue,
                            _getTripsSubtitle(todayTrips),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Earnings',
                            '₹${todayEarnings.toStringAsFixed(2)}',
                            Icons.currency_rupee,
                            AppTheme.accentGreen,
                            _getEarningsSubtitle(todayEarnings),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              InfoCard(
                icon: Icons.schedule,
                title: 'Next Shift',
                subtitle: _nextShift,
                iconColor: AppTheme.accentOrange,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOngoingTripsSection() {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        final ongoingTrips = tripProvider.ongoingTrips;
        
        if (ongoingTrips.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Ongoing Trips',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...ongoingTrips.map((trip) => _buildOngoingTripCard(trip)).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildOngoingTripCard(trip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_taxi,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trip #${trip.tripId}',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      Text(
                        'Fare: ₹${trip.fareAmount}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _navigateToTrip(trip),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Navigate',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    trip.startLocation,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    trip.endLocation,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (trip.startTime != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Started: ${_formatDateTime(trip.startTime!)}',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  int _getTodayTripsCount(List<Trip> completedTrips) {
    final today = DateTime.now();
    return completedTrips.where((trip) {
      return trip.endTime != null &&
             trip.endTime!.year == today.year &&
             trip.endTime!.month == today.month &&
             trip.endTime!.day == today.day;
    }).length;
  }

  String _getTripsSubtitle(int todayTrips) {
    if (todayTrips == 0) {
      return 'No trips today';
    } else if (todayTrips == 1) {
      return '1 trip completed';
    } else {
      return '$todayTrips trips completed';
    }
  }

  String _getEarningsSubtitle(double todayEarnings) {
    if (todayEarnings == 0) {
      return 'No earnings today';
    } else if (todayEarnings < 100) {
      return '₹${todayEarnings.toStringAsFixed(2)} earned';
    } else {
      return '₹${todayEarnings.toStringAsFixed(2)} earned';
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return AppCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Icon(
                Icons.trending_up,
                color: AppTheme.accentGreen,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTheme.heading2.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.neutralGreyLight,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.accentGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
