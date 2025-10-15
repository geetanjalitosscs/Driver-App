-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 15, 2025 at 11:49 AM
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
-- Database: `edueyeco_apatkal2`
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
(9, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-04', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154840, Lng: 79.926024)', 23.15484042, 79.92602427, 'Testing 7', '', '2025-10-04 11:44:15', 'pending', NULL, NULL, NULL, NULL, 0),
(10, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-06', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155037, Lng: 79.925987)', 23.15503750, 79.92598680, 'Full mental patient', '', '2025-10-06 08:37:50', 'pending', NULL, NULL, NULL, NULL, 0),
(11, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155066, Lng: 79.926018)', 23.15506580, 79.92601770, 'No one want to touch it', '', '2025-10-06 08:38:51', 'pending', NULL, NULL, NULL, NULL, 0),
(12, 'Shreyash', '9755833563', 'mp20ch8790', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155106, Lng: 79.926047)', 23.15510620, 79.92604700, 'Bone breaked', '', '2025-10-06 08:54:58', 'pending', NULL, NULL, NULL, NULL, 0),
(13, 'Shreyash', '9755833563', 'mp20ch8790', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155089, Lng: 79.926035)', 23.15508940, 79.92603490, 'Good one', '', '2025-10-06 08:55:22', 'resolved', 'completed', NULL, NULL, '2025-10-15 06:08:43', 1),
(14, 'Shreyash', '9755833563', 'mp20ch8790', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155089, Lng: 79.926035)', 23.15508940, 79.92603490, 'Keeping', '', '2025-10-06 08:55:50', 'pending', NULL, NULL, NULL, NULL, 0),
(15, 'dhaneshwari', '7806062421', 'mp20ch8799', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155072, Lng: 79.926017)', 23.15507170, 79.92601740, 'Headache', '', '2025-10-06 08:56:28', 'pending', NULL, NULL, NULL, NULL, 0),
(16, 'dhaneshwari', '7806062421', 'mp20ch8799', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155072, Lng: 79.926017)', 23.15507170, 79.92601740, 'Breake hand', '', '2025-10-06 08:57:26', 'pending', NULL, NULL, NULL, NULL, 0),
(17, 'mehak', '8959176446', 'mp20ac3800', '2025-10-06', '1724, 1724, Nagpur Rd, near Hotel Gulzar, Madan Mahal, Area, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.155087, Lng: 79.926030)', 23.15508700, 79.92603040, 'testing', '', '2025-10-06 09:28:59', 'pending', NULL, NULL, NULL, NULL, 0),
(19, 'siddharth', '7898140799', 'Mp20ZB6308', '2025-10-07', 'shanti nagar, Mayur Nagar, Musakhedi, Indore, Madhya Pradesh 452001, India (Lat: 22.700200, Lng: 75.907800)', 22.70020000, 75.90780000, 'testing', '', '2025-10-07 09:57:17', 'pending', NULL, NULL, NULL, NULL, 0),
(20, 'Shreyash', '9755833563', 'mp20ch8790', '2025-10-07', 'shanti nagar, Mayur Nagar, Musakhedi, Indore, Madhya Pradesh 452001, India (Lat: 22.700200, Lng: 75.907800)', 22.70020000, 75.90780000, 'tets', '', '2025-10-07 10:12:57', 'pending', NULL, NULL, NULL, NULL, 0),
(21, 'skkk', '8520369741', 'mp20ze3605', '2025-10-07', 'shanti nagar, Mayur Nagar, Musakhedi, Indore, Madhya Pradesh 452001, India (Lat: 22.700200, Lng: 75.907800)', 22.70020000, 75.90780000, 'tessst', '', '2025-10-07 10:14:30', 'pending', NULL, NULL, NULL, NULL, 0),
(23, 'com', '7645144212', 'mp20ze3605', '2025-10-07', 'shanti nagar, Mayur Nagar, Musakhedi, Indore, Madhya Pradesh 452001, India (Lat: 22.700200, Lng: 75.907800)', 22.70020000, 75.90780000, 'ssssss', '', '2025-10-07 11:03:17', 'pending', NULL, NULL, NULL, NULL, 0),
(24, 'Raj', '8959176446', 'mp20ac3893', '2025-10-07', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154824, Lng: 79.926056)', 23.15482381, 79.92605624, 'fdxgfvgh', '', '2025-10-07 11:15:52', 'pending', NULL, NULL, NULL, NULL, 0),
(25, 'Shreyash', '9755833563', 'mp20ch8790', '2025-10-07', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154826, Lng: 79.926055)', 23.15482633, 79.92605475, 'ssss', '', '2025-10-07 11:17:18', 'pending', NULL, NULL, NULL, NULL, 0),
(26, 'Krishna Vishwakarma', '8959176446', 'mp20ab2010', '2025-10-08', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154840, Lng: 79.926044)', 23.15484017, 79.92604424, 'testing 18', '', '2025-10-08 06:45:10', 'pending', NULL, NULL, NULL, NULL, 0),
(27, 'kiran', '7546963214', 'mop546gdr5', '2025-10-08', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154840, Lng: 79.926025)', 23.15484023, 79.92602490, 'Nothing', '', '2025-10-08 11:20:41', 'pending', NULL, NULL, NULL, NULL, 0),
(28, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-08', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154840, Lng: 79.926024)', 23.15484023, 79.92602399, 'Testing Purpose', '', '2025-10-08 11:21:16', 'pending', NULL, NULL, NULL, NULL, 0),
(29, 'Yadav', '', 'Mp20zy8885', '2025-10-08', '5WQV+5WF, Thakkar Gram, Jabalpur, Vehicle Fac. Jabalpur, Madhya Pradesh 482002, India (Lat: 23.187864, Lng: 79.944690)', 23.18786370, 79.94468980, 'Accident ', '', '2025-10-08 20:06:17', 'pending', NULL, NULL, NULL, NULL, 0),
(30, 'Krishna Vishwakarma', '8959176446', 'mp20ab2010', '2025-10-09', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154841, Lng: 79.926022)', 23.15484058, 79.92602221, 'no one here', '', '2025-10-09 04:32:24', 'pending', NULL, NULL, NULL, NULL, 0),
(31, 'Mehika', '7654891355', 'mp20ac3844', '2025-10-09', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154842, Lng: 79.926021)', 23.15484190, 79.92602082, 'Yono bank', '', '2025-10-09 04:34:19', 'pending', NULL, NULL, NULL, NULL, 0),
(32, 'siddharth', '9508570649', 'MP20KJ0005', '2025-10-09', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154842, Lng: 79.926027)', 23.15484178, 79.92602680, 'Testing 1.5', '', '2025-10-09 04:39:52', 'pending', NULL, NULL, NULL, NULL, 0),
(33, 'Komal', '8469571236', 'mp20ac3896', '2025-10-09', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154841, Lng: 79.926023)', 23.15484105, 79.92602271, 'Testing 1.7', '', '2025-10-09 04:41:09', 'pending', NULL, NULL, NULL, NULL, 0),
(34, 'Krishna Vishwakarma', '8959176446', 'mp20ab2010', '2025-10-10', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154841, Lng: 79.926038)', 23.15484074, 79.92603774, 'Damaged', '', '2025-10-10 05:28:03', 'resolved', 'completed', 'Driver: Rajesh Sharma | Vehicle: DL01AB1234', '2025-10-15 06:16:25', '2025-10-15 06:17:22', 1),
(35, 'Krishna Vishwakarma', '8959176446', 'mp20ab2010', '2025-10-11', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154845, Lng: 79.926035)', 23.15484466, 79.92603483, 'Today test', '', '2025-10-11 07:10:48', 'resolved', 'completed', 'Driver: Rajesh Sharma | Vehicle: DL01AB1234', '2025-10-15 06:15:59', '2025-10-15 06:16:11', 1),
(36, 'Dhani', '8459671332', 'mp20ac3890', '2025-10-11', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154844, Lng: 79.926025)', 23.15484408, 79.92602549, 'breaked', '', '2025-10-11 07:13:48', 'pending', NULL, NULL, NULL, NULL, 0);

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
(52, 19, '1759831037_screencapture-localhost-apatkal-2-apatkal-client-dashboard-php-2025-09-25-17_18_47.png'),
(53, 20, '1759831977_screencapture-localhost-apatkal-2-apatkal-apatkal-adminn-accidents-php-2025-09-25-15_49_17.png'),
(54, 21, '1759832070_screencapture-localhost-apatkal-2-apatkal-client-family-php-2025-09-25-17_19_17.png'),
(55, 22, '1759832267_licence_rajash.jpg'),
(56, 23, '1759834997_screencapture-localhost-apatkal-2-apatkal-apatkal-adminn-sales-reports-php-2025-09-25-15_50_12.png'),
(57, 24, '1759835752_5df2c806-dc2b-4a25-bec2-454253e361ad (1).jpeg'),
(58, 25, '1759835838_5df2c806-dc2b-4a25-bec2-454253e361ad (1).jpeg'),
(59, 26, '1759905910_16781488-f740-49fd-94cd-c7f2e2fb0af4.jpeg'),
(60, 27, '1759922441_Arora.jpg'),
(61, 29, '1759953977_17599539450423967749380024610447.jpg'),
(62, 30, '1759984344_Arora.jpg'),
(63, 31, '1759984459_Blue Flower.jpg'),
(64, 34, '1760074083_Flower.jpg'),
(65, 35, '1760166648_Flower.jpg'),
(66, 36, '1760166828_Vally.jpeg');

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

--
-- Dumping data for table `accident_remarks`
--

INSERT INTO `accident_remarks` (`id`, `accident_id`, `user_id`, `user_name`, `user_role`, `remark`, `created_at`, `updated_at`) VALUES
(6, 30, 1, 'Admin ', 'admin', 'done', '2025-10-11 12:21:48', '2025-10-11 12:21:48');

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
(11, 'siddharth', '9508570649', 'siddharth.toss.cs@gmail.com', 'MP20KJ0005', 'four-wheeler', '2025-09-17', NULL, 'hhgdrt', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'unpaid', NULL, '2025-09-17 15:25:38', '2025-09-27 11:59:58'),
(26, 'Krishna Vishwakarma', '8959176446', 'Krishna.vishwakarma@tosssolution.in', 'mp20ab2010', 'four-wheeler', '2025-09-27', NULL, 'Toss solution Jabalpur', NULL, '', '', '', '482001', 1, NULL, NULL, 'unpaid', NULL, '2025-09-27 13:37:09', '2025-09-27 13:37:09'),
(31, 'Shreyash', '9755833563', 'toss125training@gmail.com', 'mp20ch8790', 'two-wheeler', '2025-10-04', '', 'Shastri nagar', '', 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482001', 1, NULL, 'uploads/clients/client_1759819263_68e4b5ff86706.jpeg', 'unpaid', NULL, '2025-10-04 16:26:11', '2025-10-07 12:11:03'),
(32, 'dhaneshwari', '7806062421', 'admin@company.com', 'mp20ch8799', 'two-wheeler', '2025-10-04', '', 'ssd', '', 'Madhya Pradesh', 'Narsinghpur', 'NA', '487118', 1, NULL, 'uploads/clients/client_1759821423_68e4be6f4adcf.jpeg', 'unpaid', NULL, '2025-10-04 16:53:06', '2025-10-07 12:47:03'),
(40, 'Geetanjali', '7694975579', 'geetanjali.tosscs@gmail.com', 'mp20ch8732', 'four-wheeler', '2025-10-06', NULL, 'jabalpur mm', NULL, 'Madhya Pradesh', 'Shahdol', 'Beohari', '484774', 1, NULL, NULL, 'unpaid', NULL, '2025-10-06 13:40:48', '2025-10-06 13:40:48'),
(42, 'sid', '8596871020', 'siddharth.toss.cs@gmail.com', 'MP20PH2285', 'four-wheeler', '2025-10-09', '0255', 'sss', 'sd', 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482001', 13, NULL, NULL, 'paid', 's', '2025-10-09 11:47:00', '2025-10-09 11:47:00'),
(43, 'siddharth', '7898140799', 'siddharth.toss.cs@gmail.com', 'MP20KJ6302', 'two-wheeler', '2025-10-09', NULL, 'adhartal', NULL, 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482001', 1, NULL, NULL, 'unpaid', NULL, '2025-10-09 12:50:20', '2025-10-09 12:50:20'),
(44, 'sid', '9508578649', 'siddharth.toss.cs@gmail.com', 'MP20PH2652', 'three-wheeler', '2025-10-10', '0255', 'ewf', 'sd', 'Madhya Pradesh', 'Jabalpur', 'Jabalpur', '482004', 13, NULL, NULL, 'paid', 'ed', '2025-10-10 17:35:16', '2025-10-10 17:35:16');

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
(23, 40, 'siddharth', '7898140780', 'shreyash.toss.cs@gmail.com', 'brother', NULL, 'rrfff', NULL, 1, 'siish', '2025-10-07 13:03:26', '2025-10-07 13:07:55');

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
(30, 42, '8596871020', '$2y$10$UwVCb81RuDX1GqlUkyl51OGrycgHGpTSecSfR/w01sw8uay5UYbK6', 'active', NULL, '2025-10-09 11:47:00', '2025-10-09 11:47:00'),
(31, 43, '7898140799', '$2y$10$qL7Iden1OXV/LbJqWQIlV.qclW7cVLW9rmHfFctZ1lcGv5zEoWwWK', 'active', NULL, '2025-10-09 12:50:20', '2025-10-09 12:50:20'),
(32, 44, '9508578649', '$2y$10$PNKO5FE.m.4OE9NXtTFexev0m4nF8Oco7iz9dQ/WV2UHiczce.ROi', 'active', NULL, '2025-10-10 17:35:16', '2025-10-10 17:35:16');

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
(7, 'ensurekar', '8952023654', 'krishna.vish9329@gmail.com', 'tttest', 'resolved', '2025-09-29 09:13:59', 'complete'),
(10, 'new', '9876543210', 'toss125training@gmail.com', 'teeeest', 'resolved', '2025-09-29 09:20:35', 'donne'),
(12, 'rgram', '9876543210', 'Toss125training@gmail.com', 'edwatfvxcvz', 'resolved', '2025-09-29 09:28:08', 'doone'),
(14, 'toss', '9876543210', 'toss125training@gmail.com', 'testttting', 'resolved', '2025-09-29 09:42:54', 'reemark');

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
  `kyc_status` enum('pending','approved','rejected') DEFAULT 'pending',
  `account_details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `drivers`
--

INSERT INTO `drivers` (`id`, `driver_name`, `email`, `password`, `number`, `address`, `vehicle_type`, `vehicle_number`, `model_rating`, `aadhar_photo`, `licence_photo`, `rc_photo`, `created_at`, `updated_at`, `kyc_status`, `account_details`) VALUES
(1, 'Rajesh Sharma', 'rajesh.sharma90@gmail.com', '$2y$10$X7jMStqD5ERzpsgYXhu.Mejq1YKUHLbtN9GpWmj/tbrpZSRf9be5i', '9876543210', '123, Gandhi Marg, Sue Delhi', 'Ambulance', 'DL01AB1234', NULL, 'aadhar_rajesh.jpg', 'licence_rajesh.jpg', 'rc_rajesh.jpg', '2025-09-24 05:52:18', '2025-10-14 07:09:27', 'approved', '{\"account_number\":\"12345678907\",\"bank_name\":\"State Bank Of India\",\"ifsc_code\":\"SBIN0001234\",\"account_holder_name\":\"Rajesh Sharma\",\"updated_at\":\"2025-10-14 07:09:27\"}'),
(2, 'Dhaneshwari Patel', 'dhaneshwari17@gmail.com', '$2y$10$FmHuB6iiE1YqLNBb4hRfjOR2WQfFIR7EcOspYG7FJJqItOK0IRu9q', '7945681234', 'beohari mp', 'Ambulance', 'mp20mz4528', NULL, 'Moon.jpg', 'Flower.jpg', 'Blue Flower.jpg', '2025-09-25 04:20:15', '2025-10-08 11:14:15', 'approved', NULL),
(3, 'amit', 'kalmaliindia@gmail.com', '$2y$10$5umnfnk.EgxwjelKFomLLekkdsYdHe6FKGVNkGWILLhim6j1lgvna', '8770658824', 'jabalpur', 'ambulance', 'mp20ja6365', NULL, 'JPEG_20250927_235821_3502812970878090506.jpg', 'JPEG_20250927_235827_7286715491207715510.jpg', 'default_rc.jpg', '2025-09-27 18:28:45', '2025-10-09 05:48:45', 'approved', NULL),
(12, 'komal', 'komal@gmail.com', '$2y$10$.Br01UJJL3ZMi.9uMegVQeHB90Q.KBSK/XiDpotjJzzA1NMmFMn5O', '9643153484', 'katni', 'Ambulance', 'mp89gh5647', NULL, '12_aadhar_1759909111_68e614f7b803b.jpeg', '12_licence_1759909111_68e614f7b8bf0.jpeg', '12_rc_1759909111_68e614f7b966c.jpeg', '2025-10-08 07:38:31', '2025-10-09 05:22:34', 'approved', NULL),
(13, 'siddharth', 'sid@gmail.com', '$2y$10$.DvSwW3Tt2klj9j2vadnCuuZ18sWRXFKJyeLHEMW/WhdvW2iWs6t2', '8956231479', 'adhartal', 'Ambulance', 'mp20cb8765', NULL, '13_aadhar_1759989104_68e74d70cdc33.jpeg', '13_licence_1759989104_68e74d70ce280.jpeg', '13_rc_1759989104_68e74d70ce5fa.jpeg', '2025-10-09 05:51:44', '2025-10-09 05:52:04', 'approved', NULL);

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
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `vehicle_number` varchar(10) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `last_used_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `qr_codes`
--

INSERT INTO `qr_codes` (`id`, `qr_number`, `qr_url`, `created_at`, `vehicle_number`, `full_name`, `phone`, `last_used_at`) VALUES
(133, 1, '/submitaccident.php?qr=1', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(134, 2, '/submitaccident.php?qr=2', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(135, 3, '/submitaccident.php?qr=3', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(136, 4, '/submitaccident.php?qr=4', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(137, 5, '/submitaccident.php?qr=5', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(138, 6, '/submitaccident.php?qr=6', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(139, 7, '/submitaccident.php?qr=7', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(140, 8, '/submitaccident.php?qr=8', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(141, 9, '/submitaccident.php?qr=9', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(142, 10, '/submitaccident.php?qr=10', '2025-10-10 16:22:18', NULL, NULL, NULL, NULL),
(143, 11, '/submitaccident.php?qr=11', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(144, 12, '/submitaccident.php?qr=12', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(145, 13, '/submitaccident.php?qr=13', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(146, 14, '/submitaccident.php?qr=14', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(147, 15, '/submitaccident.php?qr=15', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(148, 16, '/submitaccident.php?qr=16', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(149, 17, '/submitaccident.php?qr=17', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(150, 18, '/submitaccident.php?qr=18', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(151, 19, '/submitaccident.php?qr=19', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(152, 20, '/submitaccident.php?qr=20', '2025-10-10 16:25:40', NULL, NULL, NULL, NULL),
(153, 21, '/submitaccident.php?qr=21', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(154, 22, '/submitaccident.php?qr=22', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(155, 23, '/submitaccident.php?qr=23', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(156, 24, '/submitaccident.php?qr=24', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(157, 25, '/submitaccident.php?qr=25', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(158, 26, '/submitaccident.php?qr=26', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(159, 27, '/submitaccident.php?qr=27', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(160, 28, '/submitaccident.php?qr=28', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(161, 29, '/submitaccident.php?qr=29', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(162, 30, '/submitaccident.php?qr=30', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(163, 31, '/submitaccident.php?qr=31', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(164, 32, '/submitaccident.php?qr=32', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(165, 33, '/submitaccident.php?qr=33', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(166, 34, '/submitaccident.php?qr=34', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(167, 35, '/submitaccident.php?qr=35', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(168, 36, '/submitaccident.php?qr=36', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(169, 37, '/submitaccident.php?qr=37', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(170, 38, '/submitaccident.php?qr=38', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(171, 39, '/submitaccident.php?qr=39', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(172, 40, '/submitaccident.php?qr=40', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(173, 41, '/submitaccident.php?qr=41', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(174, 42, '/submitaccident.php?qr=42', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(175, 43, '/submitaccident.php?qr=43', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(176, 44, '/submitaccident.php?qr=44', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(177, 45, '/submitaccident.php?qr=45', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(178, 46, '/submitaccident.php?qr=46', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(179, 47, '/submitaccident.php?qr=47', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(180, 48, '/submitaccident.php?qr=48', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(181, 49, '/submitaccident.php?qr=49', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(182, 50, '/submitaccident.php?qr=50', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(183, 51, '/submitaccident.php?qr=51', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(184, 52, '/submitaccident.php?qr=52', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(185, 53, '/submitaccident.php?qr=53', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(186, 54, '/submitaccident.php?qr=54', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(187, 55, '/submitaccident.php?qr=55', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(188, 56, '/submitaccident.php?qr=56', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(189, 57, '/submitaccident.php?qr=57', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(190, 58, '/submitaccident.php?qr=58', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(191, 59, '/submitaccident.php?qr=59', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(192, 60, '/submitaccident.php?qr=60', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(193, 61, '/submitaccident.php?qr=61', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(194, 62, '/submitaccident.php?qr=62', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(195, 63, '/submitaccident.php?qr=63', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(196, 64, '/submitaccident.php?qr=64', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(197, 65, '/submitaccident.php?qr=65', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(198, 66, '/submitaccident.php?qr=66', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(199, 67, '/submitaccident.php?qr=67', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(200, 68, '/submitaccident.php?qr=68', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(201, 69, '/submitaccident.php?qr=69', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(202, 70, '/submitaccident.php?qr=70', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(203, 71, '/submitaccident.php?qr=71', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(204, 72, '/submitaccident.php?qr=72', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(205, 73, '/submitaccident.php?qr=73', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(206, 74, '/submitaccident.php?qr=74', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(207, 75, '/submitaccident.php?qr=75', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(208, 76, '/submitaccident.php?qr=76', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(209, 77, '/submitaccident.php?qr=77', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(210, 78, '/submitaccident.php?qr=78', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(211, 79, '/submitaccident.php?qr=79', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(212, 80, '/submitaccident.php?qr=80', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(213, 81, '/submitaccident.php?qr=81', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(214, 82, '/submitaccident.php?qr=82', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(215, 83, '/submitaccident.php?qr=83', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(216, 84, '/submitaccident.php?qr=84', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(217, 85, '/submitaccident.php?qr=85', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(218, 86, '/submitaccident.php?qr=86', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(219, 87, '/submitaccident.php?qr=87', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(220, 88, '/submitaccident.php?qr=88', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(221, 89, '/submitaccident.php?qr=89', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(222, 90, '/submitaccident.php?qr=90', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(223, 91, '/submitaccident.php?qr=91', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(224, 92, '/submitaccident.php?qr=92', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(225, 93, '/submitaccident.php?qr=93', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(226, 94, '/submitaccident.php?qr=94', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(227, 95, '/submitaccident.php?qr=95', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(228, 96, '/submitaccident.php?qr=96', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(229, 97, '/submitaccident.php?qr=97', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(230, 98, '/submitaccident.php?qr=98', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(231, 99, '/submitaccident.php?qr=99', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(232, 100, '/submitaccident.php?qr=100', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(233, 101, '/submitaccident.php?qr=101', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(234, 102, '/submitaccident.php?qr=102', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(235, 103, '/submitaccident.php?qr=103', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(236, 104, '/submitaccident.php?qr=104', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(237, 105, '/submitaccident.php?qr=105', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(238, 106, '/submitaccident.php?qr=106', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(239, 107, '/submitaccident.php?qr=107', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(240, 108, '/submitaccident.php?qr=108', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(241, 109, '/submitaccident.php?qr=109', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(242, 110, '/submitaccident.php?qr=110', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(243, 111, '/submitaccident.php?qr=111', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(244, 112, '/submitaccident.php?qr=112', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(245, 113, '/submitaccident.php?qr=113', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(246, 114, '/submitaccident.php?qr=114', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(247, 115, '/submitaccident.php?qr=115', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(248, 116, '/submitaccident.php?qr=116', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(249, 117, '/submitaccident.php?qr=117', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(250, 118, '/submitaccident.php?qr=118', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(251, 119, '/submitaccident.php?qr=119', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(252, 120, '/submitaccident.php?qr=120', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(253, 121, '/submitaccident.php?qr=121', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(254, 122, '/submitaccident.php?qr=122', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(255, 123, '/submitaccident.php?qr=123', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(256, 124, '/submitaccident.php?qr=124', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(257, 125, '/submitaccident.php?qr=125', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(258, 126, '/submitaccident.php?qr=126', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(259, 127, '/submitaccident.php?qr=127', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(260, 128, '/submitaccident.php?qr=128', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(261, 129, '/submitaccident.php?qr=129', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(262, 130, '/submitaccident.php?qr=130', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(263, 131, '/submitaccident.php?qr=131', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(264, 132, '/submitaccident.php?qr=132', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(265, 133, '/submitaccident.php?qr=133', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(266, 134, '/submitaccident.php?qr=134', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(267, 135, '/submitaccident.php?qr=135', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(268, 136, '/submitaccident.php?qr=136', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(269, 137, '/submitaccident.php?qr=137', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(270, 138, '/submitaccident.php?qr=138', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(271, 139, '/submitaccident.php?qr=139', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(272, 140, '/submitaccident.php?qr=140', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(273, 141, '/submitaccident.php?qr=141', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(274, 142, '/submitaccident.php?qr=142', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(275, 143, '/submitaccident.php?qr=143', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(276, 144, '/submitaccident.php?qr=144', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(277, 145, '/submitaccident.php?qr=145', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(278, 146, '/submitaccident.php?qr=146', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(279, 147, '/submitaccident.php?qr=147', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(280, 148, '/submitaccident.php?qr=148', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(281, 149, '/submitaccident.php?qr=149', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(282, 150, '/submitaccident.php?qr=150', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(283, 151, '/submitaccident.php?qr=151', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(284, 152, '/submitaccident.php?qr=152', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(285, 153, '/submitaccident.php?qr=153', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(286, 154, '/submitaccident.php?qr=154', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(287, 155, '/submitaccident.php?qr=155', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(288, 156, '/submitaccident.php?qr=156', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(289, 157, '/submitaccident.php?qr=157', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(290, 158, '/submitaccident.php?qr=158', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(291, 159, '/submitaccident.php?qr=159', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(292, 160, '/submitaccident.php?qr=160', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(293, 161, '/submitaccident.php?qr=161', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(294, 162, '/submitaccident.php?qr=162', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(295, 163, '/submitaccident.php?qr=163', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(296, 164, '/submitaccident.php?qr=164', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(297, 165, '/submitaccident.php?qr=165', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(298, 166, '/submitaccident.php?qr=166', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(299, 167, '/submitaccident.php?qr=167', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(300, 168, '/submitaccident.php?qr=168', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(301, 169, '/submitaccident.php?qr=169', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(302, 170, '/submitaccident.php?qr=170', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(303, 171, '/submitaccident.php?qr=171', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(304, 172, '/submitaccident.php?qr=172', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(305, 173, '/submitaccident.php?qr=173', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(306, 174, '/submitaccident.php?qr=174', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(307, 175, '/submitaccident.php?qr=175', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(308, 176, '/submitaccident.php?qr=176', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(309, 177, '/submitaccident.php?qr=177', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(310, 178, '/submitaccident.php?qr=178', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(311, 179, '/submitaccident.php?qr=179', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(312, 180, '/submitaccident.php?qr=180', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(313, 181, '/submitaccident.php?qr=181', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(314, 182, '/submitaccident.php?qr=182', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(315, 183, '/submitaccident.php?qr=183', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(316, 184, '/submitaccident.php?qr=184', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(317, 185, '/submitaccident.php?qr=185', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(318, 186, '/submitaccident.php?qr=186', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(319, 187, '/submitaccident.php?qr=187', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(320, 188, '/submitaccident.php?qr=188', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(321, 189, '/submitaccident.php?qr=189', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(322, 190, '/submitaccident.php?qr=190', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(323, 191, '/submitaccident.php?qr=191', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(324, 192, '/submitaccident.php?qr=192', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(325, 193, '/submitaccident.php?qr=193', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(326, 194, '/submitaccident.php?qr=194', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(327, 195, '/submitaccident.php?qr=195', '2025-10-13 10:59:28', NULL, NULL, NULL, NULL),
(328, 196, '/submitaccident.php?qr=196', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(329, 197, '/submitaccident.php?qr=197', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(330, 198, '/submitaccident.php?qr=198', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(331, 199, '/submitaccident.php?qr=199', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(332, 200, '/submitaccident.php?qr=200', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(333, 201, '/submitaccident.php?qr=201', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(334, 202, '/submitaccident.php?qr=202', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(335, 203, '/submitaccident.php?qr=203', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(336, 204, '/submitaccident.php?qr=204', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(337, 205, '/submitaccident.php?qr=205', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(338, 206, '/submitaccident.php?qr=206', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(339, 207, '/submitaccident.php?qr=207', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(340, 208, '/submitaccident.php?qr=208', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(341, 209, '/submitaccident.php?qr=209', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(342, 210, '/submitaccident.php?qr=210', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(343, 211, '/submitaccident.php?qr=211', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(344, 212, '/submitaccident.php?qr=212', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(345, 213, '/submitaccident.php?qr=213', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(346, 214, '/submitaccident.php?qr=214', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(347, 215, '/submitaccident.php?qr=215', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(348, 216, '/submitaccident.php?qr=216', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(349, 217, '/submitaccident.php?qr=217', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(350, 218, '/submitaccident.php?qr=218', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(351, 219, '/submitaccident.php?qr=219', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(352, 220, '/submitaccident.php?qr=220', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(353, 221, '/submitaccident.php?qr=221', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(354, 222, '/submitaccident.php?qr=222', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(355, 223, '/submitaccident.php?qr=223', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(356, 224, '/submitaccident.php?qr=224', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(357, 225, '/submitaccident.php?qr=225', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(358, 226, '/submitaccident.php?qr=226', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(359, 227, '/submitaccident.php?qr=227', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(360, 228, '/submitaccident.php?qr=228', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(361, 229, '/submitaccident.php?qr=229', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(362, 230, '/submitaccident.php?qr=230', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(363, 231, '/submitaccident.php?qr=231', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(364, 232, '/submitaccident.php?qr=232', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(365, 233, '/submitaccident.php?qr=233', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(366, 234, '/submitaccident.php?qr=234', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(367, 235, '/submitaccident.php?qr=235', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(368, 236, '/submitaccident.php?qr=236', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(369, 237, '/submitaccident.php?qr=237', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(370, 238, '/submitaccident.php?qr=238', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(371, 239, '/submitaccident.php?qr=239', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(372, 240, '/submitaccident.php?qr=240', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(373, 241, '/submitaccident.php?qr=241', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(374, 242, '/submitaccident.php?qr=242', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(375, 243, '/submitaccident.php?qr=243', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(376, 244, '/submitaccident.php?qr=244', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(377, 245, '/submitaccident.php?qr=245', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(378, 246, '/submitaccident.php?qr=246', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(379, 247, '/submitaccident.php?qr=247', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(380, 248, '/submitaccident.php?qr=248', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(381, 249, '/submitaccident.php?qr=249', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(382, 250, '/submitaccident.php?qr=250', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(383, 251, '/submitaccident.php?qr=251', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(384, 252, '/submitaccident.php?qr=252', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(385, 253, '/submitaccident.php?qr=253', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(386, 254, '/submitaccident.php?qr=254', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(387, 255, '/submitaccident.php?qr=255', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(388, 256, '/submitaccident.php?qr=256', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(389, 257, '/submitaccident.php?qr=257', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(390, 258, '/submitaccident.php?qr=258', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(391, 259, '/submitaccident.php?qr=259', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(392, 260, '/submitaccident.php?qr=260', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(393, 261, '/submitaccident.php?qr=261', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(394, 262, '/submitaccident.php?qr=262', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(395, 263, '/submitaccident.php?qr=263', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(396, 264, '/submitaccident.php?qr=264', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(397, 265, '/submitaccident.php?qr=265', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(398, 266, '/submitaccident.php?qr=266', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(399, 267, '/submitaccident.php?qr=267', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(400, 268, '/submitaccident.php?qr=268', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(401, 269, '/submitaccident.php?qr=269', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(402, 270, '/submitaccident.php?qr=270', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(403, 271, '/submitaccident.php?qr=271', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(404, 272, '/submitaccident.php?qr=272', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(405, 273, '/submitaccident.php?qr=273', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(406, 274, '/submitaccident.php?qr=274', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(407, 275, '/submitaccident.php?qr=275', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(408, 276, '/submitaccident.php?qr=276', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(409, 277, '/submitaccident.php?qr=277', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(410, 278, '/submitaccident.php?qr=278', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(411, 279, '/submitaccident.php?qr=279', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(412, 280, '/submitaccident.php?qr=280', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(413, 281, '/submitaccident.php?qr=281', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(414, 282, '/submitaccident.php?qr=282', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(415, 283, '/submitaccident.php?qr=283', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(416, 284, '/submitaccident.php?qr=284', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(417, 285, '/submitaccident.php?qr=285', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(418, 286, '/submitaccident.php?qr=286', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(419, 287, '/submitaccident.php?qr=287', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(420, 288, '/submitaccident.php?qr=288', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(421, 289, '/submitaccident.php?qr=289', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(422, 290, '/submitaccident.php?qr=290', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(423, 291, '/submitaccident.php?qr=291', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(424, 292, '/submitaccident.php?qr=292', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(425, 293, '/submitaccident.php?qr=293', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(426, 294, '/submitaccident.php?qr=294', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(427, 295, '/submitaccident.php?qr=295', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(428, 296, '/submitaccident.php?qr=296', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(429, 297, '/submitaccident.php?qr=297', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(430, 298, '/submitaccident.php?qr=298', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(431, 299, '/submitaccident.php?qr=299', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(432, 300, '/submitaccident.php?qr=300', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(433, 301, '/submitaccident.php?qr=301', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(434, 302, '/submitaccident.php?qr=302', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(435, 303, '/submitaccident.php?qr=303', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(436, 304, '/submitaccident.php?qr=304', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(437, 305, '/submitaccident.php?qr=305', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(438, 306, '/submitaccident.php?qr=306', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(439, 307, '/submitaccident.php?qr=307', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(440, 308, '/submitaccident.php?qr=308', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(441, 309, '/submitaccident.php?qr=309', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(442, 310, '/submitaccident.php?qr=310', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(443, 311, '/submitaccident.php?qr=311', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(444, 312, '/submitaccident.php?qr=312', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(445, 313, '/submitaccident.php?qr=313', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(446, 314, '/submitaccident.php?qr=314', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(447, 315, '/submitaccident.php?qr=315', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(448, 316, '/submitaccident.php?qr=316', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(449, 317, '/submitaccident.php?qr=317', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(450, 318, '/submitaccident.php?qr=318', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(451, 319, '/submitaccident.php?qr=319', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(452, 320, '/submitaccident.php?qr=320', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(453, 321, '/submitaccident.php?qr=321', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(454, 322, '/submitaccident.php?qr=322', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(455, 323, '/submitaccident.php?qr=323', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(456, 324, '/submitaccident.php?qr=324', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(457, 325, '/submitaccident.php?qr=325', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(458, 326, '/submitaccident.php?qr=326', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(459, 327, '/submitaccident.php?qr=327', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(460, 328, '/submitaccident.php?qr=328', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(461, 329, '/submitaccident.php?qr=329', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(462, 330, '/submitaccident.php?qr=330', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(463, 331, '/submitaccident.php?qr=331', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(464, 332, '/submitaccident.php?qr=332', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(465, 333, '/submitaccident.php?qr=333', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(466, 334, '/submitaccident.php?qr=334', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(467, 335, '/submitaccident.php?qr=335', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(468, 336, '/submitaccident.php?qr=336', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(469, 337, '/submitaccident.php?qr=337', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(470, 338, '/submitaccident.php?qr=338', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(471, 339, '/submitaccident.php?qr=339', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(472, 340, '/submitaccident.php?qr=340', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(473, 341, '/submitaccident.php?qr=341', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(474, 342, '/submitaccident.php?qr=342', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(475, 343, '/submitaccident.php?qr=343', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(476, 344, '/submitaccident.php?qr=344', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(477, 345, '/submitaccident.php?qr=345', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(478, 346, '/submitaccident.php?qr=346', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(479, 347, '/submitaccident.php?qr=347', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(480, 348, '/submitaccident.php?qr=348', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(481, 349, '/submitaccident.php?qr=349', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(482, 350, '/submitaccident.php?qr=350', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(483, 351, '/submitaccident.php?qr=351', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(484, 352, '/submitaccident.php?qr=352', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(485, 353, '/submitaccident.php?qr=353', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(486, 354, '/submitaccident.php?qr=354', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(487, 355, '/submitaccident.php?qr=355', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(488, 356, '/submitaccident.php?qr=356', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(489, 357, '/submitaccident.php?qr=357', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(490, 358, '/submitaccident.php?qr=358', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(491, 359, '/submitaccident.php?qr=359', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(492, 360, '/submitaccident.php?qr=360', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(493, 361, '/submitaccident.php?qr=361', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(494, 362, '/submitaccident.php?qr=362', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(495, 363, '/submitaccident.php?qr=363', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(496, 364, '/submitaccident.php?qr=364', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(497, 365, '/submitaccident.php?qr=365', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(498, 366, '/submitaccident.php?qr=366', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(499, 367, '/submitaccident.php?qr=367', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(500, 368, '/submitaccident.php?qr=368', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(501, 369, '/submitaccident.php?qr=369', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(502, 370, '/submitaccident.php?qr=370', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(503, 371, '/submitaccident.php?qr=371', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(504, 372, '/submitaccident.php?qr=372', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(505, 373, '/submitaccident.php?qr=373', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(506, 374, '/submitaccident.php?qr=374', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(507, 375, '/submitaccident.php?qr=375', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(508, 376, '/submitaccident.php?qr=376', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(509, 377, '/submitaccident.php?qr=377', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(510, 378, '/submitaccident.php?qr=378', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(511, 379, '/submitaccident.php?qr=379', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(512, 380, '/submitaccident.php?qr=380', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(513, 381, '/submitaccident.php?qr=381', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(514, 382, '/submitaccident.php?qr=382', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(515, 383, '/submitaccident.php?qr=383', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(516, 384, '/submitaccident.php?qr=384', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(517, 385, '/submitaccident.php?qr=385', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(518, 386, '/submitaccident.php?qr=386', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(519, 387, '/submitaccident.php?qr=387', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(520, 388, '/submitaccident.php?qr=388', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(521, 389, '/submitaccident.php?qr=389', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(522, 390, '/submitaccident.php?qr=390', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(523, 391, '/submitaccident.php?qr=391', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(524, 392, '/submitaccident.php?qr=392', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(525, 393, '/submitaccident.php?qr=393', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(526, 394, '/submitaccident.php?qr=394', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(527, 395, '/submitaccident.php?qr=395', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(528, 396, '/submitaccident.php?qr=396', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(529, 397, '/submitaccident.php?qr=397', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(530, 398, '/submitaccident.php?qr=398', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(531, 399, '/submitaccident.php?qr=399', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(532, 400, '/submitaccident.php?qr=400', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(533, 401, '/submitaccident.php?qr=401', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(534, 402, '/submitaccident.php?qr=402', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(535, 403, '/submitaccident.php?qr=403', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(536, 404, '/submitaccident.php?qr=404', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(537, 405, '/submitaccident.php?qr=405', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(538, 406, '/submitaccident.php?qr=406', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(539, 407, '/submitaccident.php?qr=407', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(540, 408, '/submitaccident.php?qr=408', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(541, 409, '/submitaccident.php?qr=409', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(542, 410, '/submitaccident.php?qr=410', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(543, 411, '/submitaccident.php?qr=411', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(544, 412, '/submitaccident.php?qr=412', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(545, 413, '/submitaccident.php?qr=413', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(546, 414, '/submitaccident.php?qr=414', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(547, 415, '/submitaccident.php?qr=415', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(548, 416, '/submitaccident.php?qr=416', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(549, 417, '/submitaccident.php?qr=417', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(550, 418, '/submitaccident.php?qr=418', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(551, 419, '/submitaccident.php?qr=419', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(552, 420, '/submitaccident.php?qr=420', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(553, 421, '/submitaccident.php?qr=421', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(554, 422, '/submitaccident.php?qr=422', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(555, 423, '/submitaccident.php?qr=423', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(556, 424, '/submitaccident.php?qr=424', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(557, 425, '/submitaccident.php?qr=425', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(558, 426, '/submitaccident.php?qr=426', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(559, 427, '/submitaccident.php?qr=427', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(560, 428, '/submitaccident.php?qr=428', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(561, 429, '/submitaccident.php?qr=429', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(562, 430, '/submitaccident.php?qr=430', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(563, 431, '/submitaccident.php?qr=431', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(564, 432, '/submitaccident.php?qr=432', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(565, 433, '/submitaccident.php?qr=433', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(566, 434, '/submitaccident.php?qr=434', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(567, 435, '/submitaccident.php?qr=435', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(568, 436, '/submitaccident.php?qr=436', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(569, 437, '/submitaccident.php?qr=437', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(570, 438, '/submitaccident.php?qr=438', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(571, 439, '/submitaccident.php?qr=439', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(572, 440, '/submitaccident.php?qr=440', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(573, 441, '/submitaccident.php?qr=441', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(574, 442, '/submitaccident.php?qr=442', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(575, 443, '/submitaccident.php?qr=443', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(576, 444, '/submitaccident.php?qr=444', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(577, 445, '/submitaccident.php?qr=445', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(578, 446, '/submitaccident.php?qr=446', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(579, 447, '/submitaccident.php?qr=447', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(580, 448, '/submitaccident.php?qr=448', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(581, 449, '/submitaccident.php?qr=449', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(582, 450, '/submitaccident.php?qr=450', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(583, 451, '/submitaccident.php?qr=451', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(584, 452, '/submitaccident.php?qr=452', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(585, 453, '/submitaccident.php?qr=453', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(586, 454, '/submitaccident.php?qr=454', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(587, 455, '/submitaccident.php?qr=455', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(588, 456, '/submitaccident.php?qr=456', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(589, 457, '/submitaccident.php?qr=457', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(590, 458, '/submitaccident.php?qr=458', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(591, 459, '/submitaccident.php?qr=459', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(592, 460, '/submitaccident.php?qr=460', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(593, 461, '/submitaccident.php?qr=461', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(594, 462, '/submitaccident.php?qr=462', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(595, 463, '/submitaccident.php?qr=463', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(596, 464, '/submitaccident.php?qr=464', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(597, 465, '/submitaccident.php?qr=465', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(598, 466, '/submitaccident.php?qr=466', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(599, 467, '/submitaccident.php?qr=467', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(600, 468, '/submitaccident.php?qr=468', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(601, 469, '/submitaccident.php?qr=469', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(602, 470, '/submitaccident.php?qr=470', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(603, 471, '/submitaccident.php?qr=471', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(604, 472, '/submitaccident.php?qr=472', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(605, 473, '/submitaccident.php?qr=473', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(606, 474, '/submitaccident.php?qr=474', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(607, 475, '/submitaccident.php?qr=475', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(608, 476, '/submitaccident.php?qr=476', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(609, 477, '/submitaccident.php?qr=477', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(610, 478, '/submitaccident.php?qr=478', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(611, 479, '/submitaccident.php?qr=479', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(612, 480, '/submitaccident.php?qr=480', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(613, 481, '/submitaccident.php?qr=481', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(614, 482, '/submitaccident.php?qr=482', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(615, 483, '/submitaccident.php?qr=483', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(616, 484, '/submitaccident.php?qr=484', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(617, 485, '/submitaccident.php?qr=485', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(618, 486, '/submitaccident.php?qr=486', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(619, 487, '/submitaccident.php?qr=487', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(620, 488, '/submitaccident.php?qr=488', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(621, 489, '/submitaccident.php?qr=489', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(622, 490, '/submitaccident.php?qr=490', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(623, 491, '/submitaccident.php?qr=491', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(624, 492, '/submitaccident.php?qr=492', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(625, 493, '/submitaccident.php?qr=493', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(626, 494, '/submitaccident.php?qr=494', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(627, 495, '/submitaccident.php?qr=495', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(628, 496, '/submitaccident.php?qr=496', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(629, 497, '/submitaccident.php?qr=497', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(630, 498, '/submitaccident.php?qr=498', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(631, 499, '/submitaccident.php?qr=499', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(632, 500, '/submitaccident.php?qr=500', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(633, 501, '/submitaccident.php?qr=501', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(634, 502, '/submitaccident.php?qr=502', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(635, 503, '/submitaccident.php?qr=503', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(636, 504, '/submitaccident.php?qr=504', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(637, 505, '/submitaccident.php?qr=505', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(638, 506, '/submitaccident.php?qr=506', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(639, 507, '/submitaccident.php?qr=507', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(640, 508, '/submitaccident.php?qr=508', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(641, 509, '/submitaccident.php?qr=509', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(642, 510, '/submitaccident.php?qr=510', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(643, 511, '/submitaccident.php?qr=511', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(644, 512, '/submitaccident.php?qr=512', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(645, 513, '/submitaccident.php?qr=513', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(646, 514, '/submitaccident.php?qr=514', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(647, 515, '/submitaccident.php?qr=515', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(648, 516, '/submitaccident.php?qr=516', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(649, 517, '/submitaccident.php?qr=517', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(650, 518, '/submitaccident.php?qr=518', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(651, 519, '/submitaccident.php?qr=519', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(652, 520, '/submitaccident.php?qr=520', '2025-10-13 10:59:29', NULL, NULL, NULL, NULL),
(653, 521, '/submitaccident.php?qr=521', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(654, 522, '/submitaccident.php?qr=522', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(655, 523, '/submitaccident.php?qr=523', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(656, 524, '/submitaccident.php?qr=524', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(657, 525, '/submitaccident.php?qr=525', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(658, 526, '/submitaccident.php?qr=526', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(659, 527, '/submitaccident.php?qr=527', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(660, 528, '/submitaccident.php?qr=528', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(661, 529, '/submitaccident.php?qr=529', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(662, 530, '/submitaccident.php?qr=530', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(663, 531, '/submitaccident.php?qr=531', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(664, 532, '/submitaccident.php?qr=532', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(665, 533, '/submitaccident.php?qr=533', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(666, 534, '/submitaccident.php?qr=534', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(667, 535, '/submitaccident.php?qr=535', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(668, 536, '/submitaccident.php?qr=536', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(669, 537, '/submitaccident.php?qr=537', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(670, 538, '/submitaccident.php?qr=538', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(671, 539, '/submitaccident.php?qr=539', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(672, 540, '/submitaccident.php?qr=540', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(673, 541, '/submitaccident.php?qr=541', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(674, 542, '/submitaccident.php?qr=542', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(675, 543, '/submitaccident.php?qr=543', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(676, 544, '/submitaccident.php?qr=544', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(677, 545, '/submitaccident.php?qr=545', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(678, 546, '/submitaccident.php?qr=546', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(679, 547, '/submitaccident.php?qr=547', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(680, 548, '/submitaccident.php?qr=548', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(681, 549, '/submitaccident.php?qr=549', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(682, 550, '/submitaccident.php?qr=550', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(683, 551, '/submitaccident.php?qr=551', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(684, 552, '/submitaccident.php?qr=552', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(685, 553, '/submitaccident.php?qr=553', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(686, 554, '/submitaccident.php?qr=554', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(687, 555, '/submitaccident.php?qr=555', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(688, 556, '/submitaccident.php?qr=556', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(689, 557, '/submitaccident.php?qr=557', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(690, 558, '/submitaccident.php?qr=558', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(691, 559, '/submitaccident.php?qr=559', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(692, 560, '/submitaccident.php?qr=560', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(693, 561, '/submitaccident.php?qr=561', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(694, 562, '/submitaccident.php?qr=562', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(695, 563, '/submitaccident.php?qr=563', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(696, 564, '/submitaccident.php?qr=564', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(697, 565, '/submitaccident.php?qr=565', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(698, 566, '/submitaccident.php?qr=566', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(699, 567, '/submitaccident.php?qr=567', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(700, 568, '/submitaccident.php?qr=568', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(701, 569, '/submitaccident.php?qr=569', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(702, 570, '/submitaccident.php?qr=570', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(703, 571, '/submitaccident.php?qr=571', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(704, 572, '/submitaccident.php?qr=572', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(705, 573, '/submitaccident.php?qr=573', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(706, 574, '/submitaccident.php?qr=574', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(707, 575, '/submitaccident.php?qr=575', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL);
INSERT INTO `qr_codes` (`id`, `qr_number`, `qr_url`, `created_at`, `vehicle_number`, `full_name`, `phone`, `last_used_at`) VALUES
(708, 576, '/submitaccident.php?qr=576', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(709, 577, '/submitaccident.php?qr=577', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(710, 578, '/submitaccident.php?qr=578', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(711, 579, '/submitaccident.php?qr=579', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(712, 580, '/submitaccident.php?qr=580', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(713, 581, '/submitaccident.php?qr=581', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(714, 582, '/submitaccident.php?qr=582', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(715, 583, '/submitaccident.php?qr=583', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(716, 584, '/submitaccident.php?qr=584', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(717, 585, '/submitaccident.php?qr=585', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(718, 586, '/submitaccident.php?qr=586', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(719, 587, '/submitaccident.php?qr=587', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(720, 588, '/submitaccident.php?qr=588', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(721, 589, '/submitaccident.php?qr=589', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(722, 590, '/submitaccident.php?qr=590', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(723, 591, '/submitaccident.php?qr=591', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(724, 592, '/submitaccident.php?qr=592', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(725, 593, '/submitaccident.php?qr=593', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(726, 594, '/submitaccident.php?qr=594', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(727, 595, '/submitaccident.php?qr=595', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(728, 596, '/submitaccident.php?qr=596', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(729, 597, '/submitaccident.php?qr=597', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(730, 598, '/submitaccident.php?qr=598', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(731, 599, '/submitaccident.php?qr=599', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(732, 600, '/submitaccident.php?qr=600', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(733, 601, '/submitaccident.php?qr=601', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(734, 602, '/submitaccident.php?qr=602', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(735, 603, '/submitaccident.php?qr=603', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(736, 604, '/submitaccident.php?qr=604', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(737, 605, '/submitaccident.php?qr=605', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(738, 606, '/submitaccident.php?qr=606', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(739, 607, '/submitaccident.php?qr=607', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(740, 608, '/submitaccident.php?qr=608', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(741, 609, '/submitaccident.php?qr=609', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(742, 610, '/submitaccident.php?qr=610', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(743, 611, '/submitaccident.php?qr=611', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(744, 612, '/submitaccident.php?qr=612', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(745, 613, '/submitaccident.php?qr=613', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(746, 614, '/submitaccident.php?qr=614', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(747, 615, '/submitaccident.php?qr=615', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(748, 616, '/submitaccident.php?qr=616', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(749, 617, '/submitaccident.php?qr=617', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(750, 618, '/submitaccident.php?qr=618', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(751, 619, '/submitaccident.php?qr=619', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(752, 620, '/submitaccident.php?qr=620', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(753, 621, '/submitaccident.php?qr=621', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(754, 622, '/submitaccident.php?qr=622', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(755, 623, '/submitaccident.php?qr=623', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(756, 624, '/submitaccident.php?qr=624', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(757, 625, '/submitaccident.php?qr=625', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(758, 626, '/submitaccident.php?qr=626', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(759, 627, '/submitaccident.php?qr=627', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(760, 628, '/submitaccident.php?qr=628', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(761, 629, '/submitaccident.php?qr=629', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(762, 630, '/submitaccident.php?qr=630', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(763, 631, '/submitaccident.php?qr=631', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(764, 632, '/submitaccident.php?qr=632', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(765, 633, '/submitaccident.php?qr=633', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(766, 634, '/submitaccident.php?qr=634', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(767, 635, '/submitaccident.php?qr=635', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(768, 636, '/submitaccident.php?qr=636', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(769, 637, '/submitaccident.php?qr=637', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(770, 638, '/submitaccident.php?qr=638', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(771, 639, '/submitaccident.php?qr=639', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(772, 640, '/submitaccident.php?qr=640', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(773, 641, '/submitaccident.php?qr=641', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(774, 642, '/submitaccident.php?qr=642', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(775, 643, '/submitaccident.php?qr=643', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(776, 644, '/submitaccident.php?qr=644', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(777, 645, '/submitaccident.php?qr=645', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(778, 646, '/submitaccident.php?qr=646', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(779, 647, '/submitaccident.php?qr=647', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(780, 648, '/submitaccident.php?qr=648', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(781, 649, '/submitaccident.php?qr=649', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(782, 650, '/submitaccident.php?qr=650', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(783, 651, '/submitaccident.php?qr=651', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(784, 652, '/submitaccident.php?qr=652', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(785, 653, '/submitaccident.php?qr=653', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(786, 654, '/submitaccident.php?qr=654', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(787, 655, '/submitaccident.php?qr=655', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(788, 656, '/submitaccident.php?qr=656', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(789, 657, '/submitaccident.php?qr=657', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(790, 658, '/submitaccident.php?qr=658', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(791, 659, '/submitaccident.php?qr=659', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(792, 660, '/submitaccident.php?qr=660', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(793, 661, '/submitaccident.php?qr=661', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(794, 662, '/submitaccident.php?qr=662', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(795, 663, '/submitaccident.php?qr=663', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(796, 664, '/submitaccident.php?qr=664', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(797, 665, '/submitaccident.php?qr=665', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(798, 666, '/submitaccident.php?qr=666', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(799, 667, '/submitaccident.php?qr=667', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(800, 668, '/submitaccident.php?qr=668', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(801, 669, '/submitaccident.php?qr=669', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(802, 670, '/submitaccident.php?qr=670', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(803, 671, '/submitaccident.php?qr=671', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(804, 672, '/submitaccident.php?qr=672', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(805, 673, '/submitaccident.php?qr=673', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(806, 674, '/submitaccident.php?qr=674', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(807, 675, '/submitaccident.php?qr=675', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(808, 676, '/submitaccident.php?qr=676', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(809, 677, '/submitaccident.php?qr=677', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(810, 678, '/submitaccident.php?qr=678', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(811, 679, '/submitaccident.php?qr=679', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(812, 680, '/submitaccident.php?qr=680', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(813, 681, '/submitaccident.php?qr=681', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(814, 682, '/submitaccident.php?qr=682', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(815, 683, '/submitaccident.php?qr=683', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(816, 684, '/submitaccident.php?qr=684', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(817, 685, '/submitaccident.php?qr=685', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(818, 686, '/submitaccident.php?qr=686', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(819, 687, '/submitaccident.php?qr=687', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(820, 688, '/submitaccident.php?qr=688', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(821, 689, '/submitaccident.php?qr=689', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(822, 690, '/submitaccident.php?qr=690', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(823, 691, '/submitaccident.php?qr=691', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(824, 692, '/submitaccident.php?qr=692', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(825, 693, '/submitaccident.php?qr=693', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(826, 694, '/submitaccident.php?qr=694', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(827, 695, '/submitaccident.php?qr=695', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(828, 696, '/submitaccident.php?qr=696', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(829, 697, '/submitaccident.php?qr=697', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(830, 698, '/submitaccident.php?qr=698', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(831, 699, '/submitaccident.php?qr=699', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(832, 700, '/submitaccident.php?qr=700', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(833, 701, '/submitaccident.php?qr=701', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(834, 702, '/submitaccident.php?qr=702', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(835, 703, '/submitaccident.php?qr=703', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(836, 704, '/submitaccident.php?qr=704', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(837, 705, '/submitaccident.php?qr=705', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(838, 706, '/submitaccident.php?qr=706', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(839, 707, '/submitaccident.php?qr=707', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(840, 708, '/submitaccident.php?qr=708', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(841, 709, '/submitaccident.php?qr=709', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(842, 710, '/submitaccident.php?qr=710', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(843, 711, '/submitaccident.php?qr=711', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(844, 712, '/submitaccident.php?qr=712', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(845, 713, '/submitaccident.php?qr=713', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(846, 714, '/submitaccident.php?qr=714', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(847, 715, '/submitaccident.php?qr=715', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(848, 716, '/submitaccident.php?qr=716', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(849, 717, '/submitaccident.php?qr=717', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(850, 718, '/submitaccident.php?qr=718', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(851, 719, '/submitaccident.php?qr=719', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(852, 720, '/submitaccident.php?qr=720', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(853, 721, '/submitaccident.php?qr=721', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(854, 722, '/submitaccident.php?qr=722', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(855, 723, '/submitaccident.php?qr=723', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(856, 724, '/submitaccident.php?qr=724', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(857, 725, '/submitaccident.php?qr=725', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(858, 726, '/submitaccident.php?qr=726', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(859, 727, '/submitaccident.php?qr=727', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(860, 728, '/submitaccident.php?qr=728', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(861, 729, '/submitaccident.php?qr=729', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(862, 730, '/submitaccident.php?qr=730', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(863, 731, '/submitaccident.php?qr=731', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(864, 732, '/submitaccident.php?qr=732', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(865, 733, '/submitaccident.php?qr=733', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(866, 734, '/submitaccident.php?qr=734', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(867, 735, '/submitaccident.php?qr=735', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(868, 736, '/submitaccident.php?qr=736', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(869, 737, '/submitaccident.php?qr=737', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(870, 738, '/submitaccident.php?qr=738', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(871, 739, '/submitaccident.php?qr=739', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(872, 740, '/submitaccident.php?qr=740', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(873, 741, '/submitaccident.php?qr=741', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(874, 742, '/submitaccident.php?qr=742', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(875, 743, '/submitaccident.php?qr=743', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(876, 744, '/submitaccident.php?qr=744', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(877, 745, '/submitaccident.php?qr=745', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(878, 746, '/submitaccident.php?qr=746', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(879, 747, '/submitaccident.php?qr=747', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(880, 748, '/submitaccident.php?qr=748', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(881, 749, '/submitaccident.php?qr=749', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(882, 750, '/submitaccident.php?qr=750', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(883, 751, '/submitaccident.php?qr=751', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(884, 752, '/submitaccident.php?qr=752', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(885, 753, '/submitaccident.php?qr=753', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(886, 754, '/submitaccident.php?qr=754', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(887, 755, '/submitaccident.php?qr=755', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(888, 756, '/submitaccident.php?qr=756', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(889, 757, '/submitaccident.php?qr=757', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(890, 758, '/submitaccident.php?qr=758', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(891, 759, '/submitaccident.php?qr=759', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(892, 760, '/submitaccident.php?qr=760', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(893, 761, '/submitaccident.php?qr=761', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(894, 762, '/submitaccident.php?qr=762', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(895, 763, '/submitaccident.php?qr=763', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(896, 764, '/submitaccident.php?qr=764', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(897, 765, '/submitaccident.php?qr=765', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(898, 766, '/submitaccident.php?qr=766', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(899, 767, '/submitaccident.php?qr=767', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(900, 768, '/submitaccident.php?qr=768', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(901, 769, '/submitaccident.php?qr=769', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(902, 770, '/submitaccident.php?qr=770', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(903, 771, '/submitaccident.php?qr=771', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(904, 772, '/submitaccident.php?qr=772', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(905, 773, '/submitaccident.php?qr=773', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(906, 774, '/submitaccident.php?qr=774', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(907, 775, '/submitaccident.php?qr=775', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(908, 776, '/submitaccident.php?qr=776', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(909, 777, '/submitaccident.php?qr=777', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(910, 778, '/submitaccident.php?qr=778', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(911, 779, '/submitaccident.php?qr=779', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(912, 780, '/submitaccident.php?qr=780', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(913, 781, '/submitaccident.php?qr=781', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(914, 782, '/submitaccident.php?qr=782', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(915, 783, '/submitaccident.php?qr=783', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(916, 784, '/submitaccident.php?qr=784', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(917, 785, '/submitaccident.php?qr=785', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(918, 786, '/submitaccident.php?qr=786', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(919, 787, '/submitaccident.php?qr=787', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(920, 788, '/submitaccident.php?qr=788', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(921, 789, '/submitaccident.php?qr=789', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(922, 790, '/submitaccident.php?qr=790', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(923, 791, '/submitaccident.php?qr=791', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(924, 792, '/submitaccident.php?qr=792', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(925, 793, '/submitaccident.php?qr=793', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(926, 794, '/submitaccident.php?qr=794', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(927, 795, '/submitaccident.php?qr=795', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(928, 796, '/submitaccident.php?qr=796', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(929, 797, '/submitaccident.php?qr=797', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(930, 798, '/submitaccident.php?qr=798', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(931, 799, '/submitaccident.php?qr=799', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(932, 800, '/submitaccident.php?qr=800', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(933, 801, '/submitaccident.php?qr=801', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(934, 802, '/submitaccident.php?qr=802', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(935, 803, '/submitaccident.php?qr=803', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(936, 804, '/submitaccident.php?qr=804', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(937, 805, '/submitaccident.php?qr=805', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(938, 806, '/submitaccident.php?qr=806', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(939, 807, '/submitaccident.php?qr=807', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(940, 808, '/submitaccident.php?qr=808', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(941, 809, '/submitaccident.php?qr=809', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(942, 810, '/submitaccident.php?qr=810', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(943, 811, '/submitaccident.php?qr=811', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(944, 812, '/submitaccident.php?qr=812', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(945, 813, '/submitaccident.php?qr=813', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(946, 814, '/submitaccident.php?qr=814', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(947, 815, '/submitaccident.php?qr=815', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(948, 816, '/submitaccident.php?qr=816', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(949, 817, '/submitaccident.php?qr=817', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(950, 818, '/submitaccident.php?qr=818', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(951, 819, '/submitaccident.php?qr=819', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(952, 820, '/submitaccident.php?qr=820', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(953, 821, '/submitaccident.php?qr=821', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(954, 822, '/submitaccident.php?qr=822', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(955, 823, '/submitaccident.php?qr=823', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(956, 824, '/submitaccident.php?qr=824', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(957, 825, '/submitaccident.php?qr=825', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(958, 826, '/submitaccident.php?qr=826', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(959, 827, '/submitaccident.php?qr=827', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(960, 828, '/submitaccident.php?qr=828', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(961, 829, '/submitaccident.php?qr=829', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(962, 830, '/submitaccident.php?qr=830', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(963, 831, '/submitaccident.php?qr=831', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(964, 832, '/submitaccident.php?qr=832', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(965, 833, '/submitaccident.php?qr=833', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(966, 834, '/submitaccident.php?qr=834', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(967, 835, '/submitaccident.php?qr=835', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(968, 836, '/submitaccident.php?qr=836', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(969, 837, '/submitaccident.php?qr=837', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(970, 838, '/submitaccident.php?qr=838', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(971, 839, '/submitaccident.php?qr=839', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(972, 840, '/submitaccident.php?qr=840', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(973, 841, '/submitaccident.php?qr=841', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(974, 842, '/submitaccident.php?qr=842', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(975, 843, '/submitaccident.php?qr=843', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(976, 844, '/submitaccident.php?qr=844', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(977, 845, '/submitaccident.php?qr=845', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(978, 846, '/submitaccident.php?qr=846', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(979, 847, '/submitaccident.php?qr=847', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(980, 848, '/submitaccident.php?qr=848', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(981, 849, '/submitaccident.php?qr=849', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(982, 850, '/submitaccident.php?qr=850', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(983, 851, '/submitaccident.php?qr=851', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(984, 852, '/submitaccident.php?qr=852', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(985, 853, '/submitaccident.php?qr=853', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(986, 854, '/submitaccident.php?qr=854', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(987, 855, '/submitaccident.php?qr=855', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(988, 856, '/submitaccident.php?qr=856', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(989, 857, '/submitaccident.php?qr=857', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(990, 858, '/submitaccident.php?qr=858', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(991, 859, '/submitaccident.php?qr=859', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(992, 860, '/submitaccident.php?qr=860', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(993, 861, '/submitaccident.php?qr=861', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(994, 862, '/submitaccident.php?qr=862', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(995, 863, '/submitaccident.php?qr=863', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(996, 864, '/submitaccident.php?qr=864', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(997, 865, '/submitaccident.php?qr=865', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(998, 866, '/submitaccident.php?qr=866', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(999, 867, '/submitaccident.php?qr=867', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1000, 868, '/submitaccident.php?qr=868', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1001, 869, '/submitaccident.php?qr=869', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1002, 870, '/submitaccident.php?qr=870', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1003, 871, '/submitaccident.php?qr=871', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1004, 872, '/submitaccident.php?qr=872', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1005, 873, '/submitaccident.php?qr=873', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1006, 874, '/submitaccident.php?qr=874', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1007, 875, '/submitaccident.php?qr=875', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1008, 876, '/submitaccident.php?qr=876', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1009, 877, '/submitaccident.php?qr=877', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1010, 878, '/submitaccident.php?qr=878', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1011, 879, '/submitaccident.php?qr=879', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1012, 880, '/submitaccident.php?qr=880', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1013, 881, '/submitaccident.php?qr=881', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1014, 882, '/submitaccident.php?qr=882', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1015, 883, '/submitaccident.php?qr=883', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1016, 884, '/submitaccident.php?qr=884', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1017, 885, '/submitaccident.php?qr=885', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1018, 886, '/submitaccident.php?qr=886', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1019, 887, '/submitaccident.php?qr=887', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1020, 888, '/submitaccident.php?qr=888', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1021, 889, '/submitaccident.php?qr=889', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1022, 890, '/submitaccident.php?qr=890', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1023, 891, '/submitaccident.php?qr=891', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1024, 892, '/submitaccident.php?qr=892', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1025, 893, '/submitaccident.php?qr=893', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1026, 894, '/submitaccident.php?qr=894', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1027, 895, '/submitaccident.php?qr=895', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1028, 896, '/submitaccident.php?qr=896', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1029, 897, '/submitaccident.php?qr=897', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1030, 898, '/submitaccident.php?qr=898', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1031, 899, '/submitaccident.php?qr=899', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1032, 900, '/submitaccident.php?qr=900', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1033, 901, '/submitaccident.php?qr=901', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1034, 902, '/submitaccident.php?qr=902', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1035, 903, '/submitaccident.php?qr=903', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1036, 904, '/submitaccident.php?qr=904', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1037, 905, '/submitaccident.php?qr=905', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1038, 906, '/submitaccident.php?qr=906', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1039, 907, '/submitaccident.php?qr=907', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1040, 908, '/submitaccident.php?qr=908', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1041, 909, '/submitaccident.php?qr=909', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1042, 910, '/submitaccident.php?qr=910', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1043, 911, '/submitaccident.php?qr=911', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1044, 912, '/submitaccident.php?qr=912', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1045, 913, '/submitaccident.php?qr=913', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1046, 914, '/submitaccident.php?qr=914', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1047, 915, '/submitaccident.php?qr=915', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1048, 916, '/submitaccident.php?qr=916', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1049, 917, '/submitaccident.php?qr=917', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1050, 918, '/submitaccident.php?qr=918', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1051, 919, '/submitaccident.php?qr=919', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1052, 920, '/submitaccident.php?qr=920', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1053, 921, '/submitaccident.php?qr=921', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1054, 922, '/submitaccident.php?qr=922', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1055, 923, '/submitaccident.php?qr=923', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1056, 924, '/submitaccident.php?qr=924', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1057, 925, '/submitaccident.php?qr=925', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1058, 926, '/submitaccident.php?qr=926', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1059, 927, '/submitaccident.php?qr=927', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1060, 928, '/submitaccident.php?qr=928', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1061, 929, '/submitaccident.php?qr=929', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1062, 930, '/submitaccident.php?qr=930', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1063, 931, '/submitaccident.php?qr=931', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1064, 932, '/submitaccident.php?qr=932', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1065, 933, '/submitaccident.php?qr=933', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1066, 934, '/submitaccident.php?qr=934', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1067, 935, '/submitaccident.php?qr=935', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1068, 936, '/submitaccident.php?qr=936', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1069, 937, '/submitaccident.php?qr=937', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1070, 938, '/submitaccident.php?qr=938', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1071, 939, '/submitaccident.php?qr=939', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1072, 940, '/submitaccident.php?qr=940', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1073, 941, '/submitaccident.php?qr=941', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1074, 942, '/submitaccident.php?qr=942', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1075, 943, '/submitaccident.php?qr=943', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1076, 944, '/submitaccident.php?qr=944', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1077, 945, '/submitaccident.php?qr=945', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1078, 946, '/submitaccident.php?qr=946', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1079, 947, '/submitaccident.php?qr=947', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1080, 948, '/submitaccident.php?qr=948', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1081, 949, '/submitaccident.php?qr=949', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1082, 950, '/submitaccident.php?qr=950', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1083, 951, '/submitaccident.php?qr=951', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1084, 952, '/submitaccident.php?qr=952', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1085, 953, '/submitaccident.php?qr=953', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1086, 954, '/submitaccident.php?qr=954', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1087, 955, '/submitaccident.php?qr=955', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1088, 956, '/submitaccident.php?qr=956', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1089, 957, '/submitaccident.php?qr=957', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1090, 958, '/submitaccident.php?qr=958', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1091, 959, '/submitaccident.php?qr=959', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1092, 960, '/submitaccident.php?qr=960', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1093, 961, '/submitaccident.php?qr=961', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1094, 962, '/submitaccident.php?qr=962', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1095, 963, '/submitaccident.php?qr=963', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1096, 964, '/submitaccident.php?qr=964', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1097, 965, '/submitaccident.php?qr=965', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1098, 966, '/submitaccident.php?qr=966', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1099, 967, '/submitaccident.php?qr=967', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1100, 968, '/submitaccident.php?qr=968', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1101, 969, '/submitaccident.php?qr=969', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1102, 970, '/submitaccident.php?qr=970', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1103, 971, '/submitaccident.php?qr=971', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1104, 972, '/submitaccident.php?qr=972', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1105, 973, '/submitaccident.php?qr=973', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1106, 974, '/submitaccident.php?qr=974', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1107, 975, '/submitaccident.php?qr=975', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1108, 976, '/submitaccident.php?qr=976', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1109, 977, '/submitaccident.php?qr=977', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1110, 978, '/submitaccident.php?qr=978', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1111, 979, '/submitaccident.php?qr=979', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1112, 980, '/submitaccident.php?qr=980', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1113, 981, '/submitaccident.php?qr=981', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1114, 982, '/submitaccident.php?qr=982', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1115, 983, '/submitaccident.php?qr=983', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1116, 984, '/submitaccident.php?qr=984', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1117, 985, '/submitaccident.php?qr=985', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1118, 986, '/submitaccident.php?qr=986', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1119, 987, '/submitaccident.php?qr=987', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1120, 988, '/submitaccident.php?qr=988', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1121, 989, '/submitaccident.php?qr=989', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1122, 990, '/submitaccident.php?qr=990', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1123, 991, '/submitaccident.php?qr=991', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1124, 992, '/submitaccident.php?qr=992', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1125, 993, '/submitaccident.php?qr=993', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1126, 994, '/submitaccident.php?qr=994', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1127, 995, '/submitaccident.php?qr=995', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1128, 996, '/submitaccident.php?qr=996', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1129, 997, '/submitaccident.php?qr=997', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1130, 998, '/submitaccident.php?qr=998', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1131, 999, '/submitaccident.php?qr=999', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1132, 1000, '/submitaccident.php?qr=1000', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1133, 1001, '/submitaccident.php?qr=1001', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1134, 1002, '/submitaccident.php?qr=1002', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1135, 1003, '/submitaccident.php?qr=1003', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1136, 1004, '/submitaccident.php?qr=1004', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1137, 1005, '/submitaccident.php?qr=1005', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1138, 1006, '/submitaccident.php?qr=1006', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1139, 1007, '/submitaccident.php?qr=1007', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1140, 1008, '/submitaccident.php?qr=1008', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1141, 1009, '/submitaccident.php?qr=1009', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1142, 1010, '/submitaccident.php?qr=1010', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1143, 1011, '/submitaccident.php?qr=1011', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1144, 1012, '/submitaccident.php?qr=1012', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1145, 1013, '/submitaccident.php?qr=1013', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1146, 1014, '/submitaccident.php?qr=1014', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1147, 1015, '/submitaccident.php?qr=1015', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1148, 1016, '/submitaccident.php?qr=1016', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1149, 1017, '/submitaccident.php?qr=1017', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1150, 1018, '/submitaccident.php?qr=1018', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1151, 1019, '/submitaccident.php?qr=1019', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1152, 1020, '/submitaccident.php?qr=1020', '2025-10-13 10:59:58', NULL, NULL, NULL, NULL),
(1153, 1021, '/submitaccident.php?qr=1021', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1154, 1022, '/submitaccident.php?qr=1022', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1155, 1023, '/submitaccident.php?qr=1023', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1156, 1024, '/submitaccident.php?qr=1024', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1157, 1025, '/submitaccident.php?qr=1025', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1158, 1026, '/submitaccident.php?qr=1026', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1159, 1027, '/submitaccident.php?qr=1027', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1160, 1028, '/submitaccident.php?qr=1028', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1161, 1029, '/submitaccident.php?qr=1029', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1162, 1030, '/submitaccident.php?qr=1030', '2025-10-13 11:17:38', NULL, NULL, NULL, NULL),
(1163, 1031, '/submitaccident.php?qr=1031', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1164, 1032, '/submitaccident.php?qr=1032', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1165, 1033, '/submitaccident.php?qr=1033', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1166, 1034, '/submitaccident.php?qr=1034', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1167, 1035, '/submitaccident.php?qr=1035', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1168, 1036, '/submitaccident.php?qr=1036', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1169, 1037, '/submitaccident.php?qr=1037', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1170, 1038, '/submitaccident.php?qr=1038', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1171, 1039, '/submitaccident.php?qr=1039', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1172, 1040, '/submitaccident.php?qr=1040', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1173, 1041, '/submitaccident.php?qr=1041', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1174, 1042, '/submitaccident.php?qr=1042', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1175, 1043, '/submitaccident.php?qr=1043', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1176, 1044, '/submitaccident.php?qr=1044', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1177, 1045, '/submitaccident.php?qr=1045', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1178, 1046, '/submitaccident.php?qr=1046', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1179, 1047, '/submitaccident.php?qr=1047', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1180, 1048, '/submitaccident.php?qr=1048', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1181, 1049, '/submitaccident.php?qr=1049', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1182, 1050, '/submitaccident.php?qr=1050', '2025-10-13 11:25:00', NULL, NULL, NULL, NULL),
(1183, 1051, '/submitaccident.php?qr=1051', '2025-10-13 12:16:30', NULL, NULL, NULL, NULL),
(1184, 1052, '/submitaccident.php?qr=1052', '2025-10-13 12:16:30', 'MP20KJ0005', 'siddharth', '9508570649', '2025-10-13 12:31:25'),
(1185, 1053, '/submitaccident.php?qr=1053', '2025-10-13 12:16:30', NULL, NULL, NULL, NULL),
(1186, 1054, '/submitaccident.php?qr=1054', '2025-10-13 12:16:30', NULL, NULL, NULL, NULL),
(1187, 1055, '/submitaccident.php?qr=1055', '2025-10-13 12:16:30', NULL, NULL, NULL, NULL),
(1188, 1056, '/submitaccident.php?qr=1056', '2025-10-13 12:16:30', NULL, NULL, NULL, NULL),
(1189, 1057, '/submitaccident.php?qr=1057', '2025-10-13 12:16:30', NULL, NULL, NULL, NULL),
(1190, 1058, '/submitaccident.php?qr=1058', '2025-10-13 12:16:30', NULL, NULL, NULL, NULL),
(1191, 1059, '/submitaccident.php?qr=1059', '2025-10-13 12:16:30', NULL, NULL, NULL, NULL),
(1192, 1060, '/submitaccident.php?qr=1060', '2025-10-13 12:16:30', NULL, NULL, NULL, NULL),
(1193, 1061, '/submitaccident.php?qr=1061', '2025-10-13 12:42:12', NULL, NULL, NULL, NULL),
(1194, 1062, '/submitaccident.php?qr=1062', '2025-10-13 12:42:12', NULL, NULL, NULL, NULL),
(1195, 1063, '/submitaccident.php?qr=1063', '2025-10-13 12:42:12', 'mp20ab2010', 'Krishna Vishwakarma', '8959176446', '2025-10-13 12:49:17'),
(1196, 1064, '/submitaccident.php?qr=1064', '2025-10-13 12:42:12', NULL, NULL, NULL, NULL),
(1197, 1065, '/submitaccident.php?qr=1065', '2025-10-13 12:42:12', NULL, NULL, NULL, NULL),
(1198, 1066, '/submitaccident.php?qr=1066', '2025-10-13 12:42:12', NULL, NULL, NULL, NULL),
(1199, 1067, '/submitaccident.php?qr=1067', '2025-10-13 12:42:12', NULL, NULL, NULL, NULL),
(1200, 1068, '/submitaccident.php?qr=1068', '2025-10-13 12:42:12', NULL, NULL, NULL, NULL),
(1201, 1069, '/submitaccident.php?qr=1069', '2025-10-13 12:42:12', NULL, NULL, NULL, NULL),
(1202, 1070, '/submitaccident.php?qr=1070', '2025-10-13 12:42:12', NULL, NULL, NULL, NULL),
(1203, 1071, 'apatkal/submitaccident.php?qr=1071', '2025-10-13 13:01:56', NULL, NULL, NULL, NULL),
(1204, 1072, 'apatkal/submitaccident.php?qr=1072', '2025-10-13 13:01:56', 'mp20ch8790', 'Shreyash', '8523697410', '2025-10-13 13:03:42'),
(1205, 1073, 'apatkal/submitaccident.php?qr=1073', '2025-10-13 13:01:56', NULL, NULL, NULL, NULL),
(1206, 1074, 'apatkal/submitaccident.php?qr=1074', '2025-10-13 13:01:56', NULL, NULL, NULL, NULL),
(1207, 1075, 'apatkal/submitaccident.php?qr=1075', '2025-10-13 13:01:56', NULL, NULL, NULL, NULL),
(1208, 1076, 'apatkal/submitaccident.php?qr=1076', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1209, 1077, 'apatkal/submitaccident.php?qr=1077', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1210, 1078, 'apatkal/submitaccident.php?qr=1078', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1211, 1079, 'apatkal/submitaccident.php?qr=1079', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1212, 1080, 'apatkal/submitaccident.php?qr=1080', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1213, 1081, 'apatkal/submitaccident.php?qr=1081', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1214, 1082, 'apatkal/submitaccident.php?qr=1082', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1215, 1083, 'apatkal/submitaccident.php?qr=1083', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1216, 1084, 'apatkal/submitaccident.php?qr=1084', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1217, 1085, 'apatkal/submitaccident.php?qr=1085', '2025-10-13 13:31:50', NULL, NULL, NULL, NULL),
(1218, 1086, 'apatkal/submitaccident.php?qr=1086', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1219, 1087, 'apatkal/submitaccident.php?qr=1087', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1220, 1088, 'apatkal/submitaccident.php?qr=1088', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1221, 1089, 'apatkal/submitaccident.php?qr=1089', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1222, 1090, 'apatkal/submitaccident.php?qr=1090', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1223, 1091, 'apatkal/submitaccident.php?qr=1091', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1224, 1092, 'apatkal/submitaccident.php?qr=1092', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1225, 1093, 'apatkal/submitaccident.php?qr=1093', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1226, 1094, 'apatkal/submitaccident.php?qr=1094', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1227, 1095, 'apatkal/submitaccident.php?qr=1095', '2025-10-13 13:34:33', NULL, NULL, NULL, NULL),
(1228, 1096, 'apatkal/submitaccident.php?qr=1096', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1229, 1097, 'apatkal/submitaccident.php?qr=1097', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1230, 1098, 'apatkal/submitaccident.php?qr=1098', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1231, 1099, 'apatkal/submitaccident.php?qr=1099', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1232, 1100, 'apatkal/submitaccident.php?qr=1100', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1233, 1101, 'apatkal/submitaccident.php?qr=1101', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1234, 1102, 'apatkal/submitaccident.php?qr=1102', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1235, 1103, 'apatkal/submitaccident.php?qr=1103', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1236, 1104, 'apatkal/submitaccident.php?qr=1104', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1237, 1105, 'apatkal/submitaccident.php?qr=1105', '2025-10-13 13:45:11', NULL, NULL, NULL, NULL),
(1238, 1106, 'apatkal/submitaccident.php?qr=1106', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1239, 1107, 'apatkal/submitaccident.php?qr=1107', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1240, 1108, 'apatkal/submitaccident.php?qr=1108', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1241, 1109, 'apatkal/submitaccident.php?qr=1109', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1242, 1110, 'apatkal/submitaccident.php?qr=1110', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1243, 1111, 'apatkal/submitaccident.php?qr=1111', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1244, 1112, 'apatkal/submitaccident.php?qr=1112', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1245, 1113, 'apatkal/submitaccident.php?qr=1113', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1246, 1114, 'apatkal/submitaccident.php?qr=1114', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1247, 1115, 'apatkal/submitaccident.php?qr=1115', '2025-10-13 13:45:22', NULL, NULL, NULL, NULL),
(1248, 1116, 'apatkal/submitaccident.php?qr=1116', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1249, 1117, 'apatkal/submitaccident.php?qr=1117', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1250, 1118, 'apatkal/submitaccident.php?qr=1118', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1251, 1119, 'apatkal/submitaccident.php?qr=1119', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1252, 1120, 'apatkal/submitaccident.php?qr=1120', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1253, 1121, 'apatkal/submitaccident.php?qr=1121', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1254, 1122, 'apatkal/submitaccident.php?qr=1122', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1255, 1123, 'apatkal/submitaccident.php?qr=1123', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1256, 1124, 'apatkal/submitaccident.php?qr=1124', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1257, 1125, 'apatkal/submitaccident.php?qr=1125', '2025-10-13 13:45:34', NULL, NULL, NULL, NULL),
(1258, 1126, 'apatkal/submitaccident.php?qr=1126', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL),
(1259, 1127, 'apatkal/submitaccident.php?qr=1127', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL),
(1260, 1128, 'apatkal/submitaccident.php?qr=1128', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL),
(1261, 1129, 'apatkal/submitaccident.php?qr=1129', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL),
(1262, 1130, 'apatkal/submitaccident.php?qr=1130', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL),
(1263, 1131, 'apatkal/submitaccident.php?qr=1131', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL),
(1264, 1132, 'apatkal/submitaccident.php?qr=1132', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL),
(1265, 1133, 'apatkal/submitaccident.php?qr=1133', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL),
(1266, 1134, 'apatkal/submitaccident.php?qr=1134', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL),
(1267, 1135, 'apatkal/submitaccident.php?qr=1135', '2025-10-13 13:45:42', NULL, NULL, NULL, NULL);
INSERT INTO `qr_codes` (`id`, `qr_number`, `qr_url`, `created_at`, `vehicle_number`, `full_name`, `phone`, `last_used_at`) VALUES
(1268, 1136, 'apatkal/submitaccident.php?qr=1136', '2025-10-13 13:46:09', NULL, NULL, NULL, NULL),
(1269, 1137, 'apatkal/submitaccident.php?qr=1137', '2025-10-13 13:46:09', NULL, NULL, NULL, NULL),
(1270, 1138, 'apatkal/submitaccident.php?qr=1138', '2025-10-13 13:46:09', NULL, NULL, NULL, NULL),
(1271, 1139, 'apatkal/submitaccident.php?qr=1139', '2025-10-13 13:46:09', NULL, NULL, NULL, NULL),
(1272, 1140, 'apatkal/submitaccident.php?qr=1140', '2025-10-13 13:46:09', NULL, NULL, NULL, NULL),
(1273, 1141, 'apatkal/submitaccident.php?qr=1141', '2025-10-13 13:46:09', NULL, NULL, NULL, NULL),
(1274, 1142, 'apatkal/submitaccident.php?qr=1142', '2025-10-13 13:46:09', NULL, NULL, NULL, NULL),
(1275, 1143, 'apatkal/submitaccident.php?qr=1143', '2025-10-13 13:46:09', NULL, NULL, NULL, NULL),
(1276, 1144, 'apatkal/submitaccident.php?qr=1144', '2025-10-13 13:46:10', NULL, NULL, NULL, NULL),
(1277, 1145, 'apatkal/submitaccident.php?qr=1145', '2025-10-13 13:46:10', NULL, NULL, NULL, NULL),
(1278, 1146, 'apatkal/submitaccident.php?qr=1146', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1279, 1147, 'apatkal/submitaccident.php?qr=1147', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1280, 1148, 'apatkal/submitaccident.php?qr=1148', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1281, 1149, 'apatkal/submitaccident.php?qr=1149', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1282, 1150, 'apatkal/submitaccident.php?qr=1150', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1283, 1151, 'apatkal/submitaccident.php?qr=1151', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1284, 1152, 'apatkal/submitaccident.php?qr=1152', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1285, 1153, 'apatkal/submitaccident.php?qr=1153', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1286, 1154, 'apatkal/submitaccident.php?qr=1154', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1287, 1155, 'apatkal/submitaccident.php?qr=1155', '2025-10-13 14:16:13', NULL, NULL, NULL, NULL),
(1288, 1156, 'apatkal/submitaccident.php?qr=1156', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1289, 1157, 'apatkal/submitaccident.php?qr=1157', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1290, 1158, 'apatkal/submitaccident.php?qr=1158', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1291, 1159, 'apatkal/submitaccident.php?qr=1159', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1292, 1160, 'apatkal/submitaccident.php?qr=1160', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1293, 1161, 'apatkal/submitaccident.php?qr=1161', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1294, 1162, 'apatkal/submitaccident.php?qr=1162', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1295, 1163, 'apatkal/submitaccident.php?qr=1163', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1296, 1164, 'apatkal/submitaccident.php?qr=1164', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1297, 1165, 'apatkal/submitaccident.php?qr=1165', '2025-10-13 14:16:41', NULL, NULL, NULL, NULL),
(1298, 1166, 'apatkal/submitaccident.php?qr=1166', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1299, 1167, 'apatkal/submitaccident.php?qr=1167', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1300, 1168, 'apatkal/submitaccident.php?qr=1168', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1301, 1169, 'apatkal/submitaccident.php?qr=1169', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1302, 1170, 'apatkal/submitaccident.php?qr=1170', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1303, 1171, 'apatkal/submitaccident.php?qr=1171', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1304, 1172, 'apatkal/submitaccident.php?qr=1172', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1305, 1173, 'apatkal/submitaccident.php?qr=1173', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1306, 1174, 'apatkal/submitaccident.php?qr=1174', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1307, 1175, 'apatkal/submitaccident.php?qr=1175', '2025-10-13 14:27:15', NULL, NULL, NULL, NULL),
(1308, 1176, 'apatkal/submitaccident.php?qr=1176', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1309, 1177, 'apatkal/submitaccident.php?qr=1177', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1310, 1178, 'apatkal/submitaccident.php?qr=1178', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1311, 1179, 'apatkal/submitaccident.php?qr=1179', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1312, 1180, 'apatkal/submitaccident.php?qr=1180', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1313, 1181, 'apatkal/submitaccident.php?qr=1181', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1314, 1182, 'apatkal/submitaccident.php?qr=1182', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1315, 1183, 'apatkal/submitaccident.php?qr=1183', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1316, 1184, 'apatkal/submitaccident.php?qr=1184', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1317, 1185, 'apatkal/submitaccident.php?qr=1185', '2025-10-13 14:32:15', NULL, NULL, NULL, NULL),
(1318, 1186, 'apatkal/submitaccident.php?qr=1186', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1319, 1187, 'apatkal/submitaccident.php?qr=1187', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1320, 1188, 'apatkal/submitaccident.php?qr=1188', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1321, 1189, 'apatkal/submitaccident.php?qr=1189', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1322, 1190, 'apatkal/submitaccident.php?qr=1190', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1323, 1191, 'apatkal/submitaccident.php?qr=1191', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1324, 1192, 'apatkal/submitaccident.php?qr=1192', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1325, 1193, 'apatkal/submitaccident.php?qr=1193', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1326, 1194, 'apatkal/submitaccident.php?qr=1194', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1327, 1195, 'apatkal/submitaccident.php?qr=1195', '2025-10-13 14:33:12', NULL, NULL, NULL, NULL),
(1328, 1196, 'apatkal/submitaccident.php?qr=1196', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1329, 1197, 'apatkal/submitaccident.php?qr=1197', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1330, 1198, 'apatkal/submitaccident.php?qr=1198', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1331, 1199, 'apatkal/submitaccident.php?qr=1199', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1332, 1200, 'apatkal/submitaccident.php?qr=1200', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1333, 1201, 'apatkal/submitaccident.php?qr=1201', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1334, 1202, 'apatkal/submitaccident.php?qr=1202', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1335, 1203, 'apatkal/submitaccident.php?qr=1203', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1336, 1204, 'apatkal/submitaccident.php?qr=1204', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1337, 1205, 'apatkal/submitaccident.php?qr=1205', '2025-10-13 14:48:56', NULL, NULL, NULL, NULL),
(1338, 1206, 'apatkal/submitaccident.php?qr=1206', '2025-10-13 14:49:16', NULL, NULL, NULL, NULL),
(1339, 1207, 'apatkal/submitaccident.php?qr=1207', '2025-10-13 14:49:16', NULL, NULL, NULL, NULL),
(1340, 1208, 'apatkal/submitaccident.php?qr=1208', '2025-10-13 14:49:16', NULL, NULL, NULL, NULL),
(1341, 1209, 'apatkal/submitaccident.php?qr=1209', '2025-10-13 14:49:16', NULL, NULL, NULL, NULL),
(1342, 1210, 'apatkal/submitaccident.php?qr=1210', '2025-10-13 14:49:16', NULL, NULL, NULL, NULL),
(1343, 1211, 'apatkal/submitaccident.php?qr=1211', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1344, 1212, 'apatkal/submitaccident.php?qr=1212', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1345, 1213, 'apatkal/submitaccident.php?qr=1213', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1346, 1214, 'apatkal/submitaccident.php?qr=1214', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1347, 1215, 'apatkal/submitaccident.php?qr=1215', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1348, 1216, 'apatkal/submitaccident.php?qr=1216', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1349, 1217, 'apatkal/submitaccident.php?qr=1217', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1350, 1218, 'apatkal/submitaccident.php?qr=1218', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1351, 1219, 'apatkal/submitaccident.php?qr=1219', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1352, 1220, 'apatkal/submitaccident.php?qr=1220', '2025-10-13 15:04:14', NULL, NULL, NULL, NULL),
(1353, 1221, 'apatkal/submitaccident.php?qr=1221', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1354, 1222, 'apatkal/submitaccident.php?qr=1222', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1355, 1223, 'apatkal/submitaccident.php?qr=1223', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1356, 1224, 'apatkal/submitaccident.php?qr=1224', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1357, 1225, 'apatkal/submitaccident.php?qr=1225', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1358, 1226, 'apatkal/submitaccident.php?qr=1226', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1359, 1227, 'apatkal/submitaccident.php?qr=1227', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1360, 1228, 'apatkal/submitaccident.php?qr=1228', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1361, 1229, 'apatkal/submitaccident.php?qr=1229', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1362, 1230, 'apatkal/submitaccident.php?qr=1230', '2025-10-13 15:14:01', NULL, NULL, NULL, NULL),
(1363, 1231, 'apatkal/submitaccident.php?qr=1231', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1364, 1232, 'apatkal/submitaccident.php?qr=1232', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1365, 1233, 'apatkal/submitaccident.php?qr=1233', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1366, 1234, 'apatkal/submitaccident.php?qr=1234', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1367, 1235, 'apatkal/submitaccident.php?qr=1235', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1368, 1236, 'apatkal/submitaccident.php?qr=1236', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1369, 1237, 'apatkal/submitaccident.php?qr=1237', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1370, 1238, 'apatkal/submitaccident.php?qr=1238', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1371, 1239, 'apatkal/submitaccident.php?qr=1239', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1372, 1240, 'apatkal/submitaccident.php?qr=1240', '2025-10-13 15:32:07', NULL, NULL, NULL, NULL),
(1373, 1241, 'apatkal/submitaccident.php?qr=1241', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1374, 1242, 'apatkal/submitaccident.php?qr=1242', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1375, 1243, 'apatkal/submitaccident.php?qr=1243', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1376, 1244, 'apatkal/submitaccident.php?qr=1244', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1377, 1245, 'apatkal/submitaccident.php?qr=1245', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1378, 1246, 'apatkal/submitaccident.php?qr=1246', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1379, 1247, 'apatkal/submitaccident.php?qr=1247', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1380, 1248, 'apatkal/submitaccident.php?qr=1248', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1381, 1249, 'apatkal/submitaccident.php?qr=1249', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1382, 1250, 'apatkal/submitaccident.php?qr=1250', '2025-10-13 16:10:27', NULL, NULL, NULL, NULL),
(1383, 1251, 'apatkal/submitaccident.php?qr=1251', '2025-10-13 16:14:36', NULL, NULL, NULL, NULL),
(1384, 1252, 'apatkal/submitaccident.php?qr=1252', '2025-10-13 16:14:36', NULL, NULL, NULL, NULL),
(1385, 1253, 'apatkal/submitaccident.php?qr=1253', '2025-10-13 16:14:36', NULL, NULL, NULL, NULL),
(1386, 1254, 'apatkal/submitaccident.php?qr=1254', '2025-10-13 16:14:36', NULL, NULL, NULL, NULL),
(1387, 1255, 'apatkal/submitaccident.php?qr=1255', '2025-10-13 16:14:36', NULL, NULL, NULL, NULL),
(1388, 1256, 'apatkal/submitaccident.php?qr=1256', '2025-10-13 16:14:47', NULL, NULL, NULL, NULL),
(1389, 1257, 'apatkal/submitaccident.php?qr=1257', '2025-10-13 16:14:47', NULL, NULL, NULL, NULL),
(1390, 1258, 'apatkal/submitaccident.php?qr=1258', '2025-10-13 16:14:47', NULL, NULL, NULL, NULL),
(1391, 1259, 'apatkal/submitaccident.php?qr=1259', '2025-10-13 16:14:47', NULL, NULL, NULL, NULL),
(1392, 1260, 'apatkal/submitaccident.php?qr=1260', '2025-10-13 16:14:47', NULL, NULL, NULL, NULL),
(1393, 1261, 'apatkal/submitaccident.php?qr=1261', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1394, 1262, 'apatkal/submitaccident.php?qr=1262', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1395, 1263, 'apatkal/submitaccident.php?qr=1263', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1396, 1264, 'apatkal/submitaccident.php?qr=1264', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1397, 1265, 'apatkal/submitaccident.php?qr=1265', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1398, 1266, 'apatkal/submitaccident.php?qr=1266', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1399, 1267, 'apatkal/submitaccident.php?qr=1267', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1400, 1268, 'apatkal/submitaccident.php?qr=1268', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1401, 1269, 'apatkal/submitaccident.php?qr=1269', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1402, 1270, 'apatkal/submitaccident.php?qr=1270', '2025-10-13 16:20:21', NULL, NULL, NULL, NULL),
(1403, 1271, 'apatkal/submitaccident.php?qr=1271', '2025-10-13 16:26:28', NULL, NULL, NULL, NULL),
(1404, 1272, 'apatkal/submitaccident.php?qr=1272', '2025-10-13 16:26:28', 'mp20ch8732', 'Geetanjali', '7694975579', '2025-10-13 16:31:51'),
(1405, 1273, 'apatkal/submitaccident.php?qr=1273', '2025-10-13 16:26:28', NULL, NULL, NULL, NULL),
(1406, 1274, 'apatkal/submitaccident.php?qr=1274', '2025-10-13 16:26:28', NULL, NULL, NULL, NULL),
(1407, 1275, 'apatkal/submitaccident.php?qr=1275', '2025-10-13 16:26:28', NULL, NULL, NULL, NULL),
(1408, 1276, 'apatkal/submitaccident.php?qr=1276', '2025-10-13 16:26:28', NULL, NULL, NULL, NULL),
(1409, 1277, 'apatkal/submitaccident.php?qr=1277', '2025-10-13 16:26:28', NULL, NULL, NULL, NULL),
(1410, 1278, 'apatkal/submitaccident.php?qr=1278', '2025-10-13 16:26:28', NULL, NULL, NULL, NULL),
(1411, 1279, 'apatkal/submitaccident.php?qr=1279', '2025-10-13 16:26:28', NULL, NULL, NULL, NULL),
(1412, 1280, 'apatkal/submitaccident.php?qr=1280', '2025-10-13 16:26:28', NULL, NULL, NULL, NULL),
(1413, 1281, 'apatkal/submitaccident.php?qr=1281', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1414, 1282, 'apatkal/submitaccident.php?qr=1282', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1415, 1283, 'apatkal/submitaccident.php?qr=1283', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1416, 1284, 'apatkal/submitaccident.php?qr=1284', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1417, 1285, 'apatkal/submitaccident.php?qr=1285', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1418, 1286, 'apatkal/submitaccident.php?qr=1286', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1419, 1287, 'apatkal/submitaccident.php?qr=1287', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1420, 1288, 'apatkal/submitaccident.php?qr=1288', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1421, 1289, 'apatkal/submitaccident.php?qr=1289', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1422, 1290, 'apatkal/submitaccident.php?qr=1290', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1423, 1291, 'apatkal/submitaccident.php?qr=1291', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1424, 1292, 'apatkal/submitaccident.php?qr=1292', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1425, 1293, 'apatkal/submitaccident.php?qr=1293', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1426, 1294, 'apatkal/submitaccident.php?qr=1294', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1427, 1295, 'apatkal/submitaccident.php?qr=1295', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1428, 1296, 'apatkal/submitaccident.php?qr=1296', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1429, 1297, 'apatkal/submitaccident.php?qr=1297', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1430, 1298, 'apatkal/submitaccident.php?qr=1298', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1431, 1299, 'apatkal/submitaccident.php?qr=1299', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1432, 1300, 'apatkal/submitaccident.php?qr=1300', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1433, 1301, 'apatkal/submitaccident.php?qr=1301', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1434, 1302, 'apatkal/submitaccident.php?qr=1302', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1435, 1303, 'apatkal/submitaccident.php?qr=1303', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1436, 1304, 'apatkal/submitaccident.php?qr=1304', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1437, 1305, 'apatkal/submitaccident.php?qr=1305', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1438, 1306, 'apatkal/submitaccident.php?qr=1306', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1439, 1307, 'apatkal/submitaccident.php?qr=1307', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1440, 1308, 'apatkal/submitaccident.php?qr=1308', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1441, 1309, 'apatkal/submitaccident.php?qr=1309', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1442, 1310, 'apatkal/submitaccident.php?qr=1310', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1443, 1311, 'apatkal/submitaccident.php?qr=1311', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1444, 1312, 'apatkal/submitaccident.php?qr=1312', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1445, 1313, 'apatkal/submitaccident.php?qr=1313', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1446, 1314, 'apatkal/submitaccident.php?qr=1314', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1447, 1315, 'apatkal/submitaccident.php?qr=1315', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1448, 1316, 'apatkal/submitaccident.php?qr=1316', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1449, 1317, 'apatkal/submitaccident.php?qr=1317', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1450, 1318, 'apatkal/submitaccident.php?qr=1318', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1451, 1319, 'apatkal/submitaccident.php?qr=1319', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1452, 1320, 'apatkal/submitaccident.php?qr=1320', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1453, 1321, 'apatkal/submitaccident.php?qr=1321', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1454, 1322, 'apatkal/submitaccident.php?qr=1322', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1455, 1323, 'apatkal/submitaccident.php?qr=1323', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1456, 1324, 'apatkal/submitaccident.php?qr=1324', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1457, 1325, 'apatkal/submitaccident.php?qr=1325', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1458, 1326, 'apatkal/submitaccident.php?qr=1326', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1459, 1327, 'apatkal/submitaccident.php?qr=1327', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1460, 1328, 'apatkal/submitaccident.php?qr=1328', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1461, 1329, 'apatkal/submitaccident.php?qr=1329', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1462, 1330, 'apatkal/submitaccident.php?qr=1330', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1463, 1331, 'apatkal/submitaccident.php?qr=1331', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1464, 1332, 'apatkal/submitaccident.php?qr=1332', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1465, 1333, 'apatkal/submitaccident.php?qr=1333', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1466, 1334, 'apatkal/submitaccident.php?qr=1334', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1467, 1335, 'apatkal/submitaccident.php?qr=1335', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1468, 1336, 'apatkal/submitaccident.php?qr=1336', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1469, 1337, 'apatkal/submitaccident.php?qr=1337', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1470, 1338, 'apatkal/submitaccident.php?qr=1338', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1471, 1339, 'apatkal/submitaccident.php?qr=1339', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1472, 1340, 'apatkal/submitaccident.php?qr=1340', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1473, 1341, 'apatkal/submitaccident.php?qr=1341', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1474, 1342, 'apatkal/submitaccident.php?qr=1342', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1475, 1343, 'apatkal/submitaccident.php?qr=1343', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1476, 1344, 'apatkal/submitaccident.php?qr=1344', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1477, 1345, 'apatkal/submitaccident.php?qr=1345', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1478, 1346, 'apatkal/submitaccident.php?qr=1346', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1479, 1347, 'apatkal/submitaccident.php?qr=1347', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1480, 1348, 'apatkal/submitaccident.php?qr=1348', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1481, 1349, 'apatkal/submitaccident.php?qr=1349', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1482, 1350, 'apatkal/submitaccident.php?qr=1350', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1483, 1351, 'apatkal/submitaccident.php?qr=1351', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1484, 1352, 'apatkal/submitaccident.php?qr=1352', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1485, 1353, 'apatkal/submitaccident.php?qr=1353', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1486, 1354, 'apatkal/submitaccident.php?qr=1354', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1487, 1355, 'apatkal/submitaccident.php?qr=1355', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1488, 1356, 'apatkal/submitaccident.php?qr=1356', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1489, 1357, 'apatkal/submitaccident.php?qr=1357', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1490, 1358, 'apatkal/submitaccident.php?qr=1358', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1491, 1359, 'apatkal/submitaccident.php?qr=1359', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1492, 1360, 'apatkal/submitaccident.php?qr=1360', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1493, 1361, 'apatkal/submitaccident.php?qr=1361', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1494, 1362, 'apatkal/submitaccident.php?qr=1362', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1495, 1363, 'apatkal/submitaccident.php?qr=1363', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1496, 1364, 'apatkal/submitaccident.php?qr=1364', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1497, 1365, 'apatkal/submitaccident.php?qr=1365', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1498, 1366, 'apatkal/submitaccident.php?qr=1366', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1499, 1367, 'apatkal/submitaccident.php?qr=1367', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1500, 1368, 'apatkal/submitaccident.php?qr=1368', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1501, 1369, 'apatkal/submitaccident.php?qr=1369', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1502, 1370, 'apatkal/submitaccident.php?qr=1370', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1503, 1371, 'apatkal/submitaccident.php?qr=1371', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1504, 1372, 'apatkal/submitaccident.php?qr=1372', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1505, 1373, 'apatkal/submitaccident.php?qr=1373', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1506, 1374, 'apatkal/submitaccident.php?qr=1374', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1507, 1375, 'apatkal/submitaccident.php?qr=1375', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1508, 1376, 'apatkal/submitaccident.php?qr=1376', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1509, 1377, 'apatkal/submitaccident.php?qr=1377', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1510, 1378, 'apatkal/submitaccident.php?qr=1378', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1511, 1379, 'apatkal/submitaccident.php?qr=1379', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1512, 1380, 'apatkal/submitaccident.php?qr=1380', '2025-10-13 16:47:50', NULL, NULL, NULL, NULL),
(1513, 1381, 'apatkal/submitaccident.php?qr=1381', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1514, 1382, 'apatkal/submitaccident.php?qr=1382', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1515, 1383, 'apatkal/submitaccident.php?qr=1383', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1516, 1384, 'apatkal/submitaccident.php?qr=1384', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1517, 1385, 'apatkal/submitaccident.php?qr=1385', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1518, 1386, 'apatkal/submitaccident.php?qr=1386', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1519, 1387, 'apatkal/submitaccident.php?qr=1387', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1520, 1388, 'apatkal/submitaccident.php?qr=1388', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1521, 1389, 'apatkal/submitaccident.php?qr=1389', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1522, 1390, 'apatkal/submitaccident.php?qr=1390', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1523, 1391, 'apatkal/submitaccident.php?qr=1391', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1524, 1392, 'apatkal/submitaccident.php?qr=1392', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1525, 1393, 'apatkal/submitaccident.php?qr=1393', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1526, 1394, 'apatkal/submitaccident.php?qr=1394', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1527, 1395, 'apatkal/submitaccident.php?qr=1395', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1528, 1396, 'apatkal/submitaccident.php?qr=1396', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1529, 1397, 'apatkal/submitaccident.php?qr=1397', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1530, 1398, 'apatkal/submitaccident.php?qr=1398', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1531, 1399, 'apatkal/submitaccident.php?qr=1399', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1532, 1400, 'apatkal/submitaccident.php?qr=1400', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1533, 1401, 'apatkal/submitaccident.php?qr=1401', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1534, 1402, 'apatkal/submitaccident.php?qr=1402', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1535, 1403, 'apatkal/submitaccident.php?qr=1403', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1536, 1404, 'apatkal/submitaccident.php?qr=1404', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1537, 1405, 'apatkal/submitaccident.php?qr=1405', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1538, 1406, 'apatkal/submitaccident.php?qr=1406', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1539, 1407, 'apatkal/submitaccident.php?qr=1407', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1540, 1408, 'apatkal/submitaccident.php?qr=1408', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1541, 1409, 'apatkal/submitaccident.php?qr=1409', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1542, 1410, 'apatkal/submitaccident.php?qr=1410', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1543, 1411, 'apatkal/submitaccident.php?qr=1411', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1544, 1412, 'apatkal/submitaccident.php?qr=1412', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1545, 1413, 'apatkal/submitaccident.php?qr=1413', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1546, 1414, 'apatkal/submitaccident.php?qr=1414', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1547, 1415, 'apatkal/submitaccident.php?qr=1415', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1548, 1416, 'apatkal/submitaccident.php?qr=1416', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1549, 1417, 'apatkal/submitaccident.php?qr=1417', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1550, 1418, 'apatkal/submitaccident.php?qr=1418', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1551, 1419, 'apatkal/submitaccident.php?qr=1419', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1552, 1420, 'apatkal/submitaccident.php?qr=1420', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1553, 1421, 'apatkal/submitaccident.php?qr=1421', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1554, 1422, 'apatkal/submitaccident.php?qr=1422', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1555, 1423, 'apatkal/submitaccident.php?qr=1423', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1556, 1424, 'apatkal/submitaccident.php?qr=1424', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1557, 1425, 'apatkal/submitaccident.php?qr=1425', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1558, 1426, 'apatkal/submitaccident.php?qr=1426', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1559, 1427, 'apatkal/submitaccident.php?qr=1427', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1560, 1428, 'apatkal/submitaccident.php?qr=1428', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1561, 1429, 'apatkal/submitaccident.php?qr=1429', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1562, 1430, 'apatkal/submitaccident.php?qr=1430', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1563, 1431, 'apatkal/submitaccident.php?qr=1431', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1564, 1432, 'apatkal/submitaccident.php?qr=1432', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1565, 1433, 'apatkal/submitaccident.php?qr=1433', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1566, 1434, 'apatkal/submitaccident.php?qr=1434', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1567, 1435, 'apatkal/submitaccident.php?qr=1435', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1568, 1436, 'apatkal/submitaccident.php?qr=1436', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1569, 1437, 'apatkal/submitaccident.php?qr=1437', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1570, 1438, 'apatkal/submitaccident.php?qr=1438', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1571, 1439, 'apatkal/submitaccident.php?qr=1439', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1572, 1440, 'apatkal/submitaccident.php?qr=1440', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1573, 1441, 'apatkal/submitaccident.php?qr=1441', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1574, 1442, 'apatkal/submitaccident.php?qr=1442', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1575, 1443, 'apatkal/submitaccident.php?qr=1443', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1576, 1444, 'apatkal/submitaccident.php?qr=1444', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1577, 1445, 'apatkal/submitaccident.php?qr=1445', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1578, 1446, 'apatkal/submitaccident.php?qr=1446', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1579, 1447, 'apatkal/submitaccident.php?qr=1447', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1580, 1448, 'apatkal/submitaccident.php?qr=1448', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1581, 1449, 'apatkal/submitaccident.php?qr=1449', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1582, 1450, 'apatkal/submitaccident.php?qr=1450', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1583, 1451, 'apatkal/submitaccident.php?qr=1451', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1584, 1452, 'apatkal/submitaccident.php?qr=1452', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1585, 1453, 'apatkal/submitaccident.php?qr=1453', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1586, 1454, 'apatkal/submitaccident.php?qr=1454', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1587, 1455, 'apatkal/submitaccident.php?qr=1455', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1588, 1456, 'apatkal/submitaccident.php?qr=1456', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1589, 1457, 'apatkal/submitaccident.php?qr=1457', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1590, 1458, 'apatkal/submitaccident.php?qr=1458', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1591, 1459, 'apatkal/submitaccident.php?qr=1459', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1592, 1460, 'apatkal/submitaccident.php?qr=1460', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1593, 1461, 'apatkal/submitaccident.php?qr=1461', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1594, 1462, 'apatkal/submitaccident.php?qr=1462', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1595, 1463, 'apatkal/submitaccident.php?qr=1463', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1596, 1464, 'apatkal/submitaccident.php?qr=1464', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1597, 1465, 'apatkal/submitaccident.php?qr=1465', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1598, 1466, 'apatkal/submitaccident.php?qr=1466', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1599, 1467, 'apatkal/submitaccident.php?qr=1467', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1600, 1468, 'apatkal/submitaccident.php?qr=1468', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1601, 1469, 'apatkal/submitaccident.php?qr=1469', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1602, 1470, 'apatkal/submitaccident.php?qr=1470', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1603, 1471, 'apatkal/submitaccident.php?qr=1471', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1604, 1472, 'apatkal/submitaccident.php?qr=1472', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1605, 1473, 'apatkal/submitaccident.php?qr=1473', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1606, 1474, 'apatkal/submitaccident.php?qr=1474', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1607, 1475, 'apatkal/submitaccident.php?qr=1475', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1608, 1476, 'apatkal/submitaccident.php?qr=1476', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1609, 1477, 'apatkal/submitaccident.php?qr=1477', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1610, 1478, 'apatkal/submitaccident.php?qr=1478', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1611, 1479, 'apatkal/submitaccident.php?qr=1479', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1612, 1480, 'apatkal/submitaccident.php?qr=1480', '2025-10-13 16:52:07', NULL, NULL, NULL, NULL),
(1613, 1481, 'apatkal/submitaccident.php?qr=1481', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1614, 1482, 'apatkal/submitaccident.php?qr=1482', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1615, 1483, 'apatkal/submitaccident.php?qr=1483', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1616, 1484, 'apatkal/submitaccident.php?qr=1484', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1617, 1485, 'apatkal/submitaccident.php?qr=1485', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1618, 1486, 'apatkal/submitaccident.php?qr=1486', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1619, 1487, 'apatkal/submitaccident.php?qr=1487', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1620, 1488, 'apatkal/submitaccident.php?qr=1488', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1621, 1489, 'apatkal/submitaccident.php?qr=1489', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1622, 1490, 'apatkal/submitaccident.php?qr=1490', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1623, 1491, 'apatkal/submitaccident.php?qr=1491', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1624, 1492, 'apatkal/submitaccident.php?qr=1492', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1625, 1493, 'apatkal/submitaccident.php?qr=1493', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1626, 1494, 'apatkal/submitaccident.php?qr=1494', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1627, 1495, 'apatkal/submitaccident.php?qr=1495', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1628, 1496, 'apatkal/submitaccident.php?qr=1496', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1629, 1497, 'apatkal/submitaccident.php?qr=1497', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1630, 1498, 'apatkal/submitaccident.php?qr=1498', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1631, 1499, 'apatkal/submitaccident.php?qr=1499', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1632, 1500, 'apatkal/submitaccident.php?qr=1500', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1633, 1501, 'apatkal/submitaccident.php?qr=1501', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1634, 1502, 'apatkal/submitaccident.php?qr=1502', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1635, 1503, 'apatkal/submitaccident.php?qr=1503', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1636, 1504, 'apatkal/submitaccident.php?qr=1504', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1637, 1505, 'apatkal/submitaccident.php?qr=1505', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1638, 1506, 'apatkal/submitaccident.php?qr=1506', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1639, 1507, 'apatkal/submitaccident.php?qr=1507', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1640, 1508, 'apatkal/submitaccident.php?qr=1508', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1641, 1509, 'apatkal/submitaccident.php?qr=1509', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1642, 1510, 'apatkal/submitaccident.php?qr=1510', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1643, 1511, 'apatkal/submitaccident.php?qr=1511', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1644, 1512, 'apatkal/submitaccident.php?qr=1512', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1645, 1513, 'apatkal/submitaccident.php?qr=1513', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1646, 1514, 'apatkal/submitaccident.php?qr=1514', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1647, 1515, 'apatkal/submitaccident.php?qr=1515', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1648, 1516, 'apatkal/submitaccident.php?qr=1516', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1649, 1517, 'apatkal/submitaccident.php?qr=1517', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1650, 1518, 'apatkal/submitaccident.php?qr=1518', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1651, 1519, 'apatkal/submitaccident.php?qr=1519', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1652, 1520, 'apatkal/submitaccident.php?qr=1520', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1653, 1521, 'apatkal/submitaccident.php?qr=1521', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1654, 1522, 'apatkal/submitaccident.php?qr=1522', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1655, 1523, 'apatkal/submitaccident.php?qr=1523', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1656, 1524, 'apatkal/submitaccident.php?qr=1524', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1657, 1525, 'apatkal/submitaccident.php?qr=1525', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1658, 1526, 'apatkal/submitaccident.php?qr=1526', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1659, 1527, 'apatkal/submitaccident.php?qr=1527', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1660, 1528, 'apatkal/submitaccident.php?qr=1528', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1661, 1529, 'apatkal/submitaccident.php?qr=1529', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1662, 1530, 'apatkal/submitaccident.php?qr=1530', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1663, 1531, 'apatkal/submitaccident.php?qr=1531', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1664, 1532, 'apatkal/submitaccident.php?qr=1532', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1665, 1533, 'apatkal/submitaccident.php?qr=1533', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1666, 1534, 'apatkal/submitaccident.php?qr=1534', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1667, 1535, 'apatkal/submitaccident.php?qr=1535', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1668, 1536, 'apatkal/submitaccident.php?qr=1536', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1669, 1537, 'apatkal/submitaccident.php?qr=1537', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1670, 1538, 'apatkal/submitaccident.php?qr=1538', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1671, 1539, 'apatkal/submitaccident.php?qr=1539', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1672, 1540, 'apatkal/submitaccident.php?qr=1540', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1673, 1541, 'apatkal/submitaccident.php?qr=1541', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1674, 1542, 'apatkal/submitaccident.php?qr=1542', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1675, 1543, 'apatkal/submitaccident.php?qr=1543', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1676, 1544, 'apatkal/submitaccident.php?qr=1544', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1677, 1545, 'apatkal/submitaccident.php?qr=1545', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1678, 1546, 'apatkal/submitaccident.php?qr=1546', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1679, 1547, 'apatkal/submitaccident.php?qr=1547', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1680, 1548, 'apatkal/submitaccident.php?qr=1548', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1681, 1549, 'apatkal/submitaccident.php?qr=1549', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1682, 1550, 'apatkal/submitaccident.php?qr=1550', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1683, 1551, 'apatkal/submitaccident.php?qr=1551', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1684, 1552, 'apatkal/submitaccident.php?qr=1552', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1685, 1553, 'apatkal/submitaccident.php?qr=1553', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1686, 1554, 'apatkal/submitaccident.php?qr=1554', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1687, 1555, 'apatkal/submitaccident.php?qr=1555', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1688, 1556, 'apatkal/submitaccident.php?qr=1556', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1689, 1557, 'apatkal/submitaccident.php?qr=1557', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1690, 1558, 'apatkal/submitaccident.php?qr=1558', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1691, 1559, 'apatkal/submitaccident.php?qr=1559', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1692, 1560, 'apatkal/submitaccident.php?qr=1560', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1693, 1561, 'apatkal/submitaccident.php?qr=1561', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1694, 1562, 'apatkal/submitaccident.php?qr=1562', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1695, 1563, 'apatkal/submitaccident.php?qr=1563', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1696, 1564, 'apatkal/submitaccident.php?qr=1564', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1697, 1565, 'apatkal/submitaccident.php?qr=1565', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1698, 1566, 'apatkal/submitaccident.php?qr=1566', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1699, 1567, 'apatkal/submitaccident.php?qr=1567', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1700, 1568, 'apatkal/submitaccident.php?qr=1568', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1701, 1569, 'apatkal/submitaccident.php?qr=1569', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1702, 1570, 'apatkal/submitaccident.php?qr=1570', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1703, 1571, 'apatkal/submitaccident.php?qr=1571', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1704, 1572, 'apatkal/submitaccident.php?qr=1572', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1705, 1573, 'apatkal/submitaccident.php?qr=1573', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1706, 1574, 'apatkal/submitaccident.php?qr=1574', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1707, 1575, 'apatkal/submitaccident.php?qr=1575', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1708, 1576, 'apatkal/submitaccident.php?qr=1576', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1709, 1577, 'apatkal/submitaccident.php?qr=1577', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1710, 1578, 'apatkal/submitaccident.php?qr=1578', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1711, 1579, 'apatkal/submitaccident.php?qr=1579', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1712, 1580, 'apatkal/submitaccident.php?qr=1580', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1713, 1581, 'apatkal/submitaccident.php?qr=1581', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1714, 1582, 'apatkal/submitaccident.php?qr=1582', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1715, 1583, 'apatkal/submitaccident.php?qr=1583', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1716, 1584, 'apatkal/submitaccident.php?qr=1584', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1717, 1585, 'apatkal/submitaccident.php?qr=1585', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1718, 1586, 'apatkal/submitaccident.php?qr=1586', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1719, 1587, 'apatkal/submitaccident.php?qr=1587', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1720, 1588, 'apatkal/submitaccident.php?qr=1588', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1721, 1589, 'apatkal/submitaccident.php?qr=1589', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1722, 1590, 'apatkal/submitaccident.php?qr=1590', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1723, 1591, 'apatkal/submitaccident.php?qr=1591', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1724, 1592, 'apatkal/submitaccident.php?qr=1592', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1725, 1593, 'apatkal/submitaccident.php?qr=1593', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1726, 1594, 'apatkal/submitaccident.php?qr=1594', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1727, 1595, 'apatkal/submitaccident.php?qr=1595', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1728, 1596, 'apatkal/submitaccident.php?qr=1596', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1729, 1597, 'apatkal/submitaccident.php?qr=1597', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1730, 1598, 'apatkal/submitaccident.php?qr=1598', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1731, 1599, 'apatkal/submitaccident.php?qr=1599', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1732, 1600, 'apatkal/submitaccident.php?qr=1600', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1733, 1601, 'apatkal/submitaccident.php?qr=1601', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1734, 1602, 'apatkal/submitaccident.php?qr=1602', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1735, 1603, 'apatkal/submitaccident.php?qr=1603', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1736, 1604, 'apatkal/submitaccident.php?qr=1604', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1737, 1605, 'apatkal/submitaccident.php?qr=1605', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1738, 1606, 'apatkal/submitaccident.php?qr=1606', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1739, 1607, 'apatkal/submitaccident.php?qr=1607', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1740, 1608, 'apatkal/submitaccident.php?qr=1608', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1741, 1609, 'apatkal/submitaccident.php?qr=1609', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1742, 1610, 'apatkal/submitaccident.php?qr=1610', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1743, 1611, 'apatkal/submitaccident.php?qr=1611', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1744, 1612, 'apatkal/submitaccident.php?qr=1612', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1745, 1613, 'apatkal/submitaccident.php?qr=1613', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1746, 1614, 'apatkal/submitaccident.php?qr=1614', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1747, 1615, 'apatkal/submitaccident.php?qr=1615', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1748, 1616, 'apatkal/submitaccident.php?qr=1616', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1749, 1617, 'apatkal/submitaccident.php?qr=1617', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1750, 1618, 'apatkal/submitaccident.php?qr=1618', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1751, 1619, 'apatkal/submitaccident.php?qr=1619', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1752, 1620, 'apatkal/submitaccident.php?qr=1620', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1753, 1621, 'apatkal/submitaccident.php?qr=1621', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1754, 1622, 'apatkal/submitaccident.php?qr=1622', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1755, 1623, 'apatkal/submitaccident.php?qr=1623', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1756, 1624, 'apatkal/submitaccident.php?qr=1624', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1757, 1625, 'apatkal/submitaccident.php?qr=1625', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1758, 1626, 'apatkal/submitaccident.php?qr=1626', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1759, 1627, 'apatkal/submitaccident.php?qr=1627', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1760, 1628, 'apatkal/submitaccident.php?qr=1628', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1761, 1629, 'apatkal/submitaccident.php?qr=1629', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1762, 1630, 'apatkal/submitaccident.php?qr=1630', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1763, 1631, 'apatkal/submitaccident.php?qr=1631', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1764, 1632, 'apatkal/submitaccident.php?qr=1632', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1765, 1633, 'apatkal/submitaccident.php?qr=1633', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1766, 1634, 'apatkal/submitaccident.php?qr=1634', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1767, 1635, 'apatkal/submitaccident.php?qr=1635', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1768, 1636, 'apatkal/submitaccident.php?qr=1636', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1769, 1637, 'apatkal/submitaccident.php?qr=1637', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1770, 1638, 'apatkal/submitaccident.php?qr=1638', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1771, 1639, 'apatkal/submitaccident.php?qr=1639', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1772, 1640, 'apatkal/submitaccident.php?qr=1640', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1773, 1641, 'apatkal/submitaccident.php?qr=1641', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1774, 1642, 'apatkal/submitaccident.php?qr=1642', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1775, 1643, 'apatkal/submitaccident.php?qr=1643', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1776, 1644, 'apatkal/submitaccident.php?qr=1644', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1777, 1645, 'apatkal/submitaccident.php?qr=1645', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1778, 1646, 'apatkal/submitaccident.php?qr=1646', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1779, 1647, 'apatkal/submitaccident.php?qr=1647', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1780, 1648, 'apatkal/submitaccident.php?qr=1648', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL);
INSERT INTO `qr_codes` (`id`, `qr_number`, `qr_url`, `created_at`, `vehicle_number`, `full_name`, `phone`, `last_used_at`) VALUES
(1781, 1649, 'apatkal/submitaccident.php?qr=1649', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1782, 1650, 'apatkal/submitaccident.php?qr=1650', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1783, 1651, 'apatkal/submitaccident.php?qr=1651', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1784, 1652, 'apatkal/submitaccident.php?qr=1652', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1785, 1653, 'apatkal/submitaccident.php?qr=1653', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1786, 1654, 'apatkal/submitaccident.php?qr=1654', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1787, 1655, 'apatkal/submitaccident.php?qr=1655', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1788, 1656, 'apatkal/submitaccident.php?qr=1656', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1789, 1657, 'apatkal/submitaccident.php?qr=1657', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1790, 1658, 'apatkal/submitaccident.php?qr=1658', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1791, 1659, 'apatkal/submitaccident.php?qr=1659', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1792, 1660, 'apatkal/submitaccident.php?qr=1660', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1793, 1661, 'apatkal/submitaccident.php?qr=1661', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1794, 1662, 'apatkal/submitaccident.php?qr=1662', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1795, 1663, 'apatkal/submitaccident.php?qr=1663', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1796, 1664, 'apatkal/submitaccident.php?qr=1664', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1797, 1665, 'apatkal/submitaccident.php?qr=1665', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1798, 1666, 'apatkal/submitaccident.php?qr=1666', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1799, 1667, 'apatkal/submitaccident.php?qr=1667', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1800, 1668, 'apatkal/submitaccident.php?qr=1668', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1801, 1669, 'apatkal/submitaccident.php?qr=1669', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1802, 1670, 'apatkal/submitaccident.php?qr=1670', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1803, 1671, 'apatkal/submitaccident.php?qr=1671', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1804, 1672, 'apatkal/submitaccident.php?qr=1672', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1805, 1673, 'apatkal/submitaccident.php?qr=1673', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1806, 1674, 'apatkal/submitaccident.php?qr=1674', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1807, 1675, 'apatkal/submitaccident.php?qr=1675', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1808, 1676, 'apatkal/submitaccident.php?qr=1676', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1809, 1677, 'apatkal/submitaccident.php?qr=1677', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1810, 1678, 'apatkal/submitaccident.php?qr=1678', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1811, 1679, 'apatkal/submitaccident.php?qr=1679', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1812, 1680, 'apatkal/submitaccident.php?qr=1680', '2025-10-13 16:58:25', NULL, NULL, NULL, NULL),
(1813, 1681, 'apatkal/submitaccident.php?qr=1681', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1814, 1682, 'apatkal/submitaccident.php?qr=1682', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1815, 1683, 'apatkal/submitaccident.php?qr=1683', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1816, 1684, 'apatkal/submitaccident.php?qr=1684', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1817, 1685, 'apatkal/submitaccident.php?qr=1685', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1818, 1686, 'apatkal/submitaccident.php?qr=1686', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1819, 1687, 'apatkal/submitaccident.php?qr=1687', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1820, 1688, 'apatkal/submitaccident.php?qr=1688', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1821, 1689, 'apatkal/submitaccident.php?qr=1689', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1822, 1690, 'apatkal/submitaccident.php?qr=1690', '2025-10-13 17:01:52', NULL, NULL, NULL, NULL),
(1823, 1691, 'apatkal/submitaccident.php?qr=1691', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1824, 1692, 'apatkal/submitaccident.php?qr=1692', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1825, 1693, 'apatkal/submitaccident.php?qr=1693', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1826, 1694, 'apatkal/submitaccident.php?qr=1694', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1827, 1695, 'apatkal/submitaccident.php?qr=1695', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1828, 1696, 'apatkal/submitaccident.php?qr=1696', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1829, 1697, 'apatkal/submitaccident.php?qr=1697', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1830, 1698, 'apatkal/submitaccident.php?qr=1698', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1831, 1699, 'apatkal/submitaccident.php?qr=1699', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1832, 1700, 'apatkal/submitaccident.php?qr=1700', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1833, 1701, 'apatkal/submitaccident.php?qr=1701', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1834, 1702, 'apatkal/submitaccident.php?qr=1702', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1835, 1703, 'apatkal/submitaccident.php?qr=1703', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1836, 1704, 'apatkal/submitaccident.php?qr=1704', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1837, 1705, 'apatkal/submitaccident.php?qr=1705', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1838, 1706, 'apatkal/submitaccident.php?qr=1706', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1839, 1707, 'apatkal/submitaccident.php?qr=1707', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1840, 1708, 'apatkal/submitaccident.php?qr=1708', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1841, 1709, 'apatkal/submitaccident.php?qr=1709', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1842, 1710, 'apatkal/submitaccident.php?qr=1710', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1843, 1711, 'apatkal/submitaccident.php?qr=1711', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1844, 1712, 'apatkal/submitaccident.php?qr=1712', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1845, 1713, 'apatkal/submitaccident.php?qr=1713', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1846, 1714, 'apatkal/submitaccident.php?qr=1714', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1847, 1715, 'apatkal/submitaccident.php?qr=1715', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1848, 1716, 'apatkal/submitaccident.php?qr=1716', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1849, 1717, 'apatkal/submitaccident.php?qr=1717', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1850, 1718, 'apatkal/submitaccident.php?qr=1718', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1851, 1719, 'apatkal/submitaccident.php?qr=1719', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1852, 1720, 'apatkal/submitaccident.php?qr=1720', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1853, 1721, 'apatkal/submitaccident.php?qr=1721', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1854, 1722, 'apatkal/submitaccident.php?qr=1722', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1855, 1723, 'apatkal/submitaccident.php?qr=1723', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1856, 1724, 'apatkal/submitaccident.php?qr=1724', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1857, 1725, 'apatkal/submitaccident.php?qr=1725', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1858, 1726, 'apatkal/submitaccident.php?qr=1726', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1859, 1727, 'apatkal/submitaccident.php?qr=1727', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1860, 1728, 'apatkal/submitaccident.php?qr=1728', '2025-10-13 17:05:33', NULL, NULL, NULL, NULL),
(1861, 1729, 'apatkal/submitaccident.php?qr=1729', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1862, 1730, 'apatkal/submitaccident.php?qr=1730', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1863, 1731, 'apatkal/submitaccident.php?qr=1731', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1864, 1732, 'apatkal/submitaccident.php?qr=1732', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1865, 1733, 'apatkal/submitaccident.php?qr=1733', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1866, 1734, 'apatkal/submitaccident.php?qr=1734', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1867, 1735, 'apatkal/submitaccident.php?qr=1735', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1868, 1736, 'apatkal/submitaccident.php?qr=1736', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1869, 1737, 'apatkal/submitaccident.php?qr=1737', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1870, 1738, 'apatkal/submitaccident.php?qr=1738', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1871, 1739, 'apatkal/submitaccident.php?qr=1739', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1872, 1740, 'apatkal/submitaccident.php?qr=1740', '2025-10-13 17:05:34', NULL, NULL, NULL, NULL),
(1873, 1741, 'apatkal/submitaccident.php?qr=1741', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1874, 1742, 'apatkal/submitaccident.php?qr=1742', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1875, 1743, 'apatkal/submitaccident.php?qr=1743', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1876, 1744, 'apatkal/submitaccident.php?qr=1744', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1877, 1745, 'apatkal/submitaccident.php?qr=1745', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1878, 1746, 'apatkal/submitaccident.php?qr=1746', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1879, 1747, 'apatkal/submitaccident.php?qr=1747', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1880, 1748, 'apatkal/submitaccident.php?qr=1748', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1881, 1749, 'apatkal/submitaccident.php?qr=1749', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1882, 1750, 'apatkal/submitaccident.php?qr=1750', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1883, 1751, 'apatkal/submitaccident.php?qr=1751', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1884, 1752, 'apatkal/submitaccident.php?qr=1752', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1885, 1753, 'apatkal/submitaccident.php?qr=1753', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1886, 1754, 'apatkal/submitaccident.php?qr=1754', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1887, 1755, 'apatkal/submitaccident.php?qr=1755', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1888, 1756, 'apatkal/submitaccident.php?qr=1756', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1889, 1757, 'apatkal/submitaccident.php?qr=1757', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1890, 1758, 'apatkal/submitaccident.php?qr=1758', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1891, 1759, 'apatkal/submitaccident.php?qr=1759', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1892, 1760, 'apatkal/submitaccident.php?qr=1760', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1893, 1761, 'apatkal/submitaccident.php?qr=1761', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1894, 1762, 'apatkal/submitaccident.php?qr=1762', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1895, 1763, 'apatkal/submitaccident.php?qr=1763', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1896, 1764, 'apatkal/submitaccident.php?qr=1764', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1897, 1765, 'apatkal/submitaccident.php?qr=1765', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1898, 1766, 'apatkal/submitaccident.php?qr=1766', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1899, 1767, 'apatkal/submitaccident.php?qr=1767', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1900, 1768, 'apatkal/submitaccident.php?qr=1768', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1901, 1769, 'apatkal/submitaccident.php?qr=1769', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1902, 1770, 'apatkal/submitaccident.php?qr=1770', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1903, 1771, 'apatkal/submitaccident.php?qr=1771', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1904, 1772, 'apatkal/submitaccident.php?qr=1772', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1905, 1773, 'apatkal/submitaccident.php?qr=1773', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1906, 1774, 'apatkal/submitaccident.php?qr=1774', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1907, 1775, 'apatkal/submitaccident.php?qr=1775', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1908, 1776, 'apatkal/submitaccident.php?qr=1776', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1909, 1777, 'apatkal/submitaccident.php?qr=1777', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1910, 1778, 'apatkal/submitaccident.php?qr=1778', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1911, 1779, 'apatkal/submitaccident.php?qr=1779', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1912, 1780, 'apatkal/submitaccident.php?qr=1780', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1913, 1781, 'apatkal/submitaccident.php?qr=1781', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1914, 1782, 'apatkal/submitaccident.php?qr=1782', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1915, 1783, 'apatkal/submitaccident.php?qr=1783', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1916, 1784, 'apatkal/submitaccident.php?qr=1784', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1917, 1785, 'apatkal/submitaccident.php?qr=1785', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1918, 1786, 'apatkal/submitaccident.php?qr=1786', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1919, 1787, 'apatkal/submitaccident.php?qr=1787', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1920, 1788, 'apatkal/submitaccident.php?qr=1788', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1921, 1789, 'apatkal/submitaccident.php?qr=1789', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1922, 1790, 'apatkal/submitaccident.php?qr=1790', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1923, 1791, 'apatkal/submitaccident.php?qr=1791', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1924, 1792, 'apatkal/submitaccident.php?qr=1792', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1925, 1793, 'apatkal/submitaccident.php?qr=1793', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1926, 1794, 'apatkal/submitaccident.php?qr=1794', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1927, 1795, 'apatkal/submitaccident.php?qr=1795', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1928, 1796, 'apatkal/submitaccident.php?qr=1796', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1929, 1797, 'apatkal/submitaccident.php?qr=1797', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1930, 1798, 'apatkal/submitaccident.php?qr=1798', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1931, 1799, 'apatkal/submitaccident.php?qr=1799', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1932, 1800, 'apatkal/submitaccident.php?qr=1800', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1933, 1801, 'apatkal/submitaccident.php?qr=1801', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1934, 1802, 'apatkal/submitaccident.php?qr=1802', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1935, 1803, 'apatkal/submitaccident.php?qr=1803', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1936, 1804, 'apatkal/submitaccident.php?qr=1804', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1937, 1805, 'apatkal/submitaccident.php?qr=1805', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1938, 1806, 'apatkal/submitaccident.php?qr=1806', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1939, 1807, 'apatkal/submitaccident.php?qr=1807', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1940, 1808, 'apatkal/submitaccident.php?qr=1808', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1941, 1809, 'apatkal/submitaccident.php?qr=1809', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1942, 1810, 'apatkal/submitaccident.php?qr=1810', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1943, 1811, 'apatkal/submitaccident.php?qr=1811', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1944, 1812, 'apatkal/submitaccident.php?qr=1812', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1945, 1813, 'apatkal/submitaccident.php?qr=1813', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1946, 1814, 'apatkal/submitaccident.php?qr=1814', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1947, 1815, 'apatkal/submitaccident.php?qr=1815', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1948, 1816, 'apatkal/submitaccident.php?qr=1816', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1949, 1817, 'apatkal/submitaccident.php?qr=1817', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1950, 1818, 'apatkal/submitaccident.php?qr=1818', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1951, 1819, 'apatkal/submitaccident.php?qr=1819', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1952, 1820, 'apatkal/submitaccident.php?qr=1820', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1953, 1821, 'apatkal/submitaccident.php?qr=1821', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1954, 1822, 'apatkal/submitaccident.php?qr=1822', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1955, 1823, 'apatkal/submitaccident.php?qr=1823', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1956, 1824, 'apatkal/submitaccident.php?qr=1824', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1957, 1825, 'apatkal/submitaccident.php?qr=1825', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1958, 1826, 'apatkal/submitaccident.php?qr=1826', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1959, 1827, 'apatkal/submitaccident.php?qr=1827', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1960, 1828, 'apatkal/submitaccident.php?qr=1828', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1961, 1829, 'apatkal/submitaccident.php?qr=1829', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1962, 1830, 'apatkal/submitaccident.php?qr=1830', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1963, 1831, 'apatkal/submitaccident.php?qr=1831', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1964, 1832, 'apatkal/submitaccident.php?qr=1832', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1965, 1833, 'apatkal/submitaccident.php?qr=1833', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1966, 1834, 'apatkal/submitaccident.php?qr=1834', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1967, 1835, 'apatkal/submitaccident.php?qr=1835', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1968, 1836, 'apatkal/submitaccident.php?qr=1836', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1969, 1837, 'apatkal/submitaccident.php?qr=1837', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1970, 1838, 'apatkal/submitaccident.php?qr=1838', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1971, 1839, 'apatkal/submitaccident.php?qr=1839', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1972, 1840, 'apatkal/submitaccident.php?qr=1840', '2025-10-13 17:11:55', NULL, NULL, NULL, NULL),
(1973, 1841, 'apatkal/submitaccident.php?qr=1841', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1974, 1842, 'apatkal/submitaccident.php?qr=1842', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1975, 1843, 'apatkal/submitaccident.php?qr=1843', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1976, 1844, 'apatkal/submitaccident.php?qr=1844', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1977, 1845, 'apatkal/submitaccident.php?qr=1845', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1978, 1846, 'apatkal/submitaccident.php?qr=1846', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1979, 1847, 'apatkal/submitaccident.php?qr=1847', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1980, 1848, 'apatkal/submitaccident.php?qr=1848', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1981, 1849, 'apatkal/submitaccident.php?qr=1849', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1982, 1850, 'apatkal/submitaccident.php?qr=1850', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1983, 1851, 'apatkal/submitaccident.php?qr=1851', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1984, 1852, 'apatkal/submitaccident.php?qr=1852', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1985, 1853, 'apatkal/submitaccident.php?qr=1853', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1986, 1854, 'apatkal/submitaccident.php?qr=1854', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1987, 1855, 'apatkal/submitaccident.php?qr=1855', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1988, 1856, 'apatkal/submitaccident.php?qr=1856', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1989, 1857, 'apatkal/submitaccident.php?qr=1857', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1990, 1858, 'apatkal/submitaccident.php?qr=1858', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1991, 1859, 'apatkal/submitaccident.php?qr=1859', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1992, 1860, 'apatkal/submitaccident.php?qr=1860', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1993, 1861, 'apatkal/submitaccident.php?qr=1861', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1994, 1862, 'apatkal/submitaccident.php?qr=1862', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1995, 1863, 'apatkal/submitaccident.php?qr=1863', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1996, 1864, 'apatkal/submitaccident.php?qr=1864', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1997, 1865, 'apatkal/submitaccident.php?qr=1865', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1998, 1866, 'apatkal/submitaccident.php?qr=1866', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(1999, 1867, 'apatkal/submitaccident.php?qr=1867', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2000, 1868, 'apatkal/submitaccident.php?qr=1868', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2001, 1869, 'apatkal/submitaccident.php?qr=1869', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2002, 1870, 'apatkal/submitaccident.php?qr=1870', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2003, 1871, 'apatkal/submitaccident.php?qr=1871', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2004, 1872, 'apatkal/submitaccident.php?qr=1872', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2005, 1873, 'apatkal/submitaccident.php?qr=1873', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2006, 1874, 'apatkal/submitaccident.php?qr=1874', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2007, 1875, 'apatkal/submitaccident.php?qr=1875', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2008, 1876, 'apatkal/submitaccident.php?qr=1876', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2009, 1877, 'apatkal/submitaccident.php?qr=1877', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2010, 1878, 'apatkal/submitaccident.php?qr=1878', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2011, 1879, 'apatkal/submitaccident.php?qr=1879', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2012, 1880, 'apatkal/submitaccident.php?qr=1880', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2013, 1881, 'apatkal/submitaccident.php?qr=1881', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2014, 1882, 'apatkal/submitaccident.php?qr=1882', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2015, 1883, 'apatkal/submitaccident.php?qr=1883', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2016, 1884, 'apatkal/submitaccident.php?qr=1884', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2017, 1885, 'apatkal/submitaccident.php?qr=1885', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2018, 1886, 'apatkal/submitaccident.php?qr=1886', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2019, 1887, 'apatkal/submitaccident.php?qr=1887', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2020, 1888, 'apatkal/submitaccident.php?qr=1888', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2021, 1889, 'apatkal/submitaccident.php?qr=1889', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2022, 1890, 'apatkal/submitaccident.php?qr=1890', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2023, 1891, 'apatkal/submitaccident.php?qr=1891', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2024, 1892, 'apatkal/submitaccident.php?qr=1892', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2025, 1893, 'apatkal/submitaccident.php?qr=1893', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2026, 1894, 'apatkal/submitaccident.php?qr=1894', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2027, 1895, 'apatkal/submitaccident.php?qr=1895', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2028, 1896, 'apatkal/submitaccident.php?qr=1896', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2029, 1897, 'apatkal/submitaccident.php?qr=1897', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2030, 1898, 'apatkal/submitaccident.php?qr=1898', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2031, 1899, 'apatkal/submitaccident.php?qr=1899', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2032, 1900, 'apatkal/submitaccident.php?qr=1900', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2033, 1901, 'apatkal/submitaccident.php?qr=1901', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2034, 1902, 'apatkal/submitaccident.php?qr=1902', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2035, 1903, 'apatkal/submitaccident.php?qr=1903', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2036, 1904, 'apatkal/submitaccident.php?qr=1904', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2037, 1905, 'apatkal/submitaccident.php?qr=1905', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2038, 1906, 'apatkal/submitaccident.php?qr=1906', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2039, 1907, 'apatkal/submitaccident.php?qr=1907', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2040, 1908, 'apatkal/submitaccident.php?qr=1908', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2041, 1909, 'apatkal/submitaccident.php?qr=1909', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2042, 1910, 'apatkal/submitaccident.php?qr=1910', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2043, 1911, 'apatkal/submitaccident.php?qr=1911', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2044, 1912, 'apatkal/submitaccident.php?qr=1912', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2045, 1913, 'apatkal/submitaccident.php?qr=1913', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2046, 1914, 'apatkal/submitaccident.php?qr=1914', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2047, 1915, 'apatkal/submitaccident.php?qr=1915', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2048, 1916, 'apatkal/submitaccident.php?qr=1916', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2049, 1917, 'apatkal/submitaccident.php?qr=1917', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2050, 1918, 'apatkal/submitaccident.php?qr=1918', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2051, 1919, 'apatkal/submitaccident.php?qr=1919', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2052, 1920, 'apatkal/submitaccident.php?qr=1920', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2053, 1921, 'apatkal/submitaccident.php?qr=1921', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2054, 1922, 'apatkal/submitaccident.php?qr=1922', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2055, 1923, 'apatkal/submitaccident.php?qr=1923', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2056, 1924, 'apatkal/submitaccident.php?qr=1924', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2057, 1925, 'apatkal/submitaccident.php?qr=1925', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2058, 1926, 'apatkal/submitaccident.php?qr=1926', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2059, 1927, 'apatkal/submitaccident.php?qr=1927', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2060, 1928, 'apatkal/submitaccident.php?qr=1928', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2061, 1929, 'apatkal/submitaccident.php?qr=1929', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2062, 1930, 'apatkal/submitaccident.php?qr=1930', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2063, 1931, 'apatkal/submitaccident.php?qr=1931', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2064, 1932, 'apatkal/submitaccident.php?qr=1932', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2065, 1933, 'apatkal/submitaccident.php?qr=1933', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2066, 1934, 'apatkal/submitaccident.php?qr=1934', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2067, 1935, 'apatkal/submitaccident.php?qr=1935', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2068, 1936, 'apatkal/submitaccident.php?qr=1936', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2069, 1937, 'apatkal/submitaccident.php?qr=1937', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2070, 1938, 'apatkal/submitaccident.php?qr=1938', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2071, 1939, 'apatkal/submitaccident.php?qr=1939', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2072, 1940, 'apatkal/submitaccident.php?qr=1940', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2073, 1941, 'apatkal/submitaccident.php?qr=1941', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2074, 1942, 'apatkal/submitaccident.php?qr=1942', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2075, 1943, 'apatkal/submitaccident.php?qr=1943', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2076, 1944, 'apatkal/submitaccident.php?qr=1944', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2077, 1945, 'apatkal/submitaccident.php?qr=1945', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2078, 1946, 'apatkal/submitaccident.php?qr=1946', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2079, 1947, 'apatkal/submitaccident.php?qr=1947', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2080, 1948, 'apatkal/submitaccident.php?qr=1948', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2081, 1949, 'apatkal/submitaccident.php?qr=1949', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2082, 1950, 'apatkal/submitaccident.php?qr=1950', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2083, 1951, 'apatkal/submitaccident.php?qr=1951', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2084, 1952, 'apatkal/submitaccident.php?qr=1952', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2085, 1953, 'apatkal/submitaccident.php?qr=1953', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2086, 1954, 'apatkal/submitaccident.php?qr=1954', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2087, 1955, 'apatkal/submitaccident.php?qr=1955', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2088, 1956, 'apatkal/submitaccident.php?qr=1956', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2089, 1957, 'apatkal/submitaccident.php?qr=1957', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2090, 1958, 'apatkal/submitaccident.php?qr=1958', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2091, 1959, 'apatkal/submitaccident.php?qr=1959', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2092, 1960, 'apatkal/submitaccident.php?qr=1960', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2093, 1961, 'apatkal/submitaccident.php?qr=1961', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2094, 1962, 'apatkal/submitaccident.php?qr=1962', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2095, 1963, 'apatkal/submitaccident.php?qr=1963', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2096, 1964, 'apatkal/submitaccident.php?qr=1964', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2097, 1965, 'apatkal/submitaccident.php?qr=1965', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2098, 1966, 'apatkal/submitaccident.php?qr=1966', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2099, 1967, 'apatkal/submitaccident.php?qr=1967', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2100, 1968, 'apatkal/submitaccident.php?qr=1968', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2101, 1969, 'apatkal/submitaccident.php?qr=1969', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2102, 1970, 'apatkal/submitaccident.php?qr=1970', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2103, 1971, 'apatkal/submitaccident.php?qr=1971', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2104, 1972, 'apatkal/submitaccident.php?qr=1972', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2105, 1973, 'apatkal/submitaccident.php?qr=1973', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2106, 1974, 'apatkal/submitaccident.php?qr=1974', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2107, 1975, 'apatkal/submitaccident.php?qr=1975', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2108, 1976, 'apatkal/submitaccident.php?qr=1976', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2109, 1977, 'apatkal/submitaccident.php?qr=1977', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2110, 1978, 'apatkal/submitaccident.php?qr=1978', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2111, 1979, 'apatkal/submitaccident.php?qr=1979', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2112, 1980, 'apatkal/submitaccident.php?qr=1980', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2113, 1981, 'apatkal/submitaccident.php?qr=1981', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2114, 1982, 'apatkal/submitaccident.php?qr=1982', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2115, 1983, 'apatkal/submitaccident.php?qr=1983', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2116, 1984, 'apatkal/submitaccident.php?qr=1984', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2117, 1985, 'apatkal/submitaccident.php?qr=1985', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2118, 1986, 'apatkal/submitaccident.php?qr=1986', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2119, 1987, 'apatkal/submitaccident.php?qr=1987', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2120, 1988, 'apatkal/submitaccident.php?qr=1988', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2121, 1989, 'apatkal/submitaccident.php?qr=1989', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2122, 1990, 'apatkal/submitaccident.php?qr=1990', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2123, 1991, 'apatkal/submitaccident.php?qr=1991', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2124, 1992, 'apatkal/submitaccident.php?qr=1992', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2125, 1993, 'apatkal/submitaccident.php?qr=1993', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2126, 1994, 'apatkal/submitaccident.php?qr=1994', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2127, 1995, 'apatkal/submitaccident.php?qr=1995', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2128, 1996, 'apatkal/submitaccident.php?qr=1996', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2129, 1997, 'apatkal/submitaccident.php?qr=1997', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2130, 1998, 'apatkal/submitaccident.php?qr=1998', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2131, 1999, 'apatkal/submitaccident.php?qr=1999', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2132, 2000, 'apatkal/submitaccident.php?qr=2000', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2133, 2001, 'apatkal/submitaccident.php?qr=2001', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2134, 2002, 'apatkal/submitaccident.php?qr=2002', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2135, 2003, 'apatkal/submitaccident.php?qr=2003', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2136, 2004, 'apatkal/submitaccident.php?qr=2004', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2137, 2005, 'apatkal/submitaccident.php?qr=2005', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2138, 2006, 'apatkal/submitaccident.php?qr=2006', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2139, 2007, 'apatkal/submitaccident.php?qr=2007', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2140, 2008, 'apatkal/submitaccident.php?qr=2008', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2141, 2009, 'apatkal/submitaccident.php?qr=2009', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2142, 2010, 'apatkal/submitaccident.php?qr=2010', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2143, 2011, 'apatkal/submitaccident.php?qr=2011', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2144, 2012, 'apatkal/submitaccident.php?qr=2012', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2145, 2013, 'apatkal/submitaccident.php?qr=2013', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2146, 2014, 'apatkal/submitaccident.php?qr=2014', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2147, 2015, 'apatkal/submitaccident.php?qr=2015', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2148, 2016, 'apatkal/submitaccident.php?qr=2016', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2149, 2017, 'apatkal/submitaccident.php?qr=2017', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2150, 2018, 'apatkal/submitaccident.php?qr=2018', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2151, 2019, 'apatkal/submitaccident.php?qr=2019', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2152, 2020, 'apatkal/submitaccident.php?qr=2020', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2153, 2021, 'apatkal/submitaccident.php?qr=2021', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2154, 2022, 'apatkal/submitaccident.php?qr=2022', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2155, 2023, 'apatkal/submitaccident.php?qr=2023', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2156, 2024, 'apatkal/submitaccident.php?qr=2024', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2157, 2025, 'apatkal/submitaccident.php?qr=2025', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2158, 2026, 'apatkal/submitaccident.php?qr=2026', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2159, 2027, 'apatkal/submitaccident.php?qr=2027', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2160, 2028, 'apatkal/submitaccident.php?qr=2028', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2161, 2029, 'apatkal/submitaccident.php?qr=2029', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2162, 2030, 'apatkal/submitaccident.php?qr=2030', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2163, 2031, 'apatkal/submitaccident.php?qr=2031', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2164, 2032, 'apatkal/submitaccident.php?qr=2032', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2165, 2033, 'apatkal/submitaccident.php?qr=2033', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2166, 2034, 'apatkal/submitaccident.php?qr=2034', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2167, 2035, 'apatkal/submitaccident.php?qr=2035', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2168, 2036, 'apatkal/submitaccident.php?qr=2036', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2169, 2037, 'apatkal/submitaccident.php?qr=2037', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2170, 2038, 'apatkal/submitaccident.php?qr=2038', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2171, 2039, 'apatkal/submitaccident.php?qr=2039', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2172, 2040, 'apatkal/submitaccident.php?qr=2040', '2025-10-13 17:23:32', NULL, NULL, NULL, NULL),
(2173, 2041, 'apatkal/submitaccident.php?qr=2041', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2174, 2042, 'apatkal/submitaccident.php?qr=2042', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2175, 2043, 'apatkal/submitaccident.php?qr=2043', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2176, 2044, 'apatkal/submitaccident.php?qr=2044', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2177, 2045, 'apatkal/submitaccident.php?qr=2045', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2178, 2046, 'apatkal/submitaccident.php?qr=2046', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2179, 2047, 'apatkal/submitaccident.php?qr=2047', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2180, 2048, 'apatkal/submitaccident.php?qr=2048', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2181, 2049, 'apatkal/submitaccident.php?qr=2049', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2182, 2050, 'apatkal/submitaccident.php?qr=2050', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2183, 2051, 'apatkal/submitaccident.php?qr=2051', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2184, 2052, 'apatkal/submitaccident.php?qr=2052', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2185, 2053, 'apatkal/submitaccident.php?qr=2053', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2186, 2054, 'apatkal/submitaccident.php?qr=2054', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2187, 2055, 'apatkal/submitaccident.php?qr=2055', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2188, 2056, 'apatkal/submitaccident.php?qr=2056', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2189, 2057, 'apatkal/submitaccident.php?qr=2057', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2190, 2058, 'apatkal/submitaccident.php?qr=2058', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2191, 2059, 'apatkal/submitaccident.php?qr=2059', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2192, 2060, 'apatkal/submitaccident.php?qr=2060', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2193, 2061, 'apatkal/submitaccident.php?qr=2061', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2194, 2062, 'apatkal/submitaccident.php?qr=2062', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2195, 2063, 'apatkal/submitaccident.php?qr=2063', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2196, 2064, 'apatkal/submitaccident.php?qr=2064', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2197, 2065, 'apatkal/submitaccident.php?qr=2065', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2198, 2066, 'apatkal/submitaccident.php?qr=2066', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2199, 2067, 'apatkal/submitaccident.php?qr=2067', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2200, 2068, 'apatkal/submitaccident.php?qr=2068', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2201, 2069, 'apatkal/submitaccident.php?qr=2069', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2202, 2070, 'apatkal/submitaccident.php?qr=2070', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2203, 2071, 'apatkal/submitaccident.php?qr=2071', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2204, 2072, 'apatkal/submitaccident.php?qr=2072', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2205, 2073, 'apatkal/submitaccident.php?qr=2073', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2206, 2074, 'apatkal/submitaccident.php?qr=2074', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2207, 2075, 'apatkal/submitaccident.php?qr=2075', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2208, 2076, 'apatkal/submitaccident.php?qr=2076', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2209, 2077, 'apatkal/submitaccident.php?qr=2077', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2210, 2078, 'apatkal/submitaccident.php?qr=2078', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2211, 2079, 'apatkal/submitaccident.php?qr=2079', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2212, 2080, 'apatkal/submitaccident.php?qr=2080', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2213, 2081, 'apatkal/submitaccident.php?qr=2081', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2214, 2082, 'apatkal/submitaccident.php?qr=2082', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2215, 2083, 'apatkal/submitaccident.php?qr=2083', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2216, 2084, 'apatkal/submitaccident.php?qr=2084', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2217, 2085, 'apatkal/submitaccident.php?qr=2085', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2218, 2086, 'apatkal/submitaccident.php?qr=2086', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2219, 2087, 'apatkal/submitaccident.php?qr=2087', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2220, 2088, 'apatkal/submitaccident.php?qr=2088', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2221, 2089, 'apatkal/submitaccident.php?qr=2089', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2222, 2090, 'apatkal/submitaccident.php?qr=2090', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2223, 2091, 'apatkal/submitaccident.php?qr=2091', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2224, 2092, 'apatkal/submitaccident.php?qr=2092', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2225, 2093, 'apatkal/submitaccident.php?qr=2093', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2226, 2094, 'apatkal/submitaccident.php?qr=2094', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2227, 2095, 'apatkal/submitaccident.php?qr=2095', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2228, 2096, 'apatkal/submitaccident.php?qr=2096', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2229, 2097, 'apatkal/submitaccident.php?qr=2097', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2230, 2098, 'apatkal/submitaccident.php?qr=2098', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2231, 2099, 'apatkal/submitaccident.php?qr=2099', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2232, 2100, 'apatkal/submitaccident.php?qr=2100', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2233, 2101, 'apatkal/submitaccident.php?qr=2101', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2234, 2102, 'apatkal/submitaccident.php?qr=2102', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2235, 2103, 'apatkal/submitaccident.php?qr=2103', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2236, 2104, 'apatkal/submitaccident.php?qr=2104', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2237, 2105, 'apatkal/submitaccident.php?qr=2105', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2238, 2106, 'apatkal/submitaccident.php?qr=2106', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2239, 2107, 'apatkal/submitaccident.php?qr=2107', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2240, 2108, 'apatkal/submitaccident.php?qr=2108', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2241, 2109, 'apatkal/submitaccident.php?qr=2109', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2242, 2110, 'apatkal/submitaccident.php?qr=2110', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2243, 2111, 'apatkal/submitaccident.php?qr=2111', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2244, 2112, 'apatkal/submitaccident.php?qr=2112', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2245, 2113, 'apatkal/submitaccident.php?qr=2113', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2246, 2114, 'apatkal/submitaccident.php?qr=2114', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2247, 2115, 'apatkal/submitaccident.php?qr=2115', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2248, 2116, 'apatkal/submitaccident.php?qr=2116', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2249, 2117, 'apatkal/submitaccident.php?qr=2117', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2250, 2118, 'apatkal/submitaccident.php?qr=2118', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2251, 2119, 'apatkal/submitaccident.php?qr=2119', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2252, 2120, 'apatkal/submitaccident.php?qr=2120', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2253, 2121, 'apatkal/submitaccident.php?qr=2121', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2254, 2122, 'apatkal/submitaccident.php?qr=2122', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2255, 2123, 'apatkal/submitaccident.php?qr=2123', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2256, 2124, 'apatkal/submitaccident.php?qr=2124', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2257, 2125, 'apatkal/submitaccident.php?qr=2125', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2258, 2126, 'apatkal/submitaccident.php?qr=2126', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2259, 2127, 'apatkal/submitaccident.php?qr=2127', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2260, 2128, 'apatkal/submitaccident.php?qr=2128', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2261, 2129, 'apatkal/submitaccident.php?qr=2129', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2262, 2130, 'apatkal/submitaccident.php?qr=2130', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2263, 2131, 'apatkal/submitaccident.php?qr=2131', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2264, 2132, 'apatkal/submitaccident.php?qr=2132', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2265, 2133, 'apatkal/submitaccident.php?qr=2133', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2266, 2134, 'apatkal/submitaccident.php?qr=2134', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2267, 2135, 'apatkal/submitaccident.php?qr=2135', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2268, 2136, 'apatkal/submitaccident.php?qr=2136', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2269, 2137, 'apatkal/submitaccident.php?qr=2137', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2270, 2138, 'apatkal/submitaccident.php?qr=2138', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2271, 2139, 'apatkal/submitaccident.php?qr=2139', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2272, 2140, 'apatkal/submitaccident.php?qr=2140', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2273, 2141, 'apatkal/submitaccident.php?qr=2141', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2274, 2142, 'apatkal/submitaccident.php?qr=2142', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2275, 2143, 'apatkal/submitaccident.php?qr=2143', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2276, 2144, 'apatkal/submitaccident.php?qr=2144', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2277, 2145, 'apatkal/submitaccident.php?qr=2145', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2278, 2146, 'apatkal/submitaccident.php?qr=2146', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2279, 2147, 'apatkal/submitaccident.php?qr=2147', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2280, 2148, 'apatkal/submitaccident.php?qr=2148', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2281, 2149, 'apatkal/submitaccident.php?qr=2149', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2282, 2150, 'apatkal/submitaccident.php?qr=2150', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2283, 2151, 'apatkal/submitaccident.php?qr=2151', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2284, 2152, 'apatkal/submitaccident.php?qr=2152', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2285, 2153, 'apatkal/submitaccident.php?qr=2153', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2286, 2154, 'apatkal/submitaccident.php?qr=2154', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2287, 2155, 'apatkal/submitaccident.php?qr=2155', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2288, 2156, 'apatkal/submitaccident.php?qr=2156', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2289, 2157, 'apatkal/submitaccident.php?qr=2157', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2290, 2158, 'apatkal/submitaccident.php?qr=2158', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2291, 2159, 'apatkal/submitaccident.php?qr=2159', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2292, 2160, 'apatkal/submitaccident.php?qr=2160', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2293, 2161, 'apatkal/submitaccident.php?qr=2161', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2294, 2162, 'apatkal/submitaccident.php?qr=2162', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL);
INSERT INTO `qr_codes` (`id`, `qr_number`, `qr_url`, `created_at`, `vehicle_number`, `full_name`, `phone`, `last_used_at`) VALUES
(2295, 2163, 'apatkal/submitaccident.php?qr=2163', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2296, 2164, 'apatkal/submitaccident.php?qr=2164', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2297, 2165, 'apatkal/submitaccident.php?qr=2165', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2298, 2166, 'apatkal/submitaccident.php?qr=2166', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2299, 2167, 'apatkal/submitaccident.php?qr=2167', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2300, 2168, 'apatkal/submitaccident.php?qr=2168', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2301, 2169, 'apatkal/submitaccident.php?qr=2169', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2302, 2170, 'apatkal/submitaccident.php?qr=2170', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2303, 2171, 'apatkal/submitaccident.php?qr=2171', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2304, 2172, 'apatkal/submitaccident.php?qr=2172', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2305, 2173, 'apatkal/submitaccident.php?qr=2173', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2306, 2174, 'apatkal/submitaccident.php?qr=2174', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2307, 2175, 'apatkal/submitaccident.php?qr=2175', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2308, 2176, 'apatkal/submitaccident.php?qr=2176', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2309, 2177, 'apatkal/submitaccident.php?qr=2177', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2310, 2178, 'apatkal/submitaccident.php?qr=2178', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2311, 2179, 'apatkal/submitaccident.php?qr=2179', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2312, 2180, 'apatkal/submitaccident.php?qr=2180', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2313, 2181, 'apatkal/submitaccident.php?qr=2181', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2314, 2182, 'apatkal/submitaccident.php?qr=2182', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2315, 2183, 'apatkal/submitaccident.php?qr=2183', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2316, 2184, 'apatkal/submitaccident.php?qr=2184', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2317, 2185, 'apatkal/submitaccident.php?qr=2185', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2318, 2186, 'apatkal/submitaccident.php?qr=2186', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2319, 2187, 'apatkal/submitaccident.php?qr=2187', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2320, 2188, 'apatkal/submitaccident.php?qr=2188', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2321, 2189, 'apatkal/submitaccident.php?qr=2189', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2322, 2190, 'apatkal/submitaccident.php?qr=2190', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2323, 2191, 'apatkal/submitaccident.php?qr=2191', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2324, 2192, 'apatkal/submitaccident.php?qr=2192', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2325, 2193, 'apatkal/submitaccident.php?qr=2193', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2326, 2194, 'apatkal/submitaccident.php?qr=2194', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2327, 2195, 'apatkal/submitaccident.php?qr=2195', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2328, 2196, 'apatkal/submitaccident.php?qr=2196', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2329, 2197, 'apatkal/submitaccident.php?qr=2197', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2330, 2198, 'apatkal/submitaccident.php?qr=2198', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2331, 2199, 'apatkal/submitaccident.php?qr=2199', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2332, 2200, 'apatkal/submitaccident.php?qr=2200', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2333, 2201, 'apatkal/submitaccident.php?qr=2201', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2334, 2202, 'apatkal/submitaccident.php?qr=2202', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2335, 2203, 'apatkal/submitaccident.php?qr=2203', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2336, 2204, 'apatkal/submitaccident.php?qr=2204', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2337, 2205, 'apatkal/submitaccident.php?qr=2205', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2338, 2206, 'apatkal/submitaccident.php?qr=2206', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2339, 2207, 'apatkal/submitaccident.php?qr=2207', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2340, 2208, 'apatkal/submitaccident.php?qr=2208', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2341, 2209, 'apatkal/submitaccident.php?qr=2209', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2342, 2210, 'apatkal/submitaccident.php?qr=2210', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2343, 2211, 'apatkal/submitaccident.php?qr=2211', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2344, 2212, 'apatkal/submitaccident.php?qr=2212', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2345, 2213, 'apatkal/submitaccident.php?qr=2213', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2346, 2214, 'apatkal/submitaccident.php?qr=2214', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2347, 2215, 'apatkal/submitaccident.php?qr=2215', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2348, 2216, 'apatkal/submitaccident.php?qr=2216', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2349, 2217, 'apatkal/submitaccident.php?qr=2217', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2350, 2218, 'apatkal/submitaccident.php?qr=2218', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2351, 2219, 'apatkal/submitaccident.php?qr=2219', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2352, 2220, 'apatkal/submitaccident.php?qr=2220', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2353, 2221, 'apatkal/submitaccident.php?qr=2221', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2354, 2222, 'apatkal/submitaccident.php?qr=2222', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2355, 2223, 'apatkal/submitaccident.php?qr=2223', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2356, 2224, 'apatkal/submitaccident.php?qr=2224', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2357, 2225, 'apatkal/submitaccident.php?qr=2225', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2358, 2226, 'apatkal/submitaccident.php?qr=2226', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2359, 2227, 'apatkal/submitaccident.php?qr=2227', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2360, 2228, 'apatkal/submitaccident.php?qr=2228', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2361, 2229, 'apatkal/submitaccident.php?qr=2229', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2362, 2230, 'apatkal/submitaccident.php?qr=2230', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2363, 2231, 'apatkal/submitaccident.php?qr=2231', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2364, 2232, 'apatkal/submitaccident.php?qr=2232', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2365, 2233, 'apatkal/submitaccident.php?qr=2233', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2366, 2234, 'apatkal/submitaccident.php?qr=2234', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2367, 2235, 'apatkal/submitaccident.php?qr=2235', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2368, 2236, 'apatkal/submitaccident.php?qr=2236', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2369, 2237, 'apatkal/submitaccident.php?qr=2237', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2370, 2238, 'apatkal/submitaccident.php?qr=2238', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2371, 2239, 'apatkal/submitaccident.php?qr=2239', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2372, 2240, 'apatkal/submitaccident.php?qr=2240', '2025-10-13 17:24:30', NULL, NULL, NULL, NULL),
(2373, 2241, 'apatkal/submitaccident.php?qr=2241', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2374, 2242, 'apatkal/submitaccident.php?qr=2242', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2375, 2243, 'apatkal/submitaccident.php?qr=2243', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2376, 2244, 'apatkal/submitaccident.php?qr=2244', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2377, 2245, 'apatkal/submitaccident.php?qr=2245', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2378, 2246, 'apatkal/submitaccident.php?qr=2246', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2379, 2247, 'apatkal/submitaccident.php?qr=2247', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2380, 2248, 'apatkal/submitaccident.php?qr=2248', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2381, 2249, 'apatkal/submitaccident.php?qr=2249', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2382, 2250, 'apatkal/submitaccident.php?qr=2250', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2383, 2251, 'apatkal/submitaccident.php?qr=2251', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2384, 2252, 'apatkal/submitaccident.php?qr=2252', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2385, 2253, 'apatkal/submitaccident.php?qr=2253', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2386, 2254, 'apatkal/submitaccident.php?qr=2254', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2387, 2255, 'apatkal/submitaccident.php?qr=2255', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2388, 2256, 'apatkal/submitaccident.php?qr=2256', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2389, 2257, 'apatkal/submitaccident.php?qr=2257', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2390, 2258, 'apatkal/submitaccident.php?qr=2258', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2391, 2259, 'apatkal/submitaccident.php?qr=2259', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2392, 2260, 'apatkal/submitaccident.php?qr=2260', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2393, 2261, 'apatkal/submitaccident.php?qr=2261', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2394, 2262, 'apatkal/submitaccident.php?qr=2262', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2395, 2263, 'apatkal/submitaccident.php?qr=2263', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2396, 2264, 'apatkal/submitaccident.php?qr=2264', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2397, 2265, 'apatkal/submitaccident.php?qr=2265', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2398, 2266, 'apatkal/submitaccident.php?qr=2266', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2399, 2267, 'apatkal/submitaccident.php?qr=2267', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2400, 2268, 'apatkal/submitaccident.php?qr=2268', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2401, 2269, 'apatkal/submitaccident.php?qr=2269', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2402, 2270, 'apatkal/submitaccident.php?qr=2270', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2403, 2271, 'apatkal/submitaccident.php?qr=2271', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2404, 2272, 'apatkal/submitaccident.php?qr=2272', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2405, 2273, 'apatkal/submitaccident.php?qr=2273', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2406, 2274, 'apatkal/submitaccident.php?qr=2274', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2407, 2275, 'apatkal/submitaccident.php?qr=2275', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2408, 2276, 'apatkal/submitaccident.php?qr=2276', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2409, 2277, 'apatkal/submitaccident.php?qr=2277', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2410, 2278, 'apatkal/submitaccident.php?qr=2278', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2411, 2279, 'apatkal/submitaccident.php?qr=2279', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2412, 2280, 'apatkal/submitaccident.php?qr=2280', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2413, 2281, 'apatkal/submitaccident.php?qr=2281', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2414, 2282, 'apatkal/submitaccident.php?qr=2282', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2415, 2283, 'apatkal/submitaccident.php?qr=2283', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2416, 2284, 'apatkal/submitaccident.php?qr=2284', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2417, 2285, 'apatkal/submitaccident.php?qr=2285', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2418, 2286, 'apatkal/submitaccident.php?qr=2286', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2419, 2287, 'apatkal/submitaccident.php?qr=2287', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2420, 2288, 'apatkal/submitaccident.php?qr=2288', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2421, 2289, 'apatkal/submitaccident.php?qr=2289', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2422, 2290, 'apatkal/submitaccident.php?qr=2290', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2423, 2291, 'apatkal/submitaccident.php?qr=2291', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2424, 2292, 'apatkal/submitaccident.php?qr=2292', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2425, 2293, 'apatkal/submitaccident.php?qr=2293', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2426, 2294, 'apatkal/submitaccident.php?qr=2294', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2427, 2295, 'apatkal/submitaccident.php?qr=2295', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2428, 2296, 'apatkal/submitaccident.php?qr=2296', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2429, 2297, 'apatkal/submitaccident.php?qr=2297', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2430, 2298, 'apatkal/submitaccident.php?qr=2298', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2431, 2299, 'apatkal/submitaccident.php?qr=2299', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2432, 2300, 'apatkal/submitaccident.php?qr=2300', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2433, 2301, 'apatkal/submitaccident.php?qr=2301', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2434, 2302, 'apatkal/submitaccident.php?qr=2302', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2435, 2303, 'apatkal/submitaccident.php?qr=2303', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2436, 2304, 'apatkal/submitaccident.php?qr=2304', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2437, 2305, 'apatkal/submitaccident.php?qr=2305', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2438, 2306, 'apatkal/submitaccident.php?qr=2306', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2439, 2307, 'apatkal/submitaccident.php?qr=2307', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2440, 2308, 'apatkal/submitaccident.php?qr=2308', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2441, 2309, 'apatkal/submitaccident.php?qr=2309', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2442, 2310, 'apatkal/submitaccident.php?qr=2310', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2443, 2311, 'apatkal/submitaccident.php?qr=2311', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2444, 2312, 'apatkal/submitaccident.php?qr=2312', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2445, 2313, 'apatkal/submitaccident.php?qr=2313', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2446, 2314, 'apatkal/submitaccident.php?qr=2314', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2447, 2315, 'apatkal/submitaccident.php?qr=2315', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2448, 2316, 'apatkal/submitaccident.php?qr=2316', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2449, 2317, 'apatkal/submitaccident.php?qr=2317', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2450, 2318, 'apatkal/submitaccident.php?qr=2318', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2451, 2319, 'apatkal/submitaccident.php?qr=2319', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2452, 2320, 'apatkal/submitaccident.php?qr=2320', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2453, 2321, 'apatkal/submitaccident.php?qr=2321', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2454, 2322, 'apatkal/submitaccident.php?qr=2322', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2455, 2323, 'apatkal/submitaccident.php?qr=2323', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2456, 2324, 'apatkal/submitaccident.php?qr=2324', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2457, 2325, 'apatkal/submitaccident.php?qr=2325', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2458, 2326, 'apatkal/submitaccident.php?qr=2326', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2459, 2327, 'apatkal/submitaccident.php?qr=2327', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2460, 2328, 'apatkal/submitaccident.php?qr=2328', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2461, 2329, 'apatkal/submitaccident.php?qr=2329', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2462, 2330, 'apatkal/submitaccident.php?qr=2330', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2463, 2331, 'apatkal/submitaccident.php?qr=2331', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2464, 2332, 'apatkal/submitaccident.php?qr=2332', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2465, 2333, 'apatkal/submitaccident.php?qr=2333', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2466, 2334, 'apatkal/submitaccident.php?qr=2334', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2467, 2335, 'apatkal/submitaccident.php?qr=2335', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2468, 2336, 'apatkal/submitaccident.php?qr=2336', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2469, 2337, 'apatkal/submitaccident.php?qr=2337', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2470, 2338, 'apatkal/submitaccident.php?qr=2338', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2471, 2339, 'apatkal/submitaccident.php?qr=2339', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2472, 2340, 'apatkal/submitaccident.php?qr=2340', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2473, 2341, 'apatkal/submitaccident.php?qr=2341', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2474, 2342, 'apatkal/submitaccident.php?qr=2342', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2475, 2343, 'apatkal/submitaccident.php?qr=2343', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2476, 2344, 'apatkal/submitaccident.php?qr=2344', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2477, 2345, 'apatkal/submitaccident.php?qr=2345', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2478, 2346, 'apatkal/submitaccident.php?qr=2346', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2479, 2347, 'apatkal/submitaccident.php?qr=2347', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2480, 2348, 'apatkal/submitaccident.php?qr=2348', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2481, 2349, 'apatkal/submitaccident.php?qr=2349', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2482, 2350, 'apatkal/submitaccident.php?qr=2350', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2483, 2351, 'apatkal/submitaccident.php?qr=2351', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2484, 2352, 'apatkal/submitaccident.php?qr=2352', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2485, 2353, 'apatkal/submitaccident.php?qr=2353', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2486, 2354, 'apatkal/submitaccident.php?qr=2354', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2487, 2355, 'apatkal/submitaccident.php?qr=2355', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2488, 2356, 'apatkal/submitaccident.php?qr=2356', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2489, 2357, 'apatkal/submitaccident.php?qr=2357', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2490, 2358, 'apatkal/submitaccident.php?qr=2358', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2491, 2359, 'apatkal/submitaccident.php?qr=2359', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2492, 2360, 'apatkal/submitaccident.php?qr=2360', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2493, 2361, 'apatkal/submitaccident.php?qr=2361', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2494, 2362, 'apatkal/submitaccident.php?qr=2362', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2495, 2363, 'apatkal/submitaccident.php?qr=2363', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2496, 2364, 'apatkal/submitaccident.php?qr=2364', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2497, 2365, 'apatkal/submitaccident.php?qr=2365', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2498, 2366, 'apatkal/submitaccident.php?qr=2366', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2499, 2367, 'apatkal/submitaccident.php?qr=2367', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2500, 2368, 'apatkal/submitaccident.php?qr=2368', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2501, 2369, 'apatkal/submitaccident.php?qr=2369', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2502, 2370, 'apatkal/submitaccident.php?qr=2370', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2503, 2371, 'apatkal/submitaccident.php?qr=2371', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2504, 2372, 'apatkal/submitaccident.php?qr=2372', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2505, 2373, 'apatkal/submitaccident.php?qr=2373', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2506, 2374, 'apatkal/submitaccident.php?qr=2374', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2507, 2375, 'apatkal/submitaccident.php?qr=2375', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2508, 2376, 'apatkal/submitaccident.php?qr=2376', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2509, 2377, 'apatkal/submitaccident.php?qr=2377', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2510, 2378, 'apatkal/submitaccident.php?qr=2378', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2511, 2379, 'apatkal/submitaccident.php?qr=2379', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2512, 2380, 'apatkal/submitaccident.php?qr=2380', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2513, 2381, 'apatkal/submitaccident.php?qr=2381', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2514, 2382, 'apatkal/submitaccident.php?qr=2382', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2515, 2383, 'apatkal/submitaccident.php?qr=2383', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2516, 2384, 'apatkal/submitaccident.php?qr=2384', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2517, 2385, 'apatkal/submitaccident.php?qr=2385', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2518, 2386, 'apatkal/submitaccident.php?qr=2386', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2519, 2387, 'apatkal/submitaccident.php?qr=2387', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2520, 2388, 'apatkal/submitaccident.php?qr=2388', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2521, 2389, 'apatkal/submitaccident.php?qr=2389', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2522, 2390, 'apatkal/submitaccident.php?qr=2390', '2025-10-13 17:25:12', NULL, NULL, NULL, NULL),
(2523, 2391, 'apatkal/submitaccident.php?qr=2391', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2524, 2392, 'apatkal/submitaccident.php?qr=2392', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2525, 2393, 'apatkal/submitaccident.php?qr=2393', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2526, 2394, 'apatkal/submitaccident.php?qr=2394', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2527, 2395, 'apatkal/submitaccident.php?qr=2395', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2528, 2396, 'apatkal/submitaccident.php?qr=2396', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2529, 2397, 'apatkal/submitaccident.php?qr=2397', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2530, 2398, 'apatkal/submitaccident.php?qr=2398', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2531, 2399, 'apatkal/submitaccident.php?qr=2399', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2532, 2400, 'apatkal/submitaccident.php?qr=2400', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2533, 2401, 'apatkal/submitaccident.php?qr=2401', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2534, 2402, 'apatkal/submitaccident.php?qr=2402', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2535, 2403, 'apatkal/submitaccident.php?qr=2403', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2536, 2404, 'apatkal/submitaccident.php?qr=2404', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2537, 2405, 'apatkal/submitaccident.php?qr=2405', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2538, 2406, 'apatkal/submitaccident.php?qr=2406', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2539, 2407, 'apatkal/submitaccident.php?qr=2407', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2540, 2408, 'apatkal/submitaccident.php?qr=2408', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2541, 2409, 'apatkal/submitaccident.php?qr=2409', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2542, 2410, 'apatkal/submitaccident.php?qr=2410', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2543, 2411, 'apatkal/submitaccident.php?qr=2411', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2544, 2412, 'apatkal/submitaccident.php?qr=2412', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2545, 2413, 'apatkal/submitaccident.php?qr=2413', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2546, 2414, 'apatkal/submitaccident.php?qr=2414', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2547, 2415, 'apatkal/submitaccident.php?qr=2415', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2548, 2416, 'apatkal/submitaccident.php?qr=2416', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2549, 2417, 'apatkal/submitaccident.php?qr=2417', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2550, 2418, 'apatkal/submitaccident.php?qr=2418', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2551, 2419, 'apatkal/submitaccident.php?qr=2419', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2552, 2420, 'apatkal/submitaccident.php?qr=2420', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2553, 2421, 'apatkal/submitaccident.php?qr=2421', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2554, 2422, 'apatkal/submitaccident.php?qr=2422', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2555, 2423, 'apatkal/submitaccident.php?qr=2423', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2556, 2424, 'apatkal/submitaccident.php?qr=2424', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2557, 2425, 'apatkal/submitaccident.php?qr=2425', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2558, 2426, 'apatkal/submitaccident.php?qr=2426', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2559, 2427, 'apatkal/submitaccident.php?qr=2427', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2560, 2428, 'apatkal/submitaccident.php?qr=2428', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2561, 2429, 'apatkal/submitaccident.php?qr=2429', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2562, 2430, 'apatkal/submitaccident.php?qr=2430', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2563, 2431, 'apatkal/submitaccident.php?qr=2431', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2564, 2432, 'apatkal/submitaccident.php?qr=2432', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2565, 2433, 'apatkal/submitaccident.php?qr=2433', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2566, 2434, 'apatkal/submitaccident.php?qr=2434', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2567, 2435, 'apatkal/submitaccident.php?qr=2435', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2568, 2436, 'apatkal/submitaccident.php?qr=2436', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2569, 2437, 'apatkal/submitaccident.php?qr=2437', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2570, 2438, 'apatkal/submitaccident.php?qr=2438', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2571, 2439, 'apatkal/submitaccident.php?qr=2439', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2572, 2440, 'apatkal/submitaccident.php?qr=2440', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2573, 2441, 'apatkal/submitaccident.php?qr=2441', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2574, 2442, 'apatkal/submitaccident.php?qr=2442', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2575, 2443, 'apatkal/submitaccident.php?qr=2443', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2576, 2444, 'apatkal/submitaccident.php?qr=2444', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2577, 2445, 'apatkal/submitaccident.php?qr=2445', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2578, 2446, 'apatkal/submitaccident.php?qr=2446', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2579, 2447, 'apatkal/submitaccident.php?qr=2447', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2580, 2448, 'apatkal/submitaccident.php?qr=2448', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2581, 2449, 'apatkal/submitaccident.php?qr=2449', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2582, 2450, 'apatkal/submitaccident.php?qr=2450', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2583, 2451, 'apatkal/submitaccident.php?qr=2451', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2584, 2452, 'apatkal/submitaccident.php?qr=2452', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2585, 2453, 'apatkal/submitaccident.php?qr=2453', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2586, 2454, 'apatkal/submitaccident.php?qr=2454', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2587, 2455, 'apatkal/submitaccident.php?qr=2455', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2588, 2456, 'apatkal/submitaccident.php?qr=2456', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2589, 2457, 'apatkal/submitaccident.php?qr=2457', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2590, 2458, 'apatkal/submitaccident.php?qr=2458', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2591, 2459, 'apatkal/submitaccident.php?qr=2459', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2592, 2460, 'apatkal/submitaccident.php?qr=2460', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2593, 2461, 'apatkal/submitaccident.php?qr=2461', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2594, 2462, 'apatkal/submitaccident.php?qr=2462', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2595, 2463, 'apatkal/submitaccident.php?qr=2463', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2596, 2464, 'apatkal/submitaccident.php?qr=2464', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2597, 2465, 'apatkal/submitaccident.php?qr=2465', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2598, 2466, 'apatkal/submitaccident.php?qr=2466', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2599, 2467, 'apatkal/submitaccident.php?qr=2467', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2600, 2468, 'apatkal/submitaccident.php?qr=2468', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2601, 2469, 'apatkal/submitaccident.php?qr=2469', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2602, 2470, 'apatkal/submitaccident.php?qr=2470', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2603, 2471, 'apatkal/submitaccident.php?qr=2471', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2604, 2472, 'apatkal/submitaccident.php?qr=2472', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2605, 2473, 'apatkal/submitaccident.php?qr=2473', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2606, 2474, 'apatkal/submitaccident.php?qr=2474', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2607, 2475, 'apatkal/submitaccident.php?qr=2475', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2608, 2476, 'apatkal/submitaccident.php?qr=2476', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2609, 2477, 'apatkal/submitaccident.php?qr=2477', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2610, 2478, 'apatkal/submitaccident.php?qr=2478', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2611, 2479, 'apatkal/submitaccident.php?qr=2479', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2612, 2480, 'apatkal/submitaccident.php?qr=2480', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2613, 2481, 'apatkal/submitaccident.php?qr=2481', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2614, 2482, 'apatkal/submitaccident.php?qr=2482', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2615, 2483, 'apatkal/submitaccident.php?qr=2483', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2616, 2484, 'apatkal/submitaccident.php?qr=2484', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2617, 2485, 'apatkal/submitaccident.php?qr=2485', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2618, 2486, 'apatkal/submitaccident.php?qr=2486', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2619, 2487, 'apatkal/submitaccident.php?qr=2487', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2620, 2488, 'apatkal/submitaccident.php?qr=2488', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2621, 2489, 'apatkal/submitaccident.php?qr=2489', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2622, 2490, 'apatkal/submitaccident.php?qr=2490', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2623, 2491, 'apatkal/submitaccident.php?qr=2491', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2624, 2492, 'apatkal/submitaccident.php?qr=2492', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2625, 2493, 'apatkal/submitaccident.php?qr=2493', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2626, 2494, 'apatkal/submitaccident.php?qr=2494', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2627, 2495, 'apatkal/submitaccident.php?qr=2495', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2628, 2496, 'apatkal/submitaccident.php?qr=2496', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2629, 2497, 'apatkal/submitaccident.php?qr=2497', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2630, 2498, 'apatkal/submitaccident.php?qr=2498', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2631, 2499, 'apatkal/submitaccident.php?qr=2499', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2632, 2500, 'apatkal/submitaccident.php?qr=2500', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2633, 2501, 'apatkal/submitaccident.php?qr=2501', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2634, 2502, 'apatkal/submitaccident.php?qr=2502', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2635, 2503, 'apatkal/submitaccident.php?qr=2503', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2636, 2504, 'apatkal/submitaccident.php?qr=2504', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2637, 2505, 'apatkal/submitaccident.php?qr=2505', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2638, 2506, 'apatkal/submitaccident.php?qr=2506', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2639, 2507, 'apatkal/submitaccident.php?qr=2507', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2640, 2508, 'apatkal/submitaccident.php?qr=2508', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2641, 2509, 'apatkal/submitaccident.php?qr=2509', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2642, 2510, 'apatkal/submitaccident.php?qr=2510', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2643, 2511, 'apatkal/submitaccident.php?qr=2511', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2644, 2512, 'apatkal/submitaccident.php?qr=2512', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2645, 2513, 'apatkal/submitaccident.php?qr=2513', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2646, 2514, 'apatkal/submitaccident.php?qr=2514', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2647, 2515, 'apatkal/submitaccident.php?qr=2515', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2648, 2516, 'apatkal/submitaccident.php?qr=2516', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2649, 2517, 'apatkal/submitaccident.php?qr=2517', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2650, 2518, 'apatkal/submitaccident.php?qr=2518', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2651, 2519, 'apatkal/submitaccident.php?qr=2519', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2652, 2520, 'apatkal/submitaccident.php?qr=2520', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2653, 2521, 'apatkal/submitaccident.php?qr=2521', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2654, 2522, 'apatkal/submitaccident.php?qr=2522', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2655, 2523, 'apatkal/submitaccident.php?qr=2523', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2656, 2524, 'apatkal/submitaccident.php?qr=2524', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2657, 2525, 'apatkal/submitaccident.php?qr=2525', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2658, 2526, 'apatkal/submitaccident.php?qr=2526', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2659, 2527, 'apatkal/submitaccident.php?qr=2527', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2660, 2528, 'apatkal/submitaccident.php?qr=2528', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2661, 2529, 'apatkal/submitaccident.php?qr=2529', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2662, 2530, 'apatkal/submitaccident.php?qr=2530', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2663, 2531, 'apatkal/submitaccident.php?qr=2531', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2664, 2532, 'apatkal/submitaccident.php?qr=2532', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2665, 2533, 'apatkal/submitaccident.php?qr=2533', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2666, 2534, 'apatkal/submitaccident.php?qr=2534', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2667, 2535, 'apatkal/submitaccident.php?qr=2535', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2668, 2536, 'apatkal/submitaccident.php?qr=2536', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2669, 2537, 'apatkal/submitaccident.php?qr=2537', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2670, 2538, 'apatkal/submitaccident.php?qr=2538', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2671, 2539, 'apatkal/submitaccident.php?qr=2539', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2672, 2540, 'apatkal/submitaccident.php?qr=2540', '2025-10-13 17:28:58', NULL, NULL, NULL, NULL),
(2673, 2541, 'apatkal/submitaccident.php?qr=2541', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2674, 2542, 'apatkal/submitaccident.php?qr=2542', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2675, 2543, 'apatkal/submitaccident.php?qr=2543', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2676, 2544, 'apatkal/submitaccident.php?qr=2544', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2677, 2545, 'apatkal/submitaccident.php?qr=2545', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2678, 2546, 'apatkal/submitaccident.php?qr=2546', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2679, 2547, 'apatkal/submitaccident.php?qr=2547', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2680, 2548, 'apatkal/submitaccident.php?qr=2548', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2681, 2549, 'apatkal/submitaccident.php?qr=2549', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2682, 2550, 'apatkal/submitaccident.php?qr=2550', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2683, 2551, 'apatkal/submitaccident.php?qr=2551', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2684, 2552, 'apatkal/submitaccident.php?qr=2552', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2685, 2553, 'apatkal/submitaccident.php?qr=2553', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2686, 2554, 'apatkal/submitaccident.php?qr=2554', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2687, 2555, 'apatkal/submitaccident.php?qr=2555', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2688, 2556, 'apatkal/submitaccident.php?qr=2556', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2689, 2557, 'apatkal/submitaccident.php?qr=2557', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2690, 2558, 'apatkal/submitaccident.php?qr=2558', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2691, 2559, 'apatkal/submitaccident.php?qr=2559', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2692, 2560, 'apatkal/submitaccident.php?qr=2560', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2693, 2561, 'apatkal/submitaccident.php?qr=2561', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2694, 2562, 'apatkal/submitaccident.php?qr=2562', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2695, 2563, 'apatkal/submitaccident.php?qr=2563', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2696, 2564, 'apatkal/submitaccident.php?qr=2564', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2697, 2565, 'apatkal/submitaccident.php?qr=2565', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2698, 2566, 'apatkal/submitaccident.php?qr=2566', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2699, 2567, 'apatkal/submitaccident.php?qr=2567', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2700, 2568, 'apatkal/submitaccident.php?qr=2568', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2701, 2569, 'apatkal/submitaccident.php?qr=2569', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2702, 2570, 'apatkal/submitaccident.php?qr=2570', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2703, 2571, 'apatkal/submitaccident.php?qr=2571', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2704, 2572, 'apatkal/submitaccident.php?qr=2572', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2705, 2573, 'apatkal/submitaccident.php?qr=2573', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2706, 2574, 'apatkal/submitaccident.php?qr=2574', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2707, 2575, 'apatkal/submitaccident.php?qr=2575', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2708, 2576, 'apatkal/submitaccident.php?qr=2576', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2709, 2577, 'apatkal/submitaccident.php?qr=2577', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2710, 2578, 'apatkal/submitaccident.php?qr=2578', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2711, 2579, 'apatkal/submitaccident.php?qr=2579', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2712, 2580, 'apatkal/submitaccident.php?qr=2580', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2713, 2581, 'apatkal/submitaccident.php?qr=2581', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2714, 2582, 'apatkal/submitaccident.php?qr=2582', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2715, 2583, 'apatkal/submitaccident.php?qr=2583', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2716, 2584, 'apatkal/submitaccident.php?qr=2584', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2717, 2585, 'apatkal/submitaccident.php?qr=2585', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2718, 2586, 'apatkal/submitaccident.php?qr=2586', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2719, 2587, 'apatkal/submitaccident.php?qr=2587', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2720, 2588, 'apatkal/submitaccident.php?qr=2588', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2721, 2589, 'apatkal/submitaccident.php?qr=2589', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2722, 2590, 'apatkal/submitaccident.php?qr=2590', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2723, 2591, 'apatkal/submitaccident.php?qr=2591', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2724, 2592, 'apatkal/submitaccident.php?qr=2592', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2725, 2593, 'apatkal/submitaccident.php?qr=2593', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2726, 2594, 'apatkal/submitaccident.php?qr=2594', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2727, 2595, 'apatkal/submitaccident.php?qr=2595', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2728, 2596, 'apatkal/submitaccident.php?qr=2596', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2729, 2597, 'apatkal/submitaccident.php?qr=2597', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2730, 2598, 'apatkal/submitaccident.php?qr=2598', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2731, 2599, 'apatkal/submitaccident.php?qr=2599', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2732, 2600, 'apatkal/submitaccident.php?qr=2600', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2733, 2601, 'apatkal/submitaccident.php?qr=2601', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2734, 2602, 'apatkal/submitaccident.php?qr=2602', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2735, 2603, 'apatkal/submitaccident.php?qr=2603', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2736, 2604, 'apatkal/submitaccident.php?qr=2604', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2737, 2605, 'apatkal/submitaccident.php?qr=2605', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2738, 2606, 'apatkal/submitaccident.php?qr=2606', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2739, 2607, 'apatkal/submitaccident.php?qr=2607', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2740, 2608, 'apatkal/submitaccident.php?qr=2608', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2741, 2609, 'apatkal/submitaccident.php?qr=2609', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2742, 2610, 'apatkal/submitaccident.php?qr=2610', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2743, 2611, 'apatkal/submitaccident.php?qr=2611', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2744, 2612, 'apatkal/submitaccident.php?qr=2612', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2745, 2613, 'apatkal/submitaccident.php?qr=2613', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2746, 2614, 'apatkal/submitaccident.php?qr=2614', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2747, 2615, 'apatkal/submitaccident.php?qr=2615', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2748, 2616, 'apatkal/submitaccident.php?qr=2616', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2749, 2617, 'apatkal/submitaccident.php?qr=2617', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2750, 2618, 'apatkal/submitaccident.php?qr=2618', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2751, 2619, 'apatkal/submitaccident.php?qr=2619', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2752, 2620, 'apatkal/submitaccident.php?qr=2620', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2753, 2621, 'apatkal/submitaccident.php?qr=2621', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2754, 2622, 'apatkal/submitaccident.php?qr=2622', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2755, 2623, 'apatkal/submitaccident.php?qr=2623', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2756, 2624, 'apatkal/submitaccident.php?qr=2624', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2757, 2625, 'apatkal/submitaccident.php?qr=2625', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2758, 2626, 'apatkal/submitaccident.php?qr=2626', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2759, 2627, 'apatkal/submitaccident.php?qr=2627', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2760, 2628, 'apatkal/submitaccident.php?qr=2628', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2761, 2629, 'apatkal/submitaccident.php?qr=2629', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2762, 2630, 'apatkal/submitaccident.php?qr=2630', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2763, 2631, 'apatkal/submitaccident.php?qr=2631', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2764, 2632, 'apatkal/submitaccident.php?qr=2632', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2765, 2633, 'apatkal/submitaccident.php?qr=2633', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2766, 2634, 'apatkal/submitaccident.php?qr=2634', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2767, 2635, 'apatkal/submitaccident.php?qr=2635', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2768, 2636, 'apatkal/submitaccident.php?qr=2636', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2769, 2637, 'apatkal/submitaccident.php?qr=2637', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2770, 2638, 'apatkal/submitaccident.php?qr=2638', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2771, 2639, 'apatkal/submitaccident.php?qr=2639', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2772, 2640, 'apatkal/submitaccident.php?qr=2640', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2773, 2641, 'apatkal/submitaccident.php?qr=2641', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2774, 2642, 'apatkal/submitaccident.php?qr=2642', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2775, 2643, 'apatkal/submitaccident.php?qr=2643', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2776, 2644, 'apatkal/submitaccident.php?qr=2644', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2777, 2645, 'apatkal/submitaccident.php?qr=2645', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2778, 2646, 'apatkal/submitaccident.php?qr=2646', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2779, 2647, 'apatkal/submitaccident.php?qr=2647', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2780, 2648, 'apatkal/submitaccident.php?qr=2648', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2781, 2649, 'apatkal/submitaccident.php?qr=2649', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2782, 2650, 'apatkal/submitaccident.php?qr=2650', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2783, 2651, 'apatkal/submitaccident.php?qr=2651', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2784, 2652, 'apatkal/submitaccident.php?qr=2652', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2785, 2653, 'apatkal/submitaccident.php?qr=2653', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2786, 2654, 'apatkal/submitaccident.php?qr=2654', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2787, 2655, 'apatkal/submitaccident.php?qr=2655', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2788, 2656, 'apatkal/submitaccident.php?qr=2656', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2789, 2657, 'apatkal/submitaccident.php?qr=2657', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2790, 2658, 'apatkal/submitaccident.php?qr=2658', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2791, 2659, 'apatkal/submitaccident.php?qr=2659', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2792, 2660, 'apatkal/submitaccident.php?qr=2660', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2793, 2661, 'apatkal/submitaccident.php?qr=2661', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2794, 2662, 'apatkal/submitaccident.php?qr=2662', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2795, 2663, 'apatkal/submitaccident.php?qr=2663', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2796, 2664, 'apatkal/submitaccident.php?qr=2664', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2797, 2665, 'apatkal/submitaccident.php?qr=2665', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2798, 2666, 'apatkal/submitaccident.php?qr=2666', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2799, 2667, 'apatkal/submitaccident.php?qr=2667', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2800, 2668, 'apatkal/submitaccident.php?qr=2668', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2801, 2669, 'apatkal/submitaccident.php?qr=2669', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2802, 2670, 'apatkal/submitaccident.php?qr=2670', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2803, 2671, 'apatkal/submitaccident.php?qr=2671', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2804, 2672, 'apatkal/submitaccident.php?qr=2672', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2805, 2673, 'apatkal/submitaccident.php?qr=2673', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2806, 2674, 'apatkal/submitaccident.php?qr=2674', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2807, 2675, 'apatkal/submitaccident.php?qr=2675', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2808, 2676, 'apatkal/submitaccident.php?qr=2676', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL);
INSERT INTO `qr_codes` (`id`, `qr_number`, `qr_url`, `created_at`, `vehicle_number`, `full_name`, `phone`, `last_used_at`) VALUES
(2809, 2677, 'apatkal/submitaccident.php?qr=2677', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2810, 2678, 'apatkal/submitaccident.php?qr=2678', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2811, 2679, 'apatkal/submitaccident.php?qr=2679', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2812, 2680, 'apatkal/submitaccident.php?qr=2680', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2813, 2681, 'apatkal/submitaccident.php?qr=2681', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2814, 2682, 'apatkal/submitaccident.php?qr=2682', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2815, 2683, 'apatkal/submitaccident.php?qr=2683', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2816, 2684, 'apatkal/submitaccident.php?qr=2684', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2817, 2685, 'apatkal/submitaccident.php?qr=2685', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2818, 2686, 'apatkal/submitaccident.php?qr=2686', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2819, 2687, 'apatkal/submitaccident.php?qr=2687', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2820, 2688, 'apatkal/submitaccident.php?qr=2688', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2821, 2689, 'apatkal/submitaccident.php?qr=2689', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2822, 2690, 'apatkal/submitaccident.php?qr=2690', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2823, 2691, 'apatkal/submitaccident.php?qr=2691', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2824, 2692, 'apatkal/submitaccident.php?qr=2692', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2825, 2693, 'apatkal/submitaccident.php?qr=2693', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2826, 2694, 'apatkal/submitaccident.php?qr=2694', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2827, 2695, 'apatkal/submitaccident.php?qr=2695', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2828, 2696, 'apatkal/submitaccident.php?qr=2696', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2829, 2697, 'apatkal/submitaccident.php?qr=2697', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2830, 2698, 'apatkal/submitaccident.php?qr=2698', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2831, 2699, 'apatkal/submitaccident.php?qr=2699', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2832, 2700, 'apatkal/submitaccident.php?qr=2700', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2833, 2701, 'apatkal/submitaccident.php?qr=2701', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2834, 2702, 'apatkal/submitaccident.php?qr=2702', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2835, 2703, 'apatkal/submitaccident.php?qr=2703', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2836, 2704, 'apatkal/submitaccident.php?qr=2704', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2837, 2705, 'apatkal/submitaccident.php?qr=2705', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2838, 2706, 'apatkal/submitaccident.php?qr=2706', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2839, 2707, 'apatkal/submitaccident.php?qr=2707', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2840, 2708, 'apatkal/submitaccident.php?qr=2708', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2841, 2709, 'apatkal/submitaccident.php?qr=2709', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2842, 2710, 'apatkal/submitaccident.php?qr=2710', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2843, 2711, 'apatkal/submitaccident.php?qr=2711', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2844, 2712, 'apatkal/submitaccident.php?qr=2712', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2845, 2713, 'apatkal/submitaccident.php?qr=2713', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2846, 2714, 'apatkal/submitaccident.php?qr=2714', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2847, 2715, 'apatkal/submitaccident.php?qr=2715', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2848, 2716, 'apatkal/submitaccident.php?qr=2716', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2849, 2717, 'apatkal/submitaccident.php?qr=2717', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2850, 2718, 'apatkal/submitaccident.php?qr=2718', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2851, 2719, 'apatkal/submitaccident.php?qr=2719', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2852, 2720, 'apatkal/submitaccident.php?qr=2720', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2853, 2721, 'apatkal/submitaccident.php?qr=2721', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2854, 2722, 'apatkal/submitaccident.php?qr=2722', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2855, 2723, 'apatkal/submitaccident.php?qr=2723', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2856, 2724, 'apatkal/submitaccident.php?qr=2724', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2857, 2725, 'apatkal/submitaccident.php?qr=2725', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2858, 2726, 'apatkal/submitaccident.php?qr=2726', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2859, 2727, 'apatkal/submitaccident.php?qr=2727', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2860, 2728, 'apatkal/submitaccident.php?qr=2728', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2861, 2729, 'apatkal/submitaccident.php?qr=2729', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2862, 2730, 'apatkal/submitaccident.php?qr=2730', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2863, 2731, 'apatkal/submitaccident.php?qr=2731', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2864, 2732, 'apatkal/submitaccident.php?qr=2732', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2865, 2733, 'apatkal/submitaccident.php?qr=2733', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2866, 2734, 'apatkal/submitaccident.php?qr=2734', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2867, 2735, 'apatkal/submitaccident.php?qr=2735', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2868, 2736, 'apatkal/submitaccident.php?qr=2736', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2869, 2737, 'apatkal/submitaccident.php?qr=2737', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2870, 2738, 'apatkal/submitaccident.php?qr=2738', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2871, 2739, 'apatkal/submitaccident.php?qr=2739', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2872, 2740, 'apatkal/submitaccident.php?qr=2740', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2873, 2741, 'apatkal/submitaccident.php?qr=2741', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2874, 2742, 'apatkal/submitaccident.php?qr=2742', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2875, 2743, 'apatkal/submitaccident.php?qr=2743', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2876, 2744, 'apatkal/submitaccident.php?qr=2744', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2877, 2745, 'apatkal/submitaccident.php?qr=2745', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2878, 2746, 'apatkal/submitaccident.php?qr=2746', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2879, 2747, 'apatkal/submitaccident.php?qr=2747', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2880, 2748, 'apatkal/submitaccident.php?qr=2748', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2881, 2749, 'apatkal/submitaccident.php?qr=2749', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2882, 2750, 'apatkal/submitaccident.php?qr=2750', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2883, 2751, 'apatkal/submitaccident.php?qr=2751', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2884, 2752, 'apatkal/submitaccident.php?qr=2752', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2885, 2753, 'apatkal/submitaccident.php?qr=2753', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2886, 2754, 'apatkal/submitaccident.php?qr=2754', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2887, 2755, 'apatkal/submitaccident.php?qr=2755', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2888, 2756, 'apatkal/submitaccident.php?qr=2756', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2889, 2757, 'apatkal/submitaccident.php?qr=2757', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2890, 2758, 'apatkal/submitaccident.php?qr=2758', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2891, 2759, 'apatkal/submitaccident.php?qr=2759', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2892, 2760, 'apatkal/submitaccident.php?qr=2760', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2893, 2761, 'apatkal/submitaccident.php?qr=2761', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2894, 2762, 'apatkal/submitaccident.php?qr=2762', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2895, 2763, 'apatkal/submitaccident.php?qr=2763', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2896, 2764, 'apatkal/submitaccident.php?qr=2764', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2897, 2765, 'apatkal/submitaccident.php?qr=2765', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2898, 2766, 'apatkal/submitaccident.php?qr=2766', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2899, 2767, 'apatkal/submitaccident.php?qr=2767', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2900, 2768, 'apatkal/submitaccident.php?qr=2768', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2901, 2769, 'apatkal/submitaccident.php?qr=2769', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2902, 2770, 'apatkal/submitaccident.php?qr=2770', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2903, 2771, 'apatkal/submitaccident.php?qr=2771', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2904, 2772, 'apatkal/submitaccident.php?qr=2772', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2905, 2773, 'apatkal/submitaccident.php?qr=2773', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2906, 2774, 'apatkal/submitaccident.php?qr=2774', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2907, 2775, 'apatkal/submitaccident.php?qr=2775', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2908, 2776, 'apatkal/submitaccident.php?qr=2776', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2909, 2777, 'apatkal/submitaccident.php?qr=2777', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2910, 2778, 'apatkal/submitaccident.php?qr=2778', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2911, 2779, 'apatkal/submitaccident.php?qr=2779', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2912, 2780, 'apatkal/submitaccident.php?qr=2780', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2913, 2781, 'apatkal/submitaccident.php?qr=2781', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2914, 2782, 'apatkal/submitaccident.php?qr=2782', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2915, 2783, 'apatkal/submitaccident.php?qr=2783', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2916, 2784, 'apatkal/submitaccident.php?qr=2784', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2917, 2785, 'apatkal/submitaccident.php?qr=2785', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2918, 2786, 'apatkal/submitaccident.php?qr=2786', '2025-10-13 17:29:30', NULL, NULL, NULL, NULL),
(2919, 2787, 'apatkal/submitaccident.php?qr=2787', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2920, 2788, 'apatkal/submitaccident.php?qr=2788', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2921, 2789, 'apatkal/submitaccident.php?qr=2789', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2922, 2790, 'apatkal/submitaccident.php?qr=2790', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2923, 2791, 'apatkal/submitaccident.php?qr=2791', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2924, 2792, 'apatkal/submitaccident.php?qr=2792', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2925, 2793, 'apatkal/submitaccident.php?qr=2793', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2926, 2794, 'apatkal/submitaccident.php?qr=2794', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2927, 2795, 'apatkal/submitaccident.php?qr=2795', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2928, 2796, 'apatkal/submitaccident.php?qr=2796', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2929, 2797, 'apatkal/submitaccident.php?qr=2797', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2930, 2798, 'apatkal/submitaccident.php?qr=2798', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2931, 2799, 'apatkal/submitaccident.php?qr=2799', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2932, 2800, 'apatkal/submitaccident.php?qr=2800', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2933, 2801, 'apatkal/submitaccident.php?qr=2801', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2934, 2802, 'apatkal/submitaccident.php?qr=2802', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2935, 2803, 'apatkal/submitaccident.php?qr=2803', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2936, 2804, 'apatkal/submitaccident.php?qr=2804', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2937, 2805, 'apatkal/submitaccident.php?qr=2805', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2938, 2806, 'apatkal/submitaccident.php?qr=2806', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2939, 2807, 'apatkal/submitaccident.php?qr=2807', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2940, 2808, 'apatkal/submitaccident.php?qr=2808', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2941, 2809, 'apatkal/submitaccident.php?qr=2809', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2942, 2810, 'apatkal/submitaccident.php?qr=2810', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2943, 2811, 'apatkal/submitaccident.php?qr=2811', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2944, 2812, 'apatkal/submitaccident.php?qr=2812', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2945, 2813, 'apatkal/submitaccident.php?qr=2813', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2946, 2814, 'apatkal/submitaccident.php?qr=2814', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2947, 2815, 'apatkal/submitaccident.php?qr=2815', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2948, 2816, 'apatkal/submitaccident.php?qr=2816', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2949, 2817, 'apatkal/submitaccident.php?qr=2817', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2950, 2818, 'apatkal/submitaccident.php?qr=2818', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2951, 2819, 'apatkal/submitaccident.php?qr=2819', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2952, 2820, 'apatkal/submitaccident.php?qr=2820', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2953, 2821, 'apatkal/submitaccident.php?qr=2821', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2954, 2822, 'apatkal/submitaccident.php?qr=2822', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2955, 2823, 'apatkal/submitaccident.php?qr=2823', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2956, 2824, 'apatkal/submitaccident.php?qr=2824', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2957, 2825, 'apatkal/submitaccident.php?qr=2825', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2958, 2826, 'apatkal/submitaccident.php?qr=2826', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2959, 2827, 'apatkal/submitaccident.php?qr=2827', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2960, 2828, 'apatkal/submitaccident.php?qr=2828', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2961, 2829, 'apatkal/submitaccident.php?qr=2829', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2962, 2830, 'apatkal/submitaccident.php?qr=2830', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2963, 2831, 'apatkal/submitaccident.php?qr=2831', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2964, 2832, 'apatkal/submitaccident.php?qr=2832', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2965, 2833, 'apatkal/submitaccident.php?qr=2833', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2966, 2834, 'apatkal/submitaccident.php?qr=2834', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2967, 2835, 'apatkal/submitaccident.php?qr=2835', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2968, 2836, 'apatkal/submitaccident.php?qr=2836', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2969, 2837, 'apatkal/submitaccident.php?qr=2837', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2970, 2838, 'apatkal/submitaccident.php?qr=2838', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2971, 2839, 'apatkal/submitaccident.php?qr=2839', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2972, 2840, 'apatkal/submitaccident.php?qr=2840', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2973, 2841, 'apatkal/submitaccident.php?qr=2841', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2974, 2842, 'apatkal/submitaccident.php?qr=2842', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2975, 2843, 'apatkal/submitaccident.php?qr=2843', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2976, 2844, 'apatkal/submitaccident.php?qr=2844', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2977, 2845, 'apatkal/submitaccident.php?qr=2845', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2978, 2846, 'apatkal/submitaccident.php?qr=2846', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2979, 2847, 'apatkal/submitaccident.php?qr=2847', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2980, 2848, 'apatkal/submitaccident.php?qr=2848', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2981, 2849, 'apatkal/submitaccident.php?qr=2849', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2982, 2850, 'apatkal/submitaccident.php?qr=2850', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2983, 2851, 'apatkal/submitaccident.php?qr=2851', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2984, 2852, 'apatkal/submitaccident.php?qr=2852', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2985, 2853, 'apatkal/submitaccident.php?qr=2853', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2986, 2854, 'apatkal/submitaccident.php?qr=2854', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2987, 2855, 'apatkal/submitaccident.php?qr=2855', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2988, 2856, 'apatkal/submitaccident.php?qr=2856', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2989, 2857, 'apatkal/submitaccident.php?qr=2857', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2990, 2858, 'apatkal/submitaccident.php?qr=2858', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2991, 2859, 'apatkal/submitaccident.php?qr=2859', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2992, 2860, 'apatkal/submitaccident.php?qr=2860', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2993, 2861, 'apatkal/submitaccident.php?qr=2861', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2994, 2862, 'apatkal/submitaccident.php?qr=2862', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2995, 2863, 'apatkal/submitaccident.php?qr=2863', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2996, 2864, 'apatkal/submitaccident.php?qr=2864', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2997, 2865, 'apatkal/submitaccident.php?qr=2865', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2998, 2866, 'apatkal/submitaccident.php?qr=2866', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(2999, 2867, 'apatkal/submitaccident.php?qr=2867', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3000, 2868, 'apatkal/submitaccident.php?qr=2868', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3001, 2869, 'apatkal/submitaccident.php?qr=2869', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3002, 2870, 'apatkal/submitaccident.php?qr=2870', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3003, 2871, 'apatkal/submitaccident.php?qr=2871', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3004, 2872, 'apatkal/submitaccident.php?qr=2872', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3005, 2873, 'apatkal/submitaccident.php?qr=2873', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3006, 2874, 'apatkal/submitaccident.php?qr=2874', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3007, 2875, 'apatkal/submitaccident.php?qr=2875', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3008, 2876, 'apatkal/submitaccident.php?qr=2876', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3009, 2877, 'apatkal/submitaccident.php?qr=2877', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3010, 2878, 'apatkal/submitaccident.php?qr=2878', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3011, 2879, 'apatkal/submitaccident.php?qr=2879', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3012, 2880, 'apatkal/submitaccident.php?qr=2880', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3013, 2881, 'apatkal/submitaccident.php?qr=2881', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3014, 2882, 'apatkal/submitaccident.php?qr=2882', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3015, 2883, 'apatkal/submitaccident.php?qr=2883', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3016, 2884, 'apatkal/submitaccident.php?qr=2884', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3017, 2885, 'apatkal/submitaccident.php?qr=2885', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3018, 2886, 'apatkal/submitaccident.php?qr=2886', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3019, 2887, 'apatkal/submitaccident.php?qr=2887', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3020, 2888, 'apatkal/submitaccident.php?qr=2888', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3021, 2889, 'apatkal/submitaccident.php?qr=2889', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3022, 2890, 'apatkal/submitaccident.php?qr=2890', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3023, 2891, 'apatkal/submitaccident.php?qr=2891', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3024, 2892, 'apatkal/submitaccident.php?qr=2892', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3025, 2893, 'apatkal/submitaccident.php?qr=2893', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3026, 2894, 'apatkal/submitaccident.php?qr=2894', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3027, 2895, 'apatkal/submitaccident.php?qr=2895', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3028, 2896, 'apatkal/submitaccident.php?qr=2896', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3029, 2897, 'apatkal/submitaccident.php?qr=2897', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3030, 2898, 'apatkal/submitaccident.php?qr=2898', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3031, 2899, 'apatkal/submitaccident.php?qr=2899', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3032, 2900, 'apatkal/submitaccident.php?qr=2900', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3033, 2901, 'apatkal/submitaccident.php?qr=2901', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3034, 2902, 'apatkal/submitaccident.php?qr=2902', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3035, 2903, 'apatkal/submitaccident.php?qr=2903', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3036, 2904, 'apatkal/submitaccident.php?qr=2904', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3037, 2905, 'apatkal/submitaccident.php?qr=2905', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3038, 2906, 'apatkal/submitaccident.php?qr=2906', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3039, 2907, 'apatkal/submitaccident.php?qr=2907', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3040, 2908, 'apatkal/submitaccident.php?qr=2908', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3041, 2909, 'apatkal/submitaccident.php?qr=2909', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3042, 2910, 'apatkal/submitaccident.php?qr=2910', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3043, 2911, 'apatkal/submitaccident.php?qr=2911', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3044, 2912, 'apatkal/submitaccident.php?qr=2912', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3045, 2913, 'apatkal/submitaccident.php?qr=2913', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3046, 2914, 'apatkal/submitaccident.php?qr=2914', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3047, 2915, 'apatkal/submitaccident.php?qr=2915', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3048, 2916, 'apatkal/submitaccident.php?qr=2916', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3049, 2917, 'apatkal/submitaccident.php?qr=2917', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3050, 2918, 'apatkal/submitaccident.php?qr=2918', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3051, 2919, 'apatkal/submitaccident.php?qr=2919', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3052, 2920, 'apatkal/submitaccident.php?qr=2920', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3053, 2921, 'apatkal/submitaccident.php?qr=2921', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3054, 2922, 'apatkal/submitaccident.php?qr=2922', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3055, 2923, 'apatkal/submitaccident.php?qr=2923', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3056, 2924, 'apatkal/submitaccident.php?qr=2924', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3057, 2925, 'apatkal/submitaccident.php?qr=2925', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3058, 2926, 'apatkal/submitaccident.php?qr=2926', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3059, 2927, 'apatkal/submitaccident.php?qr=2927', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3060, 2928, 'apatkal/submitaccident.php?qr=2928', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3061, 2929, 'apatkal/submitaccident.php?qr=2929', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3062, 2930, 'apatkal/submitaccident.php?qr=2930', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3063, 2931, 'apatkal/submitaccident.php?qr=2931', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3064, 2932, 'apatkal/submitaccident.php?qr=2932', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3065, 2933, 'apatkal/submitaccident.php?qr=2933', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3066, 2934, 'apatkal/submitaccident.php?qr=2934', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3067, 2935, 'apatkal/submitaccident.php?qr=2935', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3068, 2936, 'apatkal/submitaccident.php?qr=2936', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3069, 2937, 'apatkal/submitaccident.php?qr=2937', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3070, 2938, 'apatkal/submitaccident.php?qr=2938', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3071, 2939, 'apatkal/submitaccident.php?qr=2939', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3072, 2940, 'apatkal/submitaccident.php?qr=2940', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3073, 2941, 'apatkal/submitaccident.php?qr=2941', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3074, 2942, 'apatkal/submitaccident.php?qr=2942', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3075, 2943, 'apatkal/submitaccident.php?qr=2943', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3076, 2944, 'apatkal/submitaccident.php?qr=2944', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3077, 2945, 'apatkal/submitaccident.php?qr=2945', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3078, 2946, 'apatkal/submitaccident.php?qr=2946', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3079, 2947, 'apatkal/submitaccident.php?qr=2947', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3080, 2948, 'apatkal/submitaccident.php?qr=2948', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3081, 2949, 'apatkal/submitaccident.php?qr=2949', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3082, 2950, 'apatkal/submitaccident.php?qr=2950', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3083, 2951, 'apatkal/submitaccident.php?qr=2951', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3084, 2952, 'apatkal/submitaccident.php?qr=2952', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3085, 2953, 'apatkal/submitaccident.php?qr=2953', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3086, 2954, 'apatkal/submitaccident.php?qr=2954', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3087, 2955, 'apatkal/submitaccident.php?qr=2955', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3088, 2956, 'apatkal/submitaccident.php?qr=2956', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3089, 2957, 'apatkal/submitaccident.php?qr=2957', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3090, 2958, 'apatkal/submitaccident.php?qr=2958', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3091, 2959, 'apatkal/submitaccident.php?qr=2959', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3092, 2960, 'apatkal/submitaccident.php?qr=2960', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3093, 2961, 'apatkal/submitaccident.php?qr=2961', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3094, 2962, 'apatkal/submitaccident.php?qr=2962', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3095, 2963, 'apatkal/submitaccident.php?qr=2963', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3096, 2964, 'apatkal/submitaccident.php?qr=2964', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3097, 2965, 'apatkal/submitaccident.php?qr=2965', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3098, 2966, 'apatkal/submitaccident.php?qr=2966', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3099, 2967, 'apatkal/submitaccident.php?qr=2967', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3100, 2968, 'apatkal/submitaccident.php?qr=2968', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3101, 2969, 'apatkal/submitaccident.php?qr=2969', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3102, 2970, 'apatkal/submitaccident.php?qr=2970', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3103, 2971, 'apatkal/submitaccident.php?qr=2971', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3104, 2972, 'apatkal/submitaccident.php?qr=2972', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3105, 2973, 'apatkal/submitaccident.php?qr=2973', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3106, 2974, 'apatkal/submitaccident.php?qr=2974', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3107, 2975, 'apatkal/submitaccident.php?qr=2975', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3108, 2976, 'apatkal/submitaccident.php?qr=2976', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3109, 2977, 'apatkal/submitaccident.php?qr=2977', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3110, 2978, 'apatkal/submitaccident.php?qr=2978', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3111, 2979, 'apatkal/submitaccident.php?qr=2979', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3112, 2980, 'apatkal/submitaccident.php?qr=2980', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3113, 2981, 'apatkal/submitaccident.php?qr=2981', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3114, 2982, 'apatkal/submitaccident.php?qr=2982', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3115, 2983, 'apatkal/submitaccident.php?qr=2983', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3116, 2984, 'apatkal/submitaccident.php?qr=2984', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3117, 2985, 'apatkal/submitaccident.php?qr=2985', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3118, 2986, 'apatkal/submitaccident.php?qr=2986', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3119, 2987, 'apatkal/submitaccident.php?qr=2987', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3120, 2988, 'apatkal/submitaccident.php?qr=2988', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3121, 2989, 'apatkal/submitaccident.php?qr=2989', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3122, 2990, 'apatkal/submitaccident.php?qr=2990', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3123, 2991, 'apatkal/submitaccident.php?qr=2991', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3124, 2992, 'apatkal/submitaccident.php?qr=2992', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3125, 2993, 'apatkal/submitaccident.php?qr=2993', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3126, 2994, 'apatkal/submitaccident.php?qr=2994', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3127, 2995, 'apatkal/submitaccident.php?qr=2995', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3128, 2996, 'apatkal/submitaccident.php?qr=2996', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3129, 2997, 'apatkal/submitaccident.php?qr=2997', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3130, 2998, 'apatkal/submitaccident.php?qr=2998', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3131, 2999, 'apatkal/submitaccident.php?qr=2999', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3132, 3000, 'apatkal/submitaccident.php?qr=3000', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3133, 3001, 'apatkal/submitaccident.php?qr=3001', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3134, 3002, 'apatkal/submitaccident.php?qr=3002', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3135, 3003, 'apatkal/submitaccident.php?qr=3003', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3136, 3004, 'apatkal/submitaccident.php?qr=3004', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3137, 3005, 'apatkal/submitaccident.php?qr=3005', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3138, 3006, 'apatkal/submitaccident.php?qr=3006', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3139, 3007, 'apatkal/submitaccident.php?qr=3007', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3140, 3008, 'apatkal/submitaccident.php?qr=3008', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3141, 3009, 'apatkal/submitaccident.php?qr=3009', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3142, 3010, 'apatkal/submitaccident.php?qr=3010', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3143, 3011, 'apatkal/submitaccident.php?qr=3011', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3144, 3012, 'apatkal/submitaccident.php?qr=3012', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3145, 3013, 'apatkal/submitaccident.php?qr=3013', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3146, 3014, 'apatkal/submitaccident.php?qr=3014', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3147, 3015, 'apatkal/submitaccident.php?qr=3015', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3148, 3016, 'apatkal/submitaccident.php?qr=3016', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3149, 3017, 'apatkal/submitaccident.php?qr=3017', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3150, 3018, 'apatkal/submitaccident.php?qr=3018', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3151, 3019, 'apatkal/submitaccident.php?qr=3019', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3152, 3020, 'apatkal/submitaccident.php?qr=3020', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3153, 3021, 'apatkal/submitaccident.php?qr=3021', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3154, 3022, 'apatkal/submitaccident.php?qr=3022', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3155, 3023, 'apatkal/submitaccident.php?qr=3023', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3156, 3024, 'apatkal/submitaccident.php?qr=3024', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3157, 3025, 'apatkal/submitaccident.php?qr=3025', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3158, 3026, 'apatkal/submitaccident.php?qr=3026', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3159, 3027, 'apatkal/submitaccident.php?qr=3027', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3160, 3028, 'apatkal/submitaccident.php?qr=3028', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3161, 3029, 'apatkal/submitaccident.php?qr=3029', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3162, 3030, 'apatkal/submitaccident.php?qr=3030', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3163, 3031, 'apatkal/submitaccident.php?qr=3031', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3164, 3032, 'apatkal/submitaccident.php?qr=3032', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3165, 3033, 'apatkal/submitaccident.php?qr=3033', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3166, 3034, 'apatkal/submitaccident.php?qr=3034', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3167, 3035, 'apatkal/submitaccident.php?qr=3035', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3168, 3036, 'apatkal/submitaccident.php?qr=3036', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3169, 3037, 'apatkal/submitaccident.php?qr=3037', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3170, 3038, 'apatkal/submitaccident.php?qr=3038', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3171, 3039, 'apatkal/submitaccident.php?qr=3039', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3172, 3040, 'apatkal/submitaccident.php?qr=3040', '2025-10-13 17:29:31', NULL, NULL, NULL, NULL),
(3173, 3041, 'apatkal/submitaccident.php?qr=3041', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL),
(3174, 3042, 'apatkal/submitaccident.php?qr=3042', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL),
(3175, 3043, 'apatkal/submitaccident.php?qr=3043', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL),
(3176, 3044, 'apatkal/submitaccident.php?qr=3044', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL),
(3177, 3045, 'apatkal/submitaccident.php?qr=3045', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL),
(3178, 3046, 'apatkal/submitaccident.php?qr=3046', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL),
(3179, 3047, 'apatkal/submitaccident.php?qr=3047', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL),
(3180, 3048, 'apatkal/submitaccident.php?qr=3048', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL),
(3181, 3049, 'apatkal/submitaccident.php?qr=3049', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL),
(3182, 3050, 'apatkal/submitaccident.php?qr=3050', '2025-10-14 11:02:23', NULL, NULL, NULL, NULL);

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
  `duration` int(11) NOT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `start_latitude` decimal(10,8) DEFAULT NULL,
  `start_longitude` decimal(11,8) DEFAULT NULL,
  `end_latitude` decimal(10,8) DEFAULT NULL,
  `end_longitude` decimal(11,8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trips`
--

INSERT INTO `trips` (`history_id`, `driver_id`, `client_name`, `location`, `timing`, `duration`, `start_time`, `end_time`, `created_at`, `start_latitude`, `start_longitude`, `end_latitude`, `end_longitude`) VALUES
(0, 1, '', 'XGWG+8J Pathar Kansiya, Madhya Pradesh, India (Lat: 22.995800, Lng: 77.526600)', '2025-10-04 09:11:59', 1, '2025-10-04 09:11:59', '2025-10-04 03:42:16', '2025-10-04 09:12:16', NULL, NULL, NULL, NULL),
(1, 1, 'Priya Sharma', 'Apollo Hospital, Indore', '2025-09-20 09:00:00', 45, '2025-09-20 09:05:00', '2025-09-20 09:50:00', '2025-09-20 09:00:00', NULL, NULL, NULL, NULL),
(2, 1, 'Rajesh Kumar', 'Fortis Hospital, Bhopal', '2025-09-27 03:45:00', 60, '2025-09-27 03:50:00', '2025-09-27 04:50:00', '2025-09-27 03:45:00', NULL, NULL, NULL, NULL),
(3, 1, 'Meera Patel', 'Manipal Hospital, Jabalpur', '2025-10-01 11:15:00', 50, '2025-10-01 11:20:00', '2025-10-01 12:10:00', '2025-10-01 11:15:00', NULL, NULL, NULL, NULL),
(4, 1, 'Vikram Singh', 'AIIMS Hospital, Delhi', '2025-10-02 06:00:00', 75, '2025-10-02 06:05:00', '2025-10-02 06:15:00', '2025-10-02 06:00:00', NULL, NULL, NULL, NULL),
(34, 1, 'Krishna Vishwakarma', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154841, Lng: 79.926038)', '2025-10-15 06:16:25', 57, '2025-10-15 06:16:25', '2025-10-15 06:17:22', '2025-10-15 06:17:22', 23.15484074, 79.92603774, 23.15484729, 79.92602640),
(35, 1, 'Krishna Vishwakarma', 'Shop no 2 First Floor Shivhari Complex Besides Gulzar Hotel Mahanadda, Cheevani Phamad Nagar, Jabalpur, Madhya Pradesh 482001, India (Lat: 23.154845, Lng: 79.926035)', '2025-10-15 06:15:59', 12, '2025-10-15 06:15:59', '2025-10-15 06:16:11', '2025-10-15 06:16:11', 23.15484466, 79.92603483, 23.15484729, 79.92602640);

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
(1, 'Admin', 'User', 'admin@apatkal.com', '', '$2y$10$MwM62gNOKcbw5RIxp2LpHOumiuD.i7vqxupBpir9no7Uv0/Hz6/Fy', 'admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', 0, 1, '2025-10-11 12:46:39', '2025-09-13 08:01:19', '2025-10-11 12:46:39'),
(2, 'Krishna', 'Vish', 'Toss125traininag@gmai.com', '7723065844', '$2y$10$pZ8DQ4CufH1drx2OF5qMnuPXgpPuWCT.Z5.wnHc38Oy7.HR036jVq', 'sales', NULL, NULL, '', NULL, NULL, NULL, NULL, 'sales', 0, 1, NULL, '2025-09-13 15:46:08', '2025-09-13 17:02:04'),
(3, 'Sarah', 'Johnson', 'hr@apatkal.com', '9876543210', '$2y$10$wDNv.mYbXpnet7re8If.keP.NPDOHoLOXgsqJBK1YBITQi2aWKn6u', 'hr_manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'hr', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(4, 'Mike', 'Davis', 'sales@apatkal.com', '9876543211', '$2y$10$4AYUzkUaaGtu5nnXGguB4.aPA.DgfCprSC5hnBGj4Mm7H1wkt4sti', 'sales_rep', NULL, NULL, '', NULL, NULL, NULL, NULL, 'sales', 0, 1, '2025-10-08 11:01:15', '2025-09-13 16:58:30', '2025-10-08 11:01:15'),
(5, 'Lisa', 'Wilson', 'office@apatkal.com', '9876543212', '$2y$10$w2eAWT7oUdswd6KDvTw0muJv4zVRsU35o10vMxLj/kBkyfnbv5nPC', 'office_staff', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'office_staff', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(6, 'David', 'Brown', 'manager@apatkal.com', '9876543213', '$2y$10$jV9jn2GjPqA7XJUP1p35ieUQNDbirBOZDRPE6pYsbpBq5zsGtwXAK', 'manager1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'manager', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(7, 'Emma', 'Garcia', 'supervisor@apatkal.com', '9876543214', '$2y$10$oSF8KFXrI.lOk.puE8igeOE5yeY/jNNSYaETcEHdqEhgVXqZVR3EC', 'supervisor1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'supervisor', 0, 1, NULL, '2025-09-13 16:58:30', '2025-09-13 16:59:37'),
(8, 'Gulam', 'Gous', 'kalmaliindia@gmail.com', '8770658824', '$2y$10$FonFNbtwhX7uKdjK2J4rD.dXZ6L3O3GKUUfYhQBJ2/Mpsuyw4BIGK', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'user', 0, 1, '2025-09-14 00:10:22', '2025-09-14 00:07:43', '2025-09-14 00:10:22'),
(9, 'shivam', 'kumar', 'siddharth.toss.cs@gmail.com', '7723065844', '$2y$10$aUm.zWoadt.sD/2z8NfTCeUGGUwfSy8seH7ofmtoQ81xauAaM.RPS', 'shivam', NULL, NULL, 'frfre', NULL, NULL, NULL, NULL, 'supervisor', 0, 1, NULL, '2025-09-17 13:15:35', '2025-09-17 13:16:06'),
(10, 'siddharth', 'singh', 'shreyash.toss.cs@gmail.com', '7898140799', '$2y$10$WxVsjnomImnEgZyqMhz9XeI6JB9BTUL02Q2KhqgNNa3OlYa.WssyS', 'siddharth', NULL, NULL, 'jbp', NULL, NULL, NULL, NULL, 'hr', 0, 1, NULL, '2025-09-23 15:10:59', '2025-09-24 11:25:17'),
(11, 'aavi', 'thakur', 'sidhusingh7898thakur@gmail.com', '7898140799', '$2y$10$sN9jAh2LzTWxwcfT1s0NGuRnkAmvempf2LH0keRV54rN13hMC/xHW', 'aaavi', NULL, NULL, 'dsffsd', NULL, NULL, NULL, NULL, 'sales', 0, 0, NULL, '2025-09-24 11:27:41', '2025-09-24 15:31:43'),
(12, 'Krishna', 'Vishwakarma', 'Toss125training@gmail.com', '7723065844', '$2y$10$ImdXHAGbRAbMY8GGOP3xE.zfwXSJYusqVUZeGkIaOVljqqaNX2Aq2', 'krishnaToss', NULL, NULL, '', NULL, NULL, NULL, NULL, 'hr', 0, 1, '2025-09-26 11:40:00', '2025-09-26 11:39:03', '2025-09-26 11:40:00'),
(13, 'akuu', 'val', 'shreyas.toss.cs@gmail.com', '8520122520', '$2y$10$nWlgxIdoPvj3GPX861lQY.zPCidGRxRj.4SUnrCJCc5aVbZ52jSCa', 'akuu bal', NULL, NULL, 'mp', NULL, NULL, NULL, NULL, 'office_staff', 0, 1, '2025-10-11 12:44:42', '2025-10-06 13:59:48', '2025-10-11 12:44:42');

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
(1, 1, 4600.00, 5950.00, 1350.00, '2025-08-01 04:30:00', '2025-10-15 06:13:14'),
(13, 2, 0.00, 0.00, 0.00, '2025-10-08 11:09:43', '2025-10-09 04:47:19'),
(14, 13, 0.00, 0.00, 0.00, '2025-10-09 05:51:44', '2025-10-09 05:52:20');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `withdrawals`
--

INSERT INTO `withdrawals` (`withdrawal_id`, `driver_id`, `amount`, `bank_account_number`, `bank_name`, `ifsc_code`, `account_holder_name`, `status`, `requested_at`, `processed_at`, `created_at`) VALUES
(19, 1, 1000.00, '1234567890123456', 'State Bank Of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-10-08 10:44:03', '2025-10-08 10:44:03', '2025-10-08 10:44:03'),
(20, 1, 100.00, '1234567890123456', 'State Bank Of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-10-08 10:53:41', '2025-10-08 10:53:41', '2025-10-08 10:53:41'),
(21, 1, 150.00, '1234567890123456', 'State Bank Of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-10-08 10:58:34', '2025-10-08 10:58:34', '2025-10-08 10:58:34'),
(22, 1, 100.00, '1234567890123456', 'State Bank Of India', 'SBIN0001234', 'Rajesh Sharma', 'completed', '2025-10-11 07:23:51', '2025-10-11 07:23:51', '2025-10-11 07:23:51');

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
  ADD UNIQUE KEY `uq_qr_number` (`qr_number`),
  ADD KEY `idx_vehicle_number` (`vehicle_number`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `accident_photos`
--
ALTER TABLE `accident_photos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `accident_remarks`
--
ALTER TABLE `accident_remarks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `client_family_members`
--
ALTER TABLE `client_family_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `client_logins`
--
ALTER TABLE `client_logins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3183;

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
  MODIFY `wallet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `website_config`
--
ALTER TABLE `website_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `withdrawal_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

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
