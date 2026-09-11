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


-- Суммарная стоимость отправлений по сотруднику

DELIMITER //
CREATE PROCEDURE pros5(IN emp_id INT)
BEGIN
    DECLARE emp_exists INT;
    DECLARE total DECIMAL(10, 2);

    SELECT COUNT(*) INTO emp_exists
    FROM employees
    WHERE employee_id = emp_id;

    IF emp_exists = 0 THEN
        SELECT 'Ошибка: сотрудник не найден' AS message;
    ELSE
        SELECT COALESCE(SUM(cost), 0) INTO total
        FROM shipments
        WHERE employee_id = emp_id;

        IF total = 0 THEN
            SELECT 'Нет данных о отправлениях' AS message;
        ELSE
            SELECT total AS total_cost;
        END IF;
    END IF;
END //
DELIMITER ;


-- Поиск сотрудника с наибольшим количеством отправлений по определенному типу

DELIMITER //
CREATE PROCEDURE pros6()
BEGIN
    DECLARE result_count INT DEFAULT 0;

    CREATE TEMPORARY TABLE IF NOT EXISTS temp_top_employees AS
    WITH ranked_employees AS (
        SELECT
            e.last_name,
            st.type_name,
            COUNT(*) AS shipment_count,
            RANK() OVER (PARTITION BY st.type_id ORDER BY COUNT(*) DESC) AS shipments_rank
        FROM shipments s
        JOIN employees e ON s.employee_id = e.employee_id
        JOIN shipment_types st ON s.type_id = st.type_id
        GROUP BY e.employee_id, st.type_id
    )
    SELECT
        type_name,
        last_name,
        shipment_count
    FROM ranked_employees
    WHERE shipments_rank = 1;

    SELECT COUNT(*) INTO result_count FROM temp_top_employees;

    IF result_count > 0 THEN
        SELECT * FROM temp_top_employees;
    ELSE
        SELECT 'Ошибка: нет данных о сотрудниках и отправлениях' AS message;
    END IF;

    DROP TEMPORARY TABLE IF EXISTS temp_top_employees;
END //
DELIMITER ;


-- Среднее количество отправлений в день по регионам

DELIMITER //
CREATE PROCEDURE pros7()
BEGIN
    DECLARE shipment_count INT;

    SELECT COUNT(*) INTO shipment_count
    FROM (
        SELECT r.region_name, COUNT(DISTINCT DATE(s.date_sent)) AS distinct_dates
        FROM shipments s
        JOIN postal_offices po ON s.postal_office_id = po.postal_office_id
        JOIN cities c ON po.city_id = c.city_id
        JOIN regions r ON c.region_id = r.region_id
        WHERE s.date_sent >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
        GROUP BY r.region_id
    ) AS region_counts;

    IF shipment_count = 0 THEN
        SELECT 'Ошибка: нет отправлений за последние 3 месяца' AS message;
    ELSE
        SELECT
            r.region_name,
            CASE
                WHEN COUNT(DISTINCT DATE(s.date_sent)) = 0 THEN 0
                ELSE COUNT(*) / COUNT(DISTINCT DATE(s.date_sent))
            END AS avg_per_day
        FROM shipments s
        JOIN postal_offices po ON s.postal_office_id = po.postal_office_id
        JOIN cities c ON po.city_id = c.city_id
        JOIN regions r ON c.region_id = r.region_id
        WHERE s.date_sent >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
        GROUP BY r.region_id;
    END IF;
END //
DELIMITER ;
