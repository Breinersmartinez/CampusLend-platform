

-- 1. CONFIGURACIÓN INICIAL


SET TIME ZONE 'UTC';


-- 2. EXTENSIONES

CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- UUID alternative



--------------------------
-- 3. TABLAS DE REFERENCIA (Catálogos)
--------------------------

-- 3.1 Roles de empleados
CREATE TABLE role_type (
                           role_id       SERIAL        PRIMARY KEY,
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
                                      status_id     SERIAL        PRIMARY KEY,
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
                                      status_id     SERIAL        PRIMARY KEY,
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


-- 3.4 Estados de profesores
CREATE TABLE professor_status_type (
                                       status_id     SERIAL        PRIMARY KEY,
                                       status_name   VARCHAR(50)   NOT NULL UNIQUE,
                                       description   TEXT,
                                       created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO professor_status_type (status_name, description) VALUES
                                                                 ('ACTIVE',     'Currently active professor with system access'),
                                                                 ('INACTIVE',   'Inactive professor, no system access'),
                                                                 ('SABBATICAL', 'Professor on sabbatical leave'),
                                                                 ('RETIRED',    'Retired professor, archived records');

COMMENT ON TABLE professor_status_type IS 'Reference table for professor status';


-- 3.5 Tipos de contrato docente
CREATE TABLE contract_type (
                               contract_type_id   SERIAL        PRIMARY KEY,
                               contract_name      VARCHAR(50)   NOT NULL UNIQUE,
                               description        TEXT,
                               created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO contract_type (contract_name, description) VALUES
                                                           ('FULL_TIME',   'Full-time professor with exclusive dedication'),
                                                           ('PART_TIME',   'Part-time professor with partial dedication'),
                                                           ('ADJUNCT',     'Adjunct professor hired per academic term');

COMMENT ON TABLE contract_type IS 'Reference table for professor contract types';


-- 3.6 Estados de salas
CREATE TABLE room_status_type (
                                  status_id     SERIAL        PRIMARY KEY,
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


-- 3.7 Tipos de equipamiento en salas
CREATE TABLE equipment_type (
                                equipment_type_id   SERIAL        PRIMARY KEY,
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


-- 3.8 Estados de computadoras
CREATE TABLE computer_status_type (
                                      status_id     SERIAL        PRIMARY KEY,
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


-- 3.9 Tipos de recurso para reservas
CREATE TABLE resource_type (
                               resource_type_id   SERIAL        PRIMARY KEY,
                               resource_name      VARCHAR(50)   NOT NULL UNIQUE,
                               description        TEXT,
                               created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO resource_type (resource_name, description) VALUES
                                                           ('ROOM',     'Physical room reservation'),
                                                           ('COMPUTER', 'Computer equipment reservation');

COMMENT ON TABLE resource_type IS 'Reference table for reservation resource types';


-- 3.10 Tipos de solicitante
CREATE TABLE requester_type (
                                requester_type_id   SERIAL        PRIMARY KEY,
                                requester_name      VARCHAR(50)   NOT NULL UNIQUE,
                                description         TEXT,
                                created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

INSERT INTO requester_type (requester_name, description) VALUES
                                                             ('STUDENT',    'Reservation or loan made by a student'),
                                                             ('PROFESSOR',  'Reservation or loan made by a professor');

COMMENT ON TABLE requester_type IS 'Reference table: who made the reservation or loan (STUDENT or PROFESSOR)';


-- 3.11 Estados de reservas
CREATE TABLE reservation_status_type (
                                         status_id     SERIAL        PRIMARY KEY,
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


-- 3.12 Estados de préstamos
CREATE TABLE loan_status_type (
                                  status_id     SERIAL        PRIMARY KEY,
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


-- 3.13 Estados de multas
CREATE TABLE fine_status_type (
                                  status_id     SERIAL        PRIMARY KEY,
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


-- 3.14 Tipos de acción para auditoría
CREATE TABLE audit_action_type (
                                   action_id     SERIAL        PRIMARY KEY,
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

--------------------------
-- 4. TABLAS PRINCIPALES
--------------------------

-- 4.1 EMPLEADO
CREATE TABLE employee (
                          employee_id             UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                          card_id                 VARCHAR(20)   NOT NULL UNIQUE,
                          first_name              VARCHAR(150)  NOT NULL,
                          last_name               VARCHAR(150)  NOT NULL,
                          institutional_email     VARCHAR(100)  NOT NULL UNIQUE,
                          password_hash           VARCHAR(255)  NOT NULL,
                          role_id                 INTEGER       NOT NULL,
                          department              VARCHAR(100)  NOT NULL,
                          phone                   VARCHAR(20),
                          status_id               INTEGER       NOT NULL,
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
                         academic_status_id      INTEGER       NOT NULL,
                         pending_fines           NUMERIC(10,2) NOT NULL DEFAULT 0.00,
                         created_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                         updated_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);




COMMENT ON TABLE  student               IS 'Registered students who can reserve rooms or request equipment loans';
COMMENT ON COLUMN student.pending_fines IS 'Total accumulated unpaid fines (recalculated by trigger)';


-- 4.3 PROFESOR
CREATE TABLE professor (
                           professor_id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                           id_card                 VARCHAR(20)   NOT NULL UNIQUE,
                           first_name              VARCHAR(150)  NOT NULL,
                           last_name               VARCHAR(150)  NOT NULL,
                           institutional_email     VARCHAR(100)  NOT NULL UNIQUE,
                           password_hash           VARCHAR(255)  NOT NULL,
                           faculty                 VARCHAR(150)  NOT NULL,
                           academic_department     VARCHAR(150)  NOT NULL,
                           contract_type_id        INTEGER       NOT NULL,
                           status_id               INTEGER       NOT NULL,
                           phone                   VARCHAR(20),
                           pending_fines           NUMERIC(10,2) NOT NULL DEFAULT 0.00,
                           hire_date               DATE          NOT NULL DEFAULT CURRENT_DATE,
                           created_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                           updated_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);


COMMENT ON TABLE  professor                  IS 'Teaching staff who can reserve rooms and request computer loans';
COMMENT ON COLUMN professor.faculty          IS 'Faculty the professor belongs to';
COMMENT ON COLUMN professor.contract_type_id IS 'FULL_TIME, PART_TIME or ADJUNCT';
COMMENT ON COLUMN professor.pending_fines    IS 'Total unpaid fines — conditionally applied by DTI (recalculated by trigger)';


-- 4.4 SALA


CREATE TABLE room (
                      room_id         UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                      name            VARCHAR(100)  NOT NULL,
                      building        VARCHAR(50)   NOT NULL,
                      floor           SMALLINT      NOT NULL,
                      room_number     VARCHAR(20)   NOT NULL,
                      max_capacity    SMALLINT      NOT NULL,
                      opening_time    TIME          NOT NULL,
                      closing_time    TIME          NOT NULL,
                      status_id       INTEGER       NOT NULL,
                      created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                      updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

                      UNIQUE (building, floor, room_number)
);



COMMENT ON TABLE room IS 'Study and work rooms available for reservation by students and professors';


-- 4.5 EQUIPAMIENTO DE SALA
CREATE TABLE room_equipment (
                                room_equipment_id   UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
                                room_id             UUID        NOT NULL,
                                equipment_type_id   INTEGER     NOT NULL,
                                quantity            SMALLINT    NOT NULL DEFAULT 1,
                                notes               TEXT,
                                created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                UNIQUE (room_id, equipment_type_id)
);


COMMENT ON TABLE room_equipment IS 'Equipment inventory available in each room';


-- 4.6 COMPUTADORA
CREATE TABLE computer (
                          computer_id       UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                          inventory_code    VARCHAR(50)   NOT NULL UNIQUE,
                          model             VARCHAR(100)  NOT NULL,
                          brand             VARCHAR(100)  NOT NULL,
                          processor         VARCHAR(100)  NOT NULL,
                          ram_gb            SMALLINT      NOT NULL,
                          storage_gb        INTEGER       NOT NULL,
                          qr_code           VARCHAR(255)  UNIQUE,
                          status_id         INTEGER       NOT NULL,
                          acquisition_date  DATE          NOT NULL,
                          notes             TEXT,
                          created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                          updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);



COMMENT ON TABLE  computer                IS 'Laptops available for direct loan or prior reservation';
COMMENT ON COLUMN computer.inventory_code IS 'Unique physical inventory label code';
COMMENT ON COLUMN computer.qr_code        IS 'QR or barcode generated for quick identification';


-- 4.7 RESERVA
-- Soporta: estudiante O profesor | sala O computadora
-- Dos restricciones XOR independientes garantizadas por CHECK
CREATE TABLE reservation (
                             reservation_id       UUID        PRIMARY KEY DEFAULT gen_random_uuid(),

    -- ── Quién reserva (XOR: estudiante o profesor) ───────
                             requester_type_id    INTEGER     NOT NULL,
                             student_id           UUID,
                             professor_id         UUID,

    -- ── Qué recurso (XOR: sala o computadora) ────────────
                             resource_type_id     INTEGER     NOT NULL,
                             room_id              UUID,
                             computer_id          UUID,

                             reservation_date     DATE        NOT NULL,
                             start_time           TIME        NOT NULL,
                             end_time             TIME        NOT NULL,
                             status_id            INTEGER     NOT NULL,
                             cancellation_reason  TEXT,
                             created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                             updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  reservation                   IS 'Reservations of rooms or computers by students or professors';
COMMENT ON COLUMN reservation.requester_type_id IS 'STUDENT or PROFESSOR — determines which FK (student_id/professor_id) is active';
COMMENT ON COLUMN reservation.resource_type_id  IS 'ROOM or COMPUTER — determines which FK (room_id/computer_id) is active';


-- 4.8 PRÉSTAMO
-- Soporta: estudiante O profesor como solicitante
-- id_reservation es NULL si es préstamo directo sin reserva previa
CREATE TABLE loan (
                      loan_id                 UUID        PRIMARY KEY DEFAULT gen_random_uuid(),

    -- ── Quién recibe el préstamo (XOR) ───────────────────
                      requester_type_id       INTEGER     NOT NULL,
                      student_id              UUID,
                      professor_id            UUID,

                      computer_id             UUID        NOT NULL,
                      employee_registrant_id  UUID        NOT NULL,
                      reservation_id          UUID        UNIQUE,   -- NULL = préstamo directo

                      request_date            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                      expected_return_date    TIMESTAMPTZ NOT NULL,
                      actual_return_date      TIMESTAMPTZ,
                      status_id               INTEGER     NOT NULL,
                      notes                   TEXT,
                      created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                      updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);



COMMENT ON TABLE  loan                        IS 'Computer loans to students or professors. reservation_id NULL = direct loan';
COMMENT ON COLUMN loan.requester_type_id      IS 'STUDENT or PROFESSOR — determines which FK (student_id/professor_id) is active';
COMMENT ON COLUMN loan.employee_registrant_id IS 'IT employee who physically delivered the equipment';
COMMENT ON COLUMN loan.reservation_id         IS 'Optional: linked reservation. NULL means direct loan without prior reservation';


-- 4.9 MULTA
-- Aplica a estudiantes siempre; a profesores de forma condicional (DTI decide)
CREATE TABLE fine (
                      fine_id             UUID          PRIMARY KEY DEFAULT gen_random_uuid(),

    -- ── A quién se aplica (XOR) ───────────────────────────
                      requester_type_id   INTEGER       NOT NULL,
                      student_id          UUID,
                      professor_id        UUID,

                      loan_id             UUID,         -- NULL si la multa no viene de un préstamo
                      applied_by          UUID,         -- Empleado DTI que aplicó la multa al profesor

                      amount              NUMERIC(10,2) NOT NULL,
                      reason              TEXT          NOT NULL,
                      status_id           INTEGER       NOT NULL,
                      generation_date     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                      payment_date        TIMESTAMPTZ,
                      created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
                      updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);


COMMENT ON TABLE  fine             IS 'Fines applied to students (always) or professors (conditionally by DTI)';
COMMENT ON COLUMN fine.applied_by  IS 'Employee who decided to apply the fine — especially relevant for professors';
COMMENT ON COLUMN fine.loan_id     IS 'Optional: linked loan. NULL means fine was issued without a loan origin';


-- 4.10 AUDITORÍA
CREATE TABLE audit (
                       audit_id        UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
                       affected_table  VARCHAR(100)  NOT NULL,
                       record_id       VARCHAR(100),
                       action_id       INTEGER       NOT NULL,
                       employee_id     UUID,
                       student_id      UUID,
                       professor_id    UUID,         -- Nuevo: rastrear acciones de profesores
                       user_role       VARCHAR(50),
                       previous_data   JSONB,
                       new_data        JSONB,
                       source_ip       INET,
                       date_time       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);


COMMENT ON TABLE  audit              IS 'Immutable log of all critical system operations. Never updated or deleted';
COMMENT ON COLUMN audit.professor_id IS 'Populated when the audited action was performed by a professor';

-- --------------------------
-- 5. Llaves foraneas (fk)
-- --------------------------

ALTER TABLE employee
    ADD CONSTRAINT check_employee_email
        CHECK (institutional_email LIKE '%@ucc.edu.co'),
    ADD CONSTRAINT fk_employee_role
        FOREIGN KEY (role_id) REFERENCES role_type(role_id),
    ADD CONSTRAINT fk_employee_status
        FOREIGN KEY (status_id) REFERENCES employee_status_type(status_id);

ALTER TABLE student
    ADD CONSTRAINT check_student_email
        CHECK (institutional_email LIKE '%@campusucc.edu.co'),
    ADD CONSTRAINT check_semester
        CHECK (semester BETWEEN 1 AND 12),
    ADD CONSTRAINT check_pending_fines
        CHECK (pending_fines >= 0),
    ADD CONSTRAINT fk_student_academic_status
        FOREIGN KEY (academic_status_id) REFERENCES academic_status_type(status_id);


ALTER TABLE professor
    ADD CONSTRAINT check_professor_email
        CHECK (institutional_email LIKE '%@ucc.edu.co'),
    ADD CONSTRAINT check_professor_pending_fines
        CHECK (pending_fines >= 0),
    ADD CONSTRAINT fk_professor_contract_type
        FOREIGN KEY (contract_type_id) REFERENCES contract_type(contract_type_id),
    ADD CONSTRAINT fk_professor_status
        FOREIGN KEY (status_id) REFERENCES professor_status_type(status_id);

ALTER TABLE room
    ADD CONSTRAINT check_floor
        CHECK (floor >= 0),
    ADD CONSTRAINT check_max_capacity
        CHECK (max_capacity > 0),
    ADD CONSTRAINT check_closing_time
        CHECK (closing_time > opening_time),
    ADD CONSTRAINT fk_room_status
        FOREIGN KEY (status_id) REFERENCES room_status_type(status_id);

ALTER TABLE room_equipment
    ADD CONSTRAINT check_quantity
        CHECK (quantity > 0),
    ADD CONSTRAINT fk_room_equipment_room
        FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_room_equipment_type
        FOREIGN KEY (equipment_type_id) REFERENCES equipment_type(equipment_type_id);


ALTER TABLE computer
    ADD CONSTRAINT check_ram
        CHECK (ram_gb > 0),
    ADD CONSTRAINT check_storage
        CHECK (storage_gb > 0),
    ADD CONSTRAINT fk_computer_status
        FOREIGN KEY (status_id) REFERENCES computer_status_type(status_id);



 -- Validaciones de tiempo
ALTER TABLE reservation
    ADD CONSTRAINT check_reservation_end_time
        CHECK (end_time > start_time);

-- XOR solicitante: solo student_id O professor_id
ALTER TABLE reservation
    ADD CONSTRAINT chk_requester_xor CHECK (
        (requester_type_id = (SELECT requester_type_id FROM requester_type WHERE requester_name = 'STUDENT')
            AND student_id IS NOT NULL AND professor_id IS NULL)
            OR
        (requester_type_id = (SELECT requester_type_id FROM requester_type WHERE requester_name = 'PROFESSOR')
            AND professor_id IS NOT NULL AND student_id IS NULL)
        );

-- XOR recurso: solo room_id O computer_id
ALTER TABLE reservation
    ADD CONSTRAINT chk_resource_xor CHECK (
        (resource_type_id = (SELECT resource_type_id FROM resource_type WHERE resource_name = 'ROOM')
            AND room_id IS NOT NULL AND computer_id IS NULL)
            OR
        (resource_type_id = (SELECT resource_type_id FROM resource_type WHERE resource_name = 'COMPUTER')
            AND computer_id IS NOT NULL AND room_id IS NULL)
        );

-- Claves foráneas
ALTER TABLE reservation
    ADD CONSTRAINT fk_reservation_requester_type
        FOREIGN KEY (requester_type_id) REFERENCES requester_type(requester_type_id),
    ADD CONSTRAINT fk_reservation_student
        FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_reservation_professor
        FOREIGN KEY (professor_id) REFERENCES professor(professor_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_reservation_resource_type
        FOREIGN KEY (resource_type_id) REFERENCES resource_type(resource_type_id),
    ADD CONSTRAINT fk_reservation_room
        FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_reservation_computer
        FOREIGN KEY (computer_id) REFERENCES computer(computer_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_reservation_status
        FOREIGN KEY (status_id) REFERENCES reservation_status_type(status_id);


  -- Validaciones de fechas
ALTER TABLE loan
    ADD CONSTRAINT check_expected_return
        CHECK (expected_return_date > request_date),
    ADD CONSTRAINT check_actual_return
        CHECK (actual_return_date IS NULL OR actual_return_date >= request_date);

-- XOR solicitante: solo student_id O professor_id
ALTER TABLE loan
    ADD CONSTRAINT chk_loan_requester_xor CHECK (
        (requester_type_id = (SELECT requester_type_id FROM requester_type WHERE requester_name = 'STUDENT')
            AND student_id IS NOT NULL AND professor_id IS NULL)
            OR
        (requester_type_id = (SELECT requester_type_id FROM requester_type WHERE requester_name = 'PROFESSOR')
            AND professor_id IS NOT NULL AND student_id IS NULL)
        );

-- Claves foráneas
ALTER TABLE loan
    ADD CONSTRAINT fk_loan_requester_type
        FOREIGN KEY (requester_type_id) REFERENCES requester_type(requester_type_id),
    ADD CONSTRAINT fk_loan_student
        FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_loan_professor
        FOREIGN KEY (professor_id) REFERENCES professor(professor_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_loan_computer
        FOREIGN KEY (computer_id) REFERENCES computer(computer_id) ON DELETE RESTRICT,
    ADD CONSTRAINT fk_loan_employee
        FOREIGN KEY (employee_registrant_id) REFERENCES employee(employee_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_loan_reservation
        FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_loan_status
        FOREIGN KEY (status_id) REFERENCES loan_status_type(status_id);


-- Validaciones
ALTER TABLE fine
    ADD CONSTRAINT check_fine_amount
        CHECK (amount > 0),
    ADD CONSTRAINT check_fine_payment_date
        CHECK (payment_date IS NULL OR payment_date >= generation_date);

-- XOR solicitante
ALTER TABLE fine
    ADD CONSTRAINT chk_fine_requester_xor CHECK (
        (requester_type_id = (SELECT requester_type_id FROM requester_type WHERE requester_name = 'STUDENT')
            AND student_id IS NOT NULL AND professor_id IS NULL)
            OR
        (requester_type_id = (SELECT requester_type_id FROM requester_type WHERE requester_name = 'PROFESSOR')
            AND professor_id IS NOT NULL AND student_id IS NULL)
        );

-- Claves foráneas
ALTER TABLE fine
    ADD CONSTRAINT fk_fine_requester_type
        FOREIGN KEY (requester_type_id) REFERENCES requester_type(requester_type_id),
    ADD CONSTRAINT fk_fine_student
        FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_fine_professor
        FOREIGN KEY (professor_id) REFERENCES professor(professor_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_fine_loan
        FOREIGN KEY (loan_id) REFERENCES loan(loan_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_fine_applied_by
        FOREIGN KEY (applied_by) REFERENCES employee(employee_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_fine_status
        FOREIGN KEY (status_id) REFERENCES fine_status_type(status_id);



ALTER TABLE audit
    ADD CONSTRAINT fk_audit_action
        FOREIGN KEY (action_id) REFERENCES audit_action_type(action_id),
    ADD CONSTRAINT fk_audit_employee
        FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_audit_student
        FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_audit_professor
        FOREIGN KEY (professor_id) REFERENCES professor(professor_id) ON DELETE SET NULL;




-- --------------------------
-- 5. indices (indexs)
-- --------------------------

CREATE INDEX idx_employee_email    ON employee(institutional_email);
CREATE INDEX idx_employee_card_id  ON employee(card_id);
CREATE INDEX idx_employee_status   ON employee(status_id);
CREATE INDEX idx_employee_role     ON employee(role_id);

CREATE INDEX idx_student_email          ON student(institutional_email);
CREATE INDEX idx_student_id_card        ON student(id_card);
CREATE INDEX idx_student_status         ON student(academic_status_id);
CREATE INDEX idx_student_pending_fines  ON student(pending_fines) WHERE pending_fines > 0;

CREATE INDEX idx_professor_email        ON professor(institutional_email);
CREATE INDEX idx_professor_id_card      ON professor(id_card);
CREATE INDEX idx_professor_status       ON professor(status_id);
CREATE INDEX idx_professor_faculty      ON professor(faculty);
CREATE INDEX idx_professor_pending_fines ON professor(pending_fines) WHERE pending_fines > 0;

CREATE INDEX idx_room_building  ON room(building);
CREATE INDEX idx_room_status    ON room(status_id);
CREATE INDEX idx_room_location  ON room(building, floor);

CREATE INDEX idx_room_equipment_room ON room_equipment(room_id);
CREATE INDEX idx_room_equipment_type ON room_equipment(equipment_type_id);

CREATE INDEX idx_computer_inventory ON computer(inventory_code);
CREATE INDEX idx_computer_status    ON computer(status_id);
CREATE INDEX idx_computer_qr        ON computer(qr_code) WHERE qr_code IS NOT NULL;


-- Índices
CREATE INDEX idx_reservation_student      ON reservation(student_id)    WHERE student_id IS NOT NULL;
CREATE INDEX idx_reservation_professor    ON reservation(professor_id)  WHERE professor_id IS NOT NULL;
CREATE INDEX idx_reservation_date         ON reservation(reservation_date);
CREATE INDEX idx_reservation_status       ON reservation(status_id);
CREATE INDEX idx_reservation_resource     ON reservation(resource_type_id);
CREATE INDEX idx_reservation_room         ON reservation(room_id)       WHERE room_id IS NOT NULL;
CREATE INDEX idx_reservation_computer     ON reservation(computer_id)   WHERE computer_id IS NOT NULL;
CREATE INDEX idx_reservation_search       ON reservation(student_id, reservation_date, status_id);

-- Índice parcial para evitar solapamiento de salas en el mismo horario
CREATE UNIQUE INDEX idx_no_overlap_room ON reservation(room_id, reservation_date, start_time, end_time)
    WHERE status_id = (SELECT status_id FROM reservation_status_type WHERE status_name = 'ACTIVE')
      AND room_id IS NOT NULL;

-- Índice parcial para evitar solapamiento de computadoras en el mismo horario
CREATE UNIQUE INDEX idx_no_overlap_computer ON reservation(computer_id, reservation_date, start_time, end_time)
    WHERE status_id = (SELECT status_id FROM reservation_status_type WHERE status_name = 'ACTIVE')
      AND computer_id IS NOT NULL;
-- Índices
CREATE INDEX idx_loan_student       ON loan(student_id)   WHERE student_id IS NOT NULL;
CREATE INDEX idx_loan_professor     ON loan(professor_id) WHERE professor_id IS NOT NULL;
CREATE INDEX idx_loan_computer      ON loan(computer_id);
CREATE INDEX idx_loan_status        ON loan(status_id);
CREATE INDEX idx_loan_request_date  ON loan(request_date);
CREATE INDEX idx_loan_return_date   ON loan(expected_return_date)
    WHERE status_id IN (SELECT status_id FROM loan_status_type WHERE status_name IN ('ACTIVE','OVERDUE'));
CREATE INDEX idx_loan_search        ON loan(student_id, status_id, expected_return_date);

-- Índices
CREATE INDEX idx_fine_student         ON fine(student_id)   WHERE student_id IS NOT NULL;
CREATE INDEX idx_fine_professor       ON fine(professor_id) WHERE professor_id IS NOT NULL;
CREATE INDEX idx_fine_status          ON fine(status_id);
CREATE INDEX idx_fine_generation_date ON fine(generation_date);
CREATE INDEX idx_fine_payment_date    ON fine(payment_date) WHERE payment_date IS NOT NULL;
CREATE INDEX idx_fine_student_status  ON fine(student_id, status_id);

CREATE INDEX idx_audit_table     ON audit(affected_table);
CREATE INDEX idx_audit_date      ON audit(date_time DESC);
CREATE INDEX idx_audit_employee  ON audit(employee_id)  WHERE employee_id IS NOT NULL;
CREATE INDEX idx_audit_student   ON audit(student_id)   WHERE student_id IS NOT NULL;
CREATE INDEX idx_audit_professor ON audit(professor_id) WHERE professor_id IS NOT NULL;
CREATE INDEX idx_audit_action    ON audit(action_id);
CREATE INDEX idx_audit_search    ON audit(affected_table, action_id, date_time DESC);




-- --------------------------
-- 6. VISTAS (VIEWS)
-- --------------------------

-- 6.1 Computadoras disponibles
CREATE OR REPLACE VIEW v_computers_available AS
SELECT c.computer_id, c.inventory_code, c.brand, c.model,
       c.processor, c.ram_gb, c.storage_gb, cs.status_name AS status
FROM computer c
         JOIN computer_status_type cs ON c.status_id = cs.status_id
WHERE cs.status_name = 'AVAILABLE';

COMMENT ON VIEW v_computers_available IS 'Computers currently available for loan or reservation';


-- 6.2 Salas disponibles con equipamiento
CREATE OR REPLACE VIEW v_rooms_available AS
SELECT r.room_id, r.name, r.building, r.floor, r.room_number,
       r.max_capacity, r.opening_time, r.closing_time,
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
         r.max_capacity, r.opening_time, r.closing_time, rs.status_name;

COMMENT ON VIEW v_rooms_available IS 'Available rooms with equipment inventory as JSON';


-- 6.3 Préstamos activos (estudiantes y profesores)
CREATE OR REPLACE VIEW v_active_loans AS
SELECT
    l.loan_id,
    rt.requester_name                                                   AS requester_type,
    COALESCE(
            CONCAT(s.first_name,  ' ', s.last_name),
            CONCAT(p.first_name,  ' ', p.last_name)
    )                                                                   AS requester_name,
    COALESCE(s.institutional_email, p.institutional_email)             AS requester_email,
    c.inventory_code, c.brand, c.model,
    CONCAT(e.first_name, ' ', e.last_name)                             AS registrant_employee,
    ls.status_name                                                      AS loan_status,
    l.request_date,
    l.expected_return_date,
    l.actual_return_date,
    l.reservation_id IS NOT NULL                                       AS from_reservation
FROM loan l
         JOIN requester_type rt             ON l.requester_type_id = rt.requester_type_id
         LEFT JOIN student s                ON l.student_id = s.student_id
         LEFT JOIN professor p              ON l.professor_id = p.professor_id
         JOIN computer c                    ON l.computer_id = c.computer_id
         JOIN employee e                    ON l.employee_registrant_id = e.employee_id
         JOIN loan_status_type ls           ON l.status_id = ls.status_id
WHERE ls.status_name = 'ACTIVE';

COMMENT ON VIEW v_active_loans IS 'Active loans for both students and professors';


-- 6.4 Reservas de hoy (estudiantes y profesores)
CREATE OR REPLACE VIEW v_reservations_today AS
SELECT
    r.reservation_id,
    rt_res.resource_name                                                AS resource_type,
    rt_req.requester_name                                               AS requester_type,
    COALESCE(
            CONCAT(s.first_name,  ' ', s.last_name),
            CONCAT(p.first_name,  ' ', p.last_name)
    )                                                                   AS requester_name,
    COALESCE(rm.name, c.model)                                         AS resource_name,
    COALESCE(rm.building, 'N/A')                                       AS building,
    COALESCE(rm.floor::TEXT, 'N/A')                                    AS floor,
    c.inventory_code,
    r.start_time,
    r.end_time,
    rs.status_name                                                      AS reservation_status
FROM reservation r
         JOIN requester_type rt_req         ON r.requester_type_id = rt_req.requester_type_id
         JOIN resource_type rt_res          ON r.resource_type_id = rt_res.resource_type_id
         JOIN reservation_status_type rs    ON r.status_id = rs.status_id
         LEFT JOIN student s                ON r.student_id = s.student_id
         LEFT JOIN professor p              ON r.professor_id = p.professor_id
         LEFT JOIN room rm                  ON r.room_id = rm.room_id
         LEFT JOIN computer c               ON r.computer_id = c.computer_id
WHERE r.reservation_date = CURRENT_DATE
  AND rs.status_name = 'ACTIVE';

COMMENT ON VIEW v_reservations_today IS 'Active reservations for today, students and professors';


-- 6.5 Estudiantes con multas pendientes
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

COMMENT ON VIEW v_students_with_fines IS 'Students with pending fines, ordered by amount';


-- 6.6 Profesores con multas pendientes
CREATE OR REPLACE VIEW v_professors_with_fines AS
SELECT
    p.professor_id,
    CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
    p.institutional_email,
    p.faculty,
    p.pending_fines,
    COUNT(f.fine_id) AS unpaid_fine_count
FROM professor p
         LEFT JOIN fine f ON p.professor_id = f.professor_id
    AND f.status_id = (SELECT status_id FROM fine_status_type WHERE status_name = 'PENDING')
WHERE p.pending_fines > 0
GROUP BY p.professor_id, p.first_name, p.last_name, p.institutional_email,
         p.faculty, p.pending_fines
ORDER BY p.pending_fines DESC;

COMMENT ON VIEW v_professors_with_fines IS 'Professors with pending fines (conditionally applied by DTI)';


-- 6.7 Préstamos vencidos (estudiantes y profesores)
CREATE OR REPLACE VIEW v_overdue_loans AS
SELECT
    l.loan_id,
    rt.requester_name                                                   AS requester_type,
    COALESCE(
            CONCAT(s.first_name,  ' ', s.last_name),
            CONCAT(p.first_name,  ' ', p.last_name)
    )                                                                   AS requester_name,
    COALESCE(s.institutional_email, p.institutional_email)             AS requester_email,
    c.inventory_code, c.brand, c.model,
    l.expected_return_date,
    CURRENT_TIMESTAMP - l.expected_return_date                         AS time_overdue,
    ls.status_name                                                      AS loan_status
FROM loan l
         JOIN requester_type rt             ON l.requester_type_id = rt.requester_type_id
         LEFT JOIN student s                ON l.student_id = s.student_id
         LEFT JOIN professor p              ON l.professor_id = p.professor_id
         JOIN computer c                    ON l.computer_id = c.computer_id
         JOIN loan_status_type ls           ON l.status_id = ls.status_id
WHERE ls.status_name IN ('ACTIVE', 'OVERDUE')
  AND l.expected_return_date < CURRENT_TIMESTAMP
ORDER BY l.expected_return_date ASC;

COMMENT ON VIEW v_overdue_loans IS 'Overdue loans for both students and professors';


-- 6.8 Resumen de actividad de empleados
CREATE OR REPLACE VIEW v_employee_activity AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    r.role_name,
    COUNT(DISTINCT a.audit_id)             AS total_actions,
    MAX(a.date_time)                       AS last_action,
    es.status_name                         AS status
FROM employee e
         LEFT JOIN role_type r              ON e.role_id = r.role_id
         LEFT JOIN audit a                  ON e.employee_id = a.employee_id
         LEFT JOIN employee_status_type es  ON e.status_id = es.status_id
GROUP BY e.employee_id, e.first_name, e.last_name, r.role_name, es.status_name
ORDER BY MAX(a.date_time) DESC NULLS LAST;

COMMENT ON VIEW v_employee_activity IS 'Employee activity summary with last action timestamp';


