CREATE OR REPLACE PROCEDURE prc_ClearAllTables()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM appointment;
    DELETE FROM schedule;
    DELETE FROM outpatient_card;
    DELETE FROM doctor_direction;
    DELETE FROM patient;
    DELETE FROM doctor;
    DELETE FROM direction;
    DELETE FROM doctor_profile;
    DELETE FROM cabinet;
    DELETE FROM department;

    ALTER SEQUENCE department_department_id_seq RESTART WITH 1;
    ALTER SEQUENCE doctor_profile_profile_id_seq RESTART WITH 1;
    ALTER SEQUENCE doctor_doctor_id_seq RESTART WITH 1;
    ALTER SEQUENCE patient_patient_id_seq RESTART WITH 1;
    ALTER SEQUENCE direction_direction_id_seq RESTART WITH 1;
END;
$$;