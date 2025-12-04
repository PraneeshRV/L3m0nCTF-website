/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ctfd
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES
('24ad6790bc3c');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `anti_cheat_alerts`
--

DROP TABLE IF EXISTS `anti_cheat_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `anti_cheat_alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alert_type` varchar(50) NOT NULL,
  `severity` varchar(20) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `description` text NOT NULL,
  `evidence` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`evidence`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `resolved_at` datetime(6) DEFAULT NULL,
  `resolved_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `resolved_by` (`resolved_by`),
  CONSTRAINT `anti_cheat_alerts_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `anti_cheat_alerts_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `anti_cheat_alerts_ibfk_3` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`),
  CONSTRAINT `anti_cheat_alerts_ibfk_4` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anti_cheat_alerts`
--

LOCK TABLES `anti_cheat_alerts` WRITE;
/*!40000 ALTER TABLE `anti_cheat_alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `anti_cheat_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `anti_cheat_config`
--

DROP TABLE IF EXISTS `anti_cheat_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `anti_cheat_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `duplicate_flag_threshold` int(11) DEFAULT NULL,
  `brute_force_threshold` int(11) DEFAULT NULL,
  `brute_force_window` int(11) DEFAULT NULL,
  `ip_sharing_threshold` int(11) DEFAULT NULL,
  `sequence_similarity_threshold` float DEFAULT NULL,
  `time_delta_threshold` int(11) DEFAULT NULL,
  `auto_ban_enabled` tinyint(1) DEFAULT NULL,
  `notification_enabled` tinyint(1) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anti_cheat_config`
--

LOCK TABLES `anti_cheat_config` WRITE;
/*!40000 ALTER TABLE `anti_cheat_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `anti_cheat_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `awards`
--

DROP TABLE IF EXISTS `awards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `awards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `category` varchar(80) DEFAULT NULL,
  `icon` text DEFAULT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `type` varchar(80) DEFAULT 'standard',
  PRIMARY KEY (`id`),
  KEY `awards_ibfk_1` (`team_id`),
  KEY `awards_ibfk_2` (`user_id`),
  CONSTRAINT `awards_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `awards_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `awards`
--

LOCK TABLES `awards` WRITE;
/*!40000 ALTER TABLE `awards` DISABLE KEYS */;
/*!40000 ALTER TABLE `awards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brackets`
--

DROP TABLE IF EXISTS `brackets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `brackets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brackets`
--

LOCK TABLES `brackets` WRITE;
/*!40000 ALTER TABLE `brackets` DISABLE KEYS */;
/*!40000 ALTER TABLE `brackets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `challenge_topics`
--

DROP TABLE IF EXISTS `challenge_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `challenge_topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `topic_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `topic_id` (`topic_id`),
  CONSTRAINT `challenge_topics_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `challenge_topics_ibfk_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `challenge_topics`
--

LOCK TABLES `challenge_topics` WRITE;
/*!40000 ALTER TABLE `challenge_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `challenge_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `challenges`
--

DROP TABLE IF EXISTS `challenges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `challenges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `max_attempts` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `category` varchar(80) DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `state` varchar(80) NOT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `connection_info` text DEFAULT NULL,
  `next_id` int(11) DEFAULT NULL,
  `attribution` text DEFAULT NULL,
  `logic` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `next_id` (`next_id`),
  CONSTRAINT `challenges_ibfk_1` FOREIGN KEY (`next_id`) REFERENCES `challenges` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `challenges`
--

LOCK TABLES `challenges` WRITE;
/*!40000 ALTER TABLE `challenges` DISABLE KEYS */;
/*!40000 ALTER TABLE `challenges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `page_id` (`page_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_4` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` text DEFAULT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES
(1,'ctf_version','3.8.0'),
(2,'anti_cheat_alembic_version','ac001_initial'),
(3,'docker_challenges_alembic_version','dc004_add_dynamic_flag'),
(4,'dynamic_challenges_alembic_version','eb68f277ab61'),
(5,'geo_challenges_alembic_version','1a5e83bf7e42'),
(6,'ctf_name','L3m0nCTF'),
(7,'ctf_description',''),
(8,'user_mode','teams'),
(9,'ctf_theme','stargaze'),
(10,'start',''),
(11,'end',''),
(12,'freeze',NULL),
(13,'challenge_visibility','private'),
(14,'registration_visibility','public'),
(15,'score_visibility','public'),
(16,'account_visibility','public'),
(17,'verify_emails','false'),
(18,'social_shares','true'),
(19,'team_size',''),
(20,'mail_server',NULL),
(21,'mail_port',NULL),
(22,'mail_tls',NULL),
(23,'mail_ssl',NULL),
(24,'mail_username',NULL),
(25,'mail_password',NULL),
(26,'mail_useauth',NULL),
(27,'setup','1'),
(28,'version_latest','https://github.com/CTFd/CTFd/releases/tag/3.8.1'),
(29,'next_update_check','1764918267'),
(30,'theme_header',''),
(31,'theme_footer',''),
(32,'theme_settings','');
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docker_challenge`
--

DROP TABLE IF EXISTS `docker_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `docker_challenge` (
  `id` int(11) NOT NULL,
  `docker_image` varchar(128) DEFAULT NULL,
  `docker_config_id` int(11) DEFAULT NULL,
  `challenge_type` varchar(32) DEFAULT NULL,
  `docker_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`docker_images`)),
  `primary_service` varchar(64) DEFAULT NULL,
  `connection_type` varchar(32) DEFAULT NULL,
  `instance_duration` int(11) DEFAULT NULL,
  `custom_subdomain` varchar(128) DEFAULT NULL,
  `environment_vars` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_docker_challenge_docker_image` (`docker_image`),
  KEY `ix_docker_challenge_docker_config_id` (`docker_config_id`),
  CONSTRAINT `docker_challenge_ibfk_1` FOREIGN KEY (`id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `docker_challenge_ibfk_2` FOREIGN KEY (`docker_config_id`) REFERENCES `docker_config` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docker_challenge`
--

LOCK TABLES `docker_challenge` WRITE;
/*!40000 ALTER TABLE `docker_challenge` DISABLE KEYS */;
/*!40000 ALTER TABLE `docker_challenge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docker_challenge_tracker`
--

DROP TABLE IF EXISTS `docker_challenge_tracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `docker_challenge_tracker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `team_id` varchar(64) DEFAULT NULL,
  `user_id` varchar(64) DEFAULT NULL,
  `docker_image` varchar(64) DEFAULT NULL,
  `timestamp` int(11) DEFAULT NULL,
  `revert_time` int(11) DEFAULT NULL,
  `instance_id` varchar(128) DEFAULT NULL,
  `ports` varchar(128) DEFAULT NULL,
  `host` varchar(128) DEFAULT NULL,
  `challenge` varchar(256) DEFAULT NULL,
  `docker_config_id` int(11) DEFAULT NULL,
  `stack_id` varchar(128) DEFAULT NULL,
  `service_name` varchar(64) DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT NULL,
  `network_name` varchar(128) DEFAULT NULL,
  `flag` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_docker_challenge_tracker_challenge` (`challenge`),
  KEY `ix_docker_challenge_tracker_docker_image` (`docker_image`),
  KEY `ix_docker_challenge_tracker_host` (`host`),
  KEY `ix_docker_challenge_tracker_ports` (`ports`),
  KEY `ix_docker_challenge_tracker_instance_id` (`instance_id`),
  KEY `ix_docker_challenge_tracker_revert_time` (`revert_time`),
  KEY `ix_docker_challenge_tracker_user_id` (`user_id`),
  KEY `ix_docker_challenge_tracker_docker_config_id` (`docker_config_id`),
  KEY `ix_docker_challenge_tracker_team_id` (`team_id`),
  KEY `ix_docker_challenge_tracker_timestamp` (`timestamp`),
  KEY `ix_docker_challenge_tracker_stack_id` (`stack_id`),
  CONSTRAINT `docker_challenge_tracker_ibfk_1` FOREIGN KEY (`docker_config_id`) REFERENCES `docker_config` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docker_challenge_tracker`
--

LOCK TABLES `docker_challenge_tracker` WRITE;
/*!40000 ALTER TABLE `docker_challenge_tracker` DISABLE KEYS */;
/*!40000 ALTER TABLE `docker_challenge_tracker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docker_config`
--

DROP TABLE IF EXISTS `docker_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `docker_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `hostname` varchar(128) DEFAULT NULL,
  `domain` varchar(256) DEFAULT NULL,
  `tls_enabled` tinyint(1) DEFAULT NULL,
  `ca_cert` varchar(2200) DEFAULT NULL,
  `client_cert` varchar(2000) DEFAULT NULL,
  `client_key` varchar(3300) DEFAULT NULL,
  `repositories` varchar(1024) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `last_status_check` datetime(6) DEFAULT NULL,
  `status` varchar(32) DEFAULT NULL,
  `status_message` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_docker_config_hostname` (`hostname`),
  KEY `ix_docker_config_client_key` (`client_key`(768)),
  KEY `ix_docker_config_repositories` (`repositories`(768)),
  KEY `ix_docker_config_ca_cert` (`ca_cert`(768)),
  KEY `ix_docker_config_tls_enabled` (`tls_enabled`),
  KEY `ix_docker_config_client_cert` (`client_cert`(768)),
  KEY `ix_docker_config_name` (`name`),
  KEY `ix_docker_config_domain` (`domain`),
  KEY `ix_docker_config_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docker_config`
--

LOCK TABLES `docker_config` WRITE;
/*!40000 ALTER TABLE `docker_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `docker_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dynamic_challenge`
--

DROP TABLE IF EXISTS `dynamic_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `dynamic_challenge` (
  `id` int(11) NOT NULL,
  `initial` int(11) DEFAULT NULL,
  `minimum` int(11) DEFAULT NULL,
  `decay` int(11) DEFAULT NULL,
  `function` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `dynamic_challenge_ibfk_1` FOREIGN KEY (`id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_challenge`
--

LOCK TABLES `dynamic_challenge` WRITE;
/*!40000 ALTER TABLE `dynamic_challenge` DISABLE KEYS */;
/*!40000 ALTER TABLE `dynamic_challenge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `field_entries`
--

DROP TABLE IF EXISTS `field_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `field_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`value`)),
  `field_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `field_id` (`field_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `field_entries_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`) ON DELETE CASCADE,
  CONSTRAINT `field_entries_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `field_entries_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `field_entries`
--

LOCK TABLES `field_entries` WRITE;
/*!40000 ALTER TABLE `field_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `field_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fields`
--

DROP TABLE IF EXISTS `fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `field_type` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `required` tinyint(1) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  `editable` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fields`
--

LOCK TABLES `fields` WRITE;
/*!40000 ALTER TABLE `fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `location` text DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `page_id` int(11) DEFAULT NULL,
  `sha1sum` varchar(40) DEFAULT NULL,
  `solution_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `page_id` (`page_id`),
  KEY `files_ibfk_1` (`challenge_id`),
  KEY `solution_id` (`solution_id`),
  CONSTRAINT `files_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `files_ibfk_2` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`),
  CONSTRAINT `files_ibfk_3` FOREIGN KEY (`solution_id`) REFERENCES `solutions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `files`
--

LOCK TABLES `files` WRITE;
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
INSERT INTO `files` VALUES
(2,'page','4163f5e0a249150cc965567c108ee246/small-logo-without-text.png',NULL,NULL,'b297cffee05cdfdcaa9e1bf4a812fa242ed9e78a',NULL),
(3,'page','28e053d0921880ec777913aa567295e8/xyz-logo-white.png',NULL,NULL,'13d870a7c5a532e9d489dfba7f182f52b6fa2abe',NULL),
(4,'page','35f10fa7fc84e3cf2922aeb440dae8f2/xyz-logo-color.png',NULL,NULL,'3e5ea9018936f04b9e57db6f54951cb3fe2d225d',NULL),
(5,'page','3e9cd52cd53aac70df8a96bbb17d3819/TrainSec_Main_dark2x.png',NULL,NULL,'140ff0e82e247186d46e1bf97166272db0e472ae',NULL),
(6,'page','98979b9143367f7f2796eec0128a4f66/TrainSec_main2x.png',NULL,NULL,'1458c3e58a0ad8904c87490ea00340d1d889db3b',NULL),
(7,'page','598c6b65b67db7751b17c46e994dc875/seclance.png',NULL,NULL,'6a8ef6860822f09c2d078f140a7841611b25a4e7',NULL),
(8,'page','d23dbf98d11a38d0341f402cea84247a/logo_name.png',NULL,NULL,'e34397f33690f06b8af7b873c824bf6406998592',NULL),
(9,'page','88cd15557b6b2818b44911ea92e6ce4b/LetsDefend_NowPartOfHTB_FINAL-solid-color_NoWhiteSpace.png',NULL,NULL,'ca23f8c1c6b0d98627a6a3ea77ecef032d5839cb',NULL),
(10,'page','9a148b1690ec172f5d7336a21640872c/ASVerticalWhiteOutlineLogo.png',NULL,NULL,'a904e9e015b9032aa974b226da696a8c77adf911',NULL),
(11,'page','51a88b5b77f2d5629a6e4e140b7ae731/apisec-logo.png',NULL,NULL,'5ae3606aad10e04ef49c5e3775c259343d4e9292',NULL),
(12,'page','38e2ae3c57b073ed16c34757ca898b4d/Amrita.png',NULL,NULL,'ff8a94a5f3cd63ed96b23718b199b484d9e30a44',NULL);
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flags`
--

DROP TABLE IF EXISTS `flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `flags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flags_ibfk_1` (`challenge_id`),
  CONSTRAINT `flags_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flags`
--

LOCK TABLES `flags` WRITE;
/*!40000 ALTER TABLE `flags` DISABLE KEYS */;
/*!40000 ALTER TABLE `flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `geo_challenge`
--

DROP TABLE IF EXISTS `geo_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_challenge` (
  `id` int(11) NOT NULL,
  `latitude` decimal(12,10) DEFAULT NULL,
  `longitude` decimal(13,10) DEFAULT NULL,
  `tolerance_radius` decimal(10,2) DEFAULT NULL,
  `initial` int(11) DEFAULT NULL,
  `minimum` int(11) DEFAULT NULL,
  `decay` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `geo_challenge_ibfk_1` FOREIGN KEY (`id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geo_challenge`
--

LOCK TABLES `geo_challenge` WRITE;
/*!40000 ALTER TABLE `geo_challenge` DISABLE KEYS */;
/*!40000 ALTER TABLE `geo_challenge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hints`
--

DROP TABLE IF EXISTS `hints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(80) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`requirements`)),
  `title` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hints_ibfk_1` (`challenge_id`),
  CONSTRAINT `hints_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hints`
--

LOCK TABLES `hints` WRITE;
/*!40000 ALTER TABLE `hints` DISABLE KEYS */;
/*!40000 ALTER TABLE `hints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  `content` text DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifier_config`
--

DROP TABLE IF EXISTS `notifier_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifier_config` (
  `key` varchar(128) NOT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifier_config`
--

LOCK TABLES `notifier_config` WRITE;
/*!40000 ALTER TABLE `notifier_config` DISABLE KEYS */;
INSERT INTO `notifier_config` VALUES
('discord_notifier','false'),
('discord_webhook_url',''),
('telegram_bot_token',''),
('telegram_chat_id',''),
('telegram_message_thread_id',''),
('twitter_access_token',''),
('twitter_access_token_secret',''),
('twitter_consumer_key',''),
('twitter_consumer_secret',''),
('twitter_hashtags',''),
('twitter_notifier','false');
/*!40000 ALTER TABLE `notifier_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pages`
--

DROP TABLE IF EXISTS `pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(80) DEFAULT NULL,
  `route` varchar(128) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `draft` tinyint(1) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `auth_required` tinyint(1) DEFAULT NULL,
  `format` varchar(80) DEFAULT NULL,
  `link_target` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `route` (`route`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pages`
--

LOCK TABLES `pages` WRITE;
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` VALUES
(1,'L3m0nCTF','index','<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n    <meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <title>L3m0n CTF 2025 | Enter the Abyss</title>\n    \n    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n    <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>\n    <link href=\"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&family=JetBrains+Mono:wght@400;700&display=swap\" rel=\"stylesheet\">\n    \n    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css\">\n\n    <script src=\"https://cdn.tailwindcss.com\"></script>\n    \n    <script>\n        tailwind.config = {\n            theme: {\n                extend: {\n                    fontFamily: {\n                        sans: [\'Inter\', \'sans-serif\'],\n                        mono: [\'JetBrains Mono\', \'monospace\'],\n                    },\n                    colors: {\n                        lemon: {\n                            DEFAULT: \'#ccff00\',\n                            glow: \'#d9ff4d\',\n                            dim: \'#4d6600\',\n                        },\n                        obsidian: \'#050505\',\n                        glass: \'rgba(20, 20, 20, 0.6)\',\n                    },\n                    animation: {\n                        \'float\': \'float 6s ease-in-out infinite\',\n                        \'pulse-glow\': \'pulseGlow 3s infinite\',\n                        \'scanline\': \'scanline 8s linear infinite\',\n                    },\n                    keyframes: {\n                        float: {\n                            \'0%, 100%\': { transform: \'translateY(0)\' },\n                            \'50%\': { transform: \'translateY(-20px)\' },\n                        },\n                        pulseGlow: {\n                            \'0%, 100%\': { boxShadow: \'0 0 20px rgba(204, 255, 0, 0.2)\' },\n                            \'50%\': { boxShadow: \'0 0 40px rgba(204, 255, 0, 0.5)\' },\n                        },\n                        scanline: {\n                            \'0%\': { transform: \'translateY(-100%)\' },\n                            \'100%\': { transform: \'translateY(100%)\' }\n                        }\n                    }\n                }\n            }\n        }\n    </script>\n\n    <style>\n        body {\n            background-color: #050505; \n            background-image: \n                radial-gradient(circle at 50% 50%, rgba(20, 30, 40, 0.5) 0%, rgba(5, 5, 5, 1) 100%);\n            color: #e5e5e5;\n            overflow-x: hidden;\n        }\n\n        .glass-panel {\n            background: rgba(15, 15, 15, 0.4);\n            backdrop-filter: blur(12px);\n            -webkit-backdrop-filter: blur(12px);\n            border: 1px solid rgba(255, 255, 255, 0.08);\n            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);\n            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);\n        }\n\n        .glass-panel:hover {\n            border-color: rgba(204, 255, 0, 0.4);\n            transform: translateY(-2px);\n            background: rgba(20, 20, 20, 0.6);\n            box-shadow: 0 10px 40px rgba(204, 255, 0, 0.1);\n        }\n\n        .glitch-text {\n            position: relative;\n        }\n        \n        .glitch-text::before,\n        .glitch-text::after {\n            content: attr(data-text);\n            position: absolute;\n            top: 0;\n            left: 0;\n            width: 100%;\n            height: 100%;\n        }\n\n        .glitch-text::before {\n            left: 2px;\n            text-shadow: -1px 0 #ff00c1;\n            clip: rect(44px, 450px, 56px, 0);\n            animation: glitch-anim 5s infinite linear alternate-reverse;\n        }\n\n        .glitch-text::after {\n            left: -2px;\n            text-shadow: -1px 0 #00fff9;\n            clip: rect(44px, 450px, 56px, 0);\n            animation: glitch-anim2 5s infinite linear alternate-reverse;\n        }\n\n        @keyframes glitch-anim {\n            0% { clip: rect(14px, 9999px, 127px, 0); }\n            5% { clip: rect(34px, 9999px, 12px, 0); }\n            100% { clip: rect(84px, 9999px, 87px, 0); }\n        }\n        \n        @keyframes glitch-anim2 {\n            0% { clip: rect(84px, 9999px, 14px, 0); }\n            100% { clip: rect(12px, 9999px, 34px, 0); }\n        }\n\n        ::-webkit-scrollbar { width: 6px; }\n        ::-webkit-scrollbar-track { background: #050505; }\n        ::-webkit-scrollbar-thumb { background: #333; border-radius: 3px; }\n        ::-webkit-scrollbar-thumb:hover { background: #ccff00; }\n\n        .text-glow { text-shadow: 0 0 15px rgba(204, 255, 0, 0.5); }\n        .border-gradient { border-image: linear-gradient(to right, #ccff00, transparent) 1; }\n    </style>\n</head>\n<body class=\"min-h-screen relative\">\n\n    <div class=\"fixed inset-0 z-[-1] pointer-events-none\">\n        <div class=\"absolute top-0 right-0 w-[500px] h-[500px] bg-lemon/5 rounded-full blur-[120px]\"></div>\n        <div class=\"absolute bottom-0 left-0 w-[500px] h-[500px] bg-blue-500/5 rounded-full blur-[120px]\"></div>\n    </div>\n\n    <main class=\"relative z-10 pt-8 pb-20 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto\">\n        \n        <div class=\"grid lg:grid-cols-2 gap-12 items-center mb-24 min-h-[80vh]\">\n            <div class=\"order-2 lg:order-1 text-center lg:text-left\">\n                <div class=\"inline-block px-3 py-1 mb-4 border border-lemon/30 rounded-full bg-lemon/5\">\n                    <span class=\"text-lemon font-mono text-xs font-bold tracking-[0.2em] uppercase\">\n                        <i class=\"fas fa-circle text-[8px] mr-2 animate-ping\"></i>Live Registration\n                    </span>\n                </div>\n                \n                <h1 class=\"text-6xl md:text-8xl font-black text-white mb-6 leading-tight tracking-tight glitch-text\" data-text=\"L3M0N CTF\">\n                    L3M0N <br/>\n                    <span class=\"text-transparent bg-clip-text bg-gradient-to-r from-lemon to-white\">CTF 2025</span>\n                </h1>\n\n                <p class=\"text-gray-400 text-lg md:text-xl mb-8 max-w-2xl mx-auto lg:mx-0 font-light leading-relaxed\">\n                    Dive into the digital abyss. Solve the unsolvable.\n                    Presented by <span class=\"text-white font-semibold border-b border-lemon/50\">TIFAC-CORE IN CYBER SECURITY</span> & <span class=\"text-white font-semibold border-b border-lemon/50\">Amrita Vishwa Vidyapeetham</span>.\n                </p>\n\n                <div class=\"flex flex-col sm:flex-row gap-4 justify-center lg:justify-start\">\n                    <a href=\"/challenges\" class=\"group relative px-8 py-4 bg-lemon text-black font-bold text-lg rounded-xl overflow-hidden shadow-[0_0_20px_rgba(204,255,0,0.3)] hover:shadow-[0_0_40px_rgba(204,255,0,0.6)] transition-all transform hover:-translate-y-1 text-center no-underline\">\n                        <span class=\"relative z-10 flex items-center justify-center gap-2\">\n                            ENTER ARENA <i class=\"fas fa-arrow-right group-hover:translate-x-1 transition-transform\"></i>\n                        </span>\n                        <div class=\"absolute inset-0 bg-white/30 translate-y-full group-hover:translate-y-0 transition-transform duration-300\"></div>\n                    </a>\n                    \n                    <a href=\"https://discord.gg/your-discord-link\" target=\"_blank\" class=\"px-8 py-4 border border-white/20 text-white font-bold text-lg rounded-xl hover:bg-white/5 transition-all flex items-center justify-center gap-2 no-underline\">\n                        <i class=\"fab fa-discord\"></i> JOIN DISCORD\n                    </a>\n                </div>\n                \n                <div class=\"mt-10 flex flex-wrap gap-4 justify-center lg:justify-start\">\n                    <div class=\"glass-panel px-6 py-4 rounded-xl text-center min-w-[80px]\">\n                        <div id=\"days\" class=\"text-3xl font-mono font-bold text-lemon\">00</div>\n                        <div class=\"text-xs text-gray-500 uppercase tracking-wider\">Days</div>\n                    </div>\n                    <div class=\"glass-panel px-6 py-4 rounded-xl text-center min-w-[80px]\">\n                        <div id=\"hours\" class=\"text-3xl font-mono font-bold text-white\">00</div>\n                        <div class=\"text-xs text-gray-500 uppercase tracking-wider\">Hours</div>\n                    </div>\n                    <div class=\"glass-panel px-6 py-4 rounded-xl text-center min-w-[80px]\">\n                        <div id=\"minutes\" class=\"text-3xl font-mono font-bold text-white\">00</div>\n                        <div class=\"text-xs text-gray-500 uppercase tracking-wider\">Mins</div>\n                    </div>\n                    <div class=\"glass-panel px-6 py-4 rounded-xl text-center min-w-[80px]\">\n                        <div id=\"seconds\" class=\"text-3xl font-mono font-bold text-white\">00</div>\n                        <div class=\"text-xs text-gray-500 uppercase tracking-wider\">Secs</div>\n                    </div>\n                </div>\n            </div>\n\n            <div class=\"order-1 lg:order-2 flex justify-center relative\">\n                <div class=\"absolute inset-0 border border-lemon/10 rounded-full animate-[spin_10s_linear_infinite]\"></div>\n                <div class=\"absolute inset-4 border border-white/5 rounded-full animate-[spin_15s_linear_infinite_reverse]\"></div>\n                \n                <div class=\"relative w-64 h-64 md:w-96 md:h-96 animate-float\">\n                    <div class=\"absolute inset-0 bg-lemon blur-[80px] opacity-20 rounded-full\"></div>\n                    <img src=\"https://api.iconify.design/noto:lemon.svg\" alt=\"Lemon CTF Logo\" class=\"w-full h-full object-contain drop-shadow-[0_0_30px_rgba(204,255,0,0.4)] grayscale-[0.2] contrast-125\">\n                </div>\n            </div>\n        </div>\n\n        <div class=\"mb-24\">\n            <h2 class=\"text-3xl font-bold text-white text-center mb-4\">Challenge Categories</h2>\n            <p class=\"text-gray-400 text-center mb-12 max-w-2xl mx-auto\">Test your skills across multiple domains of cybersecurity</p>\n            <div class=\"flex flex-wrap justify-center gap-4\">\n                <div class=\"category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3\">\n                    <i class=\"fas fa-globe text-blue-400\"></i>\n                    <span class=\"font-semibold\">Web</span>\n                </div>\n                <div class=\"category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3\">\n                    <i class=\"fas fa-key text-purple-400\"></i>\n                    <span class=\"font-semibold\">Crypto</span>\n                </div>\n                <div class=\"category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3\">\n                    <i class=\"fas fa-microchip text-red-400\"></i>\n                    <span class=\"font-semibold\">Pwn</span>\n                </div>\n                <div class=\"category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3\">\n                    <i class=\"fas fa-bug text-green-400\"></i>\n                    <span class=\"font-semibold\">Reverse</span>\n                </div>\n                <div class=\"category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3\">\n                    <i class=\"fas fa-search text-yellow-400\"></i>\n                    <span class=\"font-semibold\">Forensics</span>\n                </div>\n                <div class=\"category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3\">\n                    <i class=\"fas fa-puzzle-piece text-pink-400\"></i>\n                    <span class=\"font-semibold\">Misc</span>\n                </div>\n                <div class=\"category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3\">\n                    <i class=\"fas fa-user-secret text-cyan-400\"></i>\n                    <span class=\"font-semibold\">OSINT</span>\n                </div>\n                <div class=\"category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3\">\n                    <i class=\"fas fa-map-marked-alt text-orange-400\"></i>\n                    <span class=\"font-semibold\">GeoSINT</span>\n                </div>\n            </div>\n        </div>\n\n        <div class=\"grid grid-cols-1 md:grid-cols-6 lg:grid-cols-12 gap-6\">\n            \n            <div class=\"glass-panel p-6 rounded-2xl md:col-span-3 lg:col-span-4 flex flex-col justify-between group\">\n                <div class=\"mb-4\">\n                    <i class=\"far fa-calendar-alt text-3xl text-lemon mb-2 group-hover:scale-110 transition-transform\"></i>\n                    <h3 class=\"text-gray-400 font-mono text-sm uppercase tracking-wider\">Timeline</h3>\n                </div>\n                <div>\n                    <p class=\"text-2xl font-bold text-white\">Dec 20 - 21</p>\n                    <p class=\"text-sm text-gray-500\">2025 Edition</p>\n                </div>\n            </div>\n\n            <div class=\"glass-panel p-6 rounded-2xl md:col-span-3 lg:col-span-4 flex flex-col justify-between group\">\n                <div class=\"mb-4\">\n                    <i class=\"fas fa-map-marker-alt text-3xl text-red-400 mb-2 group-hover:scale-110 transition-transform\"></i>\n                    <h3 class=\"text-gray-400 font-mono text-sm uppercase tracking-wider\">Location</h3>\n                </div>\n                <div>\n                    <p class=\"text-xl font-bold text-white leading-tight\">Amrita Vishwa Vidyapeetham</p>\n                    <p class=\"text-sm text-gray-500\">Coimbatore, India</p>\n                </div>\n            </div>\n\n            <div class=\"glass-panel p-6 rounded-2xl md:col-span-6 lg:col-span-4 flex flex-col justify-between group\">\n                <div class=\"mb-4\">\n                    <i class=\"fas fa-terminal text-3xl text-blue-400 mb-2 group-hover:scale-110 transition-transform\"></i>\n                    <h3 class=\"text-gray-400 font-mono text-sm uppercase tracking-wider\">Format</h3>\n                </div>\n                <div class=\"flex gap-4\">\n                    <div>\n                        <p class=\"text-xl font-bold text-white\">Jeopardy</p>\n                        <p class=\"text-sm text-gray-500\">Style</p>\n                    </div>\n                    <div class=\"w-[1px] bg-white/10\"></div>\n                    <div>\n                        <p class=\"text-xl font-bold text-white\">24</p>\n                        <p class=\"text-sm text-gray-500\">Hours</p>\n                    </div>\n                </div>\n            </div>\n\n            <div class=\"glass-panel p-8 rounded-2xl md:col-span-6 lg:col-span-7 relative overflow-hidden group border-lemon/30\">\n                <div class=\"absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity\">\n                    <i class=\"fas fa-trophy text-9xl text-lemon transform rotate-12\"></i>\n                </div>\n                <div class=\"relative z-10\">\n                    <h3 class=\"text-lemon font-mono font-bold uppercase tracking-widest mb-2 flex items-center gap-2\">\n                        <i class=\"fas fa-star animate-spin\"></i> Prize Pool\n                    </h3>\n                    <div class=\"text-5xl md:text-7xl font-black text-white mb-2 text-glow\">\n                        $14,000+\n                    </div>\n                    <p class=\"text-gray-400 max-w-md\">\n                        Massive rewards in cash, vouchers, and exclusive swag waiting for the top ranked teams.\n                    </p>\n                </div>\n            </div>\n\n            <div class=\"glass-panel p-8 rounded-2xl md:col-span-6 lg:col-span-5 flex flex-col justify-center relative overflow-hidden group\">\n                <div class=\"absolute inset-0 bg-gradient-to-br from-purple-500/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity\"></div>\n                <div class=\"relative z-10\">\n                    <div class=\"w-12 h-12 rounded-full bg-white/10 flex items-center justify-center mb-4 group-hover:bg-lemon group-hover:text-black transition-colors\">\n                        <i class=\"fas fa-briefcase text-xl\"></i>\n                    </div>\n                    <h3 class=\"text-2xl font-bold text-white mb-2\">Internship Opportunities</h3>\n                    <p class=\"text-gray-400 text-sm\">\n                        Direct interview access with top cybersecurity firms for high performers.\n                    </p>\n                </div>\n            </div>\n        </div>\n\n        <div class=\"mt-24 text-center border-t border-white/5 pt-12\">\n            <p class=\"text-gray-500 font-mono text-sm mb-4\">POWERED BY</p>\n            <div class=\"flex flex-wrap justify-center items-center gap-8 md:gap-12 opacity-70 grayscale hover:grayscale-0 transition-all duration-500\">\n                <div class=\"text-xl font-bold text-white flex items-center gap-2\">\n                    <i class=\"fas fa-university\"></i> AMRITA VISHWA VIDYAPEETHAM\n                </div>\n                <div class=\"h-4 w-[1px] bg-white/20 hidden md:block\"></div>\n                <div class=\"text-xl font-bold text-white flex items-center gap-2\">\n                    <i class=\"fas fa-shield-alt\"></i> TIFAC-CORE IN CYBER SECURITY\n                </div>\n            </div>\n            \n            <div class=\"mt-12 flex justify-center gap-6\">\n                <a href=\"#\" class=\"text-gray-400 hover:text-lemon transition-colors\"><i class=\"fab fa-twitter text-xl\"></i></a>\n                <a href=\"#\" class=\"text-gray-400 hover:text-lemon transition-colors\"><i class=\"fab fa-instagram text-xl\"></i></a>\n                <a href=\"#\" class=\"text-gray-400 hover:text-lemon transition-colors\"><i class=\"fab fa-linkedin text-xl\"></i></a>\n            </div>\n            \n            <p class=\"text-gray-600 text-xs mt-8 font-mono\">\n                &copy; 2025 L3m0n CTF. All systems operational.\n            </p>\n        </div>\n\n    </main>\n\n    <script>\n        document.addEventListener(\'DOMContentLoaded\', () => {\n            const countDownDate = new Date(\"Dec 20, 2025 09:00:00\").getTime();\n\n            const x = setInterval(function() {\n                const now = new Date().getTime();\n                const distance = countDownDate - now;\n\n                const days = Math.floor(distance / (1000 * 60 * 60 * 24));\n                const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));\n                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));\n                const seconds = Math.floor((distance % (1000 * 60)) / 1000);\n\n                document.getElementById(\"days\").textContent = days < 10 ? \"0\" + days : days;\n                document.getElementById(\"hours\").textContent = hours < 10 ? \"0\" + hours : hours;\n                document.getElementById(\"minutes\").textContent = minutes < 10 ? \"0\" + minutes : minutes;\n                document.getElementById(\"seconds\").textContent = seconds < 10 ? \"0\" + seconds : seconds;\n\n                if (distance < 0) {\n                    clearInterval(x);\n                    document.getElementById(\"days\").textContent = \"00\";\n                    document.getElementById(\"hours\").textContent = \"00\";\n                    document.getElementById(\"minutes\").textContent = \"00\";\n                    document.getElementById(\"seconds\").textContent = \"00\";\n                }\n            }, 1000);\n        });\n    </script>\n</body>\n</html>\n',0,0,0,'html',NULL),
(2,'Sponsors','sponsors','<link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n<link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>\n<link href=\"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&family=JetBrains+Mono:wght@400;700&display=swap\" rel=\"stylesheet\">\n<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css\">\n<script src=\"https://cdn.tailwindcss.com\"></script>\n\n<style>\n.sponsor-section {\n    font-family: \'Inter\', sans-serif;\n    padding: 60px 20px;\n    max-width: 1200px;\n    margin: 0 auto;\n}\n\n.section-header {\n    text-align: center;\n    margin-bottom: 50px;\n}\n\n.section-badge {\n    display: inline-flex;\n    align-items: center;\n    gap: 8px;\n    padding: 8px 20px;\n    border-radius: 50px;\n    background: rgba(204, 255, 0, 0.1);\n    border: 1px solid rgba(204, 255, 0, 0.3);\n    margin-bottom: 20px;\n}\n\n.section-badge i { color: #ccff00; }\n.section-badge span {\n    color: #ccff00;\n    font-family: \'JetBrains Mono\', monospace;\n    font-size: 0.85rem;\n    font-weight: 700;\n    letter-spacing: 0.15em;\n    text-transform: uppercase;\n}\n\n.section-title {\n    font-size: 3.5rem;\n    font-weight: 900;\n    color: #fff;\n    margin: 0 0 20px 0;\n    text-shadow: 0 0 40px rgba(204, 255, 0, 0.3);\n}\n\n.section-title span {\n    background: linear-gradient(90deg, #ccff00, #ffffff);\n    -webkit-background-clip: text;\n    -webkit-text-fill-color: transparent;\n}\n\n.section-subtitle {\n    color: #e5e5e5;\n    font-size: 1.15rem;\n    max-width: 700px;\n    margin: 0 auto;\n    line-height: 1.7;\n}\n\n.sponsors-grid {\n    display: grid;\n    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));\n    gap: 28px;\n}\n\n.sponsor-card {\n    background: rgba(20, 20, 25, 0.8);\n    border: 1px solid rgba(255, 255, 255, 0.08);\n    padding: 32px 28px;\n    border-radius: 24px;\n    transition: all 0.4s ease;\n    backdrop-filter: blur(10px);\n    text-align: center;\n}\n\n.sponsor-card:hover {\n    border-color: rgba(204, 255, 0, 0.4);\n    transform: translateY(-8px);\n    box-shadow: 0 25px 60px rgba(204, 255, 0, 0.12);\n}\n\n.logo-container {\n    width: 100%;\n    height: 120px;\n    background: rgba(255, 255, 255, 0.95);\n    border-radius: 16px;\n    display: flex;\n    align-items: center;\n    justify-content: center;\n    padding: 20px;\n    margin-bottom: 24px;\n}\n\n.logo-container.dark-bg {\n    background: #1a1a2e;\n}\n\n.logo-container img {\n    max-width: 100%;\n    max-height: 90px;\n    object-fit: contain;\n}\n\n.sponsor-card h4 {\n    color: #fff;\n    font-size: 1.5rem;\n    font-weight: 700;\n    margin: 0 0 16px 0;\n    display: flex;\n    align-items: center;\n    justify-content: center;\n    gap: 10px;\n}\n\n.sponsor-card h4 i { font-size: 1.1rem; }\n\n.sponsor-card p {\n    color: #e5e5e5;\n    font-size: 0.95rem;\n    line-height: 1.7;\n    margin: 0;\n}\n</style>\n\n<div class=\"sponsor-section\">\n    <div class=\"section-header\">\n        <div class=\"section-badge\">\n            <i class=\"fas fa-star\"></i>\n            <span>Thank You</span>\n        </div>\n        <h1 class=\"section-title\">Our <span>Sponsors</span></h1>\n        <p class=\"section-subtitle\">\n            A huge thank you to all the incredible organizations that made this event possible. Their support drives the future of cybersecurity.\n        </p>\n    </div>\n\n    <div class=\"sponsors-grid\">\n        \n        <div class=\"sponsor-card\">\n            <div class=\"logo-container dark-bg\">\n                <img src=\"/files/9a148b1690ec172f5d7336a21640872c/ASVerticalWhiteOutlineLogo.png\" alt=\"Altered Security\">\n            </div>\n            <h4>Altered Security <i class=\"fas fa-shield-alt\" style=\"color: #ef4444;\"></i></h4>\n            <p>An industry leader in offensive security training and certification programs. They specialize in hands-on red teaming, exploit development, and adversary simulation for professionals.</p>\n        </div>\n\n        <div class=\"sponsor-card\">\n            <div class=\"logo-container\">\n                <img src=\"/files/51a88b5b77f2d5629a6e4e140b7ae731/apisec-logo.png\" alt=\"APISEC University\">\n            </div>\n            <h4>APISEC University <i class=\"fas fa-code\" style=\"color: #3b82f6;\"></i></h4>\n            <p>A dedicated platform for API security education, offering structured training on secure API design, testing, and defense. Their courses help learners understand and secure modern API ecosystems.</p>\n        </div>\n\n        <div class=\"sponsor-card\">\n            <div class=\"logo-container\">\n                <img src=\"/files/d23dbf98d11a38d0341f402cea84247a/logo_name.png\" alt=\"Caido\">\n            </div>\n            <h4>Caido <i class=\"fas fa-bug\" style=\"color: #a855f7;\"></i></h4>\n            <p>A lightweight web security auditing toolkit designed for efficient application testing. It helps security professionals and researchers analyze and identify issues in web applications with modern workflows.</p>\n        </div>\n\n        <div class=\"sponsor-card\">\n            <div class=\"logo-container\">\n                <img src=\"/files/88cd15557b6b2818b44911ea92e6ce4b/LetsDefend_NowPartOfHTB_FINAL-solid-color_NoWhiteSpace.png\" alt=\"LetsDefend\">\n            </div>\n            <h4>LetsDefend <i class=\"fas fa-user-shield\" style=\"color: #22c55e;\"></i></h4>\n            <p>A practical cyber security training platform focused on blue team skills and SOC operations. It offers SOC simulations, incident response labs, and real-world defensive scenarios for learners.</p>\n        </div>\n\n        <div class=\"sponsor-card\">\n            <div class=\"logo-container\">\n                <img src=\"/files/598c6b65b67db7751b17c46e994dc875/seclance.png\" alt=\"Seclance\">\n            </div>\n            <h4>Seclance <i class=\"fas fa-certificate\" style=\"color: #eab308;\"></i></h4>\n            <p>A cyber security company providing consulting, training, and certification programs. Known for expert-led courses and high success rates, they help professionals upskill in key security domains.</p>\n        </div>\n\n        <div class=\"sponsor-card\">\n            <div class=\"logo-container\">\n                <img src=\"/files/3e9cd52cd53aac70df8a96bbb17d3819/TrainSec_Main_dark2x.png\" alt=\"TrainSec\">\n            </div>\n            <h4>TrainSec <i class=\"fas fa-graduation-cap\" style=\"color: #06b6d4;\"></i></h4>\n            <p>A security training academy offering in-depth courses on malware analysis, Windows internals, and advanced defensive concepts. They focus on developing strong technical expertise through practical learning.</p>\n        </div>\n\n        <div class=\"sponsor-card\">\n            <div class=\"logo-container\">\n                <img src=\"/files/35f10fa7fc84e3cf2922aeb440dae8f2/xyz-logo-color.png\" alt=\"XYZ\">\n            </div>\n            <h4>XYZ <i class=\"fas fa-globe\" style=\"color: #f97316;\"></i></h4>\n            <p>A global provider of domain and digital identity solutions. They power online presence for businesses, creators, and startups through flexible domain naming and infrastructure.</p>\n        </div>\n\n    </div>\n</div>\n',0,0,0,'html',NULL),
(3,'Test Page','test','<div class=\"container py-5\"><h1 class=\"text-center\">Test Page</h1><p class=\"text-center\">This is a test page for L3m0nCTF.</p></div>',0,1,0,'html',NULL);
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `review` varchar(2000) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`challenge_id`),
  KEY `challenge_id` (`challenge_id`),
  CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solutions`
--

DROP TABLE IF EXISTS `solutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `solutions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `state` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `challenge_id` (`challenge_id`),
  CONSTRAINT `solutions_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solutions`
--

LOCK TABLES `solutions` WRITE;
/*!40000 ALTER TABLE `solutions` DISABLE KEYS */;
/*!40000 ALTER TABLE `solutions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solves`
--

DROP TABLE IF EXISTS `solves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `solves` (
  `id` int(11) NOT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `challenge_id` (`challenge_id`,`team_id`),
  UNIQUE KEY `challenge_id_2` (`challenge_id`,`user_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `solves_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solves_ibfk_2` FOREIGN KEY (`id`) REFERENCES `submissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solves_ibfk_3` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solves_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solves`
--

LOCK TABLES `solves` WRITE;
/*!40000 ALTER TABLE `solves` DISABLE KEYS */;
/*!40000 ALTER TABLE `solves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submissions`
--

DROP TABLE IF EXISTS `submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `submissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `ip` varchar(46) DEFAULT NULL,
  `provided` text DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `challenge_id` (`challenge_id`),
  KEY `team_id` (`team_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submissions`
--

LOCK TABLES `submissions` WRITE;
/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge_id` int(11) DEFAULT NULL,
  `value` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tags_ibfk_1` (`challenge_id`),
  CONSTRAINT `tags_ibfk_1` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oauth_id` int(11) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `secret` varchar(128) DEFAULT NULL,
  `website` varchar(128) DEFAULT NULL,
  `affiliation` varchar(128) DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `captain_id` int(11) DEFAULT NULL,
  `bracket_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `id` (`id`,`oauth_id`),
  UNIQUE KEY `oauth_id` (`oauth_id`),
  KEY `team_captain_id` (`captain_id`),
  KEY `bracket_id` (`bracket_id`),
  CONSTRAINT `team_captain_id` FOREIGN KEY (`captain_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`bracket_id`) REFERENCES `brackets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES
(1,NULL,'lemon-admin',NULL,'$bcrypt-sha256$v=2,t=2b,r=12$z8sQVG0O8RGBZaG1o4O9mu$lWIVkm7ePvpyCaUxBSt4KjYDkjm6ibG',NULL,NULL,NULL,NULL,1,0,'2025-12-03 15:19:02.207963',1,NULL);
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `expiration` datetime(6) DEFAULT NULL,
  `value` varchar(128) DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`value`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topics`
--

LOCK TABLES `topics` WRITE;
/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracking`
--

DROP TABLE IF EXISTS `tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) DEFAULT NULL,
  `ip` varchar(46) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `target` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tracking_ibfk_1` (`user_id`),
  CONSTRAINT `tracking_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracking`
--

LOCK TABLES `tracking` WRITE;
/*!40000 ALTER TABLE `tracking` DISABLE KEYS */;
INSERT INTO `tracking` VALUES
(1,NULL,'192.168.65.1',1,'2025-12-04 06:43:38.531086',NULL),
(2,NULL,'172.19.0.1',1,'2025-12-04 06:22:41.017844',NULL),
(3,NULL,'172.67.185.159',1,'2025-12-04 18:37:40.103019',NULL);
/*!40000 ALTER TABLE `tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unlocks`
--

DROP TABLE IF EXISTS `unlocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `unlocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `target` int(11) DEFAULT NULL,
  `date` datetime(6) DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `unlocks_ibfk_1` (`team_id`),
  KEY `unlocks_ibfk_2` (`user_id`),
  CONSTRAINT `unlocks_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `unlocks_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unlocks`
--

LOCK TABLES `unlocks` WRITE;
/*!40000 ALTER TABLE `unlocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `unlocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oauth_id` int(11) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `type` varchar(80) DEFAULT NULL,
  `secret` varchar(128) DEFAULT NULL,
  `website` varchar(128) DEFAULT NULL,
  `affiliation` varchar(128) DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `created` datetime(6) DEFAULT NULL,
  `language` varchar(32) DEFAULT NULL,
  `bracket_id` int(11) DEFAULT NULL,
  `change_password` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `id` (`id`,`oauth_id`),
  UNIQUE KEY `oauth_id` (`oauth_id`),
  KEY `team_id` (`team_id`),
  KEY `bracket_id` (`bracket_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`bracket_id`) REFERENCES `brackets` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,NULL,'lemon-admin','$bcrypt-sha256$v=2,t=2b,r=12$ivhUGff2yLMABGYn5GnrLe$EyNrr99QRzSWZL99YHyEmlL41V6nbgm','praneeshrv404@gmail.com','admin',NULL,NULL,NULL,NULL,1,0,0,1,'2025-12-01 06:38:31.912277',NULL,NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-04 19:09:07
