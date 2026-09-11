-- Проверка дублирования паспортных данных
DELIMITER //
CREATE TRIGGER check_duplicate_passport
BEFORE INSERT ON clients
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM clients WHERE passport_number = NEW.passport_number) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Клиент с таким номером паспорта уже существует';
    END IF;
END //
DELIMITER ;

-- Ограничение количества директоров в одном отделении
DELIMITER //
CREATE TRIGGER one_director
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.position_id = 1 AND EXISTS(
        SELECT 1 FROM employees WHERE position_id = 1 AND postal_office_id = NEW.postal_office_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'В отделении уже есть директор!';
    END IF;
END //
DELIMITER ;

-- Автоматическое регулирование регистра при добавлении сотрудника
DELIMITER //
CREATE TRIGGER normalize_fio
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.first_name = CONCAT(UPPER(LEFT(NEW.first_name, 1)), LOWER(SUBSTRING(NEW.first_name, 2)));
    SET NEW.last_name = CONCAT(UPPER(LEFT(NEW.last_name, 1)), LOWER(SUBSTRING(NEW.last_name, 2)));
END //
DELIMITER ;

-- Приведение номеров телефона к единому формату
DELIMITER //
CREATE TRIGGER normalize_phone_number
BEFORE INSERT ON clients
FOR EACH ROW
BEGIN
    IF LEFT(NEW.phone_number, 1) = '8' THEN
        SET NEW.phone_number = CONCAT('+7', SUBSTRING(NEW.phone_number, 2));
    END IF;
END //
DELIMITER ;

-- Автоматический расчёт стоимости отправления (наценка 1,5% за каждые 100 г сверх 1 кг)
DELIMITER //
CREATE TRIGGER shipment_cost
BEFORE INSERT ON shipments
FOR EACH ROW
BEGIN
    DECLARE base_price DECIMAL(10, 2);
    DECLARE weight_coef DECIMAL(10, 2);

    SELECT st.base_price INTO base_price FROM shipment_types st WHERE st.type_id = NEW.type_id;

    IF NEW.weight > 1.0 THEN
        SET weight_coef = (NEW.weight - 1.0) * 100 * 0.015;
    ELSE
        SET weight_coef = 0;
    END IF;

    SET NEW.cost = base_price + (base_price * weight_coef);
END //
DELIMITER ;

-- Проверка максимального веса отправления
DELIMITER //
CREATE TRIGGER check_max_weight
BEFORE INSERT ON shipments
FOR EACH ROW
BEGIN
    DECLARE max_allowed_weight DECIMAL(10, 3);

    SELECT st.max_weight INTO max_allowed_weight FROM shipment_types st WHERE st.type_id = NEW.type_id;

    IF max_allowed_weight IS NOT NULL AND NEW.weight > max_allowed_weight THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Превышен максимально допустимый вес для данного типа отправления';
    END IF;
END //
DELIMITER ;

-- Автоматическое обновление статуса при получении отправления
DELIMITER //
CREATE TRIGGER update_status
BEFORE UPDATE ON shipments
FOR EACH ROW
BEGIN
    IF NEW.date_received IS NOT NULL AND (OLD.date_received IS NULL OR NEW.date_received != OLD.date_received) THEN
        SET NEW.status = 'Delivered';

        IF NEW.date_received < NEW.date_sent THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Дата получения не может быть раньше даты отправки';
        END IF;
    END IF;
END //
DELIMITER ;
