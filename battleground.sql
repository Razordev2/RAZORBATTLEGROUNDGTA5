-- ========================================================
-- DATABASE SCHEMA: BATTLEGROUND ESPORTS RESOURCE (XAMPP / MySQL / MariaDB)
-- Import file ini ke phpMyAdmin XAMPP atau MySQL Database Server
-- ========================================================

CREATE DATABASE IF NOT EXISTS `battleground_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `battleground_db`;

-- --------------------------------------------------------
-- Tabel 1: `battleground_players`
-- Menyimpan statistik pemain, total kill, match, dan koin
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `battleground_players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(64) NOT NULL COMMENT 'Steam Hex, Discord ID, atau FiveM License',
  `name` varchar(64) NOT NULL DEFAULT 'Player',
  `total_matches` int(11) NOT NULL DEFAULT 0,
  `total_wins` int(11) NOT NULL DEFAULT 0,
  `total_kills` int(11) NOT NULL DEFAULT 0,
  `total_deaths` int(11) NOT NULL DEFAULT 0,
  `total_damage` int(11) NOT NULL DEFAULT 0,
  `total_score` int(11) NOT NULL DEFAULT 0,
  `coins` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabel 2: `battleground_matches`
-- Menyimpan riwayat setiap pertandingan battleground
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `battleground_matches` (
  `match_id` varchar(64) NOT NULL,
  `winner_team_name` varchar(64) DEFAULT 'N/A',
  `total_teams` int(11) NOT NULL DEFAULT 0,
  `total_players` int(11) NOT NULL DEFAULT 0,
  `start_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `end_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`match_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabel 3: `battleground_match_teams`
-- Menyimpan peringkat, total kill, dan poin tim di setiap match
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `battleground_match_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `match_id` varchar(64) NOT NULL,
  `team_name` varchar(64) NOT NULL,
  `team_logo` text DEFAULT NULL,
  `placement_rank` int(11) NOT NULL DEFAULT 0,
  `kills` int(11) NOT NULL DEFAULT 0,
  `damage` int(11) NOT NULL DEFAULT 0,
  `score` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_match_id` (`match_id`),
  CONSTRAINT `fk_match_teams` FOREIGN KEY (`match_id`) REFERENCES `battleground_matches` (`match_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabel 4: `battleground_redeem_codes`
-- Menyimpan daftar kode voucher redeem event
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `battleground_redeem_codes` (
  `code` varchar(32) NOT NULL,
  `reward_type` varchar(32) NOT NULL DEFAULT 'KILLMESSAGE',
  `reward_id` varchar(32) NOT NULL DEFAULT 'NEON',
  `max_uses` int(11) NOT NULL DEFAULT 100,
  `current_uses` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Data Sampel Kode Redeem Event Bawaan
-- --------------------------------------------------------
INSERT INTO `battleground_redeem_codes` (`code`, `reward_type`, `reward_id`, `max_uses`, `current_uses`, `enabled`) VALUES
('BG2026', 'KILLMESSAGE', 'NEON', 500, 0, 1),
('TOURNAMENT2026', 'COINS', '1000', 100, 0, 1)
ON DUPLICATE KEY UPDATE `enabled` = 1;
