-- DELIMITER $$ 
-- CREATE FUNCTION BranchRevenue(
--     region_id INT,
--     branch_no INT,
--     year_ INT
-- )
-- RETURNS INT 
-- BEGIN 
--     DECLARE sum_order_price INT;
--     DECLARE sum_dlvr_fee INT; 

--     IF NOT EXISTS (
--         SELECT * 
--         FROM Branch AS B 
--         WHERE B.region_id = region_id AND B.number = branch_no
--     ) THEN 
--         SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'This branch does not exists';
--     END IF;

--     SELECT SUM(OD.unit_price * OD.quantity * (100 - OD.promo_amount) / 100)
--     INTO sum_order_price 
--     FROM Bill
--         JOIN Orders AS O ON O.id = Bill.order_id
--         JOIN Order_Detail AS OD ON OD.order_id = O.id
--         JOIN Product AS P ON OD.product_id = P.id 
--         JOIN Branch AS B ON O.branch_no = B.number 
--     WHERE 
--         DATE(Bill.issue_time) >= MAKEDATE(year_, 1) AND 
--         DATE(Bill.issue_time) < MAKEDATE(year_ + 1, 1) AND 
--         B.number = branch_no AND 
--         B.region_id = region_id;

--     SELECT SUM(Bill.dlvr_fee)
--     INTO sum_dlvr_fee
--     FROM Bill
--         JOIN Orders AS O ON O.id = Bill.order_id
--         JOIN Branch AS B ON O.branch_no = B.number 
--     WHERE 
--         DATE(Bill.issue_time) >= MAKEDATE(year_, 1) AND 
--         DATE(Bill.issue_time) < MAKEDATE(year_ + 1, 1) AND 
--         B.number = branch_no AND 
--         B.region_id = region_id;

--     RETURN sum_order_price + sum_dlvr_fee;
-- END $$
-- DELIMITER ;

-- DELIMITER $$
-- CREATE FUNCTION BranchAverageRating(
--     region_id INT,
--     branch_no INT,
--     year_ INT
-- ) 
-- RETURNS DECIMAL(10,1)
-- BEGIN 
--     DECLARE avgRating DECIMAL(10, 1);

--     IF NOT EXISTS (
--         SELECT * 
--         FROM Branch AS B 
--         WHERE B.region_id = region_id AND B.number = branch_no
--     ) THEN 
--         SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'This branch does not exists';
--     END IF;

--     SELECT AVG(R.rating)
--     INTO avgRating 
--     FROM Review AS R 
--         JOIN Product AS P ON R.pro_id = P.id 
--         JOIN Branch_Product AS BP ON BP.product_id = P.id
--         JOIN Branch AS B ON BP.branch_no = B.number
--     WHERE 
--         DATE(R.time) >= MAKEDATE(year_, 1) AND 
--         DATE(R.time) < MAKEDATE(year_ + 1, 1) AND 
--         B.number = branch_no AND 
--         B.region_id = region_id;

--     RETURN (avgRating);
-- END $$ 
-- DELIMITER ;

























-- update: using LOOP/CURSOR

DROP FUNCTION IF EXISTS BranchRevenue;
DELIMITER $$ 
CREATE FUNCTION BranchRevenue(
    region_id INT,
    branch_no INT,
    year_ INT
)
RETURNS INT 
BEGIN 
    DECLARE sum_order_price INT;
    DECLARE sum_dlvr_fee INT;
    DECLARE total_order_price INT;
    DECLARE total_dlvr_fee INT;
    
    DECLARE done INT DEFAULT FALSE;
    DECLARE order_price_cursor CURSOR FOR SELECT order_price FROM TempOrderPrice;
    DECLARE dlvr_fee_cursor CURSOR FOR SELECT dlvr_fee FROM TempDlvrFee;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    IF NOT EXISTS (
        SELECT * 
        FROM Branch AS B 
        WHERE B.region_id = region_id AND B.number = branch_no
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This branch does not exists';
    END IF;

    -- Initialize variables
    SET sum_order_price = 0;
    SET sum_dlvr_fee = 0;

    -- Loop through orders to calculate order price
    CREATE TEMPORARY TABLE TempOrderPrice (
        order_price INT
    );

    INSERT INTO TempOrderPrice (order_price)
    SELECT OD.unit_price * OD.quantity * (100 - OD.promo_amount) / 100
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

    OPEN order_price_cursor;

    read_order_price:LOOP
        FETCH order_price_cursor INTO total_order_price;

        IF done THEN
            LEAVE read_order_price;
        END IF;

        SET sum_order_price = sum_order_price + total_order_price;
    END LOOP;

    CLOSE order_price_cursor;

	SET done = false;
    -- Loop through orders to calculate delivery fee
    CREATE TEMPORARY TABLE TempDlvrFee (
        dlvr_fee INT
    );

    INSERT INTO TempDlvrFee (dlvr_fee)
    SELECT Bill.dlvr_fee
    FROM Bill
        JOIN Orders AS O ON O.id = Bill.order_id
        JOIN Branch AS B ON O.branch_no = B.number 
    WHERE 
        DATE(Bill.issue_time) >= MAKEDATE(year_, 1) AND 
        DATE(Bill.issue_time) < MAKEDATE(year_ + 1, 1) AND 
        B.number = branch_no AND 
        B.region_id = region_id;

    OPEN dlvr_fee_cursor;

    read_dlvr_fee: LOOP
        FETCH dlvr_fee_cursor INTO total_dlvr_fee;

        IF done THEN
            LEAVE read_dlvr_fee;
        END IF;

        SET sum_dlvr_fee = sum_dlvr_fee + total_dlvr_fee;
    END LOOP;

    CLOSE dlvr_fee_cursor;

    -- Drop temporary tables
    DROP TEMPORARY TABLE IF EXISTS TempOrderPrice;
    DROP TEMPORARY TABLE IF EXISTS TempDlvrFee;

    RETURN sum_order_price + sum_dlvr_fee;
END $$
DELIMITER ;














DROP FUNCTION IF EXISTS BranchAverageRating;
DELIMITER $$
CREATE FUNCTION BranchAverageRating(
    region_id INT,
    branch_no INT,
    year_ INT
) 
RETURNS DECIMAL(10,1)
BEGIN 
    DECLARE totalRating DECIMAL(10, 1);
    DECLARE ratingCount INT;
    DECLARE avgRating DECIMAL(10, 1);
    
    DECLARE done INT DEFAULT FALSE;
    DECLARE review_rating_cursor CURSOR FOR SELECT review_rating FROM TempReviewRating;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    IF NOT EXISTS (
        SELECT * 
        FROM Branch AS B 
        WHERE B.region_id = region_id AND B.number = branch_no
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This branch does not exists';
    END IF;

    SET totalRating = 0;
    SET ratingCount = 0;

    CREATE TEMPORARY TABLE TempReviewRating (
        review_rating DECIMAL(10, 1)
    );

    INSERT INTO TempReviewRating (review_rating)
    SELECT R.rating
    FROM Review AS R 
        JOIN Product AS P ON R.pro_id = P.id 
        JOIN Branch_Product AS BP ON BP.product_id = P.id
        JOIN Branch AS B ON BP.branch_no = B.number
    WHERE 
        DATE(R.time) >= MAKEDATE(year_, 1) AND 
        DATE(R.time) < MAKEDATE(year_ + 1, 1) AND 
        B.number = branch_no AND 
        B.region_id = region_id;

    OPEN review_rating_cursor;

    read_review_rating:LOOP
        FETCH review_rating_cursor INTO avgRating;

        IF done THEN
            LEAVE read_review_rating;
        END IF;

        SET totalRating = totalRating + avgRating;
        SET ratingCount = ratingCount + 1;
    END LOOP;

    CLOSE review_rating_cursor;

    -- calculate average rating
    IF ratingCount > 0 THEN
        SET avgRating = totalRating / ratingCount;
    ELSE
        SET avgRating = 0; -- set default value if there are no ratings
    END IF;

    DROP TEMPORARY TABLE IF EXISTS TempReviewRating;

    RETURN avgRating;
END $$ 
DELIMITER ;