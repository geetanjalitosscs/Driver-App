-- Add trip_id column to earnings table
-- This will link earnings to specific trips

-- Step 1: Add trip_id column to earnings table
ALTER TABLE earnings 
ADD COLUMN trip_id INT NULL AFTER driver_id;

-- Step 2: Add foreign key constraint (optional - links to trips table)
-- ALTER TABLE earnings 
-- ADD CONSTRAINT fk_earnings_trip_id 
-- FOREIGN KEY (trip_id) REFERENCES trips(history_id) ON DELETE SET NULL;

-- Step 3: Update existing earnings records with trip_id values
-- Assuming trips 5, 6, 7, 8 exist and correspond to earnings records
UPDATE earnings SET trip_id = 5 WHERE id = 1;
UPDATE earnings SET trip_id = 6 WHERE id = 2;
UPDATE earnings SET trip_id = 7 WHERE id = 3;
UPDATE earnings SET trip_id = 8 WHERE id = 4;
UPDATE earnings SET trip_id = 9 WHERE id = 5;

-- Step 4: Verify the changes
SELECT 
    id,
    driver_id,
    trip_id,
    amount,
    earning_date,
    created_time
FROM earnings 
WHERE driver_id = 1
ORDER BY id;

-- Step 5: Show earnings with trip information (if trips table exists)
SELECT 
    e.id as earning_id,
    e.driver_id,
    e.trip_id,
    e.amount,
    e.earning_date,
    t.client_name,
    t.location
FROM earnings e
LEFT JOIN trips t ON e.trip_id = t.history_id
WHERE e.driver_id = 1
ORDER BY e.earning_date DESC;
