CREATE TABLE `driver_assignments` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `accident_id` INT NOT NULL,
  `driver_id` INT NOT NULL,
  `assigned_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('pending', 'accepted', 'rejected', 'cancelled') DEFAULT 'pending',
  `rejection_reason` TEXT NULL,
  `attempt_count` INT DEFAULT 1,
  `last_attempt_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `radius_km` DECIMAL(10, 3) DEFAULT 5.0, -- Initial 5km radius
  `radius_meters` INT DEFAULT 5000, -- Initial 5000m radius
  FOREIGN KEY (`accident_id`) REFERENCES `accidents`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`driver_id`) REFERENCES `drivers`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_assignment` (`accident_id`, `driver_id`)
);
