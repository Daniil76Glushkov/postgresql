
-- Итоговый скрипт исправления найденных аномалий
BEGIN;

-- 1. Исправление некорректных оценок и добавление CHECK-ограничения
UPDATE grades
SET grade = 5
WHERE grade > 5;

UPDATE grades
SET grade = 1
WHERE grade < 1;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'grades_grade_check'
          AND conrelid = 'grades'::regclass
    ) THEN
        ALTER TABLE grades
        ADD CONSTRAINT grades_grade_check
        CHECK (grade BETWEEN 1 AND 5);
    END IF;
END $$;

-- 2. Очистка дубликатов и логических ошибок в attendance
CREATE TEMP TABLE attendance_fix AS
SELECT
    student_id,
    date,
    MIN(id) AS keep_id,
    BOOL_AND(is_present) AS new_is_present,
    CASE
        WHEN BOOL_AND(is_present) = true THEN NULL
        ELSE COALESCE(
            (ARRAY_AGG(reason_absent) FILTER (WHERE reason_absent IS NOT NULL))[1],
            'Причина не указана'
        )
    END AS new_reason_absent
FROM attendance
GROUP BY student_id, date
HAVING COUNT(*) > 1;

UPDATE attendance a
SET
    is_present = f.new_is_present,
    reason_absent = f.new_reason_absent
FROM attendance_fix f
WHERE a.id = f.keep_id;

DELETE FROM attendance a
USING attendance_fix f
WHERE a.student_id = f.student_id
  AND a.date = f.date
  AND a.id <> f.keep_id;

UPDATE attendance
SET reason_absent = NULL
WHERE is_present = true
  AND reason_absent IS NOT NULL;

UPDATE attendance
SET reason_absent = 'Причина не указана'
WHERE is_present = false
  AND reason_absent IS NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'attendance_student_date_unique'
          AND conrelid = 'attendance'::regclass
    ) THEN
        ALTER TABLE attendance
        ADD CONSTRAINT attendance_student_date_unique
        UNIQUE (student_id, date);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'attendance_reason_check'
          AND conrelid = 'attendance'::regclass
    ) THEN
        ALTER TABLE attendance
        ADD CONSTRAINT attendance_reason_check
        CHECK (
            (is_present = true AND reason_absent IS NULL)
            OR
            (is_present = false AND reason_absent IS NOT NULL)
        );
    END IF;
END $$;

COMMIT;

-- 3. Индексы для повышения производительности запросов по внешним ключам
CREATE INDEX IF NOT EXISTS idx_attendance_student_id ON attendance(student_id);

CREATE INDEX IF NOT EXISTS idx_grades_student_id ON grades(student_id);
CREATE INDEX IF NOT EXISTS idx_grades_subject_id ON grades(subject_id);
CREATE INDEX IF NOT EXISTS idx_grades_teacher_id ON grades(teacher_id);

CREATE INDEX IF NOT EXISTS idx_timetable_class_id ON timetable(class_id);
CREATE INDEX IF NOT EXISTS idx_timetable_subject_id ON timetable(subject_id);
CREATE INDEX IF NOT EXISTS idx_timetable_teacher_id ON timetable(teacher_id);

CREATE INDEX IF NOT EXISTS idx_student_class_student_id ON student_class(student_id);
CREATE INDEX IF NOT EXISTS idx_student_class_class_id ON student_class(class_id);

CREATE INDEX IF NOT EXISTS idx_student_parents_student_id ON student_parents(student_id);
CREATE INDEX IF NOT EXISTS idx_student_parents_parent_id ON student_parents(parent_id);

-- 4. Исправление VIEW class_average
CREATE OR REPLACE VIEW class_average AS
SELECT
    c.grade_level,
    c.letter,
    AVG(g.grade) AS avg_grade,
    c.id AS class_id
FROM classes c
JOIN student_class sc
    ON c.id = sc.class_id
   AND sc.is_current = true
JOIN grades g
    ON sc.student_id = g.student_id
GROUP BY c.id, c.grade_level, c.letter;

-- 5. Исправление функции расчета процента посещаемости
CREATE OR REPLACE FUNCTION public.calculate_attendance_percentage(
    present_days integer,
    total_days integer
)
RETURNS numeric
LANGUAGE plpgsql
AS $function$
BEGIN
    IF total_days IS NULL OR total_days = 0 THEN
        RETURN 0;
    END IF;

    IF present_days IS NULL THEN
        present_days := 0;
    END IF;

    RETURN ROUND((present_days::numeric / total_days) * 100, 2);
END;
$function$;

-- 6. Триггер для контроля одного текущего класса у ученика
CREATE OR REPLACE FUNCTION public.ensure_single_current_class()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.is_current = true THEN
        UPDATE student_class
        SET is_current = false
        WHERE student_id = NEW.student_id
          AND is_current = true
          AND NOT (
              class_id = NEW.class_id
              AND transfer_date = NEW.transfer_date
          );
    END IF;

    RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS trg_ensure_single_current_class ON student_class;

CREATE TRIGGER trg_ensure_single_current_class
BEFORE INSERT OR UPDATE OF is_current
ON student_class
FOR EACH ROW
EXECUTE FUNCTION public.ensure_single_current_class();
