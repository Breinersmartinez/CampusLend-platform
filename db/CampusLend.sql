

-- 1. CONFIGURACIÓN INICIAL

SET TIME ZONE 'UTC';

-- 2. EXTENSIONES

CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- UUID alternative

-- 3. TABLAS DE REFERENCIA (Catálogos)

-- 3.1 Roles de empleados
CREATE TABLE role_type (
                           role_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                           role_name     VARCHAR(50)   NOT NULL UNIQUE,
                           description   TEXT,
                           created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO role_type (role_name, description) VALUES
                                                   ('ADMINISTRATOR', 'Full access to system administration and reporting'),
                                                   ('IT_STAFF',      'Operational management of equipment and reservations');

COMMENT ON TABLE role_type IS 'Reference table for employee role types';

-- 3.2 Estados de empleados
CREATE TABLE employee_status_type (
                                      status_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                      status_name   VARCHAR(50)   NOT NULL UNIQUE,
                                      description   TEXT,
                                      created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO employee_status_type (status_name, description) VALUES
                                                                ('ACTIVE',     'Currently active employee with system access'),
                                                                ('INACTIVE',   'Inactive employee, no system access'),
                                                                ('SUSPENDED',  'Temporarily suspended from system'),
                                                                ('RETIRED',    'Retired employee, archived records');

COMMENT ON TABLE employee_status_type IS 'Reference table for employee status';

-- 3.3 Estados académicos de estudiantes
CREATE TABLE academic_status_type (
                                      status_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                      status_name   VARCHAR(50)   NOT NULL UNIQUE,
                                      description   TEXT,
                                      created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO academic_status_type (status_name, description) VALUES
                                                                ('ACTIVE',     'Currently enrolled student'),
                                                                ('INACTIVE',   'Not currently enrolled'),
                                                                ('SUSPENDED',  'Academic suspension'),
                                                                ('GRADUATED',  'Graduated student');

COMMENT ON TABLE academic_status_type IS 'Reference table for student academic status';

-- 3.4 Estados de salas
CREATE TABLE room_status_type (
                                  status_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                  status_name   VARCHAR(50)   NOT NULL UNIQUE,
                                  description   TEXT,
                                  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO room_status_type (status_name, description) VALUES
                                                            ('AVAILABLE',   'Room is available for reservation'),
                                                            ('MAINTENANCE', 'Room under maintenance'),
                                                            ('CLOSED',      'Room permanently closed'),
                                                            ('RESERVED',    'Currently reserved');

COMMENT ON TABLE room_status_type IS 'Reference table for room status';

-- 3.5 Tipos de equipamiento en salas
CREATE TABLE equipment_type (
                                equipment_type_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                equipment_name      VARCHAR(100)  NOT NULL UNIQUE,
                                description         TEXT,
                                created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO equipment_type (equipment_name, description) VALUES
                                                             ('PROJECTOR',      'Data projector for presentations'),
                                                             ('WHITEBOARD',     'Interactive whiteboard'),
                                                             ('DESK',           'Study desk'),
                                                             ('CHAIR',          'Study chair'),
                                                             ('COMPUTER',       'Desktop computer'),
                                                             ('PRINTER',        'Network printer'),
                                                             ('MONITOR',        'Additional monitor display'),
                                                             ('SPEAKER_SYSTEM', 'Audio speaker system');

COMMENT ON TABLE equipment_type IS 'Reference table for room equipment types';

-- 3.6 Estados de computadoras
CREATE TABLE computer_status_type (
                                      status_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                      status_name   VARCHAR(50)   NOT NULL UNIQUE,
                                      description   TEXT,
                                      created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO computer_status_type (status_name, description) VALUES
                                                                ('AVAILABLE',   'Available for loan or reservation'),
                                                                ('IN_LOAN',     'Currently loaned out'),
                                                                ('MAINTENANCE', 'Under maintenance'),
                                                                ('RETIRED',     'Equipment decommissioned'),
                                                                ('DAMAGED',     'Equipment damaged, not available');

COMMENT ON TABLE computer_status_type IS 'Reference table for computer status';

-- 3.7 Tipos de recurso para reservas
CREATE TABLE resource_type (
                               resource_type_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                               resource_name      VARCHAR(50)   NOT NULL UNIQUE,
                               description        TEXT,
                               created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO resource_type (resource_name, description) VALUES
                                                           ('ROOM',     'Physical room reservation'),
                                                           ('COMPUTER', 'Computer equipment reservation');

COMMENT ON TABLE resource_type IS 'Reference table for reservation resource types';

-- 3.8 Estados de reservas
CREATE TABLE reservation_status_type (
                                         status_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                         status_name   VARCHAR(50)   NOT NULL UNIQUE,
                                         description   TEXT,
                                         created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO reservation_status_type (status_name, description) VALUES
                                                                   ('ACTIVE',             'Reservation is active and pending'),
                                                                   ('CANCELLED',          'Reservation was cancelled'),
                                                                   ('COMPLETED',          'Reservation fulfilled'),
                                                                   ('CONVERTED_TO_LOAN',  'Reservation converted to computer loan');

COMMENT ON TABLE reservation_status_type IS 'Reference table for reservation status';

-- 3.9 Estados de préstamos
CREATE TABLE loan_status_type (
                                  status_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                  status_name   VARCHAR(50)   NOT NULL UNIQUE,
                                  description   TEXT,
                                  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO loan_status_type (status_name, description) VALUES
                                                            ('ACTIVE',    'Loan currently active, pending return'),
                                                            ('RETURNED',  'Equipment returned'),
                                                            ('OVERDUE',   'Loan return date exceeded'),
                                                            ('LOST',      'Equipment reported lost');

COMMENT ON TABLE loan_status_type IS 'Reference table for loan status';

-- 3.10 Estados de multas
CREATE TABLE fine_status_type (
                                  status_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                  status_name   VARCHAR(50)   NOT NULL UNIQUE,
                                  description   TEXT,
                                  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO fine_status_type (status_name, description) VALUES
                                                            ('PENDING',   'Fine not yet paid'),
                                                            ('PAID',      'Fine has been paid'),
                                                            ('WAIVED',    'Fine was waived by DTI decision'),
                                                            ('DISPUTED',  'Fine under dispute');

COMMENT ON TABLE fine_status_type IS 'Reference table for fine status';

-- 3.11 Tipos de acción para auditoría
CREATE TABLE audit_action_type (
                                   action_id     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                   action_name   VARCHAR(50)   NOT NULL UNIQUE,
                                   description   TEXT,
                                   created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO audit_action_type (action_name, description) VALUES
                                                             ('CREATE',  'Record was created'),
                                                             ('UPDATE',  'Record was updated'),
                                                             ('DELETE',  'Record was deleted'),
                                                             ('LOGIN',   'User login event'),
                                                             ('LOGOUT',  'User logout event');

COMMENT ON TABLE audit_action_type IS 'Reference table for audit action types';


-- 4. TABLAS PRINCIPALES


-- 4.1 EMPLEADO (DTI)
CREATE TABLE employee (
                          employee_id             UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                          card_id                 VARCHAR(20)   NOT NULL UNIQUE,
                          first_name              VARCHAR(150)  NOT NULL,
                          last_name               VARCHAR(150)  NOT NULL,
                          institutional_email     VARCHAR(100)  NOT NULL UNIQUE,
                          password_hash           VARCHAR(255)  NOT NULL,
                          role_id                 UUID          NOT NULL,
                          department              VARCHAR(100)  NOT NULL,
                          phone                   VARCHAR(20),
                          status_id               UUID          NOT NULL,
                          hire_date               DATE          NOT NULL DEFAULT CURRENT_DATE,
                          created_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                          updated_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  employee              IS 'IT personnel and administrators with system access';
COMMENT ON COLUMN employee.password_hash IS 'Password encrypted with BCrypt (Spring Security)';

-- 4.2 ESTUDIANTE
CREATE TABLE student (
                         student_id              UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                         id_card                 VARCHAR(20)   NOT NULL UNIQUE,
                         first_name              VARCHAR(150)  NOT NULL,
                         last_name               VARCHAR(150)  NOT NULL,
                         institutional_email     VARCHAR(100)  NOT NULL UNIQUE,
                         password_hash           VARCHAR(255)  NOT NULL,
                         academic_program        VARCHAR(150)  NOT NULL,
                         semester                SMALLINT      NOT NULL,
                         academic_status_id      UUID          NOT NULL,
                         pending_fines           NUMERIC(10,2) NOT NULL DEFAULT 0.00,
                         created_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                         updated_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  student               IS 'Registered students who can reserve rooms or request equipment loans';
COMMENT ON COLUMN student.pending_fines IS 'Total accumulated unpaid fines (recalculated by trigger)';

-- 4.3 SALA
CREATE TABLE room (
                      room_id         UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                      name            VARCHAR(100)  NOT NULL,
                      building        VARCHAR(50)   NOT NULL,
                      floor           SMALLINT      NOT NULL,
                      room_number     VARCHAR(20)   NOT NULL,
                      max_capacity    SMALLINT      NOT NULL,
                      opening_time    TIME          NOT NULL,
                      closing_time    TIME          NOT NULL,
                      status_id       UUID          NOT NULL,
                      created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                      updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

                      UNIQUE (building, floor, room_number)
);

COMMENT ON TABLE room IS 'Study and work rooms available for reservation by students';

-- 4.4 EQUIPAMIENTO DE SALA
CREATE TABLE room_equipment (
                                room_equipment_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                room_id             UUID        NOT NULL,
                                equipment_type_id   UUID        NOT NULL,
                                quantity            SMALLINT    NOT NULL DEFAULT 1,
                                notes               TEXT,
                                created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                UNIQUE (room_id, equipment_type_id)
);

COMMENT ON TABLE room_equipment IS 'Equipment inventory available in each room';

-- 4.5 COMPUTADORA
CREATE TABLE computer (
                          computer_id       UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                          inventory_code    VARCHAR(50)   NOT NULL UNIQUE,
                          model             VARCHAR(100)  NOT NULL,
                          brand             VARCHAR(100)  NOT NULL,
                          processor         VARCHAR(100)  NOT NULL,
                          ram_gb            SMALLINT      NOT NULL,
                          storage_gb        INTEGER       NOT NULL,
                          qr_code           VARCHAR(255)  UNIQUE,
                          status_id         UUID          NOT NULL,
                          acquisition_date  DATE          NOT NULL,
                          notes             TEXT,
                          created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                          updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  computer                IS 'Laptops available for direct loan or prior reservation';
COMMENT ON COLUMN computer.inventory_code IS 'Unique physical inventory label code';
COMMENT ON COLUMN computer.qr_code        IS 'QR or barcode generated for quick identification';

-- 4.6 RESERVA (Solo para estudiantes)
CREATE TABLE reservation (
                             reservation_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                             student_id           UUID        NOT NULL,
                             resource_type_id     UUID        NOT NULL,
                             room_id              UUID,
                             computer_id          UUID,
                             reservation_date     DATE        NOT NULL,
                             start_time           TIME        NOT NULL,
                             end_time             TIME        NOT NULL,
                             status_id            UUID        NOT NULL,
                             cancellation_reason  TEXT,
                             created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                             updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  reservation                   IS 'Reservations of rooms or computers by students';
COMMENT ON COLUMN reservation.resource_type_id  IS 'ROOM or COMPUTER — determines which FK (room_id/computer_id) is active';

-- 4.7 PRÉSTAMO (Solo para estudiantes)
CREATE TABLE loan (
                      loan_id                 UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                      student_id              UUID        NOT NULL,
                      computer_id             UUID        NOT NULL,
                      employee_registrant_id  UUID        NOT NULL,
                      reservation_id          UUID        UNIQUE,
                      request_date            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                      expected_return_date    TIMESTAMPTZ NOT NULL,
                      actual_return_date      TIMESTAMPTZ,
                      status_id               UUID        NOT NULL,
                      notes                   TEXT,
                      created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                      updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  loan                        IS 'Computer loans to students. reservation_id NULL = direct loan';
COMMENT ON COLUMN loan.employee_registrant_id IS 'IT employee who physically delivered the equipment';
COMMENT ON COLUMN loan.reservation_id         IS 'Optional: linked reservation. NULL means direct loan without prior reservation';

-- 4.8 MULTA (Solo para estudiantes)
CREATE TABLE fine (
                      fine_id             UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                      student_id          UUID          NOT NULL,
                      loan_id             UUID,
                      amount              NUMERIC(10,2) NOT NULL,
                      reason              TEXT          NOT NULL,
                      status_id           UUID          NOT NULL,
                      generation_date     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                      payment_date        TIMESTAMPTZ,
                      created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                      updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  fine             IS 'Fines applied to students';
COMMENT ON COLUMN fine.loan_id     IS 'Optional: linked loan. NULL means fine was issued without a loan origin';

-- 4.9 AUDITORÍA
CREATE TABLE audit (
                       audit_id        UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                       affected_table  VARCHAR(100)  NOT NULL,
                       record_id       VARCHAR(100),
                       action_id       UUID          NOT NULL,
                       employee_id     UUID,
                       student_id      UUID,
                       user_role       VARCHAR(50),
                       previous_data   JSONB,
                       new_data        JSONB,
                       source_ip       INET,
                       date_time       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  audit              IS 'Immutable log of all critical system operations. Never updated or deleted';


-- 5. LLAVES FORÁNEAS (FOREIGN KEYS)


-- Restricciones para EMPLOYEE
ALTER TABLE employee
    ADD CONSTRAINT check_employee_email
        CHECK (institutional_email LIKE '%@ucc.edu.co'),
    ADD CONSTRAINT fk_employee_role
        FOREIGN KEY (role_id) REFERENCES role_type(role_id),
    ADD CONSTRAINT fk_employee_status
        FOREIGN KEY (status_id) REFERENCES employee_status_type(status_id);

-- Restricciones para STUDENT
ALTER TABLE student
    ADD CONSTRAINT check_student_email
        CHECK (institutional_email LIKE '%@campusucc.edu.co'),
    ADD CONSTRAINT check_semester
        CHECK (semester BETWEEN 1 AND 12),
    ADD CONSTRAINT check_pending_fines
        CHECK (pending_fines >= 0),
    ADD CONSTRAINT fk_student_academic_status
        FOREIGN KEY (academic_status_id) REFERENCES academic_status_type(status_id);

-- Restricciones para ROOM
ALTER TABLE room
    ADD CONSTRAINT check_floor
        CHECK (floor >= 0),
    ADD CONSTRAINT check_max_capacity
        CHECK (max_capacity > 0),
    ADD CONSTRAINT check_closing_time
        CHECK (closing_time > opening_time),
    ADD CONSTRAINT fk_room_status
        FOREIGN KEY (status_id) REFERENCES room_status_type(status_id);

-- Restricciones para ROOM_EQUIPMENT
ALTER TABLE room_equipment
    ADD CONSTRAINT check_quantity
        CHECK (quantity > 0),
    ADD CONSTRAINT fk_room_equipment_room
        FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_room_equipment_type
        FOREIGN KEY (equipment_type_id) REFERENCES equipment_type(equipment_type_id);

-- Restricciones para COMPUTER
ALTER TABLE computer
    ADD CONSTRAINT check_ram
        CHECK (ram_gb > 0),
    ADD CONSTRAINT check_storage
        CHECK (storage_gb > 0),
    ADD CONSTRAINT fk_computer_status
        FOREIGN KEY (status_id) REFERENCES computer_status_type(status_id);

-- Restricciones para RESERVATION
ALTER TABLE reservation
    ADD CONSTRAINT check_reservation_end_time
        CHECK (end_time > start_time),
    ADD CONSTRAINT check_student_not_null
        CHECK (student_id IS NOT NULL),
    ADD CONSTRAINT check_resource_xor
        CHECK ((room_id IS NOT NULL AND computer_id IS NULL) OR (room_id IS NULL AND computer_id IS NOT NULL)),
    ADD CONSTRAINT fk_reservation_student
        FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_reservation_resource_type
        FOREIGN KEY (resource_type_id) REFERENCES resource_type(resource_type_id),
    ADD CONSTRAINT fk_reservation_room
        FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_reservation_computer
        FOREIGN KEY (computer_id) REFERENCES computer(computer_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_reservation_status
        FOREIGN KEY (status_id) REFERENCES reservation_status_type(status_id);

-- Restricciones para LOAN
ALTER TABLE loan
    ADD CONSTRAINT check_student_not_null
        CHECK (student_id IS NOT NULL),
    ADD CONSTRAINT check_dates
        CHECK (expected_return_date > request_date),
    ADD CONSTRAINT fk_loan_student
        FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_loan_computer
        FOREIGN KEY (computer_id) REFERENCES computer(computer_id),
    ADD CONSTRAINT fk_loan_employee
        FOREIGN KEY (employee_registrant_id) REFERENCES employee(employee_id),
    ADD CONSTRAINT fk_loan_reservation
        FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_loan_status
        FOREIGN KEY (status_id) REFERENCES loan_status_type(status_id);

-- Restricciones para FINE
ALTER TABLE fine
    ADD CONSTRAINT check_amount_positive
        CHECK (amount > 0),
    ADD CONSTRAINT fk_fine_student
        FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_fine_loan
        FOREIGN KEY (loan_id) REFERENCES loan(loan_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_fine_status
        FOREIGN KEY (status_id) REFERENCES fine_status_type(status_id);

-- Restricciones para AUDIT
ALTER TABLE audit
    ADD CONSTRAINT fk_audit_action
        FOREIGN KEY (action_id) REFERENCES audit_action_type(action_id),
    ADD CONSTRAINT fk_audit_employee
        FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_audit_student
        FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL;


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



-- PROCEDIMIENTOS ALMACENADOS

-- Insertar reserva
CREATE OR REPLACE PROCEDURE sp_create_reservation(
    p_student_id UUID,
    p_resource_type_id UUID,
    p_room_id UUID,
    p_computer_id UUID,
    p_reservation_date DATE,
    p_start_time TIME,
    p_end_time TIME
)
LANGUAGE plpgsql
AS $$
DECLARE
v_status_id UUID;
BEGIN

SELECT status_id
INTO v_status_id
FROM reservation_status_type
WHERE status_name = 'ACTIVE';

INSERT INTO reservation (
    student_id,
    resource_type_id,
    room_id,
    computer_id,
    reservation_date,
    start_time,
    end_time,
    status_id
)
VALUES (
           p_student_id,
           p_resource_type_id,
           p_room_id,
           p_computer_id,
           p_reservation_date,
           p_start_time,
           p_end_time,
           v_status_id
       );

END;
$$;

CALL sp_create_reservation(
    'UUID_ESTUDIANTE',
    'UUID_RESOURCE_TYPE',
    'UUID_ROOM',
    NULL,
    CURRENT_DATE,
    '08:00',
    '10:00'
);



-- Cancellar reserva

CREATE OR REPLACE PROCEDURE sp_cancel_reservation(
    p_reservation_id UUID,
    p_reason TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
v_status_id UUID;
BEGIN

SELECT status_id
INTO v_status_id
FROM reservation_status_type
WHERE status_name = 'CANCELLED';

UPDATE reservation
SET
    status_id = v_status_id,
    cancellation_reason = p_reason,
    updated_at = NOW()
WHERE reservation_id = p_reservation_id;

END;
$$;


-- registrar prestamo

CREATE OR REPLACE PROCEDURE sp_create_loan(
    p_student_id UUID,
    p_computer_id UUID,
    p_employee_id UUID,
    p_expected_return_date TIMESTAMPTZ,
    p_reservation_id UUID DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
v_loan_status UUID;
    v_computer_status UUID;
BEGIN

SELECT status_id
INTO v_loan_status
FROM loan_status_type
WHERE status_name = 'ACTIVE';

INSERT INTO loan (
    student_id,
    computer_id,
    employee_registrant_id,
    reservation_id,
    expected_return_date,
    status_id
)
VALUES (
           p_student_id,
           p_computer_id,
           p_employee_id,
           p_reservation_id,
           p_expected_return_date,
           v_loan_status
       );

SELECT status_id
INTO v_computer_status
FROM computer_status_type
WHERE status_name = 'IN_LOAN';

UPDATE computer
SET status_id = v_computer_status,
    updated_at = NOW()
WHERE computer_id = p_computer_id;

END;
$$;

CALL sp_create_loan(
    'UUID_ESTUDIANTE',
    'UUID_COMPUTER',
    'UUID_EMPLEADO',
    NOW() + INTERVAL '7 days'
);

-- registrar devolucion
CREATE OR REPLACE PROCEDURE sp_return_loan(
    p_loan_id UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
v_returned_status UUID;
    v_available_status UUID;
    v_computer_id UUID;
BEGIN

SELECT status_id
INTO v_returned_status
FROM loan_status_type
WHERE status_name = 'RETURNED';

UPDATE loan
SET
    actual_return_date = NOW(),
    status_id = v_returned_status,
    updated_at = NOW()
WHERE loan_id = p_loan_id
    RETURNING computer_id INTO v_computer_id;

SELECT status_id
INTO v_available_status
FROM computer_status_type
WHERE status_name = 'AVAILABLE';

UPDATE computer
SET
    status_id = v_available_status,
    updated_at = NOW()
WHERE computer_id = v_computer_id;

END;
$$;


CALL sp_return_loan('UUID_LOAN');
-- registrar multa

CREATE OR REPLACE PROCEDURE sp_create_fine(
    p_student_id UUID,
    p_loan_id UUID,
    p_amount NUMERIC,
    p_reason TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
v_status_id UUID;
BEGIN

SELECT status_id
INTO v_status_id
FROM fine_status_type
WHERE status_name = 'PENDING';

INSERT INTO fine (
    student_id,
    loan_id,
    amount,
    reason,
    status_id
)
VALUES (
           p_student_id,
           p_loan_id,
           p_amount,
           p_reason,
           v_status_id
       );

UPDATE student
SET pending_fines = pending_fines + p_amount,
    updated_at = NOW()
WHERE student_id = p_student_id;

END;
$$;


