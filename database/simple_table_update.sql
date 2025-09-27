-- Simple SQL to update only your existing tables for location-based accident filtering
-- This adds location tracking to your existing drivers table

-- 1. Add location columns to your existing drivers table
ALTER TABLE drivers 
ADD COLUMN current_latitude DECIMAL(10, 8) NULL,
ADD COLUMN current_longitude DECIMAL(11, 8) NULL,
ADD COLUMN location_updated_at TIMESTAMP NULL;

-- 2. Add indexes for better performance
CREATE INDEX idx_drivers_location ON drivers(current_latitude, current_longitude);
CREATE INDEX idx_accidents_location ON accidents(latitude, longitude);

-- 3. Update your existing drivers with sample locations (Indore area)
UPDATE drivers 
SET 
    current_latitude = 22.7170,
    current_longitude = 75.8337,
    location_updated_at = NOW()
WHERE id = 1;

UPDATE drivers 
SET 
    current_latitude = 22.7200,
    current_longitude = 75.8400,
    location_updated_at = NOW()
WHERE id = 2;

-- That's it! Your existing tables now support location-based filtering
-- The API files will work with these updated tables
