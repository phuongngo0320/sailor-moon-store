-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Dec 05, 2023 at 03:26 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sailormoonstore`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_orderdetail` (IN `orderid` INT, IN `productid` INT)   BEGIN
    DELETE FROM order_detail
    WHERE EXISTS (
        SELECT *
        FROM order_detail
        WHERE order_id = orderid and product_id = productid and quantity = 0
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_orderdetail` (IN `orderid` INT, IN `productid` INT, IN `quantity` INT)   BEGIN
    IF NOT EXISTS (SELECT * FROM orders WHERE order_id = orderid) THEN
        SELECT 'No Order ID found' AS message;
    END IF;

    SET @unit_price = (SELECT price FROM product WHERE id = productid);
    IF (SELECT COUNT(*) FROM promotion_product WHERE product_id = productid) > 0 THEN
        SET @promo_Value = (SELECT MAX(promo_value) FROM promotion WHERE id IN (SELECT promo_id 
                                                                                FROM promotion_product 
                                                                                WHERE product_id = productid));
    ELSE
        SET @promo_Value = 0;
    END IF;

    INSERT INTO order_detail 
    VALUES (orderid, productid, @unit_price, quantity, @promo_Value);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_addquantity` (IN `orderid` INT, IN `productid` INT)   BEGIN
    UPDATE order_detail SET quantity = quantity + 1 WHERE order_id = orderid and product_id = productid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_decrquantity` (IN `orderid` INT, IN `productid` INT)   BEGIN
    UPDATE order_detail SET quantity = quantity - 1 WHERE order_id = orderid and product_id = productid;
    CALL delete_orderdetail(orderid,productid);
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `BranchAverageRating` (`region_id` INT, `branch_no` INT, `year_` INT) RETURNS DECIMAL(10,1)  BEGIN 
    DECLARE avgRating DECIMAL(10, 1);

    SELECT AVG(R.rating)
    INTO avgRating 
    FROM Review AS R 
        JOIN Product AS P ON R.pro_id = P.id 
        JOIN Branch_Product AS BP ON BP.product_id = P.id
        JOIN Branch AS B ON BP.branch_no = B.number
    WHERE 
        DATE(R.time) >= MAKEDATE(year_, 1) AND 
        DATE(R.time) < MAKEDATE(year_ + 1, 1) AND 
        B.number = branch_no AND 
        B.region_id = region_id;

    RETURN (avgRating);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `BranchRevenue` (`region_id` INT, `branch_no` INT, `year_` INT) RETURNS INT(11)  BEGIN 
    DECLARE sum_order_price INT;
    DECLARE sum_dlvr_fee INT; 

    SELECT SUM(OD.unit_price * OD.quantity * (100 - OD.promo_amount) / 100)
    INTO sum_order_price 
    FROM Bill
        JOIN Orders AS O ON O.id = Bill.order_id
        JOIN Order_Detail AS OD ON OD.order_id = O.id
        JOIN Product AS P ON OD.product_id = P.id 
        JOIN Branch AS B ON O.branch_no = B.number 
    WHERE 
        DATE(Bill.issue_time) >= MAKEDATE(year_, 1) AND 
        DATE(Bill.issue_time) < MAKEDATE(year_ + 1, 1) AND 
        B.number = branch_no AND 
        B.region_id = region_id;

    SELECT SUM(Bill.dlvr_fee)
    INTO sum_dlvr_fee
    FROM Bill
        JOIN Orders AS O ON O.id = Bill.order_id
        JOIN Branch AS B ON O.branch_no = B.number 
    WHERE 
        DATE(Bill.issue_time) >= MAKEDATE(year_, 1) AND 
        DATE(Bill.issue_time) < MAKEDATE(year_ + 1, 1) AND 
        B.number = branch_no AND 
        B.region_id = region_id;

    RETURN sum_order_price + sum_dlvr_fee;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accountant`
--

CREATE TABLE `accountant` (
  `acct_id` int(11) NOT NULL,
  `acct_certificate` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accountant`
--

INSERT INTO `accountant` (`acct_id`, `acct_certificate`) VALUES
(106, 'VACPA'),
(107, 'ACCA'),
(109, 'CIA'),
(111, 'CMA'),
(115, 'CPA'),
(118, 'CIMA'),
(119, 'VACPA'),
(120, 'FRM'),
(122, 'FRM'),
(123, 'CIA'),
(124, 'CFA'),
(125, 'ACCA'),
(126, 'CPA'),
(127, 'VACPA'),
(134, 'CIMA'),
(140, 'CIA'),
(144, 'VACPA'),
(150, 'VACPA'),
(159, 'CIMA'),
(167, 'FRM'),
(170, 'ACCA'),
(176, 'ACCA'),
(177, 'CPA'),
(181, 'VACPA'),
(187, 'CIA'),
(188, 'ACCA'),
(189, 'VACPA'),
(192, 'FRM'),
(198, 'CPA'),
(199, 'FRM');

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `acct_id` int(11) DEFAULT NULL,
  `issue_time` datetime DEFAULT NULL,
  `dlvr_time` datetime DEFAULT NULL,
  `dlvr_fee` int(11) DEFAULT NULL,
  `dlvr_address_street` varchar(50) DEFAULT NULL,
  `dlvr_address_district` varchar(50) DEFAULT NULL,
  `dlvr_address_city` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`id`, `order_id`, `acct_id`, `issue_time`, `dlvr_time`, `dlvr_fee`, `dlvr_address_street`, `dlvr_address_district`, `dlvr_address_city`) VALUES
(12231, 12231, 134, '2023-05-06 00:00:00', '2023-06-06 00:00:00', 0, '108, Phạm Hữu Lầu, Phú Mỹ', 'quận 7', 'TPHCM'),
(12302, 12302, 167, '2023-03-04 00:00:00', '2023-04-04 00:00:00', 30000, '21, Lê Đại Hành, Phường 3', 'thành phố Đà Lạt', 'Lâm Đồng'),
(12311, 12311, 198, '2023-05-08 00:00:00', '2023-06-08 00:00:00', 0, '61, Mai Anh Tuấn', 'quận Đống Đa', 'Hà Nội'),
(12313, 12313, 187, '2023-11-07 00:00:00', '2023-12-07 00:00:00', 0, '78, Võ Nguyên Giáp, Phước Mỹ', 'Quận Sơn Trà', 'Đà Nẵng'),
(12342, 12342, 127, '2023-07-11 00:00:00', '2023-08-11 00:00:00', 15000, '15, thôn Khánh Lợi, xã Cát Khánh', 'huyện Phù Cát', 'Bình Định'),
(12345, 12345, 111, '2023-11-09 00:00:00', '2023-12-09 00:00:00', 15000, '56, Suối Môn', 'thành phố Cam Ranh', 'Khánh Hòa'),
(12347, 12347, 123, '2023-11-09 00:00:00', '2023-12-09 00:00:00', 15000, '78, 534, xã Nghi Văn', 'huyện Nghi Lộc', 'Nghệ An'),
(12348, 12348, 124, '2023-05-09 00:00:00', '2023-06-09 00:00:00', 30000, '22, Tân Lập, Đông Hòa', 'Dĩ An', 'Bình Dương'),
(12352, 12352, 176, '2023-10-08 00:00:00', '2023-11-08 00:00:00', 0, '21, Lạc Long Quân', 'quận Tây Hồ', 'Hà Nội'),
(12389, 12389, 119, '2023-08-15 00:00:00', '2023-08-16 00:00:00', 15000, '12, Đinh Điền, Đông Thành', 'thành phố Ninh Bình', 'Ninh Bình'),
(12392, 12392, 126, '2023-07-14 00:00:00', '2023-07-15 00:00:00', 30000, '24, Trương Vĩnh Trọng', 'huyện Giồng Tôm', 'Bến Tre'),
(12456, 12456, 189, '2023-01-07 00:00:00', '2023-02-07 00:00:00', 0, '29, Vân An', 'quận Ba Đình', 'Hà Nội'),
(12923, 12923, 150, '2023-09-09 00:00:00', '2023-10-09 00:00:00', 0, '24, Ngọc Hải', 'huyện Thanh Trì', 'Hà Nội'),
(13098, 13098, 177, '2023-07-07 00:00:00', '2023-08-07 00:00:00', 0, '18, Hùng Vương, Vĩnh Trung', 'quận Thanh Khê', 'Đà Nẵng'),
(13145, 13145, 118, '2023-10-03 00:00:00', '2023-11-03 00:00:00', 0, '32, Âu Cơ', 'quận Tân Bình', 'TPHCM'),
(13456, 13456, 125, '2023-07-08 00:00:00', '2023-08-08 00:00:00', 30000, '37, khu phố 3, Phường 3', 'thị xã Gò Công', 'Tiền Giang'),
(29871, 29871, 127, '2023-08-08 00:00:00', '2023-09-08 00:00:00', 0, '62, Trương Phước Phan, Bình Trị Đông', 'quận Bình Tân', 'TPHCM'),
(65890, 65890, 115, '2023-08-16 00:00:00', '2023-08-17 00:00:00', 15000, '28, Đường 16 tháng 4, Phường Mỹ Hải', 'TP. Phan Rang-Tháp Chàm', 'Ninh Thuận'),
(76545, 76545, 170, '2023-02-08 00:00:00', '2023-03-08 00:00:00', 15000, '33, Xuân Diệu, Bắc Hòa', 'thành phố Hà Tĩnh', 'Hà Tĩnh');

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `region_id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `mgr_id` int(11) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `phone` char(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`region_id`, `number`, `mgr_id`, `name`, `address`, `phone`) VALUES
(1, 1, 488, 'SailorMoonStore 1', '35 phường số 7, An Lộc A, Bình Tân, Thành phố Hồ C', '0909667745'),
(2, 2, 421, 'SailorMoonStore 2', '110 Mai Hắc Đế, quận Hai Bà Trưng, Hà Nội', '0916364572'),
(3, 3, 432, 'SailorMoonStore 3', '89B P. Lý Thường Kiệt, Cửa Nam, Hoàn Kiếm, Hà Nội', '0908070605'),
(4, 4, 467, 'SailorMoonStore 4', '34 P. Trần Bình, Mỹ Đình, Nam Tử Liêm, Hà Nội', '0389567231'),
(5, 5, 498, 'SailorMoonStore 5', '386 Điện Biên Phủ, Q.Thanh Khê, Tp.Đà Nẵng', '0345678912'),
(6, 6, 456, 'SailorMoonStore 6', '17 Võ Văn Kiệt, An Hải Bắc, Sơn Trà, Đà Nẵng', '0974568934');

-- --------------------------------------------------------

--
-- Table structure for table `branch_product`
--

CREATE TABLE `branch_product` (
  `region_id` int(11) NOT NULL,
  `branch_no` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch_product`
--

INSERT INTO `branch_product` (`region_id`, `branch_no`, `product_id`) VALUES
(1, 1, 100231),
(1, 1, 100325),
(1, 1, 100341),
(1, 1, 103502),
(1, 1, 103911),
(1, 1, 107341),
(1, 1, 109352),
(1, 1, 700141),
(1, 1, 700325),
(1, 1, 700391),
(1, 1, 703145),
(1, 1, 703420),
(1, 1, 709341),
(1, 1, 712421),
(1, 1, 723431),
(1, 1, 723532),
(1, 1, 723911),
(1, 1, 724524),
(1, 1, 725141),
(1, 1, 734545),
(1, 1, 741124),
(1, 1, 745253),
(1, 1, 745301),
(1, 1, 745344),
(1, 1, 754312),
(1, 1, 754901),
(1, 1, 755721),
(1, 1, 772831),
(1, 1, 777341),
(1, 1, 782131),
(1, 1, 790231),
(1, 1, 790341),
(1, 1, 790832),
(1, 1, 793502),
(1, 1, 793532),
(1, 1, 799235),
(1, 1, 799351),
(1, 1, 799352),
(1, 1, 799395),
(1, 1, 801244),
(1, 1, 803420),
(1, 1, 806456),
(1, 1, 809341),
(1, 1, 809683),
(1, 1, 812421),
(1, 1, 823431),
(1, 1, 823532),
(1, 1, 823911),
(1, 1, 824524),
(1, 1, 825141),
(1, 1, 841124),
(1, 1, 845301),
(1, 1, 845344),
(1, 1, 854312),
(1, 1, 854901),
(1, 1, 855721),
(1, 1, 882131),
(1, 1, 890341),
(1, 1, 890832),
(1, 1, 900141),
(1, 1, 900325),
(1, 1, 900391),
(1, 1, 903145),
(1, 1, 903420),
(1, 1, 906456),
(1, 1, 909341),
(1, 1, 909683),
(1, 1, 912421),
(1, 1, 923431),
(1, 1, 923532),
(1, 1, 924524),
(1, 1, 925141),
(1, 1, 934545),
(1, 1, 941124),
(1, 1, 945253),
(1, 1, 945301),
(1, 1, 945344),
(1, 1, 954312),
(1, 1, 954901),
(1, 1, 955721),
(1, 1, 972831),
(1, 1, 977341),
(1, 1, 982131),
(1, 1, 990231),
(1, 1, 990832),
(1, 1, 993502),
(1, 1, 993532),
(1, 1, 999235),
(1, 1, 999351),
(1, 1, 999352),
(1, 1, 999395),
(2, 2, 100231),
(2, 2, 100325),
(2, 2, 100341),
(2, 2, 103502),
(2, 2, 103911),
(2, 2, 107341),
(2, 2, 109352),
(2, 2, 700141),
(2, 2, 700325),
(2, 2, 700391),
(2, 2, 703145),
(2, 2, 703420),
(2, 2, 709341),
(2, 2, 712421),
(2, 2, 723431),
(2, 2, 723532),
(2, 2, 723911),
(2, 2, 724524),
(2, 2, 725141),
(2, 2, 734545),
(2, 2, 741124),
(2, 2, 745253),
(2, 2, 745301),
(2, 2, 745344),
(2, 2, 754312),
(2, 2, 754901),
(2, 2, 755721),
(2, 2, 772831),
(2, 2, 777341),
(2, 2, 782131),
(2, 2, 790231),
(2, 2, 790341),
(2, 2, 790832),
(2, 2, 793502),
(2, 2, 793532),
(2, 2, 799235),
(2, 2, 799351),
(2, 2, 799352),
(2, 2, 799395),
(2, 2, 801244),
(2, 2, 803420),
(2, 2, 806456),
(2, 2, 809341),
(2, 2, 809683),
(2, 2, 812421),
(2, 2, 823431),
(2, 2, 823532),
(2, 2, 823911),
(2, 2, 824524),
(2, 2, 825141),
(2, 2, 841124),
(2, 2, 845301),
(2, 2, 845344),
(2, 2, 854312),
(2, 2, 854901),
(2, 2, 855721),
(2, 2, 882131),
(2, 2, 890341),
(2, 2, 890832),
(2, 2, 900141),
(2, 2, 900325),
(2, 2, 900391),
(2, 2, 903145),
(2, 2, 903420),
(2, 2, 906456),
(2, 2, 909341),
(2, 2, 909683),
(2, 2, 912421),
(2, 2, 923431),
(2, 2, 923532),
(2, 2, 924524),
(2, 2, 925141),
(2, 2, 934545),
(2, 2, 941124),
(2, 2, 945253),
(2, 2, 945301),
(2, 2, 945344),
(2, 2, 954312),
(2, 2, 954901),
(2, 2, 955721),
(2, 2, 972831),
(2, 2, 977341),
(2, 2, 982131),
(2, 2, 990231),
(2, 2, 990832),
(2, 2, 993502),
(2, 2, 993532),
(2, 2, 999235),
(2, 2, 999351),
(2, 2, 999352),
(2, 2, 999395),
(3, 3, 100231),
(3, 3, 100325),
(3, 3, 100341),
(3, 3, 103502),
(3, 3, 103911),
(3, 3, 107341),
(3, 3, 109352),
(3, 3, 700141),
(3, 3, 700325),
(3, 3, 700391),
(3, 3, 703145),
(3, 3, 703420),
(3, 3, 709341),
(3, 3, 712421),
(3, 3, 723431),
(3, 3, 723532),
(3, 3, 723911),
(3, 3, 724524),
(3, 3, 725141),
(3, 3, 734545),
(3, 3, 741124),
(3, 3, 745253),
(3, 3, 745301),
(3, 3, 745344),
(3, 3, 754312),
(3, 3, 754901),
(3, 3, 755721),
(3, 3, 772831),
(3, 3, 777341),
(3, 3, 782131),
(3, 3, 790231),
(3, 3, 790341),
(3, 3, 790832),
(3, 3, 793502),
(3, 3, 793532),
(3, 3, 799235),
(3, 3, 799351),
(3, 3, 799352),
(3, 3, 799395),
(3, 3, 801244),
(3, 3, 803420),
(3, 3, 806456),
(3, 3, 809341),
(3, 3, 809683),
(3, 3, 812421),
(3, 3, 823431),
(3, 3, 823532),
(3, 3, 823911),
(3, 3, 824524),
(3, 3, 825141),
(3, 3, 841124),
(3, 3, 845301),
(3, 3, 845344),
(3, 3, 854312),
(3, 3, 854901),
(3, 3, 855721),
(3, 3, 882131),
(3, 3, 890341),
(3, 3, 890832),
(3, 3, 900141),
(3, 3, 900325),
(3, 3, 900391),
(3, 3, 903145),
(3, 3, 903420),
(3, 3, 906456),
(3, 3, 909341),
(3, 3, 909683),
(3, 3, 912421),
(3, 3, 923431),
(3, 3, 923532),
(3, 3, 924524),
(3, 3, 925141),
(3, 3, 934545),
(3, 3, 941124),
(3, 3, 945253),
(3, 3, 945301),
(3, 3, 945344),
(3, 3, 954312),
(3, 3, 954901),
(3, 3, 955721),
(3, 3, 972831),
(3, 3, 977341),
(3, 3, 982131),
(3, 3, 990231),
(3, 3, 990832),
(3, 3, 993502),
(3, 3, 993532),
(3, 3, 999235),
(3, 3, 999351),
(3, 3, 999352),
(3, 3, 999395),
(4, 4, 100231),
(4, 4, 100325),
(4, 4, 100341),
(4, 4, 103502),
(4, 4, 103911),
(4, 4, 107341),
(4, 4, 109352),
(4, 4, 700141),
(4, 4, 700325),
(4, 4, 700391),
(4, 4, 703145),
(4, 4, 703420),
(4, 4, 709341),
(4, 4, 712421),
(4, 4, 723431),
(4, 4, 723532),
(4, 4, 723911),
(4, 4, 724524),
(4, 4, 725141),
(4, 4, 734545),
(4, 4, 741124),
(4, 4, 745253),
(4, 4, 745301),
(4, 4, 745344),
(4, 4, 754312),
(4, 4, 754901),
(4, 4, 755721),
(4, 4, 772831),
(4, 4, 777341),
(4, 4, 782131),
(4, 4, 790231),
(4, 4, 790341),
(4, 4, 790832),
(4, 4, 793502),
(4, 4, 793532),
(4, 4, 799235),
(4, 4, 799351),
(4, 4, 799352),
(4, 4, 799395),
(4, 4, 801244),
(4, 4, 803420),
(4, 4, 806456),
(4, 4, 809341),
(4, 4, 809683),
(4, 4, 812421),
(4, 4, 823431),
(4, 4, 823532),
(4, 4, 823911),
(4, 4, 824524),
(4, 4, 825141),
(4, 4, 841124),
(4, 4, 845301),
(4, 4, 845344),
(4, 4, 854312),
(4, 4, 854901),
(4, 4, 855721),
(4, 4, 882131),
(4, 4, 890341),
(4, 4, 890832),
(4, 4, 900141),
(4, 4, 900325),
(4, 4, 900391),
(4, 4, 903145),
(4, 4, 903420),
(4, 4, 906456),
(4, 4, 909341),
(4, 4, 909683),
(4, 4, 912421),
(4, 4, 923431),
(4, 4, 923532),
(4, 4, 924524),
(4, 4, 925141),
(4, 4, 934545),
(4, 4, 941124),
(4, 4, 945253),
(4, 4, 945301),
(4, 4, 945344),
(4, 4, 954312),
(4, 4, 954901),
(4, 4, 955721),
(4, 4, 972831),
(4, 4, 977341),
(4, 4, 982131),
(4, 4, 990231),
(4, 4, 990832),
(4, 4, 993502),
(4, 4, 993532),
(4, 4, 999235),
(4, 4, 999351),
(4, 4, 999352),
(4, 4, 999395);

-- --------------------------------------------------------

--
-- Table structure for table `branch_supplier`
--

CREATE TABLE `branch_supplier` (
  `region_id` int(11) NOT NULL,
  `branch_no` int(11) NOT NULL,
  `sup_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch_supplier`
--

INSERT INTO `branch_supplier` (`region_id`, `branch_no`, `sup_id`) VALUES
(1, 1, 0),
(1, 1, 7),
(1, 1, 8),
(1, 1, 9),
(2, 2, 0),
(2, 2, 7),
(2, 2, 8),
(2, 2, 9),
(3, 3, 0),
(3, 3, 7),
(3, 3, 8),
(3, 3, 9),
(4, 4, 0),
(4, 4, 7),
(4, 4, 8),
(4, 4, 9),
(5, 5, 0),
(5, 5, 7),
(5, 5, 8),
(5, 5, 9),
(6, 6, 0),
(6, 6, 7),
(6, 6, 8),
(6, 6, 9);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `descr` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `descr`) VALUES
(10, 'nón', 'nón tai bèo, nón lưỡi trai, nón beret'),
(77, 'áo', 'áo thun,áo sweater, áo sơ mi'),
(88, 'quần', 'quần jean, quần thun, quần sọt'),
(99, 'đầm', 'đầm dài xòe, đầm ngắn bồng bềnh, đầm ngắn ôm body');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id`, `name`) VALUES
(1124, 'Nguyễn Ngọc Mai'),
(1234, 'Phan Hoàng Phúc'),
(2125, 'Trần Thanh Tâm'),
(2145, 'Lê Quang Huy'),
(2352, 'Nguyễn Xuân Mai'),
(2356, 'Trương Thị Mỹ Duyên'),
(2536, 'Lê Anh Thư'),
(3124, 'Nguyễn Huỳnh Như'),
(3436, 'Nguyễn Nhật Ánh'),
(3523, 'Lê Thị Ngọc Phương'),
(3667, 'Trần Chí Khiêm'),
(4566, 'Đinh Ngọc Vân'),
(5235, 'Trần Ngọc Băng'),
(5647, 'Phan Văn Lộc'),
(6367, 'Nguyễn Văn Trúc'),
(6473, 'La Ngọc Vân'),
(6633, 'Lê Gia Bảo'),
(7457, 'Nguyễn Văn Vinh'),
(9887, 'Võ Văn Kiệt');

-- --------------------------------------------------------

--
-- Table structure for table `customer_address`
--

CREATE TABLE `customer_address` (
  `cus_id` int(11) NOT NULL,
  `address_street` varchar(255) NOT NULL,
  `address_district` varchar(255) NOT NULL,
  `address_city` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_address`
--

INSERT INTO `customer_address` (`cus_id`, `address_street`, `address_district`, `address_city`) VALUES
(1124, '56, Suối Môn', 'thành phố Cam Ranh', 'Khánh Hòa'),
(1234, '78, 534, xã Nghi Văn', 'huyện Nghi Lộc', 'Nghệ An'),
(2125, '33, Xuân Diệu, Bắc Hòa', 'thành phố Hà Tĩnh', 'Hà Tĩnh'),
(2145, '24, Trương Vĩnh Trọng', 'huyện Giồng Tôm', 'Bến Tre'),
(2352, '32, Âu Cơ', 'quận Tân Bình', 'TPHCM'),
(2356, '12, Đinh Điền, Đông Thành', 'thành phố Ninh Bình', 'Ninh Bình'),
(2536, '21, Lạc Long Quân', 'quận Tây Hồ', 'Hà Nội'),
(3124, '22, Tân Lập, Đông Hòa', 'Dĩ An', 'Bình Dương'),
(3436, '15, thôn Khánh Lợi, xã Cát Khánh', 'huyện Phù Cát', 'Bình Định'),
(3523, '18, Hùng Vương, Vĩnh Trung ', 'quận Thanh Khê', 'Đà Nẵng'),
(3667, '37, khu phố 3, Phường 3', 'thị xã Gò Công', 'Tiền Giang'),
(4566, '21, Lê Đại Hành, Phường 3', 'thành phố Đà Lạt', 'Lâm Đồng'),
(5235, '61, Mai Anh Tuấn', 'quận Đống Đa', 'Hà Nội'),
(5647, '62, Trương Phước Phan, Bình Trị Đông', 'quận Bình Tân', 'TPHCM'),
(6367, '78, Võ Nguyên Giáp, Ph??c M?', 'Quận Sơn Trà', 'Đà Nẵng'),
(6473, '28, Đường 16 tháng 4, Phường Mỹ Hải', 'TP. Phan Rang-Tháp Chàm', 'Ninh Thuận'),
(6633, '29, Vân An', 'quận Ba Đình', 'Hà Nội'),
(7457, '24, Ngọc Hải', 'huyện Thanh Trì', 'Hà Nội'),
(9887, '108, Phạm Hữu Lầu, Phú Mỹ', 'quận 7', 'TPHCM');

-- --------------------------------------------------------

--
-- Table structure for table `customer_email`
--

CREATE TABLE `customer_email` (
  `cus_id` int(11) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_email`
--

INSERT INTO `customer_email` (`cus_id`, `email`) VALUES
(1124, 'mai97@gmail.com'),
(1234, 'phuc23n@gmail.com'),
(2125, 'ttt9091@gmail.com'),
(2145, 'huyle2910@hmail.com'),
(2352, 'mainguyen513@gmail.com'),
(2356, 'myduyen113@gmail.com'),
(2536, 'athu13114@gmail.com'),
(3124, 'nhuhuynh21@gmai.com'),
(3436, 'nhatanh56@gmail.com'),
(3523, 'ntnphuong2891@gmail.com'),
(3667, 'khiemtran34@gmail.com'),
(4566, 'nvan1314@gmail.com'),
(5235, 'nbang89012@gmail.com'),
(5647, 'locpham5792@gmail.com'),
(6367, 'vantruc9898@gmail.com'),
(6473, 'vanla156@gmail.com'),
(6633, 'legiabao90@gmail.com'),
(7457, 'binhnguyen2106@gmail.com'),
(9887, 'vankiet207@gmail.com');

--
-- Triggers `customer_email`
--
DELIMITER $$
CREATE TRIGGER `check_customer_email` BEFORE INSERT ON `customer_email` FOR EACH ROW BEGIN
    IF NOT (NEW.email REGEXP '^[^@]+@[^@]+.[^@]{2,}$') THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The email must be in a valid format.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_phone`
--

CREATE TABLE `customer_phone` (
  `cus_id` int(11) NOT NULL,
  `phone` char(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_phone`
--

INSERT INTO `customer_phone` (`cus_id`, `phone`) VALUES
(1124, '0987231431'),
(1234, '0945656711'),
(2125, '0382434645'),
(2145, '0383255731'),
(2352, '0384365782'),
(2356, '0965468769'),
(2536, '0956467568'),
(3124, '0932545561'),
(3436, '0934656134'),
(3523, '0946431545'),
(3667, '0925346456'),
(4566, '0385435261'),
(5235, '0916451341'),
(5647, '0389003414'),
(6367, '0934656784'),
(6473, '0956246277'),
(6633, '0386588124'),
(7457, '0957781465'),
(9887, '0953464571');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `bdate` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `salary` int(11) DEFAULT NULL,
  `region_id` int(11) DEFAULT NULL,
  `branch_no` int(11) DEFAULT NULL,
  `supervisor_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`id`, `name`, `bdate`, `address`, `start_date`, `salary`, `region_id`, `branch_no`, `supervisor_id`) VALUES
(106, 'Trương Quốc Vinh', '1995-02-03', 'Ấp 2,Phong Thạnh Tây, Giá Rai, Bạc Liêu', '2021-07-31', 9000000, 6, 6, 166),
(107, 'Nguyễn Thanh Hồng', '1997-04-04', 'Thôn 6, Xã Đức Chánh, Huyện Mộ Đức, Tỉnh Quảng Ngãi', '2021-07-31', 9000000, 6, 6, 166),
(109, 'Lê Nguyễn Minh Nhựt', '1990-02-05', '32A/61/52 Miếu Hai Xã, Lê Chân, Hải Phòng', '2021-03-02', 9000000, 6, 6, 166),
(111, 'Lê Như Ý', '1990-01-01', 'ấp Mới, xã Long Định, huyện Châu Thành, tỉnh Tiền Giang', '2021-03-02', 9000000, 1, 1, 488),
(115, 'Nguyễn Thế Hào', '1997-02-04', 'ấp Khánh Thạnh, xã Khánh Thạnh Tân, huyện Mỏ Cày Bắc, tỉnh Bến Tre', '2020-02-21', 9000000, 3, 3, 133),
(118, 'Lê Quang Hùng', '1990-01-09', '12B Nhiêu Tứ phường 7 quận Phú Nhuận TPHCM', '2020-02-21', 9000000, 3, 3, 133),
(119, 'Nguyễn Gia Bảo', '1995-01-05', 'Khóm Huệ Đức, thị trấn Cô Tô, huyện Tri Tôn, tỉnh An Giang', '2021-05-06', 9000000, 3, 3, 133),
(120, 'Trương Văn Thế Hùng', '1994-01-23', 'Đường Nguyễn Thị Minh Khai, khu phố 3, thị trấn Tân Thạnh, huyện Tân Thạnh, tỉnh Long An', '2021-12-31', 9000000, 4, 4, 144),
(122, 'Phạm Ngọc Tuyên', '1997-02-05', '166/27 Châu Văn Liêm, Thị Trấn Hậu Nghĩa, Huyện Đức Hòa, Tỉnh Long An', '2021-05-31', 9000000, 2, 2, 421),
(123, 'Võ Văn Mai', '1989-02-01', '188/21/13B Lê Đình Cẩn, Tân Tạo, Bình Tân, TP.HCM', '2020-02-21', 9000000, 1, 1, 111),
(124, 'Lê Tuấn Lộc', '1999-03-04', NULL, '2021-11-12', 9000000, 1, 1, 111),
(125, 'Nguyễn Thị Ngọc Phươ', '1993-02-01', '1818/3/10, ấp 1C, xã Phước Thái, Long Thành, Đồng Nai', '2021-05-06', 9000000, 1, 1, 111),
(126, 'Trương Ngọc Vàng', '1999-03-03', 'Bích Trung Nam, Triệu Thành, Triệu Phong, Quảng Trị', '2021-05-24', 9000000, 1, 1, 111),
(133, 'Ngô Tuyết Nhi', '1991-08-08', '7/4 Lý Thường Kiệt, P.9, Q.Tân Bình, TP.HCM', '2021-03-02', 9000000, 3, 3, 432),
(134, 'Võ Thanh Trung', '1993-03-08', NULL, '2021-03-02', 9000000, 2, 2, 122),
(140, 'Nguyễn Thanh Hoàng H', '1996-02-07', '86/14, Huỳnh Văn Cù, Tổ 57, Khu phố 4, Phường Hiệp Thành, Thành phố Thủ Dầu Một, Tỉnh Bình Dương', '2021-11-12', 9000000, 5, 5, 155),
(141, 'Lê Hữu Triết', '1990-02-02', 'khu phố 2, Thị Trấn Thứ 11, Huyện An Minh, tỉnh Kiên Giang', '2021-03-02', 9000000, 5, 5, 155),
(144, 'Lê Ngọc Hoa', '1998-07-29', '535/52/21 Thống Nhất phường 16 quận Gò Vấp TP.HCM', '2021-03-02', 9000000, 4, 4, 467),
(150, 'Võ Thanh Tùng', '1991-04-05', '19/g3 khu phố1 phường Long bình tân biên hoà đồng nai', '2021-05-24', 9000000, 4, 4, 144),
(155, 'Trương Ngọc Huỳnh Ma', '1999-06-07', 'Tổ 9, Khu phố Tân An, thị trấn Tân Phú, huyện Đồng Phú, tỉnh Bình Phước', '2020-02-21', 9000000, 5, 5, 498),
(159, 'Trương Nguyễn Phúc N', '1995-03-08', '20B/5, ấp 5, xã Phước Tân Hưng, huyện Châu Thành, tỉnh Long An', '2020-02-21', 9000000, 5, 5, 155),
(166, 'Nguyễn Trương Thanh ', '1994-01-04', '09/1 Thôn 5, xã Tân Châu, huyện Di Linh, tỉnh Lâm Đồng', '2021-07-31', 9000000, 6, 6, 456),
(167, 'Trần Hữu Đức', '1991-02-08', 'Ấp 4, Bàu Cạn, Long Thành, Đồng Nai', '2021-11-12', 9000000, 2, 2, 122),
(170, 'Lê Bảo Hưng', '1997-02-05', '31/71/35 đường số 3, phường Bình Hưng Hòa A, quận Bình Tân, TPHCM', '2021-07-31', 9000000, 4, 4, 144),
(177, 'Nguyễn Thị Xinh', '1995-05-07', 'Khu vực Thới Thạnh 1, phường Thới Thuận, quận Thốt Nốt, TP. Cần Thơ', '2021-07-31', 9000000, 4, 4, 144),
(187, 'Trương Thị Xuân Mai', '1996-01-01', 'Ấp Bảo Vệ, xã Giang Điền, huyện Trảng Bom, tỉnh Đồng Nai', '2021-05-06', 9000000, 3, 3, 133),
(189, 'Mai Ngọc Tuấn', '1999-05-06', '430, ấp Sơn Thành, xã Nam Thái Sơn, huyện Hòn Đất, tỉnh Kiên Giang', '2021-11-12', 9000000, 2, 2, 122),
(192, 'Võ Hoàng Phúc', '1998-06-06', '39/16 Võ Duy Ninh phường 22 quận Bình Thạnh TPHCM', '2021-07-31', 9000000, 6, 6, 166),
(198, 'Nguyễn Ngọc Nhi', '1992-06-06', 'Ấp CHợ, xã Thanh Tuyền, huyện Dầu Tiếng, tỉnh BÌnh DƯơng', '2021-11-12', 9000000, 2, 2, 122),
(199, 'Lâm Bá Hùng', '1991-05-05', '5B2 Trần Thị Thơm, phường 9, Thành phố Mỹ Tho, Tiền Giang', '2021-12-11', 9000000, 5, 5, 155),
(202, 'Lê Bảo Minh', '1990-01-09', '252 Mã Lò, Phường Bình Trị Đông A, Quận Bình Tân, Thành phố Hồ Chí Minh', '2021-05-06', 8000000, 6, 6, 266),
(203, 'Mai Gia Bảo', '1991-02-08', '46/4 Blao Sire Đại Lào, Bảo Lộc, Lâm Đồng', '2021-05-06', 8000000, 5, 5, 255),
(204, 'Huỳnh Thị Ngọc Dung', '1990-01-01', 'xã Phong Mỹ, huyện Cao Lãnh, Đồng Tháp', '2021-11-12', 8000000, 4, 4, 244),
(205, 'Lê Thị Ngọc Liên', '1999-03-04', 'Phường Hưng Trí, Thị Trấn Kỳ Anh, Hà Tĩnh', '2021-11-12', 8000000, 4, 4, 244),
(207, 'Nguyễn Bảo Minh', '1996-01-01', '21A, đường số 1A, P. Bình Hưng Hoà A, Q. Bình Tân, TP. Hồ Chí Minh', '2021-05-06', 8000000, 6, 6, 266),
(209, 'Lê Văn Võ', '1997-04-30', 'Quảng Thái, Quảng Điền, Thừa Thiên Huế', '2021-03-02', 8000000, 4, 4, 244),
(210, 'Ngô Huỳnh Ngọc An', '1997-02-05', 'Số nhà 1122, Ấp 2, Xã Phú Lập, Huyện Tân Phú, Tỉnh Đồng Nai', '2021-04-19', 8000000, 5, 5, 255),
(211, 'Nguyễn Mai Như', '1996-04-06', 'Số 1, hẻm 34 Lạc Long Quân, Hiệp Định, Hiệp Tân, Hoà Thành, Tây Ninh.', '2021-07-31', 8000000, 1, 1, 488),
(219, 'Trương Lê Ánh Dương', '1993-03-08', '23/16/14 Mai Hắc Đế, Phường 15, Quận 8, TP.HCM', '2021-04-19', 8000000, 5, 5, 255),
(220, 'Nguyễn Ngọc Giang', '1989-02-01', 'Bảo Bình - Cẩm Mỹ - Đồng Nai', '2020-02-21', 8000000, 4, 4, 244),
(222, 'Phan Hữu Triết', '1999-02-05', 'Tổ 16, ấp Đông, Kim Sơn, Châu Thành, Tiền Giang', '2021-07-31', 8000000, 2, 2, 421),
(223, 'Nguyễn Trọng Thức', '1998-08-15', 'xóm 2 thôn 3 , Bắc Ruộng, Tánh Linh, Bình Thuận', '2021-07-31', 8000000, 2, 2, 222),
(231, 'Huỳnh Ngọc Kha', '1994-09-15', '55 Mạc Thị Bưởi, Xã Lộc Thanh, TP Bảo Lộc, Tỉnh Lâm Đồng', '2021-07-31', 8000000, 3, 3, 233),
(233, 'Nguyễn Ngọc Linh', '1997-05-25', 'Thái Bình, Châu Thành, Tây Ninh', '2021-07-31', 8000000, 3, 3, 432),
(234, 'Nguyễn Hữu Trung', '1994-02-23', 'Ấp 6, xã Hòa Hội, huyện Xuyên Mộc, tỉnh Bà Rịa - Vũng Tàu', '2021-07-31', 8000000, 3, 3, 233),
(239, 'Mai Văn Tiến', '1992-08-18', 'Trường Bắn, Xuân Tâm, Xuân Lộc, Đồng Nai', '2021-07-31', 8000000, 3, 3, 233),
(240, 'Trương Văn Sơn', '1999-03-03', 'Số 5 Hoàng Hoa Thám, Đông Hòa, Dĩ An, Bình Dương', '2021-03-02', 8000000, 5, 5, 255),
(244, 'Nguyễn Ngọc Trâm', '1996-03-20', '36, khu phố 7, phường Tân Thới Nhất, đường TTN02, quận 12, tp.HCM', '2021-07-31', 8000000, 4, 4, 467),
(245, 'Phan Văn Vũ', '1999-09-09', '100A, Ấp 7, Tân Bửu, Bến Lức, Long An', '2021-11-12', 8000000, 1, 1, 211),
(248, 'Nguyễn Ngọc Ngạn', '1997-03-01', '18 Nguyễn Đình Chiểu, P1, Tân An, Long An', '2020-02-21', 8000000, 1, 1, 211),
(253, 'Nguyễn Phu Trung', '1998-07-07', '56B5 tổ 9C khu phố 12 phường An Bình, Biên Hòa, Đồng Nai', '2021-11-12', 8000000, 1, 1, 211),
(255, 'Nguyễn Văn Bình', '1993-02-01', 'B11/18, hẻm 747, phường Tam Hiệp, Biên hòa, Đồng Nai', '2021-11-12', 8000000, 5, 5, 498),
(256, 'Nguyễn Phan An', '1997-02-15', '20 Nguyễn Văn Huề, phường Thanh Khê Tây, quận Thanh Khê, Thành phố Đà Nẵng', '2021-07-31', 8000000, 2, 2, 222),
(261, 'Nguyễn Văn Hưu', '1992-06-22', 'Tổ 3, ấp Soor Rung, xã Lộc Phú, huyện Lộc Ninh, tỉnh Bình Phước', '2021-05-24', 8000000, 6, 6, 266),
(266, 'Trương Lê Đán Phúc N', '1999-05-06', 'KDC số 3, Thôn Dương Quang, Xã Đức Thắng, Huyện Mộ Đức, Tỉnh Quảng Ngãi', '2021-05-24', 8000000, 6, 6, 456),
(267, 'Trần Văn Trọng', '1998-03-21', 'ấp Tín Nghĩa, xã Xuân Thiện, huyện Thống Nhất, tỉnh Đồng Nai', '2021-07-31', 8000000, 3, 3, 233),
(276, 'Lê Minh Hiếu', '1991-08-24', 'A4/11 ấp 1 xã Quy Đức huyện Bình Chánh TPHCM', '2021-03-02', 8000000, 6, 6, 266),
(278, 'Lê Hữu An', '1999-06-23', '30/48 Lê Anh Xuân, Thới Bình, Ninh Kiều, Cần Thơ', '2021-07-31', 8000000, 2, 2, 222),
(289, 'Lâm Bá Hào', '1998-04-13', 'Số 47, tổ 21, ấp Công Thành, xã Quảng Thành, huyện Châu Đức, tỉnh BRVT', '2021-03-02', 8000000, 1, 1, 211),
(290, 'Nguyễn Ngọc An', '1995-05-23', '107 Tổ 4 ấp Bình Thuận, Bình Trưng, Châu Thành, Tiền Giang', '2021-03-02', 8000000, 2, 2, 222),
(308, 'Nguyễn Văn Phương', '1995-03-08', 'Xã CưEBur, thành phố Buôn Ma Thuột, tỉnh Đăk Lăk', '2021-03-02', 7000000, 3, 3, 333),
(309, 'Nguyễn Thanh Văn', '1994-01-04', '9/12 Trần Quang Cơ, phường Phú Thạnh, quận Tân Phú', '2021-04-19', 7000000, 3, 3, 333),
(310, 'Lê Ngọc Tuấn', '1999-06-07', '271/1, ấp Bình Xuyên, xã Bình Quới, huyện Châu Thành, tỉnh Long An', '2021-04-19', 7000000, 2, 2, 322),
(311, 'Nguyễn Quang Đăng', '1995-01-05', '68, đường 3 tháng 2, thị trấn Đạ Tẻh, huyện Đạ Tẻh, tỉnh Lâm Đồng', '2020-02-21', 7000000, 1, 1, 488),
(315, 'Bùi Văn Tài', '1998-06-06', '25b/5, KP.9, P.Tân Biên, Biên Hòa, Đồng Nai', '2021-04-19', 7000000, 3, 3, 333),
(316, 'Lê Hiếu Tâm', '1998-08-15', '77/39 Trần Văn Quang Phường 10 Quận Tân Bình', '2021-05-24', 7000000, 5, 5, 355),
(319, 'Nguyễn Văn Hiển', '1991-05-05', 'Phước Đa 1, Ninh Đa, Ninh Hoà, Khánh Hoà', '2021-07-31', 7000000, 2, 2, 322),
(320, 'Lương Hiếu Tâm', '1997-02-15', 'Khu phố 2, Thị trấn Bến Cầu, huyện Bến Cầu, tỉnh Tây Ninh', '2021-05-06', 7000000, 5, 5, 355),
(321, 'Lê Tuấn Lâm', '1995-05-07', 'Ấp Thạnh Phú, xã Đồng Thạnh, huyện Gò Công Tây, tỉnh Tiền Giang', '2021-04-19', 7000000, 2, 2, 322),
(322, 'Nguyễn Ngọc Hiền', '1991-04-05', '70-70A Tân Kỳ Tân Quý, P. Tây Thạnh, Q. Tân Phú, TP Hồ Chí Minh', '2020-02-21', 7000000, 2, 2, 421),
(329, 'Võ Văn Hữu', '1999-02-05', 'Phường Nguyễn Nghiêm, Thị xã Đức Phổ, Quãng Ngãi', '2021-03-02', 7000000, 5, 5, 355),
(333, 'Lê Quốc Trung', '1996-02-07', '241 Thủy Phú, IaBlứ, Chư Pưh, Gia Lai', '2020-02-21', 7000000, 3, 3, 432),
(341, 'Trần Tú Trinh', '1999-09-09', 'Ấp 1, xã Tân Tây, Thạnh Hóa, Long An', '2020-02-21', 7000000, 4, 4, 344),
(342, 'Trương Lê Hướng Dươn', '1995-02-03', 'ấp Hưng Thạnh, xã Long Hưng, thị xã Gò Công, tỉnh Tiền Giang', '2021-07-31', 7000000, 4, 4, 344),
(344, 'Võ Đăng Khoa', '1997-04-04', 'Số 622, Kv Qui Thạnh 1, P Trung Kiên, Q Thốt Nốt, TP Cần Thơ', '2021-05-06', 7000000, 4, 4, 467),
(347, 'Nguyễn Thị Lài', '1996-04-06', 'Thôn Tiến Bình, xã Tiến Thành, Phan Thiết, Bình Thuận', '2021-04-19', 7000000, 4, 4, 344),
(348, 'Lê Văn Tám', '1997-03-01', 'Thôn Mỵ Trường, Hải Trường, Hải Lăng,', '2021-04-19', 7000000, 4, 4, 344),
(351, 'Trần Ngọc Trâm', '1998-04-13', '170/32 Lê Đức Thọ, Phường 6, Gò Vấp, Thành phố Hồ Chí Minh', '2021-11-12', 7000000, 5, 5, 355),
(355, 'Trần Ngọc Trinh', '1998-07-07', 'Thôn Tân Long xã Châu Pha thị xã Phú Mỹ tỉnh Bà Rịa Vũng Tàu', '2021-11-12', 7000000, 5, 5, 498),
(356, 'Nguyễn Quốc Trung', '1990-02-02', '86 Lạc Thạnh, Tu Tra, Đơn Dương, Lâm Đồng', '2021-04-19', 7000000, 2, 2, 322),
(359, 'Phùng Hữu Thắng', '1995-05-23', 'Số 18,đường D1, khu dân cư Lê Phong, phường Đông Hoà, thành phố Dĩ An, tỉnh Bình Dương', '2020-02-21', 7000000, 6, 6, 366),
(361, 'Trương Ánh My', '1997-04-25', 'Khu phố Gia Tân, Phường Gia Lộc, Thị xã Trảng Bàng, Tỉnh Tây Ninh', '2021-04-19', 7000000, 6, 6, 366),
(365, 'Lê Thị Mỹ', '1998-03-21', 'Tây hà 4 , xã Cư Bao, Thị xã Buôn Hồ ,Đak Lak', '2021-04-19', 7000000, 6, 6, 366),
(366, 'Dương Ngọc Minh Thư', '1999-06-23', 'thôn Trà Bình Đông, xã Mỹ Hiệp, huyện Phù Mỹ, tỉnh Bình Định', '2021-05-24', 7000000, 6, 6, 456),
(367, 'Nguyễn Quốc Huy', '1990-02-05', '437 Xã Vĩnh Trinh Huyện Vĩnh Thạnh Thành Phố Cần Thơhơ', '2021-04-19', 7000000, 3, 3, 333),
(369, 'Võ Văn Trung', '1994-02-23', 'Ấp Mỹ hòa, xã Mỹ hạnh trung, tx cai lậy, tiền giang', '2021-04-19', 7000000, 6, 6, 366),
(380, 'Nguyễn Ngọc Minh', '1997-02-04', '23A, Điện Biên Phủ, phường 15, Bình Thạnh', '2021-05-06', 7000000, 1, 1, 311),
(381, 'Văn Thị Mỹ Ánh My', '1994-01-28', 'Phòng 518 - Tòa AG3 KTX khu A', '2021-05-24', 7000000, 1, 1, 311),
(382, 'Nguyễn Ngọc Tường Vy', '1997-02-05', '276A/15, Hưng Quới, Thanh Đức, Long Hồ, Vĩnh Long', '2021-05-24', 7000000, 1, 1, 311),
(389, 'Bùi Kim Ngân', '1998-07-29', '75A đường D07, ấp An Bình, xã Trung Hòa, huyện Trảng Bom, tỉnh Đồng Nai', '2021-03-02', 7000000, 1, 1, 311),
(421, 'Trương Ngọc Huỳnh Nh', '1994-09-15', 'Ấp Xóm Dinh, xã tân Đông, huyện Gò Công Đông, tỉnh Tiền Giang', '2021-05-24', 10000000, 2, 2, NULL),
(432, 'Lê Văn Vũ', '1996-09-20', '377/24 Cách Mạng Tháng Tám, Phường 12, Quận 10, Tp HCM', '2021-03-02', 10000000, 3, 3, NULL),
(456, 'Bùi Tiến Dũng', '1998-10-19', 'xóm 3, xã nam thanh, huyện nam đàn, tỉnh nghệ an', '2020-02-21', 10000000, 6, 6, NULL),
(467, 'Lê Văn Huỳnh Mai', '1997-07-28', 'số 92, khóm Phước Bình, Phường 2, Thị xã Duyên Hải, tỉnh Trà Vinh', '2021-05-24', 10000000, 4, 4, NULL),
(488, 'Dương Nguyễn Đăng Kh', '1992-08-18', 'Hắc Dịch, thị xã Phú Mỹ, BRVT', '2021-04-19', 10000000, 1, 1, NULL),
(498, 'Lê Văn Tài', '1998-03-17', 'Xã Tịnh Hòa, Thành phố Quảng Ngãi, Tỉnh Quảng Ngãi', '2021-05-06', 10000000, 5, 5, NULL);

--
-- Triggers `employee`
--
DELIMITER $$
CREATE TRIGGER `check_bdate` BEFORE INSERT ON `employee` FOR EACH ROW BEGIN
    IF YEAR(CURDATE()) - YEAR(NEW.bdate) <= 18 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The employee must be over 18 years old.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_start_date` BEFORE INSERT ON `employee` FOR EACH ROW BEGIN
    IF NEW.bdate >= NEW.start_date THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The birth date must be less than the start date.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `supervisor_salary_insert` BEFORE INSERT ON `employee` FOR EACH ROW BEGIN
    DECLARE supervisor_salary INT;
    DECLARE employee_salary INT;

    IF NEW.supervisor_id IS NOT NULL THEN
        SELECT salary INTO supervisor_salary FROM Employee WHERE id = NEW.supervisor_id;
        SELECT salary INTO employee_salary FROM Employee WHERE id = NEW.id;

        IF supervisor_salary <= employee_salary THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Supervisor salary must be higher than the employee''s salary.';
        END IF;
    END IF;

    IF EXISTS (
		SELECT 1 
		FROM Employee 
		WHERE supervisor_id = NEW.id AND salary >= NEW.salary
	) 
	THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Supervisor salary must be higher than the employee''s salary.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `supervisor_salary_update` BEFORE UPDATE ON `employee` FOR EACH ROW BEGIN
    DECLARE supervisor_salary INT;
    DECLARE employee_salary INT;

    IF NEW.supervisor_id IS NOT NULL THEN
        SELECT salary INTO supervisor_salary FROM Employee WHERE id = NEW.supervisor_id;
        SELECT salary INTO employee_salary FROM Employee WHERE id = NEW.id;

        IF supervisor_salary <= employee_salary THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Supervisor salary must be higher than the employee''s salary.';
        END IF;
    END IF;

    IF EXISTS (
		SELECT 1 
		FROM Employee 
		WHERE supervisor_id = NEW.id AND salary >= NEW.salary
	) 
	THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Supervisor salary must be higher than the employee''s salary.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_email`
--

CREATE TABLE `employee_email` (
  `emp_id` int(11) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_email`
--

INSERT INTO `employee_email` (`emp_id`, `email`) VALUES
(106, 'qvinh56888@gmai.com'),
(107, 'thhong7700@gmai.com'),
(109, 'minhnhat599@gmai.com'),
(111, 'yle2908@gmail.com'),
(115, 'haonguyen32344@gmai.com'),
(118, 'qhung212@gmai.com'),
(119, 'ngiabao3414@gmai.com'),
(120, 'thehung12412@gmai.com'),
(122, 'tuyenpham3423@gmail.com'),
(123, 'maivan214@gmail.com'),
(124, 'locle356@gmail.com'),
(125, 'phuongnguyen891@gmail.com'),
(126, 'vangn33@gmail.com'),
(133, 'nhingo341@gmail.com'),
(134, 'tttrung23424@gmail.com'),
(140, 'tringuyen4235@gmai.com'),
(141, 'ht3435@gmai.com'),
(144, 'nhoa213@gmai.com'),
(150, 'thanhtung13235@gmai.com'),
(155, 'maitruong4480@gmai.com'),
(159, 'phucnguyen6795@gmai.com'),
(166, 'uyennguyen4483@gmai.com'),
(167, 'hduc201@gmail.com'),
(170, 'baohung2412@gmai.com'),
(177, 'xinhnguyen467@gmai.com'),
(187, 'xuanmai24234@gmail.com'),
(189, 'ntuan1334@gmail.com'),
(192, 'hoangphuc4578@gmai.com'),
(198, 'nnn2412@gmail.com'),
(199, 'bahung241@gmai.com'),
(202, 'baominh12124@gmai.com'),
(203, 'baomai214124@gmai.com'),
(204, 'dunghuynh4124@gmai.com'),
(205, 'lienle214@gmai.com'),
(207, 'minhle124@gmai.com'),
(209, 'vole32465@gmai.com'),
(210, 'anngo21412@gmai.com'),
(211, 'mainhu5784@gmai.com'),
(219, 'duongtruong214@gmai.com'),
(220, 'giangnguyen2412@gmai.com'),
(222, 'thietphan346@gmai.com'),
(223, 'thucnguyen246@gmai.com'),
(231, 'khahuynh341@gmai.com'),
(233, 'linhnguyen212@gmai.com'),
(234, 'huutrung424@gmai.com'),
(239, 'tienmai1241@gmai.com'),
(240, 'sontruong3414@gmai.com'),
(244, 'tramnguyen2124@gmai.com'),
(245, 'vanvu356@gmai.com'),
(248, 'nngan5584@gmai.com'),
(253, 'ptrung3456@gmai.com'),
(255, 'binhnguyen14124@gmai.com'),
(256, 'annguyen231@gmai.com'),
(261, 'vnhau3441@gmai.com'),
(266, 'nguyentruong24124@gmai.com'),
(267, 'trongtran24214@gmai.com'),
(276, 'minhhieu21412@gmai.com'),
(278, 'anle414@gmai.com'),
(289, 'bahao25467@gmai.com'),
(290, 'anngnguyen34134@gmai.com'),
(308, 'vophuong9453@gmai.com'),
(309, 'tvan2414@gmai.com'),
(310, 'ntuan840@gmai.com'),
(311, 'qdang31410@gmai.com'),
(315, 'vtai353@gmai.com'),
(316, 'htam5657@gmai.com'),
(319, 'vhien467@gmai.com'),
(320, 'hieutam3453@gmai.com'),
(321, 'lamle325@gmai.com'),
(322, 'nhien34325@gmai.com'),
(329, 'vanhuu658@gmai.com'),
(333, 'qtrung0043@gmai.com'),
(341, 'tutrinh834@gmai.com'),
(342, 'duongtle464@gmai.com'),
(344, 'dangkhoa4645@gmai.com'),
(347, 'lainguyen5575@gmai.com'),
(348, 'tamle34723@gmai.com'),
(351, 'ntram4756@gmai.com'),
(355, 'ntrinh6768@gmai.com'),
(356, 'qtrong214@gmai.com'),
(359, 'pthang43546@gmai.com'),
(361, 'mytruong32423@gmai.com'),
(365, 'thimy3534@gmai.com'),
(366, 'minhthu24903@gmai.com'),
(367, 'qhuy5786@gmai.com'),
(369, 'vantrung31423@gmai.com'),
(380, 'nminh12415@gmai.com'),
(381, 'anhmy24124@gmail.com'),
(382, 'tuongvy2412@gmail.com'),
(389, 'nganbui2412@gmail.com'),
(421, 'hnhu56346@gmai.com'),
(432, 'vanvu3423@gmai.com'),
(456, 'tidung94534@gmai.com'),
(467, 'hmai35346@gmai.com'),
(488, 'khoanguyen3235@gmai.com'),
(498, 'vantai35457@gmai.com');

--
-- Triggers `employee_email`
--
DELIMITER $$
CREATE TRIGGER `check_email` BEFORE INSERT ON `employee_email` FOR EACH ROW BEGIN
    IF NOT (NEW.email REGEXP '^[^@]+@[^@]+.[^@]{2,}$') THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The email must be in a valid format.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_phone`
--

CREATE TABLE `employee_phone` (
  `emp_id` int(11) NOT NULL,
  `phone` char(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_phone`
--

INSERT INTO `employee_phone` (`emp_id`, `phone`) VALUES
(0, ''),
(106, '0946325156'),
(107, '0916497258'),
(109, '0975566002'),
(111, '0935346323'),
(115, '0388893112'),
(118, '0916113451'),
(119, '0962331352'),
(120, '0903235261'),
(122, '0963547341'),
(123, '0342352334'),
(124, '0912446273'),
(125, '0965471235'),
(126, '0965431234'),
(133, '0999565412'),
(134, '0957465423'),
(140, '0945724815'),
(141, '0974513235'),
(144, '0389012415'),
(150, '0903432511'),
(155, '0964475632'),
(159, '0381442459'),
(166, '0965378104'),
(167, '0385762533'),
(170, '0962351566'),
(177, '0936323415'),
(187, '0965214351'),
(189, '0955651411'),
(192, '0906321110'),
(198, '0388856435'),
(199, '0963515367'),
(202, '0389654322'),
(203, '0905303144'),
(204, '0387667872'),
(205, '0387677654'),
(207, '0952651135'),
(209, '0967567655'),
(210, '0972312344'),
(211, '0974512857'),
(219, '0957653303'),
(220, '0965412331'),
(222, '0958656414'),
(223, '0389050345'),
(231, '0387873354'),
(233, '0967873433'),
(234, '0926767345'),
(239, '0945676451'),
(240, '0385434567'),
(244, '0987323332'),
(245, '0963471311'),
(248, '0924658348'),
(253, '0956345200'),
(255, '0967876614'),
(256, '0389534520'),
(261, '0389807561'),
(266, '0906550225'),
(267, '0387865654'),
(276, '0900344123'),
(278, '0954574565'),
(289, '0384746250'),
(290, '0942654335'),
(308, '0923523012'),
(309, '0963421435'),
(310, '0906334502'),
(311, '0965323443'),
(315, '0389023621'),
(316, '0984554357'),
(319, '0976345543'),
(320, '0957583143'),
(321, '0965434330'),
(322, '0956765603'),
(329, '0984565214'),
(333, '0943256141'),
(341, '0389002351'),
(342, '0912451235'),
(344, '0963345021'),
(347, '0381842390'),
(348, '0964342420'),
(351, '0924241256'),
(355, '0964578304'),
(356, '0385345023'),
(359, '0987523654'),
(361, '0974640345'),
(365, '0976543352'),
(366, '0097i765236'),
(367, '0389064514'),
(369, '0380543221'),
(380, '0905523032'),
(381, '0956731233'),
(382, '0923563312'),
(389, '0975345633'),
(421, '0998765436'),
(432, '0987654321'),
(456, '0389099521'),
(467, '0973456760'),
(488, '0987654554'),
(498, '0987676346');

-- --------------------------------------------------------

--
-- Table structure for table `manager`
--

CREATE TABLE `manager` (
  `mgr_id` int(11) NOT NULL,
  `mgr_skill` varchar(50) DEFAULT NULL,
  `mgr_qualification` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `manager`
--

INSERT INTO `manager` (`mgr_id`, `mgr_skill`, `mgr_qualification`) VALUES
(421, 'SPHR', '6 năm'),
(432, 'IHRM', '5 năm'),
(456, 'CTMP', '4 năm'),
(467, 'GPHR', '5 năm'),
(488, 'PHR', '7 năm'),
(498, 'CCP', '4 năm');

-- --------------------------------------------------------

--
-- Table structure for table `membership_card`
--

CREATE TABLE `membership_card` (
  `card_id` int(11) NOT NULL,
  `cus_id` int(11) NOT NULL,
  `card_point` int(11) NOT NULL,
  `registration_date` date DEFAULT NULL,
  `card_level` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `membership_card`
--

INSERT INTO `membership_card` (`card_id`, `cus_id`, `card_point`, `registration_date`, `card_level`) VALUES
(1241205, 6367, 33, '2021-03-22', 'Đồng'),
(1241245, 1234, 996, '2021-03-22', 'bạc'),
(1412402, 3667, 2000, '2022-07-31', 'vàng'),
(2352351, 3436, 120000, '2021-01-03', 'kim cương'),
(2353524, 6633, 700, '2021-03-05', 'bạc'),
(2353535, 2536, 55, '2021-03-22', 'Đồng'),
(2456345, 2356, 6000, '2021-03-05', 'vàng'),
(3463402, 4566, 5000, '2022-04-03', 'vàng'),
(3623131, 2145, 3000, '2021-03-05', 'vàng'),
(4352341, 9887, 10700, '2021-03-05', 'bạch kim'),
(5235235, 7457, 7000, '2021-03-05', 'vàng'),
(5345235, 3523, 555, '2023-09-08', 'bạc'),
(5435502, 6473, 15000, '2022-04-03', 'bạch kim'),
(8923124, 1124, 98, '2022-04-03', 'Đồng');

-- --------------------------------------------------------

--
-- Table structure for table `membership_level`
--

CREATE TABLE `membership_level` (
  `level` varchar(10) NOT NULL,
  `benefit` varchar(20) DEFAULT NULL,
  `min_point` int(11) NOT NULL,
  `max_point` int(11) NOT NULL,
  `discount_amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `membership_level`
--

INSERT INTO `membership_level` (`level`, `benefit`, `min_point`, `max_point`, `discount_amount`) VALUES
('bạc', 'giảm giá', 100, 1000, 1),
('bạch kim', 'giảm giá', 10000, 100000, 6),
('kim cương', 'giảm giá', 100000, 1000000, 10),
('vàng', 'giảm giá', 1000, 10000, 3),
('đồng', 'không giảm', 0, 100, 0);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `order_time` datetime DEFAULT NULL,
  `region_id` int(11) DEFAULT NULL,
  `branch_no` int(11) DEFAULT NULL,
  `salesman_id` int(11) DEFAULT NULL,
  `shipper_id` int(11) DEFAULT NULL,
  `dlvr_start` datetime DEFAULT NULL,
  `dlvr_end` datetime DEFAULT NULL,
  `cus_id` int(11) DEFAULT NULL,
  `order_status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_time`, `region_id`, `branch_no`, `salesman_id`, `shipper_id`, `dlvr_start`, `dlvr_end`, `cus_id`, `order_status`) VALUES
(12231, '2023-06-05 00:00:00', 1, 1, 380, 222, '2023-06-06 00:00:00', '2023-06-08 00:00:00', 9887, 'Đã chốt'),
(12302, '2023-04-03 00:00:00', 3, 3, 333, 231, '2023-04-04 00:00:00', '2023-04-06 00:00:00', 4566, 'Đã chốt'),
(12311, '2023-08-05 00:00:00', 3, 3, 309, 234, '2023-08-06 00:00:00', '2023-08-08 00:00:00', 5235, 'Đã chốt'),
(12313, '2023-07-11 00:00:00', 5, 5, 351, 240, '2023-07-12 00:00:00', '2023-07-14 00:00:00', 6367, 'Đang xử lý'),
(12342, '2023-11-07 00:00:00', 3, 3, 309, 239, '2023-11-08 00:00:00', '2023-11-10 00:00:00', 3436, 'Đã chốt'),
(12345, '2023-09-11 00:00:00', 4, 4, 347, 209, '2023-09-12 00:00:00', '2023-09-14 00:00:00', 1124, 'Đang nhập'),
(12347, '2023-09-11 00:00:00', 3, 3, 333, 267, '2023-09-12 00:00:00', '2023-09-14 00:00:00', 1234, 'Đang nhập'),
(12348, '2023-09-05 00:00:00', 4, 4, 342, 220, '2023-09-06 00:00:00', '2023-09-08 00:00:00', 3124, 'Đã chốt'),
(12352, '2023-08-10 00:00:00', 4, 4, 344, 204, '2023-08-11 00:00:00', '2023-08-13 00:00:00', 2536, 'Đã chốt'),
(12389, '2023-08-15 00:00:00', 1, 1, 389, 289, '2023-08-16 00:00:00', '2023-08-18 00:00:00', 2356, 'Đã chốt'),
(12392, '2023-07-14 00:00:00', 2, 2, 322, 223, '2023-07-15 00:00:00', '2023-07-17 00:00:00', 2145, 'Đã chốt'),
(12456, '2023-07-01 00:00:00', 2, 2, 321, 256, '2023-07-02 00:00:00', '2023-07-04 00:00:00', 6633, 'Đã chốt'),
(12923, '2023-09-09 00:00:00', 2, 2, 319, 278, '2023-09-10 00:00:00', '2023-09-12 00:00:00', 7457, 'Đã chốt'),
(13098, '2023-07-07 00:00:00', 5, 5, 329, 210, '2023-07-08 00:00:00', '2023-07-10 00:00:00', 3523, 'Đã chốt'),
(13145, '2023-03-10 00:00:00', 1, 1, 381, 222, '2023-03-11 00:00:00', '2023-03-13 00:00:00', 2352, 'Đã chốt'),
(13456, '2023-08-07 00:00:00', 3, 3, 308, 234, '2023-08-08 00:00:00', '2023-08-10 00:00:00', 3667, 'Đã chốt'),
(29871, '2023-08-08 00:00:00', 1, 1, 382, 289, '2023-08-09 00:00:00', '2023-08-11 00:00:00', 5647, 'Đã chốt'),
(65890, '2023-08-16 00:00:00', 2, 2, 310, 223, '2023-08-17 00:00:00', '2023-08-19 00:00:00', 6473, 'Đã chốt'),
(76545, '2023-08-02 00:00:00', 1, 1, 382, 248, '2023-08-03 00:00:00', '2023-08-05 00:00:00', 2125, 'Đã chốt');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `check_delivery_time` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
    IF NEW.dlvr_start >= NEW.dlvr_end THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The delivery start time must be less than the delivery end time.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_detail`
--

CREATE TABLE `order_detail` (
  `product_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `unit_price` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `promo_amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_detail`
--

INSERT INTO `order_detail` (`product_id`, `order_id`, `unit_price`, `quantity`, `promo_amount`) VALUES
(100341, 12311, 100000, 1, 0),
(109352, 12456, 100000, 1, 1),
(703145, 12302, 250000, 1, 3),
(712421, 12345, 200000, 1, 3),
(723911, 12348, 260000, 1, 0),
(734545, 12352, 200000, 1, 0),
(741124, 12347, 200000, 1, 1),
(790231, 13456, 250000, 1, 3),
(799352, 12342, 250000, 1, 10),
(799395, 12392, 250000, 1, 3),
(882131, 12231, 190000, 1, 6),
(900141, 12313, 320000, 1, 3),
(923431, 76545, 300000, 1, 0),
(941124, 12389, 300000, 1, 3),
(945301, 65890, 300000, 1, 6),
(945344, 13145, 320000, 1, 0),
(954901, 12923, 290000, 1, 3),
(955721, 13098, 290000, 1, 1),
(990832, 29871, 290000, 1, 0);

--
-- Triggers `order_detail`
--
DELIMITER $$
CREATE TRIGGER `order_stock_quantity_insert` BEFORE INSERT ON `order_detail` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT *
		FROM Product AS P
		WHERE NEW.product_id = P.id AND NEW.quantity > P.quantity
	)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Quantity of a product in an order must not exceed its stock quantity';
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `order_stock_quantity_update` BEFORE UPDATE ON `order_detail` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT *
		FROM Product AS P
		WHERE NEW.product_id = P.id AND NEW.quantity > P.quantity
	)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Quantity of a product in an order must not exceed its stock quantity';
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `sup_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(20) NOT NULL,
  `price` int(11) NOT NULL,
  `size` varchar(20) DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL,
  `material` varchar(20) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `sup_id`, `category_id`, `name`, `price`, `size`, `color`, `material`, `quantity`) VALUES
(100231, 0, 10, 'nón beret', 100000, 'M', 'đen', 'da', 60),
(100325, 0, 10, 'nón lưỡi trai', 90000, 'M', 'be', 'cotton', 60),
(100341, 0, 10, 'nón tai bèo', 100000, 'M', 'đen', 'cotton', 60),
(103502, 0, 10, 'nón beret', 100000, 'M', 'be', 'da', 60),
(103911, 0, 10, 'nón tai bèo', 100000, 'M', 'be', 'cotton', 60),
(107341, 0, 10, 'nón lưỡi trai', 90000, 'M', 'đen', 'cotton', 60),
(109352, 0, 10, 'nón beret', 100000, 'M', 'trắng', 'da', 60),
(700141, 7, 77, 'áo sweater mùa đông', 250000, 'S', '?en', 'nỉ lót lớp bông', 120),
(700325, 7, 77, 'áo sơ mi tay dài côn', 260000, 'L', 'trắng', 'cotton lạnh', 120),
(700391, 7, 77, 'áo sweater mùa đông', 250000, 'L', '?en', 'nỉ lót lớp bông', 120),
(703145, 7, 77, 'áo sweater mùa đông', 250000, 'XL', '?en', 'nỉ lót lớp bông', 120),
(703420, 7, 77, 'áo thun mùa hè tay n', 200000, 'M', 'trắng', 'thun lạnh co dãn', 120),
(709341, 7, 77, 'áo thun mùa hè tay n', 200000, 'XL', 'xanh dương', 'thun lạnh co dãn', 120),
(712421, 7, 77, 'áo thun mùa hè tay n', 200000, 'L', 'trắng', 'thun lạnh co dãn', 120),
(723431, 7, 77, 'áo thun mùa hè tay n', 200000, 'L', 'đỏ', 'thun lạnh co dãn', 120),
(723532, 7, 77, 'áo sơ mi tay dài côn', 260000, 'XL', 'xanh dương', 'cotton lạnh', 120),
(723911, 7, 77, 'áo sơ mi tay dài côn', 260000, 'S', 'trắng', 'cotton lạnh', 120),
(724524, 7, 77, 'áo thun mùa hè tay n', 200000, 'XL', 'trắng', 'thun lạnh co dãn', 120),
(725141, 7, 77, 'áo thun mùa hè tay n', 200000, 'S', 'xanh dương', 'thun lạnh co dãn', 120),
(734545, 7, 77, 'áo thun mùa hè tay n', 200000, 'L', 'xanh dương', 'thun lạnh co dãn', 120),
(741124, 7, 77, 'áo thun mùa hè tay n', 200000, 'S', 'đỏ', 'thun lạnh co dãn', 120),
(745253, 7, 77, 'áo sweater mùa đông', 250000, 'L', 'be', 'nỉ lót lớp bông', 120),
(745301, 7, 77, 'áo thun mùa hè tay n', 200000, 'M', 'đỏ', 'thun lạnh co dãn', 120),
(745344, 7, 77, 'áo thun mùa hè tay n', 200000, 'M', 'xanh dương', 'thun lạnh co dãn', 120),
(754312, 7, 77, 'áo thun mùa hè tay n', 200000, 'XL', 'đỏ', 'thun lạnh co dãn', 120),
(754901, 7, 77, 'áo sơ mi tay dài côn', 260000, 'S', 'xanh dương', 'cotton lạnh', 120),
(755721, 7, 77, 'áo sơ mi tay dài côn', 260000, 'M', 'xanh dương', 'cotton lạnh', 120),
(772831, 7, 77, 'áo sweater mùa đông', 250000, 'M', '?en', 'nỉ lót lớp bông', 120),
(777341, 7, 77, 'áo sơ mi tay dài côn', 260000, 'XL', 'trắng', 'cotton lạnh', 120),
(782131, 7, 77, 'áo thun mùa hè tay n', 200000, 'S', 'trắng', 'thun lạnh co dãn', 120),
(790231, 7, 77, 'áo sweater mùa đông', 250000, 'M', 'đỏ', 'nỉ lót lớp bông', 120),
(790341, 7, 77, 'áo sơ mi tay dài côn', 260000, 'M', 'trắng', 'cotton lạnh', 120),
(790832, 7, 77, 'áo sơ mi tay dài côn', 260000, 'L', 'xanh dương', 'cotton lạnh', 120),
(793502, 7, 77, 'áo sweater mùa đông', 250000, 'S', 'đỏ', 'nỉ lót lớp bông', 120),
(793532, 7, 77, 'áo sweater mùa đông', 250000, 'XL', 'đỏ', 'nỉ lót lớp bông', 120),
(799235, 7, 77, 'áo sweater mùa đông', 250000, 'XL', 'be', 'nỉ lót lớp bông', 120),
(799351, 7, 77, 'áo sweater mùa đông', 250000, 'S', 'be', 'nỉ lót lớp bông', 120),
(799352, 7, 77, 'áo sweater mùa đông', 250000, 'L', 'đỏ', 'nỉ lót lớp bông', 120),
(799395, 7, 77, 'áo sweater mùa đông', 250000, 'M', 'be', 'nỉ lót lớp bông', 120),
(801244, 8, 88, 'quần jean ôm dài', 190000, 'S', 'xanh dương', 'jean', 120),
(803420, 8, 88, 'quần thun ống rộng d', 190000, 'XL', 'đen', 'jean', 120),
(806456, 8, 88, 'quần jean ống rộng', 190000, 'S', 'xanh dương', 'jean', 120),
(809341, 8, 88, 'quần jean ôm dài', 190000, 'M', 'xanh dương', 'jean', 120),
(809683, 8, 88, 'quần jean ống rộng', 190000, 'M', 'xanh dương', 'jean', 120),
(812421, 8, 88, 'quần sọt nữ', 100000, 'S', 'đen', 'kaki', 120),
(823431, 8, 88, 'quần thun ống rộng d', 190000, 'S', 'đen', 'jean', 120),
(823532, 8, 88, 'quần sọt nam', 150000, 'M', 'đen', 'kaki', 120),
(823911, 8, 88, 'quần sọt nam', 150000, 'L', 'đen', 'kaki', 120),
(824524, 8, 88, 'quần sọt nữ', 100000, 'M', 'đen', 'kaki', 120),
(825141, 8, 88, 'quần jean ống rộng', 190000, 'L', 'xanh dương', 'jean', 120),
(841124, 8, 88, 'quần jean ôm dài', 190000, 'L', 'xanh dương', 'jean', 120),
(845301, 8, 88, 'quần jean ôm dài', 190000, 'XL', 'xanh dương', 'jean', 120),
(845344, 8, 88, 'quần jean ống rộng', 190000, 'XL', 'xanh dương', 'jean', 120),
(854312, 8, 88, 'quần thun ống rộng d', 190000, 'M', 'đen', 'jean', 120),
(854901, 8, 88, 'quần sọt nữ', 100000, 'L', 'đen', 'kaki', 120),
(855721, 8, 88, 'quần sọt nữ', 100000, 'XL', 'đen', 'kaki', 120),
(882131, 8, 88, 'quần thun ống rộng d', 190000, 'L', 'đen', 'jean', 120),
(890341, 8, 88, 'quần sọt nam', 150000, 'XL', 'đen', 'kaki', 120),
(890832, 8, 88, 'quần sọt nam', 150000, 'S', 'đen', 'kaki', 120),
(900141, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'L', 'trắng', 'cotton lạnh', 60),
(900325, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'S', 'đen', 'cotton lạnh', 60),
(900391, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'S', 'trắng', 'cotton lạnh, voan', 60),
(903145, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'M', 'trắng', 'cotton lạnh, voan', 60),
(903420, 9, 99, 'đầm ngắn ôm body', 290000, 'M', 'đen', 'thun lạnh co dãn', 60),
(906456, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'L', 'trắng', 'cotton lạnh, voan', 60),
(909341, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'XL', 'đỏ', 'cotton lạnh, voan', 60),
(909683, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'XL', 'trắng', 'cotton lạnh, voan', 60),
(912421, 9, 99, 'đầm ngắn ôm body', 290000, 'L', 'đen', 'thun lạnh co dãn', 60),
(923431, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'L', 'hồng', 'cotton lạnh, voan', 60),
(923532, 9, 99, 'đầm ngắn ôm body', 290000, 'XL', 'đỏ', 'thun lạnh co dãn', 60),
(924524, 9, 99, 'đầm ngắn ôm body', 290000, 'XL', 'đen', 'thun lạnh co dãn', 60),
(925141, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'S', 'đỏ', 'cotton lạnh, voan', 60),
(934545, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'L', 'đỏ', 'cotton lạnh, voan', 60),
(941124, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'S', 'hồng', 'cotton lạnh, voan', 60),
(945253, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'S', 'trắng', 'cotton lạnh', 60),
(945301, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'M', 'hồng', 'cotton lạnh, voan', 60),
(945344, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'M', 'đỏ', 'cotton lạnh, voan', 60),
(954312, 9, 99, 'đầm ngắn bồng bềnh', 300000, 'XL', 'hồng', 'cotton lạnh, voan', 60),
(954901, 9, 99, 'đầm ngắn ôm body', 290000, 'S', 'đỏ', 'thun lạnh co dãn', 60),
(955721, 9, 99, 'đầm ngắn ôm body', 290000, 'M', 'đỏ', 'thun lạnh co dãn', 60),
(972831, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'XL', 'trắng', 'cotton lạnh', 60),
(977341, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'M', 'đen', 'cotton lạnh', 60),
(982131, 9, 99, 'đầm ngắn ôm body', 290000, 'S', 'đen', 'thun lạnh co dãn', 60),
(990231, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'XL', 'đen', 'cotton lạnh', 60),
(990832, 9, 99, 'đầm ngắn ôm body', 290000, 'L', 'đỏ', 'thun lạnh co dãn', 60),
(993502, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'L', 'đen', 'cotton lạnh', 60),
(993532, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'M', 'đỏ', 'cotton lạnh', 60),
(999235, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'M', 'trắng', 'cotton lạnh', 60),
(999351, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'L', 'đỏ', 'cotton lạnh', 60),
(999352, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'S', 'đỏ', 'cotton lạnh', 60),
(999395, 9, 99, 'đầm xòe dài dự tiệc', 320000, 'XL', 'đỏ', 'cotton lạnh', 60);

-- --------------------------------------------------------

--
-- Table structure for table `promotion`
--

CREATE TABLE `promotion` (
  `id` int(11) NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `promo_type` char(1) DEFAULT NULL,
  `promo_value` int(11) DEFAULT NULL,
  `descr` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promotion`
--

INSERT INTO `promotion` (`id`, `start_time`, `end_time`, `promo_type`, `promo_value`, `descr`) VALUES
(88888888, '2023-01-12 00:00:00', '2023-12-12 00:00:00', 'd', 3, 'giảm 3% tổng hóa đơn');

--
-- Triggers `promotion`
--
DELIMITER $$
CREATE TRIGGER `check_promotion_date` BEFORE INSERT ON `promotion` FOR EACH ROW BEGIN
    IF NEW.start_time >= NEW.end_time THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The start time must be less than the end time.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `promotion_product`
--

CREATE TABLE `promotion_product` (
  `promo_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promotion_product`
--

INSERT INTO `promotion_product` (`promo_id`, `product_id`) VALUES
(88888888, 712421),
(88888888, 900141);

-- --------------------------------------------------------

--
-- Table structure for table `region`
--

CREATE TABLE `region` (
  `id` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `area` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `region`
--

INSERT INTO `region` (`id`, `name`, `area`) VALUES
(1, 'SailorMoonStore 1', 40.00),
(2, 'SailorMoonStore 2', 40.00),
(3, 'SailorMoonStore 3', 40.00),
(4, 'SailorMoonStore 4', 40.00),
(5, 'SailorMoonStore 5', 40.00),
(6, 'SailorMoonStore 6', 40.00);

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `id` int(11) NOT NULL,
  `cus_id` int(11) NOT NULL,
  `pro_id` int(11) NOT NULL,
  `time` datetime NOT NULL,
  `content` varchar(255) NOT NULL,
  `rating` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`id`, `cus_id`, `pro_id`, `time`, `content`, `rating`) VALUES
(12231, 9887, 882131, '2023-08-06 00:00:00', 'giao nhanh, shiper thân thiện, gói kĩ', 5),
(12311, 5235, 100341, '2023-08-08 00:00:00', 'hàng chất lượng, đúng màu', 5),
(12342, 3436, 799352, '2023-10-14 00:00:00', 'shop tứ vấn đúng size, giao đúng màu', 5),
(12348, 3124, 723911, '2023-08-15 00:00:00', 'giao nhanh, vừa size, đúng màu', 5),
(12352, 2536, 734545, '2023-08-13 00:00:00', 'shop 10 điểm,chưa thử, để đánh giá lại sau', 4),
(12389, 2356, 941124, '2023-08-21 00:00:00', 'shop tư vấn đúng size, giao đúng màu', 5),
(12392, 2145, 799395, '2023-07-23 00:00:00', 'shop tư vấn nhiệt tình, hàng như hình', 5),
(12456, 6633, 109352, '2023-04-09 00:00:00', 'giao đúng màu, nhanh, đủ', 5),
(13098, 3523, 955721, '2023-10-07 00:00:00', 'giao nhanh, shiper thân thiện, gói kĩ', 5),
(13145, 2352, 945344, '2023-03-13 00:00:00', 'giao nhanh, vừa size, đúng màu', 5),
(13456, 3667, 790231, '2023-10-19 00:00:00', 'shop tư vấn nhiệt tình, tuy nhiên trả lời hơi lâu', 4),
(65890, 6473, 945301, '2023-08-19 00:00:00', 'hàng chất lượng, đúng màu', 5),
(76545, 2125, 923431, '2023-05-10 00:00:00', 'giao đúng màu, nhanh, đủ', 5);

--
-- Triggers `review`
--
DELIMITER $$
CREATE TRIGGER `review_product_insert` BEFORE INSERT ON `review` FOR EACH ROW BEGIN
	IF NOT EXISTS (
		SELECT * 
		FROM Bill AS B 
			JOIN Orders AS O ON B.order_id = O.id
			JOIN Order_Detail AS OD ON OD.order_id = O.id 
		WHERE NEW.pro_id = OD.product_id
	)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Customers cannot write a review on a product before purchasing it';
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `review_product_update` BEFORE UPDATE ON `review` FOR EACH ROW BEGIN
	IF NOT EXISTS (
		SELECT * 
		FROM Bill AS B 
			JOIN Orders AS O ON B.order_id = O.id
			JOIN Order_Detail AS OD ON OD.order_id = O.id 
		WHERE NEW.pro_id = OD.product_id
	)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Customers cannot write a review on a product before purchasing it';
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `salesman`
--

CREATE TABLE `salesman` (
  `salesman_id` int(11) NOT NULL,
  `salesman_mktg_skill` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `salesman`
--

INSERT INTO `salesman` (`salesman_id`, `salesman_mktg_skill`) VALUES
(308, 'Chứng chỉ Digital Marketing OMCP'),
(309, 'Chứng chỉ Digital Marketing LinkedIn'),
(310, 'Chứng ch?ỉ Digital Marketing Specialization Course'),
(311, 'Chứng chỉ Digital Marketing PCM'),
(315, 'Chứng chỉ Google Digital Garage'),
(319, 'Chứng chỉ Digital Marketing PCM'),
(321, 'Chứng chỉ Digital Marketing Specialist SimpliLearn'),
(322, 'Chứng chỉ Google Digital Garage'),
(333, 'Chứng chỉ Digital Marketing Quốc tế CDMP'),
(341, 'Chứng chỉ Digital Marketing OMCP'),
(342, 'Chứng chỉ Digital Marketing PCM'),
(344, 'Chứng ch?ỉ Digital Marketing Specialization Course'),
(347, 'Chứng chỉ Digital Marketing của BrainStation'),
(348, 'Chứng chỉ Digital Marketing Quốc tế CDMP'),
(351, 'Chứng chỉ Google Digital Garage'),
(355, 'Chứng chỉ Digital Marketing LinkedIn'),
(356, 'Chứng chỉ Digital Marketing của BrainStation'),
(367, 'Chứng chỉ Digital Marketing Specialist SimpliLearn'),
(380, 'Chứng chỉ Digital Marketing của BrainStation'),
(381, 'Chứng chỉ Digital Marketing OMCP'),
(382, 'Chứng chỉ Digital Marketing LinkedIn'),
(389, 'Chứng chỉ Digital Marketing Quốc tế CDMP');

-- --------------------------------------------------------

--
-- Table structure for table `shipper`
--

CREATE TABLE `shipper` (
  `shipper_id` int(11) NOT NULL,
  `driver_license` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shipper`
--

INSERT INTO `shipper` (`shipper_id`, `driver_license`) VALUES
(202, '1'),
(203, '1'),
(204, '1'),
(205, '2'),
(207, '2'),
(209, '2'),
(210, '1'),
(211, '1'),
(219, '2'),
(220, '1'),
(222, '2'),
(223, '1'),
(231, '1'),
(233, '1'),
(234, '1'),
(239, '2'),
(240, '2'),
(244, '2'),
(245, '2'),
(248, '2'),
(253, '2'),
(255, '1'),
(256, '1'),
(261, '2'),
(266, '2'),
(267, '2'),
(276, '2'),
(278, '1'),
(289, '2'),
(290, '2');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(13) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`id`, `name`, `address`, `phone`) VALUES
(7, 'Công ty cổ phần Dệt ', 'òa nhà Nam Hải LakeView (Tầng 8) Lô 9A, KĐT Vĩnh Hoàng, Hoàng Văn Thụ, Hoàng Mai, Hà Nội', '0900213445'),
(8, 'Công Ty Cổ Phần May ', '13A Tống Văn Trân, Phường 5, Quận 11 Thành Phố Hồ Chí Minh', '0989891234'),
(9, 'Xưởng may An Phát', '54/57/3 Đường Tân Thới Hiệp 29, Tân Thới Hiệp, Quận 12, Thành phố Hồ Chí Minh', '0900678900'),
(10, 'Cơ Sở Sản Xuất Mũ Nó', '14/47 Tổ 5 - KP3, Khu Phố 2a, Quận 12, Thành phố Hồ Chí Minh', '0902030405');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accountant`
--
ALTER TABLE `accountant`
  ADD PRIMARY KEY (`acct_id`);

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_bill_order` (`order_id`),
  ADD KEY `fk_bill_accountant` (`acct_id`);

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`region_id`,`number`),
  ADD KEY `fk_branch_manager` (`mgr_id`);

--
-- Indexes for table `branch_product`
--
ALTER TABLE `branch_product`
  ADD PRIMARY KEY (`region_id`,`branch_no`,`product_id`),
  ADD KEY `fk_brpro_product` (`product_id`);

--
-- Indexes for table `branch_supplier`
--
ALTER TABLE `branch_supplier`
  ADD PRIMARY KEY (`region_id`,`branch_no`,`sup_id`),
  ADD KEY `fk_brsup_supplier` (`sup_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD PRIMARY KEY (`cus_id`,`address_street`,`address_district`,`address_city`);

--
-- Indexes for table `customer_email`
--
ALTER TABLE `customer_email`
  ADD PRIMARY KEY (`cus_id`,`email`);

--
-- Indexes for table `customer_phone`
--
ALTER TABLE `customer_phone`
  ADD PRIMARY KEY (`cus_id`,`phone`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_emp_region_branch` (`region_id`,`branch_no`),
  ADD KEY `fk_emp_super` (`supervisor_id`);

--
-- Indexes for table `employee_email`
--
ALTER TABLE `employee_email`
  ADD PRIMARY KEY (`emp_id`,`email`);

--
-- Indexes for table `employee_phone`
--
ALTER TABLE `employee_phone`
  ADD PRIMARY KEY (`emp_id`,`phone`);

--
-- Indexes for table `manager`
--
ALTER TABLE `manager`
  ADD PRIMARY KEY (`mgr_id`);

--
-- Indexes for table `membership_card`
--
ALTER TABLE `membership_card`
  ADD PRIMARY KEY (`card_id`),
  ADD KEY `fk_memcard_cus` (`cus_id`),
  ADD KEY `fk_memcard_level` (`card_level`);

--
-- Indexes for table `membership_level`
--
ALTER TABLE `membership_level`
  ADD PRIMARY KEY (`level`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_order_branch` (`region_id`,`branch_no`),
  ADD KEY `fk_order_saleman` (`salesman_id`),
  ADD KEY `fk_order_shipper` (`shipper_id`),
  ADD KEY `fk_order_customer` (`cus_id`);

--
-- Indexes for table `order_detail`
--
ALTER TABLE `order_detail`
  ADD PRIMARY KEY (`product_id`,`order_id`),
  ADD KEY `fk_odetail_order` (`order_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pro_supplier` (`sup_id`),
  ADD KEY `fk_pro_category` (`category_id`);

--
-- Indexes for table `promotion`
--
ALTER TABLE `promotion`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `promotion_product`
--
ALTER TABLE `promotion_product`
  ADD PRIMARY KEY (`promo_id`,`product_id`),
  ADD KEY `fk_promprod_product` (`product_id`);

--
-- Indexes for table `region`
--
ALTER TABLE `region`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_review_cus` (`cus_id`),
  ADD KEY `fk_review_pro` (`pro_id`);

--
-- Indexes for table `salesman`
--
ALTER TABLE `salesman`
  ADD PRIMARY KEY (`salesman_id`);

--
-- Indexes for table `shipper`
--
ALTER TABLE `shipper`
  ADD PRIMARY KEY (`shipper_id`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bill`
--
ALTER TABLE `bill`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76546;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9888;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=499;

--
-- AUTO_INCREMENT for table `membership_card`
--
ALTER TABLE `membership_card`
  MODIFY `card_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8923125;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76546;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=999396;

--
-- AUTO_INCREMENT for table `promotion`
--
ALTER TABLE `promotion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88888889;

--
-- AUTO_INCREMENT for table `region`
--
ALTER TABLE `region`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76546;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accountant`
--
ALTER TABLE `accountant`
  ADD CONSTRAINT `fk_emp_acct_id` FOREIGN KEY (`acct_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `fk_bill_accountant` FOREIGN KEY (`acct_id`) REFERENCES `accountant` (`acct_id`),
  ADD CONSTRAINT `fk_bill_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `branch`
--
ALTER TABLE `branch`
  ADD CONSTRAINT `fk_branch_manager` FOREIGN KEY (`mgr_id`) REFERENCES `manager` (`mgr_id`),
  ADD CONSTRAINT `fk_branch_region` FOREIGN KEY (`region_id`) REFERENCES `region` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `branch_product`
--
ALTER TABLE `branch_product`
  ADD CONSTRAINT `fk_brpro_branch` FOREIGN KEY (`region_id`,`branch_no`) REFERENCES `branch` (`region_id`, `number`),
  ADD CONSTRAINT `fk_brpro_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `branch_supplier`
--
ALTER TABLE `branch_supplier`
  ADD CONSTRAINT `fk_brsup_branch` FOREIGN KEY (`region_id`,`branch_no`) REFERENCES `branch` (`region_id`, `number`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_brsup_supplier` FOREIGN KEY (`sup_id`) REFERENCES `supplier` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD CONSTRAINT `fk_cus_address` FOREIGN KEY (`cus_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customer_email`
--
ALTER TABLE `customer_email`
  ADD CONSTRAINT `fk_cus_email` FOREIGN KEY (`cus_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customer_phone`
--
ALTER TABLE `customer_phone`
  ADD CONSTRAINT `fk_cus_phone` FOREIGN KEY (`cus_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `fk_emp_region_branch` FOREIGN KEY (`region_id`,`branch_no`) REFERENCES `branch` (`region_id`, `number`),
  ADD CONSTRAINT `fk_emp_super` FOREIGN KEY (`supervisor_id`) REFERENCES `employee` (`id`);

--
-- Constraints for table `employee_email`
--
ALTER TABLE `employee_email`
  ADD CONSTRAINT `fk_emp_email_id` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `employee_phone`
--
ALTER TABLE `employee_phone`
  ADD CONSTRAINT `fk_emp_phone_id` FOREIGN KEY (`emp_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `manager`
--
ALTER TABLE `manager`
  ADD CONSTRAINT `fk_emp_mgr_id` FOREIGN KEY (`mgr_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `membership_card`
--
ALTER TABLE `membership_card`
  ADD CONSTRAINT `fk_memcard_cus` FOREIGN KEY (`cus_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_memcard_level` FOREIGN KEY (`card_level`) REFERENCES `membership_level` (`level`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_order_branch` FOREIGN KEY (`region_id`,`branch_no`) REFERENCES `branch` (`region_id`, `number`),
  ADD CONSTRAINT `fk_order_customer` FOREIGN KEY (`cus_id`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `fk_order_saleman` FOREIGN KEY (`salesman_id`) REFERENCES `salesman` (`salesman_id`),
  ADD CONSTRAINT `fk_order_shipper` FOREIGN KEY (`shipper_id`) REFERENCES `shipper` (`shipper_id`);

--
-- Constraints for table `order_detail`
--
ALTER TABLE `order_detail`
  ADD CONSTRAINT `fk_odetail_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_odetail_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `fk_pro_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  ADD CONSTRAINT `fk_pro_supplier` FOREIGN KEY (`sup_id`) REFERENCES `supplier` (`id`);

--
-- Constraints for table `promotion_product`
--
ALTER TABLE `promotion_product`
  ADD CONSTRAINT `fk_promprod_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `fk_promprod_promotion` FOREIGN KEY (`promo_id`) REFERENCES `promotion` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `fk_review_cus` FOREIGN KEY (`cus_id`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `fk_review_pro` FOREIGN KEY (`pro_id`) REFERENCES `product` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `salesman`
--
ALTER TABLE `salesman`
  ADD CONSTRAINT `fk_emp_salesman_id` FOREIGN KEY (`salesman_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shipper`
--
ALTER TABLE `shipper`
  ADD CONSTRAINT `fk_emp_shipper_id` FOREIGN KEY (`shipper_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
