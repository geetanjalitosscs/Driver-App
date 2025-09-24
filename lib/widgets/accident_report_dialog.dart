import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/accident_provider.dart';
import '../models/accident_report.dart';

class AccidentReportDialog extends StatefulWidget {
  const AccidentReportDialog({super.key});

  @override
  State<AccidentReportDialog> createState() => _AccidentReportDialogState();
}

class _AccidentReportDialogState extends State<AccidentReportDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccidentProvider>(
      builder: (context, accidentProvider, child) {
        final accident = accidentProvider.currentAccident;
        
        if (accident == null) {
          return _buildNoAccidentsWidget();
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            constraints: const BoxConstraints(
              maxWidth: 400,
              minWidth: 300,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(accident),
                _buildContent(accident),
                _buildActions(accidentProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoAccidentsWidget() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green[600],
            ),
            const SizedBox(height: 16),
            Text(
              'No Pending Reports',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All accident reports have been processed.',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AccidentReport accident) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.car_crash,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accident Report',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: #${accident.id}',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.red[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AccidentReport accident) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Victim Name', accident.fullname),
          _buildInfoRow('Phone', accident.phone),
          _buildInfoRow('Vehicle', accident.vehicle),
          _buildInfoRow('Accident Date', accident.accidentDate),
          _buildInfoRow('Location', accident.location),
          if (accident.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Description',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              accident.description,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(AccidentProvider accidentProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleReject(accidentProvider),
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Reject'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleAccept(accidentProvider),
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Accept'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openLocationInMaps(AccidentReport accident) async {
    try {
      final googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=${accident.latitude},${accident.longitude}&travelmode=driving';
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl));
      } else {
        throw Exception('Could not launch Google Maps');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open maps: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleAccept(AccidentProvider accidentProvider) async {
    final accident = accidentProvider.currentAccident;
    if (accident == null) return;

    // First accept the report
    final success = await accidentProvider.acceptCurrentAccident(showNext: true);
    
    if (mounted && success) {
      // Automatically open location in maps
      _openLocationInMaps(accident);
      
      // Ask for next report
      final showNext = await _askForNextReport();
      
      if (showNext == false) {
        // Cancel all remaining reports
        await accidentProvider.cancelAllRemainingReports();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report accepted. Location opened in maps. All remaining reports cancelled.'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.of(context).pop();
      } else if (showNext == true) {
        // Show next report
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report accepted. Location opened in maps. Showing next report.'),
            backgroundColor: Colors.green,
          ),
        );
        if (!accidentProvider.hasCurrentAccident) {
          Navigator.of(context).pop();
        }
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to accept report. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<bool?> _askForNextReport() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Take Another Report?',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Do you want to take another accident report?',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Decline',
              style: GoogleFonts.roboto(color: Colors.red[600]),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Yes',
              style: GoogleFonts.roboto(color: Colors.green[600]),
            ),
          ),
        ],
      ),
    );
  }

  void _handleReject(AccidentProvider accidentProvider) async {
    final success = await accidentProvider.rejectCurrentAccident();
    
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report rejected. Notification sent: Ambulance is not coming.'),
            backgroundColor: Colors.orange,
          ),
        );
        
        if (!accidentProvider.hasCurrentAccident) {
          Navigator.of(context).pop();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to reject report. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
