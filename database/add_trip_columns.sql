-- SQL script to add new columns to trips table
-- Adds: client_id, distance, from_location, to_location
-- Note: duration column already exists but will be updated to store in seconds

-- Add client_id column (nullable for backward compatibility)
ALTER TABLE `trips` 
ADD COLUMN `client_id` INT(11) NULL DEFAULT NULL 
AFTER `driver_id`;

-- Add distance column (in kilometers, decimal with 2 decimal places)
ALTER TABLE `trips` 
ADD COLUMN `distance` DECIMAL(10, 2) NULL DEFAULT NULL 
AFTER `duration`;

-- Add from_location column (text address for start location)
ALTER TABLE `trips` 
ADD COLUMN `from_location` TEXT NULL DEFAULT NULL 
AFTER `end_longitude`;

-- Add to_location column (text address for end/destination location)
ALTER TABLE `trips` 
ADD COLUMN `to_location` TEXT NULL DEFAULT NULL 
AFTER `from_location`;

-- Add index on client_id for better query performance
ALTER TABLE `trips` 
ADD INDEX `idx_client_id` (`client_id`);

-- Add foreign key constraint for client_id (if clients table exists)
-- Note: Uncomment the following line if you want to enforce referential integrity
-- ALTER TABLE `trips` ADD CONSTRAINT `fk_trips_client` FOREIGN KEY (`client_id`) REFERENCES `clients`(`id`) ON DELETE SET NULL;

-- Update duration column comment to clarify it stores seconds
ALTER TABLE `trips` 
MODIFY COLUMN `duration` INT(11) NOT NULL COMMENT 'Duration in seconds';

