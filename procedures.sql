-- Процедура 1
-- Автоматическое формирование номера амбулаторной карты
-- Тестовый сценарий: ПРОЙДЕН

CREATE OR REPLACE PROCEDURE prc_create_outpatient_card(
    IN p_creation_date DATE,
    IN p_patient_id INTEGER,
    IN p_card_status_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_next_number INTEGER;
    v_card_number VARCHAR(20);
    v_year_suffix VARCHAR(2);
BEGIN
    -- Проверка существования пациента
    IF NOT EXISTS (
        SELECT 1
        FROM patient
        WHERE patient_id = p_patient_id
    ) THEN
        RAISE EXCEPTION 'Пациент с кодом % не найден', p_patient_id;
    END IF;

    -- Проверка существования статуса карты
    IF NOT EXISTS (
        SELECT 1
        FROM outpatient_card_status
        WHERE card_status_id = p_card_status_id
    ) THEN
        RAISE EXCEPTION 'Статус карты с кодом % не найден', p_card_status_id;
    END IF;

    -- Проверка, что у пациента ещё нет карты
    IF EXISTS (
        SELECT 1
        FROM outpatient_card
        WHERE patient_id = p_patient_id
    ) THEN
        RAISE EXCEPTION 'У пациента с кодом % уже существует амбулаторная карта', p_patient_id;
    END IF;

    -- Получение следующего порядкового номера
    SELECT COALESCE(
        MAX(CAST(SUBSTRING(card_number FROM 4 FOR 8) AS INTEGER)),
        0
    ) + 1
    INTO v_next_number
    FROM outpatient_card
    WHERE card_number LIKE 'АК-%';

    -- Последние 2 цифры года
    v_year_suffix := TO_CHAR(p_creation_date, 'YY');

    -- Формирование номера карты
    v_card_number := 'АК-' || LPAD(v_next_number::TEXT, 8, '0') || '/' || v_year_suffix;

    -- Добавление карты
    INSERT INTO outpatient_card (
        card_number,
        creation_date,
        patient_id,
        card_status_id
    )
    VALUES (
        v_card_number,
        p_creation_date,
        p_patient_id,
        p_card_status_id
    );

    RAISE NOTICE 'Амбулаторная карта успешно создана: %', v_card_number;
END;
$$;


-- Процедура 2
-- Удаление отделения только если в нём нет врачей
-- Тестовый сценарий: ПРОЙДЕН


CREATE OR REPLACE PROCEDURE prc_delete_department_if_empty(
    IN p_department_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка существования отделения
    IF NOT EXISTS (
        SELECT 1
        FROM department
        WHERE department_id = p_department_id
    ) THEN
        RAISE EXCEPTION 'Отделение с кодом % не найдено', p_department_id;
    END IF;

    -- Проверка наличия врачей в отделении
    IF EXISTS (
        SELECT 1
        FROM doctor
        WHERE department_id = p_department_id
    ) THEN
        RAISE EXCEPTION 'Указанное отделение удалить нельзя, так как в нём есть сотрудники';
    END IF;

    -- Удаление отделения
    DELETE FROM department
    WHERE department_id = p_department_id;

    RAISE NOTICE 'Отделение с кодом % успешно удалено', p_department_id;
END;
$$;


-- Процедура 3
-- Добавление связи врач-направление с проверкой дубликата
-- Тестовый сценарий: ПРОЙДЕН

CREATE OR REPLACE PROCEDURE prc_add_doctor_direction(
    IN p_doctor_id INTEGER,
    IN p_direction_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка существования врача
    IF NOT EXISTS (
        SELECT 1
        FROM doctor
        WHERE doctor_id = p_doctor_id
    ) THEN
        RAISE EXCEPTION 'Врач с кодом % не найден', p_doctor_id;
    END IF;

    -- Проверка существования направления
    IF NOT EXISTS (
        SELECT 1
        FROM direction
        WHERE direction_id = p_direction_id
    ) THEN
        RAISE EXCEPTION 'Направление с кодом % не найдено', p_direction_id;
    END IF;

    -- Проверка дубликата связи
    IF EXISTS (
        SELECT 1
        FROM doctor_direction
        WHERE doctor_id = p_doctor_id
          AND direction_id = p_direction_id
    ) THEN
        RAISE EXCEPTION 'Указанная связь врача и направления уже существует';
    END IF;

    -- Добавление новой связи
    INSERT INTO doctor_direction (
        doctor_id,
        direction_id
    )
    VALUES (
        p_doctor_id,
        p_direction_id
    );

    RAISE NOTICE 'Связь врач-направление успешно добавлена';
END;
$$;


-- Процедура 4
-- Добавление записи на приём с проверкой занятого времени
-- Тестовый сценарий: ПРОЙДЕН

CREATE OR REPLACE PROCEDURE prc_create_appointment(
    IN p_ticket_number VARCHAR(20),
    IN p_appointment_date DATE,
    IN p_appointment_time TIME,
    IN p_doctor_id INTEGER,
    IN p_patient_id INTEGER,
    IN p_appointment_status_id INTEGER,
    IN p_source_id INTEGER,
    IN p_type_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка существования врача
    IF NOT EXISTS (
        SELECT 1
        FROM doctor
        WHERE doctor_id = p_doctor_id
    ) THEN
        RAISE EXCEPTION 'Врач с кодом % не найден', p_doctor_id;
    END IF;

    -- Проверка существования пациента
    IF NOT EXISTS (
        SELECT 1
        FROM patient
        WHERE patient_id = p_patient_id
    ) THEN
        RAISE EXCEPTION 'Пациент с кодом % не найден', p_patient_id;
    END IF;

    -- Проверка статуса записи
    IF NOT EXISTS (
        SELECT 1
        FROM appointment_status
        WHERE appointment_status_id = p_appointment_status_id
    ) THEN
        RAISE EXCEPTION 'Статус записи с кодом % не найден', p_appointment_status_id;
    END IF;

    -- Проверка источника записи
    IF NOT EXISTS (
        SELECT 1
        FROM appointment_source
        WHERE source_id = p_source_id
    ) THEN
        RAISE EXCEPTION 'Источник записи с кодом % не найден', p_source_id;
    END IF;

    -- Проверка типа приёма
    IF NOT EXISTS (
        SELECT 1
        FROM appointment_type
        WHERE type_id = p_type_id
    ) THEN
        RAISE EXCEPTION 'Тип приёма с кодом % не найден', p_type_id;
    END IF;

    -- Проверка занятого времени
    IF EXISTS (
        SELECT 1
        FROM appointment
        WHERE doctor_id = p_doctor_id
          AND appointment_date = p_appointment_date
          AND appointment_time = p_appointment_time
    ) THEN
        RAISE EXCEPTION 'Указанное время уже занято, выберите другое время';
    END IF;

    -- Проверка уникальности номера талона
    IF EXISTS (
        SELECT 1
        FROM appointment
        WHERE ticket_number = p_ticket_number
    ) THEN
        RAISE EXCEPTION 'Талон с номером % уже существует', p_ticket_number;
    END IF;

    -- Добавление записи
    INSERT INTO appointment (
        ticket_number,
        appointment_date,
        appointment_time,
        status,
        doctor_id,
        patient_id,
        appointment_status_id,
        source_id,
        type_id
    )
    VALUES (
        p_ticket_number,
        p_appointment_date,
        p_appointment_time,
        'Waiting',
        p_doctor_id,
        p_patient_id,
        p_appointment_status_id,
        p_source_id,
        p_type_id
    );

    RAISE NOTICE 'Запись на приём успешно создана';
END;
$$;


-- Процедура 5
-- Добавление периода расписания с проверкой дат
-- Тестовый сценарий: ПРОЙДЕН
CREATE OR REPLACE PROCEDURE prc_add_schedule_period(
    IN p_schedule_id INTEGER,
    IN p_date_start DATE,
    IN p_date_end DATE,
    IN p_specific_date DATE,
    IN p_change_reason VARCHAR(200)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка существования расписания
    IF NOT EXISTS (
        SELECT 1
        FROM schedule
        WHERE schedule_id = p_schedule_id
    ) THEN
        RAISE EXCEPTION 'Расписание с кодом % не найдено', p_schedule_id;
    END IF;

    -- Проверка заполнения дат
    IF (
        (p_date_start IS NULL OR p_date_end IS NULL)
        AND p_specific_date IS NULL
    ) THEN
        RAISE EXCEPTION 'Необходимо указать либо дату начала и дату окончания, либо конкретную дату';
    END IF;

    -- Проверка логики периода
    IF p_date_start IS NOT NULL
       AND p_date_end IS NOT NULL
       AND p_date_start > p_date_end THEN
        RAISE EXCEPTION 'Дата начала периода не может быть больше даты окончания';
    END IF;

    -- Добавление периода
    INSERT INTO schedule_period (
        schedule_id,
        date_start,
        date_end,
        specific_date,
        change_reason
    )
    VALUES (
        p_schedule_id,
        p_date_start,
        p_date_end,
        p_specific_date,
        p_change_reason
    );

    RAISE NOTICE 'Период расписания успешно добавлен';
END;
$$;