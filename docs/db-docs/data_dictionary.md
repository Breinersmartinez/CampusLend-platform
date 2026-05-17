# CAMPUSLEND - DICCIONARIO DE DATOS

**Sistema de Gestión de Préstamos de Computadoras y Reserva de Salas**  
**Universidad Cooperativa de Colombia**  
**Última actualización:** 2025-01-16

---

##  Tabla de Contenidos

1. [Descripción General](#descripción-general)
2. [Convenciones de Nombres](#convenciones-de-nombres)
3. [Tipos de Datos](#tipos-de-datos)
4. [Tablas de Referencia](#tablas-de-referencia)
5. [Tablas Principales](#tablas-principales)
6. [Relaciones entre Tablas](#relaciones-entre-tablas)
7. [Índices y Llaves](#índices-y-llaves)
8. [Vistas Principales](#vistas-principales)

---

## Descripción General

El diccionario de datos documenta la estructura completa de la base de datos PostgreSQL del sistema CampusLend. Incluye:

- **11 Tablas de Referencia (Catálogos)** - Valores estáticos de dominio
- **8 Tablas Principales** - Datos transaccionales del sistema
- **32 Triggers** - Automatización de auditoría, validación e integridad
- **Zona Horaria**: UTC (configurada en inicialización)
- **Integridad Referencial**: Foreign Keys en cascada donde aplica

---

## Convenciones de Nombres

| Elemento | Patrón | Ejemplo |
|----------|--------|---------|
| Tabla | `snake_case` | `room_equipment` |
| Columna | `snake_case` | `employee_id`, `status_id` |
| Clave Primaria | `{table}_id` | `employee_id` |
| Clave Foránea | `{table}_id` | `room_id` (en reservation) |
| Booleano | `is_{property}` | - |
| Fecha/Hora | `{event}_date`, `{event}_time` | `creation_date`, `start_time` |
| Timestamp | `{event}_at` | `created_at`, `updated_at` |
| Trigger | `trg_{action}_{table}` | `trg_audit_employee` |
| Función | `{action}_{table}_{details}()` | `audit_employee_changes()` |

---

## Tipos de Datos

### Tipos Utilizados

```
UUID          - Identificadores únicos (PgCrypto extension)
VARCHAR(n)    - Cadenas de texto variable
TEXT          - Texto largo ilimitado
INTEGER       - Números enteros
SMALLINT      - Números enteros pequeños (-32768 a 32767)
NUMERIC(p,s)  - Números decimales precisos
DATE          - Fechas (YYYY-MM-DD)
TIME          - Horas (HH:MM:SS)
TIMESTAMPTZ   - Timestamp con zona horaria (UTC)
INET          - Dirección IP (para auditoría)
JSONB         - JSON binario (para auditoría de datos previos/nuevos)
BOOLEAN       - Valores verdadero/falso
```

---

# TABLAS DE REFERENCIA (CATÁLOGOS)

Las tablas de referencia contienen valores estáticos que definen los dominios permitidos del sistema.

---

## 1. role_type

**Descripción:** Roles y permisos de empleados del DTI

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| role_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único del rol |
| role_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del rol (ADMINISTRATOR, IT_STAFF) |
| description | TEXT | NULL | Descripción detallada del rol |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación del registro |

**Valores Precargados:**
- `ADMINISTRATOR` - Acceso total a administración del sistema y reportes
- `IT_STAFF` - Gestión operacional de equipos y reservas

**Notas:**
- No tiene campo `updated_at` porque los roles no cambian frecuentemente
- UNIQUE en `role_name` para evitar duplicados

---

## 2. employee_status_type

**Descripción:** Estados posibles de un empleado

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| status_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| status_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del estado |
| description | TEXT | NULL | Descripción del estado |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `ACTIVE` - Empleado activo con acceso al sistema
- `INACTIVE` - Sin acceso, registros conservados
- `SUSPENDED` - Suspensión temporal del sistema
- `RETIRED` - Empleado jubilado, datos archivados

---

## 3. academic_status_type

**Descripción:** Estados académicos de estudiantes

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| status_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| status_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del estado |
| description | TEXT | NULL | Descripción del estado |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `ACTIVE` - Estudiante actualmente matriculado
- `INACTIVE` - No matriculado actualmente
- `SUSPENDED` - Suspensión académica
- `GRADUATED` - Estudiante graduado

---

## 4. room_status_type

**Descripción:** Estados de disponibilidad de salas

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| status_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| status_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del estado |
| description | TEXT | NULL | Descripción del estado |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `AVAILABLE` - Disponible para reserva
- `MAINTENANCE` - En mantenimiento
- `CLOSED` - Permanentemente cerrada
- `RESERVED` - Actualmente reservada

---

## 5. computer_status_type

**Descripción:** Estados de computadoras

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| status_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| status_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del estado |
| description | TEXT | NULL | Descripción del estado |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `AVAILABLE` - Disponible para préstamo
- `IN_LOAN` - Préstamo activo (sincronizado por trigger)
- `MAINTENANCE` - En mantenimiento
- `RETIRED` - Decommissionada
- `DAMAGED` - Dañada, no disponible

---

## 6. equipment_type

**Descripción:** Tipos de equipamiento disponible en salas

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| equipment_type_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| equipment_name | VARCHAR(100) | NOT NULL, UNIQUE | Nombre del equipamiento |
| description | TEXT | NULL | Descripción técnica |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `PROJECTOR` - Proyector de datos
- `WHITEBOARD` - Pizarra interactiva
- `DESK` - Escritorio de estudio
- `CHAIR` - Silla de estudio
- `COMPUTER` - Computadora de escritorio
- `PRINTER` - Impresora de red
- `MONITOR` - Monitor adicional
- `SPEAKER_SYSTEM` - Sistema de audio

---

## 7. resource_type

**Descripción:** Tipos de recursos que pueden reservarse

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| resource_type_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| resource_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del recurso |
| description | TEXT | NULL | Descripción |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `ROOM` - Reserva de sala física
- `COMPUTER` - Préstamo de computadora

---

## 8. reservation_status_type

**Descripción:** Estados de reservas y préstamos

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| status_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| status_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del estado |
| description | TEXT | NULL | Descripción |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `ACTIVE` - Reserva activa y pendiente
- `CANCELLED` - Reserva cancelada
- `COMPLETED` - Reserva completada
- `CONVERTED_TO_LOAN` - Reserva convertida a préstamo

---

## 9. loan_status_type

**Descripción:** Estados de préstamos de computadoras

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| status_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| status_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del estado |
| description | TEXT | NULL | Descripción |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `ACTIVE` - Préstamo activo, pendiente devolución
- `RETURNED` - Equipo devuelto
- `OVERDUE` - Retraso en devolución (detectado por trigger)
- `LOST` - Equipo reportado como perdido

---

## 10. fine_status_type

**Descripción:** Estados de multas

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| status_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| status_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del estado |
| description | TEXT | NULL | Descripción |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `PENDING` - Multa no pagada
- `PAID` - Multa pagada
- `WAIVED` - Exonerada por decisión del DTI
- `DISPUTED` - En disputa/reclamo

---

## 11. audit_action_type

**Descripción:** Tipos de acciones registradas en auditoría

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| action_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| action_name | VARCHAR(50) | NOT NULL, UNIQUE | Nombre de la acción |
| description | TEXT | NULL | Descripción |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de creación |

**Valores Precargados:**
- `CREATE` - Registro creado
- `UPDATE` - Registro actualizado
- `DELETE` - Registro eliminado
- `LOGIN` - Evento de login
- `LOGOUT` - Evento de logout

---

# TABLAS PRINCIPALES

Las tablas principales contienen los datos transaccionales del sistema.

---

## 1. employee (EMPLEADO DTI)

**Descripción:** Personal del DTI con acceso al sistema

**Relaciones:**
- FK: `role_id` → `role_type.role_id`
- FK: `status_id` → `employee_status_type.status_id`
- 1:N con `audit` (auditor)
- 1:N con `loan` (registrante)

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| employee_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| card_id | VARCHAR(20) | NOT NULL, UNIQUE | Número de carnet único |
| first_name | VARCHAR(150) | NOT NULL | Primer nombre |
| last_name | VARCHAR(150) | NOT NULL | Apellido |
| institutional_email | VARCHAR(100) | NOT NULL, UNIQUE | Email @ucc.edu.co |
| password_hash | VARCHAR(255) | NOT NULL | Contraseña cifrada (BCrypt) |
| role_id | UUID | NOT NULL, FK | Referencia a role_type |
| department | VARCHAR(100) | NOT NULL | Departamento (p. ej., "DTI", "Sistemas") |
| phone | VARCHAR(20) | NULL | Teléfono de contacto |
| status_id | UUID | NOT NULL, FK | Estado del empleado |
| hire_date | DATE | NOT NULL, Default: `CURRENT_DATE` | Fecha de contratación |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Registro creado |
| updated_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Último cambio (trigger) |

**Índices:**
- PRIMARY KEY: `employee_id`
- UNIQUE: `card_id`, `institutional_email`
- FK INDEX: `role_id`, `status_id`

**Triggers Asociados:**
- `trg_audit_employee` - Audita cambios
- `trg_update_employee_timestamp` - Actualiza updated_at
- `trg_prevent_last_admin_deactivation` - Valida admin único

**Validaciones:**
- Email debe contener dominio @ucc.edu.co
- Password hash con BCrypt (Spring Security)
- card_id único (carnet institucional)

---

## 2. student (ESTUDIANTE)

**Descripción:** Estudiantes registrados en el sistema

**Relaciones:**
- FK: `academic_status_id` → `academic_status_type.status_id`
- 1:N con `reservation`
- 1:N con `loan`
- 1:N con `fine`

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| student_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| id_card | VARCHAR(20) | NOT NULL, UNIQUE | Cédula de identidad |
| first_name | VARCHAR(150) | NOT NULL | Primer nombre |
| last_name | VARCHAR(150) | NOT NULL | Apellido |
| institutional_email | VARCHAR(100) | NOT NULL, UNIQUE | Email @campusucc.edu.co |
| password_hash | VARCHAR(255) | NOT NULL | Contraseña cifrada (BCrypt) |
| academic_program | VARCHAR(150) | NOT NULL | Programa académico (carrera) |
| semester | SMALLINT | NOT NULL | Semestre actual (1-12) |
| academic_status_id | UUID | NOT NULL, FK | Estado académico |
| pending_fines | NUMERIC(10,2) | NOT NULL, Default: 0.00 | Total multas pendientes (sincronizado por trigger) |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Registro creado |
| updated_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Último cambio |

**Índices:**
- PRIMARY KEY: `student_id`
- UNIQUE: `id_card`, `institutional_email`
- FK INDEX: `academic_status_id`

**Triggers Asociados:**
- `trg_audit_student` - Audita cambios
- `trg_update_student_timestamp` - Actualiza updated_at
- `trg_prevent_deactivation_with_active_loans` - Valida sin préstamos activos

**Validaciones:**
- Email debe contener dominio @campusucc.edu.co
- Semestre entre 1 y 12
- pending_fines se actualiza automáticamente por triggers de multas

**Notas:**
- `pending_fines` es denormalizado por rendimiento, siempre sincronizado por triggers

---

## 3. room (SALA)

**Descripción:** Salas de estudio y trabajo disponibles para reserva

**Relaciones:**
- FK: `status_id` → `room_status_type.status_id`
- 1:N con `room_equipment`
- 1:N con `reservation`

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| room_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| name | VARCHAR(100) | NOT NULL | Nombre de la sala (p. ej., "Sala de Estudio A") |
| building | VARCHAR(50) | NOT NULL | Torre/Edificio (p. ej., "Torre A", "Bloque 1") |
| floor | SMALLINT | NOT NULL | Número de piso |
| room_number | VARCHAR(20) | NOT NULL | Número de sala |
| max_capacity | SMALLINT | NOT NULL | Capacidad máxima de personas |
| opening_time | TIME | NOT NULL | Hora apertura (HH:MM:SS) |
| closing_time | TIME | NOT NULL | Hora cierre (HH:MM:SS) |
| status_id | UUID | NOT NULL, FK | Estado de la sala |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Registro creado |
| updated_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Último cambio |

**Índices:**
- PRIMARY KEY: `room_id`
- UNIQUE: `(building, floor, room_number)` - Ubicación única
- FK INDEX: `status_id`

**Triggers Asociados:**
- `trg_audit_room` - Audita cambios
- `trg_update_room_timestamp` - Actualiza updated_at
- `trg_prevent_room_deactivation_with_active_reservations` - Valida sin reservas activas
- `trg_detect_room_reservation_conflict` - Detecta conflictos horarios
- `trg_validate_room_available_for_reservation` - Valida disponibilidad

**Validaciones:**
- opening_time < closing_time
- max_capacity > 0
- Ubicación (building, floor, room_number) única
- Status debe ser AVAILABLE para permitir reservas

---

## 4. room_equipment (EQUIPAMIENTO DE SALA)

**Descripción:** Inventario de equipamiento en cada sala

**Relaciones:**
- FK: `room_id` → `room.room_id`
- FK: `equipment_type_id` → `equipment_type.equipment_type_id`

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| room_equipment_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| room_id | UUID | NOT NULL, FK | Referencia a sala |
| equipment_type_id | UUID | NOT NULL, FK | Tipo de equipamiento |
| quantity | SMALLINT | NOT NULL, Default: 1 | Cantidad disponible |
| notes | TEXT | NULL | Observaciones (estado, marca, modelo) |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Registro creado |
| updated_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Último cambio |

**Índices:**
- PRIMARY KEY: `room_equipment_id`
- UNIQUE: `(room_id, equipment_type_id)` - Una sala no puede tener 2x el mismo equipo
- FK INDEX: `room_id`, `equipment_type_id`

**Triggers Asociados:**
- `trg_update_room_equipment_timestamp` - Actualiza updated_at

**Validaciones:**
- quantity > 0
- No duplicados por sala y tipo

**Ejemplo:**
```
Room A tiene: 2 Proyectores, 1 Pizarra Interactiva, 10 Escritorios
```

---

## 5. computer (COMPUTADORA)

**Descripción:** Laptops y computadoras disponibles para préstamo

**Relaciones:**
- FK: `status_id` → `computer_status_type.status_id`
- 1:N con `loan`
- 1:N con `reservation`

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| computer_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| inventory_code | VARCHAR(50) | NOT NULL, UNIQUE | Código de inventario (etiqueta física) |
| model | VARCHAR(100) | NOT NULL | Modelo (p. ej., "Dell XPS 13") |
| brand | VARCHAR(100) | NOT NULL | Marca (Dell, HP, Lenovo) |
| processor | VARCHAR(100) | NOT NULL | Procesador (p. ej., "Intel i7-10700K") |
| ram_gb | SMALLINT | NOT NULL | RAM en GB |
| storage_gb | INTEGER | NOT NULL | Almacenamiento en GB |
| qr_code | VARCHAR(255) | UNIQUE, NULL | Código QR/barcode para escaneo rápido |
| status_id | UUID | NOT NULL, FK | Estado actual |
| acquisition_date | DATE | NOT NULL | Fecha de adquisición |
| notes | TEXT | NULL | Observaciones (daños, historial) |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Registro creado |
| updated_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Último cambio |

**Índices:**
- PRIMARY KEY: `computer_id`
- UNIQUE: `inventory_code`, `qr_code`
- FK INDEX: `status_id`

**Triggers Asociados:**
- `trg_audit_computer` - Audita cambios
- `trg_update_computer_timestamp` - Actualiza updated_at
- `trg_sync_computer_status_on_loan_creation` - Cambia a IN_LOAN en préstamo
- `trg_sync_computer_status_on_loan_return` - Cambia a AVAILABLE en devolución
- `trg_prevent_computer_deactivation_with_active_loans` - Valida sin préstamos activos
- `trg_detect_computer_loan_conflict` - Detecta conflictos horarios
- `trg_validate_computer_available_for_loan` - Valida disponibilidad

**Validaciones:**
- inventory_code único (etiqueta física)
- ram_gb > 0 y storage_gb > 0
- acquisition_date válida
- Status debe ser AVAILABLE para préstamos

**Estados Posibles:**
- `AVAILABLE` → Disponible
- `IN_LOAN` → Préstamo activo (sincronizado)
- `MAINTENANCE` → En reparación
- `RETIRED` → Decommissionada
- `DAMAGED` → Dañada

---

## 6. reservation (RESERVA)

**Descripción:** Reservas de salas y computadoras por estudiantes

**Relaciones:**
- FK: `student_id` → `student.student_id`
- FK: `resource_type_id` → `resource_type.resource_type_id`
- FK: `room_id` → `room.room_id` (NULL si es computadora)
- FK: `computer_id` → `computer.computer_id` (NULL si es sala)
- FK: `status_id` → `reservation_status_type.status_id`

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| reservation_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| student_id | UUID | NOT NULL, FK | Estudiante que reserva |
| resource_type_id | UUID | NOT NULL, FK | ROOM o COMPUTER (determina cuál FK usar) |
| room_id | UUID | NULL, FK | Sala reservada (si resource_type = ROOM) |
| computer_id | UUID | NULL, FK | Computadora reservada (si resource_type = COMPUTER) |
| reservation_date | DATE | NOT NULL | Fecha de la reserva |
| start_time | TIME | NOT NULL | Hora inicio (HH:MM:SS) |
| end_time | TIME | NOT NULL | Hora fin (HH:MM:SS) |
| status_id | UUID | NOT NULL, FK | Estado de la reserva |
| cancellation_reason | TEXT | NULL | Motivo si fue cancelada |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Registro creado |
| updated_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Último cambio |

**Índices:**
- PRIMARY KEY: `reservation_id`
- FK INDEX: `student_id`, `resource_type_id`, `room_id`, `computer_id`, `status_id`
- SEARCH INDEX: `(room_id, reservation_date)` para detectar conflictos

**Triggers Asociados:**
- `trg_audit_reservation` - Audita cambios
- `trg_update_reservation_timestamp` - Actualiza updated_at
- `trg_validate_reservation_duration` - Máximo 3 horas
- `trg_validate_reservation_advance` - Máximo 7 días anticipación
- `trg_validate_computer_reservation_same_day` - Computadora = mismo día
- `trg_detect_room_reservation_conflict` - Sin conflictos horarios
- `trg_validate_room_available_for_reservation` - Sala disponible

**Reglas de Negocio:**
- ROOM: Hasta 7 días de anticipación, máximo 3 horas de duración
- COMPUTER: Mismo día, máximo 3 horas de duración
- Cancelación automática si no inicia en 30 minutos (trigger)

**Validaciones:**
- start_time < end_time
- reservation_date >= TODAY
- end_time - start_time <= 3 horas (180 minutos)
- Si ROOM: reservation_date <= TODAY + 7 días
- Si COMPUTER: reservation_date = TODAY
- Sin conflictos horarios en el mismo recurso

---

## 7. loan (PRÉSTAMO)

**Descripción:** Préstamos de computadoras a estudiantes

**Relaciones:**
- FK: `student_id` → `student.student_id`
- FK: `computer_id` → `computer.computer_id`
- FK: `employee_registrant_id` → `employee.employee_id` (quien entrega)
- FK: `reservation_id` → `reservation.reservation_id` (NULL si préstamo directo)
- FK: `status_id` → `loan_status_type.status_id`
- 1:N con `fine`

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| loan_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| student_id | UUID | NOT NULL, FK | Estudiante que toma préstamo |
| computer_id | UUID | NOT NULL, FK | Computadora prestada |
| employee_registrant_id | UUID | NOT NULL, FK | Empleado DTI que entrega |
| reservation_id | UUID | UNIQUE, NULL, FK | Reserva asociada (NULL = préstamo directo) |
| request_date | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Timestamp de solicitud |
| expected_return_date | TIMESTAMPTZ | NOT NULL | Timestamp esperado de devolución |
| actual_return_date | TIMESTAMPTZ | NULL | Timestamp real de devolución |
| status_id | UUID | NOT NULL, FK | Estado del préstamo |
| notes | TEXT | NULL | Observaciones (daños al devolver, etc.) |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Registro creado |
| updated_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Último cambio |

**Índices:**
- PRIMARY KEY: `loan_id`
- UNIQUE: `reservation_id` (una reserva → un préstamo máximo)
- FK INDEX: `student_id`, `computer_id`, `employee_registrant_id`, `status_id`
- SEARCH INDEX: `(student_id, status_id)` para válido(1 préstamo activo)

**Triggers Asociados:**
- `trg_audit_loan` - Audita cambios
- `trg_update_loan_timestamp` - Actualiza updated_at
- `trg_sync_computer_status_on_loan_creation` - Estado → IN_LOAN
- `trg_sync_computer_status_on_loan_return` - Estado → AVAILABLE
- `trg_validate_single_active_loan` - Máximo 1 préstamo activo por estudiante
- `trg_validate_loan_duration` - Máximo 2 horas
- `trg_validate_loan_operating_hours` - 7 AM - 9 PM
- `trg_cancel_expired_loans` - Auto-cancela si no inicia en 10 min
- `trg_detect_overdue_loans` - Detecta retrasos
- `trg_detect_computer_loan_conflict` - Sin conflictos horarios
- `trg_validate_computer_available_for_loan` - Computadora disponible
- `trg_prevent_inactive_student_loan` - Estudiante académicamente activo
- `trg_validate_no_fines_for_loan` - Sin multas pendientes
- `trg_create_fine_on_overdue_loan` - Crear multa si vence

**Reglas de Negocio:**
- Máximo 2 horas de duración
- Entre 7:00 AM y 21:00 (9 PM)
- Un estudiante no puede tener 2 préstamos ACTIVE simultáneamente
- Cancelación automática si no inicia en 10 minutos
- Multa automática de 10,000 COP/hora si se vence
- Estudiante debe estar ACTIVE académicamente
- Estudiante no puede tener multas pendientes

**Estados Posibles:**
- `ACTIVE` - Préstamo vigente
- `RETURNED` - Computadora devuelta
- `OVERDUE` - Retraso (detectado por trigger)
- `LOST` - Computadora perdida

---

## 8. fine (MULTA)

**Descripción:** Multas por retrasos en devolución de computadoras

**Relaciones:**
- FK: `student_id` → `student.student_id`
- FK: `loan_id` → `loan.loan_id` (NULL si multa por otro motivo)
- FK: `status_id` → `fine_status_type.status_id`

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| fine_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| student_id | UUID | NOT NULL, FK | Estudiante multado |
| loan_id | UUID | NULL, FK | Préstamo asociado (NULL si multa sin origen de préstamo) |
| amount | NUMERIC(10,2) | NOT NULL | Monto en COP |
| reason | TEXT | NOT NULL | Motivo de la multa |
| status_id | UUID | NOT NULL, FK | Estado de la multa |
| generation_date | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Fecha de generación |
| payment_date | TIMESTAMPTZ | NULL | Fecha de pago (NULL si PENDING) |
| created_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Registro creado |
| updated_at | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Último cambio |

**Índices:**
- PRIMARY KEY: `fine_id`
- FK INDEX: `student_id`, `loan_id`, `status_id`
- SEARCH INDEX: `(student_id, status_id)` para calcular pending_fines

**Triggers Asociados:**
- `trg_audit_fine` - Audita cambios
- `trg_update_fine_timestamp` - Actualiza updated_at
- `trg_create_fine_on_overdue_loan` - Auto-crear multa en OVERDUE
- `trg_update_student_fines_on_payment` - Actualiza pending_fines al pagar

**Cálculo de Multas:**
- **Retrasos:** 10,000 COP por hora completa de retraso
- Ejemplo: 2.5 horas de retraso = 30,000 COP (3 horas redondeadas)

**Estados Posibles:**
- `PENDING` - No pagada
- `PAID` - Pagada (payment_date registrada)
- `WAIVED` - Exonerada por DTI
- `DISPUTED` - En reclamo/disputa

**Notas:**
- Creada automáticamente por trigger cuando loan.status = OVERDUE
- Impide nuevos préstamos si hay multas PENDING

---

## 9. audit (AUDITORÍA)

**Descripción:** Registro inmutable de todas las operaciones críticas

**Relaciones:**
- FK: `action_id` → `audit_action_type.action_id`
- FK: `employee_id` → `employee.employee_id` (NULL si acción de estudiante)
- FK: `student_id` → `student.student_id` (NULL si acción de empleado)

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| audit_id | UUID | PK, Default: `gen_random_uuid()` | Identificador único |
| affected_table | VARCHAR(100) | NOT NULL | Tabla modificada (employee, student, room, loan, etc.) |
| record_id | VARCHAR(100) | NULL | UUID del registro modificado |
| action_id | UUID | NOT NULL, FK | CREATE, UPDATE, DELETE, LOGIN, LOGOUT |
| employee_id | UUID | NULL, FK | Empleado que realizó la acción |
| student_id | UUID | NULL, FK | Estudiante que realizó la acción |
| user_role | VARCHAR(50) | NULL | Rol del usuario (ADMINISTRATOR, IT_STAFF) |
| previous_data | JSONB | NULL | Datos antes de cambio (UPDATE) |
| new_data | JSONB | NULL | Datos después de cambio (INSERT/UPDATE) |
| source_ip | INET | NULL | IP de origen de la solicitud |
| date_time | TIMESTAMPTZ | NOT NULL, Default: `NOW()` | Timestamp exacto de la acción |

**Índices:**
- PRIMARY KEY: `audit_id`
- INDEX: `date_time` (búsqueda temporal)
- INDEX: `affected_table` (búsqueda por tabla)
- INDEX: `(employee_id, date_time)` (auditoría por empleado)
- INDEX: `(student_id, date_time)` (auditoría por estudiante)

**Características:**
- **Inmutable** - Nunca se actualiza ni se elimina
- **JSONB** - Permite búsquedas eficientes en datos antiguo/nuevo
- **Completa** - Todo cambio en tablas principales es auditado
- **Timestamps exactos** - Con zona horaria UTC

**Ejemplos de Datos:**
```json
{
  "previous_data": {"status_id": "uuid1", "pending_fines": 0},
  "new_data": {"status_id": "uuid2", "pending_fines": 10000}
}
```

---

# RELACIONES ENTRE TABLAS

## Diagrama de Relaciones

```
role_type
    ↑ (1)
    │ (N)
    └─── employee
            ↑ (1)
            │ (N)
            └─── loan (como registrante)

employee_status_type
    ↑ (1)
    │ (N)
    └─── employee

academic_status_type
    ↑ (1)
    │ (N)
    └─── student

student
    ├─────→ (1) academic_status_type
    ├─────→ (N) reservation
    ├─────→ (N) loan
    └─────→ (N) fine

room_status_type
    ↑ (1)
    │ (N)
    └─── room

room
    ├─────→ (1) room_status_type
    ├─────→ (N) room_equipment
    └─────→ (N) reservation

equipment_type
    ↑ (1)
    │ (N)
    └─── room_equipment

computer_status_type
    ↑ (1)
    │ (N)
    └─── computer

computer
    ├─────→ (1) computer_status_type
    ├─────→ (N) loan
    └─────→ (N) reservation

resource_type
    ↑ (1)
    │ (N)
    └─── reservation

reservation_status_type
    ↑ (1)
    │ (N)
    └─── reservation

reservation
    ├─────→ (1) student
    ├─────→ (1) resource_type
    ├─────→ (1) room (NULL si COMPUTER)
    ├─────→ (1) computer (NULL si ROOM)
    ├─────→ (1) reservation_status_type
    └─────→ (1) loan (único)

loan_status_type
    ↑ (1)
    │ (N)
    └─── loan

loan
    ├─────→ (1) student
    ├─────→ (1) computer
    ├─────→ (1) employee (registrante)
    ├─────→ (1) reservation (NULL = directo)
    ├─────→ (1) loan_status_type
    └─────→ (N) fine

fine_status_type
    ↑ (1)
    │ (N)
    └─── fine

fine
    ├─────→ (1) student
    ├─────→ (1) loan (NULL si multa manual)
    └─────→ (1) fine_status_type

audit_action_type
    ↑ (1)
    │ (N)
    └─── audit

audit
    ├─────→ (1) audit_action_type
    ├─────→ (1) employee (NULL si student)
    └─────→ (1) student (NULL si employee)
```

## Restricciones de Integridad Referencial

| Relación | On Delete | On Update | Notas |
|----------|-----------|-----------|-------|
| employee → role_type | NO ACTION | CASCADE | No se pueden eliminar roles |
| employee → employee_status_type | NO ACTION | CASCADE | No se pueden eliminar estados |
| student → academic_status_type | NO ACTION | CASCADE | No se pueden eliminar estados |
| room → room_status_type | NO ACTION | CASCADE | No se pueden eliminar estados |
| computer → computer_status_type | NO ACTION | CASCADE | No se pueden eliminar estados |
| reservation → room | RESTRICT | CASCADE | Trigger valida sin reservas activas |
| reservation → computer | RESTRICT | CASCADE | Trigger valida sin reservas activas |
| loan → computer | RESTRICT | CASCADE | Trigger valida sin préstamos activos |
| loan → student | RESTRICT | CASCADE | Trigger valida sin préstamos activos |
| fine → student | CASCADE | CASCADE | Eliminar estudiante → elimina multas |
| fine → loan | SET NULL | CASCADE | Eliminar préstamo → multa sin loan_id |

---

# ÍNDICES Y LLAVES

## Índices Creados

```sql
-- Claves Primarias (automáticas)
PRIMARY KEY (role_id, employee_id, student_id, room_id, computer_id, etc.)

-- Claves Únicas
UNIQUE (role_type.role_name)
UNIQUE (employee_status_type.status_name)
UNIQUE (academic_status_type.status_name)
UNIQUE (room_status_type.status_name)
UNIQUE (computer_status_type.status_name)
UNIQUE (equipment_type.equipment_name)
UNIQUE (resource_type.resource_name)
UNIQUE (reservation_status_type.status_name)
UNIQUE (loan_status_type.status_name)
UNIQUE (fine_status_type.status_name)
UNIQUE (audit_action_type.action_name)
UNIQUE (employee.card_id)
UNIQUE (employee.institutional_email)
UNIQUE (student.id_card)
UNIQUE (student.institutional_email)
UNIQUE (room.building, floor, room_number)
UNIQUE (room_equipment.room_id, equipment_type_id)
UNIQUE (computer.inventory_code)
UNIQUE (computer.qr_code)
UNIQUE (reservation.reservation_id)
UNIQUE (loan.reservation_id)

-- Índices de Claves Foráneas (automáticos en PostgreSQL)
FK INDEX (employee.role_id)
FK INDEX (employee.status_id)
FK INDEX (student.academic_status_id)
FK INDEX (room.status_id)
FK INDEX (room_equipment.room_id)
FK INDEX (room_equipment.equipment_type_id)
FK INDEX (computer.status_id)
FK INDEX (reservation.student_id)
FK INDEX (reservation.resource_type_id)
FK INDEX (reservation.room_id)
FK INDEX (reservation.computer_id)
FK INDEX (reservation.status_id)
FK INDEX (loan.student_id)
FK INDEX (loan.computer_id)
FK INDEX (loan.employee_registrant_id)
FK INDEX (loan.reservation_id)
FK INDEX (loan.status_id)
FK INDEX (fine.student_id)
FK INDEX (fine.loan_id)
FK INDEX (fine.status_id)
FK INDEX (audit.action_id)
FK INDEX (audit.employee_id)
FK INDEX (audit.student_id)

-- Índices de Búsqueda
INDEX (audit.date_time DESC)
INDEX (audit.affected_table)
INDEX (loan.student_id, loan.status_id)
INDEX (reservation.room_id, reservation.reservation_date)
INDEX (reservation.computer_id, reservation.reservation_date)
INDEX (fine.student_id, fine.status_id)
```

---

# VISTAS PRINCIPALES

Las siguientes vistas facilitan consultas comunes:

## V1: Préstamos Activos con Detalles

```sql
SELECT 
    l.loan_id,
    s.first_name || ' ' || s.last_name as student_name,
    c.brand || ' ' || c.model as computer,
    l.request_date,
    l.expected_return_date,
    ls.status_name as status,
    CASE WHEN l.expected_return_date < NOW() THEN 'VENCIDO' ELSE 'OK' END as alert
FROM loan l
JOIN student s ON l.student_id = s.student_id
JOIN computer c ON l.computer_id = c.computer_id
JOIN loan_status_type ls ON l.status_id = ls.status_id
WHERE ls.status_name IN ('ACTIVE', 'OVERDUE');
```

## V2: Multas Pendientes por Estudiante

```sql
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name as student_name,
    s.pending_fines as total_pending,
    COUNT(f.fine_id) as number_of_fines,
    MAX(f.generation_date) as most_recent_fine
FROM student s
JOIN fine f ON s.student_id = f.student_id
WHERE f.status_id = (SELECT status_id FROM fine_status_type WHERE status_name = 'PENDING')
GROUP BY s.student_id
ORDER BY s.pending_fines DESC;
```

## V3: Disponibilidad de Salas

```sql
SELECT 
    r.room_id,
    r.name,
    r.building || ' - Piso ' || r.floor || ' - Sala ' || r.room_number as location,
    r.max_capacity,
    rs.status_name as status,
    CASE WHEN rs.status_name = 'AVAILABLE' THEN 'Disponible Ahora' ELSE rs.description END as availability
FROM room r
JOIN room_status_type rs ON r.status_id = rs.status_id
ORDER BY r.building, r.floor, r.room_number;
```

## V4: Auditoría de Cambios Recientes

```sql
SELECT 
    a.audit_id,
    a.date_time,
    a.affected_table,
    aa.action_name,
    COALESCE(e.first_name || ' ' || e.last_name, st.first_name || ' ' || st.last_name) as user_name,
    a.user_role,
    a.previous_data,
    a.new_data
FROM audit a
JOIN audit_action_type aa ON a.action_id = aa.action_id
LEFT JOIN employee e ON a.employee_id = e.employee_id
LEFT JOIN student st ON a.student_id = st.student_id
ORDER BY a.date_time DESC
LIMIT 100;
```

---

# NOTAS DE IMPLEMENTACIÓN

## Convenciones de Códigos

### Estados de Computadora
- `AVAILABLE` - Disponible para préstamo inmediato
- `IN_LOAN` - Préstamo activo (sincronizado automáticamente)
- `MAINTENANCE` - En reparación
- `RETIRED` - Decommissionada (fin de vida)
- `DAMAGED` - Dañada, no segura para usar

### Estados de Préstamo
- `ACTIVE` - Préstamo vigente
- `RETURNED` - Computadora devuelta (cierre normal)
- `OVERDUE` - Retraso en devolución (trigger detección)
- `LOST` - Computadora perdida o no recuperada

### Estados de Reserva
- `ACTIVE` - Reserva confirmada y vigente
- `CANCELLED` - Cancelada por cualquier motivo
- `COMPLETED` - Completada (sala/equipo utilizado)
- `CONVERTED_TO_LOAN` - Reserva de equipo convertida a préstamo

### Estados de Multa
- `PENDING` - No pagada, impide nuevos préstamos
- `PAID` - Pagada, sin restricciones
- `WAIVED` - Exonerada por resolución del DTI
- `DISPUTED` - En reclamo del estudiante

## Reglas de Negocio

### Límites de Préstamo
- **Máxima duración**: 2 horas
- **Horario permitido**: 7:00 AM - 9:00 PM
- **Máximo por estudiante**: 1 préstamo activo simultáneamente
- **Cancelación automática**: 10 minutos sin inicio

### Límites de Reserva - Sala
- **Máxima duración**: 3 horas
- **Anticipación máxima**: 7 días calendario
- **Cancelación automática**: 30 minutos sin inicio
- **Conflictos**: Prohibida sobreposición horaria en misma sala

### Límites de Reserva - Computadora
- **Máxima duración**: 3 horas (aunque típicamente se usan los 2 horas de préstamo)
- **Anticipación**: Mismo día solamente
- **Conversión**: Reserva se convierte en préstamo si se concreta

### Multas
- **Cálculo**: 10,000 COP por hora completa de retraso
- **Aplicación**: Automática cuando préstamo se marca OVERDUE
- **Bloqueo**: Estudiante con multas pendientes no puede hacer nuevos préstamos
- **Waiver**: Solo por resolución del DTI

### Restricciones de Estudiante
- **Académicamente activo**: ACTIVE status necesario para préstamos
- **Sin multas pendientes**: Requerimiento previo para cualquier préstamo
- **Sin préstamos activos**: Máximo 1 simultáneamente
- **Desactivación**: Imposible si hay préstamos activos

### Restricciones de Empleado
- **Último administrador**: No puede desactivarse si es único admin activo
- **Roles fijos**: No se puede cambiar role de un empleado (requiere crear nuevo)

## Datos Sensibles

| Dato | Protección | Notas |
|------|-----------|-------|
| password_hash | Cifrado BCrypt | Never returned in queries |
| institutional_email | Visible a administradores | PII - Confidencial |
| id_card (cédula) | Visible solo a propietario | PII - Confidencial |
| phone | Visible solo a DTI | PII - Confidencial |
| previous_data en audit | Auditoría inmutable | Histórico completo |

## Consideraciones de Rendimiento

1. **Denormalización**: `student.pending_fines` es denormalizado (calculado una vez, actualizado por triggers) para evitar JOIN costoso
2. **Índices**: Todas las FK tienen índices automáticos; búsquedas por estado requieren índices separados
3. **Auditoría JSONB**: Columnas de datos anterior/nuevo permiten búsquedas sin desserializar
4. **Cascadas**: Eliminación en cascada solo en direcciones apropiadas (student → fine, nunca inverso)

## Mantenimiento

### Limpieza de Datos
```sql
-- Eliminar préstamos cancelados hace > 30 días
DELETE FROM loan WHERE status_id = (
    SELECT status_id FROM loan_status_type WHERE status_name = 'CANCELLED'
) AND updated_at < CURRENT_DATE - INTERVAL '30 days';

-- Archiva auditoría antigua (opcional)
-- Crear tabla audit_archive y migrar registros > 1 año
```

### Recálculo de Multas Pendientes
```sql
-- Recalcular en caso de inconsistencia
UPDATE student
SET pending_fines = (
    SELECT COALESCE(SUM(amount), 0)
    FROM fine
    WHERE student_id = student.student_id
    AND status_id = (SELECT status_id FROM fine_status_type WHERE status_name = 'PENDING')
)
WHERE student_id IN (
    SELECT DISTINCT student_id FROM fine WHERE status_name = 'PENDING'
);
```

---

## Información de Contacto

**Sistema**: CampusLend v1.0  
**Base de Datos**: PostgreSQL 12+  
**Zona Horaria**: UTC  
**Última Revisión**: 2025-01-16  
**Administrador**: DTI - Universidad Cooperativa de Colombia

---

