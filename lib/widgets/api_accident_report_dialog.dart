import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accident_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/profile_provider.dart';
import '../models/accident_report.dart';
import '../models/accident_filter.dart';
import '../models/trip.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/accident_filter_widget.dart';
import '../screens/trip_navigation_screen.dart';
import '../theme/app_theme.dart';

class ApiAccidentReportDialog extends StatefulWidget {
  final double? currentLat;
  final double? currentLng;
  
  const ApiAccidentReportDialog({
    Key? key,
    this.currentLat,
    this.currentLng,
  }) : super(key: key);

  @override
  State<ApiAccidentReportDialog> createState() => _ApiAccidentReportDialogState();
}

class _ApiAccidentReportDialogState extends State<ApiAccidentReportDialog> {
  bool _isProcessing = false;
  Timer? _timer;
  int _countdown = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdown = 30;
    _timer?.cancel();
    print('Starting 30-second countdown timer for accident report');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });
        
        if (_countdown <= 0) {
          _timer?.cancel();
          print('Timer expired - auto-rejecting accident report');
          _autoReject();
        }
      }
    });
  }

  void _autoReject() async {
    if (!mounted) return;
    
    print('Auto-rejecting accident report...');
    final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
    final success = await accidentProvider.rejectCurrentAccident();
    
    if (success && mounted) {
      print('Auto-reject successful. Checking for more reports...');
      // Show next report automatically or close if no more reports
      if (accidentProvider.hasMoreAccidents) {
        print('More reports available - starting timer for next report');
        // Reset timer for next report
        _startTimer();
        // Refresh the dialog to show next report
        setState(() {});
      } else {
        print('No more reports - closing dialog');
        // No more reports, close dialog and return to home page
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccidentProvider>(
      builder: (context, accidentProvider, child) {
        if (!accidentProvider.hasCurrentAccident) {
          return _buildNoReportsDialog();
        }

        final accident = accidentProvider.currentAccident!;
        return _buildAccidentDialog(accident, accidentProvider);
      },
    );
  }

  Widget _buildNoReportsDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: AppTheme.accentGreen,
              ),
              const SizedBox(height: 16),
              Text(
                'No Accident Reports',
                style: AppTheme.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'There are currently no pending accident reports from the API.',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please check if accident reports are being submitted to the server.',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccidentDialog(AccidentReport accident, AccidentProvider provider) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          minWidth: 280,
        ),
        child: AppCard(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.report_problem,
                        color: AppTheme.accentOrange,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Accident Report #${accident.id}',
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Filter button
                      IconButton(
                        onPressed: _showFilterDialog,
                        icon: Icon(
                          Icons.filter_list,
                          color: provider.currentFilter.hasActiveFilters 
                              ? AppTheme.primaryBlue 
                              : Colors.grey,
                        ),
                        tooltip: 'Filter Reports',
                        iconSize: 20,
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        color: AppTheme.textSecondary,
                        iconSize: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Countdown Timer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _countdown <= 5 ? AppTheme.errorRed.withOpacity(0.1) : AppTheme.accentOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _countdown <= 5 ? AppTheme.errorRed : AppTheme.accentOrange,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          color: _countdown <= 5 ? AppTheme.errorRed : AppTheme.accentOrange,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Auto-reject in ${_countdown}s',
                          style: AppTheme.bodyMedium.copyWith(
                            color: _countdown <= 5 ? AppTheme.errorRed : AppTheme.accentOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Accident Details
                  _buildDetailRow('Name', accident.fullname),
                  _buildDetailRow('Phone', accident.phone),
                  _buildDetailRow('Vehicle', accident.vehicle),
                  _buildDetailRow('Location', accident.location),
                  _buildDetailRow('Date', accident.createdAt),
                  if (accident.description.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Description',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      accident.description,
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                  if (accident.photos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Photos',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: accident.photos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                accident.photos[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    color: AppTheme.backgroundLight,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: AppTheme.textSecondary,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  // Action Buttons
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 300;
                      final buttonSpacing = isSmallScreen ? 8.0 : 12.0;
                      return Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Reject',
                              onPressed: _isProcessing ? null : () => _handleReject(provider),
                              variant: AppButtonVariant.danger,
                              icon: Icons.close,
                              size: isSmallScreen ? AppButtonSize.small : AppButtonSize.medium,
                            ),
                          ),
                          SizedBox(width: buttonSpacing),
                          Expanded(
                            child: AppButton(
                              text: 'Accept',
                              onPressed: _isProcessing ? null : () => _handleAccept(provider),
                              variant: AppButtonVariant.secondary,
                              icon: Icons.check,
                              size: isSmallScreen ? AppButtonSize.small : AppButtonSize.medium,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAccept(AccidentProvider provider) async {
    // Cancel timer since user took action
    _timer?.cancel();
    
    setState(() {
      _isProcessing = true;
    });

    try {
      final success = await provider.acceptCurrentAccident(
        showNext: false,
        currentLat: widget.currentLat,
        currentLng: widget.currentLng,
      );
      
      if (success) {
        // Create a trip from the accepted accident report
        final trip = await _createTripFromAccident(provider.currentAccident!);
        
        // Close accident dialog
        Navigator.of(context).pop();
        
        // Navigate to trip navigation screen
        if (trip != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TripNavigationScreen(trip: trip),
            ),
          );
        }
        
        // Refresh the pending count in the background
        provider.refreshPendingCount();
      } else {
        _showErrorSnackBar('Failed to accept accident report');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<Trip?> _createTripFromAccident(AccidentReport accident) async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      
      if (profileProvider.profile.driverId.isNotEmpty) {
        final driverId = int.parse(profileProvider.profile.driverId);
        
        // Create a trip with the accident details
        final tripData = {
          'driver_id': driverId,
          'user_id': 1, // Default user ID for accident reports
          'start_location': accident.location,
          'end_location': accident.location, // Same location for accident response
          'fare_amount': 500.0, // Default fare for accident response
          'status': 'ongoing',
          'start_time': DateTime.now().toIso8601String(),
        };
        
        // Accept the trip (this will create it in the database)
        await tripProvider.acceptTrip(
          accident.id, // Use accident ID as trip ID for now
          driverId,
        );
        
        // Refresh ongoing trips
        await tripProvider.loadOngoingTrips(driverId);
        
        // Return the created trip
        final ongoingTrips = tripProvider.ongoingTrips;
        if (ongoingTrips.isNotEmpty) {
          return ongoingTrips.first;
        }
      }
      return null;
    } catch (e) {
      print('Error creating trip from accident: $e');
      return null;
    }
  }

  Future<void> _handleReject(AccidentProvider provider) async {
    // Cancel timer since user took action
    _timer?.cancel();
    
    setState(() {
      _isProcessing = true;
    });

    try {
      final success = await provider.rejectCurrentAccident();
      
      if (success) {
        // Show next report automatically or close if no more reports
        if (provider.hasMoreAccidents) {
          // Reset timer for next report
          _startTimer();
          // Refresh the dialog to show next report
          setState(() {});
        } else {
          // No more reports, close dialog and return to home page
          Navigator.of(context).pop();
        }
      } else {
        _showErrorSnackBar('Failed to reject accident report');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }


  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    final accidentProvider = Provider.of<AccidentProvider>(context, listen: false);
    final newFilter = await FilterBottomSheet.show(
      context,
      accidentProvider.currentFilter,
    );
    
    if (newFilter != null) {
      accidentProvider.applyFilter(newFilter);
      
      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newFilter.hasActiveFilters 
                ? 'Filters applied: ${newFilter.filterSummary}'
                : 'All filters cleared',
          ),
          backgroundColor: AppTheme.primaryBlue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
