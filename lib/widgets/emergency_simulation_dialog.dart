import 'package:flutter/material.dart';
import '../models/emergency_request.dart';
import '../providers/emergency_provider.dart';
import '../services/api_service_endpoints.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'location_picker_dialog.dart';

class EmergencySimulationDialog extends StatefulWidget {
  const EmergencySimulationDialog({super.key});

  @override
  State<EmergencySimulationDialog> createState() => _EmergencySimulationDialogState();
}

class _EmergencySimulationDialogState extends State<EmergencySimulationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _patientAgeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool _isValidatingLocation = false;
  String? _locationError;

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientAgeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _validateLocation() async {
    final location = _locationController.text.trim();
    if (location.isEmpty) return;

    setState(() {
      _isValidatingLocation = true;
      _locationError = null;
    });

    try {
      // Simple validation - just check if location is not empty
      if (mounted) {
        setState(() {
          _isValidatingLocation = false;
          if (location.trim().isNotEmpty) {
            _locationError = null;
          } else {
            _locationError = 'Please enter a valid location';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isValidatingLocation = false;
          _locationError = 'Failed to validate location';
        });
      }
    }
  }

  void _getCurrentLocation() async {
    setState(() {
      _isValidatingLocation = true;
      _locationError = null;
    });

    try {
      print('Emergency simulation: Getting current location...');
      final location = await CentralizedApiService.getCurrentLocationDetailed();
      
      if (location != null) {
        setState(() {
          _locationController.text = location['address'];
          _locationError = null;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Current location set: ${location['address']}'),
            backgroundColor: AppTheme.accentGreen,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        setState(() {
          _locationError = 'Unable to get current location';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to get current location. Check console for details.'),
            backgroundColor: AppTheme.accentRed,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print('Emergency simulation location error: $e');
      setState(() {
        _locationError = 'Error getting location: $e';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: AppTheme.accentRed,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isValidatingLocation = false;
      });
    }
  }

  void _openLocationPicker() {
    showDialog(
      context: context,
      builder: (context) => LocationPickerDialog(
        initialLocation: _locationController.text,
        onLocationSelected: (location, lat, lng) {
          setState(() {
            _locationController.text = location;
            _locationError = null;
          });
          
          // If we have coordinates, we can skip validation
          if (lat != null && lng != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Location selected: $location'),
                backgroundColor: AppTheme.accentGreen,
              ),
            );
          } else {
            // Validate the manually entered location
            _validateLocation();
          }
        },
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Validate location first
      await _validateLocation();
      
      if (_locationError != null) {
        return; // Don't submit if location is invalid
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Use mock coordinates for simulation
        final coordinates = {
          'latitude': 23.0225, // Default coordinates for simulation
          'longitude': 81.3784,
        };
        
        // Debug: Print coordinates being set
        print("=== EMERGENCY SIMULATION DEBUG ===");
        print("Location entered: ${_locationController.text.trim()}");
        print("Coordinates received: $coordinates");
        print("Latitude: ${coordinates['latitude']}");
        print("Longitude: ${coordinates['longitude']}");
        
        // Create emergency request
        final emergencyRequest = EmergencyRequest.fromForm(
          patientName: _patientNameController.text.trim(),
          patientAge: int.parse(_patientAgeController.text.trim()),
          location: _locationController.text.trim(),
          description: _descriptionController.text.trim(),
          latitude: coordinates?['latitude'] ?? 23.0225, // Beohari coordinates as fallback
          longitude: coordinates?['longitude'] ?? 81.3784,
        );
        
        print("Emergency request created with coordinates: ${emergencyRequest.latitude}, ${emergencyRequest.longitude}");
        print("=== EMERGENCY SIMULATION DEBUG END ===");

        // Add to emergency provider
        if (mounted) {
          final emergencyProvider = Provider.of<EmergencyProvider>(context, listen: false);
          emergencyProvider.createEmergencyRequest(emergencyRequest);
          
          Navigator.of(context).pop();
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Emergency request created successfully!'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create emergency: $e'),
              backgroundColor: AppTheme.accentRed,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.emergency,
                      color: AppTheme.accentRed,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Create Emergency Simulation',
                      style: AppTextStyles.dialogTitle,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Patient Name
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  hintText: 'Enter patient name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Patient Age
              TextFormField(
                controller: _patientAgeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Patient Age',
                  hintText: 'Enter patient age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.cake),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter patient age';
                  }
                  final age = int.tryParse(value.trim());
                  if (age == null || age < 0 || age > 150) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                onChanged: (value) {
                  // Clear error when user starts typing
                  if (_locationError != null) {
                    setState(() {
                      _locationError = null;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  _validateLocation();
                },
                decoration: InputDecoration(
                  labelText: 'Emergency Location',
                  hintText: 'Enter emergency location (e.g., Jabalpur, Madhya Pradesh)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                  suffixIcon: _isValidatingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : GestureDetector(
                          onTap: _getCurrentLocation,
                          onLongPress: _openLocationPicker,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.my_location, color: AppTheme.primaryBlue),
                          ),
                        ),
                  errorText: _locationError,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter emergency location';
                  }
                  if (_locationError != null) {
                    return _locationError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Emergency Description',
                  hintText: 'Describe the emergency situation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter emergency description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentRed,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Create',
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
      ),
    );
  }
}
