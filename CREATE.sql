--
-- Table structure for table `realtor`
--

DROP TABLE IF EXISTS `realtor`;
CREATE TABLE `realtor` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `full_name` varchar(245) NOT NULL,
  `email` varchar(245) NOT NULL,
  `phone` bigint NOT NULL,
  `login` varchar(245) NOT NULL,
  `password` char(65) NOT NULL,
  `emp_date` date NOT NULL,
  `realtorcol` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `login_UNIQUE` (`login`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `phone_UNIQUE` (`phone`)
);

--
-- Table structure for table `district`
--

DROP TABLE IF EXISTS `district`;
CREATE TABLE `district` (
  `id` int(3) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `name` varchar(145) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
);

--
-- Table structure for table `transaction_type`
--

DROP TABLE IF EXISTS `transaction_type`;
CREATE TABLE `transaction_type` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `type` varchar(145) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
);

--
-- Table structure for table `client_type`
--

DROP TABLE IF EXISTS `client_type`;
CREATE TABLE `client_type` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `type` varchar(145) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
);

--
-- Table structure for table `property_type`
--

DROP TABLE IF EXISTS `property_type`;
CREATE TABLE `property_type` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `type` varchar(145) NOT NULL,
  `is_commercial` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
);

--
-- Table structure for table `contract_type`
--

DROP TABLE IF EXISTS `contract_type`;
CREATE TABLE `contract_type` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `type` varchar(145) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
);


--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE `client` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `client_type_id` int(4) unsigned zerofill NOT NULL,
  `name` varchar(145) NOT NULL,
  `surname` varchar(145) NOT NULL,
  `patronymic` varchar(145)  DEFAULT NULL,
  `passport` char(11) DEFAULT NULL,
  `email` varchar(145) NOT NULL,
  `phone` bigint NOT NULL,
  `requisites` bigint NOT NULL,
  `ITN/TIN` bigint NOT NULL COMMENT 'Individual Taxpayer Number - ИНН для физлиц, Taxpayer Identification Number - ИНН для юрлиц. (пример: 7729083775 )',
  `IEC` bigint NOT NULL COMMENT 'Individual Enterprises Classifier, КПП (пример: 772906003)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `requisites_UNIQUE` (`requisites`),
  UNIQUE KEY `IEC_UNIQUE` (`IEC`),
  UNIQUE KEY `ITN/TIN_UNIQUE` (`ITN/TIN`),
  UNIQUE KEY `phone_UNIQUE` (`phone`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_client_type_id_idx` (`client_type_id`),
  CONSTRAINT `fk_client_type_id` FOREIGN KEY (`client_type_id`) REFERENCES `client_type` (`id`)
);

--
-- Table structure for table `property`
--

DROP TABLE IF EXISTS `property`;
CREATE TABLE `property` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `property_type_id` int(4) unsigned zerofill NOT NULL,
  `district_id` int(4) unsigned zerofill NOT NULL,
  `transaction_id` int(4) unsigned zerofill NOT NULL,
  `owner_client_id` int(4) unsigned zerofill NOT NULL,
  `address` varchar(145) DEFAULT NULL,
  `floor` int DEFAULT NULL,
  `rooms` int DEFAULT NULL,
  `square` varchar(15) NULL,
  `bedrooms` int DEFAULT NULL,
  `bathrooms` int DEFAULT NULL,
  `details` text,
  `price` decimal(10,2) DEFAULT NULL,
  `is_new_building` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_property_type_id_idx` (`property_type_id`),
  KEY `fk_property_transaction_id_idx` (`transaction_id`),
  KEY `fk_district_id_idx` (`district_id`),
  KEY `fk_client_id_idx` (`owner_client_id`),
  KEY `fk_administrative_district_id_idx` (`administrative_district_id`),
  CONSTRAINT `property_ibfk_2` FOREIGN KEY (`property_type_id`) REFERENCES `property_type` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `property_ibfk_3` FOREIGN KEY (`transaction_id`) REFERENCES `transaction_type` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `property_ibfk_4` FOREIGN KEY (`owner_client_id`) REFERENCES `client` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `property_ibfk_5` FOREIGN KEY (`district_id`) REFERENCES `district` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `request`
--

DROP TABLE IF EXISTS `request`;
CREATE TABLE `request` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `property_id` int(4) unsigned zerofill DEFAULT NULL,
  `client_id` int(4) unsigned zerofill NOT NULL,
  `realtor_id` int(4) unsigned zerofill NOT NULL,
  `transaction_type_id` int(4) unsigned zerofill NOT NULL,
  `details` varchar(245) DEFAULT NULL,
  `max_price` decimal(10,2) DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(10) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_client_id_idx` (`client_id`),
  KEY `fk_property_id_idx` (`property_id`),
  KEY `fk_transaction_type_id_idx` (`transaction_type_id`),
  KEY `fk_realtor_id_idx` (`realtor_id`),
  CONSTRAINT `request_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  CONSTRAINT `request_ibfk_3` FOREIGN KEY (`transaction_type_id`) REFERENCES `transaction_type` (`id`),
  CONSTRAINT `request_ibfk_4` FOREIGN KEY (`realtor_id`) REFERENCES `realtor` (`id`)
);

--
-- Table structure for table `show_property_meet`
--

DROP TABLE IF EXISTS `show_property_meet`;
CREATE TABLE `show_property_meet` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `property_id` int(4) unsigned zerofill NOT NULL,
  `client_id` int(4) unsigned zerofill NOT NULL,
  `realtor_id` int(4) unsigned zerofill NOT NULL,
  `comment` varchar(245) DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` int DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_property_id_idx` (`property_id`),
  KEY `fk_client_id_idx` (`client_id`),
  KEY `fk_realtor_id_idx` (`realtor_id`),
  CONSTRAINT `show_property_meet_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`),
  CONSTRAINT `show_property_meet_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  CONSTRAINT `show_property_meet_ibfk_3` FOREIGN KEY (`realtor_id`) REFERENCES `realtor` (`id`)
);

--
-- Table structure for table `contract`
--

DROP TABLE IF EXISTS `contract`;
CREATE TABLE `contract` (
  `id` int(4) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `counteragents` char(10) NOT NULL,
  `property_id` int(4) unsigned zerofill NOT NULL,
  `realtor_id` int(4) unsigned zerofill NOT NULL,
  `transaction_id` int(4) unsigned zerofill NOT NULL,
  `contract_type_id` int(4) unsigned zerofill NOT NULL,
  `prepayment` decimal(10,2) DEFAULT NULL,
  `payment_sum` decimal(10,2) DEFAULT NULL,
  `fee_percentage` int DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_client_id_idx` (`counteragents`),
  KEY `fk_transaction_id_idx` (`transaction_id`),
  KEY `fk_property_id_idx` (`property_id`),
  KEY `fk_realtor_id_idx` (`realtor_id`),
  KEY `fk_contract_type_id_idx` (`contract_type_id`),
  CONSTRAINT `contract_ibfk_2` FOREIGN KEY (`transaction_id`) REFERENCES `transaction_type` (`id`),
  CONSTRAINT `contract_ibfk_3` FOREIGN KEY (`property_id`) REFERENCES `property` (`id`),
  CONSTRAINT `contract_ibfk_5` FOREIGN KEY (`realtor_id`) REFERENCES `realtor` (`id`),
  CONSTRAINT `fk_contract_1` FOREIGN KEY (`contract_type_id`) REFERENCES `contract_type` (`id`)
);

* [Перейти в DIRECTORY](https://github.com/Krivosheenkova/MYSQL_COURSEWORK/blob/main/DIRECTORY.md) 
