import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/location_picker_service.dart';

class DebugLocationTestScreen extends StatefulWidget {
  @override
  _DebugLocationTestScreenState createState() => _DebugLocationTestScreenState();
}

class _DebugLocationTestScreenState extends State<DebugLocationTestScreen> {
  String _debugInfo = 'Tap "Test Location" to start debugging...';
  bool _isLoading = false;

  void _testLocation() async {
    setState(() {
      _isLoading = true;
      _debugInfo = 'Starting location test...\n';
    });

    try {
      final location = await LocationPickerService.getCurrentLocation();
      
      if (location != null) {
        setState(() {
          _debugInfo += 'SUCCESS!\n';
          _debugInfo += 'Latitude: ${location['latitude']}\n';
          _debugInfo += 'Longitude: ${location['longitude']}\n';
          _debugInfo += 'Address: ${location['address']}\n';
          _debugInfo += 'Accuracy: ${location['accuracy']}m\n';
          _debugInfo += 'Timestamp: ${location['timestamp']}\n';
        });
      } else {
        setState(() {
          _debugInfo += 'FAILED: Location service returned null\n';
          _debugInfo += 'Check console logs for detailed error information\n';
        });
      }
    } catch (e) {
      setState(() {
        _debugInfo += 'ERROR: $e\n';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Location Test'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Location Debug Test',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'This screen will help debug location issues. Check the console for detailed logs.',
                      style: GoogleFonts.roboto(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _testLocation,
                        icon: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(Icons.location_on),
                        label: Text(_isLoading ? 'Testing...' : 'Test Location'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _debugInfo,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Issues & Solutions:',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Location services disabled - Enable in device settings\n'
                      '2. App permissions denied - Allow location access\n'
                      '3. GPS signal weak - Move to open area\n'
                      '4. Emulator issues - Set location in emulator settings\n'
                      '5. Network issues - Check internet connection',
                      style: GoogleFonts.roboto(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
