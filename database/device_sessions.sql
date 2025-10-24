-- Device Sessions Table for Single Device Login
CREATE TABLE `device_sessions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `driver_id` INT NOT NULL,
  `device_id` VARCHAR(255) NOT NULL,
  `device_name` VARCHAR(255) DEFAULT NULL,
  `login_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `last_activity` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` BOOLEAN DEFAULT TRUE,
  `ip_address` VARCHAR(45) DEFAULT NULL,
  `user_agent` TEXT DEFAULT NULL,
  FOREIGN KEY (`driver_id`) REFERENCES `drivers`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_driver_device` (`driver_id`, `device_id`)
);

-- Index for faster lookups
CREATE INDEX `idx_driver_active_session` ON `device_sessions` (`driver_id`, `is_active`);
CREATE INDEX `idx_device_id` ON `device_sessions` (`device_id`);
