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
