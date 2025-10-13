-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 13, 2025 at 07:36 AM
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
  `status` varchar(20) DEFAULT 'pending',
  `driver_status` varchar(20) DEFAULT NULL,
  `driver_details` text DEFAULT NULL,
  `accepted_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `completion_confirmed` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accidents`
--

INSERT INTO `accidents` (`id`, `fullname`, `phone`, `vehicle`, `accident_date`, `location`, `latitude`, `longitude`, `description`, `photo`, `created_at`, `status`, `driver_status`, `driver_details`, `accepted_at`, `completed_at`, `completion_confirmed`) VALUES
(1, 'Test User', '9876543210', 'MP20ZE3605', '2025-10-04', 'Test Location', 22.71700000, 75.83370000, 'Test accident description', '', '2025-10-04 10:23:19', 'pending', NULL, NULL, NULL, NULL, 0),
(2, 'geetanjali', '7694975579', 'MP20PH2265', '2025-10-04', '8C2C+FRP, Peoples Campus, Bhanpur, Bhopal, Madhya Pradesh 462037, India (Lat: 23.301000, Lng: 77.421600)', 23.30100000, 77.42160000, 'ertyrd', '1759573448_screencapture-localhost-apatkal-2-apatkal-client-dashboard-php-2025-09-25-17_18_47.png', '2025-10-04 10:24:08', 'pending', NULL, NULL, NULL, NULL, 0),
(3, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-04', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154842, Lng: 79.926019)', 23.15484200, 79.92601923, 'testttttttt', '', '2025-10-04 10:39:36', 'pending', NULL, NULL, NULL, NULL, 0),
(4, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-04', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154840, Lng: 79.926030)', 23.15483966, 79.92603031, 'Mental Patient', '', '2025-10-04 10:45:53', 'pending', NULL, NULL, NULL, NULL, 0),
(5, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-04', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154839, Lng: 79.926032)', 23.15483918, 79.92603159, 'Ancle damaged', '', '2025-10-04 10:46:41', 'pending', NULL, NULL, NULL, NULL, 0),
(6, 'Raj', '7771076100', 'mp20ac3893', '2025-10-04', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154839, Lng: 79.926032)', 23.15483918, 79.92603159, 'Testing no 2', '', '2025-10-04 10:47:27', 'pending', NULL, NULL, NULL, NULL, 0),
(8, 'Krishna Vishwakarma', '8959176446', 'mp20ab2010', '2025-10-04', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154831, Lng: 79.926038)', 23.15483134, 79.92603816, 'Hand damaged', '', '2025-10-04 11:31:25', 'pending', NULL, NULL, NULL, NULL, 0),
(9, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-04', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154840, Lng: 79.926024)', 23.15484042, 79.92602427, 'Testing 7', '', '2025-10-04 11:44:15', 'resolved', 'completed', 'Driver ID: 1 | Vehicle: DL01AB1234', '2025-10-06 04:46:16', '2025-10-06 04:46:37', 1),
(10, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-06', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155037, Lng: 79.925987)', 23.15503750, 79.92598680, 'Full mental patient', '', '2025-10-06 08:37:50', 'pending', NULL, NULL, NULL, NULL, 0),
(11, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155066, Lng: 79.926018)', 23.15506580, 79.92601770, 'No one want to touch it', '', '2025-10-06 08:38:51', 'pending', NULL, NULL, NULL, NULL, 0),
(12, 'Shreyash', '9755833563', 'mp20ch8790', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155106, Lng: 79.926047)', 23.15510620, 79.92604700, 'Bone breaked', '', '2025-10-06 08:54:58', 'pending', NULL, NULL, NULL, NULL, 0),
(13, 'Shreyash', '9755833563', 'mp20ch8790', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155089, Lng: 79.926035)', 23.15508940, 79.92603490, 'Good one', '', '2025-10-06 08:55:22', 'pending', NULL, NULL, NULL, NULL, 0),
(14, 'Shreyash', '9755833563', 'mp20ch8790', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155089, Lng: 79.926035)', 23.15508940, 79.92603490, 'Keeping', '', '2025-10-06 08:55:50', 'pending', NULL, NULL, NULL, NULL, 0),
(15, 'dhaneshwari', '7806062421', 'mp20ch8799', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155072, Lng: 79.926017)', 23.15507170, 79.92601740, 'Headache', '', '2025-10-06 08:56:28', 'pending', 'assigned', 'Driver ID: 1 | Vehicle: DL01AB1234', '2025-10-06 09:24:25', NULL, 0),
(16, 'dhaneshwari', '7806062421', 'mp20ch8799', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155072, Lng: 79.926017)', 23.15507170, 79.92601740, 'Breake hand', '', '2025-10-06 08:57:26', 'resolved', 'completed', 'Driver ID: 1 | Vehicle: DL01AB1234', '2025-10-06 09:18:39', '2025-10-06 09:19:23', 1),
(17, 'mehak', '8959176446', 'mp20ac3800', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155087, Lng: 79.926030)', 23.15508700, 79.92603040, 'testing', '', '2025-10-06 09:28:59', 'pending', NULL, NULL, NULL, NULL, 0),
(18, 'Shreyash', '9755833563', 'mp20ch8790', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155135, Lng: 79.926027)', 23.15513520, 79.92602700, 'Testing 7', '', '2025-10-06 09:30:27', 'pending', NULL, NULL, NULL, NULL, 0),
(19, 'siddharth', '7898140799', 'Mp20ZB6308', '2025-10-07', 'shanti nagar, Mayur Nagar, Musakhedi, Indore, Madhya Pradesh 452001, India (Lat: 22.700200, Lng: 75.907800)', 22.70020000, 75.90780000, 'siddd', '', '2025-10-07 09:56:52', 'pending', NULL, NULL, NULL, NULL, 0),
(20, 'siddharth', '7898140799', 'MP20ZB6308', '2025-10-09', '9FHM+X7 Barkhedi Abdulla, Madhya Pradesh, India (Lat: 23.380000, Lng: 77.483200)', 23.38000000, 77.48320000, 'ssd', '', '2025-10-09 07:25:12', 'pending', NULL, NULL, NULL, NULL, 0);

--
-- Triggers `accidents`
--
DELIMITER $$
CREATE TRIGGER `update_driver_details` BEFORE UPDATE ON `accidents` FOR EACH ROW BEGIN
    -- If driver_details is being set and it wasn't set before, update accepted_at
    IF NEW.driver_details IS NOT NULL AND OLD.driver_details IS NULL THEN
        SET NEW.accepted_at = NOW();
        SET NEW.driver_status = 'assigned';
    END IF;
    
    -- If driver_status is being updated to 'completed', set completed_at
    IF NEW.driver_status = 'completed' AND OLD.driver_status != 'completed' THEN
        SET NEW.completed_at = NOW();
    END IF;
END
$$
DELIMITER ;

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
(17, 23, '1758626019_Generated Image September 23, 2025 - 11_49AM.png'),
(20, 31, '1758964097_main-banner1 (1).jpg'),
(21, 32, '1758965091_image3.png'),
(22, 33, '1758971930_About US - The TOSS Journey.png'),
(23, 34, '1758974007_image5.png'),
(24, 35, '1758974469_image4.png'),
(25, 37, '1759128490_mlogo1.png'),
(26, 38, '1759146052_apatkal advertiser.png'),
(27, 39, '1759473061_screencapture-localhost-apatkal-2-apatkal-apatkal-adminn-client-list-php-2025-09-25-18_44_02.png'),
(28, 40, '1759473927_screencapture-localhost-apatkal-2-apatkal-client-family-php-2025-09-25-17_19_17.png'),
(29, 41, '1759474344_screencapture-localhost-apatkal-2-apatkal-apatkal-adminn-sales-reports-php-2025-09-25-15_50_01.png'),
(30, 42, '1759474404_screencapture-localhost-apatkal-2-apatkal-apatkal-adminn-sales-reports-php-2025-09-25-15_50_12.png'),
(31, 43, '1759474444_screencapture-localhost-apatkal-2-apatkal-client-dashboard-php-2025-09-25-17_18_47.png'),
(32, 44, '1759474805_screencapture-localhost-apatkal-2-apatkal-client-dashboard-php-2025-09-25-17_18_47.png'),
(33, 45, '1759475323_screencapture-localhost-apatkal-2-apatkal-client-family-php-2025-09-25-17_19_17.png'),
(34, 47, '1759475543_screencapture-localhost-apatkal-2-apatkal-apatkal-adminn-sales-reports-php-2025-09-25-15_50_01.png'),
(35, 48, '1759475911_screencapture-localhost-apatkal-2-apatkal-apatkal-adminn-dashboard-php-2025-09-25-15_47_33.png'),
(36, 49, '1759492079_screencapture-localhost-apatkal-2-apatkal-client-family-php-2025-09-25-17_19_17.png'),
(37, 3, '1759573920_screencapture-localhost-apatkal-2-apatkal-client-dashboard-php-2025-09-25-17_18_47.png'),
(38, 4, '1759574376_screencapture-tossconsultancyservices-atlassian-net-jira-software-projects-AWA-boards-101-2025-09-23-14_14_42.png'),
(39, 5, '1759574753_screencapture-tossconsultancyservices-atlassian-net-jira-software-projects-AWA-boards-101-2025-09-23-11_43_19.png'),
(40, 6, '1759574801_screencapture-103-14-120-163-8083-projects-21-data-2025-09-22-16_25_33.png'),
(41, 7, '1759574847_screencapture-localhost-IT-Assets-reports-php-2025-09-19-15_04_48.png'),
(42, 8, '1759577485_Moon.jpg'),
(43, 10, '1759739870_screencapture-apatkal-in-2025-09-05-10_02_48.png'),
(44, 11, '1759739931_screencapture-tossconsultancyservices-atlassian-net-jira-software-projects-AWA-boards-101-2025-09-23-11_43_19.png'),
(45, 12, '1759740898_systems-status-chart.png'),
(46, 13, '1759740922_screencapture-localhost-IT-Assets-systems-php-2025-09-19-15_04_32.png'),
(47, 14, '1759740950_WhatsApp Image 2025-09-04 at 12.36.55 PM.jpeg'),
(48, 15, '1759740988_WhatsApp Image 2025-09-04 at 12.22.02 PM.jpeg'),
(49, 16, '1759741046_WhatsApp Image 2025-09-04 at 12.22.02 PM.jpeg'),
(50, 17, '1759742939_screencapture-103-14-120-163-8083-projects-2025-09-22-16_24_48.png'),
(51, 18, '1759743027_screencapture-tossconsultancyservices-atlassian-net-jira-software-projects-AWA-boards-101-2025-09-23-14_14_42.png'),
(52, 19, '1759831012_screencapture-localhost-apatkal-2-apatkal-apatkal-adminn-client-list-php-2025-09-25-18_44_02.png'),
(53, 20, '1759994712_screencapture-localhost-apatkal-2-apatkal-client-family-php-2025-09-25-17_19_17.png');

-- --------------------------------------------------------

--
-- Table structure for table `accident_remarks`
--

CREATE TABLE `accident_remarks` (
  `id` int(11) NOT NULL,
  `accident_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_role` varchar(50) NOT NULL,
  `remark` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
-- Table structure for table `admin_profiles`
--

CREATE TABLE `admin_profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_profiles`
--

INSERT INTO `admin_profiles` (`id`, `user_id`, `first_name`, `last_name`, `email`, `phone`, `bio`, `profile_image`, `created_at`, `updated_at`) VALUES
(1, 1, 'Admin', 'User', 'admin@apatkal.com', '', 'Administrator', 'admin_profile_1_1758795302.jpeg', '2025-09-25 14:38:18', '2025-09-25 15:45:40');

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
  `qr_code` varchar(255) DEFAULT NULL,
  `vehicle_type` enum('two-wheeler','three-wheeler','four-wheeler') DEFAULT 'four-wheeler',
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
  `status` enum('paid','unpaid') DEFAULT 'unpaid',
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`id`, `full_name`, `mobile_no`, `email`, `vehicle_no`, `qr_code`, `vehicle_type`, `created_date`, `house_no`, `address`, `landmark`, `state`, `district`, `city`, `pincode`, `added_by`, `assigned_staff`, `photo`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(11, 'siddharth', '9508570649', 'siddharth.toss.cs@gmail.com', 'MP20KJ0005', NULL, 'four-wheeler', '2025-09-17', NULL, 'hhgdrt', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'unpaid', NULL, '2025-09-17 15:25:38', '2025-09-27 11:59:58'),
(26, 'Krishna Vishwakarma', '8959176446', 'Krishna.vishwakarma@tosssolution.in', 'mp20ab2010', NULL, 'four-wheeler', '2025-09-27', NULL, 'Toss solution Jabalpur', NULL, '', '', '', '482001', 1, NULL, NULL, 'unpaid', NULL, '2025-09-27 13:37:09', '2025-09-27 13:37:09'),
(31, 'Shreyash', '9755833563', 'toss125training@gmail.com', 'mp20ch8790', NULL, 'two-wheeler', '2025-10-04', NULL, 'Shastri nagar', NULL, 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482001', 1, NULL, NULL, 'unpaid', NULL, '2025-10-04 16:26:11', '2025-10-04 16:26:11'),
(32, 'dhaneshwari', '7806062421', 'admin@company.com', 'mp20ch8799', NULL, 'two-wheeler', '2025-10-04', NULL, 'ssd', NULL, 'Madhya Pradesh', 'Narsinghpur', 'NA', '487118', 1, NULL, NULL, 'unpaid', NULL, '2025-10-04 16:53:06', '2025-10-04 16:53:06'),
(40, 'Geetanjali', '7694975579', 'geetanjali.tosscs@gmail.com', 'mp20ch8732', 'uploads/qr_codes/client_40_1760088657.png', 'four-wheeler', '2025-10-06', '', 'jabalpur mm', '', 'Madhya Pradesh', 'Shahdol', 'Beohari', '484774', 1, 13, 'uploads/clients/client_1759821308_68e4bdfcca87d.png', 'unpaid', NULL, '2025-10-06 13:40:48', '2025-10-10 15:00:57'),
(42, 'swayam', '9508570648', 'siddharth.toss.cs@gmail.com', 'MP20KJ0002', 'uploads/qr_codes/client_42_1760088545.png', 'four-wheeler', '2025-10-08', '0255', 'shastri nagar', 'sd', 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482002', 13, NULL, NULL, 'paid', '', '2025-10-08 12:04:54', '2025-10-10 14:59:05'),
(46, 'siddharth', '7898140799', 'siddharth.toss.cs@gmail.com', 'MP20PH2524', 'uploads/qr_codes/client_46_1760088411.png', 'two-wheeler', '2025-10-10', NULL, 'dedf', NULL, 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482001', 1, NULL, NULL, 'unpaid', NULL, '2025-10-10 13:45:33', '2025-10-10 14:56:51'),
(47, 'Test', '9508570685', 'shreyash.toss.cs@gmail.com', 'MP20KJ0065', NULL, 'two-wheeler', '2025-10-10', '0255', 'sfsdf', 'sd', 'Madhya Pradesh', 'Shahdol', 'Beohari', '482652', 13, NULL, NULL, 'paid', 'd', '2025-10-10 17:02:56', '2025-10-10 17:02:56');

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
(16, 11, 'Test', '7898140799', 'admintest@apatkal.com', 'daughter', '2025-09-25', NULL, NULL, 0, NULL, '2025-09-25 19:04:30', '2025-09-25 19:04:30'),
(20, 26, 'Krishna Vishwakarma', '7869722272', 'toss125training@gmail.com', 'son', '2025-10-01', 'Toss solution Jabalpur', NULL, 1, NULL, '2025-09-27 13:59:40', '2025-09-27 13:59:40'),
(21, 33, 'siddharth', '9555363996', 'sid@gmail.com', 'brother', '2003-02-21', 'few', NULL, 1, NULL, '2025-10-03 13:21:57', '2025-10-03 13:21:57'),
(22, 40, 'swayam', '9555363996', 'siddharth.toss.cs@gmail.com', 'brother', '2222-12-22', 'wwww', NULL, 1, 'eer', '2025-10-07 12:18:22', '2025-10-07 12:52:15');

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
(3, 11, '9508570649', '$2y$10$7js7HmTTivXLz4erd1bwx.Zb6U.EI.3lpivJnErHZAKadoSL9wtU2', 'active', NULL, '2025-09-17 15:25:38', '2025-09-22 15:46:08'),
(16, 26, '8959176446', '$2y$10$w/J.IYdmt.IKe/0CDWrsTOpe5l.OhICXUNQ548yrpDdjCkedVAg66', 'active', NULL, '2025-09-27 13:37:09', '2025-09-27 13:37:09'),
(25, 31, '9755833563', '$2y$10$v7SIFFRWL5O165iUIHfm0OaD8ieOk8PNtMWt88eApdIwEvHzLEjIS', 'active', NULL, '2025-10-04 16:26:11', '2025-10-06 13:29:57'),
(26, 32, '7806062421', '$2y$10$gJb.iYHYuiQLIYISVxvVL.WiHpDn15bMq199vwbA.Ix0N9YqnUN9S', 'active', NULL, '2025-10-04 16:53:06', '2025-10-06 13:29:22'),
(28, 40, '7694975579', '$2y$10$a2glOoM/bamJkcP12om.ruoUyMJaD70BK7T4Xt8J5DoWwi1pmFH2C', 'active', NULL, '2025-10-06 13:40:48', '2025-10-06 13:40:48'),
(30, 42, '9508570648', '$2y$10$o2i4c6FN10yAVtIHu1sdLevrp.ZgHThmYQZHhoQvMA58eakBC5b7a', 'active', NULL, '2025-10-08 12:04:54', '2025-10-08 12:04:54'),
(32, 46, '7898140799', '$2y$10$Qj6cXZ52I.eJ86ucAKyxweRPEgXtAbV8dkVRGHX6xlTGY5SUTc/r.', 'active', NULL, '2025-10-10 13:45:33', '2025-10-10 13:45:33'),
(33, 47, '9508570685', '$2y$10$pGxl9p3ZjWXvQrQq0LRU3OkNrVyoG.dDORUDWkplUIcFj1ruqUMPC', 'active', NULL, '2025-10-10 17:02:56', '2025-10-10 17:02:56');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `remark` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `name`, `mobile`, `email`, `message`, `status`, `created_at`, `remark`) VALUES
(1, 'test', '8959176446', 'test@test.com', 'test', 'resolved', '2025-09-13 18:40:52', NULL),
(3, 'siddharth', '7888886523', 'siddharth.toss.cs@gmail.com', 'dffffffffffffff', 'pending', '2025-09-17 08:07:31', NULL),
(5, 'new', '9876543210', 'Toss125training@gmail.com', 'dwsasfsdf', 'resolved', '2025-09-29 08:25:44', NULL),
(6, 'image', '9876543210', 'saddfs@gmail.com', 'testing processsss', 'pending', '2025-09-29 09:12:52', NULL);

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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `kyc_status` enum('pending','approved','rejected') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `drivers`
--

INSERT INTO `drivers` (`id`, `driver_name`, `email`, `password`, `number`, `address`, `vehicle_type`, `vehicle_number`, `model_rating`, `aadhar_photo`, `licence_photo`, `rc_photo`, `created_at`, `updated_at`, `kyc_status`) VALUES
(1, 'Rajesh Sharma', 'rajesh.sharma90@gmail.com', '$2y$10$X7jMStqD5ERzpsgYXhu.Mejq1YKUHLbtN9GpWmj/tbrpZSRf9be5i', '9876543210', '123, Gandhi Marg, Sue Delhi', 'Ambulance', 'DL01AB1234', 4.8, 'aadhar_rajash.jpg', 'licence_rajash.jpg', 'rc_rajash.jpg', '2025-09-24 05:52:18', '2025-10-08 05:38:23', 'rejected'),
(2, 'Dhaneshwari Patel', 'dhaneshwari17@gmail.com', '$2y$10$FmHuB6iiE1YqLNBb4hRfjOR2WQfFIR7EcOspYG7FJJqItOK0IRu9q', '7945681234', 'beohari mp', 'Ambulance', 'mp20mz4528', NULL, 'screencapture-103-14-120-163-8083-organization-2025-09-22-16_26_14.png', 'screencapture-103-14-120-163-8083-organization-2025-09-22-16_26_14.png', 'screencapture-tossconsultancyservices-atlassian-net-jira-software-projects-AWA-boards-101-2025-09-23-11_43_19.png', '2025-09-25 04:20:15', '2025-10-07 11:23:03', 'pending'),
(3, 'amit', 'kalmaliindia@gmail.com', '$2y$10$5umnfnk.EgxwjelKFomLLekkdsYdHe6FKGVNkGWILLhim6j1lgvna', '8770658824', 'jabalpur', 'ambulance', 'mp20ja6365', NULL, 'JPEG_20250927_235821_3502812970878090506.jpg', 'JPEG_20250927_235827_7286715491207715510.jpg', 'default_rc.jpg', '2025-09-27 18:28:45', '2025-10-07 11:01:07', 'approved');

-- --------------------------------------------------------

--
-- Table structure for table `earnings`
--

CREATE TABLE `earnings` (
  `id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `trip_id` int(11) DEFAULT NULL,
  `amount` decimal(8,2) NOT NULL,
  `earning_date` date NOT NULL,
  `created_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `earnings`
--

INSERT INTO `earnings` (`id`, `driver_id`, `trip_id`, `amount`, `earning_date`, `created_time`) VALUES
(1, 1, 1, 1800.00, '2025-09-20', '2025-09-20 09:50:00'),
(2, 1, 2, 2200.00, '2025-09-27', '2025-09-27 04:50:00'),
(3, 1, 3, 1950.00, '2025-10-01', '2025-10-01 12:10:00');

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
-- Table structure for table `family_members`
--

CREATE TABLE `family_members` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `relationship` varchar(100) NOT NULL,
  `mobile_no` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `family_members`
--

INSERT INTO `family_members` (`id`, `client_id`, `full_name`, `relationship`, `mobile_no`, `email`, `date_of_birth`, `address`, `created_at`, `updated_at`) VALUES
(2, 10, 'shivam kumar', 'brother', '7723065844', 'siddharth.toss.cs@gmail.com', '2025-09-24', 'efwat', '2025-09-25 18:02:10', '2025-09-25 18:02:10');

-- --------------------------------------------------------

--
-- Table structure for table `header_config`
--

CREATE TABLE `header_config` (
  `id` int(11) NOT NULL,
  `config_key` varchar(100) NOT NULL,
  `config_value` text NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `header_config`
--

INSERT INTO `header_config` (`id`, `config_key`, `config_value`, `description`, `created_at`, `updated_at`) VALUES
(1, 'site_title', 'Apatkal Emergency Services', 'Main site title displayed in header', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(2, 'header_phone', '18005709696', 'Main contact phone number', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(3, 'header_email', 'apatkalindia@gmail.com', 'Main contact email', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(4, 'emergency_phone', '18005709696', 'Emergency contact phone number', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(5, 'emergency_text', '24/7 Emergency Service', 'Emergency service text', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(6, 'facebook_url', 'https://www.facebook.com/people/Apatkal-India/61573752802887/', 'Facebook page URL', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(7, 'youtube_url', 'https://www.youtube.com/channel/UC_9OYRqF_1NiEC3_06ZPSXQ', 'YouTube channel URL', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(8, 'linkedin_url', 'https://www.linkedin.com/company/mgaus-information-technology/', 'LinkedIn company URL', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(9, 'instagram_url', 'https://www.instagram.com/apatkal.india/', 'Instagram page URL', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(10, 'logo_image', 'images/mlogo1.png', 'Path to logo image', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(11, 'logo_alt', 'Apatkal Logo', 'Alt text for logo image', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(12, 'logo_height', '45px', 'Logo height in CSS units', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(13, 'top_bar_enabled', '1', 'Enable/disable top bar (1=enabled, 0=disabled)', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(14, 'social_links_enabled', '1', 'Enable/disable social links (1=enabled, 0=disabled)', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(15, 'emergency_pulse_enabled', '1', 'Enable/disable emergency pulse animation (1=enabled, 0=disabled)', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(16, 'floating_call_enabled', '1', 'Enable/disable floating call button on mobile (1=enabled, 0=disabled)', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(17, 'mobile_menu_enabled', '1', 'Enable/disable mobile menu (1=enabled, 0=disabled)', '2025-10-04 07:37:14', '2025-10-04 07:37:14'),
(18, 'particles_enabled', '1', 'Enable/disable background particles (1=enabled, 0=disabled)', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(19, 'floating_elements_enabled', '1', 'Enable/disable floating background elements (1=enabled, 0=disabled)', '2025-10-04 07:37:14', '2025-10-04 09:01:53'),
(182, 'nav_home_text', 'HOME', 'Navigation Home text', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(183, 'nav_home_icon', 'fas fa-home', 'Navigation Home icon class', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(184, 'nav_home_url', 'index.php', 'Navigation Home URL', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(185, 'nav_about_text', 'ABOUT', 'Navigation About text', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(186, 'nav_about_icon', 'fas fa-info-circle', 'Navigation About icon class', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(187, 'nav_about_url', 'about.php', 'Navigation About URL', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(188, 'nav_plans_text', 'PLANS', 'Navigation Plans text', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(189, 'nav_plans_icon', 'fas fa-clipboard-list', 'Navigation Plans icon class', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(190, 'nav_plans_url', 'plan.php', 'Navigation Plans URL', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(191, 'nav_accident_text', 'SUBMIT ACCIDENT INFO', 'Navigation Accident text', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(192, 'nav_accident_icon', 'fas fa-exclamation-triangle', 'Navigation Accident icon class', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(193, 'nav_accident_url', 'submitaccident.php', 'Navigation Accident URL', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(194, 'nav_contact_text', 'CONTACT', 'Navigation Contact text', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(195, 'nav_contact_icon', 'fas fa-phone-alt', 'Navigation Contact icon class', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(196, 'nav_contact_url', 'contact.php', 'Navigation Contact URL', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(197, 'login_button_text', 'LOGIN', 'Login button text', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(198, 'login_button_icon', 'fas fa-sign-in-alt', 'Login button icon class', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(199, 'login_button_url', 'client_login.php', 'Login button URL', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(200, 'register_button_text', 'REGISTER', 'Register button text', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(201, 'register_button_icon', 'fas fa-user-plus', 'Register button icon class', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(202, 'register_button_url', 'client_register.php', 'Register button URL', '2025-10-04 08:35:46', '2025-10-04 09:01:53'),
(203, 'logo_upload_enabled', '1', 'Enable logo upload functionality (1=enabled, 0=disabled)', '2025-10-04 08:35:46', '2025-10-04 08:35:46'),
(247, 'logo_upload', '', NULL, '2025-10-04 08:36:16', '2025-10-04 09:01:53');

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
-- Table structure for table `payment_transactions`
--

CREATE TABLE `payment_transactions` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('phonepe','upi','card','netbanking','wallet','cash','cheque') NOT NULL DEFAULT 'phonepe',
  `transaction_id` varchar(255) NOT NULL,
  `gateway_transaction_id` varchar(255) DEFAULT NULL,
  `gateway_response` text DEFAULT NULL,
  `status` enum('pending','completed','failed','cancelled','refunded') DEFAULT 'pending',
  `payment_date` datetime DEFAULT NULL,
  `refund_date` datetime DEFAULT NULL,
  `refund_amount` decimal(10,2) DEFAULT NULL,
  `refund_reason` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_transactions`
--

INSERT INTO `payment_transactions` (`id`, `client_id`, `amount`, `payment_method`, `transaction_id`, `gateway_transaction_id`, `gateway_response`, `status`, `payment_date`, `refund_date`, `refund_amount`, `refund_reason`, `created_at`, `updated_at`) VALUES
(6, 26, 1000.00, 'phonepe', 'TXN_1758960451_26', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, '2025-09-27 13:37:32', '2025-09-27 13:37:32');

-- --------------------------------------------------------

--
-- Table structure for table `qr_codes`
--

CREATE TABLE `qr_codes` (
  `id` int(10) UNSIGNED NOT NULL,
  `qr_number` int(10) UNSIGNED NOT NULL,
  `qr_url` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `qr_codes`
--

INSERT INTO `qr_codes` (`id`, `qr_number`, `qr_url`, `created_at`) VALUES
(133, 1, '/submitaccident.php?qr=1', '2025-10-10 16:22:18'),
(134, 2, '/submitaccident.php?qr=2', '2025-10-10 16:22:18'),
(135, 3, '/submitaccident.php?qr=3', '2025-10-10 16:22:18'),
(136, 4, '/submitaccident.php?qr=4', '2025-10-10 16:22:18'),
(137, 5, '/submitaccident.php?qr=5', '2025-10-10 16:22:18'),
(138, 6, '/submitaccident.php?qr=6', '2025-10-10 16:22:18'),
(139, 7, '/submitaccident.php?qr=7', '2025-10-10 16:22:18'),
(140, 8, '/submitaccident.php?qr=8', '2025-10-10 16:22:18'),
(141, 9, '/submitaccident.php?qr=9', '2025-10-10 16:22:18'),
(142, 10, '/submitaccident.php?qr=10', '2025-10-10 16:22:18'),
(143, 11, '/submitaccident.php?qr=11', '2025-10-10 16:25:40'),
(144, 12, '/submitaccident.php?qr=12', '2025-10-10 16:25:40'),
(145, 13, '/submitaccident.php?qr=13', '2025-10-10 16:25:40'),
(146, 14, '/submitaccident.php?qr=14', '2025-10-10 16:25:40'),
(147, 15, '/submitaccident.php?qr=15', '2025-10-10 16:25:40'),
(148, 16, '/submitaccident.php?qr=16', '2025-10-10 16:25:40'),
(149, 17, '/submitaccident.php?qr=17', '2025-10-10 16:25:40'),
(150, 18, '/submitaccident.php?qr=18', '2025-10-10 16:25:40'),
(151, 19, '/submitaccident.php?qr=19', '2025-10-10 16:25:40'),
(152, 20, '/submitaccident.php?qr=20', '2025-10-10 16:25:40'),
(153, 21, '/submitaccident.php?qr=21', '2025-10-13 10:59:28'),
(154, 22, '/submitaccident.php?qr=22', '2025-10-13 10:59:28'),
(155, 23, '/submitaccident.php?qr=23', '2025-10-13 10:59:28'),
(156, 24, '/submitaccident.php?qr=24', '2025-10-13 10:59:28'),
(157, 25, '/submitaccident.php?qr=25', '2025-10-13 10:59:28'),
(158, 26, '/submitaccident.php?qr=26', '2025-10-13 10:59:28'),
(159, 27, '/submitaccident.php?qr=27', '2025-10-13 10:59:28'),
(160, 28, '/submitaccident.php?qr=28', '2025-10-13 10:59:28'),
(161, 29, '/submitaccident.php?qr=29', '2025-10-13 10:59:28'),
(162, 30, '/submitaccident.php?qr=30', '2025-10-13 10:59:28'),
(163, 31, '/submitaccident.php?qr=31', '2025-10-13 10:59:28'),
(164, 32, '/submitaccident.php?qr=32', '2025-10-13 10:59:28'),
(165, 33, '/submitaccident.php?qr=33', '2025-10-13 10:59:28'),
(166, 34, '/submitaccident.php?qr=34', '2025-10-13 10:59:28'),
(167, 35, '/submitaccident.php?qr=35', '2025-10-13 10:59:28'),
(168, 36, '/submitaccident.php?qr=36', '2025-10-13 10:59:28'),
(169, 37, '/submitaccident.php?qr=37', '2025-10-13 10:59:28'),
(170, 38, '/submitaccident.php?qr=38', '2025-10-13 10:59:28'),
(171, 39, '/submitaccident.php?qr=39', '2025-10-13 10:59:28'),
(172, 40, '/submitaccident.php?qr=40', '2025-10-13 10:59:28'),
(173, 41, '/submitaccident.php?qr=41', '2025-10-13 10:59:28'),
(174, 42, '/submitaccident.php?qr=42', '2025-10-13 10:59:28'),
(175, 43, '/submitaccident.php?qr=43', '2025-10-13 10:59:28'),
(176, 44, '/submitaccident.php?qr=44', '2025-10-13 10:59:28'),
(177, 45, '/submitaccident.php?qr=45', '2025-10-13 10:59:28'),
(178, 46, '/submitaccident.php?qr=46', '2025-10-13 10:59:28'),
(179, 47, '/submitaccident.php?qr=47', '2025-10-13 10:59:28'),
(180, 48, '/submitaccident.php?qr=48', '2025-10-13 10:59:28'),
(181, 49, '/submitaccident.php?qr=49', '2025-10-13 10:59:28'),
(182, 50, '/submitaccident.php?qr=50', '2025-10-13 10:59:28'),
(183, 51, '/submitaccident.php?qr=51', '2025-10-13 10:59:28'),
(184, 52, '/submitaccident.php?qr=52', '2025-10-13 10:59:28'),
(185, 53, '/submitaccident.php?qr=53', '2025-10-13 10:59:28'),
(186, 54, '/submitaccident.php?qr=54', '2025-10-13 10:59:28'),
(187, 55, '/submitaccident.php?qr=55', '2025-10-13 10:59:28'),
(188, 56, '/submitaccident.php?qr=56', '2025-10-13 10:59:28'),
(189, 57, '/submitaccident.php?qr=57', '2025-10-13 10:59:28'),
(190, 58, '/submitaccident.php?qr=58', '2025-10-13 10:59:28'),
(191, 59, '/submitaccident.php?qr=59', '2025-10-13 10:59:28'),
(192, 60, '/submitaccident.php?qr=60', '2025-10-13 10:59:28'),
(193, 61, '/submitaccident.php?qr=61', '2025-10-13 10:59:28'),
(194, 62, '/submitaccident.php?qr=62', '2025-10-13 10:59:28'),
(195, 63, '/submitaccident.php?qr=63', '2025-10-13 10:59:28'),
(196, 64, '/submitaccident.php?qr=64', '2025-10-13 10:59:28'),
(197, 65, '/submitaccident.php?qr=65', '2025-10-13 10:59:28'),
(198, 66, '/submitaccident.php?qr=66', '2025-10-13 10:59:28'),
(199, 67, '/submitaccident.php?qr=67', '2025-10-13 10:59:28'),
(200, 68, '/submitaccident.php?qr=68', '2025-10-13 10:59:28'),
(201, 69, '/submitaccident.php?qr=69', '2025-10-13 10:59:28'),
(202, 70, '/submitaccident.php?qr=70', '2025-10-13 10:59:28'),
(203, 71, '/submitaccident.php?qr=71', '2025-10-13 10:59:28'),
(204, 72, '/submitaccident.php?qr=72', '2025-10-13 10:59:28'),
(205, 73, '/submitaccident.php?qr=73', '2025-10-13 10:59:28'),
(206, 74, '/submitaccident.php?qr=74', '2025-10-13 10:59:28'),
(207, 75, '/submitaccident.php?qr=75', '2025-10-13 10:59:28'),
(208, 76, '/submitaccident.php?qr=76', '2025-10-13 10:59:28'),
(209, 77, '/submitaccident.php?qr=77', '2025-10-13 10:59:28'),
(210, 78, '/submitaccident.php?qr=78', '2025-10-13 10:59:28'),
(211, 79, '/submitaccident.php?qr=79', '2025-10-13 10:59:28'),
(212, 80, '/submitaccident.php?qr=80', '2025-10-13 10:59:28'),
(213, 81, '/submitaccident.php?qr=81', '2025-10-13 10:59:28'),
(214, 82, '/submitaccident.php?qr=82', '2025-10-13 10:59:28'),
(215, 83, '/submitaccident.php?qr=83', '2025-10-13 10:59:28'),
(216, 84, '/submitaccident.php?qr=84', '2025-10-13 10:59:28'),
(217, 85, '/submitaccident.php?qr=85', '2025-10-13 10:59:28'),
(218, 86, '/submitaccident.php?qr=86', '2025-10-13 10:59:28'),
(219, 87, '/submitaccident.php?qr=87', '2025-10-13 10:59:28'),
(220, 88, '/submitaccident.php?qr=88', '2025-10-13 10:59:28'),
(221, 89, '/submitaccident.php?qr=89', '2025-10-13 10:59:28'),
(222, 90, '/submitaccident.php?qr=90', '2025-10-13 10:59:28'),
(223, 91, '/submitaccident.php?qr=91', '2025-10-13 10:59:28'),
(224, 92, '/submitaccident.php?qr=92', '2025-10-13 10:59:28'),
(225, 93, '/submitaccident.php?qr=93', '2025-10-13 10:59:28'),
(226, 94, '/submitaccident.php?qr=94', '2025-10-13 10:59:28'),
(227, 95, '/submitaccident.php?qr=95', '2025-10-13 10:59:28'),
(228, 96, '/submitaccident.php?qr=96', '2025-10-13 10:59:28'),
(229, 97, '/submitaccident.php?qr=97', '2025-10-13 10:59:28'),
(230, 98, '/submitaccident.php?qr=98', '2025-10-13 10:59:28'),
(231, 99, '/submitaccident.php?qr=99', '2025-10-13 10:59:28'),
(232, 100, '/submitaccident.php?qr=100', '2025-10-13 10:59:28'),
(233, 101, '/submitaccident.php?qr=101', '2025-10-13 10:59:28'),
(234, 102, '/submitaccident.php?qr=102', '2025-10-13 10:59:28'),
(235, 103, '/submitaccident.php?qr=103', '2025-10-13 10:59:28'),
(236, 104, '/submitaccident.php?qr=104', '2025-10-13 10:59:28'),
(237, 105, '/submitaccident.php?qr=105', '2025-10-13 10:59:28'),
(238, 106, '/submitaccident.php?qr=106', '2025-10-13 10:59:28'),
(239, 107, '/submitaccident.php?qr=107', '2025-10-13 10:59:28'),
(240, 108, '/submitaccident.php?qr=108', '2025-10-13 10:59:28'),
(241, 109, '/submitaccident.php?qr=109', '2025-10-13 10:59:28'),
(242, 110, '/submitaccident.php?qr=110', '2025-10-13 10:59:28'),
(243, 111, '/submitaccident.php?qr=111', '2025-10-13 10:59:28'),
(244, 112, '/submitaccident.php?qr=112', '2025-10-13 10:59:28'),
(245, 113, '/submitaccident.php?qr=113', '2025-10-13 10:59:28'),
(246, 114, '/submitaccident.php?qr=114', '2025-10-13 10:59:28'),
(247, 115, '/submitaccident.php?qr=115', '2025-10-13 10:59:28'),
(248, 116, '/submitaccident.php?qr=116', '2025-10-13 10:59:28'),
(249, 117, '/submitaccident.php?qr=117', '2025-10-13 10:59:28'),
(250, 118, '/submitaccident.php?qr=118', '2025-10-13 10:59:28'),
(251, 119, '/submitaccident.php?qr=119', '2025-10-13 10:59:28'),
(252, 120, '/submitaccident.php?qr=120', '2025-10-13 10:59:28'),
(253, 121, '/submitaccident.php?qr=121', '2025-10-13 10:59:28'),
(254, 122, '/submitaccident.php?qr=122', '2025-10-13 10:59:28'),
(255, 123, '/submitaccident.php?qr=123', '2025-10-13 10:59:28'),
(256, 124, '/submitaccident.php?qr=124', '2025-10-13 10:59:28'),
(257, 125, '/submitaccident.php?qr=125', '2025-10-13 10:59:28'),
(258, 126, '/submitaccident.php?qr=126', '2025-10-13 10:59:28'),
(259, 127, '/submitaccident.php?qr=127', '2025-10-13 10:59:28'),
(260, 128, '/submitaccident.php?qr=128', '2025-10-13 10:59:28'),
(261, 129, '/submitaccident.php?qr=129', '2025-10-13 10:59:28'),
(262, 130, '/submitaccident.php?qr=130', '2025-10-13 10:59:28'),
(263, 131, '/submitaccident.php?qr=131', '2025-10-13 10:59:28'),
(264, 132, '/submitaccident.php?qr=132', '2025-10-13 10:59:28'),
(265, 133, '/submitaccident.php?qr=133', '2025-10-13 10:59:28'),
(266, 134, '/submitaccident.php?qr=134', '2025-10-13 10:59:28'),
(267, 135, '/submitaccident.php?qr=135', '2025-10-13 10:59:28'),
(268, 136, '/submitaccident.php?qr=136', '2025-10-13 10:59:28'),
(269, 137, '/submitaccident.php?qr=137', '2025-10-13 10:59:28'),
(270, 138, '/submitaccident.php?qr=138', '2025-10-13 10:59:28'),
(271, 139, '/submitaccident.php?qr=139', '2025-10-13 10:59:28'),
(272, 140, '/submitaccident.php?qr=140', '2025-10-13 10:59:28'),
(273, 141, '/submitaccident.php?qr=141', '2025-10-13 10:59:28'),
(274, 142, '/submitaccident.php?qr=142', '2025-10-13 10:59:28'),
(275, 143, '/submitaccident.php?qr=143', '2025-10-13 10:59:28'),
(276, 144, '/submitaccident.php?qr=144', '2025-10-13 10:59:28'),
(277, 145, '/submitaccident.php?qr=145', '2025-10-13 10:59:28'),
(278, 146, '/submitaccident.php?qr=146', '2025-10-13 10:59:28'),
(279, 147, '/submitaccident.php?qr=147', '2025-10-13 10:59:28'),
(280, 148, '/submitaccident.php?qr=148', '2025-10-13 10:59:28'),
(281, 149, '/submitaccident.php?qr=149', '2025-10-13 10:59:28'),
(282, 150, '/submitaccident.php?qr=150', '2025-10-13 10:59:28'),
(283, 151, '/submitaccident.php?qr=151', '2025-10-13 10:59:28'),
(284, 152, '/submitaccident.php?qr=152', '2025-10-13 10:59:28'),
(285, 153, '/submitaccident.php?qr=153', '2025-10-13 10:59:28'),
(286, 154, '/submitaccident.php?qr=154', '2025-10-13 10:59:28'),
(287, 155, '/submitaccident.php?qr=155', '2025-10-13 10:59:28'),
(288, 156, '/submitaccident.php?qr=156', '2025-10-13 10:59:28'),
(289, 157, '/submitaccident.php?qr=157', '2025-10-13 10:59:28'),
(290, 158, '/submitaccident.php?qr=158', '2025-10-13 10:59:28'),
(291, 159, '/submitaccident.php?qr=159', '2025-10-13 10:59:28'),
(292, 160, '/submitaccident.php?qr=160', '2025-10-13 10:59:28'),
(293, 161, '/submitaccident.php?qr=161', '2025-10-13 10:59:28'),
(294, 162, '/submitaccident.php?qr=162', '2025-10-13 10:59:28'),
(295, 163, '/submitaccident.php?qr=163', '2025-10-13 10:59:28'),
(296, 164, '/submitaccident.php?qr=164', '2025-10-13 10:59:28'),
(297, 165, '/submitaccident.php?qr=165', '2025-10-13 10:59:28'),
(298, 166, '/submitaccident.php?qr=166', '2025-10-13 10:59:28'),
(299, 167, '/submitaccident.php?qr=167', '2025-10-13 10:59:28'),
(300, 168, '/submitaccident.php?qr=168', '2025-10-13 10:59:28'),
(301, 169, '/submitaccident.php?qr=169', '2025-10-13 10:59:28'),
(302, 170, '/submitaccident.php?qr=170', '2025-10-13 10:59:28'),
(303, 171, '/submitaccident.php?qr=171', '2025-10-13 10:59:28'),
(304, 172, '/submitaccident.php?qr=172', '2025-10-13 10:59:28'),
(305, 173, '/submitaccident.php?qr=173', '2025-10-13 10:59:28'),
(306, 174, '/submitaccident.php?qr=174', '2025-10-13 10:59:28'),
(307, 175, '/submitaccident.php?qr=175', '2025-10-13 10:59:28'),
(308, 176, '/submitaccident.php?qr=176', '2025-10-13 10:59:28'),
(309, 177, '/submitaccident.php?qr=177', '2025-10-13 10:59:28'),
(310, 178, '/submitaccident.php?qr=178', '2025-10-13 10:59:28'),
(311, 179, '/submitaccident.php?qr=179', '2025-10-13 10:59:28'),
(312, 180, '/submitaccident.php?qr=180', '2025-10-13 10:59:28'),
(313, 181, '/submitaccident.php?qr=181', '2025-10-13 10:59:28'),
(314, 182, '/submitaccident.php?qr=182', '2025-10-13 10:59:28'),
(315, 183, '/submitaccident.php?qr=183', '2025-10-13 10:59:28'),
(316, 184, '/submitaccident.php?qr=184', '2025-10-13 10:59:28'),
(317, 185, '/submitaccident.php?qr=185', '2025-10-13 10:59:28'),
(318, 186, '/submitaccident.php?qr=186', '2025-10-13 10:59:28'),
(319, 187, '/submitaccident.php?qr=187', '2025-10-13 10:59:28'),
(320, 188, '/submitaccident.php?qr=188', '2025-10-13 10:59:28'),
(321, 189, '/submitaccident.php?qr=189', '2025-10-13 10:59:28'),
(322, 190, '/submitaccident.php?qr=190', '2025-10-13 10:59:28'),
(323, 191, '/submitaccident.php?qr=191', '2025-10-13 10:59:28'),
(324, 192, '/submitaccident.php?qr=192', '2025-10-13 10:59:28'),
(325, 193, '/submitaccident.php?qr=193', '2025-10-13 10:59:28'),
(326, 194, '/submitaccident.php?qr=194', '2025-10-13 10:59:28'),
(327, 195, '/submitaccident.php?qr=195', '2025-10-13 10:59:28'),
(328, 196, '/submitaccident.php?qr=196', '2025-10-13 10:59:29'),
(329, 197, '/submitaccident.php?qr=197', '2025-10-13 10:59:29'),
(330, 198, '/submitaccident.php?qr=198', '2025-10-13 10:59:29'),
(331, 199, '/submitaccident.php?qr=199', '2025-10-13 10:59:29'),
(332, 200, '/submitaccident.php?qr=200', '2025-10-13 10:59:29'),
(333, 201, '/submitaccident.php?qr=201', '2025-10-13 10:59:29'),
(334, 202, '/submitaccident.php?qr=202', '2025-10-13 10:59:29'),
(335, 203, '/submitaccident.php?qr=203', '2025-10-13 10:59:29'),
(336, 204, '/submitaccident.php?qr=204', '2025-10-13 10:59:29'),
(337, 205, '/submitaccident.php?qr=205', '2025-10-13 10:59:29'),
(338, 206, '/submitaccident.php?qr=206', '2025-10-13 10:59:29'),
(339, 207, '/submitaccident.php?qr=207', '2025-10-13 10:59:29'),
(340, 208, '/submitaccident.php?qr=208', '2025-10-13 10:59:29'),
(341, 209, '/submitaccident.php?qr=209', '2025-10-13 10:59:29'),
(342, 210, '/submitaccident.php?qr=210', '2025-10-13 10:59:29'),
(343, 211, '/submitaccident.php?qr=211', '2025-10-13 10:59:29'),
(344, 212, '/submitaccident.php?qr=212', '2025-10-13 10:59:29'),
(345, 213, '/submitaccident.php?qr=213', '2025-10-13 10:59:29'),
(346, 214, '/submitaccident.php?qr=214', '2025-10-13 10:59:29'),
(347, 215, '/submitaccident.php?qr=215', '2025-10-13 10:59:29'),
(348, 216, '/submitaccident.php?qr=216', '2025-10-13 10:59:29'),
(349, 217, '/submitaccident.php?qr=217', '2025-10-13 10:59:29'),
(350, 218, '/submitaccident.php?qr=218', '2025-10-13 10:59:29'),
(351, 219, '/submitaccident.php?qr=219', '2025-10-13 10:59:29'),
(352, 220, '/submitaccident.php?qr=220', '2025-10-13 10:59:29'),
(353, 221, '/submitaccident.php?qr=221', '2025-10-13 10:59:29'),
(354, 222, '/submitaccident.php?qr=222', '2025-10-13 10:59:29'),
(355, 223, '/submitaccident.php?qr=223', '2025-10-13 10:59:29'),
(356, 224, '/submitaccident.php?qr=224', '2025-10-13 10:59:29'),
(357, 225, '/submitaccident.php?qr=225', '2025-10-13 10:59:29'),
(358, 226, '/submitaccident.php?qr=226', '2025-10-13 10:59:29'),
(359, 227, '/submitaccident.php?qr=227', '2025-10-13 10:59:29'),
(360, 228, '/submitaccident.php?qr=228', '2025-10-13 10:59:29'),
(361, 229, '/submitaccident.php?qr=229', '2025-10-13 10:59:29'),
(362, 230, '/submitaccident.php?qr=230', '2025-10-13 10:59:29'),
(363, 231, '/submitaccident.php?qr=231', '2025-10-13 10:59:29'),
(364, 232, '/submitaccident.php?qr=232', '2025-10-13 10:59:29'),
(365, 233, '/submitaccident.php?qr=233', '2025-10-13 10:59:29'),
(366, 234, '/submitaccident.php?qr=234', '2025-10-13 10:59:29'),
(367, 235, '/submitaccident.php?qr=235', '2025-10-13 10:59:29'),
(368, 236, '/submitaccident.php?qr=236', '2025-10-13 10:59:29'),
(369, 237, '/submitaccident.php?qr=237', '2025-10-13 10:59:29'),
(370, 238, '/submitaccident.php?qr=238', '2025-10-13 10:59:29'),
(371, 239, '/submitaccident.php?qr=239', '2025-10-13 10:59:29'),
(372, 240, '/submitaccident.php?qr=240', '2025-10-13 10:59:29'),
(373, 241, '/submitaccident.php?qr=241', '2025-10-13 10:59:29'),
(374, 242, '/submitaccident.php?qr=242', '2025-10-13 10:59:29'),
(375, 243, '/submitaccident.php?qr=243', '2025-10-13 10:59:29'),
(376, 244, '/submitaccident.php?qr=244', '2025-10-13 10:59:29'),
(377, 245, '/submitaccident.php?qr=245', '2025-10-13 10:59:29'),
(378, 246, '/submitaccident.php?qr=246', '2025-10-13 10:59:29'),
(379, 247, '/submitaccident.php?qr=247', '2025-10-13 10:59:29'),
(380, 248, '/submitaccident.php?qr=248', '2025-10-13 10:59:29'),
(381, 249, '/submitaccident.php?qr=249', '2025-10-13 10:59:29'),
(382, 250, '/submitaccident.php?qr=250', '2025-10-13 10:59:29'),
(383, 251, '/submitaccident.php?qr=251', '2025-10-13 10:59:29'),
(384, 252, '/submitaccident.php?qr=252', '2025-10-13 10:59:29'),
(385, 253, '/submitaccident.php?qr=253', '2025-10-13 10:59:29'),
(386, 254, '/submitaccident.php?qr=254', '2025-10-13 10:59:29'),
(387, 255, '/submitaccident.php?qr=255', '2025-10-13 10:59:29'),
(388, 256, '/submitaccident.php?qr=256', '2025-10-13 10:59:29'),
(389, 257, '/submitaccident.php?qr=257', '2025-10-13 10:59:29'),
(390, 258, '/submitaccident.php?qr=258', '2025-10-13 10:59:29'),
(391, 259, '/submitaccident.php?qr=259', '2025-10-13 10:59:29'),
(392, 260, '/submitaccident.php?qr=260', '2025-10-13 10:59:29'),
(393, 261, '/submitaccident.php?qr=261', '2025-10-13 10:59:29'),
(394, 262, '/submitaccident.php?qr=262', '2025-10-13 10:59:29'),
(395, 263, '/submitaccident.php?qr=263', '2025-10-13 10:59:29'),
(396, 264, '/submitaccident.php?qr=264', '2025-10-13 10:59:29'),
(397, 265, '/submitaccident.php?qr=265', '2025-10-13 10:59:29'),
(398, 266, '/submitaccident.php?qr=266', '2025-10-13 10:59:29'),
(399, 267, '/submitaccident.php?qr=267', '2025-10-13 10:59:29'),
(400, 268, '/submitaccident.php?qr=268', '2025-10-13 10:59:29'),
(401, 269, '/submitaccident.php?qr=269', '2025-10-13 10:59:29'),
(402, 270, '/submitaccident.php?qr=270', '2025-10-13 10:59:29'),
(403, 271, '/submitaccident.php?qr=271', '2025-10-13 10:59:29'),
(404, 272, '/submitaccident.php?qr=272', '2025-10-13 10:59:29'),
(405, 273, '/submitaccident.php?qr=273', '2025-10-13 10:59:29'),
(406, 274, '/submitaccident.php?qr=274', '2025-10-13 10:59:29'),
(407, 275, '/submitaccident.php?qr=275', '2025-10-13 10:59:29'),
(408, 276, '/submitaccident.php?qr=276', '2025-10-13 10:59:29'),
(409, 277, '/submitaccident.php?qr=277', '2025-10-13 10:59:29'),
(410, 278, '/submitaccident.php?qr=278', '2025-10-13 10:59:29'),
(411, 279, '/submitaccident.php?qr=279', '2025-10-13 10:59:29'),
(412, 280, '/submitaccident.php?qr=280', '2025-10-13 10:59:29'),
(413, 281, '/submitaccident.php?qr=281', '2025-10-13 10:59:29'),
(414, 282, '/submitaccident.php?qr=282', '2025-10-13 10:59:29'),
(415, 283, '/submitaccident.php?qr=283', '2025-10-13 10:59:29'),
(416, 284, '/submitaccident.php?qr=284', '2025-10-13 10:59:29'),
(417, 285, '/submitaccident.php?qr=285', '2025-10-13 10:59:29'),
(418, 286, '/submitaccident.php?qr=286', '2025-10-13 10:59:29'),
(419, 287, '/submitaccident.php?qr=287', '2025-10-13 10:59:29'),
(420, 288, '/submitaccident.php?qr=288', '2025-10-13 10:59:29'),
(421, 289, '/submitaccident.php?qr=289', '2025-10-13 10:59:29'),
(422, 290, '/submitaccident.php?qr=290', '2025-10-13 10:59:29'),
(423, 291, '/submitaccident.php?qr=291', '2025-10-13 10:59:29'),
(424, 292, '/submitaccident.php?qr=292', '2025-10-13 10:59:29'),
(425, 293, '/submitaccident.php?qr=293', '2025-10-13 10:59:29'),
(426, 294, '/submitaccident.php?qr=294', '2025-10-13 10:59:29'),
(427, 295, '/submitaccident.php?qr=295', '2025-10-13 10:59:29'),
(428, 296, '/submitaccident.php?qr=296', '2025-10-13 10:59:29'),
(429, 297, '/submitaccident.php?qr=297', '2025-10-13 10:59:29'),
(430, 298, '/submitaccident.php?qr=298', '2025-10-13 10:59:29'),
(431, 299, '/submitaccident.php?qr=299', '2025-10-13 10:59:29'),
(432, 300, '/submitaccident.php?qr=300', '2025-10-13 10:59:29'),
(433, 301, '/submitaccident.php?qr=301', '2025-10-13 10:59:29'),
(434, 302, '/submitaccident.php?qr=302', '2025-10-13 10:59:29'),
(435, 303, '/submitaccident.php?qr=303', '2025-10-13 10:59:29'),
(436, 304, '/submitaccident.php?qr=304', '2025-10-13 10:59:29'),
(437, 305, '/submitaccident.php?qr=305', '2025-10-13 10:59:29'),
(438, 306, '/submitaccident.php?qr=306', '2025-10-13 10:59:29'),
(439, 307, '/submitaccident.php?qr=307', '2025-10-13 10:59:29'),
(440, 308, '/submitaccident.php?qr=308', '2025-10-13 10:59:29'),
(441, 309, '/submitaccident.php?qr=309', '2025-10-13 10:59:29'),
(442, 310, '/submitaccident.php?qr=310', '2025-10-13 10:59:29'),
(443, 311, '/submitaccident.php?qr=311', '2025-10-13 10:59:29'),
(444, 312, '/submitaccident.php?qr=312', '2025-10-13 10:59:29'),
(445, 313, '/submitaccident.php?qr=313', '2025-10-13 10:59:29'),
(446, 314, '/submitaccident.php?qr=314', '2025-10-13 10:59:29'),
(447, 315, '/submitaccident.php?qr=315', '2025-10-13 10:59:29'),
(448, 316, '/submitaccident.php?qr=316', '2025-10-13 10:59:29'),
(449, 317, '/submitaccident.php?qr=317', '2025-10-13 10:59:29'),
(450, 318, '/submitaccident.php?qr=318', '2025-10-13 10:59:29'),
(451, 319, '/submitaccident.php?qr=319', '2025-10-13 10:59:29'),
(452, 320, '/submitaccident.php?qr=320', '2025-10-13 10:59:29'),
(453, 321, '/submitaccident.php?qr=321', '2025-10-13 10:59:29'),
(454, 322, '/submitaccident.php?qr=322', '2025-10-13 10:59:29'),
(455, 323, '/submitaccident.php?qr=323', '2025-10-13 10:59:29'),
(456, 324, '/submitaccident.php?qr=324', '2025-10-13 10:59:29'),
(457, 325, '/submitaccident.php?qr=325', '2025-10-13 10:59:29'),
(458, 326, '/submitaccident.php?qr=326', '2025-10-13 10:59:29'),
(459, 327, '/submitaccident.php?qr=327', '2025-10-13 10:59:29'),
(460, 328, '/submitaccident.php?qr=328', '2025-10-13 10:59:29'),
(461, 329, '/submitaccident.php?qr=329', '2025-10-13 10:59:29'),
(462, 330, '/submitaccident.php?qr=330', '2025-10-13 10:59:29'),
(463, 331, '/submitaccident.php?qr=331', '2025-10-13 10:59:29'),
(464, 332, '/submitaccident.php?qr=332', '2025-10-13 10:59:29'),
(465, 333, '/submitaccident.php?qr=333', '2025-10-13 10:59:29'),
(466, 334, '/submitaccident.php?qr=334', '2025-10-13 10:59:29'),
(467, 335, '/submitaccident.php?qr=335', '2025-10-13 10:59:29'),
(468, 336, '/submitaccident.php?qr=336', '2025-10-13 10:59:29'),
(469, 337, '/submitaccident.php?qr=337', '2025-10-13 10:59:29'),
(470, 338, '/submitaccident.php?qr=338', '2025-10-13 10:59:29'),
(471, 339, '/submitaccident.php?qr=339', '2025-10-13 10:59:29'),
(472, 340, '/submitaccident.php?qr=340', '2025-10-13 10:59:29'),
(473, 341, '/submitaccident.php?qr=341', '2025-10-13 10:59:29'),
(474, 342, '/submitaccident.php?qr=342', '2025-10-13 10:59:29'),
(475, 343, '/submitaccident.php?qr=343', '2025-10-13 10:59:29'),
(476, 344, '/submitaccident.php?qr=344', '2025-10-13 10:59:29'),
(477, 345, '/submitaccident.php?qr=345', '2025-10-13 10:59:29'),
(478, 346, '/submitaccident.php?qr=346', '2025-10-13 10:59:29'),
(479, 347, '/submitaccident.php?qr=347', '2025-10-13 10:59:29'),
(480, 348, '/submitaccident.php?qr=348', '2025-10-13 10:59:29'),
(481, 349, '/submitaccident.php?qr=349', '2025-10-13 10:59:29'),
(482, 350, '/submitaccident.php?qr=350', '2025-10-13 10:59:29'),
(483, 351, '/submitaccident.php?qr=351', '2025-10-13 10:59:29'),
(484, 352, '/submitaccident.php?qr=352', '2025-10-13 10:59:29'),
(485, 353, '/submitaccident.php?qr=353', '2025-10-13 10:59:29'),
(486, 354, '/submitaccident.php?qr=354', '2025-10-13 10:59:29'),
(487, 355, '/submitaccident.php?qr=355', '2025-10-13 10:59:29'),
(488, 356, '/submitaccident.php?qr=356', '2025-10-13 10:59:29'),
(489, 357, '/submitaccident.php?qr=357', '2025-10-13 10:59:29'),
(490, 358, '/submitaccident.php?qr=358', '2025-10-13 10:59:29'),
(491, 359, '/submitaccident.php?qr=359', '2025-10-13 10:59:29'),
(492, 360, '/submitaccident.php?qr=360', '2025-10-13 10:59:29'),
(493, 361, '/submitaccident.php?qr=361', '2025-10-13 10:59:29'),
(494, 362, '/submitaccident.php?qr=362', '2025-10-13 10:59:29'),
(495, 363, '/submitaccident.php?qr=363', '2025-10-13 10:59:29'),
(496, 364, '/submitaccident.php?qr=364', '2025-10-13 10:59:29'),
(497, 365, '/submitaccident.php?qr=365', '2025-10-13 10:59:29'),
(498, 366, '/submitaccident.php?qr=366', '2025-10-13 10:59:29'),
(499, 367, '/submitaccident.php?qr=367', '2025-10-13 10:59:29'),
(500, 368, '/submitaccident.php?qr=368', '2025-10-13 10:59:29'),
(501, 369, '/submitaccident.php?qr=369', '2025-10-13 10:59:29'),
(502, 370, '/submitaccident.php?qr=370', '2025-10-13 10:59:29'),
(503, 371, '/submitaccident.php?qr=371', '2025-10-13 10:59:29'),
(504, 372, '/submitaccident.php?qr=372', '2025-10-13 10:59:29'),
(505, 373, '/submitaccident.php?qr=373', '2025-10-13 10:59:29'),
(506, 374, '/submitaccident.php?qr=374', '2025-10-13 10:59:29'),
(507, 375, '/submitaccident.php?qr=375', '2025-10-13 10:59:29'),
(508, 376, '/submitaccident.php?qr=376', '2025-10-13 10:59:29'),
(509, 377, '/submitaccident.php?qr=377', '2025-10-13 10:59:29'),
(510, 378, '/submitaccident.php?qr=378', '2025-10-13 10:59:29'),
(511, 379, '/submitaccident.php?qr=379', '2025-10-13 10:59:29'),
(512, 380, '/submitaccident.php?qr=380', '2025-10-13 10:59:29'),
(513, 381, '/submitaccident.php?qr=381', '2025-10-13 10:59:29'),
(514, 382, '/submitaccident.php?qr=382', '2025-10-13 10:59:29'),
(515, 383, '/submitaccident.php?qr=383', '2025-10-13 10:59:29'),
(516, 384, '/submitaccident.php?qr=384', '2025-10-13 10:59:29'),
(517, 385, '/submitaccident.php?qr=385', '2025-10-13 10:59:29'),
(518, 386, '/submitaccident.php?qr=386', '2025-10-13 10:59:29'),
(519, 387, '/submitaccident.php?qr=387', '2025-10-13 10:59:29'),
(520, 388, '/submitaccident.php?qr=388', '2025-10-13 10:59:29'),
(521, 389, '/submitaccident.php?qr=389', '2025-10-13 10:59:29'),
(522, 390, '/submitaccident.php?qr=390', '2025-10-13 10:59:29'),
(523, 391, '/submitaccident.php?qr=391', '2025-10-13 10:59:29'),
(524, 392, '/submitaccident.php?qr=392', '2025-10-13 10:59:29'),
(525, 393, '/submitaccident.php?qr=393', '2025-10-13 10:59:29'),
(526, 394, '/submitaccident.php?qr=394', '2025-10-13 10:59:29'),
(527, 395, '/submitaccident.php?qr=395', '2025-10-13 10:59:29'),
(528, 396, '/submitaccident.php?qr=396', '2025-10-13 10:59:29'),
(529, 397, '/submitaccident.php?qr=397', '2025-10-13 10:59:29'),
(530, 398, '/submitaccident.php?qr=398', '2025-10-13 10:59:29'),
(531, 399, '/submitaccident.php?qr=399', '2025-10-13 10:59:29'),
(532, 400, '/submitaccident.php?qr=400', '2025-10-13 10:59:29'),
(533, 401, '/submitaccident.php?qr=401', '2025-10-13 10:59:29'),
(534, 402, '/submitaccident.php?qr=402', '2025-10-13 10:59:29'),
(535, 403, '/submitaccident.php?qr=403', '2025-10-13 10:59:29'),
(536, 404, '/submitaccident.php?qr=404', '2025-10-13 10:59:29'),
(537, 405, '/submitaccident.php?qr=405', '2025-10-13 10:59:29'),
(538, 406, '/submitaccident.php?qr=406', '2025-10-13 10:59:29'),
(539, 407, '/submitaccident.php?qr=407', '2025-10-13 10:59:29'),
(540, 408, '/submitaccident.php?qr=408', '2025-10-13 10:59:29'),
(541, 409, '/submitaccident.php?qr=409', '2025-10-13 10:59:29'),
(542, 410, '/submitaccident.php?qr=410', '2025-10-13 10:59:29'),
(543, 411, '/submitaccident.php?qr=411', '2025-10-13 10:59:29'),
(544, 412, '/submitaccident.php?qr=412', '2025-10-13 10:59:29'),
(545, 413, '/submitaccident.php?qr=413', '2025-10-13 10:59:29'),
(546, 414, '/submitaccident.php?qr=414', '2025-10-13 10:59:29'),
(547, 415, '/submitaccident.php?qr=415', '2025-10-13 10:59:29'),
(548, 416, '/submitaccident.php?qr=416', '2025-10-13 10:59:29'),
(549, 417, '/submitaccident.php?qr=417', '2025-10-13 10:59:29'),
(550, 418, '/submitaccident.php?qr=418', '2025-10-13 10:59:29'),
(551, 419, '/submitaccident.php?qr=419', '2025-10-13 10:59:29'),
(552, 420, '/submitaccident.php?qr=420', '2025-10-13 10:59:29'),
(553, 421, '/submitaccident.php?qr=421', '2025-10-13 10:59:29'),
(554, 422, '/submitaccident.php?qr=422', '2025-10-13 10:59:29'),
(555, 423, '/submitaccident.php?qr=423', '2025-10-13 10:59:29'),
(556, 424, '/submitaccident.php?qr=424', '2025-10-13 10:59:29'),
(557, 425, '/submitaccident.php?qr=425', '2025-10-13 10:59:29'),
(558, 426, '/submitaccident.php?qr=426', '2025-10-13 10:59:29'),
(559, 427, '/submitaccident.php?qr=427', '2025-10-13 10:59:29'),
(560, 428, '/submitaccident.php?qr=428', '2025-10-13 10:59:29'),
(561, 429, '/submitaccident.php?qr=429', '2025-10-13 10:59:29'),
(562, 430, '/submitaccident.php?qr=430', '2025-10-13 10:59:29'),
(563, 431, '/submitaccident.php?qr=431', '2025-10-13 10:59:29'),
(564, 432, '/submitaccident.php?qr=432', '2025-10-13 10:59:29'),
(565, 433, '/submitaccident.php?qr=433', '2025-10-13 10:59:29'),
(566, 434, '/submitaccident.php?qr=434', '2025-10-13 10:59:29'),
(567, 435, '/submitaccident.php?qr=435', '2025-10-13 10:59:29'),
(568, 436, '/submitaccident.php?qr=436', '2025-10-13 10:59:29'),
(569, 437, '/submitaccident.php?qr=437', '2025-10-13 10:59:29'),
(570, 438, '/submitaccident.php?qr=438', '2025-10-13 10:59:29'),
(571, 439, '/submitaccident.php?qr=439', '2025-10-13 10:59:29'),
(572, 440, '/submitaccident.php?qr=440', '2025-10-13 10:59:29'),
(573, 441, '/submitaccident.php?qr=441', '2025-10-13 10:59:29'),
(574, 442, '/submitaccident.php?qr=442', '2025-10-13 10:59:29'),
(575, 443, '/submitaccident.php?qr=443', '2025-10-13 10:59:29'),
(576, 444, '/submitaccident.php?qr=444', '2025-10-13 10:59:29'),
(577, 445, '/submitaccident.php?qr=445', '2025-10-13 10:59:29'),
(578, 446, '/submitaccident.php?qr=446', '2025-10-13 10:59:29'),
(579, 447, '/submitaccident.php?qr=447', '2025-10-13 10:59:29'),
(580, 448, '/submitaccident.php?qr=448', '2025-10-13 10:59:29'),
(581, 449, '/submitaccident.php?qr=449', '2025-10-13 10:59:29'),
(582, 450, '/submitaccident.php?qr=450', '2025-10-13 10:59:29'),
(583, 451, '/submitaccident.php?qr=451', '2025-10-13 10:59:29'),
(584, 452, '/submitaccident.php?qr=452', '2025-10-13 10:59:29'),
(585, 453, '/submitaccident.php?qr=453', '2025-10-13 10:59:29'),
(586, 454, '/submitaccident.php?qr=454', '2025-10-13 10:59:29'),
(587, 455, '/submitaccident.php?qr=455', '2025-10-13 10:59:29'),
(588, 456, '/submitaccident.php?qr=456', '2025-10-13 10:59:29'),
(589, 457, '/submitaccident.php?qr=457', '2025-10-13 10:59:29'),
(590, 458, '/submitaccident.php?qr=458', '2025-10-13 10:59:29'),
(591, 459, '/submitaccident.php?qr=459', '2025-10-13 10:59:29'),
(592, 460, '/submitaccident.php?qr=460', '2025-10-13 10:59:29'),
(593, 461, '/submitaccident.php?qr=461', '2025-10-13 10:59:29'),
(594, 462, '/submitaccident.php?qr=462', '2025-10-13 10:59:29'),
(595, 463, '/submitaccident.php?qr=463', '2025-10-13 10:59:29'),
(596, 464, '/submitaccident.php?qr=464', '2025-10-13 10:59:29'),
(597, 465, '/submitaccident.php?qr=465', '2025-10-13 10:59:29'),
(598, 466, '/submitaccident.php?qr=466', '2025-10-13 10:59:29'),
(599, 467, '/submitaccident.php?qr=467', '2025-10-13 10:59:29'),
(600, 468, '/submitaccident.php?qr=468', '2025-10-13 10:59:29'),
(601, 469, '/submitaccident.php?qr=469', '2025-10-13 10:59:29'),
(602, 470, '/submitaccident.php?qr=470', '2025-10-13 10:59:29'),
(603, 471, '/submitaccident.php?qr=471', '2025-10-13 10:59:29'),
(604, 472, '/submitaccident.php?qr=472', '2025-10-13 10:59:29'),
(605, 473, '/submitaccident.php?qr=473', '2025-10-13 10:59:29'),
(606, 474, '/submitaccident.php?qr=474', '2025-10-13 10:59:29'),
(607, 475, '/submitaccident.php?qr=475', '2025-10-13 10:59:29'),
(608, 476, '/submitaccident.php?qr=476', '2025-10-13 10:59:29'),
(609, 477, '/submitaccident.php?qr=477', '2025-10-13 10:59:29'),
(610, 478, '/submitaccident.php?qr=478', '2025-10-13 10:59:29'),
(611, 479, '/submitaccident.php?qr=479', '2025-10-13 10:59:29'),
(612, 480, '/submitaccident.php?qr=480', '2025-10-13 10:59:29'),
(613, 481, '/submitaccident.php?qr=481', '2025-10-13 10:59:29'),
(614, 482, '/submitaccident.php?qr=482', '2025-10-13 10:59:29'),
(615, 483, '/submitaccident.php?qr=483', '2025-10-13 10:59:29'),
(616, 484, '/submitaccident.php?qr=484', '2025-10-13 10:59:29'),
(617, 485, '/submitaccident.php?qr=485', '2025-10-13 10:59:29'),
(618, 486, '/submitaccident.php?qr=486', '2025-10-13 10:59:29'),
(619, 487, '/submitaccident.php?qr=487', '2025-10-13 10:59:29'),
(620, 488, '/submitaccident.php?qr=488', '2025-10-13 10:59:29'),
(621, 489, '/submitaccident.php?qr=489', '2025-10-13 10:59:29'),
(622, 490, '/submitaccident.php?qr=490', '2025-10-13 10:59:29'),
(623, 491, '/submitaccident.php?qr=491', '2025-10-13 10:59:29'),
(624, 492, '/submitaccident.php?qr=492', '2025-10-13 10:59:29'),
(625, 493, '/submitaccident.php?qr=493', '2025-10-13 10:59:29'),
(626, 494, '/submitaccident.php?qr=494', '2025-10-13 10:59:29'),
(627, 495, '/submitaccident.php?qr=495', '2025-10-13 10:59:29'),
(628, 496, '/submitaccident.php?qr=496', '2025-10-13 10:59:29'),
(629, 497, '/submitaccident.php?qr=497', '2025-10-13 10:59:29'),
(630, 498, '/submitaccident.php?qr=498', '2025-10-13 10:59:29'),
(631, 499, '/submitaccident.php?qr=499', '2025-10-13 10:59:29'),
(632, 500, '/submitaccident.php?qr=500', '2025-10-13 10:59:29'),
(633, 501, '/submitaccident.php?qr=501', '2025-10-13 10:59:29'),
(634, 502, '/submitaccident.php?qr=502', '2025-10-13 10:59:29'),
(635, 503, '/submitaccident.php?qr=503', '2025-10-13 10:59:29'),
(636, 504, '/submitaccident.php?qr=504', '2025-10-13 10:59:29'),
(637, 505, '/submitaccident.php?qr=505', '2025-10-13 10:59:29'),
(638, 506, '/submitaccident.php?qr=506', '2025-10-13 10:59:29'),
(639, 507, '/submitaccident.php?qr=507', '2025-10-13 10:59:29'),
(640, 508, '/submitaccident.php?qr=508', '2025-10-13 10:59:29'),
(641, 509, '/submitaccident.php?qr=509', '2025-10-13 10:59:29'),
(642, 510, '/submitaccident.php?qr=510', '2025-10-13 10:59:29'),
(643, 511, '/submitaccident.php?qr=511', '2025-10-13 10:59:29'),
(644, 512, '/submitaccident.php?qr=512', '2025-10-13 10:59:29'),
(645, 513, '/submitaccident.php?qr=513', '2025-10-13 10:59:29'),
(646, 514, '/submitaccident.php?qr=514', '2025-10-13 10:59:29'),
(647, 515, '/submitaccident.php?qr=515', '2025-10-13 10:59:29'),
(648, 516, '/submitaccident.php?qr=516', '2025-10-13 10:59:29'),
(649, 517, '/submitaccident.php?qr=517', '2025-10-13 10:59:29'),
(650, 518, '/submitaccident.php?qr=518', '2025-10-13 10:59:29'),
(651, 519, '/submitaccident.php?qr=519', '2025-10-13 10:59:29'),
(652, 520, '/submitaccident.php?qr=520', '2025-10-13 10:59:29'),
(653, 521, '/submitaccident.php?qr=521', '2025-10-13 10:59:58'),
(654, 522, '/submitaccident.php?qr=522', '2025-10-13 10:59:58'),
(655, 523, '/submitaccident.php?qr=523', '2025-10-13 10:59:58'),
(656, 524, '/submitaccident.php?qr=524', '2025-10-13 10:59:58'),
(657, 525, '/submitaccident.php?qr=525', '2025-10-13 10:59:58'),
(658, 526, '/submitaccident.php?qr=526', '2025-10-13 10:59:58'),
(659, 527, '/submitaccident.php?qr=527', '2025-10-13 10:59:58'),
(660, 528, '/submitaccident.php?qr=528', '2025-10-13 10:59:58'),
(661, 529, '/submitaccident.php?qr=529', '2025-10-13 10:59:58'),
(662, 530, '/submitaccident.php?qr=530', '2025-10-13 10:59:58'),
(663, 531, '/submitaccident.php?qr=531', '2025-10-13 10:59:58'),
(664, 532, '/submitaccident.php?qr=532', '2025-10-13 10:59:58'),
(665, 533, '/submitaccident.php?qr=533', '2025-10-13 10:59:58'),
(666, 534, '/submitaccident.php?qr=534', '2025-10-13 10:59:58'),
(667, 535, '/submitaccident.php?qr=535', '2025-10-13 10:59:58'),
(668, 536, '/submitaccident.php?qr=536', '2025-10-13 10:59:58'),
(669, 537, '/submitaccident.php?qr=537', '2025-10-13 10:59:58'),
(670, 538, '/submitaccident.php?qr=538', '2025-10-13 10:59:58'),
(671, 539, '/submitaccident.php?qr=539', '2025-10-13 10:59:58'),
(672, 540, '/submitaccident.php?qr=540', '2025-10-13 10:59:58'),
(673, 541, '/submitaccident.php?qr=541', '2025-10-13 10:59:58'),
(674, 542, '/submitaccident.php?qr=542', '2025-10-13 10:59:58'),
(675, 543, '/submitaccident.php?qr=543', '2025-10-13 10:59:58'),
(676, 544, '/submitaccident.php?qr=544', '2025-10-13 10:59:58'),
(677, 545, '/submitaccident.php?qr=545', '2025-10-13 10:59:58'),
(678, 546, '/submitaccident.php?qr=546', '2025-10-13 10:59:58'),
(679, 547, '/submitaccident.php?qr=547', '2025-10-13 10:59:58'),
(680, 548, '/submitaccident.php?qr=548', '2025-10-13 10:59:58'),
(681, 549, '/submitaccident.php?qr=549', '2025-10-13 10:59:58'),
(682, 550, '/submitaccident.php?qr=550', '2025-10-13 10:59:58'),
(683, 551, '/submitaccident.php?qr=551', '2025-10-13 10:59:58'),
(684, 552, '/submitaccident.php?qr=552', '2025-10-13 10:59:58'),
(685, 553, '/submitaccident.php?qr=553', '2025-10-13 10:59:58'),
(686, 554, '/submitaccident.php?qr=554', '2025-10-13 10:59:58'),
(687, 555, '/submitaccident.php?qr=555', '2025-10-13 10:59:58'),
(688, 556, '/submitaccident.php?qr=556', '2025-10-13 10:59:58'),
(689, 557, '/submitaccident.php?qr=557', '2025-10-13 10:59:58'),
(690, 558, '/submitaccident.php?qr=558', '2025-10-13 10:59:58'),
(691, 559, '/submitaccident.php?qr=559', '2025-10-13 10:59:58'),
(692, 560, '/submitaccident.php?qr=560', '2025-10-13 10:59:58'),
(693, 561, '/submitaccident.php?qr=561', '2025-10-13 10:59:58'),
(694, 562, '/submitaccident.php?qr=562', '2025-10-13 10:59:58'),
(695, 563, '/submitaccident.php?qr=563', '2025-10-13 10:59:58'),
(696, 564, '/submitaccident.php?qr=564', '2025-10-13 10:59:58'),
(697, 565, '/submitaccident.php?qr=565', '2025-10-13 10:59:58'),
(698, 566, '/submitaccident.php?qr=566', '2025-10-13 10:59:58'),
(699, 567, '/submitaccident.php?qr=567', '2025-10-13 10:59:58'),
(700, 568, '/submitaccident.php?qr=568', '2025-10-13 10:59:58'),
(701, 569, '/submitaccident.php?qr=569', '2025-10-13 10:59:58'),
(702, 570, '/submitaccident.php?qr=570', '2025-10-13 10:59:58'),
(703, 571, '/submitaccident.php?qr=571', '2025-10-13 10:59:58'),
(704, 572, '/submitaccident.php?qr=572', '2025-10-13 10:59:58'),
(705, 573, '/submitaccident.php?qr=573', '2025-10-13 10:59:58'),
(706, 574, '/submitaccident.php?qr=574', '2025-10-13 10:59:58'),
(707, 575, '/submitaccident.php?qr=575', '2025-10-13 10:59:58'),
(708, 576, '/submitaccident.php?qr=576', '2025-10-13 10:59:58'),
(709, 577, '/submitaccident.php?qr=577', '2025-10-13 10:59:58'),
(710, 578, '/submitaccident.php?qr=578', '2025-10-13 10:59:58'),
(711, 579, '/submitaccident.php?qr=579', '2025-10-13 10:59:58'),
(712, 580, '/submitaccident.php?qr=580', '2025-10-13 10:59:58'),
(713, 581, '/submitaccident.php?qr=581', '2025-10-13 10:59:58'),
(714, 582, '/submitaccident.php?qr=582', '2025-10-13 10:59:58'),
(715, 583, '/submitaccident.php?qr=583', '2025-10-13 10:59:58'),
(716, 584, '/submitaccident.php?qr=584', '2025-10-13 10:59:58'),
(717, 585, '/submitaccident.php?qr=585', '2025-10-13 10:59:58'),
(718, 586, '/submitaccident.php?qr=586', '2025-10-13 10:59:58'),
(719, 587, '/submitaccident.php?qr=587', '2025-10-13 10:59:58'),
(720, 588, '/submitaccident.php?qr=588', '2025-10-13 10:59:58'),
(721, 589, '/submitaccident.php?qr=589', '2025-10-13 10:59:58'),
(722, 590, '/submitaccident.php?qr=590', '2025-10-13 10:59:58'),
(723, 591, '/submitaccident.php?qr=591', '2025-10-13 10:59:58'),
(724, 592, '/submitaccident.php?qr=592', '2025-10-13 10:59:58'),
(725, 593, '/submitaccident.php?qr=593', '2025-10-13 10:59:58'),
(726, 594, '/submitaccident.php?qr=594', '2025-10-13 10:59:58'),
(727, 595, '/submitaccident.php?qr=595', '2025-10-13 10:59:58'),
(728, 596, '/submitaccident.php?qr=596', '2025-10-13 10:59:58'),
(729, 597, '/submitaccident.php?qr=597', '2025-10-13 10:59:58'),
(730, 598, '/submitaccident.php?qr=598', '2025-10-13 10:59:58'),
(731, 599, '/submitaccident.php?qr=599', '2025-10-13 10:59:58'),
(732, 600, '/submitaccident.php?qr=600', '2025-10-13 10:59:58'),
(733, 601, '/submitaccident.php?qr=601', '2025-10-13 10:59:58'),
(734, 602, '/submitaccident.php?qr=602', '2025-10-13 10:59:58'),
(735, 603, '/submitaccident.php?qr=603', '2025-10-13 10:59:58'),
(736, 604, '/submitaccident.php?qr=604', '2025-10-13 10:59:58'),
(737, 605, '/submitaccident.php?qr=605', '2025-10-13 10:59:58'),
(738, 606, '/submitaccident.php?qr=606', '2025-10-13 10:59:58'),
(739, 607, '/submitaccident.php?qr=607', '2025-10-13 10:59:58'),
(740, 608, '/submitaccident.php?qr=608', '2025-10-13 10:59:58'),
(741, 609, '/submitaccident.php?qr=609', '2025-10-13 10:59:58'),
(742, 610, '/submitaccident.php?qr=610', '2025-10-13 10:59:58'),
(743, 611, '/submitaccident.php?qr=611', '2025-10-13 10:59:58'),
(744, 612, '/submitaccident.php?qr=612', '2025-10-13 10:59:58'),
(745, 613, '/submitaccident.php?qr=613', '2025-10-13 10:59:58'),
(746, 614, '/submitaccident.php?qr=614', '2025-10-13 10:59:58'),
(747, 615, '/submitaccident.php?qr=615', '2025-10-13 10:59:58'),
(748, 616, '/submitaccident.php?qr=616', '2025-10-13 10:59:58'),
(749, 617, '/submitaccident.php?qr=617', '2025-10-13 10:59:58'),
(750, 618, '/submitaccident.php?qr=618', '2025-10-13 10:59:58'),
(751, 619, '/submitaccident.php?qr=619', '2025-10-13 10:59:58'),
(752, 620, '/submitaccident.php?qr=620', '2025-10-13 10:59:58'),
(753, 621, '/submitaccident.php?qr=621', '2025-10-13 10:59:58'),
(754, 622, '/submitaccident.php?qr=622', '2025-10-13 10:59:58'),
(755, 623, '/submitaccident.php?qr=623', '2025-10-13 10:59:58'),
(756, 624, '/submitaccident.php?qr=624', '2025-10-13 10:59:58'),
(757, 625, '/submitaccident.php?qr=625', '2025-10-13 10:59:58'),
(758, 626, '/submitaccident.php?qr=626', '2025-10-13 10:59:58'),
(759, 627, '/submitaccident.php?qr=627', '2025-10-13 10:59:58'),
(760, 628, '/submitaccident.php?qr=628', '2025-10-13 10:59:58'),
(761, 629, '/submitaccident.php?qr=629', '2025-10-13 10:59:58'),
(762, 630, '/submitaccident.php?qr=630', '2025-10-13 10:59:58'),
(763, 631, '/submitaccident.php?qr=631', '2025-10-13 10:59:58'),
(764, 632, '/submitaccident.php?qr=632', '2025-10-13 10:59:58'),
(765, 633, '/submitaccident.php?qr=633', '2025-10-13 10:59:58'),
(766, 634, '/submitaccident.php?qr=634', '2025-10-13 10:59:58'),
(767, 635, '/submitaccident.php?qr=635', '2025-10-13 10:59:58'),
(768, 636, '/submitaccident.php?qr=636', '2025-10-13 10:59:58'),
(769, 637, '/submitaccident.php?qr=637', '2025-10-13 10:59:58'),
(770, 638, '/submitaccident.php?qr=638', '2025-10-13 10:59:58'),
(771, 639, '/submitaccident.php?qr=639', '2025-10-13 10:59:58'),
(772, 640, '/submitaccident.php?qr=640', '2025-10-13 10:59:58'),
(773, 641, '/submitaccident.php?qr=641', '2025-10-13 10:59:58'),
(774, 642, '/submitaccident.php?qr=642', '2025-10-13 10:59:58'),
(775, 643, '/submitaccident.php?qr=643', '2025-10-13 10:59:58'),
(776, 644, '/submitaccident.php?qr=644', '2025-10-13 10:59:58'),
(777, 645, '/submitaccident.php?qr=645', '2025-10-13 10:59:58'),
(778, 646, '/submitaccident.php?qr=646', '2025-10-13 10:59:58'),
(779, 647, '/submitaccident.php?qr=647', '2025-10-13 10:59:58'),
(780, 648, '/submitaccident.php?qr=648', '2025-10-13 10:59:58'),
(781, 649, '/submitaccident.php?qr=649', '2025-10-13 10:59:58'),
(782, 650, '/submitaccident.php?qr=650', '2025-10-13 10:59:58'),
(783, 651, '/submitaccident.php?qr=651', '2025-10-13 10:59:58'),
(784, 652, '/submitaccident.php?qr=652', '2025-10-13 10:59:58'),
(785, 653, '/submitaccident.php?qr=653', '2025-10-13 10:59:58'),
(786, 654, '/submitaccident.php?qr=654', '2025-10-13 10:59:58'),
(787, 655, '/submitaccident.php?qr=655', '2025-10-13 10:59:58'),
(788, 656, '/submitaccident.php?qr=656', '2025-10-13 10:59:58'),
(789, 657, '/submitaccident.php?qr=657', '2025-10-13 10:59:58'),
(790, 658, '/submitaccident.php?qr=658', '2025-10-13 10:59:58'),
(791, 659, '/submitaccident.php?qr=659', '2025-10-13 10:59:58'),
(792, 660, '/submitaccident.php?qr=660', '2025-10-13 10:59:58'),
(793, 661, '/submitaccident.php?qr=661', '2025-10-13 10:59:58'),
(794, 662, '/submitaccident.php?qr=662', '2025-10-13 10:59:58'),
(795, 663, '/submitaccident.php?qr=663', '2025-10-13 10:59:58'),
(796, 664, '/submitaccident.php?qr=664', '2025-10-13 10:59:58'),
(797, 665, '/submitaccident.php?qr=665', '2025-10-13 10:59:58'),
(798, 666, '/submitaccident.php?qr=666', '2025-10-13 10:59:58'),
(799, 667, '/submitaccident.php?qr=667', '2025-10-13 10:59:58'),
(800, 668, '/submitaccident.php?qr=668', '2025-10-13 10:59:58'),
(801, 669, '/submitaccident.php?qr=669', '2025-10-13 10:59:58'),
(802, 670, '/submitaccident.php?qr=670', '2025-10-13 10:59:58'),
(803, 671, '/submitaccident.php?qr=671', '2025-10-13 10:59:58'),
(804, 672, '/submitaccident.php?qr=672', '2025-10-13 10:59:58'),
(805, 673, '/submitaccident.php?qr=673', '2025-10-13 10:59:58'),
(806, 674, '/submitaccident.php?qr=674', '2025-10-13 10:59:58'),
(807, 675, '/submitaccident.php?qr=675', '2025-10-13 10:59:58'),
(808, 676, '/submitaccident.php?qr=676', '2025-10-13 10:59:58'),
(809, 677, '/submitaccident.php?qr=677', '2025-10-13 10:59:58'),
(810, 678, '/submitaccident.php?qr=678', '2025-10-13 10:59:58'),
(811, 679, '/submitaccident.php?qr=679', '2025-10-13 10:59:58'),
(812, 680, '/submitaccident.php?qr=680', '2025-10-13 10:59:58'),
(813, 681, '/submitaccident.php?qr=681', '2025-10-13 10:59:58'),
(814, 682, '/submitaccident.php?qr=682', '2025-10-13 10:59:58'),
(815, 683, '/submitaccident.php?qr=683', '2025-10-13 10:59:58'),
(816, 684, '/submitaccident.php?qr=684', '2025-10-13 10:59:58'),
(817, 685, '/submitaccident.php?qr=685', '2025-10-13 10:59:58'),
(818, 686, '/submitaccident.php?qr=686', '2025-10-13 10:59:58'),
(819, 687, '/submitaccident.php?qr=687', '2025-10-13 10:59:58'),
(820, 688, '/submitaccident.php?qr=688', '2025-10-13 10:59:58'),
(821, 689, '/submitaccident.php?qr=689', '2025-10-13 10:59:58'),
(822, 690, '/submitaccident.php?qr=690', '2025-10-13 10:59:58'),
(823, 691, '/submitaccident.php?qr=691', '2025-10-13 10:59:58'),
(824, 692, '/submitaccident.php?qr=692', '2025-10-13 10:59:58'),
(825, 693, '/submitaccident.php?qr=693', '2025-10-13 10:59:58'),
(826, 694, '/submitaccident.php?qr=694', '2025-10-13 10:59:58'),
(827, 695, '/submitaccident.php?qr=695', '2025-10-13 10:59:58'),
(828, 696, '/submitaccident.php?qr=696', '2025-10-13 10:59:58'),
(829, 697, '/submitaccident.php?qr=697', '2025-10-13 10:59:58'),
(830, 698, '/submitaccident.php?qr=698', '2025-10-13 10:59:58'),
(831, 699, '/submitaccident.php?qr=699', '2025-10-13 10:59:58'),
(832, 700, '/submitaccident.php?qr=700', '2025-10-13 10:59:58'),
(833, 701, '/submitaccident.php?qr=701', '2025-10-13 10:59:58'),
(834, 702, '/submitaccident.php?qr=702', '2025-10-13 10:59:58'),
(835, 703, '/submitaccident.php?qr=703', '2025-10-13 10:59:58'),
(836, 704, '/submitaccident.php?qr=704', '2025-10-13 10:59:58'),
(837, 705, '/submitaccident.php?qr=705', '2025-10-13 10:59:58'),
(838, 706, '/submitaccident.php?qr=706', '2025-10-13 10:59:58'),
(839, 707, '/submitaccident.php?qr=707', '2025-10-13 10:59:58'),
(840, 708, '/submitaccident.php?qr=708', '2025-10-13 10:59:58'),
(841, 709, '/submitaccident.php?qr=709', '2025-10-13 10:59:58'),
(842, 710, '/submitaccident.php?qr=710', '2025-10-13 10:59:58'),
(843, 711, '/submitaccident.php?qr=711', '2025-10-13 10:59:58'),
(844, 712, '/submitaccident.php?qr=712', '2025-10-13 10:59:58'),
(845, 713, '/submitaccident.php?qr=713', '2025-10-13 10:59:58'),
(846, 714, '/submitaccident.php?qr=714', '2025-10-13 10:59:58'),
(847, 715, '/submitaccident.php?qr=715', '2025-10-13 10:59:58'),
(848, 716, '/submitaccident.php?qr=716', '2025-10-13 10:59:58'),
(849, 717, '/submitaccident.php?qr=717', '2025-10-13 10:59:58'),
(850, 718, '/submitaccident.php?qr=718', '2025-10-13 10:59:58'),
(851, 719, '/submitaccident.php?qr=719', '2025-10-13 10:59:58'),
(852, 720, '/submitaccident.php?qr=720', '2025-10-13 10:59:58'),
(853, 721, '/submitaccident.php?qr=721', '2025-10-13 10:59:58'),
(854, 722, '/submitaccident.php?qr=722', '2025-10-13 10:59:58'),
(855, 723, '/submitaccident.php?qr=723', '2025-10-13 10:59:58'),
(856, 724, '/submitaccident.php?qr=724', '2025-10-13 10:59:58'),
(857, 725, '/submitaccident.php?qr=725', '2025-10-13 10:59:58'),
(858, 726, '/submitaccident.php?qr=726', '2025-10-13 10:59:58'),
(859, 727, '/submitaccident.php?qr=727', '2025-10-13 10:59:58'),
(860, 728, '/submitaccident.php?qr=728', '2025-10-13 10:59:58'),
(861, 729, '/submitaccident.php?qr=729', '2025-10-13 10:59:58'),
(862, 730, '/submitaccident.php?qr=730', '2025-10-13 10:59:58'),
(863, 731, '/submitaccident.php?qr=731', '2025-10-13 10:59:58'),
(864, 732, '/submitaccident.php?qr=732', '2025-10-13 10:59:58'),
(865, 733, '/submitaccident.php?qr=733', '2025-10-13 10:59:58'),
(866, 734, '/submitaccident.php?qr=734', '2025-10-13 10:59:58'),
(867, 735, '/submitaccident.php?qr=735', '2025-10-13 10:59:58'),
(868, 736, '/submitaccident.php?qr=736', '2025-10-13 10:59:58'),
(869, 737, '/submitaccident.php?qr=737', '2025-10-13 10:59:58'),
(870, 738, '/submitaccident.php?qr=738', '2025-10-13 10:59:58'),
(871, 739, '/submitaccident.php?qr=739', '2025-10-13 10:59:58'),
(872, 740, '/submitaccident.php?qr=740', '2025-10-13 10:59:58'),
(873, 741, '/submitaccident.php?qr=741', '2025-10-13 10:59:58'),
(874, 742, '/submitaccident.php?qr=742', '2025-10-13 10:59:58'),
(875, 743, '/submitaccident.php?qr=743', '2025-10-13 10:59:58'),
(876, 744, '/submitaccident.php?qr=744', '2025-10-13 10:59:58'),
(877, 745, '/submitaccident.php?qr=745', '2025-10-13 10:59:58'),
(878, 746, '/submitaccident.php?qr=746', '2025-10-13 10:59:58'),
(879, 747, '/submitaccident.php?qr=747', '2025-10-13 10:59:58'),
(880, 748, '/submitaccident.php?qr=748', '2025-10-13 10:59:58'),
(881, 749, '/submitaccident.php?qr=749', '2025-10-13 10:59:58'),
(882, 750, '/submitaccident.php?qr=750', '2025-10-13 10:59:58'),
(883, 751, '/submitaccident.php?qr=751', '2025-10-13 10:59:58'),
(884, 752, '/submitaccident.php?qr=752', '2025-10-13 10:59:58'),
(885, 753, '/submitaccident.php?qr=753', '2025-10-13 10:59:58'),
(886, 754, '/submitaccident.php?qr=754', '2025-10-13 10:59:58'),
(887, 755, '/submitaccident.php?qr=755', '2025-10-13 10:59:58'),
(888, 756, '/submitaccident.php?qr=756', '2025-10-13 10:59:58'),
(889, 757, '/submitaccident.php?qr=757', '2025-10-13 10:59:58'),
(890, 758, '/submitaccident.php?qr=758', '2025-10-13 10:59:58'),
(891, 759, '/submitaccident.php?qr=759', '2025-10-13 10:59:58'),
(892, 760, '/submitaccident.php?qr=760', '2025-10-13 10:59:58'),
(893, 761, '/submitaccident.php?qr=761', '2025-10-13 10:59:58'),
(894, 762, '/submitaccident.php?qr=762', '2025-10-13 10:59:58'),
(895, 763, '/submitaccident.php?qr=763', '2025-10-13 10:59:58'),
(896, 764, '/submitaccident.php?qr=764', '2025-10-13 10:59:58'),
(897, 765, '/submitaccident.php?qr=765', '2025-10-13 10:59:58'),
(898, 766, '/submitaccident.php?qr=766', '2025-10-13 10:59:58'),
(899, 767, '/submitaccident.php?qr=767', '2025-10-13 10:59:58'),
(900, 768, '/submitaccident.php?qr=768', '2025-10-13 10:59:58'),
(901, 769, '/submitaccident.php?qr=769', '2025-10-13 10:59:58'),
(902, 770, '/submitaccident.php?qr=770', '2025-10-13 10:59:58'),
(903, 771, '/submitaccident.php?qr=771', '2025-10-13 10:59:58'),
(904, 772, '/submitaccident.php?qr=772', '2025-10-13 10:59:58'),
(905, 773, '/submitaccident.php?qr=773', '2025-10-13 10:59:58'),
(906, 774, '/submitaccident.php?qr=774', '2025-10-13 10:59:58'),
(907, 775, '/submitaccident.php?qr=775', '2025-10-13 10:59:58'),
(908, 776, '/submitaccident.php?qr=776', '2025-10-13 10:59:58'),
(909, 777, '/submitaccident.php?qr=777', '2025-10-13 10:59:58'),
(910, 778, '/submitaccident.php?qr=778', '2025-10-13 10:59:58'),
(911, 779, '/submitaccident.php?qr=779', '2025-10-13 10:59:58'),
(912, 780, '/submitaccident.php?qr=780', '2025-10-13 10:59:58'),
(913, 781, '/submitaccident.php?qr=781', '2025-10-13 10:59:58'),
(914, 782, '/submitaccident.php?qr=782', '2025-10-13 10:59:58'),
(915, 783, '/submitaccident.php?qr=783', '2025-10-13 10:59:58'),
(916, 784, '/submitaccident.php?qr=784', '2025-10-13 10:59:58'),
(917, 785, '/submitaccident.php?qr=785', '2025-10-13 10:59:58'),
(918, 786, '/submitaccident.php?qr=786', '2025-10-13 10:59:58'),
(919, 787, '/submitaccident.php?qr=787', '2025-10-13 10:59:58'),
(920, 788, '/submitaccident.php?qr=788', '2025-10-13 10:59:58'),
(921, 789, '/submitaccident.php?qr=789', '2025-10-13 10:59:58'),
(922, 790, '/submitaccident.php?qr=790', '2025-10-13 10:59:58'),
(923, 791, '/submitaccident.php?qr=791', '2025-10-13 10:59:58'),
(924, 792, '/submitaccident.php?qr=792', '2025-10-13 10:59:58'),
(925, 793, '/submitaccident.php?qr=793', '2025-10-13 10:59:58'),
(926, 794, '/submitaccident.php?qr=794', '2025-10-13 10:59:58'),
(927, 795, '/submitaccident.php?qr=795', '2025-10-13 10:59:58');
INSERT INTO `qr_codes` (`id`, `qr_number`, `qr_url`, `created_at`) VALUES
(928, 796, '/submitaccident.php?qr=796', '2025-10-13 10:59:58'),
(929, 797, '/submitaccident.php?qr=797', '2025-10-13 10:59:58'),
(930, 798, '/submitaccident.php?qr=798', '2025-10-13 10:59:58'),
(931, 799, '/submitaccident.php?qr=799', '2025-10-13 10:59:58'),
(932, 800, '/submitaccident.php?qr=800', '2025-10-13 10:59:58'),
(933, 801, '/submitaccident.php?qr=801', '2025-10-13 10:59:58'),
(934, 802, '/submitaccident.php?qr=802', '2025-10-13 10:59:58'),
(935, 803, '/submitaccident.php?qr=803', '2025-10-13 10:59:58'),
(936, 804, '/submitaccident.php?qr=804', '2025-10-13 10:59:58'),
(937, 805, '/submitaccident.php?qr=805', '2025-10-13 10:59:58'),
(938, 806, '/submitaccident.php?qr=806', '2025-10-13 10:59:58'),
(939, 807, '/submitaccident.php?qr=807', '2025-10-13 10:59:58'),
(940, 808, '/submitaccident.php?qr=808', '2025-10-13 10:59:58'),
(941, 809, '/submitaccident.php?qr=809', '2025-10-13 10:59:58'),
(942, 810, '/submitaccident.php?qr=810', '2025-10-13 10:59:58'),
(943, 811, '/submitaccident.php?qr=811', '2025-10-13 10:59:58'),
(944, 812, '/submitaccident.php?qr=812', '2025-10-13 10:59:58'),
(945, 813, '/submitaccident.php?qr=813', '2025-10-13 10:59:58'),
(946, 814, '/submitaccident.php?qr=814', '2025-10-13 10:59:58'),
(947, 815, '/submitaccident.php?qr=815', '2025-10-13 10:59:58'),
(948, 816, '/submitaccident.php?qr=816', '2025-10-13 10:59:58'),
(949, 817, '/submitaccident.php?qr=817', '2025-10-13 10:59:58'),
(950, 818, '/submitaccident.php?qr=818', '2025-10-13 10:59:58'),
(951, 819, '/submitaccident.php?qr=819', '2025-10-13 10:59:58'),
(952, 820, '/submitaccident.php?qr=820', '2025-10-13 10:59:58'),
(953, 821, '/submitaccident.php?qr=821', '2025-10-13 10:59:58'),
(954, 822, '/submitaccident.php?qr=822', '2025-10-13 10:59:58'),
(955, 823, '/submitaccident.php?qr=823', '2025-10-13 10:59:58'),
(956, 824, '/submitaccident.php?qr=824', '2025-10-13 10:59:58'),
(957, 825, '/submitaccident.php?qr=825', '2025-10-13 10:59:58'),
(958, 826, '/submitaccident.php?qr=826', '2025-10-13 10:59:58'),
(959, 827, '/submitaccident.php?qr=827', '2025-10-13 10:59:58'),
(960, 828, '/submitaccident.php?qr=828', '2025-10-13 10:59:58'),
(961, 829, '/submitaccident.php?qr=829', '2025-10-13 10:59:58'),
(962, 830, '/submitaccident.php?qr=830', '2025-10-13 10:59:58'),
(963, 831, '/submitaccident.php?qr=831', '2025-10-13 10:59:58'),
(964, 832, '/submitaccident.php?qr=832', '2025-10-13 10:59:58'),
(965, 833, '/submitaccident.php?qr=833', '2025-10-13 10:59:58'),
(966, 834, '/submitaccident.php?qr=834', '2025-10-13 10:59:58'),
(967, 835, '/submitaccident.php?qr=835', '2025-10-13 10:59:58'),
(968, 836, '/submitaccident.php?qr=836', '2025-10-13 10:59:58'),
(969, 837, '/submitaccident.php?qr=837', '2025-10-13 10:59:58'),
(970, 838, '/submitaccident.php?qr=838', '2025-10-13 10:59:58'),
(971, 839, '/submitaccident.php?qr=839', '2025-10-13 10:59:58'),
(972, 840, '/submitaccident.php?qr=840', '2025-10-13 10:59:58'),
(973, 841, '/submitaccident.php?qr=841', '2025-10-13 10:59:58'),
(974, 842, '/submitaccident.php?qr=842', '2025-10-13 10:59:58'),
(975, 843, '/submitaccident.php?qr=843', '2025-10-13 10:59:58'),
(976, 844, '/submitaccident.php?qr=844', '2025-10-13 10:59:58'),
(977, 845, '/submitaccident.php?qr=845', '2025-10-13 10:59:58'),
(978, 846, '/submitaccident.php?qr=846', '2025-10-13 10:59:58'),
(979, 847, '/submitaccident.php?qr=847', '2025-10-13 10:59:58'),
(980, 848, '/submitaccident.php?qr=848', '2025-10-13 10:59:58'),
(981, 849, '/submitaccident.php?qr=849', '2025-10-13 10:59:58'),
(982, 850, '/submitaccident.php?qr=850', '2025-10-13 10:59:58'),
(983, 851, '/submitaccident.php?qr=851', '2025-10-13 10:59:58'),
(984, 852, '/submitaccident.php?qr=852', '2025-10-13 10:59:58'),
(985, 853, '/submitaccident.php?qr=853', '2025-10-13 10:59:58'),
(986, 854, '/submitaccident.php?qr=854', '2025-10-13 10:59:58'),
(987, 855, '/submitaccident.php?qr=855', '2025-10-13 10:59:58'),
(988, 856, '/submitaccident.php?qr=856', '2025-10-13 10:59:58'),
(989, 857, '/submitaccident.php?qr=857', '2025-10-13 10:59:58'),
(990, 858, '/submitaccident.php?qr=858', '2025-10-13 10:59:58'),
(991, 859, '/submitaccident.php?qr=859', '2025-10-13 10:59:58'),
(992, 860, '/submitaccident.php?qr=860', '2025-10-13 10:59:58'),
(993, 861, '/submitaccident.php?qr=861', '2025-10-13 10:59:58'),
(994, 862, '/submitaccident.php?qr=862', '2025-10-13 10:59:58'),
(995, 863, '/submitaccident.php?qr=863', '2025-10-13 10:59:58'),
(996, 864, '/submitaccident.php?qr=864', '2025-10-13 10:59:58'),
(997, 865, '/submitaccident.php?qr=865', '2025-10-13 10:59:58'),
(998, 866, '/submitaccident.php?qr=866', '2025-10-13 10:59:58'),
(999, 867, '/submitaccident.php?qr=867', '2025-10-13 10:59:58'),
(1000, 868, '/submitaccident.php?qr=868', '2025-10-13 10:59:58'),
(1001, 869, '/submitaccident.php?qr=869', '2025-10-13 10:59:58'),
(1002, 870, '/submitaccident.php?qr=870', '2025-10-13 10:59:58'),
(1003, 871, '/submitaccident.php?qr=871', '2025-10-13 10:59:58'),
(1004, 872, '/submitaccident.php?qr=872', '2025-10-13 10:59:58'),
(1005, 873, '/submitaccident.php?qr=873', '2025-10-13 10:59:58'),
(1006, 874, '/submitaccident.php?qr=874', '2025-10-13 10:59:58'),
(1007, 875, '/submitaccident.php?qr=875', '2025-10-13 10:59:58'),
(1008, 876, '/submitaccident.php?qr=876', '2025-10-13 10:59:58'),
(1009, 877, '/submitaccident.php?qr=877', '2025-10-13 10:59:58'),
(1010, 878, '/submitaccident.php?qr=878', '2025-10-13 10:59:58'),
(1011, 879, '/submitaccident.php?qr=879', '2025-10-13 10:59:58'),
(1012, 880, '/submitaccident.php?qr=880', '2025-10-13 10:59:58'),
(1013, 881, '/submitaccident.php?qr=881', '2025-10-13 10:59:58'),
(1014, 882, '/submitaccident.php?qr=882', '2025-10-13 10:59:58'),
(1015, 883, '/submitaccident.php?qr=883', '2025-10-13 10:59:58'),
(1016, 884, '/submitaccident.php?qr=884', '2025-10-13 10:59:58'),
(1017, 885, '/submitaccident.php?qr=885', '2025-10-13 10:59:58'),
(1018, 886, '/submitaccident.php?qr=886', '2025-10-13 10:59:58'),
(1019, 887, '/submitaccident.php?qr=887', '2025-10-13 10:59:58'),
(1020, 888, '/submitaccident.php?qr=888', '2025-10-13 10:59:58'),
(1021, 889, '/submitaccident.php?qr=889', '2025-10-13 10:59:58'),
(1022, 890, '/submitaccident.php?qr=890', '2025-10-13 10:59:58'),
(1023, 891, '/submitaccident.php?qr=891', '2025-10-13 10:59:58'),
(1024, 892, '/submitaccident.php?qr=892', '2025-10-13 10:59:58'),
(1025, 893, '/submitaccident.php?qr=893', '2025-10-13 10:59:58'),
(1026, 894, '/submitaccident.php?qr=894', '2025-10-13 10:59:58'),
(1027, 895, '/submitaccident.php?qr=895', '2025-10-13 10:59:58'),
(1028, 896, '/submitaccident.php?qr=896', '2025-10-13 10:59:58'),
(1029, 897, '/submitaccident.php?qr=897', '2025-10-13 10:59:58'),
(1030, 898, '/submitaccident.php?qr=898', '2025-10-13 10:59:58'),
(1031, 899, '/submitaccident.php?qr=899', '2025-10-13 10:59:58'),
(1032, 900, '/submitaccident.php?qr=900', '2025-10-13 10:59:58'),
(1033, 901, '/submitaccident.php?qr=901', '2025-10-13 10:59:58'),
(1034, 902, '/submitaccident.php?qr=902', '2025-10-13 10:59:58'),
(1035, 903, '/submitaccident.php?qr=903', '2025-10-13 10:59:58'),
(1036, 904, '/submitaccident.php?qr=904', '2025-10-13 10:59:58'),
(1037, 905, '/submitaccident.php?qr=905', '2025-10-13 10:59:58'),
(1038, 906, '/submitaccident.php?qr=906', '2025-10-13 10:59:58'),
(1039, 907, '/submitaccident.php?qr=907', '2025-10-13 10:59:58'),
(1040, 908, '/submitaccident.php?qr=908', '2025-10-13 10:59:58'),
(1041, 909, '/submitaccident.php?qr=909', '2025-10-13 10:59:58'),
(1042, 910, '/submitaccident.php?qr=910', '2025-10-13 10:59:58'),
(1043, 911, '/submitaccident.php?qr=911', '2025-10-13 10:59:58'),
(1044, 912, '/submitaccident.php?qr=912', '2025-10-13 10:59:58'),
(1045, 913, '/submitaccident.php?qr=913', '2025-10-13 10:59:58'),
(1046, 914, '/submitaccident.php?qr=914', '2025-10-13 10:59:58'),
(1047, 915, '/submitaccident.php?qr=915', '2025-10-13 10:59:58'),
(1048, 916, '/submitaccident.php?qr=916', '2025-10-13 10:59:58'),
(1049, 917, '/submitaccident.php?qr=917', '2025-10-13 10:59:58'),
(1050, 918, '/submitaccident.php?qr=918', '2025-10-13 10:59:58'),
(1051, 919, '/submitaccident.php?qr=919', '2025-10-13 10:59:58'),
(1052, 920, '/submitaccident.php?qr=920', '2025-10-13 10:59:58'),
(1053, 921, '/submitaccident.php?qr=921', '2025-10-13 10:59:58'),
(1054, 922, '/submitaccident.php?qr=922', '2025-10-13 10:59:58'),
(1055, 923, '/submitaccident.php?qr=923', '2025-10-13 10:59:58'),
(1056, 924, '/submitaccident.php?qr=924', '2025-10-13 10:59:58'),
(1057, 925, '/submitaccident.php?qr=925', '2025-10-13 10:59:58'),
(1058, 926, '/submitaccident.php?qr=926', '2025-10-13 10:59:58'),
(1059, 927, '/submitaccident.php?qr=927', '2025-10-13 10:59:58'),
(1060, 928, '/submitaccident.php?qr=928', '2025-10-13 10:59:58'),
(1061, 929, '/submitaccident.php?qr=929', '2025-10-13 10:59:58'),
(1062, 930, '/submitaccident.php?qr=930', '2025-10-13 10:59:58'),
(1063, 931, '/submitaccident.php?qr=931', '2025-10-13 10:59:58'),
(1064, 932, '/submitaccident.php?qr=932', '2025-10-13 10:59:58'),
(1065, 933, '/submitaccident.php?qr=933', '2025-10-13 10:59:58'),
(1066, 934, '/submitaccident.php?qr=934', '2025-10-13 10:59:58'),
(1067, 935, '/submitaccident.php?qr=935', '2025-10-13 10:59:58'),
(1068, 936, '/submitaccident.php?qr=936', '2025-10-13 10:59:58'),
(1069, 937, '/submitaccident.php?qr=937', '2025-10-13 10:59:58'),
(1070, 938, '/submitaccident.php?qr=938', '2025-10-13 10:59:58'),
(1071, 939, '/submitaccident.php?qr=939', '2025-10-13 10:59:58'),
(1072, 940, '/submitaccident.php?qr=940', '2025-10-13 10:59:58'),
(1073, 941, '/submitaccident.php?qr=941', '2025-10-13 10:59:58'),
(1074, 942, '/submitaccident.php?qr=942', '2025-10-13 10:59:58'),
(1075, 943, '/submitaccident.php?qr=943', '2025-10-13 10:59:58'),
(1076, 944, '/submitaccident.php?qr=944', '2025-10-13 10:59:58'),
(1077, 945, '/submitaccident.php?qr=945', '2025-10-13 10:59:58'),
(1078, 946, '/submitaccident.php?qr=946', '2025-10-13 10:59:58'),
(1079, 947, '/submitaccident.php?qr=947', '2025-10-13 10:59:58'),
(1080, 948, '/submitaccident.php?qr=948', '2025-10-13 10:59:58'),
(1081, 949, '/submitaccident.php?qr=949', '2025-10-13 10:59:58'),
(1082, 950, '/submitaccident.php?qr=950', '2025-10-13 10:59:58'),
(1083, 951, '/submitaccident.php?qr=951', '2025-10-13 10:59:58'),
(1084, 952, '/submitaccident.php?qr=952', '2025-10-13 10:59:58'),
(1085, 953, '/submitaccident.php?qr=953', '2025-10-13 10:59:58'),
(1086, 954, '/submitaccident.php?qr=954', '2025-10-13 10:59:58'),
(1087, 955, '/submitaccident.php?qr=955', '2025-10-13 10:59:58'),
(1088, 956, '/submitaccident.php?qr=956', '2025-10-13 10:59:58'),
(1089, 957, '/submitaccident.php?qr=957', '2025-10-13 10:59:58'),
(1090, 958, '/submitaccident.php?qr=958', '2025-10-13 10:59:58'),
(1091, 959, '/submitaccident.php?qr=959', '2025-10-13 10:59:58'),
(1092, 960, '/submitaccident.php?qr=960', '2025-10-13 10:59:58'),
(1093, 961, '/submitaccident.php?qr=961', '2025-10-13 10:59:58'),
(1094, 962, '/submitaccident.php?qr=962', '2025-10-13 10:59:58'),
(1095, 963, '/submitaccident.php?qr=963', '2025-10-13 10:59:58'),
(1096, 964, '/submitaccident.php?qr=964', '2025-10-13 10:59:58'),
(1097, 965, '/submitaccident.php?qr=965', '2025-10-13 10:59:58'),
(1098, 966, '/submitaccident.php?qr=966', '2025-10-13 10:59:58'),
(1099, 967, '/submitaccident.php?qr=967', '2025-10-13 10:59:58'),
(1100, 968, '/submitaccident.php?qr=968', '2025-10-13 10:59:58'),
(1101, 969, '/submitaccident.php?qr=969', '2025-10-13 10:59:58'),
(1102, 970, '/submitaccident.php?qr=970', '2025-10-13 10:59:58'),
(1103, 971, '/submitaccident.php?qr=971', '2025-10-13 10:59:58'),
(1104, 972, '/submitaccident.php?qr=972', '2025-10-13 10:59:58'),
(1105, 973, '/submitaccident.php?qr=973', '2025-10-13 10:59:58'),
(1106, 974, '/submitaccident.php?qr=974', '2025-10-13 10:59:58'),
(1107, 975, '/submitaccident.php?qr=975', '2025-10-13 10:59:58'),
(1108, 976, '/submitaccident.php?qr=976', '2025-10-13 10:59:58'),
(1109, 977, '/submitaccident.php?qr=977', '2025-10-13 10:59:58'),
(1110, 978, '/submitaccident.php?qr=978', '2025-10-13 10:59:58'),
(1111, 979, '/submitaccident.php?qr=979', '2025-10-13 10:59:58'),
(1112, 980, '/submitaccident.php?qr=980', '2025-10-13 10:59:58'),
(1113, 981, '/submitaccident.php?qr=981', '2025-10-13 10:59:58'),
(1114, 982, '/submitaccident.php?qr=982', '2025-10-13 10:59:58'),
(1115, 983, '/submitaccident.php?qr=983', '2025-10-13 10:59:58'),
(1116, 984, '/submitaccident.php?qr=984', '2025-10-13 10:59:58'),
(1117, 985, '/submitaccident.php?qr=985', '2025-10-13 10:59:58'),
(1118, 986, '/submitaccident.php?qr=986', '2025-10-13 10:59:58'),
(1119, 987, '/submitaccident.php?qr=987', '2025-10-13 10:59:58'),
(1120, 988, '/submitaccident.php?qr=988', '2025-10-13 10:59:58'),
(1121, 989, '/submitaccident.php?qr=989', '2025-10-13 10:59:58'),
(1122, 990, '/submitaccident.php?qr=990', '2025-10-13 10:59:58'),
(1123, 991, '/submitaccident.php?qr=991', '2025-10-13 10:59:58'),
(1124, 992, '/submitaccident.php?qr=992', '2025-10-13 10:59:58'),
(1125, 993, '/submitaccident.php?qr=993', '2025-10-13 10:59:58'),
(1126, 994, '/submitaccident.php?qr=994', '2025-10-13 10:59:58'),
(1127, 995, '/submitaccident.php?qr=995', '2025-10-13 10:59:58'),
(1128, 996, '/submitaccident.php?qr=996', '2025-10-13 10:59:58'),
(1129, 997, '/submitaccident.php?qr=997', '2025-10-13 10:59:58'),
(1130, 998, '/submitaccident.php?qr=998', '2025-10-13 10:59:58'),
(1131, 999, '/submitaccident.php?qr=999', '2025-10-13 10:59:58'),
(1132, 1000, '/submitaccident.php?qr=1000', '2025-10-13 10:59:58'),
(1133, 1001, '/submitaccident.php?qr=1001', '2025-10-13 10:59:58'),
(1134, 1002, '/submitaccident.php?qr=1002', '2025-10-13 10:59:58'),
(1135, 1003, '/submitaccident.php?qr=1003', '2025-10-13 10:59:58'),
(1136, 1004, '/submitaccident.php?qr=1004', '2025-10-13 10:59:58'),
(1137, 1005, '/submitaccident.php?qr=1005', '2025-10-13 10:59:58'),
(1138, 1006, '/submitaccident.php?qr=1006', '2025-10-13 10:59:58'),
(1139, 1007, '/submitaccident.php?qr=1007', '2025-10-13 10:59:58'),
(1140, 1008, '/submitaccident.php?qr=1008', '2025-10-13 10:59:58'),
(1141, 1009, '/submitaccident.php?qr=1009', '2025-10-13 10:59:58'),
(1142, 1010, '/submitaccident.php?qr=1010', '2025-10-13 10:59:58'),
(1143, 1011, '/submitaccident.php?qr=1011', '2025-10-13 10:59:58'),
(1144, 1012, '/submitaccident.php?qr=1012', '2025-10-13 10:59:58'),
(1145, 1013, '/submitaccident.php?qr=1013', '2025-10-13 10:59:58'),
(1146, 1014, '/submitaccident.php?qr=1014', '2025-10-13 10:59:58'),
(1147, 1015, '/submitaccident.php?qr=1015', '2025-10-13 10:59:58'),
(1148, 1016, '/submitaccident.php?qr=1016', '2025-10-13 10:59:58'),
(1149, 1017, '/submitaccident.php?qr=1017', '2025-10-13 10:59:58'),
(1150, 1018, '/submitaccident.php?qr=1018', '2025-10-13 10:59:58'),
(1151, 1019, '/submitaccident.php?qr=1019', '2025-10-13 10:59:58'),
(1152, 1020, '/submitaccident.php?qr=1020', '2025-10-13 10:59:58');

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
-- Table structure for table `sms_logs`
--

CREATE TABLE `sms_logs` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `family_member_id` int(11) DEFAULT NULL,
  `phone_number` varchar(20) NOT NULL,
  `message` text NOT NULL,
  `status` enum('sent','failed','error') NOT NULL,
  `api_response` text DEFAULT NULL,
  `sent_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sms_logs`
--

INSERT INTO `sms_logs` (`id`, `client_id`, `family_member_id`, `phone_number`, `message`, `status`, `api_response`, `sent_at`) VALUES
(1, 5, 1, '8959176446', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154991, Lng: 79.926007)\nCoordinates: 23.1549906,79.9260072\nMap Link: https://www.google.com/maps?q=23.1549906,79.9260072\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.313965 S.848908 S.892029  \r\n', '2025-09-27 16:28:52'),
(2, 5, 2, '8989898989', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154991, Lng: 79.926007)\nCoordinates: 23.1549906,79.9260072\nMap Link: https://www.google.com/maps?q=23.1549906,79.9260072\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.639130 S.182496 S.331208  \r\n', '2025-09-27 16:28:54'),
(3, 5, 1, '8959176446', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154991, Lng: 79.926007)\nCoordinates: 23.1549906,79.9260072\nMap Link: https://www.google.com/maps?q=23.1549906,79.9260072\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.653595 S.602967 S.131318  \r\n', '2025-09-27 16:36:22'),
(4, 5, 2, '8989898989', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154991, Lng: 79.926007)\nCoordinates: 23.1549906,79.9260072\nMap Link: https://www.google.com/maps?q=23.1549906,79.9260072\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.612244 S.392548 S.555054  \r\n', '2025-09-27 16:36:24'),
(5, 5, 1, '8959176446', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154991, Lng: 79.926007)\nCoordinates: 23.1549906,79.9260072\nMap Link: https://www.google.com/maps?q=23.1549906,79.9260072\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.943970 S.456940 S.355042 ', '2025-09-27 16:36:36'),
(6, 5, 2, '8989898989', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154991, Lng: 79.926007)\nCoordinates: 23.1549906,79.9260072\nMap Link: https://www.google.com/maps?q=23.1549906,79.9260072\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.401215 S.562256 S.787629  \r\n', '2025-09-27 16:36:40'),
(7, 5, 1, '8959176446', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154991, Lng: 79.926007)\nCoordinates: 23.1549906,79.9260072\nMap Link: https://www.google.com/maps?q=23.1549906,79.9260072\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.92042 S.284211 S.465027  \r\n', '2025-09-27 16:36:50'),
(8, 5, 2, '8989898989', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154991, Lng: 79.926007)\nCoordinates: 23.1549906,79.9260072\nMap Link: https://www.google.com/maps?q=23.1549906,79.9260072\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.15107 S.663941 S.308747  \r\n', '2025-09-27 16:36:51'),
(9, 10, 15, '9508570649', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: 1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155051, Lng: 79.926004)\nCoordinates: 23.1550505,79.9260037\nMap Link: https://www.google.com/maps?q=23.1550505,79.9260037\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.263825 S.180481 S.892914  \r\n', '2025-09-27 17:10:04'),
(10, 10, 15, '9508570649', '🚨 APATKAL EMERGENCY 🚨\n\nAccident Location: 1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155051, Lng: 79.926004)\nCoordinates: 23.1550505,79.9260037\nMap Link: https://www.google.com/maps?q=23.1550505,79.9260037\n\nEmergency Contact: 18005709696\nWebsite: https://apatkal.com', 'failed', 'S.742310 S.725983 S.930726  \r\n', '2025-09-27 17:10:05'),
(11, 11, 16, '7898140799', '🚨 ACCIDENT ALERT 🚨\n\nVehicle: MP20KJ0005\nDriver: siddharth\nLocation: XGWG+8J Pathar Kansiya, Madhya Pradesh, India (Lat: 22.995800, Lng: 77.526600)\nTime: 2025-10-03 09:08:40\n\nPlease contact immediately!\nEmergency: Contact Apatkal Support', 'failed', 'S.8698 S.996644  \r\n', '2025-10-03 12:38:43'),
(12, 10, 15, '9508570649', '🚨 ACCIDENT ALERT 🚨\n\nVehicle: MP20PH2265\nDriver: geetanjali\nLocation: XGWG+8J Pathar Kansiya, Madhya Pradesh, India (Lat: 22.995800, Lng: 77.526600)\nTime: 2025-10-03 09:09:53\n\nPlease contact immediately!\nEmergency: Contact Apatkal Support', 'failed', 'S.785584 S.536591  \r\n', '2025-10-03 12:39:55'),
(13, 10, 15, '9508570649', '🚨 ACCIDENT ALERT 🚨\n\nVehicle: MP20PH2265\nDriver: geetanjali\nLocation: XGWG+8J Pathar Kansiya, Madhya Pradesh, India (Lat: 22.995800, Lng: 77.526600)\nTime: 2025-10-03 09:12:21\n\nPlease contact immediately!\nEmergency: Contact Apatkal Support', 'failed', 'S.745148 S.707215  \r\n', '2025-10-03 12:42:23'),
(14, 10, 15, '9508570649', '🚨 ACCIDENT ALERT 🚨\n\nVehicle: MP20PH2265\nDriver: geetanjali\nLocation: XGWG+8J Pathar Kansiya, Madhya Pradesh, India (Lat: 22.995800, Lng: 77.526600)\nTime: 2025-10-03 09:18:30\n\nPlease contact immediately!\nEmergency: Contact Apatkal Support', 'failed', 'S.373993 S.32593  \r\n', '2025-10-03 12:48:31');

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
(0, 1, '', 'XGWG+8J Pathar Kansiya, Madhya Pradesh, India (Lat: 22.995800, Lng: 77.526600)', '2025-10-04 09:11:59', 505.00, 1, '2025-10-04 09:11:59', '2025-10-04 03:42:16', '2025-10-04 09:12:16'),
(1, 1, 'Priya Sharma', 'Apollo Hospital, Indore', '2025-09-20 09:00:00', 1800.00, 45, '2025-09-20 09:05:00', '2025-09-20 09:50:00', '2025-09-20 09:00:00'),
(2, 1, 'Rajesh Kumar', 'Fortis Hospital, Bhopal', '2025-09-27 03:45:00', 2200.00, 60, '2025-09-27 03:50:00', '2025-09-27 04:50:00', '2025-09-27 03:45:00'),
(3, 1, 'Meera Patel', 'Manipal Hospital, Jabalpur', '2025-10-01 11:15:00', 1950.00, 50, '2025-10-01 11:20:00', '2025-10-01 12:10:00', '2025-10-01 11:15:00'),
(4, 1, 'Vikram Singh', 'AIIMS Hospital, Delhi', '2025-10-02 06:00:00', 2800.00, 75, '2025-10-02 06:05:00', '2025-10-02 06:15:00', '2025-10-02 06:00:00'),
(9, 1, 'siddharth', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154840, Lng: 79.926024)', '2025-10-06 04:46:16', 505.00, 1, '2025-10-06 04:46:16', '2025-10-05 23:16:37', '2025-10-06 04:46:37'),
(16, 1, 'dhaneshwari', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155072, Lng: 79.926017)', '2025-10-06 09:18:39', 505.00, 1, '2025-10-06 09:18:39', '2025-10-06 03:49:23', '2025-10-06 09:19:23');

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
(1, 'Admin', 'User', 'admin@apatkal.com', '', '$2y$10$MwM62gNOKcbw5RIxp2LpHOumiuD.i7vqxupBpir9no7Uv0/Hz6/Fy', 'admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', 0, 1, '2025-10-13 11:04:30', '2025-09-13 08:01:19', '2025-10-13 11:04:30'),
(2, 'Krishna', 'Vish', 'Toss125traininag@gmai.com', '7723065844', '$2y$10$pZ8DQ4CufH1drx2OF5qMnuPXgpPuWCT.Z5.wnHc38Oy7.HR036jVq', 'sales', NULL, NULL, '', NULL, NULL, NULL, NULL, 'sales', 0, 1, NULL, '2025-09-13 15:46:08', '2025-09-13 17:02:04'),
(3, 'Sarah', 'Johnson', 'hr@apatkal.com', '9876543210', '$2y$10$wDNv.mYbXpnet7re8If.keP.NPDOHoLOXgsqJBK1YBITQi2aWKn6u', 'hr_manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'hr', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(4, 'Mike', 'Davis', 'sales@apatkal.com', '9876543211', '$2y$10$4AYUzkUaaGtu5nnXGguB4.aPA.DgfCprSC5hnBGj4Mm7H1wkt4sti', 'sales_rep', NULL, NULL, '', NULL, NULL, NULL, NULL, 'sales', 0, 1, '2025-10-08 11:00:36', '2025-09-13 16:58:30', '2025-10-08 11:00:36'),
(5, 'Lisa', 'Wilson', 'office@apatkal.com', '9876543212', '$2y$10$w2eAWT7oUdswd6KDvTw0muJv4zVRsU35o10vMxLj/kBkyfnbv5nPC', 'office_staff', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'office_staff', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(6, 'David', 'Brown', 'manager@apatkal.com', '9876543213', '$2y$10$jV9jn2GjPqA7XJUP1p35ieUQNDbirBOZDRPE6pYsbpBq5zsGtwXAK', 'manager1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'manager', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(7, 'Emma', 'Garcia', 'supervisor@apatkal.com', '9876543214', '$2y$10$oSF8KFXrI.lOk.puE8igeOE5yeY/jNNSYaETcEHdqEhgVXqZVR3EC', 'supervisor1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'supervisor', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(8, 'Gulam', 'Gous', 'kalmaliindia@gmail.com', '8770658824', '$2y$10$FonFNbtwhX7uKdjK2J4rD.dXZ6L3O3GKUUfYhQBJ2/Mpsuyw4BIGK', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'user', 0, 1, '2025-09-14 00:10:22', '2025-09-14 00:07:43', '2025-09-14 00:10:22'),
(9, 'shivam', 'kumar', 'siddharth.toss.cs@gmail.com', '7723065844', '$2y$10$aUm.zWoadt.sD/2z8NfTCeUGGUwfSy8seH7ofmtoQ81xauAaM.RPS', 'shivam', NULL, NULL, 'frfre', NULL, NULL, NULL, NULL, 'supervisor', 0, 1, NULL, '2025-09-17 13:15:35', '2025-09-17 13:16:06'),
(10, 'siddharth', 'singh', 'shreyash.toss.cs@gmail.com', '7898140799', '$2y$10$WxVsjnomImnEgZyqMhz9XeI6JB9BTUL02Q2KhqgNNa3OlYa.WssyS', 'siddharth', NULL, NULL, 'jbp', NULL, NULL, NULL, NULL, 'hr', 0, 1, NULL, '2025-09-23 15:10:59', '2025-09-24 11:25:17'),
(11, 'aavi', 'thakur', 'sidhusingh7898thakur@gmail.com', '7898140799', '$2y$10$sN9jAh2LzTWxwcfT1s0NGuRnkAmvempf2LH0keRV54rN13hMC/xHW', 'aaavi', NULL, NULL, 'dsffsd', NULL, NULL, NULL, NULL, 'sales', 0, 0, NULL, '2025-09-24 11:27:41', '2025-09-24 15:31:43'),
(12, 'Krishna', 'Vishwakarma', 'Toss125training@gmail.com', '7723065844', '$2y$10$ImdXHAGbRAbMY8GGOP3xE.zfwXSJYusqVUZeGkIaOVljqqaNX2Aq2', 'krishnaToss', NULL, NULL, '', NULL, NULL, NULL, NULL, 'hr', 0, 1, '2025-09-26 11:40:00', '2025-09-26 11:39:03', '2025-09-26 11:40:00'),
(13, 'akuu', 'val', 'shreyas.toss.cs@gmail.com', '8520122520', '$2y$10$nWlgxIdoPvj3GPX861lQY.zPCidGRxRj.4SUnrCJCc5aVbZ52jSCa', 'akuu bal', NULL, NULL, 'mp', NULL, NULL, NULL, NULL, 'office_staff', 0, 1, '2025-10-10 17:07:54', '2025-10-06 13:59:48', '2025-10-10 17:07:54');

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

--
-- Dumping data for table `wallet`
--

INSERT INTO `wallet` (`wallet_id`, `driver_id`, `balance`, `total_earned`, `total_withdrawn`, `created_at`, `updated_at`) VALUES
(1, 1, 1250.00, 5950.00, 4700.00, '2025-08-01 04:30:00', '2025-10-07 04:34:23');

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

--
-- Dumping data for table `website_config`
--

INSERT INTO `website_config` (`id`, `config_key`, `config_value`, `created_at`, `updated_at`) VALUES
(1, 'header_content', 'Apatkal Emergency Services', '2025-10-04 07:33:55', '2025-10-04 07:33:55'),
(2, 'header_phone', '18005709696', '2025-10-04 07:33:55', '2025-10-04 07:33:55'),
(3, 'header_email', 'apatkalindia@gmail.com', '2025-10-04 07:33:55', '2025-10-04 07:34:33'),
(4, 'emergency_phone', '18005709696', '2025-10-04 07:33:55', '2025-10-04 07:33:55'),
(5, 'emergency_text', '24/7 Emergency Service', '2025-10-04 07:33:55', '2025-10-04 07:33:55');

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

--
-- Dumping data for table `withdrawals`
--

INSERT INTO `withdrawals` (`withdrawal_id`, `driver_id`, `amount`, `bank_account_number`, `bank_name`, `ifsc_code`, `account_holder_name`, `status`, `requested_at`, `processed_at`, `notes`) VALUES
(1, 1, 2000.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-09-21 05:00:00', '2025-09-22 08:50:00', 'Withdrawal after Sep 20 trip'),
(2, 1, 1500.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-09-28 05:45:00', '2025-09-29 11:00:00', 'Withdrawal after Sep 27 trip'),
(3, 1, 1200.00, '1234567890123456', 'State Bank of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-10-02 04:15:00', '2025-10-02 04:15:00', 'Withdrawal after Oct 1 trip');

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
-- Indexes for table `accident_remarks`
--
ALTER TABLE `accident_remarks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_accident_remarks_accident_id` (`accident_id`),
  ADD KEY `idx_accident_remarks_user_id` (`user_id`),
  ADD KEY `idx_accident_remarks_created_at` (`created_at`);

--
-- Indexes for table `accident_reports`
--
ALTER TABLE `accident_reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`);

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
  ADD KEY `idx_drivers_kyc_status` (`kyc_status`);

--
-- Indexes for table `earnings`
--
ALTER TABLE `earnings`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `family_members`
--
ALTER TABLE `family_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `header_config`
--
ALTER TABLE `header_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `config_key` (`config_key`);

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
-- Indexes for table `payment_transactions`
--
ALTER TABLE `payment_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_client` (`client_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_payment_date` (`payment_date`),
  ADD KEY `idx_transaction_id` (`transaction_id`);

--
-- Indexes for table `qr_codes`
--
ALTER TABLE `qr_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_qr_number` (`qr_number`);

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
-- Indexes for table `sms_logs`
--
ALTER TABLE `sms_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `family_member_id` (`family_member_id`),
  ADD KEY `idx_sms_logs_client_id` (`client_id`),
  ADD KEY `idx_sms_logs_phone` (`phone_number`),
  ADD KEY `idx_sms_logs_status` (`status`),
  ADD KEY `idx_sms_logs_sent_at` (`sent_at`);

--
-- Indexes for table `trips`
--
ALTER TABLE `trips`
  ADD PRIMARY KEY (`history_id`);

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
-- Indexes for table `wallet`
--
ALTER TABLE `wallet`
  ADD PRIMARY KEY (`wallet_id`);

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
  ADD PRIMARY KEY (`withdrawal_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accidents`
--
ALTER TABLE `accidents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `accident_photos`
--
ALTER TABLE `accident_photos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `accident_remarks`
--
ALTER TABLE `accident_remarks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `accident_reports`
--
ALTER TABLE `accident_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clients`
--
ALTER TABLE `clients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `client_family_members`
--
ALTER TABLE `client_family_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `client_logins`
--
ALTER TABLE `client_logins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `components`
--
ALTER TABLE `components`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `contact_submissions`
--
ALTER TABLE `contact_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `earnings`
--
ALTER TABLE `earnings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
-- AUTO_INCREMENT for table `family_members`
--
ALTER TABLE `family_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `header_config`
--
ALTER TABLE `header_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=884;

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
-- AUTO_INCREMENT for table `payment_transactions`
--
ALTER TABLE `payment_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `qr_codes`
--
ALTER TABLE `qr_codes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1153;

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
-- AUTO_INCREMENT for table `sms_logs`
--
ALTER TABLE `sms_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `trips`
--
ALTER TABLE `trips`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `wallet`
--
ALTER TABLE `wallet`
  MODIFY `wallet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `website_config`
--
ALTER TABLE `website_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `withdrawal_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accident_remarks`
--
ALTER TABLE `accident_remarks`
  ADD CONSTRAINT `accident_remarks_ibfk_1` FOREIGN KEY (`accident_id`) REFERENCES `accidents` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `accident_remarks_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `admin_profiles`
--
ALTER TABLE `admin_profiles`
  ADD CONSTRAINT `admin_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
