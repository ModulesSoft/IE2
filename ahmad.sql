-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jan 19, 2019 at 12:07 PM
-- Server version: 5.7.9
-- PHP Version: 5.6.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ahmad`
--

-- --------------------------------------------------------

--
-- Table structure for table `designs`
--

DROP TABLE IF EXISTS `designs`;
CREATE TABLE IF NOT EXISTS `designs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `max_point` int(11) NOT NULL,
  `dice_number` int(11) NOT NULL,
  `max_dice` int(11) NOT NULL,
  `zero1` int(11) NOT NULL DEFAULT '0',
  `zero2` int(11) NOT NULL DEFAULT '0',
  `zero3` int(11) NOT NULL DEFAULT '0',
  `zero4` int(11) NOT NULL DEFAULT '0',
  `zero5` int(11) NOT NULL DEFAULT '0',
  `zero6` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `designs`
--

INSERT INTO `designs` (`id`, `username`, `name`, `max_point`, `dice_number`, `max_dice`, `zero1`, `zero2`, `zero3`, `zero4`, `zero5`, `zero6`, `created_at`, `updated_at`) VALUES
(1, 'zahra', 'game1', 1, 2, 3, 0, 1, 0, 0, 0, 0, '2019-01-18 04:13:52', '2019-01-18 04:13:52'),
(2, 'majhool', 'majhoolgame ;)', 100, 2, 3, 0, 0, 0, 1, 0, 0, '2019-01-18 04:27:09', '2019-01-18 04:27:09'),
(3, 'majhool', 'ahmad', 100, 1, 4, 0, 1, 0, 0, 1, 1, '2019-01-19 07:23:10', '2019-01-19 07:23:10');

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

DROP TABLE IF EXISTS `games`;
CREATE TABLE IF NOT EXISTS `games` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `design_id` int(11) NOT NULL,
  `user1` varchar(100) NOT NULL,
  `user2` varchar(100) DEFAULT NULL,
  `current1` int(11) NOT NULL DEFAULT '0',
  `current2` int(11) NOT NULL DEFAULT '0',
  `global1` int(11) NOT NULL DEFAULT '0',
  `global2` int(11) NOT NULL DEFAULT '0',
  `turn` int(11) NOT NULL DEFAULT '1',
  `dice` int(11) NOT NULL DEFAULT '0',
  `finished` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user2` (`user2`),
  KEY `user1` (`user1`),
  KEY `design_id` (`design_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`id`, `design_id`, `user1`, `user2`, `current1`, `current2`, `global1`, `global2`, `turn`, `dice`, `finished`, `created_at`, `updated_at`) VALUES
(36, 1, 'zahra', 'majhool', 0, 0, 15, 0, 2, 1, 1, '2019-01-18 19:25:56', '2019-01-18 19:28:33'),
(37, 1, 'majhool', 'zahra', 0, 0, 16, 14, 2, 3, 1, '2019-01-18 19:29:02', '2019-01-18 19:31:32'),
(42, 1, 'ahmad', 'majhool', 0, 0, 7, 15, 1, 1, 2, '2019-01-19 05:50:14', '2019-01-19 05:59:25'),
(43, 1, 'admin', 'majhool', 0, 0, 6, 0, 2, 6, 1, '2019-01-19 06:17:36', '2019-01-19 06:17:47'),
(44, 1, 'admin', 'majhool', 0, 0, 4, 0, 2, 4, 1, '2019-01-19 06:18:09', '2019-01-19 06:18:22'),
(45, 1, 'admin', 'majhool', 0, 0, 11, 0, 2, 6, 1, '2019-01-19 06:27:28', '2019-01-19 06:27:38'),
(46, 1, 'admin', 'majhool', 0, 0, 3, 0, 2, 3, 1, '2019-01-19 07:18:57', '2019-01-19 07:19:07'),
(52, 1, 'majhool', 'zahra', 0, 0, 4, 0, 2, 4, 1, '2019-01-19 08:30:21', '2019-01-19 08:30:32'),
(53, 1, 'zahra', 'majhool', 0, 0, 6, 0, 2, 6, 1, '2019-01-19 08:31:31', '2019-01-19 08:31:43'),
(54, 1, 'zahra', 'majhool', 0, 0, 5, 0, 2, 5, 1, '2019-01-19 08:33:10', '2019-01-19 08:33:22'),
(55, 1, 'zahra', 'majhool', 0, 0, 3, 0, 2, 3, 1, '2019-01-19 08:36:44', '2019-01-19 08:36:56');

-- --------------------------------------------------------

--
-- Table structure for table `games_comments`
--

DROP TABLE IF EXISTS `games_comments`;
CREATE TABLE IF NOT EXISTS `games_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `design_id` int(11) NOT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL,
  `text` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `game_id` (`design_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `games_comments`
--

INSERT INTO `games_comments` (`id`, `user_id`, `design_id`, `confirmed`, `created_at`, `text`) VALUES
(2, 14, 1, 1, '2019-01-19 09:34:57', 'aali'),
(7, 1, 1, 1, '2019-01-19 07:08:06', 'ads');

-- --------------------------------------------------------

--
-- Table structure for table `onlines`
--

DROP TABLE IF EXISTS `onlines`;
CREATE TABLE IF NOT EXISTS `onlines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `onlines`
--

INSERT INTO `onlines` (`id`, `username`) VALUES
(60, 'zahra');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `password` varchar(60) NOT NULL,
  `avatarURL` varchar(400) DEFAULT NULL,
  `point` int(20) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `name`, `password`, `avatarURL`, `point`, `remember_token`) VALUES
(1, 'admin', NULL, 'احمد خانعلی زاده', '$2y$10$.75l95La9tohnpDtTt1jwuyT/hR8tqCBZgORRaLzHPdCO4Vv6Sj0O', 'https://www.w3schools.com/w3images/avatar2.png', 0, 'naWBQbw5XNSeiQ5qt8ZfBZZfXMaMA3n7x378aiAHzWoGkfTxf7Orn0IXIsvu'),
(14, 'majhool', NULL, 'yousef', '$2y$10$.75l95La9tohnpDtTt1jwuyT/hR8tqCBZgORRaLzHPdCO4Vv6Sj0O', NULL, 0, 'JKwY5SKwQi1vk1qYuTcfTZxmdZMghV8dMuXwVo4G5ALkBbqDNkZvB2Tcu5ym'),
(16, 'zahra', 'majhool@gmail.com', 'zahra joon', '$2y$10$59b1SJDMTj8bzYwDl/Oeb.6uECenJPhfaeSGEuY0WhUcWTbi5kBnS', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/CandymyloveYasu.png/220px-CandymyloveYasu.png', 100, 'DCOQ8B4Ck57w8Duyd9cj7DCIoYBRsSqkjFqOaZSkNXsOwW1epYTmjLJu9cuD'),
(17, 'ahmad', 'adasda@asdas.com', 'ahmad', '$2y$10$V7TElSyymuGRf5jKq/Hi8.Np5tJt1VnLrtZA3mXhc3sCNKOzP3GHa', 'asdasdasd', 0, 'osdACXOIj1qxB186Wec8gQd4nZbgZ8b2BZCgY3JtmGmBLpQW7s59lHJTcDsn');

-- --------------------------------------------------------

--
-- Table structure for table `users_comments`
--

DROP TABLE IF EXISTS `users_comments`;
CREATE TABLE IF NOT EXISTS `users_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `whom_id` int(11) NOT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL,
  `text` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users_comments`
--

INSERT INTO `users_comments` (`id`, `user_id`, `whom_id`, `confirmed`, `created_at`, `text`) VALUES
(1, 1, 14, 1, '2019-01-17 19:41:40', 'Nice Player'),
(6, 1, 14, 0, '2019-01-19 06:44:40', 'ali hasti azizam'),
(7, 1, 14, 1, '2019-01-19 07:19:14', 'adasdasdasdsas'),
(8, 1, 16, 0, '2019-01-19 08:30:38', 'thanx');

-- --------------------------------------------------------

--
-- Table structure for table `waitlists`
--

DROP TABLE IF EXISTS `waitlists`;
CREATE TABLE IF NOT EXISTS `waitlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user1` varchar(100) NOT NULL,
  `design_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=327 DEFAULT CHARSET=utf8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `games`
--
ALTER TABLE `games`
  ADD CONSTRAINT `games_ibfk_1` FOREIGN KEY (`design_id`) REFERENCES `designs` (`id`);

--
-- Constraints for table `games_comments`
--
ALTER TABLE `games_comments`
  ADD CONSTRAINT `games_comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `games_comments_ibfk_2` FOREIGN KEY (`design_id`) REFERENCES `designs` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
