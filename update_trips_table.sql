-- Update trips table to include location tracking fields
-- Run this script to add the new columns to your existing trips table

ALTER TABLE trips 
ADD COLUMN start_latitude DECIMAL(10, 8) NULL,
ADD COLUMN start_longitude DECIMAL(11, 8) NULL,
ADD COLUMN end_latitude DECIMAL(10, 8) NULL,
ADD COLUMN end_longitude DECIMAL(11, 8) NULL,
ADD COLUMN current_latitude DECIMAL(10, 8) NULL,
ADD COLUMN current_longitude DECIMAL(11, 8) NULL,
ADD COLUMN last_location_update TIMESTAMP NULL;

-- Create location_updates table for tracking location history
CREATE TABLE IF NOT EXISTS location_updates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    accuracy DECIMAL(8, 2) NULL,
    speed DECIMAL(8, 2) NULL,
    timestamp TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE,
    INDEX idx_trip_timestamp (trip_id, timestamp),
    INDEX idx_created_at (created_at)
);

-- Add indexes for better performance
ALTER TABLE trips 
ADD INDEX idx_status (status),
ADD INDEX idx_driver_status (driver_id, status),
ADD INDEX idx_location_update (last_location_update);
