-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               5.6.22-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for retail
DROP DATABASE IF EXISTS `retail`;
CREATE DATABASE IF NOT EXISTS `retail` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `retail`;


-- Dumping structure for table retail.branch_master
DROP TABLE IF EXISTS `branch_master`;
CREATE TABLE IF NOT EXISTS `branch_master` (
  `branch_id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `bank_name` varchar(50) NOT NULL,
  `branch_name` varchar(50) NOT NULL,
  `ifsc_code` varchar(50) DEFAULT NULL,
  `micr_code` varchar(50) DEFAULT NULL,
  `db_name` varchar(50) NOT NULL,
  `context_root` varchar(50) NOT NULL,
  `email1` varchar(50) DEFAULT NULL,
  `email2` varchar(50) DEFAULT NULL,
  `phone1` varchar(15) DEFAULT NULL,
  `phone2` varchar(15) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `delete_ind` varchar(4) DEFAULT NULL,
  `create_user` varchar(50) DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table retail.branch_master: ~1 rows (approximately)
/*!40000 ALTER TABLE `branch_master` DISABLE KEYS */;
INSERT INTO `branch_master` (`branch_id`, `parent_id`, `bank_name`, `branch_name`, `ifsc_code`, `micr_code`, `db_name`, `context_root`, `email1`, `email2`, `phone1`, `phone2`, `remarks`, `start_date`, `end_date`, `delete_ind`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES
	(1, 0, 'Kalipur', 'Kalipur', '12345723', '87656311', 'retail', 'RetailSvcWS', 'ashismo@gmail.com', NULL, '9830625559', NULL, NULL, '2015-12-18', NULL, NULL, 'ashish', '2016-02-14 22:03:57', NULL, '2016-03-10 21:56:37');
/*!40000 ALTER TABLE `branch_master` ENABLE KEYS */;


-- Dumping structure for table retail.material_group
DROP TABLE IF EXISTS `material_group`;
CREATE TABLE IF NOT EXISTS `material_group` (
  `material_grp_id` int(11) NOT NULL AUTO_INCREMENT,
  `branch_id` int(11) NOT NULL,
  `group_name` varchar(50) NOT NULL,
  `group_description` varchar(50) DEFAULT NULL,
  `delete_ind` varchar(4) DEFAULT NULL,
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`material_grp_id`),
  KEY `FK_material_group_branch_master` (`branch_id`),
  CONSTRAINT `FK_material_group_branch_master` FOREIGN KEY (`branch_id`) REFERENCES `branch_master` (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table retail.material_group: ~0 rows (approximately)
/*!40000 ALTER TABLE `material_group` DISABLE KEYS */;
INSERT INTO `material_group` (`material_grp_id`, `branch_id`, `group_name`, `group_description`, `delete_ind`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES
	(1, 1, 'Metal', 'Metal', NULL, 'ashish', '2016-03-11 23:34:56', NULL, NULL);
/*!40000 ALTER TABLE `material_group` ENABLE KEYS */;


-- Dumping structure for table retail.material_master
DROP TABLE IF EXISTS `material_master`;
CREATE TABLE IF NOT EXISTS `material_master` (
  `material_id` int(11) NOT NULL AUTO_INCREMENT,
  `material_name` varchar(50) NOT NULL,
  `material_description` varchar(50) DEFAULT NULL,
  `material_grp_id` int(11) NOT NULL,
  `uom` varchar(50) NOT NULL COMMENT 'Unit of measure e.g. Kg, Litre, Package, None etc',
  `stock_in` decimal(10,2) NOT NULL,
  `stock_out` decimal(10,2) DEFAULT NULL,
  `stock_balance` decimal(10,2) DEFAULT NULL,
  `low_stock_level` decimal(10,2) DEFAULT NULL COMMENT 'If the total stock goes below this level then user will be notified',
  `qty_check_required_ind` varchar(4) DEFAULT NULL COMMENT 'There are some materials for which quantity check not required. E.g. labour charge, insurance, Emission',
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`material_id`),
  KEY `FK_material_master_material_group` (`material_grp_id`),
  CONSTRAINT `FK_material_master_material_group` FOREIGN KEY (`material_grp_id`) REFERENCES `material_group` (`material_grp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table retail.material_master: ~0 rows (approximately)
/*!40000 ALTER TABLE `material_master` DISABLE KEYS */;
INSERT INTO `material_master` (`material_id`, `material_name`, `material_description`, `material_grp_id`, `uom`, `stock_in`, `stock_out`, `stock_balance`, `low_stock_level`, `qty_check_required_ind`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES
	(1, 'Cstrol', 'Castrol', 1, 'L', 100.00, 10.00, 90.00, 10.00, NULL, 'ashish', '2016-03-11 23:49:24', NULL, NULL);
/*!40000 ALTER TABLE `material_master` ENABLE KEYS */;


-- Dumping structure for table retail.material_tran_dtl
DROP TABLE IF EXISTS `material_tran_dtl`;
CREATE TABLE IF NOT EXISTS `material_tran_dtl` (
  `tran_dtl_id` int(11) NOT NULL AUTO_INCREMENT,
  `tran_id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `delete_ind` varchar(4) DEFAULT NULL,
  `delete_reason` varchar(255) DEFAULT NULL,
  `passing_auth_ind` varchar(4) DEFAULT NULL,
  `passing_auth_remark` varchar(255) DEFAULT NULL,
  `end_date` date DEFAULT NULL COMMENT 'This field will be populated for servies like expiration of insurance/Emission test',
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tran_dtl_id`),
  KEY `FK_material_tran_dtl_material_tran_hrd` (`tran_id`),
  KEY `FK_material_tran_dtl_material_master` (`material_id`),
  CONSTRAINT `FK_material_tran_dtl_material_master` FOREIGN KEY (`material_id`) REFERENCES `material_master` (`material_id`),
  CONSTRAINT `FK_material_tran_dtl_material_tran_hrd` FOREIGN KEY (`tran_id`) REFERENCES `material_tran_hrd` (`tran_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table retail.material_tran_dtl: ~0 rows (approximately)
/*!40000 ALTER TABLE `material_tran_dtl` DISABLE KEYS */;
/*!40000 ALTER TABLE `material_tran_dtl` ENABLE KEYS */;


-- Dumping structure for table retail.material_tran_hrd
DROP TABLE IF EXISTS `material_tran_hrd`;
CREATE TABLE IF NOT EXISTS `material_tran_hrd` (
  `tran_id` int(11) NOT NULL AUTO_INCREMENT,
  `tran_no` varchar(50) DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `tran_type` enum('op','s') DEFAULT NULL COMMENT 'op=Opening, s=sell',
  `bill_date` date NOT NULL,
  `bill_amt` decimal(10,2) NOT NULL,
  `vat` decimal(10,2) NOT NULL,
  `gross_total` decimal(10,2) DEFAULT NULL,
  `paid_amt` decimal(10,2) DEFAULT NULL,
  `outstanding_amt` decimal(10,2) DEFAULT NULL,
  `paid_by` varchar(50) DEFAULT NULL,
  `delete_ind` varchar(4) DEFAULT NULL,
  `delete_reason` varchar(255) DEFAULT NULL,
  `passing_auth_ind` varchar(4) DEFAULT NULL,
  `passing_auth_remark` varchar(255) DEFAULT NULL,
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tran_id`),
  KEY `FK_material_tran_hrd_branch_master` (`branch_id`),
  KEY `FK_material_tran_hrd_retail_customer_master` (`customer_id`),
  CONSTRAINT `FK_material_tran_hrd_branch_master` FOREIGN KEY (`branch_id`) REFERENCES `branch_master` (`branch_id`),
  CONSTRAINT `FK_material_tran_hrd_retail_customer_master` FOREIGN KEY (`customer_id`) REFERENCES `retail_customer_master` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table retail.material_tran_hrd: ~0 rows (approximately)
/*!40000 ALTER TABLE `material_tran_hrd` DISABLE KEYS */;
/*!40000 ALTER TABLE `material_tran_hrd` ENABLE KEYS */;


-- Dumping structure for table retail.retail_customer_master
DROP TABLE IF EXISTS `retail_customer_master`;
CREATE TABLE IF NOT EXISTS `retail_customer_master` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(50) NOT NULL,
  `customer_type` varchar(50) DEFAULT NULL COMMENT 'Running Customer/Regular Customer etc',
  `address_line1` varchar(50) NOT NULL,
  `address_line2` varchar(50) DEFAULT NULL,
  `pin` varchar(50) NOT NULL,
  `phone1` varchar(15) NOT NULL,
  `phone2` varchar(15) DEFAULT NULL,
  `email1` varchar(50) DEFAULT NULL,
  `email2` varchar(50) DEFAULT NULL,
  `website` varchar(50) DEFAULT NULL,
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table retail.retail_customer_master: ~0 rows (approximately)
/*!40000 ALTER TABLE `retail_customer_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `retail_customer_master` ENABLE KEYS */;


-- Dumping structure for table retail.retail_rate_chart
DROP TABLE IF EXISTS `retail_rate_chart`;
CREATE TABLE IF NOT EXISTS `retail_rate_chart` (
  `rate_id` int(11) NOT NULL AUTO_INCREMENT,
  `branch_id` int(11) DEFAULT NULL,
  `material_id` int(11) DEFAULT NULL,
  `start_date` timestamp NULL DEFAULT NULL,
  `unit_rate` decimal(10,2) NOT NULL,
  `delete_ind` varchar(4) DEFAULT NULL,
  `delete_reason` varchar(255) DEFAULT NULL,
  `passing_auth_ind` varchar(4) DEFAULT NULL,
  `passing_auth_remark` varchar(255) DEFAULT NULL,
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rate_id`),
  KEY `FK_retail_rate_chart_material_master` (`material_id`),
  KEY `FK_retail_rate_chart_branch_master` (`branch_id`),
  CONSTRAINT `FK_retail_rate_chart_branch_master` FOREIGN KEY (`branch_id`) REFERENCES `branch_master` (`branch_id`),
  CONSTRAINT `FK_retail_rate_chart_material_master` FOREIGN KEY (`material_id`) REFERENCES `material_master` (`material_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table retail.retail_rate_chart: ~0 rows (approximately)
/*!40000 ALTER TABLE `retail_rate_chart` DISABLE KEYS */;
INSERT INTO `retail_rate_chart` (`rate_id`, `branch_id`, `material_id`, `start_date`, `unit_rate`, `delete_ind`, `delete_reason`, `passing_auth_ind`, `passing_auth_remark`, `create_user`, `create_date`, `update_user`, `update_date`) VALUES
	(1, 1, 1, '2016-03-12 10:49:55', 100.00, NULL, NULL, NULL, NULL, 'ashish', '2016-03-12 10:50:05', NULL, NULL);
/*!40000 ALTER TABLE `retail_rate_chart` ENABLE KEYS */;


-- Dumping structure for table retail.stock_entry
DROP TABLE IF EXISTS `stock_entry`;
CREATE TABLE IF NOT EXISTS `stock_entry` (
  `stock_id` int(11) NOT NULL AUTO_INCREMENT,
  `branch_id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `entry_date` date NOT NULL,
  `opening_entry_ind` varchar(4) DEFAULT NULL COMMENT 'Opening Entry indicator indicates if the entry is for the current financial year',
  `batch` varchar(50) DEFAULT NULL,
  `qty` decimal(10,2) NOT NULL,
  `purchase_price` decimal(10,2) NOT NULL,
  `challan_no` varchar(50) DEFAULT NULL,
  `bill_no` varchar(50) DEFAULT NULL,
  `delete_ind` varchar(4) DEFAULT NULL,
  `delete_reason` varchar(255) DEFAULT NULL,
  `passing_auth_ind` varchar(4) DEFAULT NULL,
  `passing_auth_remark` varchar(255) DEFAULT NULL,
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`stock_id`),
  KEY `FK_stock_entry_material_master` (`material_id`),
  KEY `FK_stock_entry_vendor_master` (`vendor_id`),
  KEY `FK_stock_entry_branch_master` (`branch_id`),
  CONSTRAINT `FK_stock_entry_branch_master` FOREIGN KEY (`branch_id`) REFERENCES `branch_master` (`branch_id`),
  CONSTRAINT `FK_stock_entry_material_master` FOREIGN KEY (`material_id`) REFERENCES `material_master` (`material_id`),
  CONSTRAINT `FK_stock_entry_vendor_master` FOREIGN KEY (`vendor_id`) REFERENCES `vendor_master` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table retail.stock_entry: ~0 rows (approximately)
/*!40000 ALTER TABLE `stock_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_entry` ENABLE KEYS */;


-- Dumping structure for table retail.stock_return
DROP TABLE IF EXISTS `stock_return`;
CREATE TABLE IF NOT EXISTS `stock_return` (
  `stock_return_id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_id` int(11) NOT NULL,
  `return_date` date NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `delete_ind` varchar(4) DEFAULT NULL,
  `delete_reason` varchar(255) DEFAULT NULL,
  `passing_auth_ind` varchar(4) DEFAULT NULL,
  `passing_auth_remark` varchar(255) DEFAULT NULL,
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`stock_return_id`),
  KEY `FK_stock_return_stock_entry` (`stock_id`),
  CONSTRAINT `FK_stock_return_stock_entry` FOREIGN KEY (`stock_id`) REFERENCES `stock_entry` (`stock_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table retail.stock_return: ~0 rows (approximately)
/*!40000 ALTER TABLE `stock_return` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_return` ENABLE KEYS */;


-- Dumping structure for table retail.vat_reg_no
DROP TABLE IF EXISTS `vat_reg_no`;
CREATE TABLE IF NOT EXISTS `vat_reg_no` (
  `vat_id` int(11) NOT NULL AUTO_INCREMENT,
  `vat_registration_no` varchar(50) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vat_id`),
  KEY `FK_vat_reg_no_branch_master` (`branch_id`),
  CONSTRAINT `FK_vat_reg_no_branch_master` FOREIGN KEY (`branch_id`) REFERENCES `branch_master` (`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table retail.vat_reg_no: ~0 rows (approximately)
/*!40000 ALTER TABLE `vat_reg_no` DISABLE KEYS */;
/*!40000 ALTER TABLE `vat_reg_no` ENABLE KEYS */;


-- Dumping structure for table retail.vendor_master
DROP TABLE IF EXISTS `vendor_master`;
CREATE TABLE IF NOT EXISTS `vendor_master` (
  `vendor_id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_name` varchar(50) NOT NULL,
  `address_line1` varchar(50) NOT NULL,
  `address_line2` varchar(50) DEFAULT NULL,
  `pin` varchar(50) NOT NULL,
  `phone1` varchar(15) NOT NULL,
  `phone2` varchar(15) DEFAULT NULL,
  `email1` varchar(50) DEFAULT NULL,
  `email2` varchar(50) DEFAULT NULL,
  `website` varchar(50) DEFAULT NULL,
  `create_user` varchar(50) NOT NULL,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user` varchar(50) DEFAULT NULL,
  `update_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table retail.vendor_master: ~0 rows (approximately)
/*!40000 ALTER TABLE `vendor_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `vendor_master` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
