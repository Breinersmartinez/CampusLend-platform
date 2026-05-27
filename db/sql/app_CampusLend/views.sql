-- 6. VISTAS (VIEWS) - Simplificadas para Solo Estudiantes

-- 6.1 Computadoras disponibles
CREATE OR REPLACE VIEW v_computers_available AS
SELECT
    c.computer_id,
    c.inventory_code,
    c.brand,
    c.model,
    c.processor,
    c.ram_gb,
    c.storage_gb,
    cs.status_name AS status
FROM computer c
         JOIN computer_status_type cs ON c.status_id = cs.status_id
WHERE cs.status_name = 'AVAILABLE'
ORDER BY c.brand, c.model;

COMMENT ON VIEW v_computers_available IS 'Computers currently available for loan or reservation';

-- 6.2 Salas disponibles con equipamiento
CREATE OR REPLACE VIEW v_rooms_available AS
SELECT
    r.room_id,
    r.name,
    r.building,
    r.floor,
    r.room_number,
    r.max_capacity,
    r.opening_time,
    r.closing_time,
    rs.status_name AS status,
    JSON_AGG(
            JSON_BUILD_OBJECT('equipment', et.equipment_name, 'quantity', re.quantity)
    ) FILTER (WHERE re.room_equipment_id IS NOT NULL) AS equipment
FROM room r
         JOIN room_status_type rs     ON r.status_id = rs.status_id
         LEFT JOIN room_equipment re  ON r.room_id = re.room_id
         LEFT JOIN equipment_type et  ON re.equipment_type_id = et.equipment_type_id
WHERE rs.status_name = 'AVAILABLE'
GROUP BY r.room_id, r.name, r.building, r.floor, r.room_number,
         r.max_capacity, r.opening_time, r.closing_time, rs.status_name
ORDER BY r.building, r.floor, r.room_number;

COMMENT ON VIEW v_rooms_available IS 'Available rooms with equipment inventory as JSON';

-- 6.3 Préstamos activos (Solo Estudiantes)
CREATE OR REPLACE VIEW v_active_loans AS
SELECT
    l.loan_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email AS student_email,
    c.inventory_code,
    c.brand,
    c.model,
    c.processor,
    c.ram_gb,
    CONCAT(e.first_name, ' ', e.last_name) AS registrant_employee,
    ls.status_name AS loan_status,
    l.request_date,
    l.expected_return_date,
    l.actual_return_date,
    l.reservation_id IS NOT NULL AS from_reservation
FROM loan l
         JOIN student s                  ON l.student_id = s.student_id
         JOIN computer c                 ON l.computer_id = c.computer_id
         JOIN employee e                 ON l.employee_registrant_id = e.employee_id
         JOIN loan_status_type ls        ON l.status_id = ls.status_id
WHERE ls.status_name = 'ACTIVE'
ORDER BY l.request_date DESC;

COMMENT ON VIEW v_active_loans IS 'Active loans for students';

-- 6.4 Reservas activas de hoy (Solo Estudiantes)
CREATE OR REPLACE VIEW v_reservations_today AS
SELECT
    r.reservation_id,
    rt_res.resource_name AS resource_type,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email AS student_email,
    COALESCE(rm.name, c.model) AS resource_name,
    COALESCE(rm.building, 'N/A') AS building,
    COALESCE(rm.floor::TEXT, 'N/A') AS floor,
    COALESCE(c.inventory_code, 'N/A') AS inventory_code,
    r.start_time,
    r.end_time,
    rs.status_name AS reservation_status
FROM reservation r
         JOIN student s                      ON r.student_id = s.student_id
         JOIN resource_type rt_res           ON r.resource_type_id = rt_res.resource_type_id
         JOIN reservation_status_type rs     ON r.status_id = rs.status_id
         LEFT JOIN room rm                   ON r.room_id = rm.room_id
         LEFT JOIN computer c                ON r.computer_id = c.computer_id
WHERE r.reservation_date = CURRENT_DATE
  AND rs.status_name = 'ACTIVE'
ORDER BY r.start_time;

COMMENT ON VIEW v_reservations_today IS 'Active reservations for today for students';

-- 6.5 Estudiantes con multas pendientes
CREATE OR REPLACE VIEW v_students_with_fines AS
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email,
    s.academic_program,
    s.semester,
    s.pending_fines,
    COUNT(f.fine_id) AS unpaid_fine_count
FROM student s
         LEFT JOIN fine f ON s.student_id = f.student_id
    AND f.status_id = (SELECT status_id FROM fine_status_type WHERE status_name = 'PENDING')
WHERE s.pending_fines > 0
GROUP BY s.student_id, s.first_name, s.last_name, s.institutional_email,
         s.academic_program, s.semester, s.pending_fines
ORDER BY s.pending_fines DESC;

COMMENT ON VIEW v_students_with_fines IS 'Students with pending fines, ordered by amount';

-- 6.6 Préstamos vencidos (Solo Estudiantes)
CREATE OR REPLACE VIEW v_overdue_loans AS
SELECT
    l.loan_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email,
    c.inventory_code,
    c.brand,
    c.model,
    c.processor,
    l.expected_return_date,
    CURRENT_TIMESTAMP - l.expected_return_date AS time_overdue,
    ls.status_name AS loan_status
FROM loan l
         JOIN student s                  ON l.student_id = s.student_id
         JOIN computer c                 ON l.computer_id = c.computer_id
         JOIN loan_status_type ls        ON l.status_id = ls.status_id
WHERE ls.status_name IN ('ACTIVE', 'OVERDUE')
  AND l.expected_return_date < CURRENT_TIMESTAMP
ORDER BY l.expected_return_date ASC;

COMMENT ON VIEW v_overdue_loans IS 'Overdue loans for students';

-- 6.7 Resumen de actividad de empleados
CREATE OR REPLACE VIEW v_employee_activity AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    r.role_name,
    COUNT(DISTINCT a.audit_id) AS total_actions,
    MAX(a.date_time) AS last_action,
    es.status_name AS status
FROM employee e
         LEFT JOIN role_type r              ON e.role_id = r.role_id
         LEFT JOIN audit a                  ON e.employee_id = a.employee_id
         LEFT JOIN employee_status_type es  ON e.status_id = es.status_id
GROUP BY e.employee_id, e.first_name, e.last_name, r.role_name, es.status_name
ORDER BY MAX(a.date_time) DESC NULLS LAST;

COMMENT ON VIEW v_employee_activity IS 'Employee activity summary with last action timestamp';

-- 6.8 Resumen de estadísticas de estudiantes
CREATE OR REPLACE VIEW v_student_statistics AS
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email,
    s.academic_program,
    s.semester,
    acs.status_name AS academic_status,
    s.pending_fines,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COUNT(DISTINCT CASE WHEN ls.status_name = 'ACTIVE' THEN l.loan_id END) AS active_loans,
    COUNT(DISTINCT CASE WHEN ls.status_name = 'OVERDUE' THEN l.loan_id END) AS overdue_loans,
    COUNT(DISTINCT r.reservation_id) AS total_reservations,
    COUNT(DISTINCT CASE WHEN rs.status_name = 'ACTIVE' THEN r.reservation_id END) AS active_reservations
FROM student s
         LEFT JOIN loan l                    ON s.student_id = l.student_id
         LEFT JOIN loan_status_type ls       ON l.status_id = ls.status_id
         LEFT JOIN reservation r             ON s.student_id = r.student_id
         LEFT JOIN reservation_status_type rs ON r.status_id = rs.status_id
         LEFT JOIN academic_status_type acs   ON s.academic_status_id = acs.status_id
GROUP BY s.student_id, s.first_name, s.last_name, s.institutional_email,
         s.academic_program, s.semester, acs.status_name, s.pending_fines
ORDER BY s.first_name, s.last_name;

COMMENT ON VIEW v_student_statistics IS 'Comprehensive student activity statistics';



