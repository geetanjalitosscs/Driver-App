# Database Documentation - Apatkal App

This directory contains the complete database schema and documentation for the Apatkal App.

## 📊 Database: `edueyeco_apatkal2`

**Server:** MySQL/MariaDB  
**Charset:** utf8mb4  
**Timezone:** Asia/Kolkata (IST - +05:30)

---

## 🎯 Core Tables for Apatkal App

### 1. **drivers** - Driver Authentication & Profile

**Purpose:** Stores driver registration, authentication, and KYC information.

**Structure:**
```sql
CREATE TABLE `drivers` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `driver_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,              -- Bcrypt hashed
  `number` varchar(15) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `vehicle_type` varchar(50) DEFAULT NULL,        -- 'Ambulance', 'Emergency Van'
  `vehicle_number` varchar(20) DEFAULT NULL,
  `model_rating` decimal(2,1) DEFAULT NULL,
  
  -- KYC Documents
  `aadhar_photo` varchar(255) NOT NULL,          -- Path to Aadhar photo
  `licence_photo` varchar(255) NOT NULL,          -- Path to Licence photo
  `rc_photo` varchar(255) NOT NULL,              -- Path to RC photo
  `kyc_status` enum('pending','approved','rejected') DEFAULT 'pending',
  
  -- Bank Details
  `account_number` varchar(20) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `ifsc_code` varchar(15) DEFAULT NULL,
  `account_holder_name` varchar(100) DEFAULT NULL,
  
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB CHARSET=utf8mb4;
```

**Key Fields:**
- `kyc_status` - Driver verification status (must be 'approved' to accept trips)
- `vehicle_type` - Type of ambulance/vehicle
- `aadhar_photo`, `licence_photo`, `rc_photo` - KYC document paths

**Usage:**
- Driver login authentication
- KYC verification check
- Profile updates
- Vehicle information

---

### 2. **device_sessions** - Single-Device Login Security

**Purpose:** Ensures one driver account can only be logged in on one device at a time.

**Structure:**
```sql
CREATE TABLE `device_sessions` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `driver_id` int(11) NOT NULL,
  `device_id` varchar(255) NOT NULL,            -- Unique device identifier
  `device_name` varchar(255) DEFAULT NULL,        -- Device name (e.g., "Samsung Galaxy")
  `login_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1,               -- 1 = active, 0 = logged out
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  
  FOREIGN KEY (`driver_id`) REFERENCES `drivers`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_driver_device` (`driver_id`, `device_id`)
) ENGINE=InnoDB;
```

**Key Features:**
- Single-device login enforcement
- Tracks active sessions per driver
- Auto-updates `last_activity` timestamp
- Prevents multiple device logins

**Usage:**
- Login security check
- Device management
- Session tracking

---

### 3. **driver_locations** - Real-time GPS Tracking

**Purpose:** Stores real-time driver GPS location for accident detection.

**Structure:**
```sql
CREATE TABLE `driver_locations` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `driver_id` int(11) NOT NULL UNIQUE,            -- One location per driver
  `latitude` decimal(10,8) NOT NULL,              -- Driver latitude
  `longitude` decimal(11,8) NOT NULL,             -- Driver longitude
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  
  FOREIGN KEY (`driver_id`) REFERENCES `drivers`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;
```

**Update Frequency:** Every 5 seconds (via Flutter app)

**Key Features:**
- `UNIQUE` constraint on `driver_id` prevents duplicates
- Uses `ON DUPLICATE KEY UPDATE` to update existing location
- Auto-timestamp update on each location change
- **Critical for accident detection algorithm**

**Usage:**
- Calculate driver-accident distance
- Determine if driver is within radius
- Filter nearby accidents

---

### 4. **accidents** - Accident Reports

**Purpose:** Stores accident reports from clients that need driver response.

**Structure:**
```sql
CREATE TABLE `accidents` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `fullname` varchar(100) NOT NULL,              -- Client name
  `phone` varchar(15) NOT NULL,                   -- Client phone
  `vehicle` varchar(50) NOT NULL,                  -- Vehicle number
  `accident_date` date NOT NULL,
  `location` text NOT NULL,                       -- Address text
  `latitude` decimal(10,8) DEFAULT NULL,         -- Accident latitude
  `longitude` decimal(11,8) DEFAULT NULL,        -- Accident longitude
  `description` text NOT NULL,                    -- Accident details
  `photo` varchar(255) DEFAULT NULL,              -- Accident photo path
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  
  -- Status Tracking
  `status` varchar(20) DEFAULT 'pending',         -- pending/resolved/investigating
  `driver_status` varchar(20) DEFAULT NULL,       -- assigned/completed
  `driver_details` text DEFAULT NULL,             -- Driver who accepted
  `accepted_at` timestamp NULL DEFAULT NULL,      -- When driver accepted
  `completed_at` timestamp NULL DEFAULT NULL,    -- When trip completed
  `completion_confirmed` tinyint(1) DEFAULT 0    -- Trip confirmation
  
) ENGINE=InnoDB;
```

**Status Flow:**
1. `pending` - New accident, waiting for driver
2. `investigating` - Driver accepted, en route
3. `resolved` - Accident handled, trip completed

**Triggers:**
- `update_driver_details` - Auto-updates `accepted_at` when driver accepts
- Auto-updates `completed_at` when trip completes

**Usage:**
- Accident detection and filtering
- Trip creation
- Status tracking

---

### 5. **trips** - Trip Records

**Purpose:** Stores completed trip history with location tracking.

**Structure:**
```sql
CREATE TABLE `trips` (
  `history_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `driver_id` int(11) NOT NULL,                   -- Driver who completed trip
  `client_name` varchar(100) NOT NULL,            -- Client name
  `location` text NOT NULL,                        -- Accident location
  `timing` timestamp NULL DEFAULT NULL,           -- Trip start time
  `duration` int(11) NOT NULL,                    -- Trip duration (minutes)
  `start_time` timestamp NULL DEFAULT NULL,      -- When trip started
  `end_time` timestamp NULL DEFAULT NULL,         -- When trip ended
  
  -- Location Tracking
  `start_latitude` decimal(10,8) DEFAULT NULL,   -- Accident location
  `start_longitude` decimal(11,8) DEFAULT NULL,
  `end_latitude` decimal(10,8) DEFAULT NULL,     -- Drop-off location
  `end_longitude` decimal(11,8) DEFAULT NULL,
  
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  
  FOREIGN KEY (`driver_id`) REFERENCES `drivers`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB;
```

**Usage:**
- Trip history
- Performance analytics


## 🔄 Database Relationships

### **Primary Relationships:**

```
drivers (1) ──┐
              ├──► device_sessions (N)      [One driver, multiple sessions]
              ├──► driver_locations (1)      [One location per driver]
              └──► trips (N)                 [Many trips per driver]

accidents (1) ──► trips (N)                  [Many trips per accident]
```

---

## 🎯 Key Database Operations

### **1. Driver Login Flow**
```sql
-- Check credentials
SELECT * FROM drivers WHERE email = ? AND password = ?;

-- Check for existing active session
SELECT * FROM device_sessions WHERE driver_id = ? AND is_active = 1;

-- Create new session
INSERT INTO device_sessions (driver_id, device_id, device_name, ip_address, user_agent)
VALUES (?, ?, ?, ?, ?);

-- Update driver location
INSERT INTO driver_locations (driver_id, latitude, longitude)
VALUES (?, ?, ?)
ON DUPLICATE KEY UPDATE latitude = VALUES(latitude), longitude = VALUES(longitude);
```

### **2. Accident Detection Flow**
```sql
-- Get driver current location
SELECT latitude, longitude FROM driver_locations WHERE driver_id = ?;

-- Get nearby accidents (within 10km for old, dynamic radius for new)
SELECT a.*, 
  (6371 * acos(cos(radians(?)) * cos(radians(a.latitude)) * 
  cos(radians(a.longitude) - radians(?)) + 
  sin(radians(?)) * sin(radians(a.latitude)))) AS distance_km
FROM accidents a
WHERE a.status = 'pending'
HAVING distance_km <= ?;
```

### **3. Trip Completion Flow**
```sql
-- Insert trip record
INSERT INTO trips (driver_id, client_name, location, timing, duration, start_time, end_time)
VALUES (?, ?, ?, ?, ?, ?, ?);
```

---

## 📝 Database Setup Instructions

### **1. Import Database**
```bash
mysql -u username -p
CREATE DATABASE edueyeco_apatkal2;
USE edueyeco_apatkal2;
SOURCE database/edueyeco_apatkal2.sql;
```

### **2. Configure Connection**
Edit `api/db_config.php`:
```php
$db_config = [
    'host' => 'localhost',
    'dbname' => 'edueyeco_apatkal2',
    'username' => 'your_username',
    'password' => 'your_password',
    'charset' => 'utf8mb4'
];
```

### **3. Set Timezone**
Database timezone is set to IST (Asia/Kolkata) in:
- PHP: `api/db_config.php` - `date_default_timezone_set('Asia/Kolkata')`
- MySQL: Session timezone set to `+05:30`

---

## 🔧 Important Constraints

### **1. UNIQUE Constraints**
- `drivers.email` - One email per driver
- `driver_locations.driver_id` - One location record per driver
- `device_sessions` - One active session per driver/device combination

### **2. FOREIGN KEY Constraints**
- `device_sessions.driver_id` → `drivers.id` (CASCADE on delete)
- `driver_locations.driver_id` → `drivers.id` (CASCADE on delete)
- `trips.driver_id` → `drivers.id` (CASCADE on delete)

### **3. Auto-Timestamps**
All tables use:
- `created_at` - First insert timestamp
- `updated_at` - Auto-update on row modification

---

## 📊 Sample Queries

### **Get Active Drivers with Locations**
```sql
SELECT d.id, d.driver_name, d.email, d.kyc_status,
       dl.latitude, dl.longitude, dl.updated_at
FROM drivers d
INNER JOIN driver_locations dl ON d.id = dl.driver_id
INNER JOIN device_sessions ds ON d.id = ds.driver_id
WHERE d.kyc_status = 'approved' AND ds.is_active = 1
ORDER BY dl.updated_at DESC;
```

### **Get Pending Accidents**
```sql
SELECT * FROM accidents 
WHERE status = 'pending' 
AND created_at >= NOW() - INTERVAL 24 HOUR
ORDER BY created_at DESC;
```

### **Get Recent Trip History**
```sql
SELECT t.history_id, d.driver_name, t.client_name, 
       t.location, t.duration, t.start_time, t.end_time
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
ORDER BY t.created_at DESC
LIMIT 20;
```

---

## ⚠️ Important Notes

1. **Single-Device Login**: Only one active session allowed per driver
2. **Location Updates**: Driver location updates every 5 seconds
3. **KYC Requirement**: Drivers must have `kyc_status = 'approved'` to see accidents
4. **UNIQUE Constraint**: `driver_locations.driver_id` ensures no duplicate location records
5. **Timezone**: All timestamps are in IST (Asia/Kolkata)
6. **Password Hashing**: Passwords stored using bcrypt ($2y$10$...)

---

## 📁 Related Files

- **SQL Dump**: `database/edueyeco_apatkal2.sql` - Complete database structure
- **PHP Config**: `api/db_config.php` - Database connection settings
- **Flutter**: `lib/services/api_service_endpoints.dart` - API calls

---

**Last Updated:** January 2025  
**Database Version:** 1.0.0
