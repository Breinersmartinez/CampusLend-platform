-- TRIGGERS Y FUNCIONES


-- ── updated_at automático ────────────────────────────────
CREATE OR REPLACE FUNCTION fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_employee_updated_at    BEFORE UPDATE ON employee    FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();
CREATE TRIGGER trg_student_updated_at     BEFORE UPDATE ON student     FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();
CREATE TRIGGER trg_professor_updated_at   BEFORE UPDATE ON professor   FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();
CREATE TRIGGER trg_room_updated_at        BEFORE UPDATE ON room        FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();
CREATE TRIGGER trg_computer_updated_at    BEFORE UPDATE ON computer    FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();
CREATE TRIGGER trg_reservation_updated_at BEFORE UPDATE ON reservation FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();
CREATE TRIGGER trg_loan_updated_at        BEFORE UPDATE ON loan        FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();
CREATE TRIGGER trg_fine_updated_at        BEFORE UPDATE ON fine        FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();


-- ── Sincronizar pending_fines en student y professor ─────
CREATE OR REPLACE FUNCTION fn_sync_pending_fines()
RETURNS TRIGGER AS $$
DECLARE
v_pending_status_id INTEGER;
BEGIN
SELECT status_id INTO v_pending_status_id
FROM fine_status_type WHERE status_name = 'PENDING';

IF NEW.student_id IS NOT NULL THEN
UPDATE student
SET pending_fines = (
    SELECT COALESCE(SUM(amount), 0)
    FROM fine
    WHERE student_id = NEW.student_id
      AND status_id = v_pending_status_id
)
WHERE student_id = NEW.student_id;
END IF;

    IF NEW.professor_id IS NOT NULL THEN
UPDATE professor
SET pending_fines = (
    SELECT COALESCE(SUM(amount), 0)
    FROM fine
    WHERE professor_id = NEW.professor_id
      AND status_id = v_pending_status_id
)
WHERE professor_id = NEW.professor_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_pending_fines
    AFTER INSERT OR UPDATE ON fine
                        FOR EACH ROW EXECUTE FUNCTION fn_sync_pending_fines();


-- ── Al crear préstamo: marcar computadora como IN_LOAN ───
-- ── Si viene de reserva: marcarla como CONVERTED_TO_LOAN ─
CREATE OR REPLACE FUNCTION fn_on_loan_insert()
RETURNS TRIGGER AS $$
DECLARE
v_in_loan_status INTEGER;
    v_converted_status INTEGER;
BEGIN
SELECT status_id INTO v_in_loan_status
FROM computer_status_type WHERE status_name = 'IN_LOAN';

UPDATE computer SET status_id = v_in_loan_status
WHERE computer_id = NEW.computer_id;

IF NEW.reservation_id IS NOT NULL THEN
SELECT status_id INTO v_converted_status
FROM reservation_status_type WHERE status_name = 'CONVERTED_TO_LOAN';

UPDATE reservation SET status_id = v_converted_status
WHERE reservation_id = NEW.reservation_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_loan_insert
    AFTER INSERT ON loan
    FOR EACH ROW EXECUTE FUNCTION fn_on_loan_insert();


-- ── Al devolver préstamo: liberar computadora ────────────
CREATE OR REPLACE FUNCTION fn_on_loan_return()
RETURNS TRIGGER AS $$
DECLARE
v_returned_status  INTEGER;
    v_available_status INTEGER;
BEGIN
SELECT status_id INTO v_returned_status
FROM loan_status_type WHERE status_name = 'RETURNED';

SELECT status_id INTO v_available_status
FROM computer_status_type WHERE status_name = 'AVAILABLE';

IF NEW.status_id = v_returned_status AND OLD.status_id != v_returned_status THEN
UPDATE computer SET status_id = v_available_status
WHERE computer_id = NEW.computer_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_loan_return
    AFTER UPDATE ON loan
    FOR EACH ROW EXECUTE FUNCTION fn_on_loan_return();


-- ── Proteger computadora EN_LOAN contra cambios de estado ─
CREATE OR REPLACE FUNCTION fn_protect_computer_in_loan()
RETURNS TRIGGER AS $$
DECLARE
v_in_loan_status   INTEGER;
    v_available_status INTEGER;
BEGIN
SELECT status_id INTO v_in_loan_status
FROM computer_status_type WHERE status_name = 'IN_LOAN';

SELECT status_id INTO v_available_status
FROM computer_status_type WHERE status_name = 'AVAILABLE';

IF OLD.status_id = v_in_loan_status AND NEW.status_id != v_available_status THEN
        RAISE EXCEPTION
            'Computer % has an active loan. Status can only be changed to AVAILABLE upon return.',
            OLD.computer_id;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_protect_computer_in_loan
    BEFORE UPDATE ON computer
    FOR EACH ROW EXECUTE FUNCTION fn_protect_computer_in_loan();


-- ── Proteger último administrador activo ─────────────────
CREATE OR REPLACE FUNCTION fn_protect_last_admin()
RETURNS TRIGGER AS $$
DECLARE
v_admin_role_id    INTEGER;
    v_active_status_id INTEGER;
    v_inactive_status_id INTEGER;
    v_admin_count      INTEGER;
BEGIN
SELECT role_id INTO v_admin_role_id
FROM role_type WHERE role_name = 'ADMINISTRATOR';

SELECT status_id INTO v_active_status_id
FROM employee_status_type WHERE status_name = 'ACTIVE';

SELECT status_id INTO v_inactive_status_id
FROM employee_status_type WHERE status_name = 'INACTIVE';

IF NEW.status_id = v_inactive_status_id
        AND OLD.status_id = v_active_status_id
        AND OLD.role_id = v_admin_role_id THEN

SELECT COUNT(*) INTO v_admin_count
FROM employee
WHERE role_id = v_admin_role_id
  AND status_id = v_active_status_id;

IF v_admin_count <= 1 THEN
            RAISE EXCEPTION 'Cannot deactivate the last active administrator in the system.';
END IF;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_protect_last_admin
    BEFORE UPDATE ON employee
    FOR EACH ROW EXECUTE FUNCTION fn_protect_last_admin();