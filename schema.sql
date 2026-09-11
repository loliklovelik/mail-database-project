
-- создание базы данных
CREATE DATABASE IF NOT EXISTS BD_kyrsovaiy;
USE BD_kyrsovaiy;
-- создание таблицы регионов
CREATE TABLE IF NOT EXISTS regions (
 region_id INT PRIMARY KEY AUTO_INCREMENT,
 region_name VARCHAR(50) NOT NULL UNIQUE
);
-- таблица городов
CREATE TABLE IF NOT EXISTS cities (
 city_id INT PRIMARY KEY AUTO_INCREMENT,
 city_name VARCHAR(50) NOT NULL,
 region_id INT NOT NULL,
 FOREIGN KEY (region_id) REFERENCES regions(region_id),
 UNIQUE (city_name, region_id)
);
-- таблица должностей
CREATE TABLE IF NOT EXISTS positions (
 position_id INT PRIMARY KEY AUTO_INCREMENT,
 position_name VARCHAR(50) NOT NULL UNIQUE,
 salary VARCHAR(20)
);
-- таблица типов отправлений
CREATE TABLE IF NOT EXISTS shipment_types (
 type_id INT PRIMARY KEY AUTO_INCREMENT,
 type_name VARCHAR(50) NOT NULL UNIQUE,
 description TEXT,
 base_price DECIMAL(10, 2) NOT NULL,
 max_weight DECIMAL(10, 3)
);
-- таблица почтовых отделений
CREATE TABLE IF NOT EXISTS postal_offices (
 postal_office_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(100) NOT NULL,
 city_id INT NOT NULL,
 address VARCHAR(255) NOT NULL,
 working_hours VARCHAR(100),
FOREIGN KEY (city_id) REFERENCES cities(city_id),
 UNIQUE (name, city_id)
);
-- таблица клиентов
CREATE TABLE IF NOT EXISTS clients (
 client_id INT PRIMARY KEY AUTO_INCREMENT,
 first_name VARCHAR(50) NOT NULL,
 last_name VARCHAR(50) NOT NULL,
 passport_number VARCHAR(20) NOT NULL UNIQUE,
 phone_number VARCHAR(15) NOT NULL
);
-- таблица сотрудников
CREATE TABLE IF NOT EXISTS employees (
 employee_id INT PRIMARY KEY AUTO_INCREMENT,
 first_name VARCHAR(50) NOT NULL,
 last_name VARCHAR(50) NOT NULL,
 position_id INT NOT NULL,
 postal_office_id INT NOT NULL,
 FOREIGN KEY (position_id) REFERENCES positions(position_id),
 FOREIGN KEY (postal_office_id) REFERENCES
postal_offices(postal_office_id)
);
-- таблица расписания сотрудников
CREATE TABLE IF NOT EXISTS employee_schedules (
 schedule_id INT PRIMARY KEY AUTO_INCREMENT,
 employee_id INT NOT NULL,
 day_of_week
ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sun
day') NOT NULL,
 start_time TIME NOT NULL,
 end_time TIME NOT NULL,
 FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
 UNIQUE (employee_id, day_of_week)
);
-- таблица отправлений
CREATE TABLE IF NOT EXISTS shipments (
 shipment_id INT PRIMARY KEY AUTO_INCREMENT,
 type_id INT NOT NULL,
 sender_id INT NOT NULL,
 receiver_id INT NOT NULL,
 postal_office_id INT NOT NULL,
 origin VARCHAR(100) NOT NULL,
 destination VARCHAR(100) NOT NULL,
 date_sent DATETIME NOT NULL,
 date_received DATETIME,
 weight DECIMAL(10, 3) NOT NULL,
 cost DECIMAL(10, 2) NOT NULL,
 employee_id INT NOT NULL,
 status ENUM('Registered','In transit','Delivered','Returned') DEFAULT
'Registered',
 notes TEXT,
 FOREIGN KEY (type_id) REFERENCES shipment_types(type_id),
 FOREIGN KEY (sender_id) REFERENCES clients(client_id),
 FOREIGN KEY (receiver_id) REFERENCES clients(client_id),
 FOREIGN KEY (postal_office_id) REFERENCES
postal_offices(postal_office_id),
 FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
