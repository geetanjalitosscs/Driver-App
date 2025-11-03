# Database Documentation - Apatkal App

This directory contains the complete database schema and documentation for the Apatkal App.

## 📊 Database: `edueyeco_apatkal2`

**Server:** MySQL/MariaDB  
**Charset:** Mixed (utf8mb4 for most tables, latin1 for some driver-related tables)  
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
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,              -- Bcrypt hashed ($2y$10$...)
  `number` varchar(15) NOT NULL,                 -- Phone number
  `address` varchar(255) DEFAULT NULL,
  `vehicle_type` varchar(50) DEFAULT NULL,        -- 'Ambulance', 'Van', etc.
  `vehicle_number` varchar(20) DEFAULT NULL,
  `model_rating` decimal(2,1) DEFAULT NULL,      -- Driver rating
  
  -- KYC Documents
  `aadhar_photo` varchar(255) NOT NULL,          -- Path to Aadhar photo
  `licence_photo` varchar(255) NOT NULL,          -- Path to Licence photo
  `rc_photo` varchar(255) NOT NULL,               -- Path to RC photo
  `kyc_status` enum('pending','approved','rejected') DEFAULT 'pending',
  
  -- Bank Details (stored directly in drivers table)
  `account_number` varchar(20) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `ifsc_code` varchar(15) DEFAULT NULL,
  `account_holder_name` varchar(100) DEFAULT NULL,
  
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
```

**Indexes:**
- PRIMARY KEY (`id`)
- KEY `idx_drivers_kyc_status` (`kyc_status`)

**Key Fields:**
- `kyc_status` - Driver verification status (must be 'approved' to accept trips)
- `vehicle_type` - Type of ambulance/vehicle
- `aadhar_photo`, `licence_photo`, `rc_photo` - KYC document paths
- `password` - Bcrypt hashed password (supports both hashed and plain-text for backward compatibility)

**Usage:**
- Driver login authentication
- KYC verification check
- Profile updates
- Vehicle information
- Bank account details storage

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
  `user_agent` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
```

**Indexes:**
- PRIMARY KEY (`id`)
- UNIQUE KEY `unique_driver_device` (`driver_id`, `device_id`)
- KEY `idx_driver_active_session` (`driver_id`, `is_active`)
- KEY `idx_device_id` (`device_id`)

**Key Features:**
- Single-device login enforcement via UNIQUE constraint
- Tracks active sessions per driver
- Auto-updates `last_activity` timestamp
- Prevents multiple device logins
- **Note:** Sessions are **deleted** on logout (not just deactivated)

**Usage:**
- Login security check
- Device management
- Session tracking
- Logout cleanup

---

### 3. **driver_locations** - Real-time GPS Tracking

**Purpose:** Stores real-time driver GPS location for accident detection.

**Structure:**
```sql
CREATE TABLE `driver_locations` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `driver_id` int(11) NOT NULL,                   -- Foreign key to drivers.id
  `latitude` decimal(10,8) NOT NULL,              -- Driver latitude
  `longitude` decimal(11,8) NOT NULL,             -- Driver longitude
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
```

**Update Frequency:** Every 5 seconds (via Flutter app)

**Key Features:**
- **UNIQUE constraint on `driver_id`** prevents duplicates (enforced at application level)
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
  `status` varchar(20) DEFAULT 'pending',         -- pending/investigating/resolved
  `driver_status` varchar(20) DEFAULT NULL,       -- assigned/completed
  `driver_details` text DEFAULT NULL,            -- Driver who accepted
  `accepted_at` timestamp NULL DEFAULT NULL,      -- When driver accepted
  `completed_at` timestamp NULL DEFAULT NULL,    -- When trip completed
  `completion_confirmed` tinyint(1) DEFAULT 0    -- Trip confirmation
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

**Triggers:**
- `update_driver_details` - Auto-updates `accepted_at` when driver accepts
- Auto-updates `completed_at` when trip completes

**Status Flow:**
1. `pending` - New accident, waiting for driver
2. `investigating` - Driver accepted, en route
3. `resolved` - Accident handled, trip completed

**Usage:**
- Accident detection and filtering
- Trip creation
- Status tracking

---

### 5. **trips** - Trip Records

**Purpose:** Stores completed trip history with location tracking and enhanced data.

**Structure:**
```sql
CREATE TABLE `trips` (
  `history_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `driver_id` int(11) NOT NULL,                   -- Foreign key to drivers.id
  `client_id` int(11) DEFAULT NULL,               -- Foreign key to clients.id (NEW)
  `client_name` varchar(100) NOT NULL,            -- Client name
  `location` text NOT NULL,                        -- Accident location
  `timing` timestamp NULL DEFAULT NULL,            -- Trip start time (legacy field)
  `duration` int(11) NOT NULL,                    -- Trip duration in seconds
  `distance` decimal(10,2) DEFAULT NULL,          -- Trip distance in kilometers (NEW)
  `start_time` timestamp NULL DEFAULT NULL,        -- When trip started
  `end_time` timestamp NULL DEFAULT NULL,          -- When trip ended
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  
  -- Location Tracking
  `start_latitude` decimal(10,8) DEFAULT NULL,    -- Accident location latitude
  `start_longitude` decimal(11,8) DEFAULT NULL,   -- Accident location longitude
  `end_latitude` decimal(10,8) DEFAULT NULL,      -- Drop-off location latitude
  `end_longitude` decimal(11,8) DEFAULT NULL,      -- Drop-off location longitude
  
  -- Location Addresses (NEW)
  `from_location` text DEFAULT NULL,               -- Starting address (accident location)
  `to_location` text DEFAULT NULL                  -- Destination address (drop-off location)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

**Indexes:**
- PRIMARY KEY (`history_id`)
- KEY `idx_client_id` (`client_id`)

**New Fields (Added via ALTER TABLE):**
- `client_id` - Links trip to client record in `clients` table
- `distance` - Calculated distance in kilometers using Haversine formula
- `from_location` - Full address text of starting location (accident location)
- `to_location` - Full address text of destination location

**Usage:**
- Trip history
- Performance analytics
- Distance and duration tracking
- Location-based reporting

---

### 6. **clients** - Client/User Information

**Purpose:** Stores registered client information.

**Structure:**
```sql
CREATE TABLE `clients` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `full_name` varchar(200) NOT NULL,
  `mobile_no` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `vehicle_no` varchar(50) DEFAULT NULL,
  `vehicle_type` enum('two-wheeler','three-wheeler','four-wheeler') DEFAULT 'four-wheeler',
  `created_date` date DEFAULT curdate(),
  `house_no` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `landmark` varchar(200) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `added_by` int(11) NOT NULL,
  `assigned_staff` int(11) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `status` enum('paid','unpaid') DEFAULT 'unpaid',
  `amount` decimal(10,2) DEFAULT NULL,
  `payment_method` enum('phonepe','upi','card','netbanking','wallet','cash','cheque') DEFAULT 'phonepe',
  `transaction_id` varchar(255) DEFAULT NULL,
  `gateway_transaction_id` varchar(255) DEFAULT NULL,
  `gateway_response` text DEFAULT NULL,
  `payment_date` datetime DEFAULT NULL,
  `refund_date` datetime DEFAULT NULL,
  `refund_amount` decimal(10,2) DEFAULT NULL,
  `refund_reason` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Usage:**
- Client registration and management
- Links to trips via `client_id`
- Payment tracking

---

### 7. **wallet** - Driver Wallets

**Purpose:** Tracks driver wallet balance and earnings.

**Structure:**
```sql
CREATE TABLE `wallet` (
  `wallet_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `driver_id` int(11) NOT NULL,                   -- Foreign key to drivers.id
  `balance` decimal(10,2) DEFAULT 0.00,          -- Current wallet balance
  `total_earned` decimal(10,2) DEFAULT 0.00,       -- Total earnings ever
  `total_withdrawn` decimal(10,2) DEFAULT 0.00,    -- Total withdrawn amount
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

**Usage:**
- Wallet balance tracking
- Earnings summary
- Withdrawal calculations

---

### 8. **earnings** - Driver Earnings Records

**Purpose:** Records individual earning transactions per trip.

**Structure:**
```sql
CREATE TABLE `earnings` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `driver_id` int(11) NOT NULL,                   -- Foreign key to drivers.id
  `trip_id` int(11) DEFAULT NULL,                 -- Foreign key to trips.history_id
  `amount` decimal(8,2) NOT NULL,                  -- Earning amount
  `earning_date` date NOT NULL,                   -- Date of earning
  `created_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

**Usage:**
- Individual earning records
- Trip-based earnings
- Earnings history

---

### 9. **withdrawals** - Withdrawal Requests

**Purpose:** Tracks driver withdrawal requests from wallet.

**Structure:**
```sql
CREATE TABLE `withdrawals` (
  `withdrawal_id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `driver_id` int(11) NOT NULL,                   -- Foreign key to drivers.id
  `amount` decimal(8,2) NOT NULL,                 -- Withdrawal amount
  `bank_account_number` varchar(20) NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `ifsc_code` varchar(15) NOT NULL,
  `account_holder_name` varchar(100) NOT NULL,
  `status` enum('pending','approved','rejected','completed') DEFAULT 'pending',
  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `processed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

**Usage:**
- Withdrawal request tracking
- Payment processing
- Bank account verification

---

## 🔄 Database Relationships

### **Primary Relationships:**

```
drivers (1) ──┐
              ├──► device_sessions (N)      [One driver, multiple device sessions]
              ├──► driver_locations (1)      [One location per driver]
              ├──► trips (N)                [Many trips per driver]
              ├──► wallet (1)               [One wallet per driver]
              ├──► earnings (N)              [Many earnings per driver]
              └──► withdrawals (N)          [Many withdrawals per driver]

accidents (1) ──► trips (N)                  [Many trips per accident]
clients (1) ──► trips (N)                    [Many trips per client]
trips (1) ──► earnings (N)                   [Many earnings per trip]
```

---

## 🎯 Key Database Operations

### **1. Driver Login Flow**
```sql
-- Check credentials (supports both hashed and plain-text passwords)
SELECT * FROM drivers WHERE email = ?;

-- Check for existing active session
SELECT * FROM device_sessions WHERE driver_id = ? AND is_active = 1;

-- Create new session (or update if same device)
INSERT INTO device_sessions (driver_id, device_id, device_name, ip_address, user_agent)
VALUES (?, ?, ?, ?, ?)
ON DUPLICATE KEY UPDATE 
  login_time = CURRENT_TIMESTAMP,
  last_activity = CURRENT_TIMESTAMP,
  is_active = 1;

-- Update driver location
INSERT INTO driver_locations (driver_id, latitude, longitude)
VALUES (?, ?, ?)
ON DUPLICATE KEY UPDATE 
  latitude = VALUES(latitude), 
  longitude = VALUES(longitude),
  updated_at = CURRENT_TIMESTAMP;
```

### **2. Accident Detection Flow**
```sql
-- Get driver current location
SELECT latitude, longitude FROM driver_locations WHERE driver_id = ?;

-- Get nearby accidents (within dynamic radius for new, 10km for old)
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
-- Insert trip record with new fields
INSERT INTO trips (
  driver_id, client_id, client_name, location, 
  duration, distance, start_time, end_time,
  start_latitude, start_longitude, 
  end_latitude, end_longitude,
  from_location, to_location
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

-- Add earnings record
INSERT INTO earnings (driver_id, trip_id, amount, earning_date)
VALUES (?, ?, ?, CURDATE());

-- Update wallet
UPDATE wallet 
SET balance = balance + ?,
    total_earned = total_earned + ?,
    updated_at = CURRENT_TIMESTAMP
WHERE driver_id = ?;
```

### **4. Logout Flow**
```sql
-- DELETE device session (not just deactivate)
DELETE FROM device_sessions 
WHERE driver_id = ? AND device_id = ?;
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
- `driver_locations.driver_id` - One location record per driver (enforced at app level)
- `device_sessions.unique_driver_device` - One active session per driver/device combination

### **2. FOREIGN KEY Constraints**
- `device_sessions.driver_id` → `drivers.id` (CASCADE on delete)
- `driver_locations.driver_id` → `drivers.id` (enforced at app level)
- `trips.driver_id` → `drivers.id` (CASCADE on delete)
- `trips.client_id` → `clients.id` (optional, can be NULL)
- `earnings.driver_id` → `drivers.id`
- `wallet.driver_id` → `drivers.id`
- `withdrawals.driver_id` → `drivers.id`

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

### **Get Recent Trip History with New Fields**
```sql
SELECT t.history_id, d.driver_name, t.client_name, 
       t.duration, t.distance, t.from_location, t.to_location,
       t.start_time, t.end_time
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.id
ORDER BY t.created_at DESC
LIMIT 20;
```

### **Get Trip with Client Details**
```sql
SELECT t.*, c.full_name, c.mobile_no, c.email
FROM trips t
LEFT JOIN clients c ON t.client_id = c.id
WHERE t.driver_id = ?
ORDER BY t.created_at DESC;
```

---

## ⚠️ Important Notes

1. **Single-Device Login**: Only one active session allowed per driver
2. **Location Updates**: Driver location updates every 5 seconds
3. **KYC Requirement**: Drivers must have `kyc_status = 'approved'` to see accidents
4. **UNIQUE Constraint**: `driver_locations.driver_id` ensures no duplicate location records
5. **Timezone**: All timestamps are in IST (Asia/Kolkata)
6. **Password Hashing**: Passwords stored using bcrypt ($2y$10$...) with backward compatibility for plain-text
7. **Trip Data Enhancement**: Trips now include `client_id`, `distance`, `from_location`, and `to_location`
8. **Device Sessions**: Sessions are **deleted** on logout, not just deactivated
9. **Character Sets**: Driver-related tables use `latin1`, while trips and other tables use `utf8mb4`

---

## 📁 Related Files

- **SQL Dump**: `database/edueyeco_apatkal2.sql` - Complete database structure
- **PHP Config**: `api/db_config.php` - Database connection settings
- **Flutter**: `lib/services/api_service_endpoints.dart` - API calls
- **Migration Script**: `database/add_trip_columns.sql` - Adds new trip columns

---

**Last Updated:** January 2025  
**Database Version:** 2.0.0
