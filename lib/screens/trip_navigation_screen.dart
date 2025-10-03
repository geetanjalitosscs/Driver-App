import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/trip_provider.dart';
import '../providers/accident_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../models/trip.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../config/maps_config.dart';

class TripNavigationScreen extends StatefulWidget {
  final Trip trip;

  const TripNavigationScreen({
    super.key,
    required this.trip,
  });

  @override
  State<TripNavigationScreen> createState() => _TripNavigationScreenState();
}

class _TripNavigationScreenState extends State<TripNavigationScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  
  LatLng? _currentLocation;
  LatLng? _startLocation;
  LatLng? _endLocation;
  
  bool _isNavigating = false;
  bool _isLoading = true;
  String? _errorMessage;
  
  Timer? _locationUpdateTimer;
  Timer? _tripTimer;
  
  Duration _tripDuration = Duration.zero;
  double _tripDistance = 0.0;
  
  String _currentStep = 'Starting trip...';
  String _nextStep = '';

  @override
  void initState() {
    super.initState();
    _initializeTrip();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    _tripTimer?.cancel();
    CentralizedApiService.stopTracking();
    super.dispose();
  }

  Future<void> _initializeTrip() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('=== TRIP INITIALIZATION DEBUG ===');
      print('Trip ID: ${widget.trip.historyId}');
      print('Trip location: ${widget.trip.location}');
      print('Trip endLatitude: ${widget.trip.endLatitude}');
      print('Trip endLongitude: ${widget.trip.endLongitude}');
      print('Trip clientName: ${widget.trip.clientName}');
      print('Trip amount: ${widget.trip.amount}');

      // Get current location
      final currentPos = await CentralizedApiService.getCurrentLocation();
      if (currentPos != null) {
        _currentLocation = LatLng(currentPos.latitude, currentPos.longitude);
        _startLocation = _currentLocation;
        print('Current location: ${currentPos.latitude}, ${currentPos.longitude}');
      } else {
        print('Failed to get current location');
      }

      // Parse end location from trip
      _endLocation = await _parseLocationFromString(widget.trip.location);
      
      if (_endLocation == null) {
        // Final fallback: use a default location if all parsing fails
        print('All location parsing failed, using default location');
        _endLocation = const LatLng(22.7196, 75.8577); // Default to Indore, MP
      }

      print('End location: ${_endLocation?.latitude}, ${_endLocation?.longitude}');
      print('=== TRIP INITIALIZATION DEBUG END ===');

      // Get route from start to end
      await _getRoute();

      // Start location tracking
      await _startLocationTracking();

      // Start trip timer
      _startTripTimer();

      // Automatically start navigation since we don't have a separate button
      await _startNavigation();

      setState(() {
        _isLoading = false;
      });

    } catch (e) {
      print('Trip initialization error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error initializing trip: $e';
      });
    }
  }

  Future<LatLng?> _parseLocationFromString(String locationString) async {
    try {
      // First, check if the trip has direct coordinate fields
      if (widget.trip.endLatitude != null && widget.trip.endLongitude != null) {
        print('Using direct coordinates: ${widget.trip.endLatitude}, ${widget.trip.endLongitude}');
        return LatLng(widget.trip.endLatitude!, widget.trip.endLongitude!);
      }
      
      // Try to extract coordinates from location string
      final parts = locationString.split(',');
      double? lat, lng;
      
      for (final part in parts) {
        final trimmed = part.trim();
        if (trimmed.startsWith('Lat:')) {
          lat = double.tryParse(trimmed.substring(4));
        } else if (trimmed.startsWith('Lng:')) {
          lng = double.tryParse(trimmed.substring(4));
        }
      }
      
      if (lat != null && lng != null) {
        print('Using parsed coordinates from string: $lat, $lng');
        return LatLng(lat, lng);
      }
      
      // Fallback: use geocoding service
      print('Using geocoding for location: $locationString');
      return await CentralizedApiService.geocodeAddress(locationString);
    } catch (e) {
      print('Error parsing location: $e');
      return null;
    }
  }

  Future<void> _getRoute() async {
    if (_startLocation == null || _endLocation == null) return;

    try {
      final route = await CentralizedApiService.getRoute(
        _startLocation!,
        _endLocation!,
      );

      if (route != null) {
        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: route.points,
              color: AppTheme.primaryBlue,
              width: 5,
            ),
          };
        });

        // Update next step
        if (route.steps.isNotEmpty) {
          _nextStep = route.steps.first.instructions;
        }
      }
    } catch (e) {
      print('Error getting route: $e');
    }
  }

  Future<void> _startLocationTracking() async {
    await CentralizedApiService.startTracking(
      onLocationUpdate: _onLocationUpdate,
      onError: _onLocationError,
    );
  }

  void _onLocationUpdate(Position position) {
    final newLocation = LatLng(position.latitude, position.longitude);
    
    setState(() {
      _currentLocation = newLocation;
      _updateMarkers();
    });

    // Update backend every 30 seconds or if moved > 50m
    _updateBackendLocation(newLocation);
  }

  void _onLocationError(String error) {
    setState(() {
      _errorMessage = 'Location error: $error';
    });
  }

  void _updateMarkers() {
    setState(() {
      _markers = {
        if (_currentLocation != null)
          Marker(
            markerId: const MarkerId('current'),
            position: _currentLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        if (_startLocation != null)
          Marker(
            markerId: const MarkerId('start'),
            position: _startLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: 'Start Location'),
          ),
        if (_endLocation != null)
          Marker(
            markerId: const MarkerId('end'),
            position: _endLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: 'Destination'),
          ),
      };
    });
  }

  void _updateBackendLocation(LatLng location) {
    // Update backend with current location
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    tripProvider.updateTripLocation(
      widget.trip.historyId,
      location.latitude,
      location.longitude,
    );
  }

  void _startTripTimer() {
    _tripTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _tripDuration = Duration(seconds: _tripDuration.inSeconds + 1);
      });
    });
  }

  Future<void> _startNavigation() async {
    setState(() {
      _isNavigating = true;
      _currentStep = 'Navigation started';
    });

    // Start real-time location updates
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_currentLocation != null) {
        _updateBackendLocation(_currentLocation!);
      }
    });

    // Update trip status to ongoing
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    await tripProvider.acceptTrip(widget.trip.historyId, widget.trip.driverId);
  }

  Future<void> _completeTrip() async {
    if (_currentLocation == null || _endLocation == null) {
      _showError('Unable to complete trip - location not available');
      return;
    }

    // DISABLED: Distance and time validation (as requested)
    // The validation logic is kept but commented out to preserve the code
    
    // Check minimum distance/time criteria
    // final distance = Geolocator.distanceBetween(
    //   _currentLocation!.latitude,
    //   _currentLocation!.longitude,
    //   _endLocation!.latitude,
    //   _endLocation!.longitude,
    // );

    // if (distance > MapsConfig.tripCompletionRadius) {
    //   _showError('You must be within ${MapsConfig.tripCompletionRadius}m of the destination to complete the trip');
    //   return;
    // }

    // if (_tripDuration.inMinutes < MapsConfig.minimumTripDuration) {
    //   _showError('Trip must be at least ${MapsConfig.minimumTripDuration} minutes long to complete');
    //   return;
    // }

    // Show completion dialog
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildCompletionDialog(),
    );

    if (result == true) {
      await _finalizeTrip();
    }
  }

  Widget _buildCompletionDialog() {
    return AlertDialog(
      title: Text(
        'Complete Trip',
        style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trip Duration: ${_formatDuration(_tripDuration)}'),
          Text('Distance Traveled: ${_tripDistance.toStringAsFixed(1)} km'),
          Text('Fare: ₹${widget.trip.amount}'),
          const SizedBox(height: 16),
          const Text('Are you sure you want to complete this trip?'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentGreen,
          ),
          child: const Text('Complete Trip'),
        ),
      ],
    );
  }

  Future<void> _finalizeTrip() async {
    // Show confirmation popup
    final confirmed = await _showCompletionConfirmation();
    
    if (!confirmed) {
      // User clicked "No" - just close popup, don't remove km validation
      return;
    }
    
    // User clicked "Yes" - proceed with completion
    try {
      // Get driver information
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final driverId = authProvider.currentUser?.driverIdAsInt ?? 1;
      
      // Complete the accident using the new API
      final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
      final success = await accidentProvider.completeAcceptedAccident(
        driverId: driverId,
        confirmed: true,
      );

          if (success) {
            // Add notification for trip completion
            final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
            notificationProvider.addTripCompletedNotification(
              location: widget.trip.location,
              amount: widget.trip.amount,
              tripId: widget.trip.historyId,
            );

            // Show system notification for trip completion
            await NotificationService.showTripCompletedNotification(
              tripId: widget.trip.historyId,
              vehicle: widget.trip.clientName, // Use clientName instead of vehicleNumber
              location: widget.trip.endLocation,
              earnings: widget.trip.amount,
            );

            Navigator.of(context).pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Trip completed successfully! Fare: ₹${widget.trip.amount}'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            _showError('Failed to complete trip');
          }
    } catch (e) {
      _showError('Error completing trip: $e');
    }
  }

  Future<bool> _showCompletionConfirmation() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Complete Trip'),
          content: const Text('Are you sure this trip is completed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
      ),
    );
  }

  Future<void> _openInGoogleMaps() async {
    if (_endLocation == null) {
      _showError('Destination location not available');
      return;
    }

    try {
      // Create Google Maps navigation URL
      String url;
      if (_currentLocation != null) {
        // Use current location as origin
        url = 'https://www.google.com/maps/dir/?api=1&origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${_endLocation!.latitude},${_endLocation!.longitude}&travelmode=driving';
      } else {
        // Use destination only
        url = 'https://www.google.com/maps/dir/?api=1&destination=${_endLocation!.latitude},${_endLocation!.longitude}&travelmode=driving';
      }

      print('Opening Google Maps with URL: $url');

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        _showError('Could not open Google Maps');
      }
    } catch (e) {
      print('Error opening Google Maps: $e');
      _showError('Failed to open Google Maps: $e');
    }
  }


  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _buildMapWidget() {
    // Always show trip details view
    return _buildTripDetailsView();
  }

  Widget _buildTripDetailsView() {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 140, bottom: 120), // Increased top padding to prevent overlap
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.directions_car,
                size: 64,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 16),
              Text(
                'Trip Details',
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Trip #${widget.trip.historyId}',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Information',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTripDetailRow('Client', widget.trip.clientName ?? 'N/A'),
                  _buildTripDetailRow('Location', widget.trip.location.split(',')[0]), // Show only address part
                  _buildTripDetailRow('Fare', '₹${widget.trip.amount}'),
                  _buildTripDetailRow('Duration', _formatDuration(_tripDuration)),
                  _buildTripDetailRow('Distance', '${_tripDistance.toStringAsFixed(1)} km'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Open in Map Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openInGoogleMaps,
                  icon: const Icon(Icons.map, color: Colors.white),
                  label: Text(
                    'Open in Google Maps',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                color: Colors.grey[800],
              ),
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
      body: Stack(
        children: [
          // Map - Platform specific handling
          if (!_isLoading && _currentLocation != null)
            _buildMapWidget(),
          
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          
          // Error overlay
          if (_errorMessage != null)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.red[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _initializeTrip,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          
           // Top controls
           Positioned(
             top: MediaQuery.of(context).padding.top + 8,
             left: 16,
             right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        color: AppTheme.primaryBlue,
                      ),
                      Expanded(
                        child: Text(
                          'Trip #${widget.trip.historyId}',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _initializeTrip,
                        icon: const Icon(Icons.refresh),
                        color: AppTheme.primaryBlue,
                        tooltip: 'Reload',
                      ),
                      Text(
                        '₹${widget.trip.amount}',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
           // Bottom controls
           Positioned(
             bottom: MediaQuery.of(context).padding.bottom + 8,
             left: 16,
             right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Complete Trip Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _completeTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Complete Trip',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (_nextStep.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.navigation,
                            color: AppTheme.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _nextStep,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
