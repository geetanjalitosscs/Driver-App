import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trip_provider.dart';
import '../models/trip.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class TripCompletionDialog extends StatefulWidget {
  final Trip trip;

  const TripCompletionDialog({
    super.key,
    required this.trip,
  });

  @override
  State<TripCompletionDialog> createState() => _TripCompletionDialogState();
}

class _TripCompletionDialogState extends State<TripCompletionDialog> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _endLocation;
  double? _endLatitude;
  double? _endLongitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final location = await CentralizedApiService.getCurrentLocationDetailed();
      if (location != null) {
        _endLatitude = location['latitude'];
        _endLongitude = location['longitude'];
        
        // Get address from coordinates
        _endLocation = location['address'] ?? 'Unknown Location';
      } else {
        _errorMessage = 'Unable to get current location';
      }
    } catch (e) {
      _errorMessage = 'Error getting location: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _completeTrip() async {
    if (_endLocation == null || _endLatitude == null || _endLongitude == null) {
      setState(() {
        _errorMessage = 'Please ensure location is captured';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      
      final result = await tripProvider.completeTrip(
        tripId: widget.trip.historyId,
        driverId: widget.trip.driverId,
        endLatitude: _endLatitude!,
        endLongitude: _endLongitude!,
        endLocation: _endLocation!,
      );

      if (result['success'] == true) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trip completed successfully! Fare: ₹${widget.trip.amount}'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to complete trip';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error completing trip: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: AppTheme.primaryBlue,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Complete Trip',
                    style: AppTextStyles.dialogTitle,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: AppTheme.neutralGreyLight,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Trip Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.neutralGrey50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.neutralGrey300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Details',
                    style: AppTextStyles.dialogSubtitle,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Location:', widget.trip.location),
                  _buildDetailRow('Client:', widget.trip.clientName),
                  _buildDetailRow('Fare:', '₹${widget.trip.amount}'),
                  if (widget.trip.startTime != null)
                    _buildDetailRow('Started:', _formatDateTime(widget.trip.startTime!)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Current Location
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _endLocation != null ? AppTheme.accentGreen50 : AppTheme.accentOrange50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _endLocation != null ? AppTheme.accentGreen300 : AppTheme.accentOrange300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _endLocation != null ? Icons.location_on : Icons.location_searching,
                        color: _endLocation != null ? AppTheme.accentGreen : AppTheme.accentOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'End Location',
                        style: AppTextStyles.dialogSubtitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_endLocation != null)
                    Text(
                      _endLocation!,
                      style: AppTextStyles.dialogSmall,
                    )
                  else
                    Text(
                      'Capturing location...',
                      style: AppTextStyles.dialogSmall,
                    ),
                ],
              ),
            ),

            // Error Message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentRed50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentRed300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppTheme.accentRed600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.errorText,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppTheme.neutralGrey400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.dialogBody,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading || _endLocation == null ? null : _completeTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Complete',
                            style: AppTextStyles.buttonText,
                          ),
                  ),
                ),
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: AppTextStyles.dialogCaption,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.dialogBody,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
