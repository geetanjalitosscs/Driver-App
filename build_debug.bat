@echo off
echo Building Driver App with Debug Information...

REM Clean the project
flutter clean

REM Get dependencies
flutter pub get

REM Build debug APK with verbose output
flutter build apk --debug --verbose

echo.
echo Build completed! Check for any errors above.
echo APK location: build\app\outputs\flutter-apk\app-debug.apk
echo.
echo To install on device:
echo adb install build\app\outputs\flutter-apk\app-debug.apk
echo.
echo To see logs while app is running:
echo adb logcat | findstr flutter
pause

