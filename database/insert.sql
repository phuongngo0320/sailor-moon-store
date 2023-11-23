USE SailorMoonStore;
GO 

SET IDENTITY_INSERT Employee ON;
SET IDENTITY_INSERT Manager ON;
SET IDENTITY_INSERT Accountant ON;
SET IDENTITY_INSERT Shipper  ON;
SET IDENTITY_INSERT Salesman ON;
SET IDENTITY_INSERT Region ON;
SET IDENTITY_INSERT Supplier ON;
SET IDENTITY_INSERT Category ON;
SET IDENTITY_INSERT Orders ON;
SET IDENTITY_INSERT Product ON;
SET IDENTITY_INSERT Bill ON;
SET IDENTITY_INSERT Promotion ON;
SET IDENTITY_INSERT Customer ON;
SET IDENTITY_INSERT Membership_Card ON;
SET IDENTITY_INSERT Review ON;
SET IDENTITY_INSERT Membership_Card ON;

INSERT INTO Employee VALUES(1,  'Nguyễn Văn A',  '1975-01-01', '360 Kim Mã, Q. Ba Đình, TP. Hà Nội',             '2005-01-01', 50, 1, 1, NULL);
INSERT INTO Employee VALUES(2,  'Trần Thị B',    '1976-01-01', '1 Lê Thánh Tông, Q. Hoàn Kiếm,  TP. Hà Nội',     '2005-02-01', 41, 1, 1, 1);
INSERT INTO Employee VALUES(3,  'Lê Văn C',      '1977-01-01', '84 Trần Nhân Tông, Q. Hai Bà Trưng, TP. Hà Nội', '2005-03-01', 6, 1, 1, 2);
INSERT INTO Employee VALUES(4,  'Phạm Thị D',    '1978-01-01', '15 Ngô Quyền, Q. Hoàn Kiếm, TP. Hà Nội',         '2005-04-01', 12, 1, 1, 2);
INSERT INTO Employee VALUES(5,  'Hoàng Văn E',   '1979-01-01', '6B Láng Hạ, Q. Ba Đình, TP. Hà Nội',             '2005-05-01', 15, 1, 1, 2);
INSERT INTO Employee VALUES(6,  'Huỳnh Thị G',   '1980-01-01', '83A Lý Thường Kiệt, Q. Hoàn Kiếm, TP. Hà Nội',   '2005-06-01', 9, 1, 1, 2);
INSERT INTO Employee VALUES(7,  'Võ Văn H',      '1981-01-01', '19 Phạm Đình Hổ, Q. Hai Bà Trưng, TP. Hà Nội',   '2005-07-01', 42, 1, 1, 1);
INSERT INTO Employee VALUES(8,  'Vũ Thị I',      '1982-01-01', '23 Nguyễn Công Trứ, Q. Hai Bà Trưng, Hà Nội',    '2005-08-01', 10, 1, 1, 7);
INSERT INTO Employee VALUES(9,  'Mai Văn K',     '1983-01-01', '14 Trần Bình Trọng, Q. Hoàn Kiếm, Hà Nội',       '2005-09-01', 25, 1, 1, 7);
INSERT INTO Employee VALUES(10, 'Phan Thị L',    '1984-01-01', '29 Tràng Tiền, Q. Hoàn Kiếm, Hà Nội',            '2005-10-01', 33, 1, 1, 7);
INSERT INTO Employee VALUES(11, 'Trương Văn M',  '1985-01-01', '1 Phan Đình Phùng, Q. Hoàn Kiếm, Hà Nội',        '2005-11-01', 3, 1, 1, 7);
INSERT INTO Employee VALUES(12, 'Bùi Thị N',     '1986-01-01', '110 Thái Thịnh, Q. Đống Đa, Hà Nội',             '2005-12-01', 41, 1, 1, 1);
INSERT INTO Employee VALUES(13, 'Đặng Văn O',    '1987-01-01', '27 Quốc Tử Giám, Q. Đống Đa, Hà Nội',            '2005-01-02', 28, 1, 1, 12);
INSERT INTO Employee VALUES(14, 'Đỗ Thị P',      '1988-01-01', '7 Đào Duy Anh, Q. Đống Đa, Hà Nội',              '2005-02-02', 12, 1, 1, 12);
INSERT INTO Employee VALUES(15, 'Ngô Văn Q',     '1989-01-01', '1C Tôn Đản, Q. Ba Đình, Hà Nội',                 '2005-03-02', 5, 1, 1, 12);
INSERT INTO Employee VALUES(16, 'Hồ Thị R',      '1990-01-01', '16 Láng Hạ, Q. Ba Đình, Hà Nội',                 '2005-04-02', 42, 1, 1, 12);

INSERT INTO Employee VALUES(17, 'Dương Thị S',   '1991-01-01', '58 Tây Hồ, Q. Tây Hồ, TP. Hà Nội',                               '2005-01-01', 50, 1, 2, NULL);
INSERT INTO Employee VALUES(18, 'Đinh Văn T',    '1992-01-01', '45 Nguyễn Trường Tộ, Q. Ba Đình, TP. Hà Nội',                    '2006-01-01', 43, 1, 2, 17);
INSERT INTO Employee VALUES(19, 'Lý Thị U',      '1993-01-01', '22A Tạ Hiện, Q. Hoàn Kiếm, TP. Hà Nội',                          '2007-01-01', 21, 1, 2, 18);
INSERT INTO Employee VALUES(20, 'Cao Văn V',     '1994-01-01', '146 Giảng Võ, Q. Ba Đình, TP. Hà Nội',                           '2008-01-01', 37, 1, 2, 18);
INSERT INTO Employee VALUES(21, 'Doãn Thị X',    '1995-01-01', 'Km 5 cao tốc Bắc Thăng Long - Nội Bài, H. Đông Anh, TP. Hà Nội', '2009-01-01', 18, 1, 2, 18);
INSERT INTO Employee VALUES(22, 'Hà Văn Y',      '1996-01-01', '34 Hàng Bún, Q. Ba Đình, TP. Hà Nội',                            '2010-01-01', 13, 1, 2, 18);
INSERT INTO Employee VALUES(23, 'Hứa Thị A',     '1997-01-01', '77B Kim Mã, Q. Ba Đình, TP. Hà Nội',                             '2011-01-01', 43, 1, 2, 17);
INSERT INTO Employee VALUES(24, 'Kiều Văn B',    '1998-01-01', '12 Phố Huế, Q. Hai Bà Trưng, TP. Hà Nội',                        '2012-01-01', 17, 1, 2, 23);
INSERT INTO Employee VALUES(25, 'Lâm Thị C',     '1999-01-01', '17A Trần Hưng Đạo, Q. Hoàn Kiếm, TP. Hà Nội',                    '2013-01-01', 20, 1, 2, 23);
INSERT INTO Employee VALUES(26, 'Lương Văn D',   '2000-01-01', '94 Yết Kiêu, Q. Hoàn Kiếm, TP. Hà Nội',                          '2014-01-01', 7, 1, 2, 23);
INSERT INTO Employee VALUES(27, 'Lưu Thị E',     '2001-01-01', '43B Ngô Quyền, Q. Hoàn Kiếm, TP. Hà Nội',                        '2015-01-01', 19, 1, 2, 23);
INSERT INTO Employee VALUES(28, 'Mạc Văn G',     '2002-01-01', '76 Hàng Trống, Q. Hoàn Kiếm, TP. Hà Nội',                        '2016-01-01', 49, 1, 2, 17);
INSERT INTO Employee VALUES(29, 'Nghiêm Thị H',  '2003-01-01', '16A Nguyễn Công Trứ, Q. Hai Bà Trưng, TP. Hà Nội',               '2017-01-01', 27, 1, 2, 28);
INSERT INTO Employee VALUES(30, 'Nông Văn I',    '2004-01-01', '25 Trần Hưng Đạo, Q. Hoàn Kiếm, TP. Hà Nội',                     '2018-01-01', 21, 1, 2, 28);
INSERT INTO Employee VALUES(31, 'Phùng Thị K ',  '2005-01-01', '185 Lò Đúc, Q. Hai Bà Trưng, TP. Hà Nội',                        '2019-01-01', 18, 1, 2, 28);
INSERT INTO Employee VALUES(32, 'Quách Văn L',   '2006-01-01', '132 Tôn Đức Thắng, Q. Đống Đa, TP. Hà Nội',                      '2020-01-01', 29, 1, 2, 28);

INSERT INTO Employee VALUES(33,  'Tạ Văn M',        '1975-01-02', '12 Hàng Trống, Q. Hoàn Kiếm, TP. Hà Nội',                '2005-02-01', 50, 1, 3, NULL);
INSERT INTO Employee VALUES(34,  'Tăng Thị N',      '1976-01-02', '334 Bà Triệu, Q. Hai Bà Trưng, TP. Hà Nội',              '2006-02-01', 47, 1, 3, 34);
INSERT INTO Employee VALUES(35,  'Thân Văn O',      '1977-01-02', '55 Đường Thành, Q. Hoàn Kiếm, TP. Hà Nội',               '2007-02-01', 15, 1, 3, 35);
INSERT INTO Employee VALUES(36,  'Tô Thị P',        '1978-01-02', '125 Trúc Bạch, Q. Ba Đình, TP. Hà Nội',                  '2008-02-01', 2, 1, 3, 35);
INSERT INTO Employee VALUES(37,  'Trịnh Văn Q',     '1979-01-02', '30 Cửa Nam, Q.Hoàn Kiếm, TP. Hà Nội',                    '2009-02-01', 19, 1, 3, 35);
INSERT INTO Employee VALUES(38,  'Vương Thị R',     '1980-01-02', '2 Đường Thành, Q. Hoàn Kiếm, TP. Hà Nội',                '2010-02-01', 21, 1, 3, 35);
INSERT INTO Employee VALUES(39,  'Nguyễn Thị S',    '1981-01-02', '128 Hàng Bông, Q. Hoàn Kiếm, TP. Hà Nội',                '2011-02-01', 49, 1, 3, 34);
INSERT INTO Employee VALUES(40,  'Trần Văn T',      '1982-01-02', '97 Cầu Giấy, Q. Cầu Giấy, TP. Hà Nội',                   '2012-02-01', 48, 1, 3, 39);
INSERT INTO Employee VALUES(41,  'Lê Thị U',        '1983-01-02', '16 Nguyễn Văn Cừ, Q. Long Biên, TP. Hà Nội',             '2013-02-01', 14, 1, 3, 39);
INSERT INTO Employee VALUES(42,  'Phạm Văn V',      '1984-01-02', '150 Nguyễn Thái Học, Q. Ba Đình, TP. Hà Nội',            '2014-02-01', 7, 1, 3, 39);
INSERT INTO Employee VALUES(43,  'Hoàng Thị X',     '1985-01-02', '11 Mã Mây, Q. Hoàn Kiếm, TP. Hà Nội',                    '2015-02-01', 32, 1, 3, 39);
INSERT INTO Employee VALUES(44,  'Huỳnh Văn Y',     '1986-01-02', '42 Mã Mây, Q. Hoàn Kiếm, TP. Hà Nội',                    '2016-02-01', 40, 1, 3, 34);
INSERT INTO Employee VALUES(45,  'Võ Thị A',        '1987-01-02', '95B Hàng Gà, Q. Hoàn Kiếm, TP. Hà Nội',                  '2017-02-01', 8, 1, 3, 44);
INSERT INTO Employee VALUES(46,  'Vũ Văn B',        '1988-01-02', '87 Phố Huế, Q. Hai Bà Trưng, TP. Hà Nội',                '2018-02-01', 13, 1, 3, 44);
INSERT INTO Employee VALUES(47,  'Mai Thị C',       '1989-01-02', '1 Tăng Bạt Hổ, Q. Hai Bà Trưng, TP. Hà Nội',             '2019-02-01', 20, 1, 3, 44);
INSERT INTO Employee VALUES(48,  'Phan Văn D',      '1990-01-02', '525 Ngô Gia Tự, Q. Long Biên, TP. Hà Nội',               '2020-02-01', 19, 1, 3, 44);

INSERT INTO Employee VALUES(49,  'Trương Thị E ',   '1991-01-02', '167 Nguyễn Văn Thoại, Phường An Hải Đông, Quận Sơn Trà, Đà Nẵng',                '2015-01-01', 50, 2, 1, NULL);
INSERT INTO Employee VALUES(50,  'Bùi Văn G',       '1992-01-02', 'Số 68, Đường Phước Tường 16, Phường Hoà Phát, Quận Cẩm Lệ, Đà Nẵng',             '2015-01-02', 33, 2, 1, 49);
INSERT INTO Employee VALUES(51,  'Đặng Thị H',      '1993-01-02', 'Số 19 đường Hòa Bình 3, Phường Hoà Quý, Quận Ngũ Hành Sơn, Đà Nẵng',             '2015-01-03', 14, 2, 1, 50);
INSERT INTO Employee VALUES(52,  'Đỗ Văn I',        '1994-01-02', '121 Trần Thái Tông, Phường An Khê, Quận Thanh Khê, Đà Nẵng',                     '2015-01-04', 13, 2, 1, 50);
INSERT INTO Employee VALUES(53,  'Ngô Thị K',       '1995-01-02', '102 Lý Thái Tông, Phường Thanh Khê Tây, Quận Thanh Khê, Đà Nẵng',                '2015-01-05', 16, 2, 1, 50);
INSERT INTO Employee VALUES(54,  'Hồ Văn L',        '1996-01-02', 'Số 6 Nguyễn Khắc Nhu, Phường Hoà Minh, Quận Liên Chiểu, Đà Nẵng',                '2015-01-06', 1, 2, 1, 50);
INSERT INTO Employee VALUES(55,  'Dương Văn M',     '1997-01-02', '412/14 Tôn Đức Thắng, Phường Hoà Minh, Quận Liên Chiểu, Đà Nẵng',                '2015-01-07', 37, 2, 1, 49);
INSERT INTO Employee VALUES(56,  'Đinh Thị N',      '1998-01-02', '773 Trần Cao Vân, Phường Thanh Khê Đông, Quận Thanh Khê, Đà Nẵng',               '2015-01-08', 23, 2, 1, 55);
INSERT INTO Employee VALUES(57,  'Lý Văn O',        '1999-01-02', 'Số 46 Ngọc Hân, Phường An Hải Tây, Quận Sơn Trà, Đà Nẵng',                       '2015-01-09', 1, 2, 1, 55);
INSERT INTO Employee VALUES(58,  'Cao Thị P',       '2000-01-02', '3150 Nguyễn Phước Nguyên, Phường An Khê, Quận Thanh Khê, Đà Nẵng',               '2015-01-10', 19, 2, 1, 55);
INSERT INTO Employee VALUES(59,  'Doãn Văn Q',      '2001-01-02', '253/11 Nguyễn Hoàng, Phường Bình Hiên, Quận Hải Châu, Đà Nẵng',                  '2015-01-11', 16, 2, 1, 55);
INSERT INTO Employee VALUES(60,  'Hà Thị R',        '2002-01-02', '308 Nguyễn Thị Bảy, Phường Thanh Khê Tây, Quận Thanh Khê, Đà Nẵng',              '2015-01-12', 37, 2, 1, 49);
INSERT INTO Employee VALUES(61,  'Hứa Văn S',       '2003-01-02', '255 Mẹ Thứ, Phường Hoà Xuân, Quận Cẩm Lệ, Đà Nẵng',                              '2015-01-13', 18, 2, 1, 60);
INSERT INTO Employee VALUES(62,  'Kiều Thị T',      '2004-01-02', '256 Hải Phòng, Phường Tân Chính, Quận Thanh Khê, Đà Nẵng',                       '2015-01-14', 7, 2, 1, 60);
INSERT INTO Employee VALUES(63,  'Lâm Văn U',       '2005-01-02', 'K91/2 Đường 3 Tháng 2, Phường Thuận Phước, Quận Hải Châu, Đà Nẵng',              '2015-01-15', 4, 2, 1, 60);
INSERT INTO Employee VALUES(64,  'Lương Thị V',     '2006-01-02', '328 Lê Văn An, Phường Khuê Trung, Quận Cẩm Lệ, Đà Nẵng',                         '2015-01-16', 13, 2, 1, 60);

INSERT INTO Employee VALUES(65,  'Lưu Văn X',       '2003-03-01', 'Lô A1.1 đường Hoàng Sa, Phường Mân Thái, Quận Sơn Trà, Đà Nẵng',                 '2023-11-01', 50, 2, 2, NULL);
INSERT INTO Employee VALUES(66,  'Mac Thị Y',       '2003-03-02', 'Lô 22 Vùng Trung 6, Phường Hoà Hải, Quận Ngũ Hành Sơn, Đà Nẵng',                 '2023-11-02', 37, 2, 2, 65);
INSERT INTO Employee VALUES(67,  'Nghiêm Văn A',    '2003-03-03', '141/56 Tiểu La, Phường Hoà Cường Bắc, Quận Hải Châu, Đà Nẵng',                   '2023-11-03', 26, 2, 2, 66);
INSERT INTO Employee VALUES(68,  'Nông Thị B',      '2003-03-04', '487 Đường Trường Chinh, Phường An Khê, Quận Thanh Khê, Đà Nẵng',                 '2023-11-04', 12, 2, 2, 66);
INSERT INTO Employee VALUES(69,  'Phùng Văn C',     '2003-03-05', '46 Đồng Bài 2, Phường Hoà Khánh Nam, Quận Liên Chiểu, Đà Nẵng',                  '2023-11-05', 6, 2, 2, 66);
INSERT INTO Employee VALUES(70,  'Quách Thị D',     '2003-03-06', 'K402/19 Trưng Nữ Vương, Phường Hoà Thuận Đông, Quận Hải Châu, Đà Nẵng',          '2023-11-06', 20, 2, 2, 66);
INSERT INTO Employee VALUES(71,  'Tạ Văn E',        '2003-03-07', 'Số 7 Đức Lợi 2, Phường Thuận Phước, Quận Hải Châu, Đà Nẵng',                     '2023-11-07', 39, 2, 2, 65);
INSERT INTO Employee VALUES(72,  'Tăng Thị G',      '2003-03-08', 'K37/31 Lương Thế Vinh, Phường An Hải Đông, Quận Sơn Trà, Đà Nẵng',               '2023-11-08', 20, 2, 2, 71);
INSERT INTO Employee VALUES(73,  'Thân Văn H',      '2003-03-09', '372/5 Phan Châu Trinh, Phường Bình Thuận, Quận Hải Châu, Đà Nẵng',               '2023-11-09', 17, 2, 2, 71);
INSERT INTO Employee VALUES(74,  'Tô Thị I',        '2003-03-10', 'Số 17 Tùng Lâm 8, Phường Hoà Xuân, Quận Cẩm Lệ, Đà Nẵng',                        '2023-11-10', 21, 2, 2, 71);
INSERT INTO Employee VALUES(75,  'Trịnh Văn K',     '2003-03-11', '95 Huỳnh Tấn Phát, Phường Hoà Cường Bắc, Quận Hải Châu, Đà Nẵng',                '2023-11-11', 5, 2, 2, 71);
INSERT INTO Employee VALUES(76,  'Vương Thị L',     '2003-03-12', '12 Thanh Tân, Phường Thanh Khê Đông, Quận Thanh Khê, Đà Nẵng',                   '2023-11-12', 38, 2, 2, 65);
INSERT INTO Employee VALUES(77,  'Nguyễn Văn M',    '2003-03-13', '202 Kỳ Đồng, Phường Thanh Khê Đông, Quận Thanh Khê, Đà Nẵng',                    '2023-11-13', 16, 2, 2, 76);
INSERT INTO Employee VALUES(78,  'Trần Thị N',      '2003-03-14', '25 Hoàng Bích Sơn, Phường Phước Mỹ, Quận Sơn Trà, Đà Nẵng',                      '2023-11-14', 22, 2, 2, 76);
INSERT INTO Employee VALUES(79,  'Lê Văn O',        '2003-03-15', '38 Cao Xuân Dục, Phường Thuận Phước, Quận Hải Châu, Đà Nẵng',                    '2023-11-15', 25, 2, 2, 76);
INSERT INTO Employee VALUES(80,  'Phạm Thị P',      '2003-03-16', '01 Trần Thanh Trung, Phường Thanh Khê Tây, Quận Thanh Khê, Đà Nẵng',             '2023-11-16', 17, 2, 2, 76);

INSERT INTO Employee VALUES(81,  'Hoàng Thị Q',     '2003-01-19', 'F11/27E2 đường Phạm Thị Nghĩ, ấp 6, Xã Vĩnh Lộc A, Huyện Bình Chánh, TP Hồ Chí Minh',                '2021-12-01', 50, 3, 1, NULL);
INSERT INTO Employee VALUES(82,  'Huỳnh Văn R',     '2003-02-19', '2/33 đường 147, KP5, Phường Tăng Nhơn Phú B, Thành phố Thủ Đức, TP Hồ Chí Minh',                     '2021-12-01', 34, 3, 1, 81);
INSERT INTO Employee VALUES(83,  'Võ Thị S',        '2003-03-19', '223 Hoàng Văn Thụ, Phường 08, Quận Phú Nhuận, TP Hồ Chí Minh',                                       '2021-12-01', 23, 3, 1, 82);
INSERT INTO Employee VALUES(84,  'Vũ Văn T',        '2003-04-19', 'Số 103, đường số 5, Phường Linh Xuân, Thành phố Thủ Đức, TP Hồ Chí Minh',                            '2021-12-01', 13, 3, 1, 82);
INSERT INTO Employee VALUES(85,  'Mai Thị U',       '2003-05-19', 'Số 473 Đỗ Xuân Hợp, Phường Phước Long B, Thành phố Thủ Đức, TP Hồ Chí Minh',                         '2021-12-01', 10, 3, 1, 82);
INSERT INTO Employee VALUES(86,  'Phan Văn V',      '2003-06-19', '120 Vũ Tông Phan , Khu Phố 5, Phường An Phú, Thành phố Thủ Đức, TP Hồ Chí Minh',                     '2021-12-01', 11, 3, 1, 82);
INSERT INTO Employee VALUES(87,  'Trương Thị X',    '2003-07-19', '72 Bình Giã, Phường 13, Quận Tân Bình, TP Hồ Chí Minh',                                              '2021-12-01', 36, 3, 1, 81);
INSERT INTO Employee VALUES(88,  'Bùi Văn Y',       '2003-08-19', 'Số 197 Nguyễn Văn Thủ, Phường Đa Kao, Quận 1, TP Hồ Chí Minh',                                       '2021-12-01', 6, 3, 1, 87);
INSERT INTO Employee VALUES(89,  'Đặng Thị A',      '2003-09-19', '1001/2 /5 Đường Nguyễn Thị Định, Khu Phố 3, Phường Cát Lái, Thành phố Thủ Đức, TP Hồ Chí Minh',      '2021-12-01', 10, 3, 1, 87);
INSERT INTO Employee VALUES(90,  'Đỗ Văn B',        '2003-10-19', '33/9A Đường số 08, Khu phố 01, Phường Linh Xuân, Thành phố Thủ Đức, TP Hồ Chí Minh',                 '2021-12-01', 1, 3, 1, 87);
INSERT INTO Employee VALUES(91,  'Ngô Thị C',       '2003-11-19', '45 Nguyễn Đôn Tiết, Phường Cát Lái, Thành phố Thủ Đức, TP Hồ Chí Minh',                              '2021-12-01', 21, 3, 1, 87);
INSERT INTO Employee VALUES(92,  'Hồ Văn D',        '2003-12-19', 'Số 58 đường 53, Phường Tân Phong, Quận 7, TP Hồ Chí Minh',                                           '2021-12-01', 35, 3, 1, 81);
INSERT INTO Employee VALUES(93,  'Dương Thị E',     '2004-01-19', 'Số 18 đường Trần Ngọc Diện, Phường Thảo Điền, Thành phố Thủ Đức, TP Hồ Chí Minh',                    '2021-12-01', 23, 3, 1, 92);
INSERT INTO Employee VALUES(94,  'Đinh Văn G',      '2004-02-19', 'Số 12, Đường số 2, Phường Phú Hữu, Thành phố Thủ Đức, TP Hồ Chí Minh',                               '2021-12-01', 18, 3, 1, 92);
INSERT INTO Employee VALUES(95,  'Lý Thị H',        '2004-03-19', 'Số 1B Đường số 30, Khu phố 2, Phường An Khánh, Thành phố Thủ Đức, TP Hồ Chí Minh',                   '2021-12-01', 1, 3, 1, 92);
INSERT INTO Employee VALUES(96,  'Cao Văn I',       '2004-04-19', '8/7 Đường 49B, Khu phố 4, Phường Thảo Điền, Thành phố Thủ Đức, TP Hồ Chí Minh',                      '2021-12-01', 8, 3, 1, 92);

-- INSERT INTO Manager VALUES(1, );
-- INSERT INTO Manager VALUES(17, );
-- INSERT INTO Manager VALUES(33, );
-- INSERT INTO Manager VALUES(49, );
-- INSERT INTO Manager VALUES(65, );
-- INSERT INTO Manager VALUES(81, );

-- INSERT INTO Accountant VALUES(2, );
-- INSERT INTO Accountant VALUES(3, );
-- INSERT INTO Accountant VALUES(4, );
-- INSERT INTO Accountant VALUES(5, );
-- INSERT INTO Accountant VALUES(6, );

-- INSERT INTO Accountant VALUES(2, );
-- INSERT INTO Accountant VALUES(3, );
-- INSERT INTO Accountant VALUES(4, );
-- INSERT INTO Accountant VALUES(5, );
-- INSERT INTO Accountant VALUES(6, );

-- INSERT INTO Accountant VALUES(2, );
-- INSERT INTO Accountant VALUES(3, );
-- INSERT INTO Accountant VALUES(4, );
-- INSERT INTO Accountant VALUES(5, );
-- INSERT INTO Accountant VALUES(6, );

-- INSERT INTO Accountant VALUES(2, );
-- INSERT INTO Accountant VALUES(3, );
-- INSERT INTO Accountant VALUES(4, );
-- INSERT INTO Accountant VALUES(5, );
-- INSERT INTO Accountant VALUES(6, );

-- INSERT INTO Accountant VALUES(2, );
-- INSERT INTO Accountant VALUES(3, );
-- INSERT INTO Accountant VALUES(4, );
-- INSERT INTO Accountant VALUES(5, );
-- INSERT INTO Accountant VALUES(6, );

-- INSERT INTO Accountant VALUES(2, );
-- INSERT INTO Accountant VALUES(3, );
-- INSERT INTO Accountant VALUES(4, );
-- INSERT INTO Accountant VALUES(5, );
-- INSERT INTO Accountant VALUES(6, );

-- INSERT INTO Shipper VALUES(7, );
-- INSERT INTO Shipper VALUES(8, );
-- INSERT INTO Shipper VALUES(9, );
-- INSERT INTO Shipper VALUES(10, );
-- INSERT INTO Shipper VALUES(11, );

-- INSERT INTO Shipper VALUES(7, );
-- INSERT INTO Shipper VALUES(8, );
-- INSERT INTO Shipper VALUES(9, );
-- INSERT INTO Shipper VALUES(10, );
-- INSERT INTO Shipper VALUES(11, );

-- INSERT INTO Shipper VALUES(7, );
-- INSERT INTO Shipper VALUES(8, );
-- INSERT INTO Shipper VALUES(9, );
-- INSERT INTO Shipper VALUES(10, );
-- INSERT INTO Shipper VALUES(11, );

-- INSERT INTO Shipper VALUES(7, );
-- INSERT INTO Shipper VALUES(8, );
-- INSERT INTO Shipper VALUES(9, );
-- INSERT INTO Shipper VALUES(10, );
-- INSERT INTO Shipper VALUES(11, );

-- INSERT INTO Shipper VALUES(7, );
-- INSERT INTO Shipper VALUES(8, );
-- INSERT INTO Shipper VALUES(9, );
-- INSERT INTO Shipper VALUES(10, );
-- INSERT INTO Shipper VALUES(11, );

-- INSERT INTO Shipper VALUES(7, );
-- INSERT INTO Shipper VALUES(8, );
-- INSERT INTO Shipper VALUES(9, );
-- INSERT INTO Shipper VALUES(10, );
-- INSERT INTO Shipper VALUES(11, );

-- INSERT INTO Salesman VALUES(12, );
-- INSERT INTO Salesman VALUES(13, );
-- INSERT INTO Salesman VALUES(14, );
-- INSERT INTO Salesman VALUES(15, );
-- INSERT INTO Salesman VALUES(16, );

-- INSERT INTO Salesman VALUES(12, );
-- INSERT INTO Salesman VALUES(13, );
-- INSERT INTO Salesman VALUES(14, );
-- INSERT INTO Salesman VALUES(15, );
-- INSERT INTO Salesman VALUES(16, );

-- INSERT INTO Salesman VALUES(12, );
-- INSERT INTO Salesman VALUES(13, );
-- INSERT INTO Salesman VALUES(14, );
-- INSERT INTO Salesman VALUES(15, );
-- INSERT INTO Salesman VALUES(16, );

-- INSERT INTO Salesman VALUES(12, );
-- INSERT INTO Salesman VALUES(13, );
-- INSERT INTO Salesman VALUES(14, );
-- INSERT INTO Salesman VALUES(15, );
-- INSERT INTO Salesman VALUES(16, );

-- INSERT INTO Salesman VALUES(12, );
-- INSERT INTO Salesman VALUES(13, );
-- INSERT INTO Salesman VALUES(14, );
-- INSERT INTO Salesman VALUES(15, );
-- INSERT INTO Salesman VALUES(16, );

-- INSERT INTO Salesman VALUES(12, );
-- INSERT INTO Salesman VALUES(13, );
-- INSERT INTO Salesman VALUES(14, );
-- INSERT INTO Salesman VALUES(15, );
-- INSERT INTO Salesman VALUES(16, );

INSERT INTO Region VALUES (1, 'Hà Nội', 3360);
INSERT INTO Region VALUES (2, 'Đà Nẵng', 1285);
INSERT INTO Region VALUES (3, 'Thành phố Hồ Chí Minh', 2095);

INSERT INTO  Branch VALUES (1, 1, 1, 'Ba Đình', '297D Kim Mã, Q. Ba Đình, Hà Nội', '0938 233 048');
INSERT INTO  Branch VALUES (1, 2, 17, 'Hoàn Kiếm', '57 Hàng Trống, Q. Hoàn Kiếm, Hà Nội', '0938 285 579 ');
INSERT INTO  Branch VALUES (1, 3, 33, 'Hai Bà Trưng', '13 Bùi Thị Xuân, Q. Hai Bà Trưng, Hà Nội ', '0938 226 764');
INSERT INTO  Branch VALUES (2, 1, 49, 'Hải Châu', 'K408/88 Hoàng Diệu, Phường Bình Thuận, Quận Hải Châu, Đà Nẵng', '0982 740 888');
INSERT INTO  Branch VALUES (2, 2, 65, 'Thanh Khê', 'K5/9 Nguyễn Văn Huề, Phường Thanh Khê Tây, Quận Thanh Khê, Đà Nẵng', '0970 724 112');
INSERT INTO  Branch VALUES (3, 1, 81, 'Thủ Đức', '462 Nguyễn Thị Định, Phường Thạnh Mỹ Lợi, Thành phố Thủ Đức, TP Hồ Chí Minh', '0939 601 901');

INSERT INTO Supplier VALUES (1, 'ELISE', 'Tầng 8 - Số 2 Tôn Thất Tùng - Đống Đa - Hà Nội', '1900 3060');
INSERT INTO Supplier VALUES (2, 'YODY', 'Đường An Định - Phường Việt Hòa - Thành phố Hải Dương - Hải Dương', '1800 2086');
INSERT INTO Supplier VALUES (3, 'Maison Retail Management International', NULL, '1900 252538');
INSERT INTO Supplier VALUES (4, 'Thời Trang 3C', '1575 Nguyễn Hoàng, Khu đô thị An Phú An Khánh, Quận 2, Thành phố Hồ Chí Minh', '028 3740 2628');
INSERT INTO Supplier VALUES (5, 'BiLuxury', 'Số 675-677 đường Tam Trinh, phường Yên Sở, Quận Hoàng Mai, Hà Nội', '094 432 8989');
INSERT INTO Supplier VALUES (6, 'H&A', 'Tầng 9, Tòa nhà 381 Đội Cấn, Ba Đình, Hà Nội', '0988 779 763');
INSERT INTO Supplier VALUES (7, 'Thời Trang Nam Linh', 'Số 119 Trung Kính, P. Yên Hòa, Q. Cầu Giấy, Hà Nội', '0932 292 233');
INSERT INTO Supplier VALUES (8, 'SIXDO', NULL, '1800 6650');
INSERT INTO Supplier VALUES (9, 'VMG Fashion', '25-27-29-31-33-35 Hoàng Trọng Mậu, P. Tân Hưng, Q. 7, TP. HCM', '1900 99 88 98');
INSERT INTO Supplier VALUES (10, 'Ninomaxx Concept', '53/4 Trần Khánh Dư, Phường Tân Định, Quận 1, TP. Hồ Chí Minh', '028 3526 7061');
INSERT INTO Supplier VALUES (11, 'Thời Trang Hạnh', '185/16 Ni Sư Huỳnh Liên, Phường 10, Quận Tân Bình, TP. HCM', '077 584 3019');
INSERT INTO Supplier VALUES (12, 'An Phước', '100/11-12 An Dương Vương, P.9, Q.5, TP. Hồ Chí Minh, Việt Nam', '1800 888 618');
INSERT INTO Supplier VALUES (13, 'Gumac', NULL, '1800 6013');


SET IDENTITY_INSERT Employee OFF;
SET IDENTITY_INSERT Manager OFF;
SET IDENTITY_INSERT Accountant OFF;
SET IDENTITY_INSERT Shipper  OFF;
SET IDENTITY_INSERT Salesman OFF;
SET IDENTITY_INSERT Region OFF;
SET IDENTITY_INSERT Supplier OFF;
SET IDENTITY_INSERT Category OFF;
SET IDENTITY_INSERT Orders OFF;
SET IDENTITY_INSERT Product OFF;
SET IDENTITY_INSERT Bill OFF;
SET IDENTITY_INSERT Promotion OFF;
SET IDENTITY_INSERT Customer OFF;
SET IDENTITY_INSERT Membership_Card OFF;
SET IDENTITY_INSERT Review OFF;
SET IDENTITY_INSERT Membership_Card OFF;