import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_accident_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/nearby_accidents_widget.dart';
import '../theme/app_theme.dart';

class NearbyAccidentsScreen extends StatefulWidget {
  const NearbyAccidentsScreen({Key? key}) : super(key: key);

  @override
  State<NearbyAccidentsScreen> createState() => _NearbyAccidentsScreenState();
}

class _NearbyAccidentsScreenState extends State<NearbyAccidentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Accidents'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<LocationAccidentProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _refreshAccidents(),
                tooltip: 'Refresh',
              );
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, LocationAccidentProvider>(
        builder: (context, authProvider, locationProvider, child) {
          if (!authProvider.isAuthenticated) {
            return const Center(
              child: Text('Please login to view nearby accidents'),
            );
          }

          return NearbyAccidentsWidget(
            onAccidentTap: _onAccidentTap,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateLocation,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.my_location, color: Colors.white),
        tooltip: 'Update Location',
      ),
    );
  }

  void _refreshAccidents() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationAccidentProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated && authProvider.driver != null) {
      locationProvider.getDriverNearbyAccidents(
        driverId: authProvider.driver!['driver_id'],
      );
    }
  }

  void _updateLocation() async {
    // This would typically get the current location from GPS
    // For now, we'll show a dialog to manually enter coordinates
    _showLocationUpdateDialog();
  }

  void _showLocationUpdateDialog() {
    final latController = TextEditingController();
    final lngController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: latController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                hintText: 'e.g., 22.7170',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lngController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                hintText: 'e.g., 75.8337',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final lat = double.tryParse(latController.text);
              final lng = double.tryParse(lngController.text);
              
              if (lat != null && lng != null) {
                _updateDriverLocation(lat, lng);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter valid coordinates'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _updateDriverLocation(double latitude, double longitude) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationAccidentProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated && authProvider.driver != null) {
      await locationProvider.updateDriverLocation(
        driverId: authProvider.driver!['driver_id'],
        latitude: latitude,
        longitude: longitude,
      );
      
      // Refresh nearby accidents after updating location
      await locationProvider.getDriverNearbyAccidents(
        driverId: authProvider.driver!['driver_id'],
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _onAccidentTap(Map<String, dynamic> accident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(accident['fullname'] ?? 'Accident Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Distance', '${accident['distance_km']} km'),
              _buildDetailRow('Vehicle', accident['vehicle'] ?? 'Not specified'),
              _buildDetailRow('Phone', accident['phone'] ?? 'Not provided'),
              _buildDetailRow('Date', accident['accident_date'] ?? 'Not specified'),
              _buildDetailRow('Status', accident['status'] ?? 'Unknown'),
              _buildDetailRow('Location', accident['location'] ?? 'Not specified'),
              if (accident['description'] != null && accident['description'].isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(accident['description']),
              ],
              if (accident['photos'] != null && (accident['photos'] as List).isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Photos:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${(accident['photos'] as List).length} photo(s) available'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showDirectionsDialog(accident);
            },
            child: const Text('Get Directions'),
          ),
        ],
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
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDirectionsDialog(Map<String, dynamic> accident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Get Directions'),
        content: Text(
          'Would you like to open this location in your maps app?\n\n'
          'Location: ${accident['location']}\n'
          'Coordinates: ${accident['latitude']}, ${accident['longitude']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would typically open the maps app
              // For now, just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening maps app...'),
                ),
              );
            },
            child: const Text('Open Maps'),
          ),
        ],
      ),
    );
  }
}
