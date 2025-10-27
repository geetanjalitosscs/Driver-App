# Apatkal App - Complete Documentation

A Flutter application designed for ambulance drivers to receive and respond to emergency accident requests. The app features real-time location tracking, dynamic radius accident detection, single-device login security, and comprehensive trip management.

## 🎯 Overview

This is a full-stack ambulance driver management system with:
- **Flutter Frontend** (Dart) - Mobile app for drivers
- **PHP Backend** - RESTful APIs for data management
- **MySQL Database** - Data storage and management
- **Real-time Location Tracking** - GPS tracking every 5 seconds
- **Single-Device Login** - Security for driver accounts
- **Dynamic Accident Detection** - Location-based accident notifications

---

## 📁 Project Structure

```
Apatkal-App/
├── lib/
│   ├── main.dart                           # App entry point
│   ├── config/                             # Configuration files
│   │   ├── centered_api.dart              # API endpoint configuration
│   │   └── maps_config.dart               # Google Maps configuration
│   ├── constants/
│   │   └── app_constants.dart              # App-wide constants
│   ├── models/                             # Data models
│   │   ├── accident_report.dart            # Accident data model
│   │   ├── trip.dart                       # Trip data model
│   │   ├── wallet.dart                     # Wallet data model
│   │   ├── profile_data.dart              # Driver profile model
│   │   └── [9 more models]
│   ├── providers/                          # State management
│   │   ├── auth_provider.dart             # Authentication state
│   │   ├── accident_provider.dart         # Accident management
│   │   ├── trip_provider.dart             # Trip management
│   │   ├── wallet_provider.dart           # Wallet & earnings
│   │   └── [8 more providers]
│   ├── screens/                            # UI screens
│   │   ├── login_screen.dart              # Login page
│   │   ├── signup_screen.dart             # Registration page
│   │   ├── home_screen.dart               # Main dashboard
│   │   ├── accident_list_screen.dart      # Accident listings
│   │   ├── trip_navigation_screen.dart    # Active trip navigation
│   │   └── [12 more screens]
│   ├── services/                           # Business logic
│   │   ├── api_service_endpoints.dart     # API calls
│   │   ├── location_tracking_service.dart # GPS tracking
│   │   ├── device_id_service.dart         # Device identification
│   │   └── notification_service.dart      # Push notifications
│   ├── theme/
│   │   └── app_theme.dart                  # Material 3 theme
│   ├── widgets/                           # Reusable components
│   │   ├── common/                        # Common UI widgets
│   │   ├── emergency/                     # Emergency widgets
│   │   └── trip/                          # Trip-related widgets
│   └── utils/
│       └── helpers.dart                    # Utility functions
├── api/                                    # PHP Backend APIs
│   ├── db_config.php                     # Database connection
│   ├── login.php                         # Driver login
│   ├── signup.php                        # Driver registration
│   ├── logout.php                         # Driver logout
│   ├── update_driver_location.php        # Location updates
│   ├── get_driver_nearby_accidents.php   # Nearby accidents
│   ├── get_accidents.php                 # All accidents
│   └── [20+ more API files]
├── database/
│   ├── edueyeco_apatkal2.sql            # Database schema
│   └── sample_data.sql                   # Sample data
└── android/ios/                           # Platform-specific code
```

---

## 🔄 Application Flow

### 1. **Authentication Flow**

#### **Login Process** (`login_screen.dart` → `login.php`)
1. User enters email/password
2. **AuthProvider** (`auth_provider.dart`) handles login
3. Gets current GPS location via `LocationTrackingService`
4. Gets device ID via `DeviceIdService`
5. Sends login request to `login.php` with:
   - Email, password
   - Latitude, longitude
   - Device ID, device name
6. API validates credentials in `drivers` table
7. API checks `device_sessions` for existing sessions
8. If another device is active → Login blocked (single-device security)
9. If allowed → Creates device session + updates `driver_locations`
10. Returns driver data + starts location tracking service
11. Location updates every **5 seconds** via `update_driver_location.php`

#### **Signup Process** (`signup_screen.dart` → `signup.php`)
1. User fills registration form with:
   - Personal info (name, email, phone, address)
   - Vehicle details (type, number)
   - Bank details (account, IFSC, holder name)
   - KYC documents (Aadhar, Licence, RC photos)
2. Photos are uploaded to `uploads/` directory
3. API creates driver record in `drivers` table
4. Adds bank details to `driver_bank_accounts`
5. Updates KYC documents
6. Returns driver ID for login

#### **Logout Process** (`logout.php`)
1. User taps logout
2. Stops location tracking service
3. Calls `logout.php` to deactivate device session
4. Clears local storage data
5. Returns to login screen

---

### 2. **Location Tracking Flow**

#### **Real-time GPS Updates** (`location_tracking_service.dart`)
```
Every 5 seconds:
1. Get current GPS location (latitude, longitude)
2. Check if moved > 5 meters from last location
3. If moved → Send update to update_driver_location.php
4. API inserts/updates driver_locations table:
   - driver_id (UNIQUE constraint)
   - latitude, longitude
   - updated_at (auto timestamp)
5. Uses ON DUPLICATE KEY UPDATE to prevent duplicates
```

**Key Files:**
- `lib/services/location_tracking_service.dart` - Flutter tracking service
- `api/update_driver_location.php` - PHP location API
- `driver_locations` table - Database storage

---

### 3. **Accident Detection Flow**

#### **Dynamic Radius System**

The app uses two types of accident detection:

**A. New Accidents (Last 24 Hours)** - Dynamic Expanding Radius
```
Time since accident → Radius
0-15 seconds       → 500 meters
15-30 seconds      → 1 kilometer
30-45 seconds      → 1.5 kilometers
45-60 seconds      → 2 kilometers
60+ seconds        → 10 kilometers (max)
```

**B. Old Accidents (24+ Hours)** - Fixed Radius
```
Always → 10 kilometers fixed radius
```

#### **How It Works** (`get_driver_nearby_accidents.php`)
1. API fetches current driver location from `driver_locations` table
2. Gets all pending accidents from `accidents` table
3. For each accident:
   - Calculate age (time since created)
   - If new (< 24 hours) → Calculate dynamic radius
   - If old (> 24 hours) → Use 10km fixed radius
   - Calculate distance using Haversine formula
   - Check if any approved drivers are within radius
   - Only show accident if current driver is also within radius
4. Returns filtered accidents list
5. Flutter app displays accidents on map/list

**Key Files:**
- `lib/providers/accident_provider.dart` - Accident state management
- `lib/screens/accident_list_screen.dart` - Accident display UI
- `api/get_driver_nearby_accidents.php` - Main accident detection API
- `api/get_accidents_by_location.php` - Location-based filtering
- `api/get_nearby_accidents.php` - Nearby accident search
- `api/get_accidents.php` - General accident list

---

### 4. **Trip Management Flow**

#### **Trip Lifecycle**
1. **Driver accepts accident** → Trip created in `trips` table
2. **Navigate to location** → `trip_navigation_screen.dart`
   - Real-time map with driver/client locations
   - Location updates every 2 seconds during trip
3. **Trip location updates** → `update_trip_location.php`
   - Tracks driver path during trip
   - Shows on map for client tracking
4. **Trip completion** → `get_completed_trips.php`
   - Adds to earnings
   - Updates wallet balance

**Key Files:**
- `lib/providers/trip_provider.dart` - Trip state management
- `lib/screens/trip_navigation_screen.dart` - Navigation UI
- `api/update_trip_location.php` - Trip tracking API
- `api/get_driver_trips.php` - Driver trip history

---

### 5. **Wallet & Earnings Flow**

#### **Earnings System**
1. Driver completes trip
2. Earnings added to `driver_earnings` table
3. Wallet balance updated in `wallets` table
4. Can request withdrawal via `request_withdrawal.php`
5. Withdrawal tracked in `withdrawals` table

**Key Files:**
- `lib/providers/wallet_provider.dart` - Wallet state management
- `lib/screens/wallet_screen.dart` - Wallet UI
- `api/get_wallet.php` - Wallet data API
- `api/get_driver_earnings.php` - Earnings history

---

## 🗄️ Database Schema

### **Key Tables**

#### **1. drivers** - Driver information
```sql
- id (PRIMARY KEY)
- driver_name, email, phone, password
- vehicle_type, vehicle_number
- kyc_status (pending/approved/rejected)
- created_at, updated_at
```

#### **2. driver_locations** - Real-time location tracking
```sql
- id (PRIMARY KEY)
- driver_id (UNIQUE, FOREIGN KEY)
- latitude, longitude
- updated_at (auto-timestamp)
```

#### **3. device_sessions** - Single-device login security
```sql
- id (PRIMARY KEY)
- driver_id (FOREIGN KEY)
- device_id, device_name
- login_time, last_activity
- is_active (boolean)
- ip_address, user_agent
```

#### **4. accidents** - Accident reports
```sql
- id (PRIMARY KEY)
- client_name, phone, address
- latitude, longitude
- vehicle_type, description
- photos (JSON array)
- status (pending/accepted/rejected/completed)
- created_at, updated_at
```

#### **5. trips** - Trip management
```sql
- id (PRIMARY KEY)
- driver_id (FOREIGN KEY)
- accident_id (FOREIGN KEY)
- start_time, end_time
- driver_latitude, driver_longitude
- status (pending/accepted/in_progress/completed)
```

#### **6. wallets** - Driver wallets
```sql
- id (PRIMARY KEY)
- driver_id (UNIQUE, FOREIGN KEY)
- balance
- total_earnings
- total_withdrawals
```

#### **7. withdrawals** - Withdrawal requests
```sql
- id (PRIMARY KEY)
- driver_id (FOREIGN KEY)
- amount
- status (pending/completed/rejected)
- requested_at, processed_at
```

---

## 🔐 Security Features

### **1. Single-Device Login**
- One driver account can only be active on one device
- `device_sessions` table tracks active sessions
- Login checks for existing active sessions
- New login deactivates old device session

### **2. KYC Verification**
- Aadhar, Licence, RC document upload required
- Admin approval needed before driver can accept trips
- Status: pending → approved/rejected

### **3. Location Security**
- Real-time location tracking for driver safety
- Location stored securely in database
- No location data exposed to unauthorized users

---

## 📊 Key Features

### **Driver Features**
✅ Real-time accident notifications  
✅ Dynamic radius accident detection  
✅ GPS tracking every 5 seconds  
✅ Trip navigation with live map  
✅ Wallet & earnings management  
✅ Withdrawal requests  
✅ Trip history  
✅ KYC verification  
✅ Profile management  
✅ Single-device login security  

### **API Features**
✅ RESTful API architecture  
✅ JSON request/response format  
✅ Location-based filtering  
✅ Dynamic radius calculation  
✅ Haversine distance calculation  
✅ Timezone management (IST)  
✅ Error handling & logging  

---

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (>=3.0.0)
- Dart SDK
- XAMPP (PHP + MySQL)
- Android Studio / VS Code

### **Setup Instructions**

#### **1. Database Setup**
```bash
1. Start XAMPP and MySQL
2. Import database/edueyeco_apatkal2.sql into MySQL
3. Configure api/db_config.php with your database credentials
```

#### **2. Flutter App Setup**
```bash
cd Apatkal-App
flutter pub get
flutter run
```

#### **3. API Configuration**
- Edit `lib/config/centered_api.dart` to set API base URL
- Edit `api/db_config.php` for database connection

---

## 🔄 Main Workflows

### **Workflow 1: Driver Login & Location Tracking**
```
User Opens App
  ↓
Login Screen
  ↓
Enter Credentials
  ↓
Get GPS Location
  ↓
Get Device ID
  ↓
API: login.php
  ↓
Check Single-Device Login
  ↓
Start Location Tracking (every 5 seconds)
  ↓
Update driver_locations table
  ↓
Navigate to Home Screen
```

### **Workflow 2: Accident Detection & Acceptance**
```
Location Tracking Running
  ↓
API: get_driver_nearby_accidents.php
  ↓
Calculate Driver-Accident Distance
  ↓
Check if within Radius
  ↓
Show Accident in App
  ↓
Driver Accepts Accident
  ↓
Create Trip Record
  ↓
Navigate to Trip Navigation Screen
  ↓
Start Real-time Trip Tracking
```

### **Workflow 3: Trip Completion & Payment**
```
Trip Navigation Active
  ↓
Driver Reaches Accident Location
  ↓
Pick Up Client
  ↓
Drive to Hospital
  ↓
Trip Complete
  ↓
Update Trip Status
  ↓
Add Earnings to Wallet
  ↓
Show Trip Completion Dialog
```

---

## 🗂️ File Responsibilities

### **Frontend (Flutter)**

#### **lib/screens/**
- `login_screen.dart` - User login interface
- `signup_screen.dart` - User registration interface
- `home_screen.dart` - Main dashboard with status toggle
- `accident_list_screen.dart` - List of nearby accidents (auto-refresh every 5 min)
- `trip_navigation_screen.dart` - Active trip navigation with map
- `wallet_screen.dart` - Wallet balance & transactions
- `notifications_screen.dart` - Push notifications
- `settings_screen.dart` - App settings
- `trip_history_screen.dart` - Past trip records
- `profile_screen.dart` - Driver profile

#### **lib/providers/**
- `auth_provider.dart` - Authentication, login, logout
- `accident_provider.dart` - Accident management, filtering
- `trip_provider.dart` - Trip management, navigation
- `wallet_provider.dart` - Wallet, earnings, withdrawals
- `notification_provider.dart` - Push notifications
- `earnings_provider.dart` - Earnings calculations
- `settings_provider.dart` - App settings state
- `navigation_provider.dart` - Tab navigation
- `profile_provider.dart` - Profile data

#### **lib/services/**
- `api_service_endpoints.dart` - All API calls (30+ methods)
- `location_tracking_service.dart` - GPS tracking every 5 seconds
- `device_id_service.dart` - Device identification
- `notification_service.dart` - Push notifications
- `location_accident_service.dart` - Location-based accident API

#### **lib/widgets/**
- `common/` - Reusable UI components (buttons, cards, dialogs)
- `emergency/` - Emergency request dialogs
- `trip/` - Trip-related widgets

### **Backend (PHP)**

#### **Authentication APIs**
- `login.php` - Driver login with location & device tracking
- `signup.php` - Driver registration with KYC upload
- `logout.php` - Device session deactivation
- `update_profile.php` - Profile updates

#### **Location APIs**
- `update_driver_location.php` - Real-time location updates (every 5 seconds)

#### **Accident APIs**
- `get_driver_nearby_accidents.php` - **Main accident detection with dynamic radius**
- `get_accidents.php` - All accidents with location filtering
- `get_accidents_by_location.php` - Location-based accidents
- `get_nearby_accidents.php` - Nearby accident search

#### **Trip APIs**
- `update_trip_location.php` - Trip tracking during navigation
- `get_driver_trips.php` - Trip history
- `get_completed_trips.php` - Completed trips

#### **Wallet APIs**
- `get_wallet.php` - Wallet balance
- `get_driver_earnings.php` - Earnings history
- `get_wallet_transactions.php` - Transaction history
- `request_withdrawal.php` - Withdrawal requests
- `get_withdrawals.php` - Withdrawal list

#### **Utility APIs**
- `check_kyc_status.php` - KYC verification status
- `get_account_details.php` - Account details
- `upload_photo.php` - Photo upload
- `send_notification.php` - Send push notification
- `change_password.php` - Password change
- `delete_account.php` - Account deletion

---

## 🔧 Configuration

### **API Endpoints**
Edit `lib/config/centered_api.dart`:
```dart
static const String baseUrl = 'https://tossconsultancyservices.com/apatkal/api/';
```

### **Database Config**
Edit `api/db_config.php`:
```php
$db_config = [
    'host' => 'localhost',
    'dbname' => 'edueyeco_apatkal2',
    'username' => 'edueyeco_apatkal',
    'password' => 'edueyeco_apatkal',
];
```

### **Timezone**
Already configured to IST (Asia/Kolkata) in:
- `api/db_config.php` - PHP timezone
- MySQL session timezone set to +05:30

---

## 📱 Key User Flows

### **Flow 1: New Driver Registration**
1. Open app → Signup screen
2. Enter personal info + vehicle details
3. Upload Aadhar, Licence, RC photos
4. Enter bank account details
5. Submit → KYC verification pending
6. Wait for admin approval
7. Login after approval

### **Flow 2: Active Driver Daily Work**
1. Login → Home screen
2. Toggle "On Duty" status
3. Wait for nearby accident reports
4. Accident appears (within dynamic radius)
5. Accept accident → Start navigation
6. Pick up client → Drive to hospital
7. Complete trip → Earnings added
8. Check wallet balance
9. Request withdrawal when needed

### **Flow 3: Location Tracking**
1. Login triggers location tracking
2. GPS location captured
3. Stored in `driver_locations` table
4. Updates every 5 seconds
5. Used for accident detection
6. Stops on logout

---

## 🧪 Testing

### **Test Database Connection**
```bash
php api/test_connection.php
```

### **Test Location Updates**
1. Login in app
2. Check `driver_locations` table
3. Verify `updated_at` changes every 5 seconds

### **Test Accident Detection**
1. Create accident in `accidents` table
2. Set location near active driver
3. Check if appears in app within correct radius

---

## 🐛 Troubleshooting

### **Location Not Updating**
- Check GPS permissions
- Verify `update_driver_location.php` is reachable
- Check database `driver_locations` table

### **Accidents Not Showing**
- Verify driver location in database
- Check accident location proximity
- Verify radius calculations
- Check `kyc_status` is 'approved'

### **Single-Device Login Issues**
- Check `device_sessions` table
- Verify `is_active` status
- Clear old sessions manually in database

---

## 📄 License

This project is licensed under the MIT License.

---

## 👥 Contributing

1. Fork the repository
2. Create feature branch
3. Test changes thoroughly
4. Submit pull request

---

**Last Updated:** January 2025  
**Version:** 1.0.0
