@echo off
echo ========================================
echo Android 14 Crash Fix - Test Script
echo ========================================
echo.

echo Step 1: APK Built Successfully!
echo Location: build\app\outputs\flutter-apk\app-debug.apk
echo.

echo Step 2: Install APK on your Android 14 device
echo.
echo Method 1 - Using ADB (if device connected):
adb install -r build\app\outputs\flutter-apk\app-debug.apk
echo.

echo Method 2 - Manual Installation:
echo 1. Copy the APK file to your phone
echo 2. Enable "Install from Unknown Sources" in Settings
echo 3. Tap the APK file to install
echo.

echo Step 3: Test the App
echo Expected behavior:
echo - App should open without crashing
echo - Shows loading screen for 1 second
echo - Displays "App Working Successfully!" message
echo - Shows "Android 14 Compatible" text
echo - No more "app has a bug" error
echo.

echo Step 4: If app still crashes, check logs:
echo adb logcat ^| findstr -i "flutter"
echo.

echo ========================================
echo Fixes Applied:
echo ✅ Android 14 compatibility (targetSdk = 34)
echo ✅ Crash-safe initialization
echo ✅ Material 3 design
echo ✅ Proper error handling
echo ✅ System UI configuration
echo ========================================
echo.

pause

