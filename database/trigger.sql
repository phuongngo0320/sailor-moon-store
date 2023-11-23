USE SailorMoonStore;
DROP TRIGGER IF EXISTS supervisor_salary;
DROP TRIGGER IF EXISTS review_product;
DROP TRIGGER IF EXISTS order_stock_quantity;
--------------------------------------------------------------------------

------------------ SEMANTIC CONSTRAINTS ----------------------
GO
CREATE TRIGGER supervisor_salary
ON Employee 
AFTER INSERT, UPDATE
AS 
BEGIN 
	IF EXISTS (
		SELECT *
		FROM INSERTED AS I
			JOIN Employee AS E ON I.supervisor_id = E.id
		WHERE (I.supervisor_id IS NOT NULL) AND (I.salary > E.salary)
	)
	BEGIN 
		RAISERROR('Supervisor salary must be higher than the employee''s salary.', 16, 1);
		ROLLBACK;
	END
	ELSE 
	BEGIN 
		IF EXISTS (
			SELECT * 
			FROM INSERTED AS I 
				JOIN Employee AS E ON I.id = E.supervisor_id
			WHERE (E.supervisor_id IS NOT NULL) AND (E.salary > I.salary)
		)
		BEGIN 
			RAISERROR('Supervisor salary must be higher than the employee''s salary.', 16, 1);
			ROLLBACK;
		END
	END
END

GO 
CREATE TRIGGER review_product
ON Review
AFTER INSERT, UPDATE
AS 
BEGIN
	IF NOT EXISTS (
		SELECT * 
		FROM Bill as B 
			JOIN Orders AS O ON B.order_id = O.id
			JOIN Order_Detail AS OD ON OD.order_id = O.id 
			JOIN INSERTED AS I ON I.pro_id = OD.product_id
	)
	BEGIN 
		RAISERROR('Customers cannot write a review on a product before purchasing it', 16, 1);
		ROLLBACK;
	END 
END

GO
CREATE TRIGGER order_stock_quantity
ON Order_Detail 
AFTER INSERT, UPDATE
AS 
BEGIN
	IF EXISTS (
		SELECT *
		FROM INSERTED AS I
			JOIN Product AS P ON I.product_id = P.id
		WHERE I.quantity > P.quantity
	)
	BEGIN 
		RAISERROR('Quantity of a product in an order must not exceed its stock quantity', 16, 1);
		ROLLBACK;
	END 	
END