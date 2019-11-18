-- MySQL dump 10.13  Distrib 8.0.16, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gregs_list
-- ------------------------------------------------------
-- Server version	8.0.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT = @@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS = @@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION = @@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40103 SET @OLD_TIME_ZONE = @@TIME_ZONE */;
/*!40103 SET TIME_ZONE = '+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0 */;
/*!40101 SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES = @@SQL_NOTES, SQL_NOTES = 0 */;

--
-- Table structure for table `doughtnut_list`
--

DROP TABLE IF EXISTS `doughtnut_list`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `doughtnut_list`
(
    `doughnut_name` varchar(10) DEFAULT NULL,
    `doughnut_type` varchar(6)  DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doughtnut_list`
--

LOCK TABLES `doughtnut_list` WRITE;
/*!40000 ALTER TABLE `doughtnut_list`
    DISABLE KEYS */;
/*!40000 ALTER TABLE `doughtnut_list`
    ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `my_contacts`
--

DROP TABLE IF EXISTS `my_contacts`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
SET character_set_client = utf8mb4;
CREATE TABLE `my_contacts`
(
    `last_name`  varchar(30)  DEFAULT NULL,
    `first_name` varchar(20) NOT NULL,
    `email`      varchar(50)  DEFAULT NULL,
    `gender`     char(1)      DEFAULT NULL,
    `birthday`   date         DEFAULT NULL,
    `profession` varchar(50)  DEFAULT NULL,
    `location`   varchar(50)  DEFAULT NULL,
    `status`     varchar(20)  DEFAULT 'Single',
    `interest`   varchar(100) DEFAULT NULL,
    `seeking`    varchar(100) DEFAULT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `my_contacts`
--

LOCK TABLES `my_contacts` WRITE;
/*!40000 ALTER TABLE `my_contacts`
    DISABLE KEYS */;
INSERT INTO `my_contacts` (`last_name`, `first_name`, `email`, `gender`, `birthday`, `profession`, `location`, `status`,
                           `interest`, `seeking`)
VALUES ('Anderson', 'Jillian', 'jill_anderson@breakneckpizza.com', 'F', '1980-09-05', 'TechnicalWriter',
        'Palo Alto, CA', 'Single', 'Kayaking, Reptiles', 'Relationship, Friends'),
       ('Banderson', 'Gillian', 'gill_banderson@breakneckpizza.com', 'F', '1980-09-05', 'TechnicalWriter',
        'Palo Alto, CA', 'Single', 'Kayaking, Reptiles', 'Relationship, Friends'),
       ('Baanderson', 'GGillian', 'ggill_baanderson@breakneckpizza.com', 'F', '1980-09-05', 'TechnicalWriter',
        'Palo Alto, CA', 'Single', 'Kayaking, Reptiles', 'Relationship, Friends'),
       (NULL, 'Pat', 'patpost@breakingpizza.com', NULL, NULL, 'Postal Worker', 'Princeton, NJ', 'Single', NULL, NULL),
       ('A', 'Anne', 'annea@tom.com', 'F', NULL, NULL, 'San Francisco, CA', 'Single', NULL, 'Relationship, Friends'),
       ('B', 'Anne', 'anneb@tom.com', 'F', NULL, NULL, 'San Francisco, CA', 'Married', NULL, 'Friends'),
       ('C', 'Anne', 'annec@tom.com', 'F', NULL, NULL, 'Los Angles, CA', 'Single', NULL, 'Relationship, Friends'),
       ('D', 'Anne', 'anned@tom.com', 'F', NULL, NULL, 'San Francisco, CA', 'Single', NULL, 'Relationship, Friends'),
       ('E', 'Anne', 'annee@tom.com', 'F', NULL, NULL, 'Los Angles, CA', 'Single', NULL, 'Relationship, Friends'),
       ('F', 'Anne', 'annef@tom.com', 'F', NULL, NULL, 'San Francisco, CA', 'Married', NULL, 'Friends');
/*!40000 ALTER TABLE `my_contacts`
    ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE = @OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;

-- Dump completed on 2019-07-24 23:17:34
