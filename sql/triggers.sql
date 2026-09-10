
-- Триггер для автоматического расчёта стоимости отправления (наценка 1,5% за каждые 100 г сверх первого 1 кг)

DELIMITER //
CREATE TRIGGER shipment_cost
BEFORE INSERT ON shipments
FOR EACH ROW
BEGIN
    DECLARE base_price DECIMAL(10, 2);
    DECLARE weight_coef DECIMAL(10, 2);

    SELECT st.base_price INTO base_price
    FROM shipment_types st
    WHERE st.type_id = NEW.type_id;

    IF NEW.weight > 1.0 THEN
        SET weight_coef = (NEW.weight - 1.0) * 100 * 0.015;
    ELSE
        SET weight_coef = 0;
    END IF;

    SET NEW.cost = base_price + (base_price * weight_coef);
END //
DELIMITER ;


-- Триггер для проверка максимального веса отправления

DELIMITER //
CREATE TRIGGER check_max_weight
BEFORE INSERT ON shipments
FOR EACH ROW
BEGIN
    DECLARE max_allowed_weight DECIMAL(10, 3);

    SELECT st.max_weight INTO max_allowed_weight
    FROM shipment_types st
    WHERE st.type_id = NEW.type_id;

    IF max_allowed_weight IS NOT NULL AND NEW.weight > max_allowed_weight THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Превышен максимально допустимый вес для данного типа отправления';
    END IF;
END //
DELIMITER ;

