-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Dec 04, 2023 at 07:26 AM
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
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `BranchAverageRating` (`branch_no` INT, `year_` INT) RETURNS DECIMAL(10,1)  BEGIN 
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
        B.number = branch_no;

    RETURN (avgRating);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `BranchRevenue` (`branch_no` INT, `year_` INT) RETURNS INT(11)  BEGIN 
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
        B.number = branch_no;

    SELECT SUM(Bill.dlvr_fee)
    INTO sum_dlvr_fee
    FROM Bill
        JOIN Orders AS O ON O.id = Bill.order_id
        JOIN Branch AS B ON O.branch_no = B.number 
    WHERE 
        DATE(Bill.issue_time) >= MAKEDATE(year_, 1) AND 
        DATE(Bill.issue_time) < MAKEDATE(year_ + 1, 1) AND 
        B.number = branch_no;

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
(1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
(1, 1, NULL, 'Ba Đình', '297D Kim Mã, Q. Ba Đình, Hà Nội', '0938233048'),
(1, 2, NULL, 'Hoàn Kiếm', '57 Hàng Trống, Q. Hoàn Kiếm, Hà Nội', '0938285579'),
(1, 3, NULL, 'Hai Bà Trưng', '13 Bùi Thị Xuân, Q. Hai Bà Trưng, Hà Nội', '0938226764'),
(2, 1, NULL, 'Hải Châu', 'K408/88 Hoàng Diệu, Phường Bình Thuận, Quận Hải Ch', '0982740888'),
(2, 2, NULL, 'Thanh Khê', 'K5/9 Nguyễn Văn Huề, Phường Thanh Khê Tây, Quận Th', '0970724112'),
(3, 1, NULL, 'Thủ Đức', '462 Nguyễn Thị Định, Phường Thạnh Mỹ Lợi, Thành ph', '0939601901'),
(3, 2, NULL, 'hcm2', NULL, NULL),
(3, 3, NULL, 'hcm3', NULL, NULL),
(3, 4, NULL, 'hcm4', NULL, NULL);

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
(1, 3, 3),
(1, 3, 4),
(1, 3, 5),
(3, 1, 1),
(3, 1, 2),
(3, 1, 4);

-- --------------------------------------------------------

--
-- Table structure for table `branch_supplier`
--

CREATE TABLE `branch_supplier` (
  `region_id` int(11) NOT NULL,
  `branch_no` int(11) NOT NULL,
  `sup_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `descr` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 'Ngô Văn Phương');

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

-- --------------------------------------------------------

--
-- Table structure for table `customer_email`
--

CREATE TABLE `customer_email` (
  `cus_id` int(11) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 'AAA', '2002-12-04', 'eaweqwe', '2023-12-01', 1, NULL, NULL, NULL);

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
(1, 'a123@123...'),
(1, 'a123@123.d');

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

-- --------------------------------------------------------

--
-- Table structure for table `manager`
--

CREATE TABLE `manager` (
  `mgr_id` int(11) NOT NULL,
  `mgr_skill` varchar(50) DEFAULT NULL,
  `mgr_qualification` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, NULL, 1, 3, NULL, NULL, NULL, NULL, 1, NULL),
(2, NULL, 1, 3, NULL, NULL, NULL, NULL, 1, NULL),
(3, NULL, 1, 3, NULL, NULL, NULL, NULL, 1, NULL),
(4, NULL, 3, 1, NULL, NULL, NULL, NULL, 1, NULL),
(5, NULL, 3, 1, NULL, NULL, NULL, NULL, 1, NULL);

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
(1, 4, 0, 1, 0),
(2, 5, 0, 1, 0),
(3, 1, 0, 1, 0),
(4, 2, 0, 1, 0),
(5, 3, 0, 1, 0);

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
(1, NULL, NULL, 'Quần suông thun tăm', 52000, 'FREESIZE', 'vàng', 'tăm', 20),
(2, NULL, NULL, 'QUẦN BAGGY JEAN NAM', 82849, '34', 'XANH', 'jean cotton', 10),
(3, NULL, NULL, 'Áo Polo Nam Cao Cấp ', 95000, 'XL', 'tím than', 'thun', 12),
(4, NULL, NULL, 'Women Pleated Should', 92000, NULL, 'black', 'cotton', 2),
(5, NULL, NULL, 'Áo Khoác Cadigan', 57000, 'M', 'XÁM', 'NỈ BÔNG', 76);

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
(1, 'Hà Nội', 3360.00),
(2, 'Đà Nẵng', 1285.00),
(3, 'Hồ Chí Minh', 2095.00);

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
(1, 1, 2, '2023-12-04 07:22:49', 'Quần đẹp', 4),
(2, 1, 1, '2023-12-04 07:22:49', 'Hàng chất lượng', 5),
(3, 1, 3, '2023-12-04 07:22:49', 'Áo mặc hơi nóng', 2),
(4, 1, 4, '2023-12-04 07:22:49', 'Túi quá nhỏ', 1),
(5, 1, 5, '2023-12-04 07:22:49', 'Tạm được', 3);

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

-- --------------------------------------------------------

--
-- Table structure for table `shipper`
--

CREATE TABLE `shipper` (
  `shipper_id` int(11) NOT NULL,
  `driver_license` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `membership_card`
--
ALTER TABLE `membership_card`
  MODIFY `card_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `promotion`
--
ALTER TABLE `promotion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `region`
--
ALTER TABLE `region`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
