

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


-- 5.