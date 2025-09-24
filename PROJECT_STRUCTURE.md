# Driver App - Clean Project Structure

## 📁 **Project Organization**

```
Driver-App/
├── 📱 Core App Files
│   ├── pubspec.yaml              # Dependencies & app config
│   ├── pubspec.lock              # Locked dependency versions
│   ├── analysis_options.yaml    # Code analysis rules
│   └── README.md                 # Project documentation
│
├── 📂 lib/                       # Main Flutter source code
│   ├── main.dart                 # App entry point
│   ├── config/                   # Configuration files
│   │   └── database_config.dart
│   ├── constants/                # App constants
│   │   └── app_constants.dart
│   ├── models/                   # Data models
│   │   ├── accident_filter.dart
│   │   ├── accident_report.dart
│   │   ├── emergency_request.dart
│   │   └── profile_data.dart
│   ├── providers/                # State management
│   │   ├── accident_provider.dart
│   │   ├── emergency_provider.dart
│   │   └── profile_provider.dart
│   ├── screens/                  # App screens
│   │   ├── home_screen.dart
│   │   ├── accident_list_screen.dart
│   │   ├── accident_detail_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── trip_history_screen.dart
│   │   ├── earnings_screen.dart
│   │   └── help_screen.dart
│   ├── services/                 # Business logic services
│   │   ├── accident_api_service.dart
│   │   ├── api_service.dart
│   │   ├── database_helper.dart
│   │   ├── geocoding_service.dart
│   │   ├── location_picker_service.dart
│   │   ├── navigation_service.dart
│   │   ├── notification_service.dart
│   │   └── profile_service.dart
│   ├── theme/                    # App theming
│   │   └── app_theme.dart
│   ├── utils/                    # Utility functions
│   │   └── responsive_helper.dart
│   └── widgets/                  # Reusable UI components
│       ├── accident_filter_widget.dart
│       ├── accident_report_dialog.dart
│       ├── api_accident_report_dialog.dart
│       ├── emergency_request_dialog.dart
│       ├── emergency_simulation_dialog.dart
│       ├── location_picker_dialog.dart
│       ├── notification_banner.dart
│       └── common/                # Common UI widgets
│           ├── app_button.dart
│           ├── app_card.dart
│           └── loading_widget.dart
│
├── 📱 Platform-Specific Files
│   ├── android/                  # Android configuration
│   │   ├── app/
│   │   │   ├── build.gradle.kts
│   │   │   ├── google-services.json
│   │   │   └── src/
│   │   ├── build.gradle.kts
│   │   ├── gradle.properties
│   │   ├── local.properties
│   │   └── settings.gradle.kts
│   ├── ios/                      # iOS configuration
│   │   ├── Flutter/
│   │   ├── Runner/
│   │   ├── Runner.xcodeproj/
│   │   ├── Runner.xcworkspace/
│   │   └── RunnerTests/
│   └── windows/                  # Windows configuration
│       ├── CMakeLists.txt
│       ├── flutter/
│       └── runner/
│
├── 🌐 Web Files
│   ├── web/
│   │   ├── favicon.png
│   │   ├── index.html
│   │   ├── manifest.json
│   │   └── icons/
│   └── test_notification.html    # Web notification testing
│
├── 🗄️ Database & Backend
│   ├── database_setup.sql         # Main database schema
│   ├── mysql_user_setup.sql       # MySQL user configuration
│   ├── get_accidents.php          # Accident reports API
│   └── send_notification.php      # Push notification service
│
├── 🧪 Testing & Documentation
│   ├── test/
│   │   └── widget_test.dart       # Unit tests
│   ├── demo_notifications.html    # Notification demo
│   └── NOTIFICATION_SETUP_GUIDE.md # Setup instructions
```

## 🎯 **Key Features by Category**

### **📱 Core App Features**
- **Home Screen**: Driver status, accident reports, emergency simulation
- **Accident Management**: List view, filtering, detailed reports
- **Profile Management**: Driver information and settings
- **Navigation**: Trip history, earnings tracking, help system

### **🔔 Notification System**
- **Push Notifications**: Firebase Cloud Messaging
- **In-App Banners**: Real-time notification display
- **Web Integration**: PHP scripts for sending notifications
- **Testing Tools**: Demo interfaces for notification testing

### **🔍 Filtering System**
- **City Filter**: Location-based filtering
- **Status Filter**: Report status filtering
- **Description Search**: Keyword-based search
- **Vehicle Filter**: Vehicle type filtering
- **Severity Filter**: Accident severity levels

### **🗄️ Data Management**
- **API Integration**: Accident reports from web
- **Local Storage**: Driver preferences and settings
- **Real-time Updates**: 30-second refresh cycles
- **State Management**: Provider pattern for data flow

## 🚀 **Quick Start**

1. **Install Dependencies**: `flutter pub get`
2. **Run on Web**: `flutter run -d chrome`
3. **Run on Android**: `flutter run -d android`
4. **Run on Windows**: `flutter run -d windows`

## 📋 **File Purposes**

### **Essential Files** (Don't Delete)
- `lib/` - All Flutter source code
- `pubspec.yaml` - Dependencies configuration
- `android/`, `ios/`, `windows/` - Platform configurations
- `web/` - Web platform files

### **Backend Files** (For Web Integration)
- `send_notification.php` - Push notification service
- `get_accidents.php` - Accident reports API
- `database_setup.sql` - Database schema

### **Testing Files** (Optional)
- `test_notification.html` - Web notification testing
- `demo_notifications.html` - Notification demo
- `test/` - Unit tests

### **Documentation** (Reference)
- `README.md` - Project overview
- `NOTIFICATION_SETUP_GUIDE.md` - Setup instructions
- `PROJECT_STRUCTURE.md` - This file

## ✅ **Clean Structure Benefits**

- **No Duplicates**: Removed duplicate files and folders
- **Clear Organization**: Logical grouping of related files
- **Easy Navigation**: Intuitive folder structure
- **Maintainable**: Easy to find and modify files
- **Professional**: Clean, production-ready structure
