
-- 1. TRIGGERS DE AUDITORÍA


-- 1.1 Trigger para auditar cambios en la tabla EMPLOYEE
CREATE OR REPLACE FUNCTION audit_employee_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit (affected_table, record_id, action_id, employee_id, user_role, new_data, date_time)
SELECT 'employee', NEW.employee_id::text, action_id, NEW.employee_id, 'ADMINISTRATOR',
       row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'CREATE';
RETURN NEW;

ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, employee_id, user_role, previous_data, new_data, date_time)
SELECT 'employee', OLD.employee_id::text, action_id, NEW.employee_id, 'ADMINISTRATOR',
       row_to_json(OLD), row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'UPDATE';
RETURN NEW;

ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, employee_id, user_role, previous_data, date_time)
SELECT 'employee', OLD.employee_id::text, action_id, OLD.employee_id, 'ADMINISTRATOR',
       row_to_json(OLD), NOW()
FROM audit_action_type WHERE action_name = 'DELETE';
RETURN OLD;
END IF;

RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_employee
    AFTER INSERT OR UPDATE OR DELETE ON employee
    FOR EACH ROW EXECUTE FUNCTION audit_employee_changes();

COMMENT ON FUNCTION audit_employee_changes() IS 'Audita cambios en la tabla employee (CREATE, UPDATE, DELETE)';



-- 1.2 Trigger para auditar cambios en la tabla STUDENT
CREATE OR REPLACE FUNCTION audit_student_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, new_data, date_time)
SELECT 'student', NEW.student_id::text, action_id, NEW.student_id, 'IT_STAFF',
       row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'CREATE';
RETURN NEW;

ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, previous_data, new_data, date_time)
SELECT 'student', OLD.student_id::text, action_id, NEW.student_id, 'IT_STAFF',
       row_to_json(OLD), row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'UPDATE';
RETURN NEW;

ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, previous_data, date_time)
SELECT 'student', OLD.student_id::text, action_id, OLD.student_id, 'IT_STAFF',
       row_to_json(OLD), NOW()
FROM audit_action_type WHERE action_name = 'DELETE';
RETURN OLD;
END IF;

RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_student
    AFTER INSERT OR UPDATE OR DELETE ON student
    FOR EACH ROW EXECUTE FUNCTION audit_student_changes();

COMMENT ON FUNCTION audit_student_changes() IS 'Audita cambios en la tabla student (CREATE, UPDATE, DELETE)';



-- 1.3 Trigger para auditar cambios en la tabla ROOM
CREATE OR REPLACE FUNCTION audit_room_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit (affected_table, record_id, action_id, user_role, new_data, date_time)
SELECT 'room', NEW.room_id::text, action_id, 'ADMINISTRATOR',
       row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'CREATE';
RETURN NEW;

ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, user_role, previous_data, new_data, date_time)
SELECT 'room', OLD.room_id::text, action_id, 'ADMINISTRATOR',
       row_to_json(OLD), row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'UPDATE';
RETURN NEW;

ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, user_role, previous_data, date_time)
SELECT 'room', OLD.room_id::text, action_id, 'ADMINISTRATOR',
       row_to_json(OLD), NOW()
FROM audit_action_type WHERE action_name = 'DELETE';
RETURN OLD;
END IF;

RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_room
    AFTER INSERT OR UPDATE OR DELETE ON room
    FOR EACH ROW EXECUTE FUNCTION audit_room_changes();

COMMENT ON FUNCTION audit_room_changes() IS 'Audita cambios en la tabla room (CREATE, UPDATE, DELETE)';



-- 1.4 Trigger para auditar cambios en la tabla COMPUTER
CREATE OR REPLACE FUNCTION audit_computer_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit (affected_table, record_id, action_id, user_role, new_data, date_time)
SELECT 'computer', NEW.computer_id::text, action_id, 'ADMINISTRATOR',
       row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'CREATE';
RETURN NEW;

ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, user_role, previous_data, new_data, date_time)
SELECT 'computer', OLD.computer_id::text, action_id, 'ADMINISTRATOR',
       row_to_json(OLD), row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'UPDATE';
RETURN NEW;

ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, user_role, previous_data, date_time)
SELECT 'computer', OLD.computer_id::text, action_id, 'ADMINISTRATOR',
       row_to_json(OLD), NOW()
FROM audit_action_type WHERE action_name = 'DELETE';
RETURN OLD;
END IF;

RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_computer
    AFTER INSERT OR UPDATE OR DELETE ON computer
    FOR EACH ROW EXECUTE FUNCTION audit_computer_changes();

COMMENT ON FUNCTION audit_computer_changes() IS 'Audita cambios en la tabla computer (CREATE, UPDATE, DELETE)';



-- 1.5 Trigger para auditar cambios en la tabla LOAN
CREATE OR REPLACE FUNCTION audit_loan_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, new_data, date_time)
SELECT 'loan', NEW.loan_id::text, action_id, NEW.student_id, 'IT_STAFF',
       row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'CREATE';
RETURN NEW;

ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, previous_data, new_data, date_time)
SELECT 'loan', OLD.loan_id::text, action_id, NEW.student_id, 'IT_STAFF',
       row_to_json(OLD), row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'UPDATE';
RETURN NEW;

ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, previous_data, date_time)
SELECT 'loan', OLD.loan_id::text, action_id, OLD.student_id, 'IT_STAFF',
       row_to_json(OLD), NOW()
FROM audit_action_type WHERE action_name = 'DELETE';
RETURN OLD;
END IF;

RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_loan
    AFTER INSERT OR UPDATE OR DELETE ON loan
    FOR EACH ROW EXECUTE FUNCTION audit_loan_changes();

COMMENT ON FUNCTION audit_loan_changes() IS 'Audita cambios en la tabla loan (CREATE, UPDATE, DELETE)';



-- 1.6 Trigger para auditar cambios en la tabla RESERVATION
CREATE OR REPLACE FUNCTION audit_reservation_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, new_data, date_time)
SELECT 'reservation', NEW.reservation_id::text, action_id, NEW.student_id, 'IT_STAFF',
       row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'CREATE';
RETURN NEW;

ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, previous_data, new_data, date_time)
SELECT 'reservation', OLD.reservation_id::text, action_id, NEW.student_id, 'IT_STAFF',
       row_to_json(OLD), row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'UPDATE';
RETURN NEW;

ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, previous_data, date_time)
SELECT 'reservation', OLD.reservation_id::text, action_id, OLD.student_id, 'IT_STAFF',
       row_to_json(OLD), NOW()
FROM audit_action_type WHERE action_name = 'DELETE';
RETURN OLD;
END IF;

RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_reservation
    AFTER INSERT OR UPDATE OR DELETE ON reservation
    FOR EACH ROW EXECUTE FUNCTION audit_reservation_changes();

COMMENT ON FUNCTION audit_reservation_changes() IS 'Audita cambios en la tabla reservation (CREATE, UPDATE, DELETE)';



-- 1.7 Trigger para auditar cambios en la tabla FINE
CREATE OR REPLACE FUNCTION audit_fine_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, new_data, date_time)
SELECT 'fine', NEW.fine_id::text, action_id, NEW.student_id, 'IT_STAFF',
       row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'CREATE';
RETURN NEW;

ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, previous_data, new_data, date_time)
SELECT 'fine', OLD.fine_id::text, action_id, NEW.student_id, 'IT_STAFF',
       row_to_json(OLD), row_to_json(NEW), NOW()
FROM audit_action_type WHERE action_name = 'UPDATE';
RETURN NEW;

ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit (affected_table, record_id, action_id, student_id, user_role, previous_data, date_time)
SELECT 'fine', OLD.fine_id::text, action_id, OLD.student_id, 'IT_STAFF',
       row_to_json(OLD), NOW()
FROM audit_action_type WHERE action_name = 'DELETE';
RETURN OLD;
END IF;

RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_fine
    AFTER INSERT OR UPDATE OR DELETE ON fine
    FOR EACH ROW EXECUTE FUNCTION audit_fine_changes();

COMMENT ON FUNCTION audit_fine_changes() IS 'Audita cambios en la tabla fine (CREATE, UPDATE, DELETE)';


-- 2. TRIGGERS DE INTEGRIDAD Y CONSISTENCIA


-- 2.1 Trigger para actualizar `updated_at` automáticamente en EMPLOYEE
CREATE OR REPLACE FUNCTION update_employee_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_employee_timestamp
    BEFORE UPDATE ON employee
    FOR EACH ROW EXECUTE FUNCTION update_employee_timestamp();

COMMENT ON FUNCTION update_employee_timestamp() IS 'Actualiza automáticamente el campo updated_at en employee';



-- 2.2 Trigger para actualizar `updated_at` automáticamente en STUDENT
CREATE OR REPLACE FUNCTION update_student_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_student_timestamp
    BEFORE UPDATE ON student
    FOR EACH ROW EXECUTE FUNCTION update_student_timestamp();

COMMENT ON FUNCTION update_student_timestamp() IS 'Actualiza automáticamente el campo updated_at en student';



-- 2.3 Trigger para actualizar `updated_at` automáticamente en ROOM
CREATE OR REPLACE FUNCTION update_room_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_room_timestamp
    BEFORE UPDATE ON room
    FOR EACH ROW EXECUTE FUNCTION update_room_timestamp();

COMMENT ON FUNCTION update_room_timestamp() IS 'Actualiza automáticamente el campo updated_at en room';



-- 2.4 Trigger para actualizar `updated_at` automáticamente en COMPUTER
CREATE OR REPLACE FUNCTION update_computer_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_computer_timestamp
    BEFORE UPDATE ON computer
    FOR EACH ROW EXECUTE FUNCTION update_computer_timestamp();

COMMENT ON FUNCTION update_computer_timestamp() IS 'Actualiza automáticamente el campo updated_at en computer';



-- 2.5 Trigger para actualizar `updated_at` automáticamente en ROOM_EQUIPMENT
CREATE OR REPLACE FUNCTION update_room_equipment_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_room_equipment_timestamp
    BEFORE UPDATE ON room_equipment
    FOR EACH ROW EXECUTE FUNCTION update_room_equipment_timestamp();

COMMENT ON FUNCTION update_room_equipment_timestamp() IS 'Actualiza automáticamente el campo updated_at en room_equipment';



-- 2.6 Trigger para actualizar `updated_at` automáticamente en LOAN
CREATE OR REPLACE FUNCTION update_loan_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_loan_timestamp
    BEFORE UPDATE ON loan
    FOR EACH ROW EXECUTE FUNCTION update_loan_timestamp();

COMMENT ON FUNCTION update_loan_timestamp() IS 'Actualiza automáticamente el campo updated_at en loan';



-- 2.7 Trigger para actualizar `updated_at` automáticamente en RESERVATION
CREATE OR REPLACE FUNCTION update_reservation_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_reservation_timestamp
    BEFORE UPDATE ON reservation
    FOR EACH ROW EXECUTE FUNCTION update_reservation_timestamp();

COMMENT ON FUNCTION update_reservation_timestamp() IS 'Actualiza automáticamente el campo updated_at en reservation';



-- 2.8 Trigger para actualizar `updated_at` automáticamente en FINE
CREATE OR REPLACE FUNCTION update_fine_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_fine_timestamp
    BEFORE UPDATE ON fine
    FOR EACH ROW EXECUTE FUNCTION update_fine_timestamp();

COMMENT ON FUNCTION update_fine_timestamp() IS 'Actualiza automáticamente el campo updated_at en fine';


-- 3. TRIGGERS DE CONSISTENCIA DE ESTADO


-- 3.1 Trigger para validar y sincronizar estado de COMPUTER cuando se crea LOAN
-- Si se crea un préstamo, la computadora debe cambiar a IN_LOAN
CREATE OR REPLACE FUNCTION sync_computer_status_on_loan_creation()
RETURNS TRIGGER AS $$
DECLARE
v_active_status_id UUID;
BEGIN
    -- Obtener el ID del estado 'IN_LOAN'
SELECT status_id INTO v_active_status_id
FROM computer_status_type
WHERE status_name = 'IN_LOAN'
    LIMIT 1;

-- Actualizar el estado de la computadora a IN_LOAN cuando el préstamo está activo
IF NEW.status_id = (SELECT status_id FROM loan_status_type WHERE status_name = 'ACTIVE' LIMIT 1) THEN
UPDATE computer
SET status_id = v_active_status_id
WHERE computer_id = NEW.computer_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_computer_status_on_loan_creation
    AFTER INSERT ON loan
    FOR EACH ROW EXECUTE FUNCTION sync_computer_status_on_loan_creation();

COMMENT ON FUNCTION sync_computer_status_on_loan_creation() IS 'Sincroniza el estado de computadora a IN_LOAN cuando se crea un préstamo activo';



-- 3.2 Trigger para sincronizar estado de COMPUTER cuando se finaliza LOAN
-- Si se finaliza un préstamo, la computadora debe volver a AVAILABLE
CREATE OR REPLACE FUNCTION sync_computer_status_on_loan_return()
RETURNS TRIGGER AS $$
DECLARE
v_available_status_id UUID;
BEGIN
    -- Obtener el ID del estado 'AVAILABLE'
SELECT status_id INTO v_available_status_id
FROM computer_status_type
WHERE status_name = 'AVAILABLE'
    LIMIT 1;

-- Actualizar el estado de la computadora a AVAILABLE cuando el préstamo es devuelto
IF NEW.status_id = (SELECT status_id FROM loan_status_type WHERE status_name = 'RETURNED' LIMIT 1) 
       AND OLD.status_id = (SELECT status_id FROM loan_status_type WHERE status_name = 'ACTIVE' LIMIT 1) THEN
UPDATE computer
SET status_id = v_available_status_id
WHERE computer_id = NEW.computer_id;

-- Registrar hora de devolución si no está registrada
IF NEW.actual_return_date IS NULL THEN
            NEW.actual_return_date = NOW();
END IF;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_computer_status_on_loan_return
    BEFORE UPDATE ON loan
    FOR EACH ROW EXECUTE FUNCTION sync_computer_status_on_loan_return();

COMMENT ON FUNCTION sync_computer_status_on_loan_return() IS 'Sincroniza el estado de computadora a AVAILABLE cuando se devuelve un préstamo';


-- 4. TRIGGERS DE REGLAS DE NEGOCIO


-- 4.1 Trigger para impedir más de un préstamo activo por estudiante
CREATE OR REPLACE FUNCTION validate_single_active_loan_per_student()
RETURNS TRIGGER AS $$
DECLARE
v_active_loan_count INT;
    v_active_status_id UUID;
BEGIN
    -- Obtener el ID del estado 'ACTIVE'
SELECT status_id INTO v_active_status_id
FROM loan_status_type
WHERE status_name = 'ACTIVE'
    LIMIT 1;

-- Contar préstamos activos del estudiante
SELECT COUNT(*) INTO v_active_loan_count
FROM loan
WHERE student_id = NEW.student_id
  AND status_id = v_active_status_id
  AND loan_id != COALESCE(NEW.loan_id, '00000000-0000-0000-0000-000000000000');

-- Si ya tiene un préstamo activo, rechazar el nuevo
IF v_active_loan_count > 0 THEN
        RAISE EXCEPTION 'El estudiante ya tiene un préstamo activo. No se permite más de un préstamo simultáneo.';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_single_active_loan
    BEFORE INSERT OR UPDATE ON loan
                         FOR EACH ROW EXECUTE FUNCTION validate_single_active_loan_per_student();

COMMENT ON FUNCTION validate_single_active_loan_per_student() IS 'Valida que un estudiante no tenga más de un préstamo activo simultáneamente';



-- 4.2 Trigger para validar duración máxima de préstamo (2 horas)
CREATE OR REPLACE FUNCTION validate_loan_duration()
RETURNS TRIGGER AS $$
DECLARE
v_duration_minutes INT;
BEGIN
    -- Calcular la duración del préstamo en minutos
    v_duration_minutes = EXTRACT(EPOCH FROM (NEW.expected_return_date - NEW.request_date)) / 60;
    
    -- Validar que no exceda 2 horas (120 minutos)
    IF v_duration_minutes > 120 THEN
        RAISE EXCEPTION 'La duración del préstamo de computadora no debe exceder 2 horas. Duración solicitada: % minutos', v_duration_minutes;
END IF;
    
    -- Validar que sea positivo
    IF v_duration_minutes <= 0 THEN
        RAISE EXCEPTION 'La fecha de retorno debe ser posterior a la fecha de solicitud.';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_loan_duration
    BEFORE INSERT OR UPDATE ON loan
                         FOR EACH ROW EXECUTE FUNCTION validate_loan_duration();

COMMENT ON FUNCTION validate_loan_duration() IS 'Valida que la duración de un préstamo no exceda 2 horas';



-- 4.3 Trigger para validar horario de préstamo (7 AM - 9 PM)
CREATE OR REPLACE FUNCTION validate_loan_operating_hours()
RETURNS TRIGGER AS $$
DECLARE
v_start_hour INT;
    v_end_hour INT;
BEGIN
    -- Extraer hora de inicio
    v_start_hour = EXTRACT(HOUR FROM NEW.request_date);
    v_end_hour = EXTRACT(HOUR FROM NEW.expected_return_date);
    
    -- Validar que los préstamos se realicen entre 7 AM y 9 PM
    IF v_start_hour < 7 OR v_start_hour >= 21 THEN
        RAISE EXCEPTION 'Los préstamos solo están disponibles entre 7:00 AM y 9:00 PM. Hora de solicitud: %:00', v_start_hour;
END IF;
    
    IF v_end_hour <= 7 OR v_end_hour > 21 THEN
        RAISE EXCEPTION 'Los préstamos deben finalizarse antes de las 9:00 PM. Hora de retorno: %:00', v_end_hour;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_loan_operating_hours
    BEFORE INSERT OR UPDATE ON loan
                         FOR EACH ROW EXECUTE FUNCTION validate_loan_operating_hours();

COMMENT ON FUNCTION validate_loan_operating_hours() IS 'Valida que los préstamos se realicen en horario de operación (7 AM - 9 PM)';



-- 4.4 Trigger para validar duración máxima de reserva de sala (3 horas)
CREATE OR REPLACE FUNCTION validate_reservation_duration()
RETURNS TRIGGER AS $$
DECLARE
v_duration_minutes INT;
BEGIN
    -- Calcular la duración en minutos
    v_duration_minutes = EXTRACT(EPOCH FROM (NEW.end_time - NEW.start_time)) / 60;
    
    -- Validar que no exceda 3 horas (180 minutos)
    IF v_duration_minutes > 180 THEN
        RAISE EXCEPTION 'La duración de la reserva de sala no debe exceder 3 horas. Duración solicitada: % minutos', v_duration_minutes;
END IF;
    
    -- Validar que sea positivo
    IF v_duration_minutes <= 0 THEN
        RAISE EXCEPTION 'La hora de finalización debe ser posterior a la hora de inicio.';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_reservation_duration
    BEFORE INSERT OR UPDATE ON reservation
                         FOR EACH ROW EXECUTE FUNCTION validate_reservation_duration();

COMMENT ON FUNCTION validate_reservation_duration() IS 'Valida que la duración de una reserva de sala no exceda 3 horas';



-- 4.5 Trigger para validar anticipación máxima de reserva de sala (7 días)
CREATE OR REPLACE FUNCTION validate_reservation_advance()
RETURNS TRIGGER AS $$
DECLARE
v_days_advance INT;
BEGIN
    -- Calcular días de anticipación
    v_days_advance = NEW.reservation_date - CURRENT_DATE;
    
    -- Validar que no exceda 7 días de anticipación
    IF v_days_advance > 7 THEN
        RAISE EXCEPTION 'Las reservas de salas solo se pueden realizar hasta con 7 días de anticipación. Días solicitados: %', v_days_advance;
END IF;
    
    -- Validar que no sea en el pasado
    IF NEW.reservation_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'No se puede reservar una sala para una fecha pasada.';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_reservation_advance
    BEFORE INSERT OR UPDATE ON reservation
                         FOR EACH ROW EXECUTE FUNCTION validate_reservation_advance();

COMMENT ON FUNCTION validate_reservation_advance() IS 'Valida que las reservas de sala no excedan 7 días de anticipación';



-- 4.6 Trigger para validar que computadoras reservadas sean del mismo día
CREATE OR REPLACE FUNCTION validate_computer_reservation_same_day()
RETURNS TRIGGER AS $$
BEGIN
    -- Si es una reserva de computadora, debe ser para el mismo día
    IF NEW.resource_type_id = (SELECT resource_type_id FROM resource_type WHERE resource_name = 'COMPUTER' LIMIT 1) THEN
        IF NEW.reservation_date != CURRENT_DATE THEN
            RAISE EXCEPTION 'Las reservas de computadoras solo se pueden hacer para el mismo día de solicitud.';
END IF;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_computer_reservation_same_day
    BEFORE INSERT OR UPDATE ON reservation
                         FOR EACH ROW EXECUTE FUNCTION validate_computer_reservation_same_day();

COMMENT ON FUNCTION validate_computer_reservation_same_day() IS 'Valida que las reservas de computadora sean para el mismo día';



-- 4.7 Trigger para cancelar automáticamente préstamos si no se inician en 10 minutos
CREATE OR REPLACE FUNCTION cancel_expired_loans()
RETURNS TRIGGER AS $$
DECLARE
v_pending_status_id UUID;
    v_cancelled_status_id UUID;
    v_minutes_elapsed INT;
BEGIN
    -- Obtener IDs de estados
SELECT status_id INTO v_pending_status_id
FROM loan_status_type
WHERE status_name = 'ACTIVE'
    LIMIT 1;

SELECT status_id INTO v_cancelled_status_id
FROM loan_status_type
WHERE status_name = 'CANCELLED'
    LIMIT 1;

-- Contar minutos desde que se aprobó el préstamo
v_minutes_elapsed = EXTRACT(EPOCH FROM (NOW() - NEW.request_date)) / 60;
    
    -- Si han pasado más de 10 minutos y no se ha iniciado, cancelar
    IF v_minutes_elapsed > 10 AND NEW.status_id = v_pending_status_id THEN
        NEW.status_id = v_cancelled_status_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_cancel_expired_loans
    BEFORE UPDATE ON loan
    FOR EACH ROW EXECUTE FUNCTION cancel_expired_loans();

COMMENT ON FUNCTION cancel_expired_loans() IS 'Cancela automáticamente préstamos si no se inician en 10 minutos';



-- 4.8 Trigger para cancelar automáticamente reservas de sala si no se inician en 30 minutos
CREATE OR REPLACE FUNCTION cancel_expired_reservations()
RETURNS TRIGGER AS $$
DECLARE
v_active_status_id UUID;
    v_cancelled_status_id UUID;
    v_minutes_elapsed INT;
BEGIN
    -- Obtener IDs de estados
SELECT status_id INTO v_active_status_id
FROM reservation_status_type
WHERE status_name = 'ACTIVE'
    LIMIT 1;

SELECT status_id INTO v_cancelled_status_id
FROM reservation_status_type
WHERE status_name = 'CANCELLED'
    LIMIT 1;

-- Contar minutos desde que se aprobó la reserva
v_minutes_elapsed = EXTRACT(EPOCH FROM (NOW() - NEW.created_at)) / 60;
    
    -- Si han pasado más de 30 minutos y no se ha iniciado, cancelar
    IF v_minutes_elapsed > 30 AND NEW.status_id = v_active_status_id THEN
        NEW.status_id = v_cancelled_status_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_cancel_expired_reservations
    BEFORE UPDATE ON reservation
    FOR EACH ROW EXECUTE FUNCTION cancel_expired_reservations();

COMMENT ON FUNCTION cancel_expired_reservations() IS 'Cancela automáticamente reservas de sala si no se inician en 30 minutos';



-- 4.9 Trigger para detectar préstamos vencidos (OVERDUE)
CREATE OR REPLACE FUNCTION detect_overdue_loans()
RETURNS TRIGGER AS $$
DECLARE
v_active_status_id UUID;
    v_overdue_status_id UUID;
BEGIN
    -- Obtener IDs de estados
SELECT status_id INTO v_active_status_id
FROM loan_status_type
WHERE status_name = 'ACTIVE'
    LIMIT 1;

SELECT status_id INTO v_overdue_status_id
FROM loan_status_type
WHERE status_name = 'OVERDUE'
    LIMIT 1;

-- Si la fecha de retorno ha pasado y el préstamo sigue activo, marcar como OVERDUE
IF NEW.status_id = v_active_status_id 
       AND NEW.expected_return_date < NOW() 
       AND NEW.actual_return_date IS NULL THEN
        NEW.status_id = v_overdue_status_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_detect_overdue_loans
    BEFORE UPDATE ON loan
    FOR EACH ROW EXECUTE FUNCTION detect_overdue_loans();

COMMENT ON FUNCTION detect_overdue_loans() IS 'Detecta préstamos vencidos y cambia su estado a OVERDUE';


-- 5. TRIGGERS PARA GESTIÓN DE MULTAS


-- 5.1 Trigger para crear multa automáticamente cuando un préstamo vence
CREATE OR REPLACE FUNCTION create_fine_on_overdue_loan()
RETURNS TRIGGER AS $$
DECLARE
v_active_status_id UUID;
    v_overdue_status_id UUID;
    v_pending_status_id UUID;
    v_fine_amount NUMERIC;
BEGIN
    -- Obtener IDs de estados
SELECT status_id INTO v_active_status_id
FROM loan_status_type
WHERE status_name = 'ACTIVE'
    LIMIT 1;

SELECT status_id INTO v_overdue_status_id
FROM loan_status_type
WHERE status_name = 'OVERDUE'
    LIMIT 1;

SELECT status_id INTO v_pending_status_id
FROM fine_status_type
WHERE status_name = 'PENDING'
    LIMIT 1;

-- Si el préstamo cambió a OVERDUE
IF NEW.status_id = v_overdue_status_id 
       AND OLD.status_id = v_active_status_id 
       AND NEW.actual_return_date IS NULL THEN
        
        -- Calcular multa (ejemplo: 10000 COP por hora de retraso)
        v_fine_amount = CEIL(EXTRACT(EPOCH FROM (NOW() - NEW.expected_return_date)) / 3600) * 10000;
        
        -- Crear la multa
INSERT INTO fine (student_id, loan_id, amount, reason, status_id, generation_date)
VALUES (
           NEW.student_id,
           NEW.loan_id,
           v_fine_amount,
           'Multa por retraso en devolución de computadora',
           v_pending_status_id,
           NOW()
       );

-- Actualizar total de multas pendientes del estudiante
UPDATE student
SET pending_fines = (
    SELECT COALESCE(SUM(amount), 0)
    FROM fine
    WHERE student_id = NEW.student_id
      AND status_id = v_pending_status_id
)
WHERE student_id = NEW.student_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_create_fine_on_overdue_loan
    AFTER UPDATE ON loan
    FOR EACH ROW EXECUTE FUNCTION create_fine_on_overdue_loan();

COMMENT ON FUNCTION create_fine_on_overdue_loan() IS 'Crea automáticamente una multa cuando un préstamo se marca como OVERDUE';



-- 5.2 Trigger para actualizar multas pendientes del estudiante cuando se paga una multa
CREATE OR REPLACE FUNCTION update_student_pending_fines_on_payment()
RETURNS TRIGGER AS $$
DECLARE
v_pending_status_id UUID;
    v_paid_status_id UUID;
    v_total_pending NUMERIC;
BEGIN
    -- Obtener IDs de estados
SELECT status_id INTO v_pending_status_id
FROM fine_status_type
WHERE status_name = 'PENDING'
    LIMIT 1;

SELECT status_id INTO v_paid_status_id
FROM fine_status_type
WHERE status_name = 'PAID'
    LIMIT 1;

-- Si la multa fue pagada
IF NEW.status_id = v_paid_status_id 
       AND OLD.status_id = v_pending_status_id THEN
        
        -- Registrar fecha de pago
        IF NEW.payment_date IS NULL THEN
            NEW.payment_date = NOW();
END IF;
        
        -- Recalcular total de multas pendientes del estudiante
SELECT COALESCE(SUM(amount), 0) INTO v_total_pending
FROM fine
WHERE student_id = NEW.student_id
  AND status_id = v_pending_status_id;

UPDATE student
SET pending_fines = v_total_pending
WHERE student_id = NEW.student_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_student_fines_on_payment
    BEFORE UPDATE ON fine
    FOR EACH ROW EXECUTE FUNCTION update_student_pending_fines_on_payment();

COMMENT ON FUNCTION update_student_pending_fines_on_payment() IS 'Actualiza multas pendientes del estudiante cuando se marca una multa como pagada';



-- 5.3 Trigger para validar que estudiante con multas pendientes no pueda hacer préstamos
CREATE OR REPLACE FUNCTION validate_no_fines_for_loan()
RETURNS TRIGGER AS $$
DECLARE
v_pending_fines NUMERIC;
BEGIN
    -- Obtener multas pendientes del estudiante
SELECT pending_fines INTO v_pending_fines
FROM student
WHERE student_id = NEW.student_id
    LIMIT 1;

-- Si tiene multas pendientes, rechazar el préstamo
IF v_pending_fines > 0 THEN
        RAISE EXCEPTION 'El estudiante tiene multas pendientes por %%. No puede realizar préstamos hasta que las pague.', v_pending_fines;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_no_fines_for_loan
    BEFORE INSERT OR UPDATE ON loan
                         FOR EACH ROW EXECUTE FUNCTION validate_no_fines_for_loan();

COMMENT ON FUNCTION validate_no_fines_for_loan() IS 'Valida que el estudiante no tenga multas pendientes antes de hacer un préstamo';


-- 6. TRIGGERS PARA VALIDACIÓN DE REFERENCIA INTEGRIDAD


-- 6.1 Trigger para impedir desactivar el último administrador activo
CREATE OR REPLACE FUNCTION prevent_last_admin_deactivation()
RETURNS TRIGGER AS $$
DECLARE
v_admin_role_id UUID;
    v_active_status_id UUID;
    v_active_admin_count INT;
    v_inactive_status_id UUID;
BEGIN
    -- Obtener IDs
SELECT role_id INTO v_admin_role_id
FROM role_type
WHERE role_name = 'ADMINISTRATOR'
    LIMIT 1;

SELECT status_id INTO v_inactive_status_id
FROM employee_status_type
WHERE status_name = 'INACTIVE'
    LIMIT 1;

SELECT status_id INTO v_active_status_id
FROM employee_status_type
WHERE status_name = 'ACTIVE'
    LIMIT 1;

-- Si se intenta cambiar a INACTIVE
IF NEW.status_id = v_inactive_status_id 
       AND OLD.status_id = v_active_status_id 
       AND NEW.role_id = v_admin_role_id THEN
        
        -- Contar administradores activos
SELECT COUNT(*) INTO v_active_admin_count
FROM employee
WHERE role_id = v_admin_role_id
  AND status_id = v_active_status_id
  AND employee_id != NEW.employee_id;

-- Si no hay otros administradores activos, rechazar
IF v_active_admin_count = 0 THEN
            RAISE EXCEPTION 'No se puede desactivar al último administrador activo del sistema.';
END IF;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_last_admin_deactivation
    BEFORE UPDATE ON employee
    FOR EACH ROW EXECUTE FUNCTION prevent_last_admin_deactivation();

COMMENT ON FUNCTION prevent_last_admin_deactivation() IS 'Impide desactivar al último administrador activo del sistema';



-- 6.2 Trigger para impedir desactivar estudiante con préstamos activos
CREATE OR REPLACE FUNCTION prevent_deactivation_with_active_loans()
RETURNS TRIGGER AS $$
DECLARE
v_inactive_status_id UUID;
    v_active_status_id UUID;
    v_active_loan_count INT;
BEGIN
    -- Obtener IDs
SELECT status_id INTO v_inactive_status_id
FROM academic_status_type
WHERE status_name = 'INACTIVE'
    LIMIT 1;

SELECT status_id INTO v_active_status_id
FROM academic_status_type
WHERE status_name = 'ACTIVE'
    LIMIT 1;

-- Si se intenta cambiar a INACTIVE
IF NEW.academic_status_id = v_inactive_status_id 
       AND OLD.academic_status_id = v_active_status_id THEN
        
        -- Contar préstamos activos
SELECT COUNT(*) INTO v_active_loan_count
FROM loan
WHERE student_id = NEW.student_id
  AND status_id = (SELECT status_id FROM loan_status_type WHERE status_name = 'ACTIVE' LIMIT 1);

-- Si hay préstamos activos, rechazar
IF v_active_loan_count > 0 THEN
            RAISE EXCEPTION 'No se puede desactivar al estudiante. Tiene % préstamo(s) activo(s) pendiente(s) de devolución.', v_active_loan_count;
END IF;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_deactivation_with_active_loans
    BEFORE UPDATE ON student
    FOR EACH ROW EXECUTE FUNCTION prevent_deactivation_with_active_loans();

COMMENT ON FUNCTION prevent_deactivation_with_active_loans() IS 'Impide desactivar estudiante con préstamos activos';



-- 6.3 Trigger para impedir desactivar sala con reservas activas
CREATE OR REPLACE FUNCTION prevent_room_deactivation_with_active_reservations()
RETURNS TRIGGER AS $$
DECLARE
v_inactive_status_id UUID;
    v_available_status_id UUID;
    v_active_reservation_count INT;
BEGIN
    -- Obtener IDs
SELECT status_id INTO v_inactive_status_id
FROM room_status_type
WHERE status_name = 'CLOSED'
    LIMIT 1;

SELECT status_id INTO v_available_status_id
FROM room_status_type
WHERE status_name = 'AVAILABLE'
    LIMIT 1;

-- Si se intenta cambiar a CLOSED
IF NEW.status_id = v_inactive_status_id 
       AND OLD.status_id != v_inactive_status_id THEN
        
        -- Contar reservas activas en las próximas 24 horas
SELECT COUNT(*) INTO v_active_reservation_count
FROM reservation
WHERE room_id = NEW.room_id
  AND status_id = (SELECT status_id FROM reservation_status_type WHERE status_name = 'ACTIVE' LIMIT 1)
  AND DATE(reservation_date) = CURRENT_DATE
  AND EXTRACT(EPOCH FROM (end_time - CURRENT_TIME)) / 3600 < 24;

-- Si hay reservas en las próximas 24 horas, rechazar
IF v_active_reservation_count > 0 THEN
            RAISE EXCEPTION 'No se puede desactivar la sala. Tiene % reserva(s) activa(s) en las próximas 24 horas.', v_active_reservation_count;
END IF;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_room_deactivation_with_active_reservations
    BEFORE UPDATE ON room
    FOR EACH ROW EXECUTE FUNCTION prevent_room_deactivation_with_active_reservations();

COMMENT ON FUNCTION prevent_room_deactivation_with_active_reservations() IS 'Impide desactivar sala con reservas activas en próximas 24 horas';



-- 6.4 Trigger para impedir desactivar computadora con préstamos activos
CREATE OR REPLACE FUNCTION prevent_computer_deactivation_with_active_loans()
RETURNS TRIGGER AS $$
DECLARE
v_retired_status_id UUID;
    v_active_loan_count INT;
BEGIN
    -- Obtener ID del estado RETIRED
SELECT status_id INTO v_retired_status_id
FROM computer_status_type
WHERE status_name = 'RETIRED'
    LIMIT 1;

-- Si se intenta cambiar a RETIRED
IF NEW.status_id = v_retired_status_id 
       AND OLD.status_id != v_retired_status_id THEN
        
        -- Contar préstamos activos
SELECT COUNT(*) INTO v_active_loan_count
FROM loan
WHERE computer_id = NEW.computer_id
  AND status_id IN (
    SELECT status_id FROM loan_status_type
    WHERE status_name IN ('ACTIVE', 'OVERDUE')
);

-- Si hay préstamos activos o vencidos, rechazar
IF v_active_loan_count > 0 THEN
            RAISE EXCEPTION 'No se puede desactivar la computadora. Tiene % préstamo(s) activo(s) o vencido(s).', v_active_loan_count;
END IF;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_computer_deactivation_with_active_loans
    BEFORE UPDATE ON computer
    FOR EACH ROW EXECUTE FUNCTION prevent_computer_deactivation_with_active_loans();

COMMENT ON FUNCTION prevent_computer_deactivation_with_active_loans() IS 'Impide desactivar computadora con préstamos activos';


-- 7. TRIGGERS PARA VALIDACIÓN DE RESTRICCIONES DE NEGOCIO


-- 7.1 Trigger para validar que estudiante activo no tenga estado académico inactivo
CREATE OR REPLACE FUNCTION prevent_inactive_student_loan()
RETURNS TRIGGER AS $$
DECLARE
v_inactive_status_id UUID;
    v_student_academic_status UUID;
BEGIN
    -- Obtener estado académico inactivo
SELECT status_id INTO v_inactive_status_id
FROM academic_status_type
WHERE status_name = 'INACTIVE'
    LIMIT 1;

-- Obtener estado académico del estudiante
SELECT academic_status_id INTO v_student_academic_status
FROM student
WHERE student_id = NEW.student_id
    LIMIT 1;

-- Si el estudiante está académicamente inactivo, rechazar préstamo
IF v_student_academic_status = v_inactive_status_id THEN
        RAISE EXCEPTION 'El estudiante no está activo académicamente. No puede hacer préstamos.';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_inactive_student_loan
    BEFORE INSERT OR UPDATE ON loan
                         FOR EACH ROW EXECUTE FUNCTION prevent_inactive_student_loan();

COMMENT ON FUNCTION prevent_inactive_student_loan() IS 'Impide que estudiantes académicamente inactivos hagan préstamos';



-- 7.2 Trigger para validar disponibilidad de computadora
CREATE OR REPLACE FUNCTION validate_computer_available_for_loan()
RETURNS TRIGGER AS $$
DECLARE
v_computer_status VARCHAR(50);
    v_available_status_id UUID;
BEGIN
    -- Obtener estado de la computadora
SELECT status_name INTO v_computer_status
FROM computer_status_type
WHERE status_id = (SELECT status_id FROM computer WHERE computer_id = NEW.computer_id LIMIT 1)
    LIMIT 1;

-- La computadora debe estar disponible
IF v_computer_status NOT IN ('AVAILABLE') THEN
        RAISE EXCEPTION 'La computadora no está disponible para préstamo. Estado actual: %', v_computer_status;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_computer_available_for_loan
    BEFORE INSERT ON loan
    FOR EACH ROW EXECUTE FUNCTION validate_computer_available_for_loan();

COMMENT ON FUNCTION validate_computer_available_for_loan() IS 'Valida que la computadora esté disponible antes de crear un préstamo';



-- 7.3 Trigger para validar disponibilidad de sala para reserva
CREATE OR REPLACE FUNCTION validate_room_available_for_reservation()
RETURNS TRIGGER AS $$
DECLARE
v_room_status VARCHAR(50);
BEGIN
    -- Obtener estado de la sala
SELECT status_name INTO v_room_status
FROM room_status_type
WHERE status_id = (SELECT status_id FROM room WHERE room_id = NEW.room_id LIMIT 1)
    LIMIT 1;

-- La sala debe estar disponible
IF v_room_status NOT IN ('AVAILABLE') THEN
        RAISE EXCEPTION 'La sala no está disponible para reserva. Estado actual: %', v_room_status;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_room_available_for_reservation
    BEFORE INSERT ON reservation
    FOR EACH ROW EXECUTE FUNCTION validate_room_available_for_reservation();

COMMENT ON FUNCTION validate_room_available_for_reservation() IS 'Valida que la sala esté disponible antes de crear una reserva';


-- 8. TRIGGERS PARA DETECCIÓN DE CONFLICTOS DE HORARIOS


-- 8.1 Trigger para detectar conflicto de horarios en reservas de sala
CREATE OR REPLACE FUNCTION detect_room_reservation_conflict()
RETURNS TRIGGER AS $$
DECLARE
v_conflict_count INT;
    v_active_status_id UUID;
BEGIN
    -- Obtener estado ACTIVE
SELECT status_id INTO v_active_status_id
FROM reservation_status_type
WHERE status_name = 'ACTIVE'
    LIMIT 1;

-- Buscar conflictos de horarios
SELECT COUNT(*) INTO v_conflict_count
FROM reservation
WHERE room_id = NEW.room_id
  AND reservation_date = NEW.reservation_date
  AND status_id = v_active_status_id
  AND reservation_id != COALESCE(NEW.reservation_id, '00000000-0000-0000-0000-000000000000')
      AND (
          -- Hay sobreposición de horarios
          (NEW.start_time < end_time AND NEW.end_time > start_time)
      );

-- Si hay conflictos, rechazar
IF v_conflict_count > 0 THEN
        RAISE EXCEPTION 'Existe un conflicto de horarios. La sala ya está reservada en ese horario.';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_detect_room_reservation_conflict
    BEFORE INSERT OR UPDATE ON reservation
                         FOR EACH ROW EXECUTE FUNCTION detect_room_reservation_conflict();

COMMENT ON FUNCTION detect_room_reservation_conflict() IS 'Detecta y previene conflictos de horarios en reservas de sala';



-- 8.2 Trigger para detectar conflicto de horarios en préstamos de computadora
CREATE OR REPLACE FUNCTION detect_computer_loan_conflict()
RETURNS TRIGGER AS $$
DECLARE
v_conflict_count INT;
    v_active_status_id UUID;
BEGIN
    -- Obtener estado ACTIVE
SELECT status_id INTO v_active_status_id
FROM loan_status_type
WHERE status_name = 'ACTIVE'
    LIMIT 1;

-- Buscar conflictos de horarios
SELECT COUNT(*) INTO v_conflict_count
FROM loan
WHERE computer_id = NEW.computer_id
  AND status_id = v_active_status_id
  AND loan_id != COALESCE(NEW.loan_id, '00000000-0000-0000-0000-000000000000')
      AND (
          -- Hay sobreposición de horarios
          (NEW.request_date < expected_return_date AND NEW.expected_return_date > request_date)
      );

-- Si hay conflictos, rechazar
IF v_conflict_count > 0 THEN
        RAISE EXCEPTION 'Existe un conflicto de horarios. La computadora ya está prestada en ese horario.';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_detect_computer_loan_conflict
    BEFORE INSERT OR UPDATE ON loan
                         FOR EACH ROW EXECUTE FUNCTION detect_computer_loan_conflict();

COMMENT ON FUNCTION detect_computer_loan_conflict() IS 'Detecta y previene conflictos de horarios en préstamos de computadora';




COMMIT;

COMMENT ON SCHEMA public IS 'Schema principal con triggers de auditoría, validación e integridad para CampusLend';



