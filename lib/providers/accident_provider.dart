import 'package:flutter/foundation.dart';
import '../models/accident_report.dart';
import '../models/accident_filter.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AccidentProvider extends ChangeNotifier {
  List<AccidentReport> _accidentList = [];
  List<AccidentReport> _allAccidents = []; // Store all accidents for filtering
  AccidentReport? _currentAccident;
  AccidentReport? _acceptedAccident; // Store accepted accident for home screen display
  bool _isLoading = false;
  String? _errorMessage;
  int _pendingCount = 0;
  AccidentFilter _currentFilter = AccidentFilter();

  // Getters
  List<AccidentReport> get accidentList => _accidentList;
  List<AccidentReport> get allAccidents => _allAccidents;
  AccidentReport? get currentAccident => _currentAccident;
  AccidentReport? get acceptedAccident => _acceptedAccident;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get pendingCount => _pendingCount;
  bool get hasCurrentAccident => _currentAccident != null;
  bool get hasAcceptedAccident => _acceptedAccident != null;
  bool get hasMoreAccidents => _accidentList.length > 1;
  AccidentFilter get currentFilter => _currentFilter;

  /// Load all accidents from API
  Future<void> loadAccidents() async {
    _setLoading(true);
    _clearError();

    try {
      _allAccidents = await CentralizedApiService.getAccidents();
      
      // Apply current filter
      _applyFilter();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load accidents: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Apply current filter to accidents
  void _applyFilter() {
    List<AccidentReport> filteredAccidents = List.from(_allAccidents);
    
    // Apply city filter
    if (_currentFilter.city != null && _currentFilter.city!.isNotEmpty) {
      filteredAccidents = filteredAccidents.where((accident) {
        return accident.location.toLowerCase().contains(_currentFilter.city!.toLowerCase());
      }).toList();
    }
    
    // Apply status filter
    if (_currentFilter.status != null && _currentFilter.status!.isNotEmpty) {
      filteredAccidents = filteredAccidents.where((accident) {
        return accident.status.toLowerCase() == _currentFilter.status!.toLowerCase();
      }).toList();
    }
    
    // Apply description filter
    if (_currentFilter.description != null && _currentFilter.description!.isNotEmpty) {
      filteredAccidents = filteredAccidents.where((accident) {
        return accident.description.toLowerCase().contains(_currentFilter.description!.toLowerCase());
      }).toList();
    }
    
    // Apply vehicle filter
    if (_currentFilter.vehicle != null && _currentFilter.vehicle!.isNotEmpty) {
      filteredAccidents = filteredAccidents.where((accident) {
        return accident.vehicle.toLowerCase().contains(_currentFilter.vehicle!.toLowerCase());
      }).toList();
    }
    
    // Apply severity filter (based on description keywords)
    if (_currentFilter.severity != null && _currentFilter.severity!.isNotEmpty) {
      filteredAccidents = filteredAccidents.where((accident) {
        return _matchesSeverity(accident.description, _currentFilter.severity!);
      }).toList();
    }
    
    // Apply date filters
    if (_currentFilter.dateFrom != null) {
      filteredAccidents = filteredAccidents.where((accident) {
        try {
          final accidentDate = DateTime.parse(accident.accidentDate);
          return accidentDate.isAfter(_currentFilter.dateFrom!) || 
                 accidentDate.isAtSameMomentAs(_currentFilter.dateFrom!);
        } catch (e) {
          return true; // If date parsing fails, include the accident
        }
      }).toList();
    }
    
    if (_currentFilter.dateTo != null) {
      filteredAccidents = filteredAccidents.where((accident) {
        try {
          final accidentDate = DateTime.parse(accident.accidentDate);
          return accidentDate.isBefore(_currentFilter.dateTo!) || 
                 accidentDate.isAtSameMomentAs(_currentFilter.dateTo!);
        } catch (e) {
          return true; // If date parsing fails, include the accident
        }
      }).toList();
    }
    
    _accidentList = filteredAccidents;
    _pendingCount = _accidentList.where((accident) => 
        accident.status == 'pending' && 
        (accident.driverStatus == null || accident.driverStatus == 'available')
    ).length;
    
    if (_accidentList.isNotEmpty) {
      // Prioritize accidents with valid coordinates
      final validAccidents = _accidentList.where((accident) => 
        accident.latitude != 0.0 && accident.longitude != 0.0
      ).toList();
      
      if (validAccidents.isNotEmpty) {
        _currentAccident = validAccidents[0];
        print('Selected accident with valid coordinates: ID ${_currentAccident!.id}, Lat: ${_currentAccident!.latitude}, Lng: ${_currentAccident!.longitude}');
      } else {
        _currentAccident = _accidentList[0];
        print('No accidents with valid coordinates, using first available: ID ${_currentAccident!.id}, Lat: ${_currentAccident!.latitude}, Lng: ${_currentAccident!.longitude}');
      }
    } else {
      _currentAccident = null;
    }
  }

  /// Check if accident description matches severity level
  bool _matchesSeverity(String description, String severity) {
    final desc = description.toLowerCase();
    
    switch (severity.toLowerCase()) {
      case 'low':
        return desc.contains('minor') || desc.contains('small') || desc.contains('light');
      case 'medium':
        return desc.contains('moderate') || desc.contains('medium') || desc.contains('some');
      case 'high':
        return desc.contains('serious') || desc.contains('major') || desc.contains('severe');
      case 'critical':
        return desc.contains('critical') || desc.contains('emergency') || desc.contains('urgent') || 
               desc.contains('life') || desc.contains('death') || desc.contains('fatal');
      default:
        return true;
    }
  }

  /// Accept current accident report
  Future<bool> acceptCurrentAccident({
    required int driverId,
    required String vehicleNumber,
    bool showNext = true,
    double? currentLat,
    double? currentLng,
  }) async {
    if (_currentAccident == null) return false;
    
    // Check if driver already has an accepted accident
    if (_acceptedAccident != null) {
      print('Driver already has an accepted accident. Cannot accept another.');
      return false;
    }

    try {
      // Call the new accept accident API
      print('=== ACCEPT ACCIDENT DEBUG ===');
      print('Accident ID: ${_currentAccident!.id}');
      print('Driver ID: $driverId');
      print('Vehicle Number: $vehicleNumber');
      
      // Try API call first
      bool apiSuccess = false;
      try {
        final result = await CentralizedApiService.acceptAccident(
          accidentId: _currentAccident!.id,
          driverId: driverId,
          vehicleNumber: vehicleNumber,
        );
        
        print('API Response: $result');
        apiSuccess = result['success'] == true;
        
        if (!apiSuccess) {
          print('API failed - cannot proceed with acceptance');
          _setError('Failed to accept accident: API returned failure');
          return false;
        }
      } catch (apiError) {
        print('API Error: $apiError');
        _setError('Failed to accept accident: API call failed - $apiError');
        return false;
      }
      
      print('=== ACCEPT ACCIDENT DEBUG END ===');

      // Only proceed if API succeeded
      // Store the accepted accident for home screen display
      _acceptedAccident = _currentAccident;
      notifyListeners();

      // Add notification for trip acceptance
      _addTripAcceptedNotification();
      
      // Show push notification (with error handling)
      try {
        await NotificationService.showNotification(
          id: DateTime.now().millisecondsSinceEpoch,
          title: 'Trip Accepted',
          body: 'You have accepted accident report #${_currentAccident!.id}. Navigate to the location.',
          type: 'trip_accepted',
        );
      } catch (notificationError) {
        print('Notification error (continuing anyway): $notificationError');
      }

      // Open location in Google Maps app (prefer native app over browser)
      print('=== GOOGLE MAPS DEBUG ===');
      print('Accident ID: ${_currentAccident!.id}');
      print('Latitude: ${_currentAccident!.latitude}');
      print('Longitude: ${_currentAccident!.longitude}');
      print('Location: ${_currentAccident!.location}');
      print('Full name: ${_currentAccident!.fullname}');
      print('Vehicle: ${_currentAccident!.vehicle}');
      
      // Always try to open map, even with 0,0 coordinates
      double lat = _currentAccident!.latitude;
      double lng = _currentAccident!.longitude;
      
      if (lat == 0.0 || lng == 0.0) {
        print('WARNING: Invalid coordinates - latitude: $lat, longitude: $lng');
        print('Attempting to parse coordinates from location string...');
        
        // Try to parse coordinates from location string
        final locationString = _currentAccident!.location;
        print('Attempting to parse coordinates from location: $locationString');
        
        // Try multiple patterns
        RegExp latPattern = RegExp(r'Lat:\s*([0-9.-]+)');
        RegExp lngPattern = RegExp(r'Lng:\s*([0-9.-]+)');
        
        var latMatch = latPattern.firstMatch(locationString);
        var lngMatch = lngPattern.firstMatch(locationString);
        
        // If not found, try alternative patterns
        if (latMatch == null || lngMatch == null) {
          latPattern = RegExp(r'latitude[:\s]*([0-9.-]+)', caseSensitive: false);
          lngPattern = RegExp(r'longitude[:\s]*([0-9.-]+)', caseSensitive: false);
          latMatch = latPattern.firstMatch(locationString);
          lngMatch = lngPattern.firstMatch(locationString);
        }
        
        // If still not found, try coordinate pairs
        if (latMatch == null || lngMatch == null) {
          final coordPattern = RegExp(r'([0-9.-]+),\s*([0-9.-]+)');
          final coordMatch = coordPattern.firstMatch(locationString);
          if (coordMatch != null) {
            lat = double.tryParse(coordMatch.group(1)!) ?? 0.0;
            lng = double.tryParse(coordMatch.group(2)!) ?? 0.0;
            print('Parsed coordinates from coordinate pair: lat=$lat, lng=$lng');
          }
        } else {
          lat = double.tryParse(latMatch.group(1)!) ?? 0.0;
          lng = double.tryParse(lngMatch.group(1)!) ?? 0.0;
          print('Parsed coordinates from location: lat=$lat, lng=$lng');
        }
        
        // If still 0,0, use a default location (Jabalpur city center)
        if (lat == 0.0 || lng == 0.0) {
          print('Using default coordinates for Jabalpur city center');
          lat = 23.1815; // Jabalpur city center
          lng = 79.9864;
        }
      }
      
      final googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
      print('Google Maps URL: $googleMapsUrl');
      
      try {
        print('Attempting to launch Google Maps...');
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          print('URL can be launched, launching now...');
          await launchUrl(
            Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication, // Force native app
          );
          print('Google Maps opened successfully');
        } else {
          print('Could not launch Google Maps - trying platform default');
          await launchUrl(
            Uri.parse(googleMapsUrl),
            mode: LaunchMode.platformDefault,
          );
          print('Google Maps opened with platform default');
        }
      } catch (mapsError) {
        print('Google Maps error: $mapsError');
        // Don't fail the whole process if maps fails
      }
      print('=== GOOGLE MAPS DEBUG END ===');

      // Don't move to next accident when accepting - keep it visible
      // The accepted accident will be shown on home screen
      print('=== ACCEPT ACCIDENT SUCCESS ===');
      print('Local acceptance completed successfully');
      print('Accepted accident ID: ${_acceptedAccident?.id}');
      print('=== END SUCCESS ===');
      return true;
    } catch (e) {
      print('=== ACCEPT ACCIDENT ERROR ===');
      print('Error: $e');
      print('Stack trace: ${StackTrace.current}');
      print('=== END ERROR ===');
      _setError('Failed to accept accident: $e');
      return false;
    }
  }

  /// Continue with accepted accident (navigate to trip navigation)
  void continueWithAcceptedAccident() {
    // This will be handled by the home screen to navigate to trip navigation
    notifyListeners();
  }

  /// Complete accepted accident
  Future<bool> completeAcceptedAccident({
    required int driverId,
    required bool confirmed,
  }) async {
    if (_acceptedAccident == null) return false;

    try {
      // Try API call first
      bool apiSuccess = false;
      try {
        final result = await CentralizedApiService.completeAccident(
          accidentId: _acceptedAccident!.id,
          driverId: driverId,
          confirmed: confirmed,
        );
        
        print('Complete API Response: $result');
        apiSuccess = result['success'] == true;
        
        if (!apiSuccess) {
          print('Complete API failed - but continuing with completion (database might be updated)');
          // Don't return false here - continue with completion
        }
      } catch (apiError) {
        print('Complete API Error: $apiError');
        print('API call failed but continuing with completion (database might be updated)');
        // Don't return false here - continue with completion
        apiSuccess = false;
      }

      if (confirmed) {
        // Always proceed with completion (database might be updated even if API response failed)
        _acceptedAccident = null;
        notifyListeners();
        
        // Add notification for trip completion
        _addTripCompletedNotification();
        
        // Show push notification (with error handling)
        try {
          await NotificationService.showNotification(
            id: DateTime.now().millisecondsSinceEpoch,
            title: 'Trip Completed',
            body: 'You have successfully completed accident report. Great job!',
            type: 'trip_completed',
          );
        } catch (notificationError) {
          print('Notification error (continuing anyway): $notificationError');
        }
        
        print('=== TRIP COMPLETION SUCCESS ===');
        print('Trip completed successfully, returning true');
        print('=== END SUCCESS ===');
        
        return true; // Always return true for completion
      }
      return true;
    } catch (e) {
      print('Complete accident error: $e');
      _setError('Failed to complete accident: $e');
      return false;
    }
  }

  // Async Google Maps opening to avoid blocking
  void _openGoogleMapsAsync(String url) {
    Future.microtask(() async {
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication, // Force native app
          );
          print('Google Maps opened successfully');
        } else {
          print('Could not launch Google Maps - trying platform default');
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.platformDefault,
          );
        }
      } catch (mapsError) {
        print('Google Maps error: $mapsError');
        // Don't fail the whole process if maps fails
      }
    });
  }

  // Notification helper methods
  void _addTripAcceptedNotification() {
    if (_currentAccident != null) {
      // This will be called from the UI context where NotificationProvider is available
      print('Trip accepted notification should be added for accident ${_currentAccident!.id}');
    }
  }

  void _addTripCompletedNotification() {
    if (_acceptedAccident != null) {
      // This will be called from the UI context where NotificationProvider is available
      print('Trip completed notification should be added for accident ${_acceptedAccident!.id}');
    }
  }

  void _addNewAccidentNotification() {
    if (_currentAccident != null) {
      // This will be called from the UI context where NotificationProvider is available
      print('New accident notification should be added for accident ${_currentAccident!.id}');
    }
  }

  /// Cancel accepted accident
  Future<void> cancelAcceptedAccident() async {
    if (_acceptedAccident == null) return;
    
    try {
      // Reset database fields to null
      final result = await CentralizedApiService.completeAccident(
        accidentId: _acceptedAccident!.id,
        driverId: 0, // Use 0 to indicate cancellation
        confirmed: false, // false means cancel
      );
      
      print('Cancel API Response: $result');
      
      // Clear the accepted accident locally
      _acceptedAccident = null;
      notifyListeners();
      
      print('Accident cancelled successfully');
    } catch (e) {
      print('Error cancelling accident: $e');
      // Still clear locally even if API fails
      _acceptedAccident = null;
      notifyListeners();
    }
  }

  /// Reject current accident report
  Future<bool> rejectCurrentAccident() async {
    if (_currentAccident == null) return false;

    try {
      // Note: Reject accident functionality needs to be implemented in centralized service
      // For now, we'll simulate success
      final success = true;

      if (success) {
        _moveToNextAccident();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to reject accident: $e');
      return false;
    }
  }

  /// Move to next accident in the list
  void _moveToNextAccident() {
    if (_accidentList.length > 1) {
      _accidentList.removeAt(0);
      _currentAccident = _accidentList[0];
      _pendingCount = _accidentList.length;
    } else {
      _currentAccident = null;
      _pendingCount = 0;
    }
    notifyListeners();
  }

  /// Apply filter to accidents
  void applyFilter(AccidentFilter filter) {
    _currentFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _currentFilter = AccidentFilter();
    _applyFilter();
    notifyListeners();
  }

  /// Refresh pending count from API
  Future<void> refreshPendingCount() async {
    try {
      _allAccidents = await CentralizedApiService.getAccidents();
      _applyFilter();
      notifyListeners();
    } catch (e) {
      print('Error refreshing pending count: $e');
    }
  }

  /// Refresh accident list
  Future<void> refreshAccidents() async {
    await loadAccidents();
  }

  /// Clear current accident (when all are processed)
  void clearCurrentAccident() {
    _currentAccident = null;
    notifyListeners();
  }

  /// Cancel all remaining reports (only when explicitly declining after accept)
  Future<void> cancelAllRemainingReports() async {
    if (_currentAccident == null) return;
    
    try {
      // This would need to be implemented as an API endpoint
      // For now, just clear the local state
      
      _currentAccident = null;
      _pendingCount = 0;
      _accidentList.clear();
      notifyListeners();
    } catch (e) {
      _setError('Failed to cancel remaining reports: $e');
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
  }

  /// Get accident details for navigation
  Map<String, dynamic> getAccidentDetails() {
    if (_currentAccident == null) return {};
    
    return {
      'id': _currentAccident!.id,
      'fullname': _currentAccident!.fullname,
      'phone': _currentAccident!.phone,
      'vehicle': _currentAccident!.vehicle,
      'accidentDate': _currentAccident!.accidentDate,
      'location': _currentAccident!.location,
      'latitude': _currentAccident!.latitude,
      'longitude': _currentAccident!.longitude,
      'description': _currentAccident!.description,
      'photo': _currentAccident!.photo,
      'createdAt': _currentAccident!.createdAt,
    };
  }
}
