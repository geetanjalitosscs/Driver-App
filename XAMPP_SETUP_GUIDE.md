# XAMPP Setup Guide for Driver App

## Step 1: Start XAMPP Services

1. **Open XAMPP Control Panel**
2. **Start Apache** (if not already running)
3. **Start MySQL** (if not already running)
4. Both should show green "Running" status

## Step 2: Access phpMyAdmin

1. **Open your web browser**
2. **Go to:** `http://localhost/phpmyadmin`
3. **Login:** 
   - Username: `root`
   - Password: (leave empty - no password)

## Step 3: Create Database and Table

### Option A: Use the SQL Script
1. In phpMyAdmin, click **"SQL"** tab
2. Copy and paste the contents of `database_setup.sql`
3. Click **"Go"** to execute

### Option B: Manual Setup
1. **Create Database:**
   - Click "New" in left sidebar
   - Database name: `apatkal`
   - Click "Create"

2. **Create Table:**
   - Select `apatkal` database
   - Click "SQL" tab
   - Paste this SQL:

```sql
CREATE TABLE accidents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    vehicle VARCHAR(255) NOT NULL,
    accident_date DATETIME NOT NULL,
    location VARCHAR(500) NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    description TEXT,
    photo VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'accepted', 'rejected', 'cancelled') DEFAULT 'pending'
);
```

3. **Add Sample Data:**
```sql
INSERT INTO accidents (fullname, phone, vehicle, accident_date, location, latitude, longitude, description, status) VALUES
('John Doe', '1234567890', 'Toyota Camry', '2024-01-15 10:30:00', 'Main Street, Indore', 22.7196, 75.8577, 'Car accident on main road', 'pending'),
('Jane Smith', '0987654321', 'Honda Civic', '2024-01-15 11:45:00', 'Park Avenue, Indore', 22.7200, 75.8580, 'Collision at intersection', 'pending'),
('Mike Johnson', '1122334455', 'Ford Focus', '2024-01-15 12:15:00', 'Central Plaza, Indore', 22.7190, 75.8570, 'Rear-end collision', 'pending');
```

## Step 4: Verify Setup

1. **Check if database exists:**
   - Look for `apatkal` in left sidebar

2. **Check if table exists:**
   - Click on `apatkal` database
   - Look for `accidents` table

3. **Check if data exists:**
   - Click on `accidents` table
   - Click "Browse" tab
   - You should see 3 records with status "pending"

## Step 5: Test Connection

1. **Run your Flutter app**
2. **Go Online** in the app
3. **Click "View Accident Reports"**
4. **Check console output** for debug information

## Troubleshooting

### If MySQL won't start:
- Check if port 3306 is already in use
- Restart XAMPP
- Check Windows Firewall settings

### If phpMyAdmin shows error:
- Make sure Apache is running
- Try `http://127.0.0.1/phpmyadmin`

### If connection fails:
- Verify MySQL is running in XAMPP
- Check that port 3306 is accessible
- Try connecting with MySQL command line:
  ```
  mysql -u root -p
  ```
  (Press Enter when asked for password - leave empty)

## XAMPP Default Settings:
- **Host:** localhost or 127.0.0.1
- **Port:** 3306
- **Username:** root
- **Password:** (empty)
- **phpMyAdmin:** http://localhost/phpmyadmin
