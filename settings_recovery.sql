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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(6,'setup','true'),
(7,'ctf_name','L3m0nCTF'),
(8,'ctf_description','L3m0nCTF 2025'),
(9,'user_mode','users'),
(10,'ctf_theme','core'),
(11,'challenge_visibility','public'),
(12,'score_visibility','public'),
(13,'account_visibility','public'),
(14,'registration_visibility','public'),
(15,'verify_emails','false'),
(16,'mail_server',''),
(17,'mail_port',''),
(18,'mail_useauth',''),
(19,'mail_username',''),
(20,'mail_password',''),
(21,'mail_tls',''),
(22,'mail_ssl',''),
(23,'mail_sender_addr',''),
(24,'start',''),
(25,'end',''),
(26,'freeze',''),
(27,'version_latest','https://github.com/CTFd/CTFd/releases/tag/3.8.1'),
(28,'next_update_check','1764541559');
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
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
  KEY `ix_docker_config_tls_enabled` (`tls_enabled`),
  KEY `ix_docker_config_repositories` (`repositories`(768)),
  KEY `ix_docker_config_is_active` (`is_active`),
  KEY `ix_docker_config_client_key` (`client_key`(768)),
  KEY `ix_docker_config_name` (`name`),
  KEY `ix_docker_config_domain` (`domain`),
  KEY `ix_docker_config_ca_cert` (`ca_cert`(768)),
  KEY `ix_docker_config_client_cert` (`client_cert`(768)),
  KEY `ix_docker_config_hostname` (`hostname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docker_config`
--

LOCK TABLES `docker_config` WRITE;
/*!40000 ALTER TABLE `docker_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `docker_config` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-01  4:57:55
