
Процедура для количества отправлений по типам за день в отделении
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


Процедура с выводом списка сотрудников с количеством отправлений по типам
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
