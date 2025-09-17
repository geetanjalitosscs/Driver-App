import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accident_provider.dart';
import '../models/accident_report.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
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
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        color: AppTheme.textSecondary,
                        iconSize: 20,
                      ),
                    ],
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
        // Close dialog and return to home page immediately
        Navigator.of(context).pop();
        
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

  Future<void> _handleReject(AccidentProvider provider) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final success = await provider.rejectCurrentAccident();
      
      if (success) {
        // Show next report automatically or close if no more reports
        if (provider.hasMoreAccidents) {
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
}
