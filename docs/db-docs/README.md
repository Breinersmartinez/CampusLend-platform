# E-commerce API

Este repositorio contiene una API para gestionar un sistema prestamos universitario de computadores portatiles y salas. La aplicación está desarrollada en
**Java** utilizando **Spring Boot**, con un enfoque en las buenas prácticas de desarrollo, incluyendo principios de
arquitectura limpia y patrones de diseño.

## Características

- Gestión de usuarios y autenticación.
- Documentación de la API con **OpenAPI (Swagger)**.
- Trazas, logs y métricas implementadas con el **Grafana Stack** (Grafana, Loki y Prometheus).
- Arquitectura hexagonal para una mejor separación de responsabilidades.
- Autenticación basada en **JWT** (JSON Web Tokens).
- Pipeline (canal) de integración continua configurado con **GitHub Actions**.

## Tecnologías utilizadas

- **Java 17**
- **Spring Boot 3**
- **Spring Security** para la autenticación y autorización.
- **JPA/Hibernate** para la interacción con la base de datos.
- **Postgres** como base de datos relacional.
- **OpenAPI** para la documentación de la API.
- **JUnit** y **Mockito** para pruebas unitarias.
- **Docker** para la contenedorización de la aplicación.
- **Grafana Stack** (Grafana, Loki, Prometheus) para monitoreo y observabilidad.
- **GitHub Actions** para integración continua.

## Requisitos previos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- **Java 17** o superior.
- **Maven** para la gestión de dependencias.
- **Docker** (opcional, para despliegue con contenedores).
- **PostgresSQL** (si no usas Docker para la base de datos).

## Instalación y configuración

1. Clona este repositorio:

   ```bash
   git clone 
   cd 
   ```

2. Configura las variables de entorno en el archivo `application.yml` o `application.properties` para conectar la base
   de datos:

   ```yaml
   spring:
     datasource:
       url: jdbc:mysql://localhost:3306/spring
       username: root
       password: password
     jpa:
       hibernate:
         ddl-auto: update
   ```

3. Configura el stack de observabilidad (Grafana, Loki, Prometheus) utilizando Docker Compose o la herramienta de tu
   preferencia. Asegúrate de enlazar los servicios correctamente.

4. Compila el proyecto con Maven:

   ```bash
   mvn clean install
   ```

5. Ejecuta la aplicación:

   ```bash
   mvn spring-boot:run
   ```

6. Accede a la documentación de la API
   en [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html).

## Uso

### Endpoints principales

- **Usuarios**:
    - Registro de usuarios: `POST /api/v1/users/register`
    - Login: `POST /api/v1/users/login`

## Pruebas

Para ejecutar las pruebas unitarias:

```bash
mvn test
```

## Despliegue con Docker

1. Construye la imagen de Docker:

   ```bash
   docker build -t CampusLend .
   ```

2. Ejecuta el contenedor:

   ```bash
   docker run -p 8080:8080 CampusLend
   ```

3. Asegúrate de tener un contenedor o instancia de Postgres corriendo con la base de datos configurada.

4. Despliega el stack de observabilidad con Grafana, Loki y Prometheus para habilitar monitoreo y trazabilidad.

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más información.

---