-- SQL to update existing tables for location-based accident filtering
-- This adds location tracking capabilities to your existing tables

-- 1. Add location tracking columns to drivers table
ALTER TABLE drivers 
ADD COLUMN current_latitude DECIMAL(10, 8) NULL,
ADD COLUMN current_longitude DECIMAL(11, 8) NULL,
ADD COLUMN location_updated_at TIMESTAMP NULL;

-- 2. Add indexes for better performance on location queries
CREATE INDEX idx_drivers_location ON drivers(current_latitude, current_longitude);
CREATE INDEX idx_accidents_location ON accidents(latitude, longitude);
CREATE INDEX idx_accidents_status_location ON accidents(status, latitude, longitude);

-- 3. Add location tracking to trips table (optional - for trip tracking)
ALTER TABLE trips 
ADD COLUMN start_latitude DECIMAL(10, 8) NULL,
ADD COLUMN start_longitude DECIMAL(11, 8) NULL,
ADD COLUMN end_latitude DECIMAL(10, 8) NULL,
ADD COLUMN end_longitude DECIMAL(11, 8) NULL;

-- 4. Create a view for nearby accidents (within 10km)
CREATE VIEW nearby_accidents AS
SELECT 
    a.id,
    a.fullname,
    a.phone,
    a.vehicle,
    a.accident_date,
    a.location,
    a.latitude,
    a.longitude,
    a.description,
    a.created_at,
    a.status,
    d.id as driver_id,
    d.driver_name,
    (
        6371 * acos(
            cos(radians(d.current_latitude)) * 
            cos(radians(a.latitude)) * 
            cos(radians(a.longitude) - radians(d.current_longitude)) + 
            sin(radians(d.current_latitude)) * 
            sin(radians(a.latitude))
        )
    ) AS distance_km
FROM accidents a
CROSS JOIN drivers d
WHERE a.status = 'pending'
  AND d.current_latitude IS NOT NULL 
  AND d.current_longitude IS NOT NULL
HAVING distance_km <= 10.0
ORDER BY d.id, distance_km ASC;

-- 5. Create a stored procedure to update driver location
DELIMITER $$
CREATE PROCEDURE UpdateDriverLocation(
    IN p_driver_id INT,
    IN p_latitude DECIMAL(10, 8),
    IN p_longitude DECIMAL(11, 8),
    IN p_address TEXT
)
BEGIN
    UPDATE drivers 
    SET 
        current_latitude = p_latitude,
        current_longitude = p_longitude,
        location_updated_at = NOW()
    WHERE id = p_driver_id;
    
    SELECT 'Location updated successfully' as message;
END$$
DELIMITER ;

-- 6. Create a stored procedure to get nearby accidents for a driver
DELIMITER $$
CREATE PROCEDURE GetNearbyAccidentsForDriver(
    IN p_driver_id INT
)
BEGIN
    SELECT 
        a.id,
        a.fullname,
        a.phone,
        a.vehicle,
        a.accident_date,
        a.location,
        a.latitude,
        a.longitude,
        a.description,
        a.created_at,
        a.status,
        ROUND((
            6371 * acos(
                cos(radians(d.current_latitude)) * 
                cos(radians(a.latitude)) * 
                cos(radians(a.longitude) - radians(d.current_longitude)) + 
                sin(radians(d.current_latitude)) * 
                sin(radians(a.latitude))
            )
        ), 2) AS distance_km
    FROM accidents a
    CROSS JOIN drivers d
    WHERE a.status = 'pending'
      AND d.id = p_driver_id
      AND d.current_latitude IS NOT NULL 
      AND d.current_longitude IS NOT NULL
    HAVING distance_km <= 10.0
    ORDER BY distance_km ASC, a.created_at DESC
    LIMIT 50;
END$$
DELIMITER ;

-- 7. Update existing drivers with sample locations (Indore area)
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

-- 8. Add trigger to automatically update location timestamp
DELIMITER $$
CREATE TRIGGER update_driver_location_timestamp 
BEFORE UPDATE ON drivers
FOR EACH ROW
BEGIN
    IF NEW.current_latitude != OLD.current_latitude OR 
       NEW.current_longitude != OLD.current_longitude THEN
        SET NEW.location_updated_at = NOW();
    END IF;
END$$
DELIMITER ;

-- 9. Create a function to calculate distance between two points
DELIMITER $$
CREATE FUNCTION CalculateDistance(
    lat1 DECIMAL(10, 8), 
    lon1 DECIMAL(11, 8), 
    lat2 DECIMAL(10, 8), 
    lon2 DECIMAL(11, 8)
) RETURNS DECIMAL(10, 2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE distance DECIMAL(10, 2);
    
    SET distance = (
        6371 * acos(
            cos(radians(lat1)) * 
            cos(radians(lat2)) * 
            cos(radians(lon2) - radians(lon1)) + 
            sin(radians(lat1)) * 
            sin(radians(lat2))
        )
    );
    
    RETURN ROUND(distance, 2);
END$$
DELIMITER ;

-- 10. Add comments to document the changes
ALTER TABLE drivers COMMENT = 'Drivers table with location tracking for nearby accident filtering';
ALTER TABLE accidents COMMENT = 'Accidents table with coordinates for location-based filtering';

-- Show summary of changes
SELECT 'Database updated successfully for location-based accident filtering' as status;
SELECT 'Added location columns to drivers table' as change_1;
SELECT 'Added indexes for performance' as change_2;
SELECT 'Created nearby_accidents view' as change_3;
SELECT 'Created stored procedures for location updates' as change_4;
SELECT 'Added distance calculation function' as change_5;
SELECT 'Fixed radius set to 10km' as note;
