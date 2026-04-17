CREATE OR REPLACE PROCEDURE prc_LoadSampleData()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO department (department_id, department_name) VALUES
    (1, 'Общая профилактика заболеваний'),
    (2, 'Хирургическое отделение');

    INSERT INTO cabinet (cabinet_number) VALUES
    (201), (203), (204), (302), (303), (305);

    INSERT INTO doctor_profile (profile_id, profile_name) VALUES
    (1, 'Терапевт'),
    (2, 'Отоларинголог'),
    (3, 'Хирург'),
    (4, 'Физиотерапевт'),
    (5, 'Медсестра');

    INSERT INTO direction (direction_id, direction_name) VALUES
    (1, 'Общая терапия'),
    (2, 'ЛОР'),
    (3, 'Хирургия'),
    (4, 'Физиотерапия');

    INSERT INTO doctor (doctor_id, full_name, medical_specialty, medical_degree, login, password_hash, profile_id, department_id, cabinet_number) VALUES
    (1, 'Иванов Иван Иванович', 'Терапевт', 'доктор медицинских наук', 'dk_IvanovII', 'password123', 1, 1, 201),
    (2, 'Ильин Илья Ильич', 'Терапевт', 'доктор-аспирант', 'dk_IlinII', 'password123', 1, 1, 203),
    (3, 'Петрова Елена Игоревна', 'Отоларинголог', 'кандидат медицинских наук', 'dk_PetrovaEI', 'password123', 2, 1, 204),
    (4, 'Петров Пётр Петрович', 'Хирург', 'доктор медицинских наук', 'dc_PetrovPP', 'password123', 3, 2, 302),
    (5, 'Антонова Любовь Петровна', 'Хирург', 'кандидат медицинских наук', 'dc_AntonovaLP', 'password123', 3, 2, 303),
    (6, 'Егоров Егор Олегович', 'Физиотерапевт', 'доктор-аспирант', 'dc_EgorovEO', 'password123', 4, 2, 305),
    (7, 'Романова Ольга Петровна', 'Медсестра', 'доктор-магистр', 'dc_RomanovaOP', 'password123', 5, 2, 305);

    INSERT INTO doctor_direction (doctor_id, direction_id) VALUES
    (1,1), (2,1), (3,2), (4,3), (5,3), (6,4);

    INSERT INTO patient (patient_id, full_name, passport_series, passport_number, insurance_number, gender, birth_date, address, login, password_hash) VALUES
    (1, 'Андреев Кирилл Вячеславович', 4598, 256878, '0000 1000 1009 1986', 'М', '1986-09-10', 'г. Москва, ул. Волгоградская, д. 10, к. 3, кв. 19', 'AndreevKV', 'password123'),
    (2, 'Павлова Анастасия Владимировна', 4615, 623365, '0000 1001 2001 1999', 'Ж', '1999-01-20', 'г. Москва, ул. Кропоткинская д.23, стр. 10, кв. 174', 'PavlovaAV', 'password123'),
    (3, 'Егоров Дмитрий Андреевич', 4478, 114681, '0001 1010 1910 2000', 'М', '2000-10-19', 'г. Москва, ул. Арбатская, д. 5, к.7, кв. 64', 'EgorovDA', 'password123'),
    (4, 'Антонов Олег Игоревич', 4210, 452267, '0001 1111 0804 1975', 'М', '1975-04-08', 'г. Москва, ул. Багратионовская, д. 68, стр. А, кв. 346', 'Antonov OI', 'password123');

    INSERT INTO outpatient_card (card_number, creation_date, patient_id) VALUES
    ('АК-00000001/22', '2022-05-10', 1),
    ('АК-00000001/23', '2023-01-05', 1),
    ('АК-00000002/23', '2023-03-18', 2),
    ('АК-00000003/23', '2023-04-23', 3),
    ('АК-00000004/23', '2023-08-07', 4);

    INSERT INTO schedule (day_of_week, start_time, end_time, shift, doctor_id, cabinet_number) VALUES
    ('Monday', '10:00', '10:30', 'Утренняя', 2, 203),
    ('Monday', '10:30', '11:00', 'Утренняя', 2, 203),
    ('Tuesday', '15:00', '15:30', 'Вечерняя', 2, 203),
    ('Wednesday', '15:00', '15:30', 'Вечерняя', 3, 204),
    ('Thursday', '10:00', '10:30', 'Утренняя', 3, 204),
    ('Monday', '10:00', '10:30', 'Утренняя', 5, 303),
    ('Wednesday', '10:00', '10:30', 'Утренняя', 5, 303),
    ('Tuesday', '15:00', '15:30', 'Вечерняя', 6, 305),
    ('Thursday', '15:00', '15:30', 'Вечерняя', 6, 305);

    INSERT INTO appointment (ticket_number, appointment_date, appointment_time, status, doctor_id, patient_id) VALUES
    ('ТНП-0000001/22', '2022-11-14', '10:00', 'Closed', 2, 1),
    ('ТНП-0000002/22', '2022-12-14', '11:00', 'Closed', 5, 1),
    ('ТНП-0000001/23', '2023-09-05', '15:30', 'Waiting', 6, 1),
    ('ТНП-0000001/23', '2023-09-13', '16:00', 'Waiting', 2, 2),
    ('ТНП-0000001/23', '2023-08-31', '17:30', 'Closed', 6, 4),
    ('ТНП-0000001/23', '2023-09-15', '11:30', 'Waiting', 3, 3),
    ('ТНП-0000001/23', '2023-09-28', '11:00', 'Waiting', 5, 4),
    ('ТНП-0000001/23', '2023-09-21', '15:30', 'Waiting', 3, 3);
END;
$$;