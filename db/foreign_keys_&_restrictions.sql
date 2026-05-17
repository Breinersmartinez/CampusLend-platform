LLAVES FORÁNEAS (FOREIGN KEYS)


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


