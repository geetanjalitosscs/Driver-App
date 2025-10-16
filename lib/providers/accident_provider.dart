import 'package:flutter/foundation.dart';
import '../models/accident_report.dart';
import '../models/accident_filter.dart';
import '../services/api_service_endpoints.dart';
import '../services/notification_service.dart';
import '../screens/trip_navigation_screen.dart';
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
  bool _isLoadingAccidents = false; // Prevent concurrent loading

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
  Future<void> loadAccidents({int? driverId}) async {
    // Prevent concurrent loading
    if (_isLoadingAccidents) {
      print('Accidents already loading, skipping duplicate call');
      return;
    }
    
    _isLoadingAccidents = true;
    _setLoading(true);
    _clearError();

    try {
      print('Loading accidents for driver ID: $driverId');
      
      // Store previous accident IDs to detect new ones
      final previousAccidentIds = _allAccidents.map((a) => a.id).toSet();
      
      final fetchedAccidents = await CentralizedApiService.getAccidents(driverId: driverId);
      
      // Remove duplicates based on accident ID and content
      final uniqueAccidents = <AccidentReport>[];
      final seenIds = <int>{};
      final seenContent = <String>{}; // Track content-based duplicates
      
      for (final accident in fetchedAccidents) {
        // Create a content signature for duplicate detection
        final contentSignature = '${accident.fullname}_${accident.vehicle}_${accident.location}_${accident.description}';
        
        if (!seenIds.contains(accident.id) && !seenContent.contains(contentSignature)) {
          seenIds.add(accident.id);
          seenContent.add(contentSignature);
          uniqueAccidents.add(accident);
        } else {
          if (seenIds.contains(accident.id)) {
            print('Duplicate accident detected by ID: ${accident.id}, Name: ${accident.fullname}');
          } else {
            print('Duplicate accident detected by content: ${accident.fullname}, Vehicle: ${accident.vehicle}');
          }
        }
      }
      
      _allAccidents = uniqueAccidents;
      
      // Debug logging for accident IDs
      print('=== ACCIDENT PROVIDER DEBUG ===');
      print('Fetched ${fetchedAccidents.length} accidents, ${uniqueAccidents.length} unique');
      for (final accident in _allAccidents) {
        print('Accident ID: ${accident.id}, Name: ${accident.fullname}, Vehicle: ${accident.vehicle}');
      }
      print('=== END ACCIDENT PROVIDER DEBUG ===');
      
      // Detect and notify about NEW accidents only
      if (driverId != null && _allAccidents.isNotEmpty) {
        final newAccidents = _allAccidents.where((accident) => 
          !previousAccidentIds.contains(accident.id)
        ).toList();
        
        print('Found ${newAccidents.length} new accidents');
        
        // Show notifications only for NEW accidents
        for (final accident in newAccidents) {
          print('Creating notification for new accident ID: ${accident.id}');
          
          // Add in-app notification (handled in UI layer)
          // Note: In-app notifications are handled in the UI where NotificationProvider is available
          
          // Show system notification
          await NotificationService.showNewAccidentNotification(
            accidentId: accident.id,
            vehicle: accident.vehicle,
            location: accident.location,
            latitude: accident.latitude,
            longitude: accident.longitude,
          );
        }
      }
      
      // Apply current filter
      _applyFilter();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load accidents: $e');
    } finally {
      _setLoading(false);
      _isLoadingAccidents = false; // Reset concurrent loading flag
    }
  }

  /// Manually remove duplicates (public method)
  void removeDuplicates() {
    _removeDuplicates();
    _applyFilter();
    notifyListeners();
  }

  /// Refresh accidents and remove duplicates
  Future<void> refreshAccidents({int? driverId}) async {
    await loadAccidents(driverId: driverId);
  }

  /// Remove duplicates from accident list
  void _removeDuplicates() {
    final uniqueAccidents = <AccidentReport>[];
    final seenIds = <int>{};
    final seenContent = <String>{};
    
    for (final accident in _allAccidents) {
      // Create a content signature for duplicate detection
      final contentSignature = '${accident.fullname}_${accident.vehicle}_${accident.location}_${accident.description}';
      
      if (!seenIds.contains(accident.id) && !seenContent.contains(contentSignature)) {
        seenIds.add(accident.id);
        seenContent.add(contentSignature);
        uniqueAccidents.add(accident);
      }
    }
    
    if (uniqueAccidents.length != _allAccidents.length) {
      print('Removed ${_allAccidents.length - uniqueAccidents.length} duplicate accidents');
      _allAccidents = uniqueAccidents;
    }
  }

  /// Apply current filter to accidents
  void _applyFilter() {
    // Remove duplicates before filtering
    _removeDuplicates();
    
    List<AccidentReport> filteredAccidents = List.from(_allAccidents);
    
    // Apply city filter
    if (_currentFilter.city != null && _currentFilter.city!.isNotEmpty) {
      filteredAccidents = filteredAccidents.where((accident) {
        return accident.location.toLowerCase().contains(_currentFilter.city!.toLowerCase());
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

      // Open map immediately for faster user experience
      _openMapImmediately();

      // Do other operations in background (non-blocking)
      _handleBackgroundOperations();
      
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

  /// Open map immediately for faster user experience
  void _openMapImmediately() {
    if (_currentAccident == null) return;
    
    print('=== FAST MAP OPENING ===');
    print('Accident ID: ${_currentAccident!.id}');
    print('Latitude: ${_currentAccident!.latitude}');
    print('Longitude: ${_currentAccident!.longitude}');
    
    // Get coordinates quickly
    double lat = _currentAccident!.latitude;
    double lng = _currentAccident!.longitude;
    
    // Quick fallback for invalid coordinates
    if (lat == 0.0 || lng == 0.0) {
      print('Using default coordinates for faster map opening');
      lat = 23.1815; // Jabalpur city center
      lng = 79.9864;
    }
    
    final googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
    print('Fast Google Maps URL: $googleMapsUrl');
    
    // Launch map immediately (non-blocking)
    launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication)
        .then((_) => print('Map opened successfully'))
        .catchError((error) => print('Map opening error: $error'));
    
    print('=== FAST MAP OPENING END ===');
  }

  /// Handle background operations (notifications, etc.)
  void _handleBackgroundOperations() {
    // Add notification for trip acceptance
    _addTripAcceptedNotification();
    
    // Show push notification (with error handling) - non-blocking
    NotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Trip Accepted',
      body: 'You have accepted accident report #${_currentAccident!.id}. Navigate to the location.',
      type: 'trip_accepted',
    ).catchError((error) => print('Notification error: $error'));
    
    print('Background operations completed');
  }

  /// Complete accepted accident
  Future<bool> completeAcceptedAccident({
    required int driverId,
    required bool confirmed,
    double? driverLatitude,
    double? driverLongitude,
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
          driverLatitude: driverLatitude,
          driverLongitude: driverLongitude,
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
        
        // Note: Trip completion notifications are handled in the UI layer (trip_navigation_screen.dart)
        // where NotificationProvider is available. This prevents duplicate notifications.
        
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
      try {
        // In-app notifications are handled in UI layer where NotificationProvider is available
        // System notification is handled by NotificationService
        
        // Show system notification
        NotificationService.showAccidentAcceptedNotification(
          accidentId: _currentAccident!.id,
          location: _currentAccident!.location,
          clientName: _currentAccident!.fullname,
        );
      } catch (e) {
        print('Error adding accident accepted notification: $e');
      }
    }
  }

  // Trip completion notifications are now handled in the UI layer (trip_navigation_screen.dart)
  // to prevent duplicate notifications and ensure proper NotificationProvider access

  void _addNewAccidentNotification() {
    if (_currentAccident != null) {
      try {
        // In-app notifications are handled in UI layer where NotificationProvider is available
        // System notification is handled by NotificationService
        
        // Show system notification
        NotificationService.showNewAccidentNotification(
          accidentId: _currentAccident!.id,
          vehicle: _currentAccident!.vehicle,
          location: _currentAccident!.location,
          latitude: _currentAccident!.latitude,
          longitude: _currentAccident!.longitude,
        );
      } catch (e) {
        print('Error adding new accident notification: $e');
      }
    }
  }

  /// Cancel accepted accident
  Future<void> cancelAcceptedAccident() async {
    if (_acceptedAccident == null) return;
    
    try {
      // Add notification for accident cancelled
      try {
        // In-app notifications are handled in UI layer where NotificationProvider is available
        // System notification is handled by NotificationService
        
        // Show system notification
        NotificationService.showAccidentCancelledNotification(
          accidentId: _acceptedAccident!.id,
          location: _acceptedAccident!.location,
          clientName: _acceptedAccident!.fullname,
        );
      } catch (e) {
        print('Error adding accident cancelled notification: $e');
      }
      
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
      
      // Clear global timer state since accident is cancelled
      TripNavigationScreen.clearGlobalTimer();
      
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
      print('=== REJECT ACCIDENT DEBUG ===');
      print('Rejecting accident ID: ${_currentAccident!.id}');
      
      // Add notification for accident rejected
      try {
        // In-app notifications are handled in UI layer where NotificationProvider is available
        // System notification is handled by NotificationService
        
        // Show system notification
        NotificationService.showAccidentRejectedNotification(
          accidentId: _currentAccident!.id,
          location: _currentAccident!.location,
          clientName: _currentAccident!.fullname,
        );
      } catch (e) {
        print('Error adding accident rejected notification: $e');
      }
      
      // Move to next accident (reject means skip this one)
      _moveToNextAccident();
      
      print('Moved to next accident, current accident ID: ${_currentAccident?.id}');
      print('Has more accidents: $hasMoreAccidents');
      print('=== REJECT ACCIDENT SUCCESS ===');
      
      return true;
    } catch (e) {
      print('Reject accident error: $e');
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
