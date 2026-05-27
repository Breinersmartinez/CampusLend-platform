-- VISTAS MATERIALIZADAS

-- Computadoras disponibles para préstamo / reserva
CREATE MATERIALIZED VIEW mv_computers_available AS
SELECT
    c.computer_id,
    c.inventory_code,
    c.brand,
    c.model,
    c.processor,
    c.ram_gb,
    c.storage_gb,
    c.qr_code,
    c.acquisition_date,
    c.notes,
    cs.status_name AS status
FROM computer c
         JOIN computer_status_type cs ON c.status_id = cs.status_id
WHERE cs.status_name = 'AVAILABLE'
ORDER BY c.brand, c.model;


-- Salas disponibles con equipamiento

CREATE MATERIALIZED VIEW mv_rooms_available AS
SELECT
    r.room_id,
    r.name,
    r.building,
    r.floor,
    r.room_number,
    r.max_capacity,
    r.opening_time,
    r.closing_time,
    rs.status_name AS room_status,
FROM room r
         JOIN room_status_type rs
              ON r.status_id = rs.status_id
         LEFT JOIN room_equipment re
                   ON r.room_id = re.room_id
         LEFT JOIN equipment_type et
                   ON re.equipment_type_id = et.equipment_type_id
WHERE rs.status_name = 'AVAILABLE'
GROUP BY r.room_id, rs.status_name;

-- Estadiusticas de estudiantes

CREATE MATERIALIZED VIEW mv_student_statistics AS
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email,
    s.academic_program,
    s.semester,
    acs.status_name AS academic_status,
    s.pending_fines,

    COUNT(DISTINCT l.loan_id) AS total_loans,

    COUNT(DISTINCT CASE
                       WHEN ls.status_name = 'ACTIVE'
                           THEN l.loan_id
        END) AS active_loans,

    COUNT(DISTINCT CASE
                       WHEN ls.status_name = 'OVERDUE'
                           THEN l.loan_id
        END) AS overdue_loans,

    COUNT(DISTINCT r.reservation_id) AS total_reservations,

    COUNT(DISTINCT CASE
                       WHEN rs.status_name = 'ACTIVE'
                           THEN r.reservation_id
        END) AS active_reservations

FROM student s
         LEFT JOIN loan l
                   ON s.student_id = l.student_id
         LEFT JOIN loan_status_type ls
                   ON l.status_id = ls.status_id
         LEFT JOIN reservation r
                   ON s.student_id = r.student_id
         LEFT JOIN reservation_status_type rs
                   ON r.status_id = rs.status_id
         LEFT JOIN academic_status_type acs
                   ON s.academic_status_id = acs.status_id

GROUP BY
    s.student_id,
    s.first_name,
    s.last_name,
    s.institutional_email,
    s.academic_program,
    s.semester,
    acs.status_name,
    s.pending_fines;

-- Prestamos vencidos
CREATE MATERIALIZED VIEW mv_overdue_loans AS
SELECT
    l.loan_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email,
    c.inventory_code,
    c.brand,
    c.model,
    l.expected_return_date,
    CURRENT_TIMESTAMP - l.expected_return_date AS time_overdue,
    ls.status_name AS loan_status
FROM loan l
         JOIN student s
              ON l.student_id = s.student_id
         JOIN computer c
              ON l.computer_id = c.computer_id
         JOIN loan_status_type ls
              ON l.status_id = ls.status_id
WHERE ls.status_name IN ('ACTIVE', 'OVERDUE')
  AND l.expected_return_date < CURRENT_TIMESTAMP;


-- Resumen de actividad de empleados

CREATE MATERIALIZED VIEW mv_employee_activity AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    rt.role_name,
    est.status_name AS employee_status,
    COUNT(a.audit_id) AS total_actions,
    MAX(a.date_time) AS last_action
FROM employee e
         LEFT JOIN role_type rt
                   ON e.role_id = rt.role_id
         LEFT JOIN employee_status_type est
                   ON e.status_id = est.status_id
         LEFT JOIN audit a
                   ON e.employee_id = a.employee_id
GROUP BY
    e.employee_id,
    employee_name,
    rt.role_name,
    est.status_name;



