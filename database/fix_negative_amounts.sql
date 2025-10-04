-- Fix negative amounts in trips table
-- This script will update any trips with negative amounts to positive amounts

-- First, let's see what we have
SELECT 'Trips with negative amounts:' as info;
SELECT history_id, client_name, location, amount, duration, created_at
FROM trips 
WHERE amount < 0
ORDER BY created_at DESC;

-- Update negative amounts to positive amounts
-- Use the formula: ₹500 + (duration * ₹5) or minimum ₹500
UPDATE trips 
SET amount = CASE 
    WHEN duration > 0 THEN 500.00 + (duration * 5.00)
    ELSE 500.00
END
WHERE amount < 0;

-- Verify the fix
SELECT 'Updated trips:' as info;
SELECT history_id, client_name, location, amount, duration, created_at
FROM trips 
WHERE history_id IN (
    SELECT history_id FROM trips WHERE amount < 0
)
ORDER BY created_at DESC;

-- Also fix earnings table for consistency
SELECT 'Earnings with negative amounts:' as info;
SELECT trip_id, amount, earning_date, created_at
FROM earnings 
WHERE amount < 0
ORDER BY created_at DESC;

-- Update negative earnings amounts
UPDATE earnings 
SET amount = CASE 
    WHEN EXISTS (
        SELECT 1 FROM trips t 
        WHERE t.history_id = earnings.trip_id 
        AND t.duration > 0
    ) THEN (
        SELECT 500.00 + (t.duration * 5.00) 
        FROM trips t 
        WHERE t.history_id = earnings.trip_id
    )
    ELSE 500.00
END
WHERE amount < 0;

-- Verify earnings fix
SELECT 'Updated earnings:' as info;
SELECT trip_id, amount, earning_date, created_at
FROM earnings 
WHERE trip_id IN (
    SELECT trip_id FROM earnings WHERE amount < 0
)
ORDER BY created_at DESC;

-- Final verification - show all trips and earnings
SELECT 'Final verification - All trips:' as info;
SELECT history_id, client_name, location, amount, duration, created_at
FROM trips 
ORDER BY created_at DESC
LIMIT 10;

SELECT 'Final verification - All earnings:' as info;
SELECT trip_id, amount, earning_date, created_at
FROM earnings 
ORDER BY created_at DESC
LIMIT 10;
