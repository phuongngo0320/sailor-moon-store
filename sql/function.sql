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
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION BranchAverageRating(
    region_id INT,
    branch_no INT,
    year_ INT
) 
RETURNS DECIMAL(10,1)
BEGIN 
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
END $$ 
DELIMITER ;