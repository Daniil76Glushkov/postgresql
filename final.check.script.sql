
-- 1. Некорректные оценки
SELECT COUNT(*) AS invalid_grades
FROM grades
WHERE grade < 1 OR grade > 5;

-- 2. Дубликаты посещаемости
SELECT COUNT(*) AS attendance_duplicates
FROM (
    SELECT student_id, date
    FROM attendance
    GROUP BY student_id, date
    HAVING COUNT(*) > 1
) d;

-- 3. Логические ошибки посещаемости
SELECT COUNT(*) AS attendance_logical_errors
FROM attendance
WHERE
    (is_present = true AND reason_absent IS NOT NULL)
    OR
    (is_present = false AND reason_absent IS NULL);

-- 4. Проверка функции
SELECT calculate_attendance_percentage(5, 10) AS normal_case;
SELECT calculate_attendance_percentage(0, 0) AS zero_total_days;
SELECT calculate_attendance_percentage(NULL, 10) AS null_present_days;

-- 5. Проверка триггера
SELECT
    event_object_table AS table_name,
    trigger_name,
    event_manipulation,
    action_timing
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- 6. Проверка VIEW
SELECT *
FROM class_average
ORDER BY grade_level, letter, class_id;

-- 7. Проверка индексов
SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
