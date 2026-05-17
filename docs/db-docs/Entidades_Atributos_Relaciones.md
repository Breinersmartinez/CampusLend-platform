# ENTIDADES, ATRIBUTOS Y RELACIONES - CampusLend

## 1. ENTIDADES Y SUS ATRIBUTOS

### 1.1 EMPLEADO (Entidad)
**Descripción:** Representa al personal del Departamento de Tecnología de la Información (DTI) que gestiona el sistema.

**Atributos:**
- ID_Empleado (PK) - Identificador único
- Numero_Identificacion - Documento de identidad
- Nombre_Completo - Nombre del empleado
- Correo_Institucional - Email (@ucc.edu.co)
- Contraseña_Cifrada - Contraseña encriptada
- Rol_Cargo - Rol/Cargo (Administrador, Personal DTI)
- Departamento - Área de trabajo
- Numero_Telefono - Contacto telefónico
- Estado_Empleado - (Activo/Inactivo)
- Fecha_Ingreso - Fecha de entrada al sistema
- Fecha_Actualizacion - Última modificación

---

### 1.2 ESTUDIANTE (Entidad)
**Descripción:** Representa a los estudiantes de la Universidad Cooperativa de Colombia que utilizan el sistema.

**Atributos:**
- ID_Estudiante (PK) - Identificador único
- Numero_Identificacion - Documento de identidad
- Nombre_Completo - Nombre del estudiante
- Correo_Institucional - Email (@campusucc.edu.co)
- Contraseña_Cifrada - Contraseña encriptada
- Programa_Academico - Carrera o programa
- Semestre - Semestre actual
- Estado_Academico - (Activo/Inactivo)
- Multas_Totales_Pendientes - Monto de multas por pendientes
- Fecha_Registro - Fecha de creación del registro
- Fecha_Actualizacion - Última modificación

---

### 1.3 SALA (Entidad)
**Descripción:** Representa las salas de estudio o trabajo disponibles en la universidad.

**Atributos:**
- ID_Sala (PK) - Identificador único
- Nombre_Sala - Nombre descriptivo
- Ubicacion_Torre - Torre donde está ubicada
- Ubicacion_Piso - Piso de la sala
- Ubicacion_Numero - Número de la sala
- Capacidad_Maxima - Número máximo de personas
- Equipamiento - (Proyector, tablero, computadores, etc.)
- Horario_Inicio - Hora de disponibilidad inicial
- Horario_Fin - Hora de disponibilidad final
- Estado_Sala - (Disponible/Mantenimiento/Inactivo)
- Responsable - Empleado responsable (FK)
- Fecha_Registro - Fecha de creación
- Fecha_Actualizacion - Última modificación

---

### 1.4 COMPUTADORA (Entidad)
**Descripción:** Representa los equipos de cómputo disponibles para préstamo.

**Atributos:**
- ID_Computadora (PK) - Identificador único
- Modelo_Marca - Modelo y marca del equipo
- Procesador - Tipo de procesador
- RAM - Memoria RAM
- Almacenamiento - Capacidad de almacenamiento
- Estado_Computadora - (Disponible/En Préstamo/Mantenimiento/Inactivo)
- Fecha_Adquisicion - Fecha de compra
- Ubicacion_Actual - Ubicación física actual
- Observaciones_Mantenimiento - Notas de mantenimiento
- Fecha_Registro - Fecha de creación
- Fecha_Actualizacion - Última modificación

---

### 1.5 PRÉSTAMO (Entidad)
**Descripción:** Representa el préstamo de computadoras de un estudiante.

**Atributos:**
- ID_Prestamo (PK) - Identificador único
- ID_Estudiante (FK) - Estudiante solicitante
- ID_Computadora (FK) - Equipo prestado
- Fecha_Solicitud - Fecha de solicitud
- Hora_Inicio_Programada - Hora inicial del préstamo
- Hora_Finalizacion_Programada - Hora final del préstamo
- Hora_Inicio_Real - Hora real de inicio
- Hora_Finalizacion_Real - Hora real de devolución
- Estado_Prestamo - (Pendiente de Inicio, Aprobado, Activo, Finalizado, Cancelado)
- Observaciones_Devolucion - Notas al devolver
- Estado_Equipo_Devolucion - Condición del equipo
- Empleado_Responsable (FK) - Empleado que gestiona
- Fecha_Actualizacion - Última modificación

---

### 1.6 RESERVA (Entidad)
**Descripción:** Representa la reserva de una sala de estudio o trabajo.

**Atributos:**
- ID_Reserva (PK) - Identificador único
- ID_Sala (FK) - Sala reservada
- ID_Estudiante (FK) - Estudiante solicitante
- Fecha_Solicitud - Fecha de solicitud
- Fecha_Reserva - Fecha de la reserva
- Hora_Inicio_Programada - Hora inicial
- Hora_Finalizacion_Programada - Hora final
- Hora_Inicio_Real - Hora real de inicio
- Hora_Finalizacion_Real - Hora real de finalización
- Tipo_Actividad - Tipo de uso (estudio, trabajo, etc.)
- Estado_Reserva - (Pendiente de Aprobación, Aprobado, Activo, Finalizado, Rechazado)
- Observaciones - Notas adicionales
- Empleado_Responsable (FK) - Empleado que aprueba
- Fecha_Actualizacion - Última modificación

---

### 1.7 AUDITORIA (Entidad)
**Descripción:** Registro de todas las operaciones críticas del sistema.

**Atributos:**
- ID_Auditoria (PK) - Identificador único
- ID_Usuario (FK) - Usuario que realizó la acción
- Tipo_Operacion - Tipo de operación realizada
- Tabla_Afectada - Tabla modificada
- ID_Registro_Afectado - Registro modificado
- Cambios_Realizados - Descripción de cambios
- Fecha_Operacion - Fecha y hora de la operación
- Direccion_IP - IP del usuario

---

## 2. RELACIONES ENTRE ENTIDADES

### 2.1 Relaciones Principales

| Relación | Tipo | Descripción |
|----------|------|-------------|
| **EMPLEADO** - **SALA** | 1:N | Un empleado puede ser responsable de varias salas |
| **EMPLEADO** - **PRESTAMO** | 1:N | Un empleado gestiona varios préstamos |
| **EMPLEADO** - **RESERVA** | 1:N | Un empleado aprueba varias reservas |
| **ESTUDIANTE** - **PRESTAMO** | 1:N | Un estudiante realiza varios préstamos |
| **ESTUDIANTE** - **RESERVA** | 1:N | Un estudiante realiza varias reservas |
| **COMPUTADORA** - **PRESTAMO** | 1:N | Una computadora puede ser prestada múltiples veces |
| **SALA** - **RESERVA** | 1:N | Una sala puede ser reservada múltiples veces |
| **USUARIO** (Empleado/Estudiante) - **AUDITORIA** | 1:N | Un usuario genera múltiples registros de auditoría |

---

## 3. MATRIZ DE RELACIONES

```
                    EMPLEADO
                   /   |   \
                  /    |    \
            PRESTAMO  SALA  RESERVA
              / \       |      / \
             /   \      |     /   \
        ESTUDIANTE  COMPUTADORA ESTUDIANTE
```

---

## 4. CARDINALIDADES Y RESTRICCIONES

### ESTUDIANTE - PRÉSTAMO
- **Cardinalidad:** 1:N (Un estudiante puede tener múltiples préstamos)
- **Restricción:** Un estudiante NO puede tener más de 1 préstamo activo simultáneamente

### ESTUDIANTE - RESERVA
- **Cardinalidad:** 1:N (Un estudiante puede hacer múltiples reservas)
- **Restricción:** Reservas solo hasta 7 días de anticipación

### COMPUTADORA - PRÉSTAMO
- **Cardinalidad:** 1:N (Una computadora puede ser prestada múltiples veces)
- **Restricción:** Solo 1 préstamo activo por computadora

### SALA - RESERVA
- **Cardinalidad:** 1:N (Una sala puede tener múltiples reservas)
- **Restricción:** No puede haber solapamientos de horarios

### EMPLEADO - RESPONSABLE
- **Cardinalidad:** 1:N (Un empleado gestiona múltiples operaciones)
- **Restricción:** Solo personal DTI puede gestionar

---

## 5. DOMINIOS DE VALORES

### Estados de Empleado
- Activo
- Inactivo

### Estados de Estudiante
- Activo
- Inactivo

### Estados de Sala
- Disponible
- Mantenimiento
- Inactivo

### Estados de Computadora
- Disponible
- En Préstamo
- Mantenimiento
- Inactivo

### Estados de Préstamo
- Pendiente de Inicio
- Aprobado
- Activo
- Finalizado
- Cancelado (por inasistencia)

### Estados de Reserva
- Pendiente de Aprobación
- Aprobado
- Activo
- Finalizado
- Rechazado

### Roles de Usuario
- Administrador
- Personal DTI
- Estudiante

---

## 6. REGLAS DE INTEGRIDAD REFERENCIAL

1. **Préstamo:** Al eliminar un estudiante, sus préstamos se deben marcar como históricos (no eliminar)
2. **Reserva:** Al desactivar una sala, se deben notificar los estudiantes con reservas pendientes
3. **Computadora:** Al desactivar una computadora, se valida que no tenga préstamos activos
4. **Auditoría:** Todos los cambios deben registrarse con referencia al usuario y timestamp
5. **Cascada:** No se permite eliminación de registros, solo cambio de estado a Inactivo

---

## 7. IDENTIFICADORES ÚNICOS

| Entidad | Identificador Único |
|---------|-------------------|
| EMPLEADO | ID_Empleado, Numero_Identificacion, Correo_Institucional |
| ESTUDIANTE | ID_Estudiante, Numero_Identificacion, Correo_Institucional |
| SALA | ID_Sala, Ubicacion (Torre+Piso+Numero) |
| COMPUTADORA | ID_Computadora |
| PRÉSTAMO | ID_Prestamo |
| RESERVA | ID_Reserva |
| AUDITORIA | ID_Auditoria |

---

## 8. CLAVES FORÁNEAS (FK)

| Tabla Hijo | FK | Tabla Padre | PK Padre |
|-----------|----|-----------  |----------|
| PRESTAMO | ID_Estudiante | ESTUDIANTE | ID_Estudiante |
| PRESTAMO | ID_Computadora | COMPUTADORA | ID_Computadora |
| PRESTAMO | Empleado_Responsable | EMPLEADO | ID_Empleado |
| RESERVA | ID_Sala | SALA | ID_Sala |
| RESERVA | ID_Estudiante | ESTUDIANTE | ID_Estudiante |
| RESERVA | Empleado_Responsable | EMPLEADO | ID_Empleado |
| SALA | Responsable | EMPLEADO | ID_Empleado |
| AUDITORIA | ID_Usuario | EMPLEADO/ESTUDIANTE | ID_Empleado/ID_Estudiante |

