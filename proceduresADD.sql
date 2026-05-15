-- Процедура 6
-- Добавление нового статуса расписания
-- Тестовый сценарий: ПРОЙДЕН

CREATE OR REPLACE PROCEDURE prc_add_schedule_status(
    IN p_status_name VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM schedule_status
        WHERE LOWER(status_name) = LOWER(p_status_name)
    ) THEN
        RAISE EXCEPTION 'Статус расписания "%" уже существует', p_status_name;
    END IF;

    INSERT INTO schedule_status(status_name)
    VALUES (p_status_name);

    RAISE NOTICE 'Статус расписания "%" успешно добавлен', p_status_name;
END;
$$;


-- Процедура 7
-- Добавление нового статуса амбулаторной карты
-- Тестовый сценарий: ПРОЙДЕН

CREATE OR REPLACE PROCEDURE prc_add_outpatient_card_status(
    IN p_status_name VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM outpatient_card_status
        WHERE LOWER(card_status_name) = LOWER(p_status_name)
    ) THEN
        RAISE EXCEPTION 'Статус амбулаторной карты "%" уже существует', p_status_name;
    END IF;

    INSERT INTO outpatient_card_status(card_status_name)
    VALUES (p_status_name);

    RAISE NOTICE 'Статус амбулаторной карты "%" успешно добавлен', p_status_name;
END;
$$;


-- Процедура 8
-- Добавление нового источника записи
-- Тестовый сценарий: ПРОЙДЕН

CREATE OR REPLACE PROCEDURE prc_add_appointment_source(
    IN p_source_name VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM appointment_source
        WHERE LOWER(source_name) = LOWER(p_source_name)
    ) THEN
        RAISE EXCEPTION 'Источник записи "%" уже существует', p_source_name;
    END IF;

    INSERT INTO appointment_source(source_name)
    VALUES (p_source_name);

    RAISE NOTICE 'Источник записи "%" успешно добавлен', p_source_name;
END;
$$;


-- Процедура 9
-- Добавление нового типа приёма
-- Тестовый сценарий: ПРОЙДЕН

CREATE OR REPLACE PROCEDURE prc_add_appointment_type(
    IN p_type_name VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM appointment_type
        WHERE LOWER(type_name) = LOWER(p_type_name)
    ) THEN
        RAISE EXCEPTION 'Тип приёма "%" уже существует', p_type_name;
    END IF;

    INSERT INTO appointment_type(type_name)
    VALUES (p_type_name);

    RAISE NOTICE 'Тип приёма "%" успешно добавлен', p_type_name;
END;
$$;