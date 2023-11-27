# sailor-moon-store
An online clothing store web application made for the Database Systems course of HCMUT

## Dữ liệu mẫu

- 3 khu vực: Hà Nội (3 chi nhánh), Đà Nẵng (2 chi nhánh), TP.HCM (1 chi nhánh)

- Mỗi chi nhánh có 16 nhân viên, bao gồm:

    - 1 quản lý
    - 3 ban kế toán, giao hàng, bán hàng
    - Mỗi ban có 1 trưởng ban, 4 nhân viên cấp dưới

## Cấu trúc mã nguồn

```
├── config (cấu hình: database)
├── database (chứa lệnh SQL)
├── public (chứa các view/page: trang chủ index.php, trang sản phẩm, ...)
└── src    
    ├── inc (chứa mẫu header, footer: truy xuất bằng hàm view() như trong index.php)
    ├── libs (chứa các hàm phụ trợ, thường dành cho form)
    ├── models  (chứa class lưu thông tin database)
    ├── controllers (xử lý phía server, thường dành cho form)
```

Xử lý form trong PHP xem thêm tại: https://www.phptutorial.net/php-tutorial/php-registration-form/

## Hướng dẫn kết nối PHP - SQL Server

Cài đặt:

1. Chạy lệnh `create.sql`, `insert.sql` trong `database/` trong SSMS để thêm dữ liệu

2. Cài đặt PHP (có thể dùng XAMPP)

3. Tải driver PHP SQL Server tại: [Download the Microsoft Drivers for PHP for SQL Server](https://learn.microsoft.com/en-us/sql/connect/php/download-drivers-php-sql-server?view=sql-server-ver16), 
giải nén và copy các file `php_pdo_sqlsrv_82_ts_x64.dll` và `php_sqlsrv_82_ts_x64.dll` vào `C:/php/ext` (hoặc `C:/xampp/php/ext`)

4. Truy cập folder gốc (`C:/php` hoặc `C:/xampp/php`) chỉnh sửa file `php.ini` -> thêm các dòng sau:

```ini
extension=php_sqlsrv_82_ts_x64.dll  
extension=php_pdo_sqlsrv_82_ts_x64.dll  
```

Kết nối:

5. Vào file `config/database.php`, nhập các constant HOST (thường là ADMIN), NAME (SailorMoonStore), USER, PASSWORD (tài khoản SQL Server)

6. Tạo model trong `src/models/`, mẫu model cho bảng Region xem trong file `region.php`

7. Sử dụng model để truy xuất dữ liệu, minh họa trong `public/index.php`

8. Chạy thử: dùng lệnh `php -S` hoặc dùng XAMPP

Xem thêm về PHP: [PHP Tutorial](https://www.phptutorial.net/)

Xem thêm về PHP PDO - thư viện kết nối CSDL: [PHP PDO Tutorial](https://www.phptutorial.net/php-pdo/)

