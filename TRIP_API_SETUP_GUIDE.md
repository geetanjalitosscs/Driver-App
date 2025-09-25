# Trip API Setup Guide

## 🐛 **Problem Identified:**
The trip section is not fetching data because the PHP API files are not being served by a web server.

## 🔧 **Solution Steps:**

### **Step 1: Set up XAMPP**

1. **Start XAMPP Control Panel**
2. **Start Apache service** (should show green "Running")
3. **Start MySQL service** (should show green "Running")

### **Step 2: Copy PHP Files to XAMPP**

1. **Create directory:** `C:\xampp\htdocs\Driver-App\`
2. **Copy all PHP files** from your project to this directory:
   ```
   C:\xampp\htdocs\Driver-App\
   ├── get_driver_trips.php
   ├── get_completed_trips.php
   ├── get_driver_earnings.php
   ├── get_earnings_summary.php
   ├── get_recent_earnings.php
   ├── get_weekly_earnings.php
   ├── get_wallet.php
   ├── get_wallet_transactions.php
   ├── get_withdrawals.php
   ├── request_withdrawal.php
   ├── get_accidents.php
   ├── accept_trip.php
   ├── complete_trip.php
   ├── create_trip_from_accident.php
   ├── update_trip_location.php
   ├── send_notification.php
   └── test_api.php
   ```

### **Step 3: Test API Endpoints**

1. **Test database connection:**
   ```
   http://localhost/Driver-App/test_api.php
   ```

2. **Test trips endpoint:**
   ```
   http://localhost/Driver-App/get_driver_trips.php?driver_id=1
   ```

3. **Test completed trips:**
   ```
   http://localhost/Driver-App/get_completed_trips.php?driver_id=1
   ```

### **Step 4: Add Sample Data to Database**

Run the database setup script to add sample data:

```sql
-- Connect to MySQL and run:
USE edueyeco_apatkal;
source quick_database_setup.sql;
```

### **Step 5: Update Flutter Configuration**

The Flutter app is already configured to use:
```dart
static const String baseUrl = 'http://localhost/Driver-App';
```

### **Step 6: Test the App**

1. **Run the Flutter app**
2. **Navigate to Trip History screen**
3. **Check if data loads**

## 🔍 **Troubleshooting:**

### **If API returns HTML instead of JSON:**
- Check if XAMPP Apache is running
- Verify PHP files are in `C:\xampp\htdocs\Driver-App\`
- Test with: `http://localhost/Driver-App/test_api.php`

### **If database connection fails:**
- Check if XAMPP MySQL is running
- Verify database `edueyeco_apatkal` exists
- Check username/password in PHP files

### **If no data is returned:**
- Run the sample data script
- Check if driver_id=1 exists in database
- Verify trips table has data

## 📋 **Quick Commands:**

### **Copy PHP files to XAMPP:**
```bash
# In PowerShell, run from your project directory:
xcopy "*.php" "C:\xampp\htdocs\Driver-App\" /Y
```

### **Test API endpoints:**
```bash
# Test database connection
curl "http://localhost/Driver-App/test_api.php"

# Test trips
curl "http://localhost/Driver-App/get_driver_trips.php?driver_id=1"
```

## ✅ **Expected Results:**

After setup, the API should return JSON like:
```json
[
  {
    "history_id": 1,
    "driver_id": 1,
    "client_name": "Alice Brown",
    "location": "123 Main Street, Downtown to 456 Hospital Road, Medical District",
    "timing": "2024-01-15 09:30:00",
    "amount": 45.50,
    "duration": 28,
    "start_time": "2024-01-15 09:30:00",
    "end_time": "2024-01-15 09:58:00",
    "created_at": "2024-01-15 09:30:00"
  }
]
```

Your trip section should now fetch and display data from the database! 🎉
