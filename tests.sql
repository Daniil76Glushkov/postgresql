--Проверка процедур

-- 1. Проверка создания амбулаторной карты
CALL prc_create_outpatient_card('2024-03-03', 2, 1);

-- 2. Проверка удаления отделения
CALL prc_delete_department_if_empty(2);

-- 3. Проверка дублирования связи врач-направление
CALL prc_add_doctor_direction(2, 1);

-- 4. Проверка записи на занятое время
CALL prc_create_appointment(
    'ТНП-0000009/23',
    '2023-09-13',
    '16:00',
    2,
    3,
    1,
    1,
    1
);

-- 5. Проверка периода расписания без дат
CALL prc_add_schedule_period(19, NULL, NULL, NULL, 'Тест');

-- 6. Проверка дополнительных процедур
CALL prc_add_schedule_status('Действующий');
CALL prc_add_outpatient_card_status('Активна');
CALL prc_add_appointment_source('Сайт');
CALL prc_add_appointment_type('Первичный');