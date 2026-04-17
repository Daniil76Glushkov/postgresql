SELECT 
    patient_id AS "Код пациента",
    full_name AS "ФИО",
    insurance_number AS "Номер ОМС",
    birth_date AS "Дата рождения"
FROM patient
ORDER BY full_name;

SELECT 
    d.doctor_id AS "Код врача",
    d.full_name AS "ФИО врача",
    d.medical_specialty AS "Специальность",
    dep.department_name AS "Отделение"
FROM doctor d
LEFT JOIN department dep ON d.department_id = dep.department_id
ORDER BY dep.department_name, d.full_name;

SELECT 
    d.full_name AS "Врач",
    s.day_of_week AS "День недели",
    s.start_time AS "Время начала",
    s.end_time AS "Время окончания",
    s.shift AS "Смена"
FROM schedule s
JOIN doctor d ON s.doctor_id = d.doctor_id
ORDER BY d.full_name, s.start_time;

SELECT 
    p.full_name AS "Пациент",
    oc.card_number AS "Номер карты",
    a.ticket_number AS "Номер талона",
    a.appointment_date AS "Дата приёма",
    a.appointment_time AS "Время приёма",
    a.status AS "Статус",
    d.full_name AS "Врач"
FROM appointment a
JOIN patient p ON a.patient_id = p.patient_id
JOIN outpatient_card oc ON p.patient_id = oc.patient_id
JOIN doctor d ON a.doctor_id = d.doctor_id
ORDER BY a.appointment_date DESC, a.appointment_time;

SELECT 
    d.full_name AS "Врач",
    COUNT(a.ticket_number) AS "Количество приёмов",
    SUM(CASE WHEN a.status = 'Closed' THEN 1 ELSE 0 END) AS "Завершено",
    SUM(CASE WHEN a.status = 'Waiting' THEN 1 ELSE 0 END) AS "Ожидают"
FROM doctor d
LEFT JOIN appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.full_name
ORDER BY "Количество приёмов" DESC;