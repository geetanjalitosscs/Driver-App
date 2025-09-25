-- Complete Database Setup for Driver App
-- Run this script to create all tables and insert sample data

-- Create database (uncomment if needed)
-- CREATE DATABASE IF NOT EXISTS edueyeco_apatkal;
-- USE edueyeco_apatkal;

-- 1. DRIVERS TABLE
CREATE TABLE IF NOT EXISTS drivers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    number VARCHAR(15) NOT NULL,
    address VARCHAR(255) NULL,
    vehicle_type VARCHAR(50) NULL,
    vehicle_number VARCHAR(20) NULL,
    model_rating DECIMAL(2,1) NULL,
    aadhar_photo VARCHAR(255) NOT NULL,
    licence_photo VARCHAR(255) NOT NULL,
    rc_photo VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. TRIPS TABLE (Trip History)
CREATE TABLE IF NOT EXISTS trips (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    client_name VARCHAR(100) NOT NULL,
    location TEXT NOT NULL,
    timing TIMESTAMP NULL,
    amount DECIMAL(8,2) NOT NULL,
    duration INT NOT NULL, -- in minutes
    start_time TIMESTAMP NULL,
    end_time TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);

-- 3. EARNINGS TABLE
CREATE TABLE IF NOT EXISTS earnings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    earning_date DATE NOT NULL,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);

-- 4. WALLET TABLE
CREATE TABLE IF NOT EXISTS wallet (
    wallet_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL UNIQUE,
    balance DECIMAL(10,2) NULL DEFAULT 0.00,
    total_earned DECIMAL(10,2) NULL DEFAULT 0.00,
    total_withdrawn DECIMAL(10,2) NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);

-- 5. WITHDRAWALS TABLE
CREATE TABLE IF NOT EXISTS withdrawals (
    withdrawal_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    bank_account_number VARCHAR(20) NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    ifsc_code VARCHAR(15) NOT NULL,
    account_holder_name VARCHAR(100) NOT NULL,
    status ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending',
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP NULL,
    notes TEXT NULL,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);

-- 6. ACCIDENTS TABLE
CREATE TABLE IF NOT EXISTS accidents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    trip_id INT NULL,
    location VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    description TEXT NOT NULL,
    severity ENUM('minor', 'moderate', 'severe') DEFAULT 'minor',
    status ENUM('pending', 'investigating', 'resolved', 'rejected') DEFAULT 'pending',
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id) ON DELETE SET NULL
);

-- 7. ACCIDENT_PHOTOS TABLE
CREATE TABLE IF NOT EXISTS accident_photos (
    photo_id INT PRIMARY KEY AUTO_INCREMENT,
    accident_id INT NOT NULL,
    photo VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (accident_id) REFERENCES accidents(id) ON DELETE CASCADE
);

-- 8. EMERGENCY_REQUESTS TABLE
CREATE TABLE IF NOT EXISTS emergency_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    emergency_type ENUM('medical', 'police', 'fire', 'other') NOT NULL,
    location VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('pending', 'responded', 'resolved') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

-- 9. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('trip', 'earning', 'withdrawal', 'emergency', 'system') DEFAULT 'system',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

-- 10. TRIP_LOCATIONS TABLE (for tracking trip progress)
CREATE TABLE IF NOT EXISTS trip_locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    trip_id INT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE
);

-- Insert Sample Data

-- Sample Drivers
INSERT INTO drivers (id, driver_name, email, password, number, address, vehicle_type, vehicle_number, model_rating, aadhar_photo, licence_photo, rc_photo) VALUES
(1, 'John Smith', 'john.smith@email.com', 'password123', '+1234567890', '123 Main Street, Downtown', 'ambulance', 'AMB001', 4.8, 'aadhar_john.jpg', 'licence_john.jpg', 'rc_john.jpg'),
(2, 'Sarah Johnson', 'sarah.johnson@email.com', 'password123', '+1234567891', '456 Oak Avenue, Suburbs', 'ambulance', 'AMB002', 4.9, 'aadhar_sarah.jpg', 'licence_sarah.jpg', 'rc_sarah.jpg'),
(3, 'Mike Wilson', 'mike.wilson@email.com', 'password123', '+1234567892', '789 Pine Street, Residential', 'ambulance', 'AMB003', 4.7, 'aadhar_mike.jpg', 'licence_mike.jpg', 'rc_mike.jpg');

-- Sample Trips (Trip History)
INSERT INTO trips (history_id, driver_id, client_name, location, timing, amount, duration, start_time, end_time) VALUES
(1, 1, 'Alice Brown', '123 Main Street, Downtown to 456 Hospital Road, Medical District', '2024-01-15 09:30:00', 45.50, 28, '2024-01-15 09:30:00', '2024-01-15 09:58:00'),
(2, 1, 'Bob Davis', '789 Oak Avenue, Suburbs to 321 Emergency Center, City Center', '2024-01-15 14:15:00', 32.00, 22, '2024-01-15 14:15:00', '2024-01-15 14:37:00'),
(3, 2, 'Carol White', '555 Pine Street, Residential to 999 Medical Plaza, Downtown', '2024-01-15 11:45:00', 38.75, 25, '2024-01-15 11:45:00', '2024-01-15 12:10:00'),
(4, 1, 'David Lee', '888 Elm Street, Business District to 777 Health Center, Suburbs', '2024-01-16 08:00:00', 28.50, 20, '2024-01-16 08:00:00', '2024-01-16 08:20:00'),
(5, 3, 'Emma Taylor', '222 Maple Drive, Residential to 444 Emergency Room, Medical District', '2024-01-16 13:20:00', 42.00, 30, '2024-01-16 13:20:00', '2024-01-16 13:50:00'),
(6, 2, 'Frank Miller', '333 Cedar Lane, Suburbs to 666 Trauma Center, Downtown', '2024-01-16 16:30:00', 35.25, 26, '2024-01-16 16:30:00', '2024-01-16 16:56:00'),
(7, 1, 'Grace Wilson', '111 Birch Street, Residential to 555 Medical Center, Business District', '2024-01-17 10:15:00', 41.50, 28, '2024-01-17 10:15:00', '2024-01-17 10:43:00'),
(8, 3, 'Henry Brown', '777 Spruce Avenue, Suburbs to 888 Health Clinic, Residential', '2024-01-17 15:45:00', 29.75, 22, '2024-01-17 15:45:00', '2024-01-17 16:07:00'),
(9, 2, 'Ivy Davis', '444 Oak Street, Downtown to 222 Emergency Ward, Medical District', '2024-01-17 19:20:00', 39.00, 27, '2024-01-17 19:20:00', '2024-01-17 19:47:00'),
(10, 1, 'Jack Smith', '999 Pine Road, Residential to 111 Medical Facility, Business District', '2024-01-18 07:30:00', 33.50, 24, '2024-01-18 07:30:00', '2024-01-18 07:54:00');

-- Sample Earnings
INSERT INTO earnings (id, driver_id, amount, earning_date, created_time) VALUES
(1, 1, 45.50, '2024-01-15', '2024-01-15 09:58:00'),
(2, 1, 32.00, '2024-01-15', '2024-01-15 14:37:00'),
(3, 2, 38.75, '2024-01-15', '2024-01-15 12:10:00'),
(4, 1, 28.50, '2024-01-16', '2024-01-16 08:20:00'),
(5, 3, 42.00, '2024-01-16', '2024-01-16 13:50:00'),
(6, 2, 35.25, '2024-01-16', '2024-01-16 16:56:00'),
(7, 1, 41.50, '2024-01-17', '2024-01-17 10:43:00'),
(8, 3, 29.75, '2024-01-17', '2024-01-17 16:07:00'),
(9, 2, 39.00, '2024-01-17', '2024-01-17 19:47:00'),
(10, 1, 33.50, '2024-01-18', '2024-01-18 07:54:00');

-- Sample Wallet Data
INSERT INTO wallet (driver_id, balance, total_earned, total_withdrawn) VALUES
(1, 180.50, 180.50, 0.00),
(2, 112.00, 112.00, 0.00),
(3, 71.75, 71.75, 0.00);

-- Sample Withdrawals
INSERT INTO withdrawals (driver_id, amount, bank_account_number, bank_name, ifsc_code, account_holder_name, status, requested_at, processed_at) VALUES
(1, 100.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'John Smith', 'completed', '2024-01-10 10:30:00', '2024-01-11 09:15:00'),
(2, 50.00, '2345678901234567', 'HDFC Bank', 'HDFC0001234', 'Sarah Johnson', 'pending', '2024-01-18 14:20:00', NULL),
(3, 75.00, '3456789012345678', 'ICICI Bank', 'ICIC0001234', 'Mike Wilson', 'approved', '2024-01-17 16:45:00', '2024-01-18 10:30:00');

-- Sample Accidents
INSERT INTO accidents (driver_id, trip_id, location, latitude, longitude, description, severity, status, reported_at) VALUES
(1, 1, '123 Main Street, Downtown', 40.7128, -74.0060, 'Minor collision with another vehicle while responding to emergency call', 'minor', 'pending', '2024-01-15 09:35:00'),
(2, NULL, '456 Hospital Road, Medical District', 40.7589, -73.9851, 'Vehicle breakdown during regular operation', 'minor', 'pending', '2024-01-16 11:20:00'),
(3, 5, '222 Maple Drive, Residential', 40.7831, -73.9712, 'Accident occurred while transporting patient', 'moderate', 'pending', '2024-01-16 13:25:00');

-- Sample Emergency Requests
INSERT INTO emergency_requests (driver_id, emergency_type, location, latitude, longitude, description, status, created_at) VALUES
(1, 'medical', '789 Oak Avenue, Suburbs', 40.7505, -73.9934, 'Patient requires immediate medical attention', 'resolved', '2024-01-15 14:20:00'),
(2, 'police', '555 Pine Street, Residential', 40.7831, -73.9712, 'Security incident reported', 'responded', '2024-01-16 12:30:00'),
(3, 'fire', '888 Elm Street, Business District', 40.7589, -73.9851, 'Fire emergency in building', 'pending', '2024-01-17 15:45:00');

-- Sample Notifications
INSERT INTO notifications (driver_id, title, message, type, is_read, created_at) VALUES
(1, 'New Trip Request', 'You have a new trip request from Alice Brown', 'trip', FALSE, '2024-01-15 09:25:00'),
(1, 'Trip Completed', 'Your trip to Hospital Road has been completed. Earnings: $45.50', 'earning', TRUE, '2024-01-15 09:58:00'),
(2, 'Withdrawal Approved', 'Your withdrawal request of $50.00 has been approved', 'withdrawal', FALSE, '2024-01-18 10:30:00'),
(3, 'Emergency Alert', 'Emergency request in your area', 'emergency', FALSE, '2024-01-17 15:45:00');

-- Sample Trip Locations (for tracking)
INSERT INTO trip_locations (trip_id, latitude, longitude, timestamp) VALUES
(1, 40.7128, -74.0060, '2024-01-15 09:30:00'),
(1, 40.7200, -74.0100, '2024-01-15 09:35:00'),
(1, 40.7300, -74.0200, '2024-01-15 09:40:00'),
(1, 40.7400, -74.0300, '2024-01-15 09:45:00'),
(1, 40.7500, -74.0400, '2024-01-15 09:50:00'),
(1, 40.7589, -73.9851, '2024-01-15 09:58:00');

-- Create Indexes for better performance
CREATE INDEX idx_trips_driver_id ON trips(driver_id);
CREATE INDEX idx_trips_status ON trips(status);
CREATE INDEX idx_trips_created_at ON trips(created_at);
CREATE INDEX idx_earnings_driver_id ON earnings(driver_id);
CREATE INDEX idx_earnings_date ON earnings(earning_date);
CREATE INDEX idx_withdrawals_driver_id ON withdrawals(driver_id);
CREATE INDEX idx_withdrawals_status ON withdrawals(status);
CREATE INDEX idx_accidents_status ON accidents(status);
CREATE INDEX idx_notifications_driver_id ON notifications(driver_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

-- Update driver statistics
UPDATE drivers SET 
    total_trips = (SELECT COUNT(*) FROM trips WHERE driver_id = drivers.driver_id AND status = 'completed'),
    total_earnings = (SELECT COALESCE(SUM(amount), 0) FROM earnings WHERE driver_id = drivers.driver_id);

-- Update wallet balances
UPDATE wallet SET 
    total_earned = (SELECT COALESCE(SUM(amount), 0) FROM earnings WHERE driver_id = wallet.driver_id),
    balance = total_earned - total_withdrawn;

COMMIT;



// trip insertion

INSERT INTO trips (
    driver_id,
    client_name,
    location,
    timing,
    amount,
    duration,
    start_time,
    end_time,
    created_at
) VALUES (
    1,  -- driver_id (assuming driver ID 1)
    'Sarah Johnson',
    'Apollo Hospital, Bengaluru',
    '2025-09-25 09:00:00',  -- timing
    1800,  -- amount
    50,    -- duration in minutes
    '2025-09-25 09:05:00',  -- start_time
    '2025-09-25 09:55:00',  -- end_time (completed trip)
    '2025-09-25 10:00:00'   -- created_at (today)
);