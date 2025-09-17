-- Database Setup Script for Driver App
-- Run this in phpMyAdmin after creating the database

-- Create the accidents table
CREATE TABLE accidents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    vehicle VARCHAR(255) NOT NULL,
    accident_date DATETIME NOT NULL,
    location VARCHAR(500) NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    description TEXT,
    photo VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'accepted', 'rejected', 'cancelled') DEFAULT 'pending'
);

-- Create the accident_photos table
CREATE TABLE accident_photos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    accident_id INT NOT NULL,
    photo VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (accident_id) REFERENCES accidents(id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO accidents (fullname, phone, vehicle, accident_date, location, latitude, longitude, description, status) VALUES
('John Doe', '1234567890', 'Toyota Camry', '2024-01-15 10:30:00', 'Main Street, Indore', 22.7196, 75.8577, 'Car accident on main road', 'pending'),
('Jane Smith', '0987654321', 'Honda Civic', '2024-01-15 11:45:00', 'Park Avenue, Indore', 22.7200, 75.8580, 'Collision at intersection', 'pending'),
('Mike Johnson', '1122334455', 'Ford Focus', '2024-01-15 12:15:00', 'Central Plaza, Indore', 22.7190, 75.8570, 'Rear-end collision', 'pending');

-- Insert sample photos
INSERT INTO accident_photos (accident_id, photo) VALUES
(1, 'accident_1_photo1.jpg'),
(1, 'accident_1_photo2.jpg'),
(2, 'accident_2_photo1.jpg'),
(3, 'accident_3_photo1.jpg');