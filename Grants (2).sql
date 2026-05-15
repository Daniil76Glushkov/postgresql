--Права доступа

-- 1. Создание роли
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'db_user_kt8'
    ) THEN
        CREATE ROLE db_user_kt8 LOGIN PASSWORD 'password123';
    END IF;
END
$$;

-- 2. Права на дополнительные таблицы

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE schedule_status TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE schedule_period TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE outpatient_card_status TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE appointment_status TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE appointment_source TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE appointment_type TO db_user_kt8;

-- Права на основные изменённые таблицы
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE patient TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE outpatient_card TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE schedule TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE appointment TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE doctor_direction TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE department TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE doctor TO db_user_kt8;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE direction TO db_user_kt8;

-- 3. Права на последовательности

GRANT USAGE, SELECT ON SEQUENCE schedule_status_status_id_seq TO db_user_kt8;
GRANT USAGE, SELECT ON SEQUENCE schedule_period_period_id_seq TO db_user_kt8;
GRANT USAGE, SELECT ON SEQUENCE outpatient_card_status_card_status_id_seq TO db_user_kt8;
GRANT USAGE, SELECT ON SEQUENCE appointment_status_appointment_status_id_seq TO db_user_kt8;
GRANT USAGE, SELECT ON SEQUENCE appointment_source_source_id_seq TO db_user_kt8;
GRANT USAGE, SELECT ON SEQUENCE appointment_type_type_id_seq TO db_user_kt8;

-- 4. Права на основные процедуры

GRANT EXECUTE ON PROCEDURE prc_create_outpatient_card(DATE, INTEGER, INTEGER) TO db_user_kt8;
GRANT EXECUTE ON PROCEDURE prc_delete_department_if_empty(INTEGER) TO db_user_kt8;
GRANT EXECUTE ON PROCEDURE prc_add_doctor_direction(INTEGER, INTEGER) TO db_user_kt8;
GRANT EXECUTE ON PROCEDURE prc_create_appointment(VARCHAR, DATE, TIME, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER) TO db_user_kt8;
GRANT EXECUTE ON PROCEDURE prc_add_schedule_period(INTEGER, DATE, DATE, DATE, VARCHAR) TO db_user_kt8;

-- 5. Права на дополнительные процедуры

GRANT EXECUTE ON PROCEDURE prc_add_schedule_status(VARCHAR) TO db_user_kt8;
GRANT EXECUTE ON PROCEDURE prc_add_outpatient_card_status(VARCHAR) TO db_user_kt8;
GRANT EXECUTE ON PROCEDURE prc_add_appointment_source(VARCHAR) TO db_user_kt8;
GRANT EXECUTE ON PROCEDURE prc_add_appointment_type(VARCHAR) TO db_user_kt8;