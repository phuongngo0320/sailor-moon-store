USE SailorMoonStore;
GO

-- TÌm thông tin khách hàng có cấp bậc thẻ thành viên là kim cương và số lượng đơn hàng họ đã đặt

SELECT Customer.*,COUNT(Orders.id)
FROM	Customer, Membership_card, Orders
WHERE	Customer.id = Membership_card.cus_id AND Membership_card.card_level = 'Kim cương' AND Customer.id = Orders.cus_id 
GROUP BY Customer.id,Customer.name;

-- Với mỗi chi nhánh, tìm những nhân viên bán hàng có số lượng đơn hàng nhiều nhất

SELECT Branch.region_id,Branch.number,Employee.id,Employee.name,COUNT(Orders.id)
FROM ((Salesman JOIN Employee ON Salesman.salesman_id = Employee.id) JOIN Orders ON Salesman.salesman_id = Orders.salesman_id) JOIN Branch ON (Employee.region_id = Branch.region_id AND Employee.branch_no = Branch.number) 
GROUP BY Employee.id,Employee.name
HAVING (Branch.region_id,Branch.number,COUNT(Orders.id)) IN (SELECT total.region_id,total.number,MAX(total.num) AS max 
															 FROM  (SELECT Branch.region_id,Branch.number,Employee.id,COUNT(Orders.id) AS num 
																	FROM ((Salesman JOIN Employee ON Salesman.salesman_id = Employee.id) JOIN Orders ON Salesman.salesman_id = Orders.salesman_id) JOIN Branch ON (Employee.region_id = Branch.region_id AND Employee.branch_no = Branch.number)  
																	GROUP BY Employee.id) AS total 
															 GROUP BY total.region_id,total.number) 
ORDER BY Branch.region_id