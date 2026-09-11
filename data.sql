-- заполнение регионов
INSERT INTO regions (region_name) VALUES
('Moscow Oblast'),
('Leningrad Oblast'),
('Krasnodar Krai'),
('Sverdlovsk Oblast'),
('Republic of Tatarstan');
-- заполнение городов
INSERT INTO cities (city_name, region_id) VALUES
('Moscow', 1),
('Khimki', 1),
('Saint Petersburg', 2),
('Gatchina', 2),
('Krasnodar', 3),
('Sochi', 3),
('Yekaterinburg', 4),
('Nizhny Tagil', 4),
('Kazan', 5),
('Naberezhnye Chelny', 5);
-- должности
INSERT INTO positions (position_name, salary) VALUES
('Director', '50000'),
('Postal Clerk', '40000'),
('Postman', '35000'),
('Sorter', '28000');
-- типы отправлений
INSERT INTO shipment_types (type_name, description, base_price,
max_weight) VALUES
('Letter', 'Standard postal letter', 50.00, 0.1),
('Parcel', 'Small package', 300.00, 10.0),
('EMS', 'Express mail service', 1200.00, 30.0);
-- добавление почтовых отделений
INSERT INTO postal_offices (name, city_id, address, working_hours)
VALUES
('Central Post Office', 1, '26 Myasnitskaya St', '09:00-20:00'),
('Khimki Post Office', 2, '12 Moskovskaya St', '09:00-18:00'),
('Main Post Office', 3, '9 Pochtamtskaya St', '08:00-20:00'),
('Gatchina Branch', 4, '25 Krasnaya St', '10:00-17:00'),
('Krasnodar Central', 5, '40 Krasnaya St', '08:00-19:00');
-- клиенты
INSERT INTO clients (first_name, last_name, passport_number,
phone_number) VALUES
('Ivan', 'Petrov', '4510123456', '+79161234567'),
('Elena', 'Sidorova', '4511123456', '+79162234567'),
('Alexey', 'Smirnov', '4512123456', '+79163234567'),
('Olga', 'Ivanova', '4513123456', '+79164234567'),
('Dmitry', 'Kuznetsov', '4514123456', '+79165234567'),
('Anna', 'Kozlova', '4515123456', '+79166234567'),
('Sergey', 'Morozov', '4516123456', '+79167234567');
('Maxim', 'Semenov', '4516123457', '+79161234568'),
('Daria', 'Petrova', '4517123456', '+79171234567'),
('Viktor', 'Kovalev', '4518123456', '+79181234567'),
('Svetlana', 'Fedorova', '4519123456', '+79191234567'),
('Anastasia', 'Romanova', '4520123456', '+79201234567');
-- добавление сотрудников
INSERT INTO employees (employee_id, first_name, last_name, position_id,
postal_office_id) VALUES
(1, 'Anna', 'Volkova', 1, 1), -- Director (Moscow)
(2, 'Sergey', 'Orlov', 2, 1), -- Postal Clerk (Moscow)
(3, 'Tatyana', 'Nikolaeva', 3, 1), -- Postman (Moscow)
(4, 'Pavel', 'Belov', 4, 1), -- Sorter (Moscow)
(5, 'Marina', 'Krylova', 2, 2), -- Postal Clerk (Khimki)
(6, 'Oleg', 'Vasilev', 3, 2), -- Postman (Khimki)
(7, 'Irina', 'Fedorova', 4, 2), -- Sorter (Khimki)
(8, 'Dmitry', 'Sokolov', 1, 3), -- Director (SPb)
(9, 'Ekaterina', 'Ivanova', 2, 3), -- Postal Clerk (SPb)
(10, 'Andrey', 'Petrov', 3, 3), -- Postman (SPb)
(11, 'Natalia', 'Smirnova', 4, 3), -- Sorter (SPb)
(12, 'Artem', 'Semenov', 2, 5), -- Postal Clerk (Krasnodar)
(13, 'Nadezhda', 'Petrenko', 3, 5), -- Postman (Krasnodar)
(14, 'Vladimir', 'Kuzmin', 4, 5); -- Sorter (Krasnodar)


-- заполнение расписания сотрудников
INSERT INTO employee_schedules (employee_id, day_of_week, start_time,
end_time) VALUES
(1, 'Monday', '09:00:00', '17:00:00'),
(1, 'Wednesday', '09:00:00', '17:00:00'),
(1, 'Friday', '09:00:00', '16:00:00'),
(2, 'Monday', '09:00:00', '15:00:00'),
(2, 'Tuesday', '12:00:00', '20:00:00'),
(2, 'Thursday', '09:00:00', '15:00:00'),
(2, 'Saturday', '10:00:00', '17:00:00'),
(5, 'Monday', '15:00:00', '20:00:00'),
(5, 'Tuesday', '09:00:00', '12:00:00'),
(5, 'Wednesday', '12:00:00', '20:00:00'),
(5, 'Friday', '12:00:00', '20:00:00'),
(3, 'Tuesday', '07:00:00', '15:00:00'),
(3, 'Thursday', '07:00:00', '15:00:00'),
(3, 'Saturday', '08:00:00', '14:00:00'),
(4, 'Monday', '14:00:00', '20:00:00'),
(4, 'Wednesday', '14:00:00', '20:00:00'),
(4, 'Friday', '14:00:00', '20:00:00'),
-- другое отделение
(6, 'Monday', '09:00:00', '18:00:00'),
(6, 'Wednesday', '09:00:00', '18:00:00'),
(6, 'Friday', '09:00:00', '18:00:00'),
(7, 'Tuesday', '07:30:00', '16:30:00'),
(7, 'Thursday', '07:30:00', '16:30:00'),
(8, 'Monday', '12:00:00', '18:00:00'),
(8, 'Wednesday', '12:00:00', '18:00:00'),
-- отделение СПб
(9, 'Tuesday', '08:00:00', '16:00:00'),
(9, 'Thursday', '08:00:00', '16:00:00'),
(10, 'Monday', '08:00:00', '16:00:00'),
(10, 'Wednesday', '08:00:00', '16:00:00'),
(10, 'Friday', '08:00:00', '16:00:00'),
(11, 'Tuesday', '06:00:00', '14:00:00'),
(11, 'Thursday', '06:00:00', '14:00:00'),
(12, 'Monday', '16:00:00', '20:00:00'),
(12, 'Wednesday', '16:00:00', '20:00:00'),
(13, 'Monday', '08:00:00', '16:00:00'),
(13, 'Wednesday', '08:00:00', '16:00:00'),
(13, 'Friday', '08:00:00', '16:00:00'),
(14, 'Tuesday', '07:00:00', '15:00:00'),
(14, 'Thursday', '07:00:00', '15:00:00');

-- Добавление отправлений
INSERT INTO shipments (type_id, sender_id, receiver_id, postal_office_id, origin, destination, date_sent, date_received, weight, cost, employee_id, status, notes) VALUES
(1, 1, 2, 1, 'Moscow', 'Saint Petersburg', '2024-05-01 10:30:00', '2024-05-03 14:00:00', 0.05, 50.00, 2, 'Delivered', 'Important letter'),
(2, 3, 4, 1, 'Moscow', 'Kazan', '2024-05-02 11:15:00', '2024-05-04 16:00:00', 2.50, 300.00, 5, 'Delivered', 'Book shipment'),
(3, 5, 6, 3, 'Saint Petersburg', 'Krasnodar', '2024-05-03 09:45:00', '2024-05-05 16:30:00', 5.00, 1200.00, 10, 'Delivered', 'Urgent documents'),
(1, 2, 3, 2, 'Khimki', 'Yekaterinburg', '2024-05-04 14:20:00', NULL, 0.08, 50.00, 6, 'In transit', 'Personal correspondence'),
(2, 4, 7, 5, 'Kazan', 'Sochi', '2024-05-05 16:00:00', NULL, 8.50, 300.00, 13, 'In transit', 'Gift package'),
(1, 6, 1, 4, 'Gatchina', 'Moscow', '2024-05-06 11:30:00', '2024-05-08 12:00:00', 0.1, 50.00, 8, 'Delivered', NULL),
(3, 7, 5, 1, 'Moscow', 'Naberezhnye Chelny', '2024-05-07 13:45:00', NULL, 12.0, 1200.00, 2, 'In transit', 'Business documents'),
(1, 8, 9, 2, 'Sochi', 'Kazan', '2024-05-08 10:00:00', NULL, 0.07, 55.00, 9, 'In transit', 'Letter to friends'),
(2, 9, 10, 3, 'Naberezhnye Chelny', 'Moscow', '2024-05-09 14:30:00', NULL, 3.00, 150.00, 11, 'In transit', 'Business correspondence'),
(3, 10, 11, 4, 'Moscow', 'Saint Petersburg', '2024-05-10 09:00:00', NULL, 4.50, 600.00, 12, 'In transit', 'Important documents'),
(1, 11, 12, 1, 'Krasnodar', 'Khimki', '2024-05-11 16:45:00', NULL, 0.09, 80.00, 2, 'In transit', 'Personal letter'),
(2, 12, 1, 5, 'Saint Petersburg', 'Yekaterinburg', '2024-05-12 13:15:00', NULL, 2.20, 350.00, 5, 'In transit', 'Gift package'),
(1, 1, 3, 2, 'Moscow', 'Sochi', '2024-05-13 11:00:00', NULL, 0.05, 60.00, 6, 'In transit', 'Follow-up letter'),
(2, 2, 4, 3, 'Khimki', 'Kazan', '2024-05-14 15:30:00', NULL, 1.50, 200.00, 10, 'In transit', 'Documents for review'),
(3, 3, 5, 1, 'Saint Petersburg', 'Naberezhnye Chelny', '2024-05-15 09:45:00', NULL, 6.00, 900.00, 12, 'In transit', 'Business proposal'),
(1, 4, 6, 4, 'Krasnodar', 'Moscow', '2024-05-16 12:00:00', NULL, 0.25, 70.00, 2, 'In transit', 'Letter to client'),
(2, 5, 7, 5, 'Sochi', 'Yekaterinburg', '2024-05-17 14:00:00', NULL, 3.50, 250.00, 3, 'In transit', 'Package for delivery'),
(1, 1, 2, 1, 'Moscow', 'Moscow', '2024-05-01 15:30:00', '2024-05-03 18:00:00', 0.500, 50.00, 2, 'Delivered', 'Important letter'),
(2, 2, 3, 1, 'Moscow', 'Saint Petersburg', '2025-01-10 11:20:00', '2025-01-12 15:30:00', 1.20, 250.00, 2, 'Delivered', 'New Year gifts'),
