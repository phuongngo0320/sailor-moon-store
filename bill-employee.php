<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css">
    <title>Bach</title>
</head>
<body>  
    <div class="wrapper">
        
        <?php
        // mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
        $conn = new mysqli("localhost","root","","sailormoonstore");

        if($conn->connect_error) {
            echo "Kết nối MYSQLi lỗi" . $conn->connect_error;
            exit();
        }
        ?>

        <div class="header">
            <p class="header_content" style="text-transform: uppercase; font-size:xx-large">Giao diện</p>
        </div>

        <div class="menu">
            <ul class="admincp_list">
                <li><a href="index.php?action=quanlyhoadon">Quản lý hóa đơn</a></li>
                <li><a href="index.php?action=quanlynhanvien">Quản lý nhân viên</a></li>
            </ul>
        </div>      
        
        <div class="clear"></div>

        <div class="main">

            <?php
                function getEmployeeList($conn,$month,$year,$selectedOption) {
                    if($month) {
                        $nhanvien =  " SELECT Branch.region_id AS Region_id,Branch.number AS Branch_number,Employee.id AS Employee_id,Employee.name AS Employee_name,COUNT(Orders.id) AS Amount
                                            FROM ((Salesman JOIN Employee ON Salesman.salesman_id = Employee.id) JOIN Orders ON Salesman.salesman_id = Orders.salesman_id) JOIN Branch ON (Employee.region_id = Branch.region_id AND Employee.branch_no = Branch.number) 
                                            WHERE month(orders.order_time) = $month AND year(orders.order_time) = $year
                                            GROUP BY Employee.id,Employee.name
                                            HAVING (Branch.region_id,Branch.number,COUNT(Orders.id)) IN (SELECT total.region_id,total.number,MAX(total.num) AS max 
                                                                                                        FROM  (SELECT Branch.region_id,Branch.number,Employee.id,COUNT(Orders.id) AS num 
                                                                                                                FROM ((Salesman JOIN Employee ON Salesman.salesman_id = Employee.id) JOIN Orders ON Salesman.salesman_id = Orders.salesman_id) JOIN Branch ON (Employee.region_id = Branch.region_id AND Employee.branch_no = Branch.number)  
                                                                                                                WHERE month(orders.order_time) = $month AND year(orders.order_time) = $year
                                                                                                                GROUP BY Employee.id) AS total 
                                                                                                        GROUP BY total.region_id,total.number) 
                                            ORDER BY $selectedOption; ";   
                    }
                    else {
                        $nhanvien =  "SELECT Branch.region_id AS Region_id,Branch.number AS Branch_number,Employee.id AS Employee_id,Employee.name AS Employee_name,COUNT(Orders.id) AS Amount
                                            FROM ((Salesman JOIN Employee ON Salesman.salesman_id = Employee.id) JOIN Orders ON Salesman.salesman_id = Orders.salesman_id) JOIN Branch ON (Employee.region_id = Branch.region_id AND Employee.branch_no = Branch.number) 
                                            WHERE year(orders.order_time) = $year
                                            GROUP BY Employee.id,Employee.name
                                            HAVING (Branch.region_id,Branch.number,COUNT(Orders.id)) IN (SELECT total.region_id,total.number,MAX(total.num) AS max 
                                                                                                        FROM  (SELECT Branch.region_id,Branch.number,Employee.id,COUNT(Orders.id) AS num 
                                                                                                                FROM ((Salesman JOIN Employee ON Salesman.salesman_id = Employee.id) JOIN Orders ON Salesman.salesman_id = Orders.salesman_id) JOIN Branch ON (Employee.region_id = Branch.region_id AND Employee.branch_no = Branch.number)  
                                                                                                                WHERE year(orders.order_time) = $year
                                                                                                                GROUP BY Employee.id) AS total 
                                                                                                        GROUP BY total.region_id,total.number ) 
                                            ORDER BY $selectedOption; ";  
                    }
                return   mysqli_query($conn,$nhanvien);
                }
                function getCustomerList($conn,$tensp,$start,$end,$FindOption) {
                    $sql_timkiem = "SELECT Customer.id AS Customer_id, Customer.name AS Customer_name, COUNT(Product.id) AS Amount
                                    FROM	Customer, Orders, Order_Detail, Product
                                    WHERE	Customer.id = Orders.cus_id AND Orders.id = Order_Detail.order_id AND Order_Detail.product_id = Product.id  AND product.name = '$tensp' AND orders.order_time >='$start' AND orders.order_time <= '$end'
                                    GROUP BY Customer.id, Customer.name
                                    ORDER BY $FindOption";
                    return mysqli_query($conn,$sql_timkiem);
                }
            ?>


            <?php
            if(isset($_GET['action'])){
                $tam = $_GET['action'];
            }else{
                $tam = '';
            }
            if($tam=='quanlyhoadon'){ ?>
                <div class="dienthongtin">
                    <p >Nhập tên sản phẩm và khoảng thời gian mua hàng</p>
                    <form method="post" action="">
                        <div>
                            <label for="tensanpham">Tên sản phẩm</label><br>
                            <input class="input" type="text" id="tensanpham" name="tensanpham">
                        </div>
                        <div class="form_group" >
                            <label for="ngaybatdau">Từ ngày</label><br>
                            <input class="input" type="text" id="ngaybatdau" name="ngaybatdau">
                        </div>
                        <div class="form_group">
                            <label for="ngayketthuc">Đến ngày</label><br>
                            <input class="input" type="text" id="ngayketthuc" name="ngayketthuc">
                        </div>
                        <div class="clear"></div>
                        <div class="filter_sort">
                            <select name="sort1" id="sort1">
                                <option value="Customer_id ASC">Sắp xếp</option>
                                <option value="Customer_id ASC">Mã khách hàng tăng dần</option>
                                <option value="Customer_id DESC">Mã khách hàng giảm dần</option>
                                <option value="Customer_name ASC">Tên khách hàng tăng dần</option>
                                <option value="Customer_name DESC">Tên khách hàng giảm dần</option>
                                <option value="Amount ASC">Số lượng tăng dần</option>
                                <option value="Amount DESC">Số lượng giảm dần</option>
                            </select>
                        </div>
                        <div class="clear"></div>
                        <input type="submit" value="Tìm kiếm" name="timkiem" style="font-weight:bolder; margin-bottom: 10px;font-size:120%">
                    </form>
                        
                </div>
    
                <div class="lietke">
                    <?php
                    if(isset($_POST['timkiem'])) {
                        $tensp = $_POST['tensanpham'];
                        $start = $_POST['ngaybatdau'];
                        $end = $_POST['ngayketthuc'];
                        $FindOption = $_POST['sort1'];
                        if(!$tensp || !$start || !$end ) {
                    ?>  
                    <p> Mời nhập đầy đủ thông tin </p>
                    <?php
                        }
                        elseif ($start > $end){
                            ?>  
                            <p> Mời nhập chính xác thông tin </p>
                            <?php
                                }
                        else {

                    ?> 
                    <p>Liệt kê khách hàng</p>
                    <table class="content_table" border="1" width=100% style="border-collapse:collapse;">
                        <thead>
                        <tr>
                            <th>Mã khách hàng</th>
                            <th>Tên khách hàng</th>
                            <th>Số lượng</th>
                        </tr>
                        </thead>
                        <tbody>
                        <?php
                        $query= getCustomerList($conn, $tensp, $start, $end, $FindOption);
                        $i=0;
                        while($row = mysqli_fetch_array($query)){
                            $i++;
                        ?>
                        <tr>
                            <td><?php echo $row['Customer_id'] ?></td>
                            <td><?php echo $row['Customer_name']?></td>
                            <td><?php echo $row['Amount']?></td>
                        </tr>

                        <?php
                        }
                        ?>
                        </tbody>

                    </table>

                    <?php
                        } 
                    }
                    ?> 

                </div>
            <?php
            }elseif($tam=='quanlynhanvien') { ?>
                <div class="dienthongtin">
                    <p >Nhập thời gian</p>
                    <form action="" method="post">
                        <div class="form_group">
                            <label for="thang">Tháng</label><br>
                            <input type="text" id="thang" name="thang">
                        </div>
                        <div class="form_group">
                            <label for="nam">Năm</label><br>
                            <input type="text" id="nam" name="nam">
                        </div>
                        <div class="filter_sort">
                            <select name="sort" id="sort">
                                <option value="Region_id ASC, Branch_number ASC">Sắp xếp</option>
                                <option value="Region_id ASC, Branch_number ASC">Chi nhánh tăng dần</option>
                                <option value="Region_id DESC, Branch_number DESC">Chi nhánh giảm dần</option>
                                <option value="Employee_id ASC">Mã nhân viên tăng dần</option>
                                <option value="Employee_id DESC">Mã nhân viên giảm dần</option>
                                <option value="Employee_name ASC">Tên nhân viên tăng dần</option>
                                <option value="Employee_name DESC">Tên nhân viên giảm dần</option>
                                <option value="Amount ASC">Số lượng tăng dần</option>
                                <option value="Amount DESC">Số lượng giảm dần</option>
                            </select>
                        </div>
                        <div class="clear"></div>
                        <input type="submit" value="Chọn" name="chon" style="font-weight:bolder; margin-bottom: 10px;font-size:120%">
                    
                    </form>

                </div>

                <div class="lietke">
                    <?php
                    if(isset($_POST['chon'])) {
                        $month = $_POST['thang'];
                        $year = $_POST['nam'];
                        $selectedOption = $_POST['sort']; 
                        if(!$year){
                    ?>        
                    <p> Mời nhập tháng năm hoặc năm </p>
                    <?php
                        }
                        elseif(!$month || ($month>=1 AND $month<=12)) {    
                            if($month>=1 AND $month<=12) {
                    ?>
                    <p>Nhân viên xuất sắc nhất từng chi nhánh trong tháng <?php echo $month ?> năm <?php echo $year ?> </p>
                
                    <?php            
                                       
                            }
                            elseif(!$month) {
                    ?>
                    <p> Nhân viên xuất sắc nhất từng chi nhánh trong năm <?php echo $year ?> </p>
                    <?php            
                                
                            }                      
                        ?>
                        <table class="content_table" border="1" width=100% style="border-collapse:collapse;">
                            <thead>
                            <tr>
                                <th>Mã khu vực</th>
                                <th>Mã chi nhánh</th>
                                <th>Mã nhân viên</th>
                                <th>Tên nhân viên</th>
                                <th>Số lượng</th>
                            </tr>
                            </thead>
                            <tbody>
                            <?php
                            $query1=getEmployeeList($conn,$month,$year,$selectedOption);
                            $i=0;
                            while($row1 = mysqli_fetch_array($query1)){
                                $i++;
                            ?>
                            <tr>
                                <td><?php echo $row1['Region_id'] ?></td>
                                <td><?php echo $row1['Branch_number']?></td>
                                <td><?php echo $row1['Employee_id']?></td>
                                <td><?php echo $row1['Employee_name']?></td>
                                <td><?php echo $row1['Amount']?></td>
                            </tr>

                            <?php
                                }
                            ?>
                            </tbody>
                        </table>

                    <?php 
                        }
                        else{
                            echo "Mời nhập chính xác tháng";
                        }
                    }        
                    ?> 

                </div>
            <?php
            }
            ?>
        </div>

        <div class="footer">
            <p style="font-size: small; float: right; margin: 5px; margin-right: 20px;">Thực hiện bởi nhóm SailorrmoonStore</p>
        </div>


    </div>
    
</body>
</html>
