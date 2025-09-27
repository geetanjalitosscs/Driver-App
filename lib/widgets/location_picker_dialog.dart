import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class LocationPickerDialog extends StatefulWidget {
  final String? initialLocation;
  final Function(String location, double? lat, double? lng) onLocationSelected;

  const LocationPickerDialog({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  final _searchController = TextEditingController();
  final _locationController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _isGettingCurrentLocation = false;
  Map<String, dynamic>? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _locationController.text = widget.initialLocation ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _getCurrentLocation() async {
    setState(() {
      _isGettingCurrentLocation = true;
    });

    try {
      final location = await CentralizedApiService.getCurrentLocationDetailed();
      if (location != null) {
        setState(() {
          _selectedLocation = location;
          _locationController.text = location['address'];
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location found: ${location['address']}'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to get current location'),
            backgroundColor: AppTheme.accentRed,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    } finally {
      setState(() {
        _isGettingCurrentLocation = false;
      });
    }
  }

  void _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    try {
      final results = await CentralizedApiService.searchLocation(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search error: $e'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _selectLocation(Map<String, dynamic> location) {
    setState(() {
      _selectedLocation = location;
      _locationController.text = location['address'];
      _searchResults = [];
      _searchController.clear();
    });
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      widget.onLocationSelected(
        _selectedLocation!['address'],
        _selectedLocation!['latitude'],
        _selectedLocation!['longitude'],
      );
      Navigator.of(context).pop();
    } else if (_locationController.text.isNotEmpty) {
      // Use manual input
      widget.onLocationSelected(_locationController.text, null, null);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select or enter a location'),
          backgroundColor: AppTheme.accentOrange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(AppIconStyles.locationIcon, color: AppIconStyles.locationIconColor, size: AppIconStyles.locationIconSize),
                const SizedBox(width: 8),
                Text(
                  'Select Location',
                  style: AppTextStyles.dialogTitle,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Current Location Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isGettingCurrentLocation ? null : _getCurrentLocation,
                icon: _isGettingCurrentLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  _isGettingCurrentLocation ? 'Getting Location...' : 'Use Current Location',
                  style: AppTextStyles.dialogBody,
                ),
                style: AppButtonStyles.primaryButton,
              ),
            ),
            const SizedBox(height: 20),

            // Search Section
            Text(
              'Search Location',
              style: AppTextStyles.dialogSubtitle,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a location...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _searchLocation(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSearching ? null : _searchLocation,
                  child: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Results
            if (_searchResults.isNotEmpty) ...[
              Text(
                'Search Results',
                style: AppTextStyles.dialogSmall,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: AppTheme.accentRed),
                        title: Text(
                          result['address'],
                          style: AppTextStyles.locationText,
                        ),
                        subtitle: Text(
                          'Lat: ${result['latitude'].toStringAsFixed(4)}, Lng: ${result['longitude'].toStringAsFixed(4)}',
                          style: AppTextStyles.locationSmallText,
                        ),
                        onTap: () => _selectLocation(result),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              // Manual Input
              Text(
                'Selected Location',
                style: AppTextStyles.dialogSubtitle,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Enter location manually...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.edit_location),
                ),
                maxLines: 2,
              ),
              const Spacer(),
            ],

            // Action Buttons
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.dialogBody,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: AppButtonStyles.successButton,
                    child: Text(
                      'Confirm',
                      style: AppTextStyles.dialogBody,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
