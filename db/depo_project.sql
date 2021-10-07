-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 07 Eki 2021, 17:27:25
-- Sunucu sürümü: 10.4.20-MariaDB
-- PHP Sürümü: 7.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `depo_project`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `customerSearch` (IN `customerName` VARCHAR(50))  BEGIN
    SELECT * FROM customer AS cu
    WHERE MATCH(cu.cu_name) AGAINST(customerName IN BOOLEAN MODE);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `JoinTableReceipt` (IN `i` BIGINT)  BEGIN
	 SELECT DISTINCT order_receipt as join_receipt, receipt_total as join_receipt_total, receipt_payment  FROM receipt as r
INNER JOIN receipt_orders as ro
on r.receipt_id = ro.Receipt_receipt_id
INNER JOIN orders as o
on o.order_id = ro.Orders_order_id
INNER JOIN customer as c
on c.cu_id =  o.customer_cu_id
WHERE cu_id = i;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orderStatusChange` (IN `i` BIGINT)  BEGIN
	UPDATE orders set order_status = 1 WHERE order_receipt=i;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `payOutSearch` (IN `i` VARCHAR(50))  BEGIN
	select * from PayOut where MATCH (PayOut.payOutTitle) AGAINST (i in BOOLEAN MODE)
	order by PayOut.payOutTitle DESC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `admin`
--

CREATE TABLE `admin` (
  `aid` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `admin`
--

INSERT INTO `admin` (`aid`, `email`, `name`, `password`) VALUES
(2, 'turan@mail.com', 'Turan', '827ccb0eea8a706c4c34a16891f84e7b'),
(3, 'admin@mail.com', 'Admin', '827ccb0eea8a706c4c34a16891f84e7b');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customer`
--

CREATE TABLE `customer` (
  `cu_id` int(11) NOT NULL,
  `cu_address` varchar(500) DEFAULT NULL,
  `cu_code` bigint(20) NOT NULL,
  `cu_company_title` varchar(255) DEFAULT NULL,
  `cu_email` varchar(500) DEFAULT NULL,
  `cu_mobile` varchar(255) DEFAULT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `cu_password` varchar(32) DEFAULT NULL,
  `cu_phone` varchar(255) DEFAULT NULL,
  `cu_status` int(11) NOT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `cu_tax_administration` varchar(255) DEFAULT NULL,
  `cu_tax_number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customer`
--

INSERT INTO `customer` (`cu_id`, `cu_address`, `cu_code`, `cu_company_title`, `cu_email`, `cu_mobile`, `cu_name`, `cu_password`, `cu_phone`, `cu_status`, `cu_surname`, `cu_tax_administration`, `cu_tax_number`) VALUES
(9, 'Soganli mahallesi ikbal sokak no:47/9', 447009493, 'Şirket', 'turancaymaz@hotmail.com', '22332323', 'Turan', '2323', '23232', 1, 'Çaymaz', 'aa', 2323232),
(13, 'adres', 463883105, 'Şirket', 'turancaymaz@hotmail.com', '343434', 'Turan', '1234', '3434343', 1, 'çaymaz', 'Kadıköy', 2323232),
(14, 'Vatan Caddesi No:3', 189666646, 'Bayi', 'Ali@mail.com', '54987545', 'Ali', '12345', '45502154', 2, 'Bilmem', 'Bakırköy', 2154565),
(15, 'Bakırköy', 443934041, 'Bayi', 'yakup@mail.com', '23232', 'Yakup', '2323', '2323232', 1, 'Koc', '222', 2222),
(16, 'TaksimAdres', 507443479, 'Şirket', 'ela@mail.com', '523698547', 'Ela', '222', '2365487', 1, 'veda', 'Taksim', 222222),
(17, 'Levent', 600758509, 'Şirket', 'kemal@hotmail.com', '111111', 'Kemal', '12345', '11111', 2, 'Sen', '11111111', 111111),
(18, 'aaa', 628146515, 'Şirket', 'alim@hotmail.com', '111111', 'Ali', '12345', '1111', 1, 'sen', 'Taksim', 11111);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customersearch`
--

CREATE TABLE `customersearch` (
  `cu_id` int(11) NOT NULL,
  `cu_address` varchar(500) DEFAULT NULL,
  `cu_code` bigint(20) NOT NULL,
  `cu_company_title` varchar(255) DEFAULT NULL,
  `cu_email` varchar(500) DEFAULT NULL,
  `cu_mobile` varchar(255) DEFAULT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `cu_password` varchar(32) DEFAULT NULL,
  `cu_phone` varchar(255) DEFAULT NULL,
  `cu_status` int(11) NOT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `cu_tax_administration` varchar(255) DEFAULT NULL,
  `cu_tax_number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `order_count` int(11) NOT NULL,
  `order_customer_id` int(11) NOT NULL,
  `order_product_id` int(11) DEFAULT NULL,
  `order_receipt` bigint(20) NOT NULL,
  `order_status` int(11) NOT NULL,
  `customer_cu_id` int(11) DEFAULT NULL,
  `product_p_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `orders`
--

INSERT INTO `orders` (`order_id`, `order_count`, `order_customer_id`, `order_product_id`, `order_receipt`, `order_status`, `customer_cu_id`, `product_p_id`) VALUES
(1, 0, 0, 0, 0, 0, NULL, NULL),
(2, 0, 0, 0, 0, 0, NULL, NULL),
(3, 0, 0, 0, 0, 0, NULL, NULL),
(4, 0, 0, 0, 0, 0, NULL, NULL),
(5, 0, 0, 0, 0, 0, NULL, NULL),
(6, 1, 9, 3, 12, 1, 9, 3),
(7, 12, 9, 3, 13, 1, 9, 3),
(9, 33, 14, 3, 16, 1, 14, 3),
(12, 12, 9, 3, 25, 1, 9, 3),
(13, 1, 15, 4, 36, 1, 15, 4),
(14, 1, 15, 5, 36, 1, 15, 5),
(15, 1, 15, 5, 36, 1, 15, 5),
(16, 1, 15, 3, 36, 1, 15, 3),
(18, 1, 15, 3, 35, 1, 15, 3),
(19, 1, 15, 3, 40, 1, 15, 3),
(20, 1, 9, 4, 99, 1, 9, 4),
(21, 2, 14, 3, 15, 1, 14, 3),
(22, 3, 9, 4, 41, 1, 9, 4),
(23, 2, 16, 3, 37, 1, 16, 3),
(24, 2, 16, 7, 43, 1, 16, 7),
(25, 51, 16, 3, 48, 1, 16, 3),
(26, 10, 16, 8, 48, 1, 16, 8),
(27, 1, 16, 7, 49, 1, 16, 7),
(29, 1, 16, 8, 1, 1, 16, 8),
(30, 1, 16, 8, 1, 1, 16, 8),
(31, 1, 13, 7, 21, 1, 13, 7),
(33, 1, 15, 3, 1, 0, 15, 3),
(34, 1, 14, 7, 1, 0, 14, 7),
(35, 1, 9, 4, 21, 0, 9, 4),
(36, 1, 17, 3, 90, 1, 17, 3),
(37, 1, 18, 9, 90, 1, 18, 9),
(38, 1, 18, 7, 95, 1, 18, 7),
(39, 1, 16, 8, 8, 1, 16, 8),
(40, 1, 18, 14, 92, 1, 18, 14),
(41, 1, 16, 8, 56, 1, 16, 8);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `ordersproductcustomer`
--

CREATE TABLE `ordersproductcustomer` (
  `order_id` int(11) NOT NULL,
  `cu_address` varchar(500) DEFAULT NULL,
  `cu_code` bigint(20) NOT NULL,
  `cu_company_title` varchar(255) DEFAULT NULL,
  `cu_email` varchar(500) DEFAULT NULL,
  `cu_id` int(11) NOT NULL,
  `cu_mobile` varchar(255) DEFAULT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `cu_password` varchar(32) DEFAULT NULL,
  `cu_phone` varchar(255) DEFAULT NULL,
  `cu_status` int(11) NOT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `cu_tax_administration` varchar(255) DEFAULT NULL,
  `cu_tax_number` int(11) NOT NULL,
  `order_count` int(11) NOT NULL,
  `order_customer_id` int(11) NOT NULL,
  `order_product_id` int(11) NOT NULL,
  `order_receipt` bigint(20) NOT NULL,
  `order_status` int(11) NOT NULL,
  `p_buyPrice` int(11) NOT NULL,
  `p_code` int(11) NOT NULL,
  `p_detail` varchar(255) DEFAULT NULL,
  `p_id` int(11) NOT NULL,
  `p_kdv` int(11) NOT NULL,
  `p_quantity` int(11) NOT NULL,
  `p_salesPrice` int(11) NOT NULL,
  `p_title` varchar(255) DEFAULT NULL,
  `p_unit` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `payin`
--

CREATE TABLE `payin` (
  `payIn_id` int(11) NOT NULL,
  `cName` varchar(255) DEFAULT NULL,
  `payIn_amount` int(11) NOT NULL,
  `payIn_date` datetime DEFAULT NULL,
  `payment_detail` varchar(255) DEFAULT NULL,
  `receipt_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `payintable`
--

CREATE TABLE `payintable` (
  `receipt_id` int(11) NOT NULL,
  `box_receipt` bigint(20) NOT NULL,
  `cu_id` int(11) NOT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `payIn_amount` int(11) NOT NULL,
  `payIn_date` datetime DEFAULT NULL,
  `payment_detail` varchar(255) DEFAULT NULL,
  `receipt_total` int(11) NOT NULL,
  `order_receipt` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `payout`
--

CREATE TABLE `payout` (
  `payOut_id` int(11) NOT NULL,
  `payOutDetail` varchar(255) DEFAULT NULL,
  `payOutTitle` varchar(255) DEFAULT NULL,
  `payOutTotal` int(11) NOT NULL,
  `payOutType` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `payout`
--

INSERT INTO `payout` (`payOut_id`, `payOutDetail`, `payOutTitle`, `payOutTotal`, `payOutType`) VALUES
(1, 'Kivi alındı', 'kivi ', 100, 2),
(3, 'elma detay', 'elma', 20, 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `products`
--

CREATE TABLE `products` (
  `p_id` int(11) NOT NULL,
  `p_buyPrice` int(11) NOT NULL,
  `p_code` int(11) NOT NULL,
  `p_detail` varchar(255) DEFAULT NULL,
  `p_kdv` int(11) NOT NULL,
  `p_quantity` int(11) NOT NULL,
  `p_salesPrice` int(11) NOT NULL,
  `p_title` varchar(255) DEFAULT NULL,
  `p_unit` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `products`
--

INSERT INTO `products` (`p_id`, `p_buyPrice`, `p_code`, `p_detail`, `p_kdv`, `p_quantity`, `p_salesPrice`, `p_title`, `p_unit`) VALUES
(3, 5, 161612753, 'Baldo Pirinç', 2, 300, 50, 'Pirinç', 1),
(4, 50, 162393183, 'Kivi', 4, 20, 80, 'Kivi', 2),
(5, 1, 163116794, 'N-95', 1, 100, 10, 'Maske', 4),
(7, 5, 527981061, 'Makarna', 2, 200, 10, 'Makarna', 1),
(8, 20, 596518586, 'Su Detay', 2, 300, 30, 'Su', 1),
(9, 100, 628268381, 'Bosch', 1, 3, 500, 'Klima', 1),
(14, 11, 674307119, 'aa', 1, 23, 22, 'aaa', 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `receipt`
--

CREATE TABLE `receipt` (
  `receipt_id` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `receipt_payment` int(11) NOT NULL,
  `receipt_total` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `receipt`
--

INSERT INTO `receipt` (`receipt_id`, `date`, `receipt_payment`, `receipt_total`) VALUES
(1, '2021-08-31 22:59:49', 0, 600),
(2, '2021-08-31 23:01:05', 0, 600),
(5, '2021-09-01 00:22:47', 0, 150),
(6, '2021-09-01 00:25:36', 0, 50),
(7, '2021-09-01 00:36:43', 0, 50),
(8, '2021-09-01 00:37:43', 0, 80),
(9, '2021-09-01 01:08:43', 0, 1650),
(10, '2021-09-01 01:09:57', 0, 100),
(11, '2021-09-01 17:43:20', 0, 240),
(12, '2021-09-01 17:45:49', 0, 100),
(13, '2021-09-01 23:27:36', 0, 20),
(14, '2021-09-01 23:36:58', 0, 2550),
(16, '2021-09-02 19:23:38', 0, 10),
(17, '2021-09-02 19:24:45', 0, 30),
(19, '2021-09-02 22:06:21', 0, 10),
(20, '2021-09-03 03:11:18', 0, 50),
(22, '2021-09-03 03:19:16', 0, 10),
(23, '2021-09-03 13:17:18', 0, 30),
(24, '2021-09-03 16:06:06', 0, 22),
(25, '2021-09-03 16:06:44', 0, 30);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `receiptall`
--

CREATE TABLE `receiptall` (
  `join_receipt` int(11) NOT NULL,
  `join_receipt_total` int(11) NOT NULL,
  `receipt_payment` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `receipt_orders`
--

CREATE TABLE `receipt_orders` (
  `Receipt_receipt_id` int(11) NOT NULL,
  `Orders_order_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `receipt_orders`
--

INSERT INTO `receipt_orders` (`Receipt_receipt_id`, `Orders_order_id`) VALUES
(5, 13),
(5, 14),
(5, 15),
(5, 16),
(6, 18),
(7, 19),
(8, 20),
(9, 9),
(10, 21),
(11, 22),
(12, 23),
(13, 24),
(14, 25),
(16, 27),
(17, 29),
(19, 31),
(20, 36),
(22, 38),
(23, 39),
(24, 40),
(25, 41);

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`aid`);

--
-- Tablo için indeksler `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`cu_id`);
ALTER TABLE `customer` ADD FULLTEXT KEY `customerName` (`cu_name`);

--
-- Tablo için indeksler `customersearch`
--
ALTER TABLE `customersearch`
  ADD PRIMARY KEY (`cu_id`);

--
-- Tablo için indeksler `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `FK1ttru6okx4lydanww3hieorbh` (`customer_cu_id`),
  ADD KEY `FK4j6gqq9oaiwxfo06788blggq0` (`product_p_id`);

--
-- Tablo için indeksler `ordersproductcustomer`
--
ALTER TABLE `ordersproductcustomer`
  ADD PRIMARY KEY (`order_id`);

--
-- Tablo için indeksler `payin`
--
ALTER TABLE `payin`
  ADD PRIMARY KEY (`payIn_id`);

--
-- Tablo için indeksler `payintable`
--
ALTER TABLE `payintable`
  ADD PRIMARY KEY (`receipt_id`);

--
-- Tablo için indeksler `payout`
--
ALTER TABLE `payout`
  ADD PRIMARY KEY (`payOut_id`);
ALTER TABLE `payout` ADD FULLTEXT KEY `payOut` (`payOutTitle`);

--
-- Tablo için indeksler `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`p_id`);

--
-- Tablo için indeksler `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`receipt_id`);

--
-- Tablo için indeksler `receiptall`
--
ALTER TABLE `receiptall`
  ADD PRIMARY KEY (`join_receipt`);

--
-- Tablo için indeksler `receipt_orders`
--
ALTER TABLE `receipt_orders`
  ADD UNIQUE KEY `UK_hh11xwdbr8vrhyvglon4brmuf` (`Orders_order_id`),
  ADD KEY `FKc1dtbafymm3fw1bx837q4s3pj` (`Receipt_receipt_id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `admin`
--
ALTER TABLE `admin`
  MODIFY `aid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Tablo için AUTO_INCREMENT değeri `customer`
--
ALTER TABLE `customer`
  MODIFY `cu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Tablo için AUTO_INCREMENT değeri `customersearch`
--
ALTER TABLE `customersearch`
  MODIFY `cu_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- Tablo için AUTO_INCREMENT değeri `payin`
--
ALTER TABLE `payin`
  MODIFY `payIn_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `payout`
--
ALTER TABLE `payout`
  MODIFY `payOut_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `products`
--
ALTER TABLE `products`
  MODIFY `p_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Tablo için AUTO_INCREMENT değeri `receipt`
--
ALTER TABLE `receipt`
  MODIFY `receipt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `FK1ttru6okx4lydanww3hieorbh` FOREIGN KEY (`customer_cu_id`) REFERENCES `customer` (`cu_id`),
  ADD CONSTRAINT `FK4j6gqq9oaiwxfo06788blggq0` FOREIGN KEY (`product_p_id`) REFERENCES `products` (`p_id`);

--
-- Tablo kısıtlamaları `receipt_orders`
--
ALTER TABLE `receipt_orders`
  ADD CONSTRAINT `FK5no62ua5jokvcx4u5yferrr8n` FOREIGN KEY (`Orders_order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `FKc1dtbafymm3fw1bx837q4s3pj` FOREIGN KEY (`Receipt_receipt_id`) REFERENCES `receipt` (`receipt_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
