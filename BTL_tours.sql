DROP DATABASE tourism ;
CREATE DATABASE TOURISM;
use TOURISM;

-- 1.tạo bảng chi nhánh -----------------------------------------------------------------------------
CREATE TABLE Branches (
  branch_id CHAR(6) PRIMARY KEY ,
  branch_name VARCHAR(20) NOT NULL UNIQUE,
  region VARCHAR(20),
  address VARCHAR(255),
  email VARCHAR(50),
  fax VARCHAR(20),
  manager_id CHAR(6)
);

-- xử lý branch_id vì mysql không hỗ trợ CHAR + AUTO_INCREMENT
CREATE TABLE AUTO_INCREMENT_Branches(
	id INT AUTO_INCREMENT PRIMARY KEY
) AUTO_INCREMENT = 1; -- bảng phụ

DELIMITER //
CREATE TRIGGER id_Branches_insert
BEFORE INSERT ON Branches
FOR EACH ROW
BEGIN
  INSERT INTO AUTO_INCREMENT_Branches VALUES (NULL);
  SET NEW.branch_id = CONCAT('CN', LAST_INSERT_ID());
END
//
DELIMITER ;


-- 2.tạo bảng SỐ ĐIỆN THOẠI chi nhánh -----------------------------------------------------------------------------
CREATE TABLE Branch_phones (
  branch_id CHAR(6),
  phone_number CHAR(10),
  PRIMARY KEY (branch_id, phone_number),
  FOREIGN KEY (branch_id) REFERENCES Branches (branch_id)
);



-- 3.tạo bảng Nhân viên ---------------------------------------------------------------------
CREATE TABLE Employees (
  employee_id CHAR(6) PRIMARY KEY CHECK(employee_id REGEXP '^(HD|VP)[0-9]{4}'),
  cmnd CHAR(10) NOT NULL UNIQUE,
  full_name VARCHAR(20) NOT NULL,
  address VARCHAR(255),
  gender ENUM('F','M'),				-- giới tính 
  date_of_birth DATE,
  employee_type ENUM('1','2'),		-- 1-VP, 2-HD
  position VARCHAR(20),
  branch_id CHAR(6) NOT NULL,
  FOREIGN KEY (branch_id) REFERENCES Branches (branch_id),
  -- loại nhân viên phải tương ứng với mã nhân viên
  Check(left(employee_id, 2) = 'VP' and employee_type = '1' or left(employee_id, 2) = 'HD' and employee_type = '2')
);


-- chỉnh Chi nhánh-----------------------------------------------------------------------------
ALTER TABLE Branches ADD FOREIGN KEY (manager_id) REFERENCES Employees (employee_id);


-- 4.kĩ năng ngôn ngữ nhân viên -----------------------------------------------------------------------------
CREATE TABLE Employee_languages (
  employee_id CHAR(6) CHECK(employee_id REGEXP '^(HD)'),  -- kiểm tra phải nhân viên HD
  language VARCHAR(20),
  PRIMARY KEY (employee_id, language),
  FOREIGN KEY (employee_id) REFERENCES Employees (employee_id)
);


-- 5.kĩ năng nhân viên -----------------------------------------------------------------------------
CREATE TABLE employee_skills (
  employee_id CHAR(6)  CHECK(employee_id REGEXP '^(HD)'), -- kiểm tra phải nhân viên HD
  skill VARCHAR(50),
  PRIMARY KEY (employee_id, skill),
  FOREIGN KEY (employee_id) REFERENCES Employees (employee_id)
);


-- 6.Điểm du lịch -----------------------------------------------------------------------------
CREATE TABLE Tourist_attractions (
  attraction_id INT AUTO_INCREMENT PRIMARY KEY ,
  attraction_name VARCHAR(50) NOT NULL,
  address VARCHAR(255),
  ward VARCHAR(20),
  district VARCHAR(20),
  province VARCHAR(20),
  photo_1 VARCHAR(255),
  photo_2 VARCHAR(255),
  photo_3 VARCHAR(255),
  description VARCHAR(255),
  note VARCHAR(255)
);


-- 7.Dịch vụ -----------------------------------------------------------------------------
CREATE TABLE Service_providers (
  provider_id CHAR(6) PRIMARY KEY CHECK(provider_id REGEXP '^(DV)[0-9]{4}'),
  provider_name VARCHAR(50) NOT NULL,
  email VARCHAR(50),
  phone_number CHAR(10),
  representative_name VARCHAR(20),
  representative_phone_number CHAR(10),
  address VARCHAR(255) not null,
  ward VARCHAR(20),
  district VARCHAR(20),
  province VARCHAR(20),
  photo_1 VARCHAR(255),
  photo_2 VARCHAR(255),
  photo_3 VARCHAR(255),
  photo_4 VARCHAR(255),
  photo_5 VARCHAR(255),
  service_type ENUM('1','2','3'),  -- 1 : khách sạn, 2 : vận chuyển, 3 : nhà hàng
  note VARCHAR(255)
);


-- 8.Khách hàng -----------------------------------------------------------------------------
CREATE TABLE Customers (
  customer_id CHAR(6) PRIMARY KEY CHECK(customer_id REGEXP '^(KH)[0-9]{4}'),
  cmnd CHAR(10) UNIQUE,
  full_name VARCHAR(20) NOT NULL,
  email VARCHAR(50),
  phone_number CHAR(10) NOT NULL,
  date_of_birth DATE NOT NULL,
  address VARCHAR(255)
);


-- 9.Đoàn khách -----------------------------------------------------------------------------
CREATE TABLE Customers_groups (
  group_id CHAR(6) PRIMARY KEY CHECK(group_id REGEXP '^(KD)[0-9]{4}'),
  agency_name VARCHAR(20) NOT NULL,
  email VARCHAR(50),
  phone_number CHAR(10) NOT NULL,
  address VARCHAR(255),
  representative_id CHAR(6),
  FOREIGN KEY (representative_id) REFERENCES Customers (customer_id)
);

-- 10.khách trong đoàn -----------------------------------------------------------------------------
CREATE TABLE group_individual_customers (
  group_id CHAR(6),
  customer_id CHAR(6),
  PRIMARY KEY (group_id, customer_id),
  FOREIGN KEY (group_id) REFERENCES Customers_groups (group_id),
  FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
);

-- 11.tour du lịch -----------------------------------------------------------------------------
CREATE TABLE Tours (
  tour_id VARCHAR(12) PRIMARY KEY,
  tour_name VARCHAR(50) NOT NULL,
  photo VARCHAR(255),
  start_date DATE NOT NULL,
  min_tour_guests INT NOT NULL,
  max_tour_guests INT NOT NULL,
  single_adult_price INT NOT NULL,
  single_child_price INT NOT NULL,
  group_adult_price INT NOT NULL,
  group_child_price INT NOT NULL,
  min_group_guests INT NOT NULL,
  nights INT NOT NULL CHECK(nights >= 0),
  days INT NOT NULL CHECK(days > 0),
  branch_id CHAR(6) NOT NULL,
  FOREIGN KEY (branch_id) REFERENCES Branches (branch_id),
  CHECK(single_adult_price > single_child_price),
  CHECK(single_adult_price > group_adult_price),
  CHECK(group_child_price < single_child_price),
  CHECK(group_adult_price > group_child_price),
  CHECK(min_tour_guests < max_tour_guests and min_tour_guests > 0)
);

-- xử lý Tours_id
CREATE TABLE AUTO_INCREMENT_Tours(
	id INT AUTO_INCREMENT PRIMARY KEY
) AUTO_INCREMENT = 1;

DELIMITER //
CREATE TRIGGER id_Tours_insert
BEFORE INSERT ON Tours
FOR EACH ROW
BEGIN
  INSERT INTO AUTO_INCREMENT_Tours VALUES (NULL);
  SET NEW.tour_id = CONCAT(NEW.branch_id, '-',  LPAD(LAST_INSERT_ID(),6,'0'));

END
//
DELIMITER ;




-- 12.ngày khởi hành tour dài ngày -----------------------------------------------------------------------------
CREATE TABLE Long_day_tour_departure_dates (
  tour_id VARCHAR(12),
  day INT CHECK (day >= 1 AND day <= 31),
  PRIMARY KEY (tour_id, day),
  FOREIGN KEY (tour_id) REFERENCES Tours (tour_id)
);
-- chỉ có tour dài ngày mới có ngày khởi hành
DELIMITER //
CREATE TRIGGER Long_day_tour_departure_dates_insert
BEFORE INSERT ON Long_day_tour_departure_dates
FOR EACH ROW
BEGIN
  DECLARE days INT;
  SELECT start_date INTO days FROM tours WHERE tours.Tour_id = new.tour_id;
  if days = 1 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'tour ngắn ngày không có ngày khởi hành';
  END IF;
END
//
DELIMITER ;



-- 13.lịch tình tour -----------------------------------------------------------------------------
CREATE TABLE Tour_schedules (
  tour_id VARCHAR(12),
  schedule_number INT,
  PRIMARY KEY (tour_id, schedule_number),
  FOREIGN KEY (tour_id) REFERENCES Tours (tour_id)
);
-- ngày trong lịch trình tour phải nhỏ hơn bằng ngày trong tour  
DELIMITER //
CREATE TRIGGER Tour_schedules_insert
BEFORE INSERT ON Tour_schedules
FOR EACH ROW
BEGIN
  DECLARE days INT;
  SELECT start_date INTO days FROM tours WHERE tours.Tour_id = new.tour_id;
  if days < new.schedule_number then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'tour dài ngày đã vược quá số ngày quy định';
  END IF;
END
//
DELIMITER ;


-- 14.Tham quan -----------------------------------------------------------------------------
CREATE TABLE Tour_destinations (
  tour_id VARCHAR(12),
  schedule_number INT,
  point_of_interest_id INT,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  description VARCHAR(255),
  PRIMARY KEY (tour_id, schedule_number, point_of_interest_id),
  FOREIGN KEY (tour_id, schedule_number) REFERENCES Tour_schedules (tour_id, schedule_number),
  FOREIGN KEY (point_of_interest_id) REFERENCES Tourist_attractions (attraction_id),
  CHECK (end_time > start_time)
);

-- 15.lịch trình hoặc động -----------------------------------------------------------------------------
CREATE TABLE Tour_schedule_actions (
  tour_id VARCHAR(12),
  schedule_number INT,
  action_type ENUM('1','2','3','4','5','6','7'),
  -- 1 : khởi hành tour, 2 : kết thúc tour, 3 : ăn sáng, 4 : ăn trưa, 5 : ăn tối, 6 : checkin, 7 : checkout
  start_time TIME NOT NULL,
  end_time TIME,
  description VARCHAR(255),
  PRIMARY KEY (tour_id, schedule_number, action_type),
  FOREIGN KEY (tour_id, schedule_number) REFERENCES Tour_schedules (tour_id, schedule_number),
  CHECK (end_time is null OR end_time > start_time)
);
-- tour ngắn ngày sẽ không có checkin and checkout 
DELIMITER //
CREATE TRIGGER Tour_schedule_actions_insert
BEFORE INSERT ON Tour_schedule_actions
FOR EACH ROW
BEGIN
  DECLARE days INT;
   SELECT start_date INTO days FROM tours WHERE tours.Tour_id = new.tour_id;
  if days = 1 and NEW.action_type in ('6','7') then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'tour ngắn ngày không thuê khách sạn';
  END IF;
END
//
DELIMITER ;

-- 16.chuyến đi -----------------------------------------------------------------------------
CREATE TABLE Trips (
  tour_id VARCHAR(12),
  departure_date DATE,
  arrival_date DATE,
  total_price DOUBLE DEFAULT 0.0,
  PRIMARY KEY (tour_id, departure_date),
  FOREIGN KEY (tour_id) REFERENCES Tours (tour_id),
  CHECK(arrival_date >= departure_date)
);

-- 17.Hướng dẫn viên dẫn chuyến di ------------------------------------------------------------------------
CREATE TABLE Tour_guides (
  tour_id VARCHAR(12),
  departure_date DATE,
  guide_id CHAR(6) CHECK (guide_id LIKE 'HD%'), -- HƯỚNG DẪN viên du lịch
  PRIMARY KEY (tour_id, departure_date, guide_id),
  FOREIGN KEY (tour_id, departure_date) REFERENCES Trips (tour_id, departure_date),
  FOREIGN KEY (guide_id) REFERENCES Employees (employee_id)
);

-- 18.lịch chuyến di ------------------------------------------------------------------------
CREATE TABLE Trip_schedules (
  tour_id VARCHAR(12),
  departure_date DATE,
  schedule_number INT,
  PRIMARY KEY (tour_id, departure_date, schedule_number),
  FOREIGN KEY (tour_id, departure_date) REFERENCES Trips (tour_id, departure_date)
);

-- 19.DỊCH vụ cung cấp chuyên đi ------------------------------------------------------------------------
CREATE TABLE Trip_service_providers (
  tour_id VARCHAR(12),
  departure_date DATE,
  schedule_number INT,
  service_type ENUM('1','2','3','4','5','6','7','8') CHECK(service_type not in ('1', '2')),
  service_provider_id CHAR(6),
  PRIMARY KEY (tour_id, departure_date, schedule_number, service_type, service_provider_id),
  FOREIGN KEY (tour_id, departure_date, schedule_number) REFERENCES Trip_schedules (tour_id, departure_date, schedule_number),
  FOREIGN KEY (service_provider_id) REFERENCES Service_providers (provider_id)
);


-- vé ------------------------------------------------------------------------
CREATE TABLE Registration_tickets (
  ticket_code CHAR(20) PRIMARY KEY,
  registration_date DATE,
  note VARCHAR(255),
  sales_agent_id CHAR(6) NOT NULL CHECK (sales_agent_id LIKE 'VP%'), -- nhân viên văn phòng
  individual_customer_id CHAR(6) NOT NULL,
  group_id CHAR(6),
  tour_id VARCHAR(12) NOT NULL,
  departure_date DATE NOT NULL,
  FOREIGN KEY (sales_agent_id) REFERENCES employees (employee_id),
  FOREIGN KEY (individual_customer_id) REFERENCES customers (customer_id),
  FOREIGN KEY (group_id) REFERENCES Customers_groups (group_id),
  FOREIGN KEY (tour_id, departure_date) REFERENCES trips (tour_id, departure_date)
);
-- xử lý Registration_tickets
CREATE TABLE AUTO_INCREMENT_Registration_tickets(
	id INT AUTO_INCREMENT PRIMARY KEY
) AUTO_INCREMENT = 1;

DELIMITER //
CREATE TRIGGER id_Registration_tickets_insert
BEFORE INSERT ON Registration_tickets
FOR EACH ROW
BEGIN
  INSERT INTO AUTO_INCREMENT_Registration_tickets VALUES (NULL);
  SET NEW.ticket_code = CONCAT(DATE_FORMAT(NEW.registration_date, '%d%m%Y'), '-',  LPAD(LAST_INSERT_ID(),9,'0'));
END
//
DELIMITER ;


-- kết nối dịch vụ điểm tham quan và tour ------------------------------------------------------------------------
CREATE TABLE related_service_providers (
  tour_id VARCHAR(12),
  point_id INT,
  provider_id CHAR(6),
  PRIMARY KEY (tour_id, point_id, provider_id),
  FOREIGN KEY (tour_id) REFERENCES tours (tour_id),
  FOREIGN KEY (point_id) REFERENCES tourist_attractions (attraction_id),
  FOREIGN KEY (provider_id) REFERENCES service_providers (provider_id)
);








-- ------------------------------ trigger ----------------------------------------------------------------------------------------------------

DELIMITER //  

CREATE TRIGGER after_Registration_tickets_insert
	AFTER INSERT ON Registration_tickets FOR EACH ROW  
    BEGIN
		DECLARE Gia INT;
	SELECT
		CASE
			WHEN NEW.group_id is null AND YEAR(CURDATE()) - YEAR(date_of_birth) <= 10 THEN T.single_child_price
			WHEN NEW.group_id is null THEN T.single_adult_price
			WHEN YEAR(CURDATE()) - YEAR(date_of_birth) <= 10 THEN T.group_child_price
			ELSE T.group_adult_price
		END INTO  Gia
	FROM Tours as T JOIN Customers AS C on NEW.tour_id = T.tour_id AND NEW.individual_customer_id = C.customer_id;
    
	UPDATE Trips SET total_price = total_price + Gia WHERE NEW.tour_id = Trips.tour_id AND Trips.departure_date = NEW.departure_date;
    END;
//
DELIMITER ;

DELIMITER //  

CREATE TRIGGER before_Registration_tickets_delete
	BEFORE DELETE ON Registration_tickets FOR EACH ROW  
    BEGIN
		DECLARE Gia INT;
	SELECT
		CASE
			WHEN OLD.group_id is null AND YEAR(CURDATE()) - YEAR(date_of_birth) <= 10 THEN T.single_child_price
			WHEN OLD.group_id is null THEN T.single_adult_price
			WHEN YEAR(CURDATE()) - YEAR(date_of_birth) <= 10 THEN T.group_child_price
			ELSE T.group_adult_price
		END INTO  Gia
	FROM Tours as T JOIN Customers AS C on OLD.tour_id = T.tour_id AND OLD.individual_customer_id = C.customer_id;
    
	UPDATE Trips SET total_price = total_price - Gia WHERE OLD.tour_id = Trips.tour_id AND Trips.departure_date = OLD.departure_date;
    END 

//
DELIMITER ;
-- test
-- 1000	500	800	400

-- SELECT * FROM Registration_tickets;
-- -- NGƯỜI LỚN KHÔNG TRONG ĐOÀN
-- INSERT INTO Registration_tickets (registration_date, note, sales_agent_id, individual_customer_id, group_id, tour_id, departure_date)
-- VALUES ('2023-02-01', 'đi sớm 30p.', 'VP0002', 'KH0001', null, 1, '2023-03-08');
-- SELECT *  FROM  Trips;
-- DELETE FROM Registration_tickets WHERE ticket_code = 20;
-- SELECT *  FROM  Trips;

-- -- NGƯỜI LỚN TRONG ĐOÀN
-- INSERT INTO Registration_tickets (registration_date, note, sales_agent_id, individual_customer_id, group_id, tour_id, departure_date)
-- VALUES ('2023-02-02', 'đi sớm 30p.', 'VP0002', 'KH0001', 'KD0001', 1, '2023-03-08');
-- SELECT *  FROM  Trips;
-- DELETE FROM Registration_tickets WHERE ticket_code = 21;
-- SELECT *  FROM  Trips;

-- -- trẻ nhỏ KHÔNG TRONG ĐOÀN
-- INSERT INTO Registration_tickets (registration_date, note, sales_agent_id, individual_customer_id, group_id, tour_id, departure_date)
-- VALUES ('2023-02-03', 'đi sớm 30p.', 'VP0002', 'KH0005', null, 1, '2023-03-08');
-- SELECT *  FROM  Trips;
-- DELETE FROM Registration_tickets WHERE ticket_code = 22;
-- SELECT *  FROM  Trips;

-- -- trẻ nhỏ TRONG ĐOÀN
-- INSERT INTO Registration_tickets (registration_date, note, sales_agent_id, individual_customer_id, group_id, tour_id, departure_date)
-- VALUES ('2023-02-04', 'đi sớm 30p.', 'VP0002', 'KH0005', 'KD0001', 1, '2023-03-08');
-- SELECT * FROM  Trips;
-- DELETE FROM Registration_tickets WHERE ticket_code = 23;
-- SELECT *  FROM  Trips;

-- DELETE FROM Registration_tickets WHERE tour_id = 1;
-- SELECT *  FROM  Trips;
-- ----------------------------------------------------------------------------------------------------------   



DELIMITER //
	CREATE TRIGGER Before_Trip_schedules_insert
	Before INSERT ON Trip_schedules FOR EACH ROW  
    BEGIN
		IF NEW.schedule_number not In (SELECT Tour_schedules.schedule_number FROM Tour_schedules WHERE Tour_schedules.tour_id = NEW.tour_id) THEN
			 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'lịch trình chuyến không tồn tại lịch trình trong tour';
        END IF;
    END
//
DELIMITER ;
-- test
-- INSERT INTO Trip_schedules (tour_id, departure_date, schedule_number) VALUES (1, '2023-03-08', 4);
-- INSERT INTO Trip_schedules (tour_id, departure_date, schedule_number) VALUES (2, '2023-04-21', 2);
-- ----------------------------------------------------------------------------------------------------------   


DELIMITER //
	CREATE TRIGGER Before_Trip_service_providers_insert
	Before INSERT ON Trip_service_providers FOR EACH ROW  
    BEGIN
		IF NEW.service_type != '8' AND NEW.service_type not In (SELECT TSA.action_type FROM Tour_schedule_actions as TSA WHERE TSA.tour_id = NEW.tour_id AND TSA.schedule_number = NEW.schedule_number) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'loại cung cấp chuyến không tồn tại trong hoặc động tour';
        END IF;
    END
//
DELIMITER ;

-- test
-- INSERT INTO Trip_service_providers (tour_id, departure_date, schedule_number, service_type, service_provider_id) VALUES (1, '2023-03-08', 3, '5', 'DV0002');
-- ----------------------------------------------------------------------------------------------------------  



-- !chèn bảng chi nhánh
INSERT INTO Branches (branch_name, Region, Address, Email, Fax, Manager_Id) 
VALUES 
	('CN_PY1','Phú Yên', '123 Nguyễn Huệ, phường 5, Tuy Hòa, Phú Yên', 'CN_PY1@gamil.com', 'fax1', NULL),
	('CN_PY2', 'Phú Yên', '247 Đinh Tiên Hoàng, Phường Phú Đông, Tuy Hòa, Phú Yên', 'CN_PY2@gamil.com', 'fax2', NULL),
	('CN_KH1', 'Khánh Hòa', '267 Duy Tân, Phường 3, Nha Trang, Khánh Hòa', 'CN_NT1@gamil.com', 'fax3', NULL),
	('CN_BD1', 'Bình Định', '47 Ngô Gia Tự, Phường 3, Quy Nhơn, Bình Định', 'CN_BĐ1@gamil.com', 'fax4', NULL);
	
-- ----------------------------------------------------------------------------------------------


-- !chèn bảng số điện thoại chi nhánh
INSERT INTO Branch_phones (branch_id, phone_number)
VALUES
	('CN1', '1234567890'),
	('CN1', '9876543210'),
	('CN2', '2345678901'),
	('CN2', '0987654321'),
	('CN3', '3456789012'),
	('CN3', '1098765432'),
	('CN4', '4567890123'),
	('CN4', '2109876543'),
	('CN1', '1112223333'),
	('CN2', '4445556666'),
	('CN3', '7778889999'),
	('CN4', '0001112222'),
	('CN1', '6667778888'),
	('CN2', '9990001111'),
	('CN3', '2223334444'),
	('CN4', '5556667777');

-- INSERT INTO Branch_phones (branch_id, phone_number) VALUES ('CN0','02');
-- INSERT INTO Branch_phones (branch_id, phone_number) VALUES (4,null);
-- -----------------------------------------------------------------------------------------------


-- !chèn bảng nhân viên
INSERT INTO Employees (employee_id, cmnd, full_name, address, gender, date_of_birth, employee_type, position, branch_id) 
VALUES
	('HD0001', '0000000001', 'Đào Duy Long','Phú Yên', 'M', '2003-12-25',2 ,'Hướng Dẫn Viên', 'CN1'),
    ('VP0002', '0000000002', 'Nguyễn Đức Đạt','Đồng nai', 'M', '2003-6-25',1 ,'Quản lý chi nhánh', 'CN1'),
    ('VP0003', '0000000003', 'Nguyễn Thị Hạnh','Bình Định', 'F', '2000-6-25',1 ,'Nhân viên văn phòng', 'CN1'),
    ('HD0004', '0000000004', 'Huỳnh Kim','Bình Định', 'M', '1999-6-25',2 ,'Hướng Dẫn Viên', 'CN1'),
    ('VP0005', '0000000005', 'Nguyễn Đức Vũ','Phú Yên', 'M', '2001-6-25',1 ,'Quản lý chi nhánh', 'CN2'),
    ('VP0006', '0000000006', 'Bùi Lê Văn','Phú Yên', 'M', '2003-8-25',1 ,'Quản lý chi nhánh', 'CN3'),
    ('HD0007', '0000000007', 'Nguyễn Đức Vũ','Phú Yên', 'M', '2003-6-25',2 ,'Hướng Dẫn Viên', 'CN3');

-- INSERT INTO Employees (employee_id, cmnd, full_name, employee_type, branch_id) 
-- VALUES ('VD1101', '0000222222', 'lodfasn1g3', 1,'CN1');
-- INSERT INTO Employees (employee_id, cmnd, full_name, employee_type, branch_id) 
-- VALUES ('HD0124', '0000223212', 'lodfasn1g3',2,'CN1');
-- -----------------------------------------------------------------------------------------------


-- !cập nhật nhân viên làm chủ cho chi nhánh
UPDATE Branches SET Manager_Id = 'VP0002' WHERE Manager_Id is NULL AND branch_id = 'CN1';
UPDATE Branches SET Manager_Id = 'VP0005' WHERE Manager_Id is NULL AND branch_id = 'CN2';
UPDATE Branches SET Manager_Id = 'VP0006' WHERE Manager_Id is NULL AND branch_id = 'CN3';
-- UPDATE Branches SET Manager_Id = 'VP0009' WHERE branch_id = 'CN4';
-- -----------------------------------------------------------------------------------------------


-- !kĩ năng ngôn ngữ 
INSERT INTO Employee_languages (employee_id, language) VALUES
	('HD0001', 'Tiếng Anh'),
	('HD0001', 'Tiếng Trung'),
	('HD0004', 'Tiếng Nhật'),
	('HD0004', 'Tiếng Anh');
    
-- INSERT INTO Employee_languages (employee_id, language) VALUES ('VP0002', 'Tiếng Anh');   
-- INSERT INTO employee_skills (employee_id, skill) VALUES ('HD0011', Tiếng Anh');  
-- -----------------------------------------------------------------------------------------------


-- !kĩ năng khác
INSERT INTO employee_skills (employee_id, skill) VALUES
	('HD0001', 'Thuyết trình'),
	('HD0001', 'Lập kế hoạch'),
	('HD0001', 'Phân tích dữ liệu'),
	('HD0004', 'Thuyết trình');
-- INSERT INTO employee_skills (employee_id, skill) VALUES ('VP0002', 'Phân tích dữ liệu');  
-- INSERT INTO employee_skills (employee_id, skill) VALUES ('HD0011', 'Phân tích dữ liệu');    
-- -----------------------------------------------------------------------------------------------


-- !điểm du lịch
INSERT INTO Tourist_attractions (attraction_name, address, ward, district, province, photo_1, photo_2, photo_3, description, note) VALUES
	('Kè chắn sóng Xóm Rớ', 'Bờ biển, Phường Phú Đông, thành phố Tuy Hòa, tỉnh Phú Yên', 'Phú Đông', 'Tuy Hòa', 'Phú yên', 'https://52hz.vn/wp-content/uploads/2022/08/ke-chan-song-xom-ro-o-dau.jpg', 'https://52hz.vn/wp-content/uploads/2022/08/ke-chan-song-xom-ro-2.jpg', 'https://52hz.vn/wp-content/uploads/2022/08/ke-chan-song-xom-ro-phu-yen.jpg', 'Tự nhiên', 'Nên đi mùa hè'),
	('Tháp Nghinh Phong', '25 Duy Tân, Phường 6, thành phố Tuy Hòa, tỉnh Phú Yên', 'Phường 6', 'Tuy Hòa', 'Phú yên','https://image.nhandan.vn/w790/Files/Images/2021/05/28/thapnghingphong-1622190911103.jpg','https://image.nhandan.vn/w790/Files/Images/2021/05/28/thap2-1622190934022.jpg', 'https://zoomtravel.vn/upload/images/thap-nghinh-phong-ve-dem.jpg', 'Nhân tạo', 'tất cả các mùa'),
	('Vũng Rô', '256 quốc lộ 3,Đông Hòa,  tỉnh Phú Yên', null, 'Đông Hòa', 'Phú yên', 'https://52hz.vn/wp-content/uploads/2022/08/vinh-vung-ro-gioi-thieu.jpg', 'https://52hz.vn/wp-content/uploads/2022/08/vinh-vung-ro-co-gi-choi.jpg', 'https://52hz.vn/wp-content/uploads/2022/08/vinh-vung-ro-phu-yen.jpg', 'Điểm cực Đông tổ quốc', 'tất cả các mùa'),
    ('Vinpearl Land', '98B/13, Trần Phú, Lộc Thọ, Thành phố Nha Trang, Khánh Hòa', 'Lộc Thọ', 'Nha Trang', 'Khánh Hòa', 'https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/04/vinpearl-nha-trang-768x432.jpg', 'https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/04/vinpearl-nha-trang-1-1.jpg', 'https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/04/cong-vien-vinpearl-nha-trang.jpg', 'Thủy cungc', 'tất cả các mùa');
-- -----------------------------------------------------------------------------------------------


-- !Dịch dụ 
INSERT INTO Service_providers (provider_id, provider_name, email, phone_number, representative_name, representative_phone_number, address, ward, district, province, photo_1, photo_2, photo_3, photo_4, photo_5, service_type, note) VALUE
	('DV0001', 'khách sạn biển Tuy Hòa', 'bientuyhoa@gamil.com', '0555566785', 'Nguyễn Văn Nghĩa', '0457869124', '256 Nguyễn Huệ, Phương 1, Tuy Hòa, Phú Yên', 'Phương 1', ' Tuy Hòa', 'Phú Yên', null, null, null, null, null, '1', 'khách sạn 5 sao'),
	('DV0002', 'Vận chuyển Vũ', 'vanchuyenvu@gamil.com', '0555566456', 'Nguyễn Văn Dũng', '0457869178', '200 Nguyễn Huệ, Phương 1, Tuy Hòa, Phú Yên', 'Phương 1', ' Tuy Hòa', 'Phú Yên', null, null, null, null, null, '2', 'xe 4,8,12,16 chỗ'),
	('DV0003', 'Vận chuyển Tùng', 'vanchuyentung@gamil.com', '0555896456', 'Trần Tùng', '0454569178', '250 Nguyễn Huệ, Phương 1, Tuy Hòa, Phú Yên', 'Phương 1', ' Tuy Hòa', 'Phú Yên', null, null, null, null, null, '2', NULL),
	('DV0004', 'Nhà hàng A', 'nhahangA@gamil.com', '0412589656', 'Trần Ngân', '0454568978', '240 Nguyễn Huệ, Phương 1, Tuy Hòa, Phú Yên', 'Phương 1', ' Tuy Hòa', 'Phú Yên', null, null, null, null, null, '3', NULL),
	('DV0005', 'Nhà hàng B', 'nhahangB@gamil.com', '0432586456', 'lý Văn', '0454368978', '40 Nguyễn Huệ, Phương 1, Tuy Hòa, Phú Yên', 'Phương 1', ' Tuy Hòa', 'Phú Yên', null, null, null, null, null, '3', NULL),
	('DV0006', 'Nhà hàng C', 'nhahangC@gamil.com', '0425896456', 'Lý Ngân', '0452568978', '50 Nguyễn Huệ, Phương 1, Tuy Hòa, Phú Yên', 'Phương 1', ' Tuy Hòa', 'Phú Yên', null, null, null, null, null, '3', NULL),
	('DV0007', 'Nhà hàng D', 'nhahangD@gamil.com', '0443296456', 'Kim Ngân', '0451568978', '10 Nguyễn Huệ, Phương 1, Tuy Hòa, Phú Yên', 'Phương 1', ' Tuy Hòa', 'Phú Yên', null, null, null, null, null, '3', NULL);

-- -----------------------------------------------------------------------------------------------


-- !khách hàng
INSERT INTO Customers (customer_id, cmnd, full_name, email, phone_number, date_of_birth, address)
VALUES
	('KH0001', '100000001', 'Nguyễn Văn A', 'a@gmail.com', '0901234567', '1990-01-01', '123 Phố Lý Thái Tổ, quận Hoàn Kiếm, Hà Nội'),
	('KH0002', '100000002', 'Trần Thị B', 'b@gmail.com', '0923456789', '1991-02-02', '456 Phố Nguyễn Thái Học, quận Ba Đình, Hà Nội'),
	('KH0003', '100000003', 'Lê Quang C', 'c@gmail.com', '0945678901', '1992-03-03', '789 Phố Đinh Tiên Hoàng, quận 1, Thành phố Hồ Chí Minh'),
	('KH0004', '100000004', 'Phạm Thị D', 'd@gmail.com', '0967890123', '1993-04-04', '101 Phường 7, thành phố Đà Lạt, tỉnh Lâm Đồng'),
	('KH0005',NULL, 'Đặng Thị E', 'e@gmail.com', '0989012345', '2013-05-05', '123 Phố Nguyễn Huệ, quận 1, Thành phố Hồ Chí Minh'),
	('KH0006', NULL, 'Hồ Thị F', 'f@gmail.com', '0902345678', '2012-06-06', '456 Phố Trần Hưng Đạo, quận Hoàn Kiếm, Hà Nội'),
	('KH0007', '100000007', 'Nguyễn Thị G', 'g@gmail.com', '0923456789', '1996-07-07', '789 Phố Lê Duẩn, phường Hòa Phú, thành phố Đà Nẵng'),
	('KH0008', NULL, 'Trần Quang H', 'h@gmail.com', '0945678901', '2005-08-08', '101 Phường 3, thành phố Đà Lạt, tỉnh Lâm Đồng'),
	('KH0009', NULL, 'Phạm Thị I', 'i@gmail.com', '0967890123', '2010-09-09', '123 Phố Nguyễn Thái Học, quận Ba Đình, Hà Nội'),
	('KH0010', NULL, 'Đặng Thị J', 'j@gmail.com', '0989012345', '2020-10-10', '456 Phố Trần Hưng Đạo, quận Hoàn Kiếm, Hà Nội');

-- INSERT INTO Customers (customer_id, full_name, phone_number) VALUES ('KD0011', 'Nguyễn Văn B', '0901234567');
-- INSERT INTO Customers (customer_id, full_name, phone_number) VALUES ('KH011a', 'Nguyễn Văn B', '0901234567');
-- ----------------------------------------------------------------------------------------------------------


-- !đoàn khách
INSERT INTO Customers_groups (group_id, agency_name, email, phone_number, address, representative_id)
VALUES
	('KD0001', 'ĐOÀN A', 'a@gmail.com', '0901234567', '123 Phố Lý Thái Tổ, quận Hoàn Kiếm, Hà Nội', 'KH0001'),
	('KD0002', 'ĐOÀN B', 'b@gmail.com', '0923456789', '456 Phố Nguyễn Thái Học, quận Ba Đình, Hà Nội', 'KH0002'),
	('KD0003', 'ĐOÀN C', 'c@gmail.com', '0945678901', '789 Phố Đinh Tiên Hoàng, quận 1, Thành phố Hồ Chí Minh', 'KH0003'),
	('KD0004', 'ĐOÀN D', 'd@gmail.com', '0967890123', '101 Phường 7, thành phố Đà Lạt, tỉnh Lâm Đồng', 'KH0004');

-- INSERT INTO Customers_groups (group_id, agency_name, email, phone_number, address, representative_id)
-- VALUES ('KH0001', 'ĐOÀN A', 'a@gmail.com', '0901234567', '123 Phố Lý Thái Tổ, quận Hoàn Kiếm, Hà Nội', 'KH0001');
-- INSERT INTO Customers_groups (group_id, agency_name, email, phone_number, address, representative_id)
-- VALUES ('KD0005', 'ĐOÀN A', 'a@gmail.com', '0901234567', '123 Phố Lý Thái Tổ, quận Hoàn Kiếm, Hà Nội', 'KH0020');
-- ----------------------------------------------------------------------------------------------------------


-- !khách trong đoàn
INSERT INTO group_individual_customers (group_id, customer_id)
VALUES
	('KD0001', 'KH0001'),
	('KD0001', 'KH0002'),
	('KD0001', 'KH0003'),
	('KD0001', 'KH0004'),
	('KD0002', 'KH0002'),
	('KD0002', 'KH0007'),
	('KD0002', 'KH0008'),
	('KD0002', 'KH0009'),
	('KD0003', 'KH0003'),
	('KD0003', 'KH0001'),
	('KD0003', 'KH0002'),
	('KD0003', 'KH0009'),
	('KD0003', 'KH0004'),
	('KD0003', 'KH0010'),
	('KD0004', 'KH0004');

-- INSERT INTO group_individual_customers (group_id, customer_id) VALUES ('KH0002', 'KH0001');
-- ----------------------------------------------------------------------------------------------------------


-- !tour du lịch
INSERT INTO Tours (tour_name, photo, start_date, min_tour_guests, max_tour_guests, single_adult_price, single_child_price, group_adult_price, group_child_price, min_group_guests, nights, days, branch_id)
VALUES
	('Tour Phú yên mùa xuân', 'tour_1.jpg', '2023-03-08', 4, 10, 100000, 50000, 80000, 40000, 4, 3, 2, 'CN1'),
	('Tour Phú yên tháng 4', 'tour_2.jpg', '2023-04-15', 4, 10, 150000, 75000, 120000, 60000, 3, 0, 1, 'CN1'),
	('Tour Phú Yên mùa hè', 'tour_3.jpg', '2022-05-22', 6, 12, 200000, 100000, 160000, 80000, 4, 2, 3, 'CN1'),
	('Tour Nha Trang mùa hè', 'tour_4.jpg', '2020-06-29', 8, 14, 250000, 125000, 200000, 100000, 5, 5, 5, 'CN2');

-- INSERT INTO Tours (tour_name, photo, start_date, min_tour_guests, max_tour_guests, single_adult_price, single_child_price, group_adult_price, group_child_price, min_group_guests, nights, days, branch_id)
-- VALUES ('Tour Phú yên mùa xuân', 'tour_1.jpg', '2023-03-08', 4, 10, 1000, 1500, 800, 400, 4, 3, 2, 'CN1');
-- VALUES ('Tour Phú yên mùa xuân', 'tour_1.jpg', '2023-03-08', 4, 10, 1000, 1500, 800, 400, 4, 3, 2, 'CN1');
-- ----------------------------------------------------------------------------------------------------------


-- !ngày khởi hành của tour dài ngày
INSERT INTO Long_day_tour_departure_dates (tour_id, day)
VALUES
	('CN1-000001', 6),
	('CN1-000001', 15),
	('CN1-000001', 20),
	('CN1-000001', 30),
	('CN1-000003', 11),
	('CN1-000003', 2),
	('CN2-000004', 3),
	('CN2-000004', 21),
	('CN2-000004', 15);
    
-- INSERT INTO Long_day_tour_departure_dates (tour_id, day)
-- VALUES ('CN1-000002', 32);
-- ----------------------------------------------------------------------------------------------------------


-- !lịch trình tour
INSERT INTO Tour_schedules (tour_id, schedule_number)
VALUES
	('CN1-000001', 1),
	('CN1-000001', 2),
	('CN1-000001', 3),
	('CN1-000002', 1),
	('CN1-000003', 1),
	('CN1-000003', 2),
	('CN2-000004', 1),
	('CN2-000004', 2),
	('CN2-000004', 3),
	('CN2-000004', 4),
	('CN2-000004', 5);

-- ----------------------------------------------------------------------------------------------------------

-- !tham quan
INSERT INTO Tour_destinations (tour_id, schedule_number, point_of_interest_id, start_time, end_time, description)
VALUES
	('CN1-000001', 1, 1, '8:00:00', '9:00:00', 'tham quan Kè chắn sóng Xóm Rớ'),
	('CN1-000001', 1, 2, '15:00:00', '17:00:00', 'tham quan tháp nghiêm phong'),
	('CN1-000001', 2, 3, '8:00:00', '12:00:00', 'tham quan vũng rô'),
	('CN1-000002', 1, 1, '8:00:00', '9:00:00', 'tham quan Kè chắn sóng Xóm Rớ'),
	('CN1-000002', 1, 2, '15:00:00', '17:00:00', 'tham quan tháp nghiêm phong');

-- INSERT INTO Tour_destinations (tour_id, schedule_number, point_of_interest_id, start_time, end_time, description)
-- VALUES ('CN1-000003', 1, 1, '7:00:00', '7:00:00', 'tham quan Kè chắn sóng Xóm Rớ');
-- ----------------------------------------------------------------------------------------------------------

-- !lịch trình hoặc động
INSERT INTO Tour_schedule_actions (tour_id, schedule_number, action_type, start_time, end_time, description)
VALUES
	('CN1-000001', 1, '1', '06:00:00', null, 'Khởi hành'),
	('CN1-000001', 1, '3', '07:00:00', '07:30:00', 'ăn sáng'),
	('CN1-000001', 1, '4', '12:00:00', '12:30:00', 'ăn trưa'),
	('CN1-000001', 1, '6', '13:00:00', '14:00:00', 'check in'),
	('CN1-000001', 1, '5', '18:00:00', '19:00:00', 'ăn tối'),
	('CN1-000001', 2, '3', '07:00:00', '07:30:00', 'ăn sáng'),
	('CN1-000001', 2, '4', '13:00:00', '14:00:00', 'ăn trưa'),
	('CN1-000001', 2, '5', '18:00:00', '19:00:00', 'ăn tối'),
	('CN1-000001', 3, '3', '07:00:00', '07:30:00', 'ăn sáng'),
	('CN1-000001', 3, '7', '09:00:00', '10:00:00', 'checkout'),
	('CN1-000001', 3, '2', '12:00:00', null, 'kết thúc');


-- INSERT INTO Tour_schedule_actions (tour_id, schedule_number, action_type, start_time, end_time, description)
-- VALUES (1, 3, '6', '06:00:00', '06:00:00', '1');
-- ----------------------------------------------------------------------------------------------------------


-- !chuyến đi
INSERT INTO Trips (tour_id, departure_date, arrival_date)
VALUES
	('CN1-000001', '2023-03-08', '2023-03-11'),
	('CN1-000001', '2023-05-15', '2023-05-18'),
	('CN1-000001', '2023-04-22', '2023-05-25'),
	('CN1-000002', '2023-04-21', '2023-04-21'),
    ('CN1-000001', '2024-01-22', '2024-01-25'),
    ('CN1-000002', '2024-05-22', '2024-05-25'),
    ('CN1-000002', '2024-07-22', '2024-07-25'),
    ('CN1-000002', '2024-09-22', '2024-09-25');
-- ----------------------------------------------------------------------------------------------------------

-- !Hướng dẫn viên dẫn chuyến di
INSERT INTO Tour_guides (tour_id, departure_date, guide_id)
VALUES
	('CN1-000001', '2023-05-15', 'HD0001'),
	('CN1-000001', '2023-05-15', 'HD0004'),
	('CN1-000001', '2023-03-08', 'HD0004'),
	('CN1-000001', '2023-03-08', 'HD0001'),
	('CN1-000002', '2023-04-21', 'HD0007');

-- INSERT INTO Tour_guides (tour_id, departure_date, guide_id) VALUES ('CN1-000001', '2023-03-08', 'HD002');
-- INSERT INTO Tour_guides (tour_id, departure_date, guide_id) VALUES ('CN1-000001', '2023-03-08', 'VP002');
-- ----------------------------------------------------------------------------------------------------------

-- !lịch ngày chuyến đi
INSERT INTO Trip_schedules (tour_id, departure_date, schedule_number)
VALUES
	('CN1-000001', '2023-03-08', 3),
	('CN1-000001', '2023-03-08', 2),
	('CN1-000001', '2023-05-15', 1),
	('CN1-000001', '2023-05-15', 2),
	('CN1-000001', '2023-03-08', 1),
	('CN1-000001', '2023-05-15', 3),
	('CN1-000002', '2023-04-21', 1),
    ('CN1-000001', '2024-01-22', 1),
    ('CN1-000002', '2024-05-22', 1),
    ('CN1-000002', '2024-07-22', 1),
    ('CN1-000002', '2024-09-22', 1);
    

-- ----------------------------------------------------------------------------------------------------------

-- !dịch vụ cung cấp
INSERT INTO Trip_service_providers (tour_id, departure_date, schedule_number, service_type, service_provider_id)
VALUES
	('CN1-000001', '2023-03-08', 2, '8', 'DV0002'),
	('CN1-000001', '2023-03-08', 3, '8', 'DV0003'),
	('CN1-000001', '2023-03-08', 1, '3', 'DV0004'),
	('CN1-000001', '2023-03-08', 1, '4', 'DV0005'),
	('CN1-000001', '2023-03-08', 1, '8', 'DV0002'),
	('CN1-000001', '2023-03-08', 1, '5', 'DV0006'),
	('CN1-000001', '2023-03-08', 1, '6', 'DV0001'),
	('CN1-000001', '2023-03-08', 2, '3', 'DV0004'),
	('CN1-000001', '2023-03-08', 2, '3', 'DV0005'),
	('CN1-000001', '2023-03-08', 2, '3', 'DV0006'),
	('CN1-000001', '2023-03-08', 2, '4', 'DV0005'),
	('CN1-000001', '2023-03-08', 2, '5', 'DV0006'),
	('CN1-000001', '2023-03-08', 3, '3', 'DV0004');

-- INSERT INTO Trip_service_providers (tour_id, departure_date, schedule_number, service_type, service_provider_id)
-- VALUES ('CN1-000001', '2023-03-08', 1, '1', 'DV0002');
-- ----------------------------------------------------------------------------------------------------------

-- !vé
INSERT INTO Registration_tickets (registration_date, note, sales_agent_id, individual_customer_id, group_id, tour_id, departure_date)
VALUES
	('2023-01-05', 'đi sớm 30p.', 'VP0002', 'KH0001', 'KD0001', 'CN1-000001', '2023-03-08'),
	('2023-02-06', 'đi sớm 30p.', 'VP0002', 'KH0002', 'KD0001', 'CN1-000001', '2023-03-08'),
	('2023-02-07', 'đi sớm 30p.', 'VP0003', 'KH0003', 'KD0001', 'CN1-000001', '2023-03-08'),
	('2023-02-05', 'đi sớm 30p.', 'VP0005', 'KH0007', 'KD0002', 'CN1-000001', '2023-03-08'),
	('2023-03-06', 'đi sớm 30p.', 'VP0006', 'KH0008', 'KD0002', 'CN1-000001', '2023-03-08'),
	('2023-03-07', 'đi sớm 30p.', 'VP0003', 'KH0009', 'KD0002', 'CN1-000001', '2023-03-08'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0010', null, 'CN1-000001', '2023-03-08'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0006', null, 'CN1-000001', '2023-03-08'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0007', null, 'CN1-000001', '2023-03-08'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0004', null, 'CN1-000001', '2023-03-08'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0005', null, 'CN1-000001', '2023-03-08'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0006', null, 'CN1-000001', '2023-03-08'),
	('2023-03-05', 'đi sớm 30p.', 'VP0005', 'KH0007', 'KD0002', 'CN1-000002', '2023-04-21'),
	('2023-04-06', 'đi sớm 30p.', 'VP0006', 'KH0008', 'KD0002','CN1-000002', '2023-04-21'),
	('2023-04-07', 'đi sớm 30p.', 'VP0003', 'KH0009', 'KD0002', 'CN1-000002', '2023-04-21'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0010', null, 'CN1-000002', '2023-04-21'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0006', null, 'CN1-000002', '2023-04-21'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0007', null, 'CN1-000002', '2023-04-21'),
	('2023-03-08', 'đi sớm 30p.', 'VP0006', 'KH0004', null, 'CN1-000002', '2023-04-21'),
	('2024-01-22', 'đi sớm 30p.', 'VP0006', 'KH0008', 'KD0002', 'CN1-000001', '2024-01-22'),
	('2024-01-22', 'đi sớm 30p.', 'VP0003', 'KH0009', 'KD0002', 'CN1-000001', '2024-01-22'),
	('2024-01-22', 'đi sớm 30p.', 'VP0006', 'KH0010', null, 'CN1-000001', '2024-01-22'),
	('2024-01-22', 'đi sớm 30p.', 'VP0006', 'KH0006', null, 'CN1-000001', '2024-01-22'),
	('2024-01-22', 'đi sớm 30p.', 'VP0003', 'KH0009', 'KD0002', 'CN1-000002', '2024-05-22'),
	('2024-01-22', 'đi sớm 30p.', 'VP0006', 'KH0010', null, 'CN1-000002', '2024-05-22'),
	('2024-01-22', 'đi sớm 30p.', 'VP0003', 'KH0009', 'KD0002', 'CN1-000002', '2024-07-22'),
	('2024-01-22', 'đi sớm 30p.', 'VP0006', 'KH0010', null, 'CN1-000002', '2024-07-22'),
	('2024-01-22', 'đi sớm 30p.', 'VP0003', 'KH0009', 'KD0002', 'CN1-000002', '2024-09-22'),
	('2024-01-22', 'đi sớm 30p.', 'VP0006', 'KH0010', null, 'CN1-000002', '2024-09-22');
-- ----------------------------------------------------------------------------------------------------------    


-- !kết nối dịch vụ điểm tham quan và tour
INSERT INTO related_service_providers (tour_id, point_id, provider_id)
VALUES
	('CN1-000001', 1, 'DV0002'),
	('CN1-000001', 1, 'DV0003'),
	('CN1-000001', 1, 'DV0004'),
	('CN1-000001', 1, 'DV0001'),
	('CN1-000001', 1, 'DV0005'),
	('CN1-000001', 1, 'DV0006'),
	('CN1-000001', 2, 'DV0001'),
	('CN1-000001', 2, 'DV0002'),
	('CN1-000001', 2, 'DV0003'),
	('CN1-000001', 2, 'DV0004'),
	('CN1-000001', 2, 'DV0005'),
	('CN1-000001', 2, 'DV0006'),
	('CN1-000001', 3, 'DV0004');

-- ----------------------------------------------------------------------------------------------------------   


--  STORE PROCEDURE, FUNCTION ------------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE LichTrinhChuyen(
	IN tour_id VARCHAR(12),
    IN departure_date DATE
)
BEGIN
	if (SELECT count(*) FROM Trips as T WHERE tour_id = t.tour_id AND departure_date = t.departure_date) = 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'không tìm thấy chuyến đi';
    END IF;
SELECT days as 'ngày', start as 'thời gian bắt đầu', end as 'thời gian kết thúc', service_type as  'loại dịch vụ', supplier as 'nhà cung cấp' 
FROM(
	SELECT
		DATE_ADD( departure_date  ,INTERVAl TSA.schedule_number DAY) as days, start_time as start, end_time as end,
		CASE TSA.action_type
			WHEN 1 THEN 'khởi hành tour'
			WHEN 2 THEN 'kết thúc tour'
			WHEN 3 THEN 'ăn sáng'
			WHEN 4 THEN 'ăn trưa'
			WHEN 5 THEN 'ăn tối'
			WHEN 6 THEN 'check in'
			WHEN 7 THEN 'checkout khách sạn, khởi hành về'
			WHEN 8 THEN 'Vận chuyển'
		END as service_type,
        IF(TSA.action_type in ('1','2','7'),
			(SELECT Tours.branch_id
			FROM Tours
            WHERE Tours.tour_id = tour_id),
			(SELECT Service_providers.provider_name
			FROM Service_providers
			WHERE Service_providers.provider_id = TSP.service_provider_id)) as supplier
	FROM(
		SELECT T.tour_id as tour_id, T.departure_date as departure_date, TSP.schedule_number as schedule_number, TSP.service_type, TSP.service_provider_id 
		FROM Trips as T left join Trip_service_providers AS TSP On T.tour_id = TSP.tour_id AND T.departure_date = TSP.departure_date 
        WHERE T.departure_date = departure_date
	  ) AS TSP Right JOIN Tour_schedule_actions AS TSA ON TSP.tour_id = TSA.tour_id  AND TSP.schedule_number = TSA.schedule_number AND (TSP.service_type = TSA.action_type)
	WHERE tour_id = TSA.tour_id
    
    UNION
    
    SELECT 
		DATE_ADD(departure_date ,INTERVAl TS.schedule_number DAY) as days, null as start, null as end,
		'vận chuyển' as service_type,
		(SELECT Service_providers.provider_name
		FROM Service_providers
		WHERE Service_providers.provider_id = TSP.service_provider_id) as supplier       
	 FROM(
		SELECT T.tour_id as tour_id, T.departure_date as departure_date, TSP.schedule_number as schedule_number, TSP.service_type, TSP.service_provider_id 
		FROM Trips as T left join Trip_service_providers AS TSP On T.tour_id = TSP.tour_id AND T.departure_date = TSP.departure_date   
        WHERE  departure_date  = T.departure_date   and TSP.service_type = '8'
		) AS TSP
		right JOIN Tour_schedules as TS ON TS.tour_id = TSP.tour_id AND TS.schedule_number = TSP.schedule_number 
	WHERE  tour_id = TS.tour_id
    
	UNION
		
	SELECT 
		DATE_ADD(departure_date ,INTERVAl TS.schedule_number DAY) as days, start_time as start, end_time as end,
		'Thăm quan' as service_type,
		(SELECT Tourist_attractions.attraction_name
		FROM Tourist_attractions
		WHERE Tourist_attractions.attraction_id = TD.point_of_interest_id) as supplier
	FROM
		Tour_schedules as TS JOIN Tour_destinations AS TD ON TS.tour_id = TD.tour_id AND TS.schedule_number = TD.schedule_number
	WHERE TS.tour_id = tour_id
    ) AS t
	ORDER BY t.days, t.start;
END;

//
DELIMITER ;
-- test
-- call LichTrinhChuyen('CN1-000001', '2023-03-08'); 
-- call LichTrinhChuyen('CN1-000001', '2023-05-15'); 
-- call LichTrinhChuyen('CN1-000002', '2023-04-21');
-- call LichTrinhChuyen('CN1-000002', '2024-07-22');
-- call LichTrinhChuyen('CN1-000002', '2024-01-22');

-- select * from Trips



DELIMITER //
CREATE PROCEDURE ThongKeDoanhThu(
	IN nam YEAR
)
BEGIN
	SELECT fullMonth.thang as 'Tháng' , if(total_price_month is not null, total_price_month, 0 ) as 'Tổng doanh thu (VNĐ)'
    FROM  (
		SELECT 1 as thang
		UNION SELECT 2
		UNION SELECT 3
		UNION SELECT 4
		UNION SELECT 5
		UNION SELECT 6
		UNION SELECT 7
		UNION SELECT 8
		UNION SELECT 9
		UNION SELECT 10
		UNION SELECT 11
		UNION SELECT 12
	) as fullMonth  left JOIN 
    (SELECT month(departure_date) as thang, SUM(total_price) as total_price_month FROM Trips where YEAR(departure_date) = nam GROUP BY thang) 
    as Trips ON Trips.thang = fullMonth.thang
    ORDER BY fullMonth.thang;
END;
//
DELIMITER ;
-- test
-- CALL ThongKeDoanhThu(2023)
-- CALL ThongKeDoanhThu(2024)
-- CALL ThongKeDoanhThu(2022)


-- thêm thống kê số lượng tham quan tại các điểm du lịch
DELIMITER //
CREATE FUNCTION SoLuongKhach(
	tour_id VARCHAR(12), 
    departure_date DATE
) 
RETURNS int 
DETERMINISTIC
BEGIN
  DECLARE SoLuong INT;
  SELECT COUNT(*) INTO Soluong
  FROM Registration_tickets as R
  where R.tour_id = tour_id AND R.departure_date = departure_date;
  if Soluong is null then
	return 0;
  end if;
  RETURN SoLuong;
END;

//
DELIMITER ;
-- test
-- SELECT tour_id, departure_date, SoLuongKhach(tour_id, departure_date)  FROM Trips;


DELIMITER //
CREATE FUNCTION SoLuongKhachTour(
	tour_id VARCHAR(12),
    NAM YEAR
)
RETURNS int 
DETERMINISTIC
BEGIN
	DECLARE total INT;
	SELECT sum(SoLuongKhach(tours.tour_id, departure_date)) INTO total
	FROM tours LEFT JOIN trips on  tours.tour_id = trips.tour_id
	WHERE tours.tour_id = tour_id AND year(departure_date) = nam;
    IF total is null then
		return 0;
	END IF;
    RETURN total;
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE SoLuongKhachDiemDuLich(
	IN NAM YEAR
)
BEGIN
	 SELECT attraction_name as 'điểm du lịch', IF(tour_id is null, 0 ,sum(SoLuongKhachTour(tour_id,NAM))) as 'số lượng khách'
     FROM (SELECT DISTINCT attraction_name,tour_id FROM Tourist_attractions as TA LEFT JOIN Tour_destinations as TD ON TD.point_of_interest_id = TA.attraction_id) as T
     GROUP BY attraction_name
     ORDER BY 'số lượng khách';
END;
//
DELIMITER ;

call SoLuongKhachDiemDuLich(2023);
