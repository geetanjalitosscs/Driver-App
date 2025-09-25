-- Sample Data for Earnings and Wallet Tables
-- This SQL will add realistic data to show in the Driver App
-- Run this after setting up the basic database structure

-- ============================================
-- 1. EARNINGS TABLE DATA
-- ============================================

-- Insert sample earnings for driver_id = 1 (assuming this driver exists)
-- Recent earnings (5 records) - linked to trips 5, 6, 7, 8, 9
INSERT INTO earnings (driver_id, trip_id, amount, earning_date, created_time) VALUES
(1, 5, 1500.00, '2025-09-25', '2025-09-25 18:30:00'),
(1, 6, 2200.00, '2025-09-24', '2025-09-24 19:15:00'),
(1, 7, 1800.00, '2025-09-23', '2025-09-23 17:45:00'),
(1, 8, 2500.00, '2025-09-22', '2025-09-22 20:00:00'),
(1, 9, 1200.00, '2025-09-21', '2025-09-21 16:30:00');

-- ============================================
-- 2. WALLET TABLE DATA
-- ============================================

-- Insert/Update wallet data for driver_id = 1
INSERT INTO wallet (driver_id, balance, total_earned, total_withdrawn, created_at, updated_at) 
VALUES (1, 12500.00, 9200.00, 0.00, '2025-08-01 10:00:00', '2025-09-25 18:30:00')
ON DUPLICATE KEY UPDATE
    balance = 12500.00,
    total_earned = 9200.00,
    total_withdrawn = 0.00,
    updated_at = '2025-09-25 18:30:00';

-- ============================================
-- 3. WITHDRAWALS TABLE DATA
-- ============================================

-- Insert sample withdrawal requests for driver_id = 1 (5 records)
INSERT INTO withdrawals (
    driver_id, 
    amount, 
    bank_account_number, 
    bank_name, 
    ifsc_code, 
    account_holder_name, 
    status, 
    requested_at, 
    processed_at,
    notes
) VALUES
(1, 5000.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'John Driver', 'completed', '2025-09-20 10:30:00', '2025-09-21 14:20:00', 'Monthly withdrawal - September'),
(1, 3000.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'John Driver', 'completed', '2025-09-15 16:45:00', '2025-09-16 11:30:00', 'Emergency withdrawal'),
(1, 4000.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'John Driver', 'pending', '2025-09-25 18:30:00', NULL, 'Current withdrawal request'),
(1, 6000.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'John Driver', 'completed', '2025-09-05 14:20:00', '2025-09-06 10:15:00', 'Weekly withdrawal'),
(1, 2500.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'John Driver', 'completed', '2025-08-30 11:45:00', '2025-08-31 09:30:00', 'Emergency withdrawal');

-- ============================================
-- 4. WALLET TRANSACTIONS TABLE DATA (if exists)
-- ============================================

-- Insert sample wallet transactions to track all wallet activities (5 records)
INSERT INTO wallet_transactions (
    driver_id, 
    amount, 
    type, 
    description, 
    reference_id, 
    created_at
) VALUES
(1, 1500.00, 'credit', 'Trip completion - Trip #5', '5', '2025-09-25 18:30:00'),
(1, 2200.00, 'credit', 'Trip completion - Trip #6', '6', '2025-09-24 19:15:00'),
(1, 1800.00, 'credit', 'Trip completion - Trip #7', '7', '2025-09-23 17:45:00'),
(1, 4000.00, 'debit', 'Withdrawal request - Pending', 'WD001', '2025-09-25 18:30:00'),
(1, 5000.00, 'debit', 'Withdrawal completed', 'WD002', '2025-09-21 14:20:00');

-- ============================================
-- 5. VERIFICATION QUERIES
-- ============================================

-- Check earnings data
SELECT 
    COUNT(*) as total_earnings_records,
    SUM(amount) as total_earnings_amount,
    MIN(earning_date) as earliest_date,
    MAX(earning_date) as latest_date
FROM earnings 
WHERE driver_id = 1;

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
    COUNT(*) as total_withdrawals,
    SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) as completed_amount,
    SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END) as pending_amount,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_count
FROM withdrawals 
WHERE driver_id = 1;

-- Check wallet transactions (if table exists)
SELECT 
    COUNT(*) as total_transactions,
    SUM(CASE WHEN type = 'credit' THEN amount ELSE 0 END) as total_credits,
    SUM(CASE WHEN type = 'debit' THEN amount ELSE 0 END) as total_debits
FROM wallet_transactions 
WHERE driver_id = 1;
