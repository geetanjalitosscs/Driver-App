-- Add separate columns for account details (only if they don't exist)
SET @sql = 'ALTER TABLE drivers ADD COLUMN account_number VARCHAR(20) NULL';
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'drivers' 
    AND COLUMN_NAME = 'account_number'
);
SET @sql = IF(@column_exists = 0, @sql, 'SELECT ''account_number column already exists'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE drivers ADD COLUMN bank_name VARCHAR(100) NULL';
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'drivers' 
    AND COLUMN_NAME = 'bank_name'
);
SET @sql = IF(@column_exists = 0, @sql, 'SELECT ''bank_name column already exists'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE drivers ADD COLUMN ifsc_code VARCHAR(15) NULL';
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'drivers' 
    AND COLUMN_NAME = 'ifsc_code'
);
SET @sql = IF(@column_exists = 0, @sql, 'SELECT ''ifsc_code column already exists'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE drivers ADD COLUMN account_holder_name VARCHAR(100) NULL';
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'drivers' 
    AND COLUMN_NAME = 'account_holder_name'
);
SET @sql = IF(@column_exists = 0, @sql, 'SELECT ''account_holder_name column already exists'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check if account_details column exists before migrating data
-- This will only run the migration if the column exists
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'drivers' 
    AND COLUMN_NAME = 'account_details'
);

-- Migrate existing data from account_details JSON to separate columns (only if column exists)
SET @sql = IF(@column_exists > 0, 
    'UPDATE drivers 
     SET 
         account_number = JSON_UNQUOTE(JSON_EXTRACT(account_details, ''$.account_number'')),
         bank_name = JSON_UNQUOTE(JSON_EXTRACT(account_details, ''$.bank_name'')),
         ifsc_code = JSON_UNQUOTE(JSON_EXTRACT(account_details, ''$.ifsc_code'')),
         account_holder_name = JSON_UNQUOTE(JSON_EXTRACT(account_details, ''$.account_holder_name''))
     WHERE account_details IS NOT NULL AND account_details != ''''',
    'SELECT ''account_details column does not exist, skipping migration'' as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Optional: Drop the old account_details column after migration
-- ALTER TABLE drivers DROP COLUMN account_details;
