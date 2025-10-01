-- Complete Driver Acceptance and Completion System for Accidents Table
-- This single SQL file includes all driver-related features:
-- 1. Driver status tracking
-- 2. Driver acceptance with details
-- 3. Completion confirmation system
-- 4. Combined driver_details column

-- ============================================
-- ADD ALL DRIVER-RELATED COLUMNS TO ACCIDENTS TABLE
-- ============================================

-- Add driver_status column to track driver progress
ALTER TABLE `accidents` 
ADD COLUMN `driver_status` VARCHAR(20) DEFAULT 'available' 
COMMENT 'Status of driver assigned to this accident: available, assigned, en_route, arrived, completed' 
AFTER `status`;

-- Add driver_details column to combine driver ID and vehicle number
ALTER TABLE `accidents` 
ADD COLUMN `driver_details` TEXT DEFAULT NULL 
COMMENT 'Combined driver information: Driver ID and Vehicle Number' 
AFTER `driver_status`;

-- Add accepted_at timestamp to track when driver accepted
ALTER TABLE `accidents` 
ADD COLUMN `accepted_at` TIMESTAMP NULL DEFAULT NULL 
COMMENT 'Timestamp when driver accepted this accident' 
AFTER `driver_details`;

-- Add completed_at timestamp to track when driver completed
ALTER TABLE `accidents` 
ADD COLUMN `completed_at` TIMESTAMP NULL DEFAULT NULL 
COMMENT 'Timestamp when driver completed this accident' 
AFTER `accepted_at`;

-- Add completion_confirmed column to track confirmation status
ALTER TABLE `accidents` 
ADD COLUMN `completion_confirmed` BOOLEAN DEFAULT FALSE 
COMMENT 'Whether driver confirmed completion of the accident' 
AFTER `completed_at`;

-- ============================================
-- UPDATE EXISTING RECORDS
-- ============================================

-- Update existing resolved accidents to show completion
UPDATE `accidents` 
SET 
    `driver_status` = 'completed',
    `completion_confirmed` = TRUE,
    `completed_at` = `created_at` + INTERVAL 1 HOUR
WHERE `status` = 'resolved';

-- Update existing pending accidents to show availability
UPDATE `accidents` 
SET `driver_status` = 'available' 
WHERE `status` = 'pending';

-- ============================================
-- CREATE TRIGGER FOR AUTOMATIC UPDATES
-- ============================================

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS `update_driver_details`;

-- Create trigger to automatically update timestamps and status
DELIMITER $$

CREATE TRIGGER `update_driver_details` 
BEFORE UPDATE ON `accidents`
FOR EACH ROW
BEGIN
    -- If driver_details is being set and it wasn't set before, update accepted_at
    IF NEW.driver_details IS NOT NULL AND OLD.driver_details IS NULL THEN
        SET NEW.accepted_at = NOW();
        SET NEW.driver_status = 'assigned';
    END IF;
    
    -- If driver_status is being updated to 'completed', set completed_at
    IF NEW.driver_status = 'completed' AND OLD.driver_status != 'completed' THEN
        SET NEW.completed_at = NOW();
    END IF;
END$$

DELIMITER ;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check the updated table structure
DESCRIBE `accidents`;

-- Check accidents with all driver information
SELECT 
    id,
    fullname,
    phone,
    vehicle,
    accident_date,
    location,
    status,
    driver_status,
    driver_details,
    accepted_at,
    completed_at,
    completion_confirmed,
    created_at
FROM `accidents` 
ORDER BY created_at DESC 
LIMIT 10;

-- Count accidents by driver status
SELECT 
    driver_status,
    COUNT(*) as count
FROM `accidents` 
GROUP BY driver_status;

-- Count accidents by completion status
SELECT 
    completion_confirmed,
    COUNT(*) as count
FROM `accidents` 
GROUP BY completion_confirmed;

-- Show accidents with driver details
SELECT 
    id,
    driver_details,
    driver_status,
    completion_confirmed,
    created_at
FROM `accidents` 
WHERE driver_details IS NOT NULL
ORDER BY created_at DESC;

-- ============================================
-- API ENDPOINT QUERIES (for reference)
-- ============================================

-- Query to get accidents available for acceptance
-- SELECT 
--     id,
--     fullname,
--     phone,
--     vehicle,
--     accident_date,
--     location,
--     latitude,
--     longitude,
--     description,
--     created_at
-- FROM `accidents` 
-- WHERE `status` = 'pending' 
-- AND `driver_status` = 'available'
-- ORDER BY created_at ASC;

-- Query to accept an accident
-- UPDATE `accidents` 
-- SET 
--     `driver_details` = CONCAT('Driver ID: ', ?, ' | Vehicle: ', ?),
--     `driver_status` = 'assigned'
-- WHERE `id` = ? AND `status` = 'pending' AND `driver_status` = 'available';

-- Query to complete an accident
-- UPDATE `accidents` 
-- SET 
--     `driver_status` = 'completed',
--     `completion_confirmed` = TRUE
-- WHERE `id` = ? AND `driver_details` LIKE CONCAT('%Driver ID: ', ?, '%');

-- Query to check if driver is assigned to accident
-- SELECT id FROM accidents 
-- WHERE id = ? AND driver_details LIKE CONCAT('%Driver ID: ', ?, '%');

-- ============================================
-- HELPER FUNCTIONS FOR EXTRACTING DRIVER INFO
-- ============================================

-- Function to extract driver ID from driver_details
-- SELECT 
--     id,
--     driver_details,
--     CASE 
--         WHEN driver_details LIKE '%Driver ID: %' THEN
--             SUBSTRING(driver_details, 
--                 LOCATE('Driver ID: ', driver_details) + 12,
--                 LOCATE(' |', driver_details, LOCATE('Driver ID: ', driver_details)) - LOCATE('Driver ID: ', driver_details) - 12
--             )
--         ELSE NULL
--     END as extracted_driver_id
-- FROM accidents 
-- WHERE driver_details IS NOT NULL;

-- Function to extract vehicle number from driver_details
-- SELECT 
--     id,
--     driver_details,
--     CASE 
--         WHEN driver_details LIKE '%Vehicle: %' THEN
--             SUBSTRING(driver_details, 
--                 LOCATE('Vehicle: ', driver_details) + 9
--             )
--         ELSE NULL
--     END as extracted_vehicle_number
-- FROM accidents 
-- WHERE driver_details IS NOT NULL;

-- ============================================
-- SAMPLE DATA FOR TESTING
-- ============================================

-- Example: Simulate driver accepting an accident
-- UPDATE `accidents` 
-- SET 
--     `driver_details` = 'Driver ID: 1 | Vehicle: MP20ZE3605',
--     `driver_status` = 'assigned'
-- WHERE `id` = 1 AND `status` = 'pending';

-- Example: Simulate driver completing an accident
-- UPDATE `accidents` 
-- SET 
--     `driver_status` = 'completed',
--     `completion_confirmed` = TRUE
-- WHERE `id` = 1 AND `driver_details` LIKE '%Driver ID: 1%';

-- ============================================
-- COMPLETE SYSTEM OVERVIEW
-- ============================================

/*
DRIVER WORKFLOW:
1. Accident reported → status='pending', driver_status='available'
2. Driver accepts → driver_details='Driver ID: X | Vehicle: Y', driver_status='assigned', accepted_at set
3. Driver en route → driver_status='en_route'
4. Driver arrives → driver_status='arrived'
5. Driver completes → driver_status='completed', completed_at set, completion_confirmed=TRUE

DRIVER STATUS VALUES:
- 'available': Driver is available for assignment
- 'assigned': Driver has been assigned to this accident
- 'en_route': Driver is on the way to accident location
- 'arrived': Driver has arrived at accident location
- 'completed': Driver has completed the accident response

DRIVER DETAILS FORMAT:
- "Driver ID: 1 | Vehicle: MP20ZE3605" (both present)
- "Driver ID: 1" (only driver ID)
- "Vehicle: MP20ZE3605" (only vehicle)

CONFIRMATION POPUP LOGIC:
- When driver clicks "Complete Trip", show confirmation popup
- If "Yes" → Update driver_status='completed', completion_confirmed=TRUE
- If "No" → Close popup, keep current status, don't remove km validation

FEATURES INCLUDED:
✅ Driver status tracking (available → assigned → en_route → arrived → completed)
✅ Driver acceptance with ID and vehicle number in single column
✅ Automatic timestamp updates (accepted_at, completed_at)
✅ Completion confirmation system
✅ Combined driver_details column for easy display
✅ Automatic triggers for status changes
✅ Backward compatibility with existing data
*/



-- Drop the trigger first
DROP TRIGGER IF EXISTS `update_driver_details`;

-- Drop all driver-related columns
ALTER TABLE `accidents` DROP COLUMN `completion_confirmed`;
ALTER TABLE `accidents` DROP COLUMN `completed_at`;
ALTER TABLE `accidents` DROP COLUMN `accepted_at`;
ALTER TABLE `accidents` DROP COLUMN `driver_details`;
ALTER TABLE `accidents` DROP COLUMN `driver_status`;