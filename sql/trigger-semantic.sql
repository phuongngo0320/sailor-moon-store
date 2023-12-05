-- USE SailorMoonStore;
DROP TRIGGER IF EXISTS supervisor_salary;
DROP TRIGGER IF EXISTS review_product;
DROP TRIGGER IF EXISTS order_stock_quantity;
--------------------------------------------------------------------------

------------------ SEMANTIC CONSTRAINTS ----------------------
-- GO
-- CREATE TRIGGER supervisor_salary
-- ON Employee 
-- AFTER INSERT, UPDATE
-- AS 
-- BEGIN 
-- 	IF EXISTS (
-- 		SELECT *
-- 		FROM INSERTED AS I
-- 			JOIN Employee AS E ON I.supervisor_id = E.id
-- 		WHERE (I.supervisor_id IS NOT NULL) AND (I.salary > E.salary)
-- 	)
-- 	BEGIN 
-- 		RAISERROR('Supervisor salary must be higher than the employee''s salary.', 16, 1);
-- 		ROLLBACK;
-- 	END
-- 	ELSE 
-- 	BEGIN 
-- 		IF EXISTS (
-- 			SELECT * 
-- 			FROM INSERTED AS I 
-- 				JOIN Employee AS E ON I.id = E.supervisor_id
-- 			WHERE (E.supervisor_id IS NOT NULL) AND (E.salary > I.salary)
-- 		)
-- 		BEGIN 
-- 			RAISERROR('Supervisor salary must be higher than the employee''s salary.', 16, 1);
-- 			ROLLBACK;
-- 		END
-- 	END
-- END

DELIMITER $$
CREATE TRIGGER supervisor_salary_insert
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
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
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER supervisor_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
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
END $$
DELIMITER ;

-- GO 
-- CREATE TRIGGER review_product
-- ON Review
-- AFTER INSERT, UPDATE
-- AS 
-- BEGIN
-- 	IF NOT EXISTS (
-- 		SELECT * 
-- 		FROM Bill as B 
-- 			JOIN Orders AS O ON B.order_id = O.id
-- 			JOIN Order_Detail AS OD ON OD.order_id = O.id 
-- 			JOIN INSERTED AS I ON I.pro_id = OD.product_id
-- 	)
-- 	BEGIN 
-- 		RAISERROR('Customers cannot write a review on a product before purchasing it', 16, 1);
-- 		ROLLBACK;
-- 	END 
-- END

DELIMITER $$ 
CREATE TRIGGER review_product_insert
	BEFORE INSERT ON Review
	FOR EACH ROW
BEGIN
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
END $$
DELIMITER ;

DELIMITER $$ 
CREATE TRIGGER review_product_update
	BEFORE UPDATE ON Review
	FOR EACH ROW
BEGIN
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
END $$
DELIMITER ;

-- GO
-- CREATE TRIGGER order_stock_quantity
-- ON Order_Detail 
-- AFTER INSERT, UPDATE
-- AS 
-- BEGIN
-- 	IF EXISTS (
-- 		SELECT *
-- 		FROM INSERTED AS I
-- 			JOIN Product AS P ON I.product_id = P.id
-- 		WHERE I.quantity > P.quantity
-- 	)
-- 	BEGIN 
-- 		RAISERROR('Quantity of a product in an order must not exceed its stock quantity', 16, 1);
-- 		ROLLBACK;
-- 	END 	
-- END

DELIMITER $$
CREATE TRIGGER order_stock_quantity_insert
	BEFORE INSERT ON Order_Detail
	FOR EACH ROW 
BEGIN
	IF EXISTS (
		SELECT *
		FROM Product AS P
		WHERE NEW.product_id = P.id AND NEW.quantity > P.quantity
	)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Quantity of a product in an order must not exceed its stock quantity';
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER order_stock_quantity_update
	BEFORE UPDATE ON Order_Detail
	FOR EACH ROW 
BEGIN
	IF EXISTS (
		SELECT *
		FROM Product AS P
		WHERE NEW.product_id = P.id AND NEW.quantity > P.quantity
	)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Quantity of a product in an order must not exceed its stock quantity';
	END IF;
END $$
DELIMITER ;