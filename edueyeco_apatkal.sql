-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 24, 2025 at 01:33 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `edueyeco_apatkal`
--

-- --------------------------------------------------------

--
-- Table structure for table `accidents`
--

CREATE TABLE `accidents` (
  `id` int(11) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `vehicle` varchar(50) NOT NULL,
  `accident_date` date NOT NULL,
  `location` text NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `description` text NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(20) DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accidents`
--

INSERT INTO `accidents` (`id`, `fullname`, `phone`, `vehicle`, `accident_date`, `location`, `latitude`, `longitude`, `description`, `photo`, `created_at`, `status`) VALUES
(1, 'fffs', '7893524122', 'mp20ze3605', '2000-02-21', '126, Indra Nagar, Loknayak Nagar, Indore, Madhya Pradesh 452002, India', 22.71700000, 75.83370000, 'rydhfujt ', '', '2025-09-09 00:17:44', 'pending'),
(2, 'dddd', '8523697410', 'mp20ze3609', '2005-02-21', '126, Indra Nagar, Loknayak Nagar, Indore, Madhya Pradesh 452002, India', 22.71700000, 75.83370000, 'dghfjh', '', '2025-09-09 00:22:37', 'pending'),
(3, 'fffs', '8523697410', 'mp20ze3608', '2022-02-20', '126, Indra Nagar, Loknayak Nagar, Indore, Madhya Pradesh 452002, India', 22.71700000, 75.83370000, 'gfugjihkuyo', '', '2025-09-09 00:32:56', 'pending'),
(4, 'sdfgh', '8523697416', 'mp20ze3602', '2001-10-21', '126, Indra Nagar, Loknayak Nagar, Indore, Madhya Pradesh 452002, India', 22.71700000, 75.83370000, 'gfhjbkgcjy', NULL, '2025-09-09 00:43:41', 'pending'),
(5, 'fgdh', '8523697410', 'mp20ze3605', '2004-02-20', '126, Indra Nagar, Loknayak Nagar, Indore, Madhya Pradesh 452002, India', 22.71700000, 75.83370000, 'iiuihmvgllofsfdg', NULL, '2025-09-09 00:49:37', 'pending'),
(6, 'dddd', '8523697410', 'mp20ze3605', '2322-03-22', '126, Indra Nagar, Loknayak Nagar, Indore, Madhya Pradesh 452002, India', 22.71700000, 75.83370000, 'ifjkhgafjk', NULL, '2025-09-09 00:53:15', 'pending'),
(7, 'dddd', '7695432875', 'mp20ze3602', '2124-02-22', '126, Indra Nagar, Loknayak Nagar, Indore, Madhya Pradesh 452002, India', 22.71700000, 75.83370000, 'ghgfh', NULL, '2025-09-09 00:58:59', 'pending'),
(8, 'dddd', '8523697410', 'mp20ze3605', '0000-00-00', '126, Indra Nagar, Loknayak Nagar, Indore, Madhya Pradesh 452002, India', 22.71700000, 75.83370000, 'gjh', NULL, '2025-09-09 01:17:40', 'pending'),
(11, 'Siddharth Singh Rajput', '8523697469', 'mp20ze6974', '2005-10-10', '79, Tirupati Colony, Neelbad, Bhopal, Madhya Pradesh 462044, India (Lat: 23.189914, Lng: 77.342310)', 23.18991360, 77.34231040, 'Mental Patient', NULL, '2025-09-10 01:17:12', 'pending'),
(12, 'Kritika', '7946325186', 'mp20ze3602', '2005-10-10', 'Shastri bridge jabalpur madhya pradesh', 0.00000000, 0.00000000, 'Car accident', NULL, '2025-09-10 04:14:04', 'pending'),
(13, 'sdfgh', '8523697469', 'mp20ze3605', '2005-10-10', '      adhartal jabalpur ', 0.00000000, 0.00000000, 'hjhjhg u y ouoh', NULL, '2025-09-10 06:24:46', 'pending'),
(16, 'Mehika                                                                                              ', '8523697454', 'mp20ze3602', '2025-09-12', '1320, near Telephone Exchange, Wright Town, Jabalpur, Madhya Pradesh 482002, India (Lat: 23.166976, Lng: 79.930982)', 23.16697600, 79.93098240, 's testing', NULL, '2025-09-12 00:05:33', 'pending'),
(18, 'Siddharth Singh Rajput', '7694975579', 'mp20ze3605', '2025-10-20', '15 Malipura, Hathipala Main Rd, Gadi Adda, Indore, Madhya Pradesh 452007, India (Lat: 22.712453, Lng: 75.864277)', 22.71245300, 75.86427730, 'accident', NULL, '2025-09-12 07:21:25', 'pending'),
(20, 'Janki das', '8770658824', 'Mp20ja6567', '2025-09-13', '5WQV+5WF, Thakkar Gram, Jabalpur, Vehicle Fac. Jabalpur, Madhya Pradesh 482002, India (Lat: 23.187849, Lng: 79.944728)', 23.18784940, 79.94472760, 'Fattal accident ', '', '2025-09-13 18:31:32', 'pending'),
(21, 'Yadav', '', 'Mp20ja6567', '2025-09-13', '5WQV+5WF, Thakkar Gram, Jabalpur, Vehicle Fac. Jabalpur, Madhya Pradesh 482002, India (Lat: 23.187850, Lng: 79.944727)', 23.18785010, 79.94472690, '', '', '2025-09-13 18:59:01', 'pending'),
(22, 'dgs', '7654891234', 'mp20ac3898', '2025-09-17', '1, Devguradia, Indore, Deoguradia, Madhya Pradesh 452016, India (Lat: 22.686500, Lng: 75.931300)', 22.68650000, 75.93130000, 'efedtgr', '', '2025-09-17 10:09:54', 'pending'),
(23, 'Raj', '7654891234', 'mp20ac3898', '2025-09-17', '1, Devguradia, Indore, Deoguradia, Madhya Pradesh 452016, India (Lat: 22.686500, Lng: 75.931300)', 22.68650000, 75.93130000, 'Mental', '', '2025-09-17 10:37:30', 'pending');

-- --------------------------------------------------------

--
-- Table structure for table `accident_photos`
--

CREATE TABLE `accident_photos` (
  `id` int(11) NOT NULL,
  `accident_id` int(11) NOT NULL,
  `photo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accident_photos`
--

INSERT INTO `accident_photos` (`id`, `accident_id`, `photo`) VALUES
(1, 4, '1757398421_screencapture-localhost-8080-apatkal-adminn-website-manager-php-2025-09-08-17_25_26.png'),
(2, 5, '1757398777_notify police.jpeg'),
(3, 6, '1757398995_Accident Report Icon Illustration.png'),
(4, 7, '1757399339_screencapture-localhost-8080-apatkal-adminn-website-manager-php-2025-09-08-17_25_26.png'),
(5, 8, '1757400460_ss.png'),
(8, 11, '1757486832_1.jpeg'),
(9, 12, '1757497444_screencapture-localhost-8080-admin-about-php-2025-09-03-17_27_55 (1).png'),
(10, 13, '1757505286_screencapture-localhost-8080-apatkal-adminn-admin-dashboard-php-2025-09-08-17_24_22.png'),
(13, 16, '1757655333_screencapture-localhost-8080-apatkal-adminn-accidents-php-2025-09-08-17_26_14.png'),
(15, 18, '1757681485_screencapture-localhost-8080-apatkal-adminn-accidents-php-2025-09-08-17_26_14.png'),
(16, 22, '1758103794_Blue Flower.jpg'),
(17, 23, '1758105450_Blue Flower.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `accident_reports`
--

CREATE TABLE `accident_reports` (
  `id` int(11) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `location` varchar(255) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `accident_date` date NOT NULL,
  `vehicle_number` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `active_emergencies`
-- (See below for the actual view)
--
CREATE TABLE `active_emergencies` (
`incident_id` int(11)
,`user_id` int(11)
,`first_name` varchar(100)
,`last_name` varchar(100)
,`phone` varchar(20)
,`incident_type` enum('accident','breakdown','medical','other')
,`location` varchar(255)
,`status` enum('reported','dispatched','in_progress','resolved','cancelled')
,`priority` enum('low','medium','high','critical')
,`reported_at` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `active_pages_content`
-- (See below for the actual view)
--
CREATE TABLE `active_pages_content` (
`page_id` int(11)
,`page_name` varchar(100)
,`slug` varchar(100)
,`meta_title` varchar(200)
,`meta_description` text
,`section_id` int(11)
,`section_name` varchar(100)
,`section_order` int(11)
,`component_id` int(11)
,`component_type` enum('text','image','video','button','form','link','html_block','icon','card','list')
,`content` longtext
,`extra_settings` longtext
,`component_order` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `id` int(11) NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `mobile_no` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `vehicle_no` varchar(50) DEFAULT NULL,
  `created_date` date DEFAULT curdate(),
  `house_no` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `landmark` varchar(200) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `added_by` int(11) NOT NULL,
  `assigned_staff` int(11) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive','pending') DEFAULT 'active',
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`id`, `full_name`, `mobile_no`, `email`, `vehicle_no`, `created_date`, `house_no`, `address`, `landmark`, `state`, `district`, `city`, `pincode`, `added_by`, `assigned_staff`, `photo`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'Test Client', '9876543210', 'test@example.com', 'MH12AB1234', '2025-01-15', '123 Test House', 'Test Address', 'Test Landmark', 'Maharashtra', 'Mumbai', 'Mumbai', '400001', 1, 1, NULL, 'active', 'Test client for verification', '2025-09-13 17:12:01', '2025-09-13 17:12:01'),
(2, 'Test', '9999999999', 'test@test.com', 'MP20KJ0001', '2025-09-13', '', '', '', '', '', '', '', 1, 4, NULL, 'active', NULL, '2025-09-13 17:16:46', '2025-09-13 17:16:46'),
(3, 'mehak', '7771076100', 'kalmaliindia@gmail.com', 'mp20sa3333', '2025-09-14', '430 taigore WARD JABALPUR', 'jabalpur', '', 'Madhya Pradesh', 'jabalpur', 'Jabalpur', '482004', 1, 3, NULL, 'active', NULL, '2025-09-14 00:25:38', '2025-09-14 00:25:38'),
(5, 'jai', '9999999990', 'kalmaliindia@gmail.com', 'mp20sa6567', '2025-09-14', 'jabalpur', 'jabalpur', 'ground', 'Madhya Pradesh', 'jabalpur', 'Jabalpur', '482004', 1, 3, NULL, 'active', NULL, '2025-09-14 00:37:17', '2025-09-14 00:37:17'),
(7, 'rupesh sahu1', '8959176446', 's@s.com', 'MP20KJ0078', '2025-09-14', '', 'Ranjhi', '', '', '', '', '', 1, NULL, NULL, 'active', NULL, '2025-09-14 15:52:42', '2025-09-14 18:00:13'),
(10, 'Geetanjali', '7694975579', 'geetanjali.tosscs@gmail.com', 'mp20ch8767', '2025-09-17', NULL, 'Jabalpur', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'active', NULL, '2025-09-17 15:43:50', '2025-09-17 15:43:50');

-- --------------------------------------------------------

--
-- Table structure for table `client_family_members`
--

CREATE TABLE `client_family_members` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `mobile_no` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `relationship` enum('spouse','son','daughter','father','mother','brother','sister','other') NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` text DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `is_emergency_contact` tinyint(1) DEFAULT 0,
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `client_family_members`
--

INSERT INTO `client_family_members` (`id`, `client_id`, `full_name`, `mobile_no`, `email`, `relationship`, `date_of_birth`, `address`, `photo`, `is_emergency_contact`, `notes`, `created_at`, `updated_at`) VALUES
(1, 5, 'test', '8959176446', 's@s.com', 'other', '2025-09-14', 'Ranjhi', NULL, 0, NULL, '2025-09-14 13:14:31', '2025-09-14 13:14:31'),
(2, 5, 'test2', '8989898989', 's@s.com', 'spouse', '2025-09-14', NULL, NULL, 0, NULL, '2025-09-14 13:14:58', '2025-09-14 13:14:58'),
(3, 2, 'test2', '9999999999', 's@s.com', 'other', '2025-09-14', 'address', NULL, 0, NULL, '2025-09-14 14:42:13', '2025-09-14 14:42:13'),
(4, 7, 'rupesh sahu', '8959176446', NULL, 'other', NULL, 'Ranjhi', NULL, 0, NULL, '2025-09-14 17:56:56', '2025-09-14 17:56:56');

-- --------------------------------------------------------

--
-- Table structure for table `client_logins`
--

CREATE TABLE `client_logins` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `mobile_no` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `client_logins`
--

INSERT INTO `client_logins` (`id`, `client_id`, `mobile_no`, `password`, `status`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 7, '8959176446', '$2y$10$NWQM8qmwRzKLhsyWO0qC2uXIo4amUu0/Mwtv40b6g3RZFI/rDd4fm', 'active', NULL, '2025-09-14 16:07:51', '2025-09-14 16:07:51'),
(2, 10, '7694975579', '$2y$10$UpOM5JHhWgHXTZloy2hxmOqwOP/iOaLuQDF5R1ltk/gnbPzQoQNmG', 'active', NULL, '2025-09-17 15:43:50', '2025-09-17 15:43:50');

-- --------------------------------------------------------

--
-- Table structure for table `components`
--

CREATE TABLE `components` (
  `id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `type` enum('text','image','video','button','form','link','html_block','icon','card','list') NOT NULL,
  `content` longtext DEFAULT NULL,
  `extra_settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extra_settings`)),
  `order_number` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `components`
--

INSERT INTO `components` (`id`, `section_id`, `type`, `content`, `extra_settings`, `order_number`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'image', 'images/mlogo1.png', '{\"alt\": \"Apatkal Logo\", \"width\": \"150\", \"height\": \"50\"}', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(2, 1, 'text', 'APATKAL', '{\"tag\": \"h1\", \"class\": \"logo-text\", \"style\": \"font-size: 24px; font-weight: bold;\"}', 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(3, 1, 'text', 'EMERGENCY SERVICES', '{\"tag\": \"span\", \"class\": \"emergency-badge\", \"style\": \"background: #ff4444; color: white; padding: 5px 10px; border-radius: 5px;\"}', 3, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(4, 2, 'text', 'APATKAL EMERGENCY SERVICES', '{\"tag\": \"h1\", \"class\": \"hero-title\", \"style\": \"font-size: 48px; font-weight: bold; color: #333;\"}', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(5, 2, 'text', 'When every second counts, we\'re here for you. Professional emergency response services available 24/7 to protect what matters most.', '{\"tag\": \"p\", \"class\": \"hero-subtitle\", \"style\": \"font-size: 18px; color: #666; margin: 20px 0;\"}', 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(6, 2, 'image', 'images/apatkal advertiser.png', '{\"alt\": \"Emergency Services\", \"class\": \"hero-image\", \"style\": \"max-width: 100%; height: auto;\"}', 3, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(7, 2, 'button', 'Get Started', '{\"link\": \"resister.php\", \"class\": \"btn btn-primary\", \"style\": \"background: #007bff; color: white; padding: 12px 30px; border: none; border-radius: 5px; font-size: 16px;\"}', 4, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(8, 3, 'text', 'Our Services', '{\"tag\": \"h2\", \"class\": \"section-title\", \"style\": \"font-size: 36px; text-align: center; margin-bottom: 40px;\"}', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(9, 3, 'card', '24/7 AVAILABILITY', '{\"icon\": \"⏰\", \"description\": \"Round-the-clock emergency medical services ready to respond to your call anytime, anywhere.\", \"class\": \"service-card\"}', 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(10, 3, 'card', 'AMBULANCE DISPATCH', '{\"icon\": \"🚑\", \"description\": \"Fast and efficient ambulance dispatch system with trained medical professionals on board.\", \"class\": \"service-card\"}', 3, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(11, 3, 'card', 'FAMILY ALERT', '{\"icon\": \"👨‍👩‍👧‍👦\", \"description\": \"Automatic notification system to keep your loved ones informed during emergency situations.\", \"class\": \"service-card\"}', 4, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(12, 3, 'card', 'CUSTOMER CARE', '{\"icon\": \"🎧\", \"description\": \"Dedicated customer support team providing guidance and assistance throughout your emergency.\", \"class\": \"service-card\"}', 5, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(13, 4, 'text', 'How Apatkal Works', '{\"tag\": \"h2\", \"class\": \"section-title\", \"style\": \"font-size: 36px; text-align: center; margin-bottom: 40px;\"}', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(14, 4, 'text', 'Simple 3-Step Process to Save Lives', '{\"tag\": \"p\", \"class\": \"section-subtitle\", \"style\": \"font-size: 18px; text-align: center; color: #666; margin-bottom: 40px;\"}', 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(15, 4, 'list', '1. Quick Registration - Register your details, vehicle information, and emergency contacts.\n2. QR Code Activation - In case of emergency, simply scan the QR code.\n3. Emergency Response - Ambulance is dispatched immediately, family members are notified.', '{\"type\": \"ordered\", \"class\": \"process-steps\", \"style\": \"font-size: 16px; line-height: 1.6;\"}', 3, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(16, 5, 'text', 'Our Impact', '{\"tag\": \"h2\", \"class\": \"section-title\", \"style\": \"font-size: 36px; text-align: center; margin-bottom: 40px;\"}', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(17, 5, 'card', 'Under 5 Minutes', '{\"icon\": \"fas fa-clock\", \"title\": \"Emergency Response Time\", \"description\": \"Average response time\", \"class\": \"stat-card\"}', 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(18, 5, 'card', '10,000+', '{\"icon\": \"fas fa-users\", \"title\": \"Active Users\", \"description\": \"Registered users\", \"class\": \"stat-card\"}', 3, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(19, 5, 'card', '5,000+', '{\"icon\": \"fas fa-ambulance\", \"title\": \"Emergency Incidents\", \"description\": \"Successfully handled\", \"class\": \"stat-card\"}', 4, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(20, 5, 'card', 'Pan India', '{\"icon\": \"fas fa-map-marker-alt\", \"title\": \"Coverage Area\", \"description\": \"Service coverage\", \"class\": \"stat-card\"}', 5, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(21, 8, 'text', 'About Apatkal', '{\"tag\": \"h1\", \"class\": \"page-title\", \"style\": \"font-size: 48px; font-weight: bold; color: #333; text-align: center;\"}', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(22, 9, 'text', 'Your trusted partner in emergency response and accident management', '{\"tag\": \"p\", \"class\": \"page-subtitle\", \"style\": \"font-size: 18px; color: #666; text-align: center; margin: 20px 0;\"}', 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(23, 10, 'text', 'Our Mission', '{\"tag\": \"h2\", \"class\": \"section-title\", \"style\": \"font-size: 36px; margin-bottom: 20px;\"}', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(24, 10, 'text', 'Apatkal is dedicated to providing immediate emergency response services to individuals and families across India. We understand that accidents can happen anywhere, anytime, and our mission is to ensure that help arrives when you need it most.', '{\"tag\": \"p\", \"class\": \"mission-text\", \"style\": \"font-size: 16px; line-height: 1.6; margin-bottom: 20px;\"}', 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(25, 10, 'text', 'Emergency Response Time: Our average response time is under 5 minutes, ensuring that help reaches you quickly when every second counts.', '{\"tag\": \"p\", \"class\": \"highlight-text\", \"style\": \"font-size: 18px; font-weight: bold; color: #ff4444; background: #fff3cd; padding: 15px; border-radius: 5px;\"}', 3, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19');

-- --------------------------------------------------------

--
-- Stand-in structure for view `component_stats`
-- (See below for the actual view)
--
CREATE TABLE `component_stats` (
`type` enum('text','image','video','button','form','link','html_block','icon','card','list')
,`total_components` bigint(21)
,`active_components` bigint(21)
,`inactive_components` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'new',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `name`, `mobile`, `email`, `message`, `status`, `created_at`) VALUES
(1, 'test', '8959176446', 'test@test.com', 'test', 'new', '2025-09-13 18:40:52');

-- --------------------------------------------------------

--
-- Table structure for table `contact_submissions`
--

CREATE TABLE `contact_submissions` (
  `id` int(11) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `mobile_no` varchar(20) NOT NULL,
  `email_address` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `status` enum('new','read','replied','closed') DEFAULT 'new',
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--

CREATE TABLE `drivers` (
  `id` int(11) NOT NULL,
  `driver_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `number` varchar(15) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `vehicle_type` varchar(50) DEFAULT NULL,
  `vehicle_number` varchar(20) DEFAULT NULL,
  `model_rating` decimal(2,1) DEFAULT NULL,
  `aadhar_photo` varchar(255) NOT NULL,
  `licence_photo` varchar(255) NOT NULL,
  `rc_photo` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `drivers`
--

INSERT INTO `drivers` (`id`, `driver_name`, `email`, `password`, `number`, `address`, `vehicle_type`, `vehicle_number`, `model_rating`, `aadhar_photo`, `licence_photo`, `rc_photo`, `created_at`, `updated_at`) VALUES
(1, 'Rajash Sharma', 'rajash.sharma@example.com', 'testpass123', '9876543210', '123, Gandhi Marg, Sue Delhi', 'Ambulance', 'DL01AB1234', 4.8, 'aadhar_rajash.jpg', 'licence_rajash.jpg', 'rc_rajash.jpg', '2025-09-24 11:22:18', '2025-09-24 11:22:18');

-- --------------------------------------------------------

--
-- Table structure for table `earnings`
--

CREATE TABLE `earnings` (
  `id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `earning_date` date NOT NULL,
  `created_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `emergency_contacts`
--

CREATE TABLE `emergency_contacts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `relationship` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `emergency_dispatch`
--

CREATE TABLE `emergency_dispatch` (
  `id` int(11) NOT NULL,
  `incident_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `dispatched_at` datetime DEFAULT current_timestamp(),
  `arrived_at` datetime DEFAULT NULL,
  `status` enum('dispatched','en_route','arrived','completed') DEFAULT 'dispatched',
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `emergency_incidents`
--

CREATE TABLE `emergency_incidents` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `vehicle_id` int(11) DEFAULT NULL,
  `incident_type` enum('accident','breakdown','medical','other') NOT NULL,
  `description` text DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `status` enum('reported','dispatched','in_progress','resolved','cancelled') DEFAULT 'reported',
  `priority` enum('low','medium','high','critical') DEFAULT 'medium',
  `reported_at` datetime DEFAULT current_timestamp(),
  `resolved_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `emergency_team`
--

CREATE TABLE `emergency_team` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 1,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `emergency_team`
--

INSERT INTO `emergency_team` (`id`, `name`, `phone`, `email`, `specialization`, `location`, `is_available`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Emergency Response Team 1', '18005709696', 'team1@apatkal.com', 'Medical Emergency', 'Jabalpur', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(2, 'Emergency Response Team 2', '18005709697', 'team2@apatkal.com', 'Accident Response', 'Jabalpur', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(3, 'Emergency Response Team 3', '18005709698', 'team3@apatkal.com', 'General Emergency', 'Jabalpur', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19');

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE `media` (
  `id` int(11) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `type` enum('image','video','document','audio') NOT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `uploaded_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `navigation_menus`
--

CREATE TABLE `navigation_menus` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `url` varchar(255) NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `order_number` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `navigation_menus`
--

INSERT INTO `navigation_menus` (`id`, `title`, `url`, `icon`, `parent_id`, `order_number`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'HOME', 'index.php', 'fas fa-home', NULL, 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(2, 'ABOUT', 'about.php', 'fas fa-info-circle', NULL, 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(3, 'PLANS', 'plan.php', 'fas fa-clipboard-list', NULL, 3, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(4, 'SUBMIT ACCIDENT INFO', 'submitaccident.php', 'fas fa-exclamation-triangle', NULL, 4, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(5, 'CONTACT', 'contact.php', 'fas fa-phone-alt', NULL, 5, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19');

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `meta_title` varchar(200) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pages`
--

INSERT INTO `pages` (`id`, `name`, `slug`, `meta_title`, `meta_description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Home', 'index', 'Apatkal - Emergency Services | 24/7 Emergency Response', 'Professional emergency response services available 24/7. Get immediate help during accidents with our innovative QR code system.', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(2, 'About', 'about', 'About Apatkal - Emergency Response Services', 'Learn about Apatkal emergency response services and how we help save lives during critical situations.', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(3, 'Contact', 'contact', 'Contact Apatkal - Emergency Services', 'Contact Apatkal for emergency services. Available 24/7 for immediate assistance.', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(4, 'Plans', 'plan', 'Emergency Service Plans - Apatkal', 'Choose the perfect emergency service plan for your needs. Flexible options for individuals and families.', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(5, 'FAQ', 'faq', 'Frequently Asked Questions - Apatkal', 'Find answers to common questions about Apatkal emergency services and how our system works.', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(6, 'Submit Accident', 'submitaccident', 'Submit Accident Information - Apatkal', 'Report accident information to Apatkal emergency services for immediate assistance.', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19');

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `order_number` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`id`, `page_id`, `name`, `order_number`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'Header', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(2, 1, 'Hero Banner', 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(3, 1, 'Services Overview', 3, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(4, 1, 'How It Works', 4, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(5, 1, 'Statistics', 5, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(6, 1, 'Footer', 6, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(7, 2, 'Header', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(8, 2, 'Page Banner', 2, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(9, 2, 'Mission Statement', 3, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(10, 2, 'What We Do', 4, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(11, 2, 'Process Steps', 5, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(12, 2, 'Why Choose Us', 6, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(13, 2, 'Footer', 7, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19');

-- --------------------------------------------------------

--
-- Table structure for table `service_plans`
--

CREATE TABLE `service_plans` (
  `id` int(11) NOT NULL,
  `plan_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `duration_months` int(11) NOT NULL,
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`features`)),
  `is_popular` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `service_plans`
--

INSERT INTO `service_plans` (`id`, `plan_name`, `description`, `price`, `duration_months`, `features`, `is_popular`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Emergency Response Plan', 'Complete emergency response service with 24/7 support', 999.00, 12, '[\"24/7 Emergency Response\", \"GPS Location Tracking\", \"Immediate Alert System\", \"Emergency Contact Notifications\", \"Accident Report Management\", \"24/7 Customer Support\"]', 1, 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19');

-- --------------------------------------------------------

--
-- Table structure for table `site_settings`
--

CREATE TABLE `site_settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` enum('text','number','boolean','json','file') DEFAULT 'text',
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `site_settings`
--

INSERT INTO `site_settings` (`id`, `setting_key`, `setting_value`, `setting_type`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'site_title', 'Apatkal - Emergency Services', 'text', 'Main website title', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(2, 'site_description', 'Professional emergency response services available 24/7', 'text', 'Website meta description', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(3, 'emergency_phone', '18005709696', 'text', 'Emergency contact phone number', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(4, 'contact_email', 'apatkalindia@gmail.com', 'text', 'Main contact email', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(5, 'company_address', 'Highcourt road, beoharbagh ghamapur, opposite pandey hospital jabalpur, madhyapradesh 482002', 'text', 'Company address', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(6, 'maintenance_mode', '0', 'boolean', 'Enable/disable maintenance mode', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(7, 'google_analytics', '', 'text', 'Google Analytics tracking ID', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19'),
(8, 'social_media', '{\"facebook\":\"https://www.facebook.com/people/Apatkal-India/61573752802887/\",\"youtube\":\"https://www.youtube.com/channel/UC_9OYRqF_1NiEC3_06ZPSXQ\",\"linkedin\":\"https://www.linkedin.com/company/mgaus-information-technology/\",\"instagram\":\"https://www.instagram.com/apatkal.india/\"}', 'json', 'Social media links', 1, '2025-09-13 08:01:19', '2025-09-13 08:01:19');

-- --------------------------------------------------------

--
-- Table structure for table `trips`
--

CREATE TABLE `trips` (
  `history_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `client_name` varchar(100) NOT NULL,
  `location` text NOT NULL,
  `timing` timestamp NULL DEFAULT NULL,
  `amount` decimal(8,2) NOT NULL,
  `duration` int(11) NOT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trips`
--

INSERT INTO `trips` (`history_id`, `driver_id`, `client_name`, `location`, `timing`, `amount`, `duration`, `start_time`, `end_time`, `created_at`) VALUES
(5, 1, 'Ravi Sharma', 'Apollo Hospital, Bengaluru', '2025-09-20 03:00:00', 1500.00, 45, '2025-09-20 03:05:00', '2025-09-20 03:50:00', '2025-09-24 11:23:52'),
(6, 1, 'Meera Patel', 'Fortis Hospital, Bengaluru', '2025-09-21 06:30:00', 2200.00, 60, '2025-09-21 06:35:00', NULL, '2025-09-24 11:23:52'),
(7, 1, 'Amit Verma', 'Manipal Hospital, Bengaluru', '2025-09-22 10:15:00', 1800.00, 40, '2025-09-22 10:20:00', '2025-09-22 11:00:00', '2025-09-24 11:23:52'),
(8, 1, 'Priya Singh', 'Narayana Hrudayalaya, Bengaluru', '2025-09-25 04:30:00', 2500.00, 75, NULL, NULL, '2025-09-24 11:23:52');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `role` enum('admin','hr','sales','office_staff','manager','supervisor','user') DEFAULT 'user',
  `is_verified` tinyint(1) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password`, `username`, `date_of_birth`, `gender`, `address`, `city`, `state`, `pincode`, `profile_image`, `role`, `is_verified`, `is_active`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'User', 'admin@apatkal.com', '', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', 0, 1, '2025-09-14 12:54:04', '2025-09-13 08:01:19', '2025-09-14 12:54:04'),
(2, 'Krishna', 'Vish', 'Toss125traininag@gmai.com', '7723065844', '$2y$10$pZ8DQ4CufH1drx2OF5qMnuPXgpPuWCT.Z5.wnHc38Oy7.HR036jVq', 'sales', NULL, NULL, '', NULL, NULL, NULL, NULL, 'sales', 0, 1, NULL, '2025-09-13 15:46:08', '2025-09-13 17:02:04'),
(3, 'Sarah', 'Johnson', 'hr@apatkal.com', '9876543210', '$2y$10$wDNv.mYbXpnet7re8If.keP.NPDOHoLOXgsqJBK1YBITQi2aWKn6u', 'hr_manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'hr', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(4, 'Mike', 'Davis', 'sales@apatkal.com', '9876543211', '$2y$10$4AYUzkUaaGtu5nnXGguB4.aPA.DgfCprSC5hnBGj4Mm7H1wkt4sti', 'sales_rep', NULL, NULL, '', NULL, NULL, NULL, NULL, 'sales', 0, 1, '2025-09-14 14:17:26', '2025-09-13 16:58:30', '2025-09-14 14:17:26'),
(5, 'Lisa', 'Wilson', 'office@apatkal.com', '9876543212', '$2y$10$w2eAWT7oUdswd6KDvTw0muJv4zVRsU35o10vMxLj/kBkyfnbv5nPC', 'office_staff', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'office_staff', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(6, 'David', 'Brown', 'manager@apatkal.com', '9876543213', '$2y$10$jV9jn2GjPqA7XJUP1p35ieUQNDbirBOZDRPE6pYsbpBq5zsGtwXAK', 'manager1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'manager', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(7, 'Emma', 'Garcia', 'supervisor@apatkal.com', '9876543214', '$2y$10$oSF8KFXrI.lOk.puE8igeOE5yeY/jNNSYaETcEHdqEhgVXqZVR3EC', 'supervisor1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'supervisor', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(8, 'Gulam', 'Gous', 'kalmaliindia@gmail.com', '8770658824', '$2y$10$FonFNbtwhX7uKdjK2J4rD.dXZ6L3O3GKUUfYhQBJ2/Mpsuyw4BIGK', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'user', 0, 1, '2025-09-14 00:10:22', '2025-09-14 00:07:43', '2025-09-14 00:10:22');

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_emergency_contacts`
-- (See below for the actual view)
--
CREATE TABLE `user_emergency_contacts` (
`contact_id` int(11)
,`user_id` int(11)
,`first_name` varchar(100)
,`last_name` varchar(100)
,`contact_name` varchar(100)
,`relationship` varchar(50)
,`contact_phone` varchar(20)
,`contact_email` varchar(100)
,`is_primary` tinyint(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `user_subscriptions`
--

CREATE TABLE `user_subscriptions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','expired','cancelled','suspended') DEFAULT 'active',
  `payment_status` enum('pending','paid','failed','refunded') DEFAULT 'pending',
  `amount_paid` decimal(10,2) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `vehicle_number` varchar(20) NOT NULL,
  `vehicle_type` enum('car','bike','truck','bus','other') NOT NULL,
  `make` varchar(100) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `year` year(4) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `qr_code` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wallet`
--

CREATE TABLE `wallet` (
  `wallet_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `balance` decimal(10,2) DEFAULT 0.00,
  `total_earned` decimal(10,2) DEFAULT 0.00,
  `total_withdrawn` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `website_config`
--

CREATE TABLE `website_config` (
  `id` int(11) NOT NULL,
  `config_key` varchar(100) NOT NULL,
  `config_value` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `withdrawals`
--

CREATE TABLE `withdrawals` (
  `withdrawal_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `bank_account_number` varchar(20) NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `ifsc_code` varchar(15) NOT NULL,
  `account_holder_name` varchar(100) NOT NULL,
  `status` enum('pending','approved','rejected','completed') DEFAULT 'pending',
  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `processed_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure for view `active_emergencies`
--
DROP TABLE IF EXISTS `active_emergencies`;

CREATE ALGORITHM=UNDEFINED DEFINER=`edueyeco`@`localhost` SQL SECURITY DEFINER VIEW `active_emergencies`  AS SELECT `ei`.`id` AS `incident_id`, `ei`.`user_id` AS `user_id`, `u`.`first_name` AS `first_name`, `u`.`last_name` AS `last_name`, `u`.`phone` AS `phone`, `ei`.`incident_type` AS `incident_type`, `ei`.`location` AS `location`, `ei`.`status` AS `status`, `ei`.`priority` AS `priority`, `ei`.`reported_at` AS `reported_at` FROM (`emergency_incidents` `ei` join `users` `u` on(`ei`.`user_id` = `u`.`id`)) WHERE `ei`.`status` in ('reported','dispatched','in_progress') ;

-- --------------------------------------------------------

--
-- Structure for view `active_pages_content`
--
DROP TABLE IF EXISTS `active_pages_content`;

CREATE ALGORITHM=UNDEFINED DEFINER=`edueyeco`@`localhost` SQL SECURITY DEFINER VIEW `active_pages_content`  AS SELECT `p`.`id` AS `page_id`, `p`.`name` AS `page_name`, `p`.`slug` AS `slug`, `p`.`meta_title` AS `meta_title`, `p`.`meta_description` AS `meta_description`, `s`.`id` AS `section_id`, `s`.`name` AS `section_name`, `s`.`order_number` AS `section_order`, `c`.`id` AS `component_id`, `c`.`type` AS `component_type`, `c`.`content` AS `content`, `c`.`extra_settings` AS `extra_settings`, `c`.`order_number` AS `component_order` FROM ((`pages` `p` left join `sections` `s` on(`p`.`id` = `s`.`page_id` and `s`.`is_active` = 1)) left join `components` `c` on(`s`.`id` = `c`.`section_id` and `c`.`is_active` = 1)) WHERE `p`.`is_active` = 1 ORDER BY `p`.`id` ASC, `s`.`order_number` ASC, `c`.`order_number` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `component_stats`
--
DROP TABLE IF EXISTS `component_stats`;

CREATE ALGORITHM=UNDEFINED DEFINER=`edueyeco`@`localhost` SQL SECURITY DEFINER VIEW `component_stats`  AS SELECT `c`.`type` AS `type`, count(0) AS `total_components`, count(case when `c`.`is_active` = 1 then 1 end) AS `active_components`, count(case when `c`.`is_active` = 0 then 1 end) AS `inactive_components` FROM `components` AS `c` GROUP BY `c`.`type` ;

-- --------------------------------------------------------

--
-- Structure for view `user_emergency_contacts`
--
DROP TABLE IF EXISTS `user_emergency_contacts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`edueyeco`@`localhost` SQL SECURITY DEFINER VIEW `user_emergency_contacts`  AS SELECT `ec`.`id` AS `contact_id`, `ec`.`user_id` AS `user_id`, `u`.`first_name` AS `first_name`, `u`.`last_name` AS `last_name`, `ec`.`name` AS `contact_name`, `ec`.`relationship` AS `relationship`, `ec`.`phone` AS `contact_phone`, `ec`.`email` AS `contact_email`, `ec`.`is_primary` AS `is_primary` FROM (`emergency_contacts` `ec` join `users` `u` on(`ec`.`user_id` = `u`.`id`)) WHERE `ec`.`is_active` = 1 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accidents`
--
ALTER TABLE `accidents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `accident_photos`
--
ALTER TABLE `accident_photos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `accident_reports`
--
ALTER TABLE `accident_reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_mobile_no` (`mobile_no`),
  ADD UNIQUE KEY `unique_vehicle_no` (`vehicle_no`),
  ADD KEY `added_by` (`added_by`),
  ADD KEY `assigned_staff` (`assigned_staff`);

--
-- Indexes for table `client_family_members`
--
ALTER TABLE `client_family_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_client_family_client_id` (`client_id`),
  ADD KEY `idx_client_family_relationship` (`relationship`),
  ADD KEY `idx_client_family_emergency` (`is_emergency_contact`);

--
-- Indexes for table `client_logins`
--
ALTER TABLE `client_logins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_mobile_login` (`mobile_no`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `components`
--
ALTER TABLE `components`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_components_section` (`section_id`),
  ADD KEY `idx_components_type` (`type`),
  ADD KEY `idx_components_order` (`order_number`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contact_submissions`
--
ALTER TABLE `contact_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact_submissions_status` (`status`),
  ADD KEY `idx_contact_submissions_created` (`created_at`);

--
-- Indexes for table `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `earnings`
--
ALTER TABLE `earnings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `driver_id` (`driver_id`);

--
-- Indexes for table `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `emergency_dispatch`
--
ALTER TABLE `emergency_dispatch`
  ADD PRIMARY KEY (`id`),
  ADD KEY `incident_id` (`incident_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `emergency_incidents`
--
ALTER TABLE `emergency_incidents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `idx_emergency_incidents_user` (`user_id`),
  ADD KEY `idx_emergency_incidents_status` (`status`),
  ADD KEY `idx_emergency_incidents_reported` (`reported_at`);

--
-- Indexes for table `emergency_team`
--
ALTER TABLE `emergency_team`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_media_type` (`type`);

--
-- Indexes for table `navigation_menus`
--
ALTER TABLE `navigation_menus`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idx_pages_slug` (`slug`),
  ADD KEY `idx_pages_active` (`is_active`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sections_page` (`page_id`),
  ADD KEY `idx_sections_order` (`order_number`);

--
-- Indexes for table `service_plans`
--
ALTER TABLE `service_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `site_settings`
--
ALTER TABLE `site_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `trips`
--
ALTER TABLE `trips`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `driver_id` (`driver_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_users_email` (`email`),
  ADD KEY `idx_users_phone` (`phone`);

--
-- Indexes for table `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `qr_code` (`qr_code`),
  ADD KEY `idx_vehicles_user` (`user_id`),
  ADD KEY `idx_vehicles_qr` (`qr_code`);

--
-- Indexes for table `wallet`
--
ALTER TABLE `wallet`
  ADD PRIMARY KEY (`wallet_id`),
  ADD UNIQUE KEY `driver_id` (`driver_id`);

--
-- Indexes for table `website_config`
--
ALTER TABLE `website_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `config_key` (`config_key`);

--
-- Indexes for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD PRIMARY KEY (`withdrawal_id`),
  ADD KEY `driver_id` (`driver_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accidents`
--
ALTER TABLE `accidents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `accident_photos`
--
ALTER TABLE `accident_photos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `accident_reports`
--
ALTER TABLE `accident_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clients`
--
ALTER TABLE `clients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `client_family_members`
--
ALTER TABLE `client_family_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `client_logins`
--
ALTER TABLE `client_logins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `components`
--
ALTER TABLE `components`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `contact_submissions`
--
ALTER TABLE `contact_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `earnings`
--
ALTER TABLE `earnings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `emergency_dispatch`
--
ALTER TABLE `emergency_dispatch`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `emergency_incidents`
--
ALTER TABLE `emergency_incidents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `emergency_team`
--
ALTER TABLE `emergency_team`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `media`
--
ALTER TABLE `media`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `navigation_menus`
--
ALTER TABLE `navigation_menus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `service_plans`
--
ALTER TABLE `service_plans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `site_settings`
--
ALTER TABLE `site_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `trips`
--
ALTER TABLE `trips`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wallet`
--
ALTER TABLE `wallet`
  MODIFY `wallet_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `website_config`
--
ALTER TABLE `website_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `withdrawal_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `clients_ibfk_1` FOREIGN KEY (`added_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `clients_ibfk_2` FOREIGN KEY (`assigned_staff`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `client_family_members`
--
ALTER TABLE `client_family_members`
  ADD CONSTRAINT `client_family_members_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `client_logins`
--
ALTER TABLE `client_logins`
  ADD CONSTRAINT `client_logins_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `components`
--
ALTER TABLE `components`
  ADD CONSTRAINT `components_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `earnings`
--
ALTER TABLE `earnings`
  ADD CONSTRAINT `earnings_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  ADD CONSTRAINT `emergency_contacts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `emergency_dispatch`
--
ALTER TABLE `emergency_dispatch`
  ADD CONSTRAINT `emergency_dispatch_ibfk_1` FOREIGN KEY (`incident_id`) REFERENCES `emergency_incidents` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `emergency_dispatch_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `emergency_team` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `emergency_incidents`
--
ALTER TABLE `emergency_incidents`
  ADD CONSTRAINT `emergency_incidents_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `emergency_incidents_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `navigation_menus`
--
ALTER TABLE `navigation_menus`
  ADD CONSTRAINT `navigation_menus_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `navigation_menus` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `trips`
--
ALTER TABLE `trips`
  ADD CONSTRAINT `trips_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  ADD CONSTRAINT `user_subscriptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_subscriptions_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `service_plans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wallet`
--
ALTER TABLE `wallet`
  ADD CONSTRAINT `wallet_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD CONSTRAINT `withdrawals_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
