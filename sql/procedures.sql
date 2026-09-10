-- Процедура по количеству отправлений по типам за день в отделении

DELIMITER //
CREATE PROCEDURE pros1(IN office_id INT, IN target_date DATE)
BEGIN
    DECLARE office_exists INT;

    SELECT COUNT(*) INTO office_exists
    FROM postal_offices
    WHERE postal_office_id = office_id;

    IF office_exists = 0 THEN
        SELECT 'Ошибка: почтовое отделение не найдено' AS message;
    ELSE
        SELECT
            st.type_name,
            COUNT(*) AS shipment_count
        FROM shipments s
        JOIN shipment_types st ON s.type_id = st.type_id
        WHERE s.postal_office_id = office_id
          AND DATE(s.date_sent) = target_date
        GROUP BY st.type_id;

        IF FOUND_ROWS() = 0 THEN
            SELECT CONCAT('Нет отправлений за ', target_date, ' в отделении ', office_id) AS message;
        END IF;
    END IF;
END //
DELIMITER ;


-- Список сотрудников с количеством отправлений по типам

DELIMITER //
CREATE PROCEDURE pros2()
BEGIN
    DECLARE shipment_count INT;

    SELECT COUNT(*)
    INTO shipment_count
    FROM employees e
    JOIN shipments s ON e.employee_id = s.employee_id
    JOIN shipment_types st ON s.type_id = st.type_id;

    IF shipment_count = 0 THEN
        SELECT 'Ошибка: нет отправлений для сотрудников' AS message;
    ELSE
        SELECT
            e.last_name,
            st.type_name,
            COUNT(*) AS count
        FROM employees e
        JOIN shipments s ON e.employee_id = s.employee_id
        JOIN shipment_types st ON s.type_id = st.type_id
        GROUP BY e.employee_id, st.type_id
        ORDER BY e.last_name, count DESC;
    END IF;
END //
DELIMITER ;


-- Дата первого отправления клиента

DELIMITER //
CREATE PROCEDURE pros3(IN input_client_id INT)
BEGIN
    DECLARE client_exists INT;
    DECLARE first_shipment_date DATE;

    SELECT COUNT(*) INTO client_exists
    FROM clients
    WHERE client_id = input_client_id;

    IF client_exists = 0 THEN
        SELECT 'Ошибка: клиент не найден' AS message;
    ELSE
        SELECT MIN(date_sent) INTO first_shipment_date
        FROM shipments
        WHERE sender_id = input_client_id;

        IF first_shipment_date IS NULL THEN
            SELECT 'У клиента нет отправлений' AS message;
        ELSE
            SELECT first_shipment_date AS first_shipment_date;
        END IF;
    END IF;
END //
DELIMITER ;


-- Процедура для вывода расписания работы сотрудника

DELIMITER //
CREATE PROCEDURE pros4(IN emp_id INT)
BEGIN
    DECLARE emp_exists INT;

    SELECT COUNT(*) INTO emp_exists
    FROM employees
    WHERE employee_id = emp_id;

    IF emp_exists = 0 THEN
        SELECT 'Ошибка: сотрудник не найден' AS message;
    ELSE
        SELECT
            day_of_week,
            start_time,
            end_time
        FROM employee_schedules
        WHERE employee_id = emp_id
        ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

        IF FOUND_ROWS() = 0 THEN
            SELECT 'У сотрудника нет расписания' AS message;
        END IF;
    END IF;
END //
DELIMITER ;

