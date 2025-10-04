import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/emergency_simulation_dialog.dart';
import '../providers/auth_provider.dart';
import '../providers/emergency_provider.dart';
import '../providers/accident_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/earnings_provider.dart';
import '../providers/wallet_provider.dart';
import '../providers/notification_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/navigation_provider.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../widgets/trip_completion_dialog.dart';
import '../models/trip.dart';
import '../models/accident_report.dart';
import 'profile_screen.dart';
import 'accident_list_screen.dart';
import 'trip_navigation_screen.dart';
import 'settings_screen.dart';
import '../widgets/api_accident_report_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Static variable to persist state across widget recreations
  static bool _persistentIsOnDuty = false;
  static bool _hasLoadedPersistentState = false;
  
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
  
  // Flag to track if we've loaded the saved state
  bool _hasLoadedState = false;

  @override
  void initState() {
    super.initState();
    
    // Use persistent state if available, otherwise load from storage
    if (_hasLoadedPersistentState) {
      _isOnDuty = _persistentIsOnDuty;
    } else {
      _loadOnDutyStateSync(); // Load saved online/offline state synchronously
    }
    
    _getCurrentLocation();
    _startRefreshTimer();
    _loadInitialAccidentCount();
    
    // Load data after the build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadOngoingTrips();
        _loadStatisticsData();
      }
    });
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

  // Load saved online/offline state from storage synchronously
  void _loadOnDutyStateSync() {
    try {
      // Use SharedPreferences.getInstance() synchronously
      SharedPreferences.getInstance().then((prefs) {
        final savedState = prefs.getBool('is_on_duty') ?? false;
        
        // Update both persistent and local state
        _persistentIsOnDuty = savedState;
        _hasLoadedPersistentState = true;
        
        if (mounted) {
          setState(() {
            _isOnDuty = savedState;
            _hasLoadedState = true;
          });
        }
        
        print('Loaded online/offline state: $_isOnDuty');
      }).catchError((e) {
        print('Error loading online/offline state: $e');
        _hasLoadedPersistentState = true;
        if (mounted) {
          setState(() {
            _hasLoadedState = true;
          });
        }
      });
    } catch (e) {
      print('Error loading online/offline state: $e');
      _hasLoadedPersistentState = true;
      if (mounted) {
        setState(() {
          _hasLoadedState = true;
        });
      }
    }
  }

  // Save online/offline state to storage
  Future<void> _saveOnDutyState(bool isOnDuty) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_on_duty', isOnDuty);
      
      // Update persistent state
      _persistentIsOnDuty = isOnDuty;
      _hasLoadedPersistentState = true;
      
      print('Saved online/offline state: $isOnDuty');
    } catch (e) {
      print('Error saving online/offline state: $e');
    }
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
      if (mounted) {
        setState(() {
          _isLoadingLocation = true;
        });
      }

      final locationData = await CentralizedApiService.getCurrentLocationDetailed();
      
      if (locationData != null) {
        if (mounted) {
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
        }
      } else {
        if (mounted) {
          setState(() {
            _currentAddress = 'Location unavailable';
            _isLoadingLocation = false;
          });
        }
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        setState(() {
          _currentAddress = 'Location unavailable';
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _refreshLocation() async {
    await _getCurrentLocation();
  }

  Future<void> _loadOngoingTrips() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      final driverId = authProvider.currentUser!.driverIdAsInt;
      await tripProvider.loadOngoingTrips(driverId);
    }
  }

  Future<void> _loadStatisticsData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final earningsProvider = Provider.of<EarningsProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      final driverId = authProvider.currentUser!.driverIdAsInt;
      
      // Load completed trips for today
      await tripProvider.loadCompletedTrips(driverId);
      
      // Load today's earnings
      await earningsProvider.loadDriverEarnings(driverId, 'today');
    }
  }

  // Navigation methods
  void _navigateToTrips() {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.navigateToScreen(1); // Trips section index
  }

  void _navigateToEarnings() {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.navigateToScreen(2); // Earnings section index
  }

  // Refresh button method
  Future<void> _refreshData() async {
    await _loadStatisticsData();
    await _loadOngoingTrips();
  }

  // Refresh all data including reports
  Future<void> _refreshAllData() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Refresh all providers
      final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      final earningsProvider = Provider.of<EarningsProvider>(context, listen: false);
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Get driver ID safely - driverId is String in ProfileData
      int driverId = 1; // Default fallback
      try {
        final userData = authProvider.currentUser;
        if (userData != null && userData.driverId.isNotEmpty) {
          final parsed = int.tryParse(userData.driverId);
          if (parsed != null) {
            driverId = parsed;
          }
        }
      } catch (e) {
        print('Error getting driver ID: $e, using default: $driverId');
      }
      
      // Load critical data first (fast operations)
      await Future.wait([
        accidentProvider.loadAccidents(driverId: driverId),
        tripProvider.loadCompletedTrips(driverId),
      ]);

      // Load secondary data in background (non-blocking)
      Future.wait([
        earningsProvider.loadDriverEarnings(driverId, 'all'),
        walletProvider.loadWalletData(driverId),
        _loadStatisticsData(),
        _loadOngoingTrips(),
      ]).then((_) {
        // Refresh UI after secondary data loads
        if (mounted) {
          setState(() {
            // Trigger UI refresh
          });
        }
      });

      // Skip location refresh for faster loading
      // _refreshLocation() - commented out for speed

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data refreshed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                  
                  // Accepted Accident Display
                  Consumer<AccidentProvider>(
                    builder: (context, accidentProvider, child) {
                      // Only show accepted accident when user is online
                      if (_isOnDuty && accidentProvider.hasAcceptedAccident) {
                        return Column(
                          children: [
                            _buildAcceptedAccidentCard(accidentProvider.acceptedAccident!),
                            const SizedBox(height: 16),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  
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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final profile = authProvider.currentUser;
        
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
                      profile?.driverName ?? 'Driver',
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
            'Your Status',
            style: AppTheme.heading3,
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 300) {
                // Only for extremely small screens, stack buttons vertically
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Go Online',
                        icon: Icons.play_circle_fill,
                        variant: _isOnDuty ? AppButtonVariant.secondary : AppButtonVariant.outline,
                        size: AppButtonSize.small,
                        onPressed: () {
                          setState(() {
                            _isOnDuty = true;
                          });
                          _persistentIsOnDuty = true; // Update persistent state immediately
                          _hasLoadedPersistentState = true;
                          _saveOnDutyState(true); // Save state
                          // Refresh accident count when going online
                          final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
                          accidentProvider.refreshPendingCount();
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Go Offline',
                        icon: Icons.pause_circle_filled,
                        variant: !_isOnDuty ? AppButtonVariant.danger : AppButtonVariant.outline,
                        size: AppButtonSize.small,
                        onPressed: () {
                          setState(() {
                            _isOnDuty = false;
                          });
                          _persistentIsOnDuty = false; // Update persistent state immediately
                          _hasLoadedPersistentState = true;
                          _saveOnDutyState(false); // Save state
                        },
                      ),
                    ),
                  ],
                );
              } else {
                // For screens 300px and above, use horizontal layout with smaller buttons
                return Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Go Online',
                        icon: Icons.play_circle_fill,
                        variant: _isOnDuty ? AppButtonVariant.secondary : AppButtonVariant.outline,
                        size: constraints.maxWidth < 360 ? AppButtonSize.small : AppButtonSize.medium,
                        onPressed: () {
                          setState(() {
                            _isOnDuty = true;
                          });
                          _persistentIsOnDuty = true; // Update persistent state immediately
                          _hasLoadedPersistentState = true;
                          _saveOnDutyState(true); // Save state
                          // Refresh accident count when going online
                          final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
                          accidentProvider.refreshPendingCount();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton(
                        text: 'Go Offline',
                        icon: Icons.pause_circle_filled,
                        variant: !_isOnDuty ? AppButtonVariant.danger : AppButtonVariant.outline,
                        size: constraints.maxWidth < 360 ? AppButtonSize.small : AppButtonSize.medium,
                        onPressed: () {
                          setState(() {
                            _isOnDuty = false;
                          });
                          _persistentIsOnDuty = false; // Update persistent state immediately
                          _hasLoadedPersistentState = true;
                          _saveOnDutyState(false); // Save state
                        },
                      ),
                    ),
                  ],
                );
              }
            },
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
          const SizedBox(height: 12),
          // Refresh Data button
          AppButton(
            text: 'Refresh Data',
            icon: Icons.refresh,
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.medium,
            isFullWidth: true,
            onPressed: _refreshAllData,
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
          final todayEarnings = earningsProvider.todayEarnings;
          
          return Column(
            children: [
              // Statistics Cards - Always 2 per row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Today\'s Trips',
                      '$todayTrips',
                      Icons.directions_car,
                      AppTheme.primaryBlue,
                      _getTripsSubtitle(todayTrips),
                      onTap: () => _navigateToTrips(),
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
                      onTap: () => _navigateToEarnings(),
                    ),
                  ),
                ],
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
        
        // Only show ongoing trips when user is online
        if (!_isOnDuty || ongoingTrips.isEmpty) {
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
                        'Fare: ₹${trip.amount}',
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle, {VoidCallback? onTap}) {
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
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
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  Icon(
                    onTap != null ? Icons.arrow_forward_ios : Icons.trending_up,
                    color: onTap != null ? color : AppTheme.accentGreen,
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
        ),
      ),
    );
  }


  Widget _buildAcceptedAccidentCard(AccidentReport accident) {
    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accepted Accident Report',
                      style: AppTheme.heading3.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'Report #${accident.id}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.neutralGreyLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Accident Details
          _buildAccidentDetailRow('Location', accident.location),
          _buildAccidentDetailRow('Victim', accident.fullname),
          _buildAccidentDetailRow('Phone', accident.phone),
          _buildAccidentDetailRow('Vehicle', accident.vehicle),
          _buildAccidentDetailRow('Time', _formatDateTime(DateTime.parse(accident.createdAt))),
          
          if (accident.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildAccidentDetailRow('Description', accident.description),
          ],

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Continue',
                  icon: Icons.navigation,
                  variant: AppButtonVariant.primary,
                  size: AppButtonSize.small,
                  onPressed: () => _continueWithAccident(accident),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  text: 'Cancel',
                  icon: Icons.cancel,
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.small,
                  onPressed: () => _cancelAccident(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccidentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGreyDark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.neutralGreyDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _continueWithAccident(AccidentReport accident) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Create a trip from the accepted accident report
      final trip = await _createTripFromAccident(accident);
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      if (trip != null && mounted) {
        // Add notification for trip acceptance
        final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        notificationProvider.addTripAcceptedNotification(
          location: accident.location,
          accidentId: accident.id,
          amount: trip.amount,
        );

        // Navigate to trip navigation screen (this will show trip details, not open map)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripNavigationScreen(trip: trip),
          ),
        );
      } else {
        // Show error if trip creation failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create trip from accident report'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _cancelAccident() {
    final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
    accidentProvider.cancelAcceptedAccident();
  }

  Future<Trip?> _createTripFromAccident(AccidentReport accident) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.currentUser != null) {
        final driverId = authProvider.currentUser!.driverIdAsInt;
        
        // Create a Trip object with the accident details
        // Format location string to include coordinates for trip navigation
        final locationString = '${accident.location}, Lat: ${accident.latitude}, Lng: ${accident.longitude}';
        
        final trip = Trip(
          historyId: DateTime.now().millisecondsSinceEpoch, // Use timestamp as ID
          driverId: driverId,
          clientName: accident.fullname,
          location: locationString, // Include coordinates for parsing
          amount: 500.0, // Default fare for accident response
          duration: 0, // Will be updated when trip is completed
          startTime: DateTime.now(),
          endTime: null,
          createdAt: DateTime.now(),
          endLatitude: accident.latitude, // Add end coordinates
          endLongitude: accident.longitude,
        );

        return trip;
      }
      return null;
    } catch (e) {
      print('Error creating trip from accident: $e');
      return null;
    }
  }
}
