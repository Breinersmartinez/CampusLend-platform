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


