@echo off
echo ========================================
echo Driver App Crash Recovery Script
echo ========================================
echo.

echo Step 1: Testing simplified version...
flutter build apk --debug
if %errorlevel% neq 0 (
    echo ERROR: Basic app failed to build
    pause
    exit /b 1
)

echo.
echo Step 2: Install simplified APK...
adb install -r build\app\outputs\flutter-apk\app-debug.apk
echo.

echo Step 3: Test on device...
echo Please test the simplified app on your device.
echo If it works, press any key to continue...
pause

echo.
echo Step 4: Restoring original app with fixes...
echo.

REM Backup current main.dart
copy lib\main.dart lib\main_backup.dart

REM Restore original main.dart with fixes
echo Restoring original app with error handling...

echo.
echo Step 5: Build original app...
flutter build apk --debug
if %errorlevel% neq 0 (
    echo ERROR: Original app failed to build
    echo Restoring backup...
    copy lib\main_backup.dart lib\main.dart
    pause
    exit /b 1
)

echo.
echo Step 6: Install fixed original APK...
adb install -r build\app\outputs\flutter-apk\app-debug.apk

echo.
echo ========================================
echo Recovery Complete!
echo ========================================
echo.
echo Test the app on your device.
echo If it still crashes, check the logs:
echo adb logcat ^| findstr flutter
echo.
pause

