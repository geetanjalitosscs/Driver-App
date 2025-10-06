-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 06, 2025 at 09:58 AM
-- Server version: 10.6.23-MariaDB-cll-lve
-- PHP Version: 8.4.11

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
(9, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-04', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154840, Lng: 79.926024)', 23.15484042, 79.92602427, 'Testing 7', '', '2025-10-04 11:44:15', 'pending', NULL, NULL, NULL, NULL, 0);

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
(42, 8, '1759577485_Moon.jpg');

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

INSERT INTO `clients` (`id`, `full_name`, `mobile_no`, `email`, `vehicle_no`, `vehicle_type`, `created_date`, `house_no`, `address`, `landmark`, `state`, `district`, `city`, `pincode`, `added_by`, `assigned_staff`, `photo`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'Test Client', '9876543210', 'test@example.com', 'MH12AB1234', 'four-wheeler', '2025-01-15', '123 Test House', 'Test Address', 'Test Landmark', 'Maharashtra', 'Mumbai', 'Mumbai', '400001', 1, 1, NULL, '', 'Test client for verification', '2025-09-13 17:12:01', '2025-09-25 11:54:09'),
(2, 'Test', '9999999999', 'test@test.com', 'MP20KJ0001', 'four-wheeler', '2025-09-13', '', '', '', '', '', '', '', 1, 4, NULL, '', NULL, '2025-09-13 17:16:46', '2025-09-25 11:54:09'),
(3, 'mehak', '7771076100', 'kalmaliindia@gmail.com', 'mp20sa3333', 'four-wheeler', '2025-09-14', '430 taigore WARD JABALPUR', 'jabalpur', '', 'Madhya Pradesh', 'jabalpur', 'Jabalpur', '482004', 1, 3, NULL, '', NULL, '2025-09-14 00:25:38', '2025-09-25 11:54:09'),
(5, 'jai', '9999999990', 'kalmaliindia@gmail.com', 'mp20sa6567', 'four-wheeler', '2025-09-14', 'jabalpur', 'jabalpur', 'ground', 'Madhya Pradesh', 'jabalpur', 'Jabalpur', '482004', 1, 3, NULL, '', NULL, '2025-09-14 00:37:17', '2025-09-25 11:54:09'),
(10, 'geetanjali', '7694975580', 'siddharth.toss.cs@gmail.com', 'MP20PH2265', 'four-wheeler', '2025-09-17', '', 'rdthgfjdg', '', '', '', '', '', 1, NULL, NULL, 'paid', NULL, '2025-09-17 12:43:04', '2025-10-04 16:20:32'),
(11, 'siddharth', '9508570649', 'siddharth.toss.cs@gmail.com', 'MP20KJ0005', 'four-wheeler', '2025-09-17', NULL, 'hhgdrt', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'unpaid', NULL, '2025-09-17 15:25:38', '2025-09-27 11:59:58'),
(26, 'Krishna Vishwakarma', '8959176446', 'Krishna.vishwakarma@tosssolution.in', 'mp20ab2010', 'four-wheeler', '2025-09-27', NULL, 'Toss solution Jabalpur', NULL, '', '', '', '482001', 1, NULL, NULL, 'unpaid', NULL, '2025-09-27 13:37:09', '2025-09-27 13:37:09'),
(0, 'testing 1', '8827944207', 'Toss125traingin@gmail.com', 'mp20ab2011', 'two-wheeler', '2025-09-28', NULL, 'Behind new post office\r\nबिहाइंड न्यू पोस्ट ऑफिस', NULL, 'Madhya Pradesh', 'Katni', 'Sihora', '483225', 1, NULL, NULL, 'unpaid', NULL, '2025-09-28 12:00:26', '2025-09-28 12:00:26'),
(0, 'siddharth', '7898140799', 'siddharthsingh@gmail.com', 'Mp20ZB6308', 'two-wheeler', '2025-09-28', NULL, 'adhartal', NULL, 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482004', 1, NULL, NULL, 'unpaid', NULL, '2025-09-28 14:54:17', '2025-09-28 14:54:17'),
(0, 'Hussain', '7898684888', 'admin@apatkal.com', 'Mp20nm2713', 'two-wheeler', '2025-09-30', NULL, '140 gohalpur ramnahar chitranjan ward jabalpur\r\nGohalpur\r\nJabalpur', NULL, 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482002', 1, NULL, NULL, 'unpaid', NULL, '2025-09-30 01:34:57', '2025-09-30 01:34:57'),
(0, 'Kritika', '7694975579', 'toss125training@gmail.com', 'mp20ch8770', 'two-wheeler', '2025-10-04', NULL, 'Shastri nagar', NULL, 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482001', 1, NULL, NULL, 'unpaid', NULL, '2025-10-04 16:23:42', '2025-10-04 16:23:42'),
(0, 'Shreyash', '9755833563', 'toss125training@gmail.com', 'mp20ch8790', 'two-wheeler', '2025-10-04', NULL, 'Shastri nagar', NULL, 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482001', 1, NULL, NULL, 'unpaid', NULL, '2025-10-04 16:26:11', '2025-10-04 16:26:11'),
(0, 'dhaneshwari', '7806062421', 'admin@company.com', 'mp20ch8799', 'two-wheeler', '2025-10-04', NULL, 'ssd', NULL, 'Madhya Pradesh', 'Narsinghpur', 'NA', '487118', 1, NULL, NULL, 'unpaid', NULL, '2025-10-04 16:53:06', '2025-10-04 16:53:06');

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
(15, 10, 'shivam kumar', '9508570649', 'siddharth.toss.cs@gmail.com', 'brother', '2025-09-12', 'wefst', NULL, 1, NULL, '2025-09-25 18:15:54', '2025-09-25 18:15:54'),
(16, 11, 'Test', '7898140799', 'admintest@apatkal.com', 'daughter', '2025-09-25', NULL, NULL, 0, NULL, '2025-09-25 19:04:30', '2025-09-25 19:04:30'),
(20, 26, 'Krishna Vishwakarma', '7869722272', 'toss125training@gmail.com', 'son', '2025-10-01', 'Toss solution Jabalpur', NULL, 1, NULL, '2025-09-27 13:59:40', '2025-09-27 13:59:40'),
(21, 33, 'siddharth', '9555363996', 'sid@gmail.com', 'brother', '2003-02-21', 'few', NULL, 1, NULL, '2025-10-03 13:21:57', '2025-10-03 13:21:57');

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
(2, 10, '7694975579', '$2y$10$w9xJZuLM1exthm.mu/uKruxqKBy2jFEwNAxwPMxpCe5gSF7Fyg8xi', 'active', NULL, '2025-09-17 12:43:04', '2025-09-17 12:43:04'),
(3, 11, '9508570649', '$2y$10$7js7HmTTivXLz4erd1bwx.Zb6U.EI.3lpivJnErHZAKadoSL9wtU2', 'active', NULL, '2025-09-17 15:25:38', '2025-09-22 15:46:08'),
(16, 26, '8959176446', '$2y$10$w/J.IYdmt.IKe/0CDWrsTOpe5l.OhICXUNQ548yrpDdjCkedVAg66', 'active', NULL, '2025-09-27 13:37:09', '2025-09-27 13:37:09'),
(23, 33, '7898140799', '$2y$10$8OdSfoBbgfdlnYtnREyWMu7XZhvVV/PsW1db0b6A4.W4AOHB5jbki', 'active', NULL, '2025-09-29 18:07:51', '2025-09-29 18:07:51'),
(25, 0, '9755833563', '$2y$10$v7SIFFRWL5O165iUIHfm0OaD8ieOk8PNtMWt88eApdIwEvHzLEjIS', 'active', NULL, '2025-10-04 16:26:11', '2025-10-04 16:26:11'),
(26, 0, '7806062421', '$2y$10$gJb.iYHYuiQLIYISVxvVL.WiHpDn15bMq199vwbA.Ix0N9YqnUN9S', 'active', NULL, '2025-10-04 16:53:06', '2025-10-04 16:53:06');

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
(3, 'siddharth', '7888886523', 'siddharth.toss.cs@gmail.com', 'dffffffffffffff', 'new', '2025-09-17 08:07:31', NULL),
(4, 'siddharth', '7888886523', 'sidhusingh7898thakur@gmail.com', 'q', 'new', '2025-09-24 09:51:53', NULL),
(5, 'new', '9876543210', 'Toss125training@gmail.com', 'dwsasfsdf', 'resolved', '2025-09-29 08:25:44', NULL),
(6, 'image', '9876543210', 'saddfs@gmail.com', 'testing processsss', 'pending', '2025-09-29 09:12:52', NULL),
(7, 'ensurekar', '8952023654', 'krishna.vish9329@gmail.com', 'tttest', 'resolved', '2025-09-29 09:13:59', NULL),
(8, 'ensurekar', '8952023654', 'krishna.vish9329@gmail.com', 'tttest', 'pending', '2025-09-29 09:20:08', NULL),
(9, 'ensurekar', '8952023654', 'krishna.vish9329@gmail.com', 'tttest', 'pending', '2025-09-29 09:20:18', NULL),
(10, 'new', '9876543210', 'toss125training@gmail.com', 'teeeest', 'resolved', '2025-09-29 09:20:35', 'doneeeee'),
(11, 'new', '9876543210', 'toss125training@gmail.com', 'teeeest', 'pending', '2025-09-29 09:25:40', NULL),
(12, 'rgram', '9876543210', 'Toss125training@gmail.com', 'edwatfvxcvz', 'pending', '2025-09-29 09:28:08', NULL),
(13, 'rgram', '9876543210', 'Toss125training@gmail.com', 'edwatfvxcvz', 'pending', '2025-09-29 09:38:49', NULL),
(14, 'toss', '9876543210', 'toss125training@gmail.com', 'testttting', 'pending', '2025-09-29 09:42:54', 'done');

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `drivers`
--

INSERT INTO `drivers` (`id`, `driver_name`, `email`, `password`, `number`, `address`, `vehicle_type`, `vehicle_number`, `model_rating`, `aadhar_photo`, `licence_photo`, `rc_photo`, `created_at`, `updated_at`) VALUES
(1, 'Rajesh Sharma', 'rajesh.sharma90@gmail.com', '$2y$10$X7jMStqD5ERzpsgYXhu.Mejq1YKUHLbtN9GpWmj/tbrpZSRf9be5i', '9876543210', '123, Gandhi Marg, Sue Delhi', 'Ambulance', 'DL01AB1234', 4.8, 'aadhar_rajash.jpg', 'licence_rajash.jpg', 'rc_rajash.jpg', '2025-09-24 05:52:18', '2025-09-25 03:42:54'),
(2, 'Dhaneshwari Patel', 'dhaneshwari17@gmail.com', '$2y$10$FmHuB6iiE1YqLNBb4hRfjOR2WQfFIR7EcOspYG7FJJqItOK0IRu9q', '7945681234', 'beohari mp', 'Ambulance', 'mp20mz4528', NULL, 'screencapture-103-14-120-163-8083-organization-2025-09-22-16_26_14.png', 'screencapture-103-14-120-163-8083-organization-2025-09-22-16_26_14.png', 'screencapture-tossconsultancyservices-atlassian-net-jira-software-projects-AWA-boards-101-2025-09-23-11_43_19.png', '2025-09-25 04:20:15', '2025-09-25 04:20:15'),
(0, 'amit', 'kalmaliindia@gmail.com', '$2y$10$5umnfnk.EgxwjelKFomLLekkdsYdHe6FKGVNkGWILLhim6j1lgvna', '8770658824', 'jabalpur', 'ambulance', 'mp20ja6365', NULL, 'JPEG_20250927_235821_3502812970878090506.jpg', 'JPEG_20250927_235827_7286715491207715510.jpg', 'default_rc.jpg', '2025-09-27 18:28:45', '2025-09-27 18:28:45');

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
(4, 1, 'Vikram Singh', 'AIIMS Hospital, Delhi', '2025-10-02 06:00:00', 2800.00, 75, '2025-10-02 06:05:00', '2025-10-02 06:15:00', '2025-10-02 06:00:00');

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
(1, 'Admin', 'User', 'admin@apatkal.com', '', '$2y$10$MwM62gNOKcbw5RIxp2LpHOumiuD.i7vqxupBpir9no7Uv0/Hz6/Fy', 'admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', 0, 1, '2025-10-04 17:01:52', '2025-09-13 08:01:19', '2025-10-04 17:01:52'),
(2, 'Krishna', 'Vish', 'Toss125traininag@gmai.com', '7723065844', '$2y$10$pZ8DQ4CufH1drx2OF5qMnuPXgpPuWCT.Z5.wnHc38Oy7.HR036jVq', 'sales', NULL, NULL, '', NULL, NULL, NULL, NULL, 'sales', 0, 1, NULL, '2025-09-13 15:46:08', '2025-09-13 17:02:04'),
(3, 'Sarah', 'Johnson', 'hr@apatkal.com', '9876543210', '$2y$10$wDNv.mYbXpnet7re8If.keP.NPDOHoLOXgsqJBK1YBITQi2aWKn6u', 'hr_manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'hr', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(4, 'Mike', 'Davis', 'sales@apatkal.com', '9876543211', '$2y$10$4AYUzkUaaGtu5nnXGguB4.aPA.DgfCprSC5hnBGj4Mm7H1wkt4sti', 'sales_rep', NULL, NULL, '', NULL, NULL, NULL, NULL, 'sales', 0, 1, '2025-09-14 14:17:26', '2025-09-13 16:58:30', '2025-09-14 14:17:26'),
(5, 'Lisa', 'Wilson', 'office@apatkal.com', '9876543212', '$2y$10$w2eAWT7oUdswd6KDvTw0muJv4zVRsU35o10vMxLj/kBkyfnbv5nPC', 'office_staff', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'office_staff', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(6, 'David', 'Brown', 'manager@apatkal.com', '9876543213', '$2y$10$jV9jn2GjPqA7XJUP1p35ieUQNDbirBOZDRPE6pYsbpBq5zsGtwXAK', 'manager1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'manager', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(7, 'Emma', 'Garcia', 'supervisor@apatkal.com', '9876543214', '$2y$10$oSF8KFXrI.lOk.puE8igeOE5yeY/jNNSYaETcEHdqEhgVXqZVR3EC', 'supervisor1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'supervisor', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(8, 'Gulam', 'Gous', 'kalmaliindia@gmail.com', '8770658824', '$2y$10$FonFNbtwhX7uKdjK2J4rD.dXZ6L3O3GKUUfYhQBJ2/Mpsuyw4BIGK', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'user', 0, 1, '2025-09-14 00:10:22', '2025-09-14 00:07:43', '2025-09-14 00:10:22'),
(9, 'shivam', 'kumar', 'siddharth.toss.cs@gmail.com', '7723065844', '$2y$10$aUm.zWoadt.sD/2z8NfTCeUGGUwfSy8seH7ofmtoQ81xauAaM.RPS', 'shivam', NULL, NULL, 'frfre', NULL, NULL, NULL, NULL, 'supervisor', 0, 1, NULL, '2025-09-17 13:15:35', '2025-09-17 13:16:06'),
(10, 'siddharth', 'singh', 'shreyash.toss.cs@gmail.com', '7898140799', '$2y$10$WxVsjnomImnEgZyqMhz9XeI6JB9BTUL02Q2KhqgNNa3OlYa.WssyS', 'siddharth', NULL, NULL, 'jbp', NULL, NULL, NULL, NULL, 'hr', 0, 1, NULL, '2025-09-23 15:10:59', '2025-09-24 11:25:17'),
(11, 'aavi', 'thakur', 'sidhusingh7898thakur@gmail.com', '7898140799', '$2y$10$sN9jAh2LzTWxwcfT1s0NGuRnkAmvempf2LH0keRV54rN13hMC/xHW', 'aaavi', NULL, NULL, 'dsffsd', NULL, NULL, NULL, NULL, 'sales', 0, 0, NULL, '2025-09-24 11:27:41', '2025-09-24 15:31:43'),
(12, 'Krishna', 'Vishwakarma', 'Toss125training@gmail.com', '7723065844', '$2y$10$ImdXHAGbRAbMY8GGOP3xE.zfwXSJYusqVUZeGkIaOVljqqaNX2Aq2', 'krishnaToss', NULL, NULL, '', NULL, NULL, NULL, NULL, 'hr', 0, 1, '2025-09-26 11:40:00', '2025-09-26 11:39:03', '2025-09-26 11:40:00');

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
(1, 1, 1250.00, 5950.00, 4700.00, '2025-08-01 04:30:00', '2025-10-04 11:50:29');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `accident_photos`
--
ALTER TABLE `accident_photos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

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
-- AUTO_INCREMENT for table `client_family_members`
--
ALTER TABLE `client_family_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `client_logins`
--
ALTER TABLE `client_logins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

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
