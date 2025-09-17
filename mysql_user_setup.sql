-- MySQL User Setup Script
-- Run this in MySQL as root user

-- Create a new user for the driver app
CREATE USER 'driver_app_user'@'localhost' IDENTIFIED BY 'driver_app_password';

-- Grant all privileges on the apatkal database
GRANT ALL PRIVILEGES ON apatkal.* TO 'driver_app_user'@'localhost';

-- Apply the changes
FLUSH PRIVILEGES;

-- Test the connection
-- You can now use these credentials in your app:
-- User: driver_app_user
-- Password: driver_app_password
