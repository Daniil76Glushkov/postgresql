-- 1. Статусы расписания
CREATE TABLE IF NOT EXISTS schedule_status (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(30) NOT NULL UNIQUE
);

-- 2. Добавление статуса в расписание
ALTER TABLE schedule
ADD COLUMN IF NOT EXISTS status_id INTEGER REFERENCES schedule_status(status_id);

-- 3. Периоды действия расписания
CREATE TABLE IF NOT EXISTS schedule_period (
    period_id SERIAL PRIMARY KEY,
    schedule_id INTEGER NOT NULL REFERENCES schedule(schedule_id),
    date_start DATE,
    date_end DATE,
    specific_date DATE,
    change_reason VARCHAR(200),
    CONSTRAINT chk_schedule_period_dates CHECK (
        (date_start IS NOT NULL AND date_end IS NOT NULL)
        OR (specific_date IS NOT NULL)
    )
);

-- 4. Статусы амбулаторных карт
CREATE TABLE IF NOT EXISTS outpatient_card_status (
    card_status_id SERIAL PRIMARY KEY,
    card_status_name VARCHAR(30) NOT NULL UNIQUE
);

-- 5. Фото пациента
ALTER TABLE patient
ADD COLUMN IF NOT EXISTS photo_path VARCHAR(255) UNIQUE;

-- 6. Статус амбулаторной карты
ALTER TABLE outpatient_card
ADD COLUMN IF NOT EXISTS card_status_id INTEGER REFERENCES outpatient_card_status(card_status_id);

-- 7. Статусы записи на приём
CREATE TABLE IF NOT EXISTS appointment_status (
    appointment_status_id SERIAL PRIMARY KEY,
    appointment_status_name VARCHAR(30) NOT NULL UNIQUE
);

-- 8. Источники записи
CREATE TABLE IF NOT EXISTS appointment_source (
    source_id SERIAL PRIMARY KEY,
    source_name VARCHAR(30) NOT NULL UNIQUE
);

-- 9. Типы приёма
CREATE TABLE IF NOT EXISTS appointment_type (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(30) NOT NULL UNIQUE
);

-- 10. Новые поля в записи на приём
ALTER TABLE appointment
ADD COLUMN IF NOT EXISTS appointment_status_id INTEGER REFERENCES appointment_status(appointment_status_id);

ALTER TABLE appointment
ADD COLUMN IF NOT EXISTS source_id INTEGER REFERENCES appointment_source(source_id);

ALTER TABLE appointment
ADD COLUMN IF NOT EXISTS type_id INTEGER REFERENCES appointment_type(type_id);

-- 11. Заполнение новых справочников
INSERT INTO schedule_status (status_name)
VALUES
    ('Действующий'),
    ('Отменённый'),
    ('Перенесённый'),
    ('Дополнительный')
ON CONFLICT (status_name) DO NOTHING;

INSERT INTO outpatient_card_status (card_status_name)
VALUES
    ('Активна'),
    ('Утеряна'),
    ('Архивирована'),
    ('Заблокирована')
ON CONFLICT (card_status_name) DO NOTHING;

INSERT INTO appointment_status (appointment_status_name)
VALUES
    ('Ожидает'),
    ('Завершён'),
    ('Отменён')
ON CONFLICT (appointment_status_name) DO NOTHING;

INSERT INTO appointment_source (source_name)
VALUES
    ('Регистратура'),
    ('Сайт'),
    ('Телефон')
ON CONFLICT (source_name) DO NOTHING;

INSERT INTO appointment_type (type_name)
VALUES
    ('Первичный'),
    ('Повторный')
ON CONFLICT (type_name) DO NOTHING;