-- Sample Data for Driver App Testing
-- This file contains sample data for testing the Driver App functionality

-- ============================================
-- 1. SAMPLE TRIPS DATA
-- ============================================

-- Insert sample trips for driver_id = 1
INSERT INTO trips (
    history_id, 
    driver_id, 
    client_name, 
    location, 
    timing, 
    amount, 
    duration, 
    start_time, 
    end_time, 
    created_at
) VALUES
-- Trip 1: September 20, 2025 (COMPLETED)
(10, 1, 'Priya Sharma', 'Apollo Hospital, Indore', '2025-09-20 14:30:00', 1800.00, 45, '2025-09-20 14:35:00', '2025-09-20 15:20:00', '2025-09-20 14:30:00'),

-- Trip 2: September 27, 2025 (COMPLETED)
(11, 1, 'Rajesh Kumar', 'Fortis Hospital, Bhopal', '2025-09-27 09:15:00', 2200.00, 60, '2025-09-27 09:20:00', '2025-09-27 10:20:00', '2025-09-27 09:15:00'),

-- Trip 3: October 1, 2025 (COMPLETED)
(12, 1, 'Meera Patel', 'Manipal Hospital, Jabalpur', '2025-10-01 16:45:00', 1950.00, 50, '2025-10-01 16:50:00', '2025-10-01 17:40:00', '2025-10-01 16:45:00'),

-- Trip 4: October 2, 2025 (PENDING/ONGOING)
(13, 1, 'Vikram Singh', 'AIIMS Hospital, Delhi', '2025-10-02 11:30:00', 2800.00, 75, '2025-10-02 11:35:00', NULL, '2025-10-02 11:30:00');

-- ============================================
-- 2. SAMPLE EARNINGS DATA
-- ============================================

-- Insert earnings for completed trips only
INSERT INTO earnings (driver_id, trip_id, amount, earning_date, created_time) VALUES
(1, 10, 1800.00, '2025-09-20', '2025-09-20 15:20:00'),
(1, 11, 2200.00, '2025-09-27', '2025-09-27 10:20:00'),
(1, 12, 1950.00, '2025-10-01', '2025-10-01 17:40:00');

-- ============================================
-- 3. SAMPLE WALLET DATA
-- ============================================

-- Update wallet for driver_id = 1
INSERT INTO wallet (driver_id, balance, total_earned, total_withdrawn, created_at, updated_at) 
VALUES (1, 5950.00, 5950.00, 0.00, '2025-08-01 10:00:00', '2025-10-01 17:40:00')
ON DUPLICATE KEY UPDATE
    balance = balance + 5950.00,
    total_earned = total_earned + 5950.00,
    updated_at = '2025-10-01 17:40:00';

-- ============================================
-- 4. SAMPLE WITHDRAWALS DATA
-- ============================================

-- Insert withdrawal requests
INSERT INTO withdrawals (
    driver_id, 
    amount, 
    bank_account_number, 
    bank_name, 
    ifsc_code, 
    account_holder_name, 
    status, 
    requested_at, 
    processed_at
)
VALUES
(1, 1000.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-09-21 10:30:00', '2025-09-22 14:20:00'),
(1, 1500.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-09-28 11:15:00', '2025-09-29 16:30:00'),
(1, 1200.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-10-02 09:45:00', '2025-10-02 09:45:00');

-- ============================================
-- 5. VERIFICATION QUERIES
-- ============================================

-- Check trips data
SELECT 
    history_id,
    client_name,
    location,
    DATE(timing) as trip_date,
    amount,
    duration,
    start_time,
    end_time,
    CASE 
        WHEN end_time IS NULL THEN 'PENDING/ONGOING'
        ELSE 'COMPLETED'
    END as trip_status
FROM trips 
WHERE driver_id = 1 
ORDER BY timing;

-- Check earnings data
SELECT 
    id,
    trip_id,
    amount,
    earning_date,
    created_time
FROM earnings 
WHERE driver_id = 1 
ORDER BY earning_date;

-- Check wallet data
SELECT 
    driver_id,
    balance,
    total_earned,
    total_withdrawn,
    updated_at
FROM wallet 
WHERE driver_id = 1;

-- Check withdrawals data
SELECT 
    withdrawal_id,
    amount,
    status,
    requested_at,
    processed_at,
    notes
FROM withdrawals 
WHERE driver_id = 1 
ORDER BY requested_at;

-- ============================================
-- 6. SUMMARY QUERIES
-- ============================================

-- Trip summary
SELECT 
    COUNT(*) as total_trips,
    COUNT(CASE WHEN end_time IS NOT NULL THEN 1 END) as completed_trips,
    COUNT(CASE WHEN end_time IS NULL THEN 1 END) as pending_trips,
    SUM(CASE WHEN end_time IS NOT NULL THEN amount ELSE 0 END) as completed_trips_amount,
    SUM(CASE WHEN end_time IS NULL THEN amount ELSE 0 END) as pending_trips_amount
FROM trips 
WHERE driver_id = 1;

-- Total earnings
SELECT 
    SUM(amount) as total_earnings,
    COUNT(*) as trip_count,
    AVG(amount) as average_per_trip
FROM earnings 
WHERE driver_id = 1;

-- Total withdrawals
SELECT 
    SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) as completed_withdrawals,
    SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END) as pending_withdrawals,
    COUNT(*) as total_withdrawal_requests
FROM withdrawals 
WHERE driver_id = 1;

-- Wallet balance
SELECT 
    w.balance as current_balance,
    w.total_earned as total_earned,
    w.total_withdrawn as total_withdrawn,
    (w.total_earned - w.total_withdrawn) as calculated_balance
FROM wallet w
WHERE w.driver_id = 1;



-- Add KYC status column to drivers table
ALTER TABLE drivers ADD COLUMN kyc_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending';

-- Update existing drivers to have 'approved' status (assuming they were already verified)
UPDATE drivers SET kyc_status = 'approved' WHERE kyc_status IS NULL;

-- Add index for better performance
CREATE INDEX idx_drivers_kyc_status ON drivers(kyc_status);




-- Fix drivers table AUTO_INCREMENT issue
-- This will resolve the "Duplicate entry '0' for key 'PRIMARY'" error

-- First, check if there are any records with id = 0 and delete them
DELETE FROM drivers WHERE id = 0;

-- Add AUTO_INCREMENT to the id field
ALTER TABLE drivers MODIFY COLUMN id int(11) NOT NULL AUTO_INCREMENT;

-- Add kyc_status column if it doesn't exist
ALTER TABLE drivers ADD COLUMN IF NOT EXISTS kyc_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending';

-- Set the AUTO_INCREMENT to start from 1 (in case there are existing records)
-- Get the maximum id and set AUTO_INCREMENT to max + 1
SET @max_id = (SELECT COALESCE(MAX(id), 0) FROM drivers);
SET @sql = CONCAT('ALTER TABLE drivers AUTO_INCREMENT = ', @max_id + 1);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verify the fix
SHOW CREATE TABLE drivers;


