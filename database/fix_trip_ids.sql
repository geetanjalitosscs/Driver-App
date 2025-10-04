-- Fix Trip IDs to match Accident IDs
-- This script will clean up any trips with timestamp-like IDs
-- and ensure all trips use the accident ID as the history_id

-- First, let's see what we have
SELECT 'Current trips with large IDs:' as info;
SELECT history_id, client_name, location, amount, created_at
FROM trips 
WHERE history_id > 1000000000
ORDER BY created_at DESC
LIMIT 10;

-- Delete trips with timestamp-like IDs (history_id > 1 billion)
-- These are likely created with timestamps instead of accident IDs
DELETE FROM trips WHERE history_id > 1000000000;

-- Verify deletion
SELECT 'Remaining trips:' as info;
SELECT history_id, client_name, location, amount, created_at
FROM trips 
ORDER BY created_at DESC
LIMIT 10;

-- Also clean up earnings for non-existent trips
DELETE FROM earnings WHERE trip_id NOT IN (SELECT history_id FROM trips);

-- Verify earnings cleanup
SELECT 'Remaining earnings:' as info;
SELECT trip_id, amount, earning_date, created_at
FROM earnings 
ORDER BY created_at DESC
LIMIT 10;


