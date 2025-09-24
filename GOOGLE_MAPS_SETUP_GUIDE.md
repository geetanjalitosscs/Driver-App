# Google Maps Integration Setup Guide

This guide will help you set up Google Maps integration for the trip navigation system.

## Prerequisites

1. **Google Cloud Console Account**: You need a Google Cloud account
2. **Billing Enabled**: Google Maps API requires billing to be enabled
3. **Flutter Development Environment**: Ensure Flutter is properly set up

## Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable billing for your project

## Step 2: Enable Required APIs

Enable the following APIs in your Google Cloud project:

1. **Maps SDK for Android**
2. **Maps SDK for iOS** 
3. **Directions API**
4. **Geocoding API**
5. **Places API** (optional, for enhanced location features)

### How to Enable APIs:

1. Go to "APIs & Services" > "Library"
2. Search for each API and click "Enable"
3. Make sure billing is enabled for each API

## Step 3: Create API Key

1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "API Key"
3. Copy the generated API key
4. **Important**: Restrict your API key for security

### API Key Restrictions:

1. Click on your API key to edit it
2. Under "Application restrictions":
   - For Android: Add your app's package name and SHA-1 certificate fingerprint
   - For iOS: Add your app's bundle identifier
3. Under "API restrictions":
   - Select "Restrict key"
   - Choose only the APIs you need (Maps SDK, Directions, Geocoding)

## Step 4: Configure Flutter App

### Update API Key in Configuration:

1. Open `lib/config/maps_config.dart`
2. Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key:

```dart
static const String googleMapsApiKey = 'AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
```

### Android Configuration:

1. Open `android/app/src/main/AndroidManifest.xml`
2. Add the API key inside the `<application>` tag:

```xml
<application>
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
</application>
```

### iOS Configuration:

1. Open `ios/Runner/AppDelegate.swift`
2. Add the API key in the `application` method:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Step 5: Update Database Schema

Run the SQL script to add location tracking fields:

```bash
mysql -u root -p apatkal_driver_app < update_trips_table.sql
```

This will add the following fields to your `trips` table:
- `start_latitude`, `start_longitude`
- `end_latitude`, `end_longitude` 
- `current_latitude`, `current_longitude`
- `last_location_update`

And create a new `location_updates` table for tracking location history.

## Step 6: Test the Integration

1. Run the app: `flutter run`
2. Accept an accident report
3. You should see the trip navigation screen with:
   - Live map showing your location
   - Route from start to destination
   - "Start Navigation" button
   - Real-time location tracking

## Features Implemented

### ✅ Trip Navigation Screen
- Live Google Maps integration
- Real-time location tracking
- Route calculation and display
- Start/Complete trip functionality

### ✅ Location Tracking
- Automatic location updates every 30 seconds
- Updates when moving > 50m
- Backend synchronization
- Distance and time validation

### ✅ Trip Validation
- Minimum distance requirement (100m from destination)
- Minimum time requirement (2 minutes)
- GPS verification for fraud prevention

### ✅ Backend Integration
- Real-time location updates via REST API
- Location history tracking
- Trip status management

## Troubleshooting

### Common Issues:

1. **"API key not found" error**:
   - Check if API key is correctly set in `maps_config.dart`
   - Verify API key restrictions in Google Cloud Console

2. **Map not loading**:
   - Ensure Maps SDK for Android/iOS is enabled
   - Check if billing is enabled for your project
   - Verify API key has correct permissions

3. **Location not updating**:
   - Check device location permissions
   - Ensure location services are enabled
   - Verify `geolocator` plugin is working

4. **Route not displaying**:
   - Check if Directions API is enabled
   - Verify API key has Directions API access
   - Check network connectivity

### Testing Commands:

```bash
# Check if API key is configured
flutter run --verbose

# Test on specific device
flutter run -d android
flutter run -d ios

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Security Best Practices

1. **Restrict API Key**: Always restrict your API key to specific apps and APIs
2. **Monitor Usage**: Set up billing alerts in Google Cloud Console
3. **Rotate Keys**: Regularly rotate your API keys
4. **Environment Variables**: Consider using environment variables for API keys in production

## Cost Considerations

- **Maps SDK**: Free up to 28,000 map loads per month
- **Directions API**: $5 per 1,000 requests
- **Geocoding API**: $5 per 1,000 requests

Monitor your usage in Google Cloud Console to avoid unexpected charges.

## Next Steps

1. **Customize Map Styling**: Add custom map themes
2. **Enhanced Navigation**: Add turn-by-turn voice directions
3. **Offline Maps**: Implement offline map caching
4. **Real-time Tracking**: Add passenger tracking features
5. **Analytics**: Implement trip analytics and reporting

## Support

If you encounter issues:
1. Check the [Google Maps Flutter Plugin documentation](https://pub.dev/packages/google_maps_flutter)
2. Review [Google Maps Platform documentation](https://developers.google.com/maps/documentation)
3. Check Flutter and plugin compatibility
4. Verify all dependencies are up to date
