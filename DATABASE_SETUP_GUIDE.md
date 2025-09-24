# Database Setup Guide for Driver App

This guide will help you set up the complete database structure for your Driver App with all necessary tables and sample data.

## Prerequisites

- MySQL/MariaDB server running
- phpMyAdmin or MySQL command line access
- Database: `edueyeco_apatkal` (or your preferred database name)

## Quick Setup (Recommended)

1. **Import the quick setup script:**
   ```sql
   -- Run this in phpMyAdmin or MySQL command line
   source quick_database_setup.sql;
   ```

2. **Verify tables were created:**
   ```sql
   SHOW TABLES;
   ```

## Complete Setup (Advanced)

If you need all features including notifications, emergency requests, and trip tracking:

1. **Import the complete setup script:**
   ```sql
   source complete_database_setup.sql;
   ```

## Database Structure

### Core Tables

#### 1. **drivers** - Driver information
- `id` (Primary Key)
- `driver_name`, `email`, `password`, `number`
- `aadhar_photo`, `licence_photo`, `rc_photo`
- `created_at`, `updated_at`

#### 2. **trips** - Trip history records
- `history_id` (Primary Key)
- `driver_id` (Foreign Key)
- `client_name`, `location`
- `timing`, `amount`, `duration`
- `start_time`, `end_time`
- `created_at`

#### 3. **earnings** - Driver earnings
- `id` (Primary Key)
- `driver_id` (Foreign Key)
- `amount`, `earning_date`
- `created_time`

#### 4. **wallet** - Driver wallet balance
- `wallet_id` (Primary Key)
- `driver_id` (Foreign Key, Unique)
- `balance`, `total_earned`, `total_withdrawn`

#### 5. **withdrawals** - Withdrawal requests
- `withdrawal_id` (Primary Key)
- `driver_id` (Foreign Key)
- `amount`, `bank_account_number`, `bank_name`, `ifsc_code`, `account_holder_name`
- `status` (pending/approved/rejected/completed)
- `requested_at`, `processed_at`

#### 6. **accidents** - Accident reports
- `id` (Primary Key)
- `driver_id`, `trip_id` (Foreign Keys)
- `location`, `latitude`, `longitude`
- `description`, `severity` (minor/moderate/severe)
- `status` (pending/investigating/resolved/rejected)
- `reported_at`, `resolved_at`

### Additional Tables (Complete Setup Only)

- **accident_photos** - Photos for accident reports
- **emergency_requests** - Emergency service requests
- **notifications** - Driver notifications
- **trip_locations** - Real-time trip tracking

## Sample Data Included

The setup scripts include:

### Sample Drivers (3 drivers)
- John Smith (Driver ID: 1) - Online, 25 trips, $1,250 earnings
- Sarah Johnson (Driver ID: 2) - Offline, 18 trips, $980 earnings  
- Mike Wilson (Driver ID: 3) - Online, 32 trips, $1,680 earnings

### Sample Trips (10 recent trips)
- Mix of emergency, regular, and scheduled trips
- Various statuses (completed, pending, etc.)
- Realistic fare amounts ($28-$45)
- Different locations and distances

### Sample Earnings
- Corresponding earnings for each completed trip
- Recent dates (last 4 days)
- Realistic amounts

### Sample Wallet Data
- Current balances for each driver
- Total earned amounts
- Withdrawal history

### Sample Withdrawals
- Different statuses (pending, approved, completed)
- Various bank details
- Recent withdrawal requests

### Sample Accidents
- All with `status = 'pending'` (as requested)
- Different severity levels
- Associated with trips or standalone

## Testing Your Setup

1. **Check accident reports filter:**
   ```sql
   SELECT * FROM accidents WHERE status = 'pending';
   ```

2. **Check recent trips:**
   ```sql
   SELECT * FROM trips ORDER BY created_at DESC LIMIT 5;
   ```

3. **Check earnings:**
   ```sql
   SELECT * FROM earnings ORDER BY earning_date DESC;
   ```

4. **Check wallet balances:**
   ```sql
   SELECT d.fullname, w.balance, w.total_earned, w.total_withdrawn 
   FROM drivers d 
   JOIN wallet w ON d.driver_id = w.driver_id;
   ```

## Database Configuration

Update your PHP files to use the correct database credentials:

```php
$host = "localhost";
$dbname = "edueyeco_apatkal";  // Your database name
$username = "root";            // Your MySQL username
$password = "";                // Your MySQL password
```

## Troubleshooting

### Common Issues:

1. **Foreign Key Constraints:**
   - Make sure to create tables in the correct order
   - Check that referenced tables exist before creating foreign keys

2. **Sample Data Conflicts:**
   - If you get duplicate key errors, the data might already exist
   - Use `TRUNCATE TABLE` to clear existing data before inserting

3. **Character Set Issues:**
   - Ensure your database uses UTF-8 encoding
   - Check that special characters display correctly

### Reset Database:
```sql
-- Drop all tables (be careful!)
DROP TABLE IF EXISTS accident_photos, accidents, emergency_requests, notifications, trip_locations, withdrawals, wallet, earnings, trips, drivers;
```

## Next Steps

After setting up the database:

1. **Test the Flutter app** - All screens should now show real data
2. **Verify accident reports** - Should only show pending accidents
3. **Check earnings page** - Should display recent earnings
4. **Test wallet functionality** - Should show balances and withdrawal history
5. **Verify trip history** - Should show completed trips

Your Driver App database is now ready! 🚀
