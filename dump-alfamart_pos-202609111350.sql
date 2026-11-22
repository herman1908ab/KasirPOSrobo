-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: acela.proxy.rlwy.net    Database: alfamart_pos
-- ------------------------------------------------------
-- Server version	9.7.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

-- SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `cashiers`
--

DROP TABLE IF EXISTS `cashiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cashiers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pin` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','cashier') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cashier',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cashiers`
--

LOCK TABLES `cashiers` WRITE;
/*!40000 ALTER TABLE `cashiers` DISABLE KEYS */;
INSERT INTO `cashiers` VALUES (1,'Administrator','admin','123456','admin',1,'2026-08-16 23:33:41'),(2,'Andi Setiawan','andi','111111','cashier',1,'2026-08-16 23:33:41'),(3,'Budi Santoso','budi','222222','cashier',1,'2026-08-16 23:33:41');
/*!40000 ALTER TABLE `cashiers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 0xF09F93A6,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Minuman','🥤',1,1,'2026-08-16 23:33:41','2026-08-17 12:05:47'),(2,'Makanan','🍜',1,2,'2026-08-16 23:33:41','2026-08-17 12:05:47'),(3,'Snack','🍪',1,3,'2026-08-16 23:33:41','2026-08-17 12:05:47'),(4,'Kebersihan','🧼',1,4,'2026-08-16 23:33:41','2026-08-17 12:05:47'),(5,'Rokok','🚬',1,5,'2026-08-16 23:33:41','2026-08-17 12:05:47'),(6,'Susu','🥛',1,6,'2026-08-16 23:33:41','2026-08-17 12:05:47'),(7,'Kesehatan','💊',1,7,'2026-08-16 23:33:41','2026-08-17 12:05:47');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int unsigned NOT NULL,
  `barcode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `cost_price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `stock` int NOT NULL DEFAULT '0',
  `min_stock` int NOT NULL DEFAULT '5',
  `unit` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pcs',
  `emoji` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 0xF09F93A6,
  `image_url` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `promo_label` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `barcode` (`barcode`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'8999999010011','Aqua 600ml','',4000.00,2800.00,48,10,'botol','💧','/uploads/product_1786945333824_17492.png',NULL,1,'2026-08-16 23:33:41','2026-08-22 11:01:13'),(2,1,'8999999010012','Teh Botol 350ml','',5500.00,3500.00,19,8,'botol','🍵','/uploads/product_1786945335660_340133.png','PROMO',1,'2026-08-16 23:33:41','2026-08-29 22:17:45'),(3,1,'8999999010013','Coca-Cola 390ml','',7500.00,5500.00,100,8,'kaleng','🥤','/uploads/product_1786945334132_984202.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:46:41'),(4,1,'8999999010014','Pocari Sweat 500ml','',9000.00,6500.00,111,5,'botol','🍶','/uploads/product_1786945335385_996893.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:47:04'),(5,1,'8999999010015','Good Day Coffee 250ml','',6500.00,4500.00,100,5,'kaleng','☕','/uploads/product_1786945334638_634243.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:46:51'),(6,1,'8999999010016','Mizone 500ml','',8000.00,5800.00,100,5,'botol','🧴','/uploads/product_1786945335146_591176.png','BOGO',1,'2026-08-16 23:33:41','2026-08-28 13:46:58'),(7,2,'8999999020011','Indomie Goreng','',3500.00,2500.00,99,20,'bungkus','🍜','/uploads/product_1786945335968_161495.png',NULL,1,'2026-08-16 23:33:41','2026-08-29 22:17:45'),(8,2,'8999999020012','Pop Mie Ayam','',4500.00,3200.00,0,15,'cup','🍲','/uploads/product_1786945336393_705053.png',NULL,1,'2026-08-16 23:33:41','2026-08-27 18:27:31'),(9,2,'8999999020013','Richeese Nabati','',8000.00,5800.00,99,10,'bungkus','🧀','/uploads/product_1786945336699_409267.png','PROMO',1,'2026-08-16 23:33:41','2026-08-29 22:17:45'),(10,2,'8999999020014','Sari Roti Tawar','',16500.00,12000.00,100,5,'bungkus','🍞','/uploads/product_1786945337013_215894.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:47:37'),(11,3,'8999999030011','Chitato 55gr','',12000.00,8500.00,100,10,'bungkus','🥔','/uploads/product_1786945338228_416007.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:47:54'),(12,3,'8999999030012','Cheetos 55gr','',11000.00,8000.00,100,10,'bungkus','🌽','/uploads/product_1786945337727_465283.png','2+1',1,'2026-08-16 23:33:41','2026-08-28 13:47:49'),(13,3,'8999999030013','Oreo Original','',5500.00,4000.00,100,10,'bungkus','🍪','/uploads/product_1786945338547_107724.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:47:59'),(14,3,'8999999030014','Biskuat 6pcs','',7500.00,5500.00,100,8,'bungkus','🌾','/uploads/product_1786945337302_644750.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:47:43'),(15,4,'8999999040011','Lifebuoy Sabun','',6000.00,4200.00,100,8,'buah','🧼','/uploads/product_1786945338954_399023.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:48:04'),(16,4,'8999999040012','Pepsodent 75gr','',10500.00,7500.00,100,8,'tube','🦷','/uploads/product_1786945339356_717795.png','PROMO',1,'2026-08-16 23:33:41','2026-08-28 13:48:13'),(17,4,'8999999040013','Rinso Sachet','',2000.00,1400.00,55,15,'sachet','🫧','/uploads/product_1786945365135_753964.png',NULL,1,'2026-08-16 23:33:41','2026-08-27 18:26:31'),(18,5,'8999999050011','Gudang Garam 12','',24000.00,19500.00,100,10,'bungkus','🚬','/uploads/product_1786945355099_679337.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:48:17'),(19,5,'8999999050012','Sampoerna Mild 16','',27000.00,22000.00,12,10,'bungkus','🚬','/uploads/product_1786945355522_929761.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:48:23'),(20,6,'8999999060011','Ultra Milk Full Cream','',5500.00,4000.00,100,8,'kotak','🥛','/uploads/product_1786945356453_620694.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:48:38'),(21,6,'8999999060012','Indomilk Coklat 200ml','',5000.00,3500.00,100,10,'kotak','🍫','/uploads/product_1786945356143_411937.png','PROMO',1,'2026-08-16 23:33:41','2026-08-28 13:48:33'),(22,6,'8999999060013','Dancow Sachet','',9500.00,7000.00,100,5,'sachet','🥛','/uploads/product_1786945355839_120489.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:48:28'),(23,7,'8999999070011','Panadol 4 Tablet','',8000.00,5500.00,1000,10,'strip','💊','/uploads/product_1786945357101_111996.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:49:15'),(24,7,'8999999070012','Tolak Angin Sachet','',4500.00,3200.00,0,8,'sachet','🌿','/uploads/product_1786945357463_184197.png',NULL,1,'2026-08-16 23:33:41','2026-08-27 18:25:16'),(25,7,'8999999070013','Betadine 5ml','',11000.00,8000.00,1000,5,'botol','🩹','/uploads/product_1786945356753_398323.png',NULL,1,'2026-08-16 23:33:41','2026-08-28 13:48:53'),(26,7,'12133344','losion',NULL,15000.00,14000.00,100000,5,'tube','📦',NULL,NULL,1,'2026-08-17 01:11:49','2026-08-28 13:49:04'),(27,7,'12133345','OBH Combi Sachet','tes demo',5000.00,4000.00,1000,5,'sachet','⚕️',NULL,NULL,1,'2026-08-23 12:10:09','2026-08-28 13:49:10');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_logs`
--

DROP TABLE IF EXISTS `stock_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_logs` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int unsigned NOT NULL,
  `change_type` enum('sale','restock','adjustment','initial') COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty_before` int NOT NULL,
  `qty_change` int NOT NULL,
  `qty_after` int NOT NULL,
  `reference` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cashier_id` int unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cashier_id` (`cashier_id`),
  KEY `idx_product` (`product_id`),
  KEY `idx_created` (`created_at`),
  CONSTRAINT `stock_logs_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `stock_logs_ibfk_2` FOREIGN KEY (`cashier_id`) REFERENCES `cashiers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_logs`
--

LOCK TABLES `stock_logs` WRITE;
/*!40000 ALTER TABLE `stock_logs` DISABLE KEYS */;
INSERT INTO `stock_logs` VALUES (1,26,'initial',0,20,20,'Stok awal',NULL,'2026-08-17 01:11:49'),(2,6,'sale',15,-1,14,'INV-20260816-8236',1,'2026-08-17 01:12:13'),(3,5,'sale',18,-1,17,'INV-20260816-8236',1,'2026-08-17 01:12:13'),(4,14,'sale',22,-2,20,'INV-20260817-8866',1,'2026-08-17 08:57:22'),(5,12,'sale',28,-1,27,'INV-20260817-8866',1,'2026-08-17 08:57:22'),(6,13,'sale',45,-1,44,'INV-20260817-8866',1,'2026-08-17 08:57:22'),(7,3,'sale',25,-1,24,'INV-20260817-4674',1,'2026-08-17 11:16:58'),(8,8,'sale',60,-1,59,'INV-20260817-4674',1,'2026-08-17 11:16:58'),(9,9,'sale',40,-1,39,'INV-20260817-4674',1,'2026-08-17 11:16:58'),(10,17,'sale',60,-2,58,'INV-20260817-4674',1,'2026-08-17 11:16:58'),(11,19,'sale',45,-1,44,'INV-20260817-4674',1,'2026-08-17 11:16:58'),(12,22,'sale',20,-1,19,'INV-20260817-4674',1,'2026-08-17 11:16:58'),(13,15,'sale',30,-1,29,'INV-20260817-2495',1,'2026-08-17 11:17:18'),(14,11,'sale',35,-1,34,'INV-20260817-2495',1,'2026-08-17 11:17:18'),(15,13,'sale',44,-1,43,'INV-20260817-2495',1,'2026-08-17 11:17:18'),(16,14,'sale',20,-1,19,'INV-20260817-2495',1,'2026-08-17 11:17:18'),(17,10,'sale',12,-2,10,'INV-20260817-2495',1,'2026-08-17 11:17:18'),(18,21,'sale',35,-1,34,'INV-20260817-2495',1,'2026-08-17 11:17:18'),(19,20,'sale',30,-2,28,'INV-20260817-2495',1,'2026-08-17 11:17:18'),(20,25,'sale',15,-1,14,'INV-20260817-2495',1,'2026-08-17 11:17:18'),(21,5,'sale',17,-1,16,'INV-20260817-3811',1,'2026-08-17 11:18:02'),(22,3,'sale',24,-2,22,'INV-20260817-3811',1,'2026-08-17 11:18:02'),(23,2,'sale',30,-3,27,'INV-20260817-3811',1,'2026-08-17 11:18:02'),(24,9,'sale',39,-2,37,'INV-20260817-3811',1,'2026-08-17 11:18:02'),(25,13,'sale',43,-1,42,'INV-20260817-3811',1,'2026-08-17 11:18:02'),(26,15,'sale',29,-2,27,'INV-20260817-3811',1,'2026-08-17 11:18:02'),(27,26,'sale',20,-2,18,'INV-20260817-3811',1,'2026-08-17 11:18:02'),(28,24,'sale',25,-1,24,'INV-20260817-3811',1,'2026-08-17 11:18:02'),(29,23,'sale',40,-1,39,'INV-20260817-3811',1,'2026-08-17 11:18:02'),(30,5,'sale',16,-1,15,'INV-20260817-3642',1,'2026-08-17 12:17:40'),(31,6,'sale',14,-1,13,'INV-20260817-3642',1,'2026-08-17 12:17:40'),(32,26,'sale',18,-1,17,'INV-20260817-3642',1,'2026-08-17 12:17:40'),(33,23,'sale',39,-1,38,'INV-20260817-3642',1,'2026-08-17 12:17:40'),(34,21,'sale',34,-1,33,'INV-20260817-3642',1,'2026-08-17 12:17:40'),(35,20,'sale',28,-3,25,'INV-20260817-3642',1,'2026-08-17 12:17:40'),(36,18,'sale',50,-2,48,'INV-20260817-7815',1,'2026-08-17 12:17:55'),(37,19,'sale',44,-3,41,'INV-20260817-5248',1,'2026-08-17 12:18:09'),(38,8,'sale',59,-1,58,'INV-20260817-6690',1,'2026-08-17 12:44:07'),(39,20,'sale',25,-2,23,'INV-20260817-4383',1,'2026-08-17 12:45:04'),(40,6,'sale',13,-1,12,'INV-20260817-3139',1,'2026-08-17 12:59:39'),(41,9,'sale',37,-1,36,'INV-20260817-3139',1,'2026-08-17 12:59:39'),(42,5,'sale',15,-1,14,'INV-20260820-3300',1,'2026-08-20 15:38:02'),(43,7,'sale',100,-1,99,'INV-20260821-7592',1,'2026-08-21 11:27:55'),(44,8,'sale',58,-1,57,'INV-20260821-7592',1,'2026-08-21 11:27:55'),(45,9,'sale',36,-1,35,'INV-20260821-7592',1,'2026-08-21 11:27:55'),(46,17,'sale',58,-1,57,'INV-20260821-7592',1,'2026-08-21 11:27:55'),(47,1,'sale',50,-1,49,'INV-20260821-6654',1,'2026-08-21 12:32:44'),(48,10,'sale',10,-1,9,'INV-20260821-9512',1,'2026-08-22 00:11:06'),(49,3,'sale',22,-1,21,'INV-20260821-9512',1,'2026-08-22 00:11:06'),(50,1,'sale',49,-1,48,'INV-20260822-6696',1,'2026-08-22 11:01:13'),(51,17,'sale',57,-1,56,'INV-20260822-2334',1,'2026-08-22 11:01:56'),(52,18,'sale',48,-1,47,'INV-20260822-2334',1,'2026-08-22 11:01:56'),(53,16,'sale',25,-1,24,'INV-20260822-2334',1,'2026-08-22 11:01:56'),(54,15,'sale',27,-1,26,'INV-20260822-2334',1,'2026-08-22 11:01:56'),(55,11,'sale',34,-1,33,'INV-20260822-2334',1,'2026-08-22 11:01:56'),(56,13,'sale',42,-8,34,'INV-20260822-2334',1,'2026-08-22 11:01:56'),(57,10,'sale',9,-5,4,'INV-20260822-2334',1,'2026-08-22 11:01:56'),(58,21,'sale',33,-7,26,'INV-20260822-2334',1,'2026-08-22 11:01:56'),(59,24,'sale',24,-6,18,'INV-20260822-4738',1,'2026-08-22 11:02:35'),(60,23,'sale',38,-4,34,'INV-20260822-4738',1,'2026-08-22 11:02:35'),(61,7,'sale',99,-20,79,'INV-20260822-4738',1,'2026-08-22 11:02:35'),(62,8,'sale',57,-1,56,'INV-20260822-4738',1,'2026-08-22 11:02:35'),(63,14,'sale',19,-5,14,'INV-20260822-4738',1,'2026-08-22 11:02:35'),(64,13,'sale',34,-7,27,'INV-20260822-4738',1,'2026-08-22 11:02:35'),(65,12,'sale',27,-8,19,'INV-20260822-4738',1,'2026-08-22 11:02:35'),(66,27,'initial',0,50,50,'Stok awal',NULL,'2026-08-23 12:10:09'),(67,15,'sale',26,-1,25,'INV-20260823-4940',1,'2026-08-23 13:38:39'),(68,10,'sale',4,-1,3,'INV-20260823-4940',1,'2026-08-23 13:38:39'),(69,14,'sale',14,-3,11,'INV-20260823-4940',1,'2026-08-23 13:38:39'),(70,26,'sale',17,-1,16,'INV-20260823-4940',1,'2026-08-23 13:38:39'),(71,27,'sale',50,-1,49,'INV-20260823-4940',1,'2026-08-23 13:38:39'),(72,5,'sale',14,-1,13,'INV-20260823-7467',1,'2026-08-23 14:03:12'),(73,6,'sale',12,-1,11,'INV-20260823-7467',1,'2026-08-23 14:03:12'),(74,14,'sale',11,-1,10,'INV-20260823-7467',1,'2026-08-23 14:03:12'),(75,7,'sale',79,-21,58,'INV-20260827-8693',1,'2026-08-27 18:21:33'),(76,16,'sale',24,-1,23,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(77,15,'sale',25,-1,24,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(78,13,'sale',27,-1,26,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(79,21,'sale',26,-1,25,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(80,24,'sale',18,-1,17,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(81,10,'sale',3,-3,0,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(82,18,'sale',47,-1,46,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(83,19,'sale',41,-1,40,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(84,9,'sale',35,-24,11,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(85,8,'sale',56,-5,51,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(86,26,'sale',16,-7,9,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(87,25,'sale',14,-13,1,'INV-20260827-3127',1,'2026-08-27 18:22:04'),(88,21,'sale',25,-1,24,'INV-20260827-2602',1,'2026-08-27 18:22:46'),(89,22,'sale',19,-19,0,'INV-20260827-2602',1,'2026-08-27 18:22:46'),(90,15,'sale',24,-1,23,'INV-20260827-2602',1,'2026-08-27 18:22:46'),(91,2,'sale',27,-1,26,'INV-20260827-2602',1,'2026-08-27 18:22:46'),(92,4,'sale',20,-1,19,'INV-20260827-2602',1,'2026-08-27 18:22:46'),(93,8,'sale',51,-3,48,'INV-20260827-2602',1,'2026-08-27 18:22:46'),(94,7,'sale',58,-1,57,'INV-20260827-2602',1,'2026-08-27 18:22:46'),(95,6,'sale',11,-11,0,'INV-20260827-2471',1,'2026-08-27 18:23:03'),(96,5,'sale',13,-13,0,'INV-20260827-6417',1,'2026-08-27 18:23:16'),(97,15,'sale',23,-23,0,'INV-20260827-9838',1,'2026-08-27 18:23:32'),(98,14,'sale',10,-10,0,'INV-20260827-4279',1,'2026-08-27 18:23:43'),(99,9,'sale',11,-11,0,'INV-20260827-5807',1,'2026-08-27 18:23:55'),(100,27,'sale',49,-49,0,'INV-20260827-2851',1,'2026-08-27 18:24:25'),(101,12,'sale',19,-19,0,'INV-20260827-8041',1,'2026-08-27 18:24:43'),(102,24,'sale',17,-17,0,'INV-20260827-4063',1,'2026-08-27 18:25:16'),(103,23,'sale',34,-34,0,'INV-20260827-4063',1,'2026-08-27 18:25:16'),(104,25,'sale',1,-1,0,'INV-20260827-4063',1,'2026-08-27 18:25:16'),(105,20,'sale',23,-23,0,'INV-20260827-5391',1,'2026-08-27 18:25:40'),(106,21,'sale',24,-24,0,'INV-20260827-5391',1,'2026-08-27 18:25:40'),(107,19,'sale',40,-40,0,'INV-20260827-6656',1,'2026-08-27 18:26:08'),(108,18,'sale',46,-46,0,'INV-20260827-6656',1,'2026-08-27 18:26:08'),(109,17,'sale',56,-1,55,'INV-20260827-8231',1,'2026-08-27 18:26:31'),(110,16,'sale',23,-23,0,'INV-20260827-8231',1,'2026-08-27 18:26:31'),(111,13,'sale',26,-26,0,'INV-20260827-4968',1,'2026-08-27 18:27:01'),(112,11,'sale',33,-33,0,'INV-20260827-4968',1,'2026-08-27 18:27:01'),(113,8,'sale',48,-48,0,'INV-20260827-1925',1,'2026-08-27 18:27:31'),(114,7,'sale',57,-57,0,'INV-20260827-1925',1,'2026-08-27 18:27:31'),(115,2,'sale',26,-26,0,'INV-20260827-7446',1,'2026-08-27 18:28:03'),(116,4,'sale',19,-19,0,'INV-20260827-7446',1,'2026-08-27 18:28:03'),(117,3,'sale',21,-21,0,'INV-20260827-7446',1,'2026-08-27 18:28:03'),(118,26,'sale',9,-9,0,'INV-20260827-4128',1,'2026-08-27 18:28:38'),(119,3,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:46:41'),(120,5,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:46:51'),(121,6,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:46:58'),(122,4,'restock',0,111,111,'Restock dari supplier',1,'2026-08-28 13:47:04'),(123,2,'restock',0,20,20,'Restock dari supplier',1,'2026-08-28 13:47:10'),(124,7,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:47:16'),(125,9,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:47:21'),(126,10,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:47:37'),(127,14,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:47:43'),(128,12,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:47:49'),(129,11,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:47:54'),(130,13,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:47:59'),(131,15,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:48:04'),(132,16,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:48:13'),(133,18,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:48:17'),(134,19,'restock',0,12,12,'Restock dari supplier',1,'2026-08-28 13:48:23'),(135,22,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:48:28'),(136,21,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:48:33'),(137,20,'restock',0,100,100,'Restock dari supplier',1,'2026-08-28 13:48:38'),(138,25,'restock',0,1000,1000,'Restock dari supplier',1,'2026-08-28 13:48:53'),(139,26,'restock',0,100000,100000,'Restock dari supplier',1,'2026-08-28 13:49:04'),(140,27,'restock',0,1000,1000,'Restock dari supplier',1,'2026-08-28 13:49:10'),(141,23,'restock',0,1000,1000,'Restock dari supplier',1,'2026-08-28 13:49:15'),(142,2,'sale',20,-1,19,'INV-20260829-4335',1,'2026-08-29 22:17:45'),(143,7,'sale',100,-1,99,'INV-20260829-4335',1,'2026-08-29 22:17:45'),(144,9,'sale',100,-1,99,'INV-20260829-4335',1,'2026-08-29 22:17:45');
/*!40000 ALTER TABLE `stock_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticker_messages`
--

DROP TABLE IF EXISTS `ticker_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticker_messages` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticker_messages`
--

LOCK TABLES `ticker_messages` WRITE;
/*!40000 ALTER TABLE `ticker_messages` DISABLE KEYS */;
INSERT INTO `ticker_messages` VALUES (1,'TEBUS MURAH : Beli Teh Botol Dapat Fruit Tea 1 Pcs',1,'2026-08-23 11:58:34'),(2,'Beli Produk Susu Dapat Voucher POTONGAN Ticket masuk Cimori River Park',1,'2026-08-23 12:01:37'),(3,'Beli Buku Gratis Pensil',1,'2026-08-23 13:39:17'),(4,'beli sosis gratis saos',1,'2026-08-23 14:03:47');
/*!40000 ALTER TABLE `ticker_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_items`
--

DROP TABLE IF EXISTS `transaction_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` int unsigned NOT NULL,
  `product_id` int unsigned NOT NULL,
  `product_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_price` decimal(12,2) NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `idx_transaction` (`transaction_id`),
  KEY `idx_product` (`product_id`),
  CONSTRAINT `transaction_items_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transaction_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_items`
--

LOCK TABLES `transaction_items` WRITE;
/*!40000 ALTER TABLE `transaction_items` DISABLE KEYS */;
INSERT INTO `transaction_items` VALUES (1,1,6,'Mizone 500ml',8000.00,1,8000.00),(2,1,5,'Good Day Coffee 250ml',6500.00,1,6500.00),(3,2,14,'Biskuat 6pcs',7500.00,2,15000.00),(4,2,12,'Cheetos 55gr',11000.00,1,11000.00),(5,2,13,'Oreo Original',5500.00,1,5500.00),(6,3,3,'Coca-Cola 390ml',7500.00,1,7500.00),(7,3,8,'Pop Mie Ayam',4500.00,1,4500.00),(8,3,9,'Richeese Nabati',8000.00,1,8000.00),(9,3,17,'Rinso Sachet',2000.00,2,4000.00),(10,3,19,'Sampoerna Mild 16',27000.00,1,27000.00),(11,3,22,'Dancow Sachet',9500.00,1,9500.00),(12,4,15,'Lifebuoy Sabun',6000.00,1,6000.00),(13,4,11,'Chitato 55gr',12000.00,1,12000.00),(14,4,13,'Oreo Original',5500.00,1,5500.00),(15,4,14,'Biskuat 6pcs',7500.00,1,7500.00),(16,4,10,'Sari Roti Tawar',16500.00,2,33000.00),(17,4,21,'Indomilk Coklat 200ml',5000.00,1,5000.00),(18,4,20,'Ultra Milk Full Cream',5500.00,2,11000.00),(19,4,25,'Betadine 5ml',11000.00,1,11000.00),(20,5,5,'Good Day Coffee 250ml',6500.00,1,6500.00),(21,5,3,'Coca-Cola 390ml',7500.00,2,15000.00),(22,5,2,'Teh Botol 350ml',5500.00,3,16500.00),(23,5,9,'Richeese Nabati',8000.00,2,16000.00),(24,5,13,'Oreo Original',5500.00,1,5500.00),(25,5,15,'Lifebuoy Sabun',6000.00,2,12000.00),(26,5,26,'losion',15000.00,2,30000.00),(27,5,24,'Tolak Angin Sachet',4500.00,1,4500.00),(28,5,23,'Panadol 4 Tablet',8000.00,1,8000.00),(29,6,5,'Good Day Coffee 250ml',6500.00,1,6500.00),(30,6,6,'Mizone 500ml',8000.00,1,8000.00),(31,6,26,'losion',15000.00,1,15000.00),(32,6,23,'Panadol 4 Tablet',8000.00,1,8000.00),(33,6,21,'Indomilk Coklat 200ml',5000.00,1,5000.00),(34,6,20,'Ultra Milk Full Cream',5500.00,3,16500.00),(35,7,18,'Gudang Garam 12',24000.00,2,48000.00),(36,8,19,'Sampoerna Mild 16',27000.00,3,81000.00),(37,9,8,'Pop Mie Ayam',4500.00,1,4500.00),(38,10,20,'Ultra Milk Full Cream',5500.00,2,11000.00),(39,11,6,'Mizone 500ml',8000.00,1,8000.00),(40,11,9,'Richeese Nabati',8000.00,1,8000.00),(41,12,5,'Good Day Coffee 250ml',6500.00,1,6500.00),(42,13,7,'Indomie Goreng',3500.00,1,3500.00),(43,13,8,'Pop Mie Ayam',4500.00,1,4500.00),(44,13,9,'Richeese Nabati',8000.00,1,8000.00),(45,13,17,'Rinso Sachet',2000.00,1,2000.00),(46,14,1,'Aqua 600ml',4000.00,1,4000.00),(47,15,10,'Sari Roti Tawar',16500.00,1,16500.00),(48,15,3,'Coca-Cola 390ml',7500.00,1,7500.00),(49,16,1,'Aqua 600ml',4000.00,1,4000.00),(50,17,17,'Rinso Sachet',2000.00,1,2000.00),(51,17,18,'Gudang Garam 12',24000.00,1,24000.00),(52,17,16,'Pepsodent 75gr',10500.00,1,10500.00),(53,17,15,'Lifebuoy Sabun',6000.00,1,6000.00),(54,17,11,'Chitato 55gr',12000.00,1,12000.00),(55,17,13,'Oreo Original',5500.00,8,44000.00),(56,17,10,'Sari Roti Tawar',16500.00,5,82500.00),(57,17,21,'Indomilk Coklat 200ml',5000.00,7,35000.00),(58,18,24,'Tolak Angin Sachet',4500.00,6,27000.00),(59,18,23,'Panadol 4 Tablet',8000.00,4,32000.00),(60,18,7,'Indomie Goreng',3500.00,20,70000.00),(61,18,8,'Pop Mie Ayam',4500.00,1,4500.00),(62,18,14,'Biskuat 6pcs',7500.00,5,37500.00),(63,18,13,'Oreo Original',5500.00,7,38500.00),(64,18,12,'Cheetos 55gr',11000.00,8,88000.00),(65,19,15,'Lifebuoy Sabun',6000.00,1,6000.00),(66,19,10,'Sari Roti Tawar',16500.00,1,16500.00),(67,19,14,'Biskuat 6pcs',7500.00,3,22500.00),(68,19,26,'losion',15000.00,1,15000.00),(69,19,27,'OBH Combi Sachet',5000.00,1,5000.00),(70,20,5,'Good Day Coffee 250ml',6500.00,1,6500.00),(71,20,6,'Mizone 500ml',8000.00,1,8000.00),(72,20,14,'Biskuat 6pcs',7500.00,1,7500.00),(73,21,7,'Indomie Goreng',3500.00,21,73500.00),(74,22,16,'Pepsodent 75gr',10500.00,1,10500.00),(75,22,15,'Lifebuoy Sabun',6000.00,1,6000.00),(76,22,13,'Oreo Original',5500.00,1,5500.00),(77,22,21,'Indomilk Coklat 200ml',5000.00,1,5000.00),(78,22,24,'Tolak Angin Sachet',4500.00,1,4500.00),(79,22,10,'Sari Roti Tawar',16500.00,3,49500.00),(80,22,18,'Gudang Garam 12',24000.00,1,24000.00),(81,22,19,'Sampoerna Mild 16',27000.00,1,27000.00),(82,22,9,'Richeese Nabati',8000.00,24,192000.00),(83,22,8,'Pop Mie Ayam',4500.00,5,22500.00),(84,22,26,'losion',15000.00,7,105000.00),(85,22,25,'Betadine 5ml',11000.00,13,143000.00),(86,23,21,'Indomilk Coklat 200ml',5000.00,1,5000.00),(87,23,22,'Dancow Sachet',9500.00,19,180500.00),(88,23,15,'Lifebuoy Sabun',6000.00,1,6000.00),(89,23,2,'Teh Botol 350ml',5500.00,1,5500.00),(90,23,4,'Pocari Sweat 500ml',9000.00,1,9000.00),(91,23,8,'Pop Mie Ayam',4500.00,3,13500.00),(92,23,7,'Indomie Goreng',3500.00,1,3500.00),(93,24,6,'Mizone 500ml',8000.00,11,88000.00),(94,25,5,'Good Day Coffee 250ml',6500.00,13,84500.00),(95,26,15,'Lifebuoy Sabun',6000.00,23,138000.00),(96,27,14,'Biskuat 6pcs',7500.00,10,75000.00),(97,28,9,'Richeese Nabati',8000.00,11,88000.00),(98,29,27,'OBH Combi Sachet',5000.00,49,245000.00),(99,30,12,'Cheetos 55gr',11000.00,19,209000.00),(100,31,24,'Tolak Angin Sachet',4500.00,17,76500.00),(101,31,23,'Panadol 4 Tablet',8000.00,34,272000.00),(102,31,25,'Betadine 5ml',11000.00,1,11000.00),(103,32,20,'Ultra Milk Full Cream',5500.00,23,126500.00),(104,32,21,'Indomilk Coklat 200ml',5000.00,24,120000.00),(105,33,19,'Sampoerna Mild 16',27000.00,40,1080000.00),(106,33,18,'Gudang Garam 12',24000.00,46,1104000.00),(107,34,17,'Rinso Sachet',2000.00,1,2000.00),(108,34,16,'Pepsodent 75gr',10500.00,23,241500.00),(109,35,13,'Oreo Original',5500.00,26,143000.00),(110,35,11,'Chitato 55gr',12000.00,33,396000.00),(111,36,8,'Pop Mie Ayam',4500.00,48,216000.00),(112,36,7,'Indomie Goreng',3500.00,57,199500.00),(113,37,2,'Teh Botol 350ml',5500.00,26,143000.00),(114,37,4,'Pocari Sweat 500ml',9000.00,19,171000.00),(115,37,3,'Coca-Cola 390ml',7500.00,21,157500.00),(116,38,26,'losion',15000.00,9,135000.00),(117,39,2,'Teh Botol 350ml',5500.00,1,5500.00),(118,39,7,'Indomie Goreng',3500.00,1,3500.00),(119,39,9,'Richeese Nabati',8000.00,1,8000.00);
/*!40000 ALTER TABLE `transaction_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `invoice_number` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cashier_id` int unsigned NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `paid_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `change_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `payment_method` enum('cash','debit','qris') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cash',
  `payment_status` enum('paid','pending','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'paid',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_number` (`invoice_number`),
  KEY `idx_invoice` (`invoice_number`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_cashier` (`cashier_id`),
  KEY `idx_payment_method` (`payment_method`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`cashier_id`) REFERENCES `cashiers` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,'INV-20260816-8236',1,14500.00,1595.00,0.00,16095.00,16095.00,0.00,'cash','paid',NULL,'2026-08-17 01:12:13'),(2,'INV-20260817-8866',1,31500.00,3465.00,0.00,34965.00,34965.00,0.00,'cash','paid',NULL,'2026-08-17 08:57:21'),(3,'INV-20260817-4674',1,60500.00,6655.00,0.00,67155.00,67155.00,0.00,'debit','paid',NULL,'2026-08-17 11:16:58'),(4,'INV-20260817-2495',1,91000.00,10010.00,0.00,101010.00,101010.00,0.00,'qris','paid',NULL,'2026-08-17 11:17:18'),(5,'INV-20260817-3811',1,114000.00,12540.00,0.00,126540.00,150000.00,23460.00,'cash','paid',NULL,'2026-08-17 11:18:02'),(6,'INV-20260817-3642',1,59000.00,6490.00,0.00,65490.00,65490.00,0.00,'debit','paid',NULL,'2026-08-17 12:17:40'),(7,'INV-20260817-7815',1,48000.00,5280.00,0.00,53280.00,53280.00,0.00,'qris','paid',NULL,'2026-08-17 12:17:55'),(8,'INV-20260817-5248',1,81000.00,8910.00,0.00,89910.00,100000.00,10090.00,'cash','paid',NULL,'2026-08-17 12:18:09'),(9,'INV-20260817-6690',1,4500.00,495.00,0.00,4995.00,4995.00,0.00,'cash','paid',NULL,'2026-08-17 12:44:07'),(10,'INV-20260817-4383',1,11000.00,1210.00,0.00,12210.00,12210.00,0.00,'cash','paid',NULL,'2026-08-17 12:45:04'),(11,'INV-20260817-3139',1,16000.00,1760.00,0.00,17760.00,90000.00,72240.00,'cash','paid',NULL,'2026-08-17 12:59:39'),(12,'INV-20260820-3300',1,6500.00,715.00,0.00,7215.00,7215.00,0.00,'debit','paid',NULL,'2026-08-20 15:38:02'),(13,'INV-20260821-7592',1,18000.00,1980.00,0.00,19980.00,100000.00,80020.00,'cash','paid',NULL,'2026-08-21 11:27:55'),(14,'INV-20260821-6654',1,4000.00,440.00,0.00,4440.00,4440.00,0.00,'debit','paid',NULL,'2026-08-21 12:32:44'),(15,'INV-20260821-9512',1,24000.00,2640.00,0.00,26640.00,30000.00,3360.00,'cash','paid',NULL,'2026-08-22 00:11:06'),(16,'INV-20260822-6696',1,4000.00,440.00,0.00,4440.00,4440.00,0.00,'qris','paid',NULL,'2026-08-22 11:01:13'),(17,'INV-20260822-2334',1,216000.00,23760.00,0.00,239760.00,239760.00,0.00,'qris','paid',NULL,'2026-08-22 11:01:56'),(18,'INV-20260822-4738',1,297500.00,32725.00,0.00,330225.00,330225.00,0.00,'qris','paid',NULL,'2026-08-22 11:02:35'),(19,'INV-20260823-4940',1,65000.00,7150.00,0.00,72150.00,100000.00,27850.00,'cash','paid',NULL,'2026-08-23 13:38:39'),(20,'INV-20260823-7467',1,22000.00,2420.00,0.00,24420.00,50000.00,25580.00,'cash','paid',NULL,'2026-08-23 14:03:12'),(21,'INV-20260827-8693',1,73500.00,8085.00,0.00,81585.00,81585.00,0.00,'cash','paid',NULL,'2026-08-27 18:21:33'),(22,'INV-20260827-3127',1,594500.00,65395.00,0.00,659895.00,659895.00,0.00,'cash','paid',NULL,'2026-08-27 18:22:04'),(23,'INV-20260827-2602',1,223000.00,24530.00,0.00,247530.00,247530.00,0.00,'cash','paid',NULL,'2026-08-27 18:22:46'),(24,'INV-20260827-2471',1,88000.00,9680.00,0.00,97680.00,97680.00,0.00,'cash','paid',NULL,'2026-08-27 18:23:03'),(25,'INV-20260827-6417',1,84500.00,9295.00,0.00,93795.00,93795.00,0.00,'qris','paid',NULL,'2026-08-27 18:23:16'),(26,'INV-20260827-9838',1,138000.00,15180.00,0.00,153180.00,153180.00,0.00,'debit','paid',NULL,'2026-08-27 18:23:32'),(27,'INV-20260827-4279',1,75000.00,8250.00,0.00,83250.00,83250.00,0.00,'cash','paid',NULL,'2026-08-27 18:23:43'),(28,'INV-20260827-5807',1,88000.00,9680.00,0.00,97680.00,97680.00,0.00,'qris','paid',NULL,'2026-08-27 18:23:55'),(29,'INV-20260827-2851',1,245000.00,26950.00,0.00,271950.00,271950.00,0.00,'qris','paid',NULL,'2026-08-27 18:24:25'),(30,'INV-20260827-8041',1,209000.00,22990.00,0.00,231990.00,231990.00,0.00,'cash','paid',NULL,'2026-08-27 18:24:43'),(31,'INV-20260827-4063',1,359500.00,39545.00,0.00,399045.00,399045.00,0.00,'qris','paid',NULL,'2026-08-27 18:25:16'),(32,'INV-20260827-5391',1,246500.00,27115.00,0.00,273615.00,273615.00,0.00,'debit','paid',NULL,'2026-08-27 18:25:40'),(33,'INV-20260827-6656',1,2184000.00,240240.00,0.00,2424240.00,2424240.00,0.00,'qris','paid',NULL,'2026-08-27 18:26:08'),(34,'INV-20260827-8231',1,243500.00,26785.00,0.00,270285.00,270285.00,0.00,'qris','paid',NULL,'2026-08-27 18:26:31'),(35,'INV-20260827-4968',1,539000.00,59290.00,0.00,598290.00,598290.00,0.00,'qris','paid',NULL,'2026-08-27 18:27:01'),(36,'INV-20260827-1925',1,415500.00,45705.00,0.00,461205.00,461205.00,0.00,'qris','paid',NULL,'2026-08-27 18:27:31'),(37,'INV-20260827-7446',1,471500.00,51865.00,0.00,523365.00,523365.00,0.00,'qris','paid',NULL,'2026-08-27 18:28:03'),(38,'INV-20260827-4128',1,135000.00,14850.00,0.00,149850.00,149850.00,0.00,'qris','paid',NULL,'2026-08-27 18:28:38'),(39,'INV-20260829-4335',1,17000.00,1870.00,0.00,18870.00,18870.00,0.00,'qris','paid',NULL,'2026-08-29 22:17:45');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitor_logs`
--

DROP TABLE IF EXISTS `visitor_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitor_logs` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `user_agent` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `visited_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ip` (`ip_address`),
  KEY `idx_visited` (`visited_at`)
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitor_logs`
--

LOCK TABLES `visitor_logs` WRITE;
/*!40000 ALTER TABLE `visitor_logs` DISABLE KEYS */;
INSERT INTO `visitor_logs` VALUES (1,'103.83.178.100','Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 CrKey/1.54.250320','2026-08-17 12:00:45'),(2,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 12:39:04'),(3,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 12:42:56'),(4,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 12:43:51'),(5,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 12:50:51'),(6,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 12:53:29'),(7,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 12:59:28'),(8,'103.83.178.100','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 13:11:55'),(9,'103.83.178.100','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 13:16:17'),(10,'103.83.178.100','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 13:18:08'),(11,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 14:01:47'),(12,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 14:02:03'),(13,'103.83.178.100','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-17 14:03:07'),(14,'182.6.45.213','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-17 16:04:34'),(15,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 16:28:13'),(16,'103.83.178.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-17 16:28:29'),(17,'103.83.178.100','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-17 22:02:15'),(18,'118.137.69.82','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-18 12:51:01'),(19,'36.92.231.72','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36','2026-08-18 12:51:08'),(20,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-18 13:51:23'),(21,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-18 13:53:39'),(22,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-18 14:43:20'),(23,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-19 14:58:26'),(24,'103.176.66.117','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-19 16:03:14'),(25,'180.244.229.170','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-19 16:09:41'),(26,'202.43.172.4','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36','2026-08-19 16:09:49'),(27,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-19 16:31:41'),(28,'103.176.66.117','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-19 19:59:30'),(29,'54.70.110.51','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.7922.137 Safari/537.36','2026-08-19 23:29:30'),(30,'54.70.110.51','Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1','2026-08-19 23:29:39'),(31,'146.70.199.179','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.1 Mobile/15E148 Safari/604.1','2026-08-20 05:06:24'),(32,'98.82.199.123','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 05:11:39'),(33,'44.201.109.84','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 05:11:41'),(34,'13.220.139.45','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 06:14:04'),(35,'3.88.28.103','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 06:14:05'),(36,'44.201.109.84','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 07:15:39'),(37,'32.198.5.189','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 07:15:41'),(38,'52.91.66.188','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 08:17:59'),(39,'3.86.14.44','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 08:18:00'),(40,'3.83.177.255','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 09:21:50'),(41,'13.220.139.45','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 09:21:50'),(42,'54.196.196.187','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 10:27:19'),(43,'13.220.211.247','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 10:27:27'),(44,'34.204.87.126','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 11:29:21'),(45,'34.227.66.96','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 11:29:22'),(46,'54.91.243.245','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 12:33:35'),(47,'18.232.60.27','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 12:33:36'),(48,'180.252.253.170','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/30.0 Chrome/143.0.0.0 Mobile Safari/537.36','2026-08-20 13:11:13'),(49,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-20 13:33:37'),(50,'3.81.96.168','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 13:36:51'),(51,'98.82.172.242','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 13:36:51'),(52,'146.75.132.28','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.6 Mobile/15E148 Safari/604.1','2026-08-20 14:24:07'),(53,'52.55.244.117','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 14:38:31'),(54,'32.192.208.178','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 14:38:31'),(55,'114.10.30.232','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-20 14:58:25'),(56,'182.6.9.184','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.6 Mobile/15E148 Safari/604.1','2026-08-20 15:36:13'),(57,'182.6.9.184','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.6 Mobile/15E148 Safari/604.1','2026-08-20 15:36:20'),(58,'3.81.84.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 15:40:59'),(59,'54.205.167.203','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 15:41:00'),(60,'52.90.118.45','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 16:42:32'),(61,'3.85.82.53','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 16:42:40'),(62,'32.197.125.162','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 17:45:26'),(63,'34.207.215.75','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 17:45:31'),(64,'54.166.245.199','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 18:51:17'),(65,'35.153.102.254','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 18:51:23'),(66,'32.192.189.218','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 19:54:20'),(67,'3.81.54.38','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 19:54:20'),(68,'118.99.107.160','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.6 Mobile/15E148 Safari/604.1','2026-08-20 20:40:40'),(69,'34.227.149.227','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 20:56:32'),(70,'44.203.75.115','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 20:56:36'),(71,'3.85.174.165','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 22:00:05'),(72,'54.227.65.108','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 22:00:07'),(73,'54.226.2.213','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-20 23:04:28'),(74,'35.173.202.252','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-20 23:04:28'),(75,'100.31.62.10','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 00:07:18'),(76,'54.88.202.19','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 00:07:23'),(77,'54.209.37.243','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 01:09:29'),(78,'54.159.79.163','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 01:09:31'),(79,'34.203.211.37','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 02:12:10'),(80,'98.94.107.219','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 02:12:11'),(81,'3.234.182.34','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 03:14:26'),(82,'174.129.137.40','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 03:14:26'),(83,'52.23.158.230','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 04:18:22'),(84,'100.31.64.67','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 04:18:22'),(85,'52.3.103.199','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 05:21:09'),(86,'34.205.53.103','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 05:21:15'),(87,'103.83.178.98','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-21 06:17:20'),(88,'98.93.137.6','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 07:24:27'),(89,'107.21.89.244','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 07:24:27'),(90,'182.6.5.207','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-21 07:45:43'),(91,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-21 11:27:21'),(92,'180.252.238.246','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-21 12:04:20'),(93,'182.2.187.101','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-21 12:32:01'),(94,'180.252.238.246','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-21 12:59:15'),(95,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-21 13:16:48'),(96,'82.158.131.41','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-21 13:22:28'),(97,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-21 13:29:41'),(98,'139.255.251.36','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0','2026-08-21 14:21:46'),(99,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-21 14:27:54'),(100,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-21 14:27:58'),(101,'98.93.120.125','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 15:37:20'),(102,'35.153.127.119','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 15:37:23'),(103,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-21 17:13:48'),(104,'54.80.125.6','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 17:41:42'),(105,'50.19.174.69','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 17:41:48'),(106,'54.167.158.145','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 19:44:10'),(107,'54.224.20.248','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 19:44:10'),(108,'3.90.155.150','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 21:49:11'),(109,'50.17.122.59','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 21:49:14'),(110,'100.30.196.114','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-21 23:51:55'),(111,'52.23.251.197','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-21 23:52:05'),(112,'182.9.35.125','Mozilla/5.0 (Linux; Android 15; V2250 Build/AP3A.240905.015.A2) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/151.0.7922.134 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/574.0.0.40.71;IABMV/1;]','2026-08-22 00:10:32'),(113,'173.252.95.75','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-22 00:11:50'),(114,'54.81.25.111','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-22 01:54:32'),(115,'3.88.31.6','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-22 01:54:36'),(116,'18.234.116.110','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-22 03:55:15'),(117,'54.211.185.243','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-22 03:55:17'),(118,'3.81.12.249','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-22 05:58:06'),(119,'32.197.120.191','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-22 05:58:06'),(120,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-22 08:25:57'),(121,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-22 09:10:56'),(122,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-22 09:58:37'),(123,'54.89.130.191','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-22 10:00:22'),(124,'3.81.107.34','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-22 10:00:26'),(125,'111.94.228.155','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5.2 Mobile/15E148 Safari/604.1','2026-08-22 10:57:13'),(126,'111.94.228.155','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5.2 Mobile/15E148 Safari/604.1','2026-08-22 10:59:48'),(127,'111.94.228.155','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','2026-08-22 11:25:31'),(128,'111.94.228.155','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','2026-08-22 11:26:16'),(129,'103.83.178.98','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-22 13:03:04'),(130,'103.83.178.98','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-22 13:07:43'),(131,'103.83.178.98','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-22 13:21:44'),(132,'54.205.193.160','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-22 14:03:16'),(133,'52.90.89.17','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-22 14:03:18'),(134,'111.94.228.155','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.5.2 Mobile/15E148 Safari/604.1','2026-08-22 17:36:25'),(135,'54.204.108.143','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-22 18:04:42'),(136,'54.86.23.149','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-22 18:04:46'),(137,'54.91.53.99','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-22 22:07:10'),(138,'52.200.198.232','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-22 22:07:22'),(139,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-22 22:45:50'),(140,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-22 22:59:21'),(141,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-22 22:59:43'),(142,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-22 23:07:38'),(143,'3.92.33.71','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-23 06:13:13'),(144,'54.161.200.174','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-23 06:13:14'),(145,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-23 11:46:16'),(146,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-23 11:55:27'),(147,'103.83.178.98','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-23 11:57:09'),(148,'103.83.178.98','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-23 12:04:04'),(149,'103.83.178.98','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-23 12:04:33'),(150,'103.83.178.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-23 12:15:05'),(151,'184.73.167.217','Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Amazonbot/0.1; +https://developer.amazon.com/support/amazonbot) Chrome/119.0.6045.214 Safari/537.36','2026-08-23 13:13:28'),(152,'13.217.150.225','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-23 14:15:56'),(153,'98.93.115.42','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-23 14:15:57'),(154,'103.83.178.97','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-23 14:19:22'),(155,'103.83.178.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-23 14:39:28'),(156,'103.83.178.97','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-23 15:02:22'),(157,'103.83.178.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-23 15:22:20'),(158,'103.83.178.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-23 19:18:23'),(159,'103.83.178.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-23 21:21:40'),(160,'34.207.204.39','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-23 22:18:09'),(161,'18.232.123.42','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-23 22:18:10'),(162,'103.83.178.96','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-24 13:52:45'),(163,'35.172.33.164','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-24 22:23:58'),(164,'54.159.127.158','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-24 22:23:58'),(165,'18.234.251.239','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-25 14:26:41'),(166,'100.27.36.112','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-25 14:26:54'),(167,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-26 09:09:53'),(168,'3.81.54.145','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-26 14:29:46'),(169,'52.90.58.63','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-26 14:29:46'),(170,'18.215.243.247','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-27 14:32:53'),(171,'98.83.217.68','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-27 14:33:21'),(172,'111.94.228.155','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','2026-08-27 18:21:10'),(173,'111.94.228.155','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','2026-08-27 18:28:14'),(174,'17.241.219.89','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)','2026-08-27 18:57:58'),(175,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-08-28 13:44:04'),(176,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-08-28 13:49:34'),(177,'54.81.150.125','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-28 14:35:46'),(178,'32.197.239.228','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-28 14:35:48'),(179,'54.81.114.34','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-29 14:37:55'),(180,'52.70.9.171','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-29 14:37:59'),(181,'17.166.25.193','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15 (Applebot/0.1; +http://www.apple.com/go/applebot)','2026-08-29 21:48:10'),(182,'140.213.200.122','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-08-29 22:17:30'),(183,'173.252.82.38','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-08-29 22:17:38'),(184,'44.251.38.154','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36','2026-08-29 22:17:45'),(185,'54.144.30.127','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-30 14:40:29'),(186,'98.81.11.108','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-30 14:40:32'),(187,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-08-31 09:02:39'),(188,'13.217.114.82','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-08-31 14:42:57'),(189,'13.217.92.147','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-08-31 14:42:58'),(190,'118.137.24.40','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-09-01 11:12:10'),(191,'50.16.88.164','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-09-01 14:45:39'),(192,'54.82.41.91','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-09-01 14:45:50'),(193,'118.137.24.40','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-09-01 14:48:18'),(194,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-01 15:00:55'),(195,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-01 15:56:19'),(196,'125.166.116.243','Mozilla/5.0 (iPhone; CPU iPhone OS 26_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/23B85 Safari/604.1 [FBAN/FBIOS;FBAV/576.0.0.47.71;FBBV/1048889375;FBDV/iPhone15,4;FBMD/iPhone;FBSN/iOS;FBSV/26.1;FBSS/3;FBID/phone;FBLC/en_US;FBOP/5;FBR','2026-09-01 16:00:17'),(197,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-02 09:31:05'),(198,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-02 10:31:00'),(199,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-02 10:55:31'),(200,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-02 11:37:45'),(201,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-02 11:49:10'),(202,'54.145.129.165','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-09-03 13:15:05'),(203,'54.145.129.165','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Mobile Safari/537.36','2026-09-03 13:15:27'),(204,'18.206.40.105','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-09-03 20:23:41'),(205,'98.91.195.115','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7632.6 Safari/537.36','2026-09-04 02:29:03'),(206,'52.87.200.153','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-09-04 05:31:03'),(207,'52.87.200.153','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-09-04 07:31:48'),(208,'3.235.168.53','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-09-04 07:31:51'),(209,'3.236.191.184','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-09-04 11:33:39'),(210,'35.153.207.135','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-09-04 13:34:23'),(211,'13.216.241.134','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-09-04 13:34:25'),(212,'3.81.163.24','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-09-04 15:34:39'),(213,'52.90.102.96','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-09-04 15:34:57'),(214,'3.81.163.24','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36','2026-09-04 17:35:37'),(215,'52.90.102.96','Mozilla/5.0 (Linux; Android 16; SM-S921U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36','2026-09-04 17:35:40'),(216,'116.179.37.124','Mozilla/5.0 (compatible; Baiduspider-render/2.0; +http://www.baidu.com/search/spider.html)','2026-09-05 08:08:49'),(217,'103.82.126.200','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36','2026-09-08 21:50:19'),(218,'103.119.54.178','Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.7.6 Mobile/15E148 Safari/604.1','2026-09-09 08:32:18'),(219,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-10 09:06:26'),(220,'180.252.173.87','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36','2026-09-10 12:11:50'),(221,'118.137.24.40','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36','2026-09-10 15:43:22'),(222,'182.2.164.73','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36','2026-09-10 23:49:07'),(223,'182.2.164.73','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36','2026-09-10 23:49:59'),(224,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-11 10:23:03'),(225,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-11 10:38:09'),(226,'118.137.31.222','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','2026-09-11 10:38:14');
/*!40000 ALTER TABLE `visitor_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'alfamart_pos'
--
/*!50003 DROP PROCEDURE IF EXISTS `create_transaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `create_transaction`(
  IN p_invoice      VARCHAR(30),
  IN p_cashier_id   INT UNSIGNED,
  IN p_subtotal     DECIMAL(12,2),
  IN p_tax          DECIMAL(12,2),
  IN p_discount     DECIMAL(12,2),
  IN p_total        DECIMAL(12,2),
  IN p_paid         DECIMAL(12,2),
  IN p_change       DECIMAL(12,2),
  IN p_method       VARCHAR(10),
  IN p_items_json   JSON,
  OUT p_trx_id      INT UNSIGNED,
  OUT p_error       VARCHAR(200)
)
BEGIN
  DECLARE v_product_id   INT UNSIGNED;
  DECLARE v_product_name VARCHAR(200);
  DECLARE v_price        DECIMAL(12,2);
  DECLARE v_qty          INT;
  DECLARE v_stock        INT;
  DECLARE v_i            INT DEFAULT 0;
  DECLARE v_count        INT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_trx_id = 0;
    SET p_error  = 'Database error occurred';
  END;

  SET p_error = '';
  SET v_count = JSON_LENGTH(p_items_json);

  -- Validasi stok sebelum transaksi
  check_loop: WHILE v_i < v_count DO
    SET v_product_id = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].product_id')));
    SET v_qty        = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].quantity')));
    SELECT stock INTO v_stock FROM products WHERE id = v_product_id AND is_active = 1;
    IF v_stock IS NULL THEN
      SET p_error = CONCAT('Produk ID ', v_product_id, ' tidak ditemukan');
      LEAVE check_loop;
    END IF;
    IF v_stock < v_qty THEN
      SELECT name INTO v_product_name FROM products WHERE id = v_product_id;
      SET p_error = CONCAT('Stok ', v_product_name, ' tidak mencukupi (tersisa: ', v_stock, ')');
      LEAVE check_loop;
    END IF;
    SET v_i = v_i + 1;
  END WHILE;

  IF p_error != '' THEN
    SET p_trx_id = 0;
  ELSE
    START TRANSACTION;

    -- Insert header transaksi
    INSERT INTO transactions
      (invoice_number, cashier_id, subtotal, tax_amount, discount_amount,
       total_amount, paid_amount, change_amount, payment_method)
    VALUES
      (p_invoice, p_cashier_id, p_subtotal, p_tax, p_discount,
       p_total, p_paid, p_change, p_method);

    SET p_trx_id = LAST_INSERT_ID();
    SET v_i = 0;

    -- Insert items + update stok
    WHILE v_i < v_count DO
      SET v_product_id   = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].product_id')));
      SET v_product_name = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].product_name')));
      SET v_price        = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].price')));
      SET v_qty          = JSON_UNQUOTE(JSON_EXTRACT(p_items_json, CONCAT('$[', v_i, '].quantity')));

      INSERT INTO transaction_items
        (transaction_id, product_id, product_name, product_price, quantity, subtotal)
      VALUES
        (p_trx_id, v_product_id, v_product_name, v_price, v_qty, v_price * v_qty);

      -- Update stok & catat log
      SELECT stock INTO v_stock FROM products WHERE id = v_product_id;
      UPDATE products SET stock = stock - v_qty, updated_at = NOW() WHERE id = v_product_id;
      INSERT INTO stock_logs (product_id, change_type, qty_before, qty_change, qty_after, reference, cashier_id)
      VALUES (v_product_id, 'sale', v_stock, -v_qty, v_stock - v_qty, p_invoice, p_cashier_id);

      SET v_i = v_i + 1;
    END WHILE;

    COMMIT;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-11 13:51:43
