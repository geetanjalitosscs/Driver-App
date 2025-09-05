# Ambulance Driver App

A Flutter application designed for ambulance drivers to receive and respond to emergency requests. The app features a modern Material 3 design with responsive layout for both phones and tablets.

## Features

### 🏠 Home Screen
- **Profile Header**: Driver information with online status
- **Current Status**: On Duty/Stand By toggle with location display
- **Emergency Request Card**: Real-time emergency requests with countdown timer
- **Statistics Cards**: Today's calls, daily earnings, and next shift information
- **Responsive Design**: Optimized for mobile and tablet screens

### 👤 Profile Screen
- **Driver Information**: Profile picture, name, and driver ID
- **Personal Information**: Contact details and address
- **Vehicle Information**: Ambulance type, model, and ratings
- **Performance Stats**: Total trips and average rating
- **Log Out**: Secure logout functionality

### 🚨 Emergency Request System
- **20-Second Countdown**: Automatic timer for emergency requests
- **Accept/Decline Actions**: Quick response buttons
- **Auto-Decline**: Automatic decline if no response within time limit
- **Patient Notifications**: Real-time status updates to patients

## Technical Features

- **Material 3 Design**: Modern, clean UI following Material Design guidelines
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Fluid transitions between screens
- **Card-Based UI**: Clean, organized information display
- **Google Fonts**: Professional typography
- **State Management**: Efficient state handling for real-time updates

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd app-driver-2
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart     # Home screen with emergency requests
│   └── profile_screen.dart  # Driver profile screen
├── widgets/
│   └── emergency_request_dialog.dart  # Emergency popup dialog
├── utils/
│   └── responsive_helper.dart  # Responsive design utilities
└── constants/
    └── app_constants.dart   # App constants and configuration
```

## Dependencies

- `flutter`: Flutter SDK
- `google_fonts`: Custom typography
- `cupertino_icons`: iOS-style icons

## Usage

1. **Driver Login**: Drivers can log in to access the app
2. **Emergency Requests**: When an emergency occurs, drivers receive a popup with request details
3. **Quick Response**: Drivers have 20 seconds to accept or decline the request
4. **Status Updates**: Real-time status updates are sent to patients
5. **Profile Management**: Drivers can view and edit their profile information

## Design Principles

- **Clean & Modern**: Minimalist design with focus on functionality
- **User-Friendly**: Intuitive navigation and clear information hierarchy
- **Accessible**: High contrast colors and readable fonts
- **Responsive**: Adapts seamlessly to different screen sizes
- **Professional**: Medical-grade UI suitable for emergency services

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
