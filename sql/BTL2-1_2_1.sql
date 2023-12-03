DELIMITER //
-- MySQL syntax
DROP PROCEDURE IF EXISTS insert_orderdetail //
DROP PROCEDURE IF EXISTS delete_orderdetail //
DROP PROCEDURE IF EXISTS update_addquantity //
DROP PROCEDURE IF EXISTS update_decrquantity //

CREATE PROCEDURE insert_orderdetail (IN orderid INT, IN productid INT, IN quantity INT)
BEGIN
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
END //

CREATE PROCEDURE delete_orderdetail (IN orderid INT, IN productid INT)
BEGIN
    DELETE FROM order_detail
    WHERE EXISTS (
        SELECT *
        FROM order_detail
        WHERE order_id = orderid and product_id = productid and quantity = 0
    );
END //

CREATE PROCEDURE update_addquantity (IN orderid INT, IN productid INT)
BEGIN
    UPDATE order_detail SET quantity = quantity + 1 WHERE order_id = orderid and product_id = productid;
END //

CREATE PROCEDURE update_decrquantity (IN orderid INT, IN productid INT)
BEGIN
    UPDATE order_detail SET quantity = quantity - 1 WHERE order_id = orderid and product_id = productid;
    CALL delete_orderdetail(orderid,productid);
END //
DELIMITER ;
