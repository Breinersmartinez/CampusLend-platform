
SET TIME ZONE 'UTC';

-- EXTENSIONS

CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- UUID alternative



-- Employee role types
CREATE TABLE role_type (
                           role_id              SERIAL            PRIMARY KEY,
                           role_name            VARCHAR(50)       NOT NULL UNIQUE,
                           description          TEXT,
                           created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO role_type (role_name, description) VALUES
                                                   ('ADMINISTRATOR', 'Full access to system administration and reporting'),
                                                   ('IT_STAFF', 'Operational management of equipment and reservations');

COMMENT ON TABLE role_type IS 'Reference table for employee role types';


-- Employee status types
CREATE TABLE employee_status_type (
                                      status_id            SERIAL            PRIMARY KEY,
                                      status_name          VARCHAR(50)       NOT NULL UNIQUE,
                                      description          TEXT,
                                      created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO employee_status_type (status_name, description) VALUES
                                                                ('ACTIVE', 'Currently active employee with system access'),
                                                                ('INACTIVE', 'Inactive employee, no access to system'),
                                                                ('SUSPENDED', 'Temporarily suspended from system'),
                                                                ('RETIRED', 'Retired employee, archived records');

COMMENT ON TABLE employee_status_type IS 'Reference table for employee status';


-- Student academic status types
CREATE TABLE academic_status_type (
                                      status_id            SERIAL            PRIMARY KEY,
                                      status_name          VARCHAR(50)       NOT NULL UNIQUE,
                                      description          TEXT,
                                      created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO academic_status_type (status_name, description) VALUES
                                                                ('ACTIVE', 'Currently enrolled student'),
                                                                ('INACTIVE', 'Not currently enrolled'),
                                                                ('SUSPENDED', 'Academic suspension'),
                                                                ('GRADUATED', 'Graduated student');

COMMENT ON TABLE academic_status_type IS 'Reference table for student academic status';


-- Room status types
CREATE TABLE room_status_type (
                                  status_id            SERIAL            PRIMARY KEY,
                                  status_name          VARCHAR(50)       NOT NULL UNIQUE,
                                  description          TEXT,
                                  created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO room_status_type (status_name, description) VALUES
                                                            ('AVAILABLE', 'Room is available for reservation'),
                                                            ('MAINTENANCE', 'Room under maintenance'),
                                                            ('CLOSED', 'Room permanently closed'),
                                                            ('RESERVED', 'Currently reserved');

COMMENT ON TABLE room_status_type IS 'Reference table for room status';


-- Equipment type in rooms
CREATE TABLE equipment_type (
                                equipment_type_id    SERIAL            PRIMARY KEY,
                                equipment_name       VARCHAR(100)      NOT NULL UNIQUE,
                                description          TEXT,
                                created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO equipment_type (equipment_name, description) VALUES
                                                             ('PROJECTOR', 'Data projector for presentations'),
                                                             ('WHITEBOARD', 'Interactive whiteboard'),
                                                             ('DESK', 'Study desk'),
                                                             ('CHAIR', 'Study chair'),
                                                             ('COMPUTER', 'Desktop computer'),
                                                             ('PRINTER', 'Network printer'),
                                                             ('MONITOR', 'Additional monitor display'),
                                                             ('SPEAKER_SYSTEM', 'Audio speaker system');

COMMENT ON TABLE equipment_type IS 'Reference table for room equipment types';


-- Computer status types
CREATE TABLE computer_status_type (
                                      status_id            SERIAL            PRIMARY KEY,
                                      status_name          VARCHAR(50)       NOT NULL UNIQUE,
                                      description          TEXT,
                                      created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO computer_status_type (status_name, description) VALUES
                                                                ('AVAILABLE', 'Available for loan or reservation'),
                                                                ('IN_LOAN', 'Currently loaned to student'),
                                                                ('MAINTENANCE', 'Under maintenance'),
                                                                ('RETIRED', 'Equipment decommissioned'),
                                                                ('DAMAGED', 'Equipment damaged, not available');

COMMENT ON TABLE computer_status_type IS 'Reference table for computer status';


-- Reservation status types
CREATE TABLE reservation_status_type (
                                         status_id            SERIAL            PRIMARY KEY,
                                         status_name          VARCHAR(50)       NOT NULL UNIQUE,
                                         description          TEXT,
                                         created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO reservation_status_type (status_name, description) VALUES
                                                                   ('ACTIVE', 'Reservation is active and pending'),
                                                                   ('CANCELLED', 'Reservation was cancelled'),
                                                                   ('COMPLETED', 'Reservation fulfilled'),
                                                                   ('CONVERTED_TO_LOAN', 'Reservation converted to computer loan');

COMMENT ON TABLE reservation_status_type IS 'Reference table for reservation status';


-- Resource type for reservations
CREATE TABLE resource_type (
                               resource_type_id     SERIAL            PRIMARY KEY,
                               resource_name        VARCHAR(50)       NOT NULL UNIQUE,
                               description          TEXT,
                               created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO resource_type (resource_name, description) VALUES
                                                           ('ROOM', 'Physical room reservation'),
                                                           ('COMPUTER', 'Computer equipment reservation');

COMMENT ON TABLE resource_type IS 'Reference table for reservation resource types';


-- Loan status types
CREATE TABLE loan_status_type (
                                  status_id            SERIAL            PRIMARY KEY,
                                  status_name          VARCHAR(50)       NOT NULL UNIQUE,
                                  description          TEXT,
                                  created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO loan_status_type (status_name, description) VALUES
                                                            ('ACTIVE', 'Loan currently active, pending return'),
                                                            ('RETURNED', 'Equipment returned by student'),
                                                            ('OVERDUE', 'Loan return date exceeded'),
                                                            ('LOST', 'Equipment reported lost');

COMMENT ON TABLE loan_status_type IS 'Reference table for loan status';


-- Fine status types
CREATE TABLE fine_status_type (
                                  status_id            SERIAL            PRIMARY KEY,
                                  status_name          VARCHAR(50)       NOT NULL UNIQUE,
                                  description          TEXT,
                                  created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO fine_status_type (status_name, description) VALUES
                                                            ('PENDING', 'Fine not yet paid'),
                                                            ('PAID', 'Fine has been paid'),
                                                            ('WAIVED', 'Fine was waived'),
                                                            ('DISPUTED', 'Fine under dispute');

COMMENT ON TABLE fine_status_type IS 'Reference table for fine status';


-- Audit action types
CREATE TABLE audit_action_type (
                                   action_id            SERIAL            PRIMARY KEY,
                                   action_name          VARCHAR(50)       NOT NULL UNIQUE,
                                   description          TEXT,
                                   created_at           TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

INSERT INTO audit_action_type (action_name, description) VALUES
                                                             ('CREATE', 'Record was created'),
                                                             ('UPDATE', 'Record was updated'),
                                                             ('DELETE', 'Record was deleted'),
                                                             ('LOGIN', 'User login event'),
                                                             ('LOGOUT', 'User logout event');

COMMENT ON TABLE audit_action_type IS 'Reference table for audit action types';


-- CORE TABLES

-- Employee (IT personnel and administrators)
CREATE TABLE employee (
                          employee_id              UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
                          card_id                  VARCHAR(20)       NOT NULL UNIQUE,
                          first_name               VARCHAR(150)      NOT NULL,
                          last_name                VARCHAR(150)      NOT NULL,
                          institutional_email      VARCHAR(100)      NOT NULL UNIQUE,
                          password_hash            VARCHAR(255)      NOT NULL,
                          role_id                  INTEGER           NOT NULL,
                          department               VARCHAR(100)      NOT NULL,
                          phone                    VARCHAR(20),
                          status_id                INTEGER           NOT NULL,
                          hire_date                DATE              NOT NULL DEFAULT CURRENT_DATE,
                          created_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                          updated_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

ALTER TABLE employee ADD CONSTRAINT check_institutional_email
    CHECK (institutional_email LIKE '%@ucc.edu.co');

ALTER TABLE employee ADD CONSTRAINT fk_employee_role
    FOREIGN KEY (role_id) REFERENCES role_type(role_id);

ALTER TABLE employee ADD CONSTRAINT fk_employee_status
    FOREIGN KEY (status_id) REFERENCES employee_status_type(status_id);

CREATE INDEX idx_employee_email ON employee(institutional_email);
CREATE INDEX idx_employee_card_id ON employee(card_id);
CREATE INDEX idx_employee_status ON employee(status_id);

COMMENT ON TABLE employee IS 'IT personnel and administrators with system access';
COMMENT ON COLUMN employee.password_hash IS 'Password encrypted with BCrypt (Spring Security)';
COMMENT ON COLUMN employee.institutional_email IS 'Must be institutional domain @ucc.edu.co';


-- Student (Students who can make reservations and loans)
CREATE TABLE student (
                         student_id               UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
                         id_card                  VARCHAR(20)       NOT NULL UNIQUE,
                         first_name               VARCHAR(150)      NOT NULL,
                         last_name                VARCHAR(150)      NOT NULL,
                         institutional_email      VARCHAR(100)      NOT NULL UNIQUE,
                         password_hash            VARCHAR(255)      NOT NULL,
                         academic_program         VARCHAR(150)      NOT NULL,
                         semester                 SMALLINT          NOT NULL,
                         academic_status_id       INTEGER           NOT NULL,
                         pending_fines            NUMERIC(10,2)     NOT NULL DEFAULT 0.00,
                         created_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                         updated_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

ALTER TABLE student ADD CONSTRAINT check_institutional_email
    CHECK (institutional_email LIKE '%@campusucc.edu.co');

ALTER TABLE student ADD CONSTRAINT check_semester
    CHECK (semester BETWEEN 1 AND 12);

ALTER TABLE student ADD CONSTRAINT check_pending_fines
    CHECK (pending_fines >= 0);

ALTER TABLE student ADD CONSTRAINT fk_student_academic_status
    FOREIGN KEY (academic_status_id) REFERENCES academic_status_type(status_id);

CREATE INDEX idx_student_email ON student(institutional_email);
CREATE INDEX idx_student_id_card ON student(id_card);
CREATE INDEX idx_student_academic_status ON student(academic_status_id);
CREATE INDEX idx_student_pending_fines ON student(pending_fines)
    WHERE pending_fines > 0;

COMMENT ON TABLE student IS 'Registered students who can reserve rooms or request equipment loans';
COMMENT ON COLUMN student.academic_status_id IS 'Foreign key to academic_status_type table';
COMMENT ON COLUMN student.pending_fines IS 'Total accumulated unpaid fines (calculated field)';

-- Room (Study and work spaces)
CREATE TABLE room (
                      room_id                  UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
                      name                     VARCHAR(100)      NOT NULL,
                      building                 VARCHAR(50)       NOT NULL,
                      floor                    SMALLINT          NOT NULL,
                      room_number              VARCHAR(20)       NOT NULL,
                      max_capacity             SMALLINT          NOT NULL,
                      opening_time             TIME              NOT NULL,
                      closing_time             TIME              NOT NULL,
                      status_id                INTEGER           NOT NULL,
                      created_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                      updated_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                      UNIQUE (building, floor, room_number)
);

ALTER TABLE room ADD CONSTRAINT check_floor
    CHECK (floor >= 0);

ALTER TABLE room ADD CONSTRAINT check_max_capacity
    CHECK (max_capacity > 0);

ALTER TABLE room ADD CONSTRAINT check_closing_time
    CHECK (closing_time > opening_time);

ALTER TABLE room ADD CONSTRAINT fk_room_status
    FOREIGN KEY (status_id) REFERENCES room_status_type(status_id);

CREATE INDEX idx_room_building ON room(building);
CREATE INDEX idx_room_status ON room(status_id);
CREATE INDEX idx_room_location ON room(building, floor);

COMMENT ON TABLE room IS 'Study and work rooms available for student reservation';
COMMENT ON COLUMN room.opening_time IS 'Room opening time (e.g., 07:00)';
COMMENT ON COLUMN room.closing_time IS 'Room closing time (e.g., 22:00)';
COMMENT ON COLUMN room.max_capacity IS 'Maximum number of students per room';


-- Room Equipment (Equipment inventory per room)
CREATE TABLE room_equipment (
                                room_equipment_id        UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
                                room_id                  UUID              NOT NULL,
                                equipment_type_id        INTEGER           NOT NULL,
                                quantity                 SMALLINT          NOT NULL DEFAULT 1,
                                notes                    TEXT,
                                created_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                                updated_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                                UNIQUE (room_id, equipment_type_id)
);

ALTER TABLE room_equipment ADD CONSTRAINT check_quantity
    CHECK (quantity > 0);

ALTER TABLE room_equipment ADD CONSTRAINT fk_room_equipment_room
    FOREIGN KEY (room_id) REFERENCES room(room_id)
        ON DELETE CASCADE;

ALTER TABLE room_equipment ADD CONSTRAINT fk_room_equipment_type
    FOREIGN KEY (equipment_type_id) REFERENCES equipment_type(equipment_type_id);

CREATE INDEX idx_room_equipment_room ON room_equipment(room_id);
CREATE INDEX idx_room_equipment_type ON room_equipment(equipment_type_id);

COMMENT ON TABLE room_equipment IS 'Equipment inventory available in each room';


-- Computer (Portable devices available for loan/reservation)
CREATE TABLE computer (
                          computer_id              UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
                          inventory_code           VARCHAR(50)       NOT NULL UNIQUE,
                          model                    VARCHAR(100)      NOT NULL,
                          brand                    VARCHAR(100)      NOT NULL,
                          processor                VARCHAR(100)      NOT NULL,
                          ram_gb                   SMALLINT          NOT NULL,
                          storage_gb               INTEGER           NOT NULL,
                          qr_code                  VARCHAR(255)      UNIQUE,
                          status_id                INTEGER           NOT NULL,
                          acquisition_date         DATE              NOT NULL,
                          notes                    TEXT,
                          created_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                          updated_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

ALTER TABLE computer ADD CONSTRAINT check_ram
    CHECK (ram_gb > 0);

ALTER TABLE computer ADD CONSTRAINT check_storage
    CHECK (storage_gb > 0);

ALTER TABLE computer ADD CONSTRAINT fk_computer_status
    FOREIGN KEY (status_id) REFERENCES computer_status_type(status_id);

CREATE INDEX idx_computer_inventory ON computer(inventory_code);
CREATE INDEX idx_computer_status ON computer(status_id);
CREATE INDEX idx_computer_qr ON computer(qr_code);

COMMENT ON TABLE computer IS 'Laptops available for loan or prior reservation';
COMMENT ON COLUMN computer.inventory_code IS 'Unique physical inventory code (label on equipment)';
COMMENT ON COLUMN computer.qr_code IS 'QR or barcode for quick identification';
COMMENT ON COLUMN computer.status_id IS 'Current status of the computer (AVAILABLE, IN_LOAN, etc.)';


-- Reservation (Room or computer reservations by students)
CREATE TABLE reservation (
                             reservation_id           UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
                             student_id               UUID              NOT NULL,
                             resource_type_id         INTEGER           NOT NULL,
                             room_id                  UUID,
                             computer_id              UUID,
                             reservation_date         DATE              NOT NULL,
                             start_time               TIME              NOT NULL,
                             end_time                 TIME              NOT NULL,
                             status_id                INTEGER           NOT NULL,
                             cancellation_reason      TEXT,
                             created_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                             updated_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

ALTER TABLE reservation ADD CONSTRAINT check_end_time
    CHECK (end_time > start_time);

ALTER TABLE reservation ADD CONSTRAINT fk_reservation_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
        ON DELETE CASCADE;

ALTER TABLE reservation ADD CONSTRAINT fk_reservation_resource_type
    FOREIGN KEY (resource_type_id) REFERENCES resource_type(resource_type_id);

ALTER TABLE reservation ADD CONSTRAINT fk_reservation_room
    FOREIGN KEY (room_id) REFERENCES room(room_id)
        ON DELETE SET NULL;

ALTER TABLE reservation ADD CONSTRAINT fk_reservation_computer
    FOREIGN KEY (computer_id) REFERENCES computer(computer_id)
        ON DELETE SET NULL;

ALTER TABLE reservation ADD CONSTRAINT fk_reservation_status
    FOREIGN KEY (status_id) REFERENCES reservation_status_type(status_id);

CREATE INDEX idx_reservation_student ON reservation(student_id);
CREATE INDEX idx_reservation_date ON reservation(reservation_date);
CREATE INDEX idx_reservation_status ON reservation(status_id);
CREATE INDEX idx_reservation_resource ON reservation(resource_type_id);
CREATE INDEX idx_reservation_room ON reservation(room_id) WHERE room_id IS NOT NULL;
CREATE INDEX idx_reservation_computer ON reservation(computer_id) WHERE computer_id IS NOT NULL;

COMMENT ON TABLE reservation IS 'Reservations of rooms or computers. resource_type determines which resource applies';
COMMENT ON COLUMN reservation.resource_type_id IS 'ROOM or COMPUTER reservation type';
COMMENT ON COLUMN reservation.status_id IS 'ACTIVE, CANCELLED, COMPLETED, or CONVERTED_TO_LOAN';


-- Loan (Computer loans with optional prior reservation)
CREATE TABLE loan (
                      loan_id                  UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
                      student_id               UUID              NOT NULL,
                      computer_id              UUID              NOT NULL,
                      employee_registrant_id   UUID              NOT NULL,
                      reservation_id           UUID              UNIQUE,
                      request_date             TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                      expected_return_date     TIMESTAMPTZ       NOT NULL,
                      actual_return_date       TIMESTAMPTZ,
                      status_id                INTEGER           NOT NULL,
                      notes                    TEXT,
                      created_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                      updated_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

ALTER TABLE loan ADD CONSTRAINT check_expected_return
    CHECK (expected_return_date > request_date);

ALTER TABLE loan ADD CONSTRAINT check_actual_return
    CHECK (actual_return_date IS NULL OR actual_return_date >= request_date);

ALTER TABLE loan ADD CONSTRAINT fk_loan_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
        ON DELETE CASCADE;

ALTER TABLE loan ADD CONSTRAINT fk_loan_computer
    FOREIGN KEY (computer_id) REFERENCES computer(computer_id)
        ON DELETE RESTRICT;

ALTER TABLE loan ADD CONSTRAINT fk_loan_employee
    FOREIGN KEY (employee_registrant_id) REFERENCES employee(employee_id)
        ON DELETE SET NULL;

ALTER TABLE loan ADD CONSTRAINT fk_loan_reservation
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id)
        ON DELETE SET NULL;

ALTER TABLE loan ADD CONSTRAINT fk_loan_status
    FOREIGN KEY (status_id) REFERENCES loan_status_type(status_id);

CREATE INDEX idx_loan_student ON loan(student_id);
CREATE INDEX idx_loan_computer ON loan(computer_id);
CREATE INDEX idx_loan_status ON loan(status_id);
CREATE INDEX idx_loan_request_date ON loan(request_date);
CREATE INDEX idx_loan_return_date ON loan(expected_return_date)
    WHERE status_id IN (1, 3);  -- ACTIVE or OVERDUE

COMMENT ON TABLE loan IS 'Computer loans. reservation_id is NULL for direct loans without prior reservation';
COMMENT ON COLUMN loan.employee_registrant_id IS 'IT employee who delivered the equipment';
COMMENT ON COLUMN loan.status_id IS 'ACTIVE, RETURNED, OVERDUE, or LOST';


-- Fine (Non-compliance fines)
CREATE TABLE fine (
                      fine_id                  UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
                      student_id               UUID              NOT NULL,
                      loan_id                  UUID,
                      amount                   NUMERIC(10,2)     NOT NULL,
                      reason                   TEXT              NOT NULL,
                      status_id                INTEGER           NOT NULL,
                      generation_date          TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                      payment_date             TIMESTAMPTZ,
                      created_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
                      updated_at               TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

ALTER TABLE fine ADD CONSTRAINT check_amount
    CHECK (amount > 0);

ALTER TABLE fine ADD CONSTRAINT check_payment_date
    CHECK (payment_date IS NULL OR payment_date >= generation_date);

ALTER TABLE fine ADD CONSTRAINT fk_fine_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
        ON DELETE CASCADE;

ALTER TABLE fine ADD CONSTRAINT fk_fine_loan
    FOREIGN KEY (loan_id) REFERENCES loan(loan_id)
        ON DELETE SET NULL;

ALTER TABLE fine ADD CONSTRAINT fk_fine_status
    FOREIGN KEY (status_id) REFERENCES fine_status_type(status_id);

CREATE INDEX idx_fine_student ON fine(student_id);
CREATE INDEX idx_fine_status ON fine(status_id);
CREATE INDEX idx_fine_generation_date ON fine(generation_date);
CREATE INDEX idx_fine_payment_date ON fine(payment_date) WHERE payment_date IS NOT NULL;

COMMENT ON TABLE fine IS 'Economic fines for non-compliance. Updates student.pending_fines';


-- Audit (Immutable log of critical operations)
CREATE TABLE audit (
                       audit_id                 UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
                       affected_table           VARCHAR(100)      NOT NULL,
                       record_id                VARCHAR(100),
                       action_id                INTEGER           NOT NULL,
                       employee_id              UUID,
                       student_id               UUID,
                       user_role                VARCHAR(50),
                       previous_data            JSONB,
                       new_data                 JSONB,
                       source_ip                INET,
                       date_time                TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

ALTER TABLE audit ADD CONSTRAINT fk_audit_action
    FOREIGN KEY (action_id) REFERENCES audit_action_type(action_id);

ALTER TABLE audit ADD CONSTRAINT fk_audit_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
        ON DELETE SET NULL;

ALTER TABLE audit ADD CONSTRAINT fk_audit_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
        ON DELETE SET NULL;

CREATE INDEX idx_audit_table ON audit(affected_table);
CREATE INDEX idx_audit_date ON audit(date_time DESC);
CREATE INDEX idx_audit_employee ON audit(employee_id) WHERE employee_id IS NOT NULL;
CREATE INDEX idx_audit_student ON audit(student_id) WHERE student_id IS NOT NULL;
CREATE INDEX idx_audit_action ON audit(action_id);

COMMENT ON TABLE audit IS 'Immutable log of critical system operations. Never deleted or updated';
COMMENT ON COLUMN audit.previous_data IS 'Record state before change (JSON format)';
COMMENT ON COLUMN audit.new_data IS 'Record state after change (JSON format)';



-- DATABASE VIEWS

-- Available computers for loan/reservation
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
WHERE cs.status_name = 'AVAILABLE';

COMMENT ON VIEW v_computers_available IS 'List of computers currently available for loan or reservation';


-- Available rooms with equipment inventory
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
            JSON_BUILD_OBJECT(
                    'equipment_name', et.equipment_name,
                    'quantity', re.quantity
            )
    ) FILTER (WHERE re.room_equipment_id IS NOT NULL) AS equipment
FROM room r
         JOIN room_status_type rs ON r.status_id = rs.status_id
         LEFT JOIN room_equipment re ON r.room_id = re.room_id
         LEFT JOIN equipment_type et ON re.equipment_type_id = et.equipment_type_id
WHERE rs.status_name = 'AVAILABLE'
GROUP BY r.room_id, r.name, r.building, r.floor, r.room_number,
         r.max_capacity, r.opening_time, r.closing_time, rs.status_name;

COMMENT ON VIEW v_rooms_available IS 'Available rooms with equipment inventory as JSON';


-- Active loans with student and equipment details
CREATE OR REPLACE VIEW v_active_loans AS
SELECT
    l.loan_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email AS student_email,
    c.inventory_code,
    c.brand,
    c.model,
    CONCAT(e.first_name, ' ', e.last_name) AS registrant_employee,
    ls.status_name AS loan_status,
    l.request_date,
    l.expected_return_date,
    l.actual_return_date,
    l.reservation_id IS NOT NULL AS from_reservation
FROM loan l
         JOIN student s ON l.student_id = s.student_id
         JOIN computer c ON l.computer_id = c.computer_id
         JOIN employee e ON l.employee_registrant_id = e.employee_id
         JOIN loan_status_type ls ON l.status_id = ls.status_id
WHERE ls.status_name = 'ACTIVE';

COMMENT ON VIEW v_active_loans IS 'Currently active computer loans with related student and equipment information';


-- Today's active reservations
CREATE OR REPLACE VIEW v_reservations_today AS
SELECT
    r.reservation_id,
    rt.resource_name AS resource_type,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    COALESCE(rm.name, c.model) AS resource_name,
    COALESCE(rm.building, 'N/A') AS building,
    COALESCE(rm.floor::TEXT, 'N/A') AS floor,
    c.inventory_code,
    c.brand,
    r.start_time,
    r.end_time,
    rs.status_name AS reservation_status
FROM reservation r
         JOIN student s ON r.student_id = s.student_id
         JOIN resource_type rt ON r.resource_type_id = rt.resource_type_id
         JOIN reservation_status_type rs ON r.status_id = rs.status_id
         LEFT JOIN room rm ON r.room_id = rm.room_id
         LEFT JOIN computer c ON r.computer_id = c.computer_id
WHERE r.reservation_date = CURRENT_DATE
  AND rs.status_name = 'ACTIVE';

COMMENT ON VIEW v_reservations_today IS 'Active reservations scheduled for today';


-- Students with pending fines
CREATE OR REPLACE VIEW v_students_with_fines AS
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email,
    s.pending_fines,
    COUNT(f.fine_id) AS unpaid_fine_count
FROM student s
         LEFT JOIN fine f ON s.student_id = f.student_id
    AND f.status_id = (SELECT status_id FROM fine_status_type WHERE status_name = 'PENDING')
WHERE s.pending_fines > 0
GROUP BY s.student_id, s.first_name, s.last_name, s.institutional_email, s.pending_fines
ORDER BY s.pending_fines DESC;

COMMENT ON VIEW v_students_with_fines IS 'Students with pending fines, ranked by amount owed';


-- Overdue loans report
CREATE OR REPLACE VIEW v_overdue_loans AS
SELECT
    l.loan_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.institutional_email,
    c.inventory_code,
    c.brand,
    c.model,
    l.expected_return_date,
    CURRENT_TIMESTAMP - l.expected_return_date AS days_overdue,
    ls.status_name AS loan_status
FROM loan l
         JOIN student s ON l.student_id = s.student_id
         JOIN computer c ON l.computer_id = c.computer_id
         JOIN loan_status_type ls ON l.status_id = ls.status_id
WHERE ls.status_name IN ('ACTIVE', 'OVERDUE')
  AND l.expected_return_date < CURRENT_TIMESTAMP
ORDER BY l.expected_return_date ASC;

COMMENT ON VIEW v_overdue_loans IS 'List of loans past their expected return date';


-- Employee activity summary
CREATE OR REPLACE VIEW v_employee_activity AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    r.role_name,
    COUNT(DISTINCT a.audit_id) AS total_actions,
    MAX(a.date_time) AS last_action,
    es.status_name AS status
FROM employee e
         LEFT JOIN role_type r ON e.role_id = r.role_id
         LEFT JOIN audit a ON e.employee_id = a.employee_id
         LEFT JOIN employee_status_type es ON e.status_id = es.status_id
GROUP BY e.employee_id, e.first_name, e.last_name, r.role_name, es.status_name
ORDER BY MAX(a.date_time) DESC NULLS LAST;

COMMENT ON VIEW v_employee_activity IS 'Employee activity summary with last action timestamp';


-- ADDITIONAL INDEXES FOR PERFORMANCE


-- Composite indexes for common query patterns
CREATE INDEX idx_reservation_search ON reservation(student_id, reservation_date, status_id);
CREATE INDEX idx_loan_search ON loan(student_id, status_id, expected_return_date);
CREATE INDEX idx_fine_student_status ON fine(student_id, status_id);
CREATE INDEX idx_audit_search ON audit(affected_table, action_id, date_time DESC);

-- Partial indexes for high-selectivity queries
CREATE INDEX idx_active_reservations ON reservation(student_id, start_time)
    WHERE status_id IN (1);  -- Only ACTIVE status

CREATE INDEX idx_active_loans_overdue ON loan(student_id, expected_return_date)
    WHERE status_id IN (1, 3);  -- ACTIVE or OVERDUE



