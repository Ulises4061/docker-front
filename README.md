# 🚀 Arquitectura de Microservicios con Docker Compose

## 📋 Descripción General

Este proyecto implementa una arquitectura de microservicios completa utilizando Docker Compose. La arquitectura integra un frontend web, una API REST intermedia y una base de datos PostgreSQL con persistencia de datos.

**Autor:** Ulises García
**Fecha:** Diciembre 2025

---

## 🎯 Objetivo

Diseñar e implementar una arquitectura de microservicios que demuestre:
- Funcionamiento de contenedores Docker
- Redes internas entre contenedores
- Volúmenes persistentes
- Dependencias entre servicios (depends_on)
- Comunicación CRUD entre componentes

---

## 🏗️ Arquitectura del Sistema

### Componentes Principales

```
┌─────────────────────────────────────────────────────────────┐
│                     Docker Network                           │
│                    (ulises_network)                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐  ┌──────────────────┐  ┌───────────┐  │
│  │   Frontend       │  │   Backend API    │  │ Database  │  │
│  │ (Port: 80)       │  │ (Port: 5000)     │  │(Port:5432)│  │
│  │                  │  │                  │  │           │  │
│  │ ulises-frontend  │  │ ulises-api       │  │ulises-db  │  │
│  │                  │  │                  │  │           │  │
│  │ HTML/JavaScript  │──│ Node.js/Express  │──│PostgreSQL │  │
│  │                  │  │                  │  │           │  │
│  └──────────────────┘  └──────────────────┘  └───────────┘  │
│         │                      │                    │         │
│         └──────────────────────┼────────────────────┘         │
│              Comunicación HTTP              Volumen Persistente
│              REST API                      (ulises_db_data)   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Flujo de Datos

```
1. Usuario accede a http://localhost (Frontend)
   ↓
2. Frontend carga index.html y JavaScript
   ↓
3. JavaScript realiza peticiones HTTP a http://localhost:5000
   ↓
4. API Backend recibe peticiones en Express
   ↓
5. Backend ejecuta consultas SQL en PostgreSQL
   ↓
6. Base de datos retorna datos
   ↓
7. API retorna respuesta JSON al Frontend
   ↓
8. Frontend renderiza datos en la página
```

---

## 📦 Servicios

### 1. **Frontend (ulises-frontend)**
- **Puerto:** 80
- **Imagen Base:** node:18-bullseye
- **Tecnología:** HTML5 + JavaScript
- **Características:**
  - Interfaz visual moderna con gradientes
  - Mostrar nombre "Ulises García"
  - Consumir API REST
  - Operaciones CRUD (Crear, Leer, Eliminar usuarios)
  - Verificación de estado de conexión
  - Actualización automática cada 30 segundos

**Dockerfile personalizado:**
- Usa node:18-bullseye como base
- Instala http-server para servir contenido estático
- No usa imágenes preconstruidas como nginx

### 2. **Backend API (ulises-api)**
- **Puerto:** 5000
- **Imagen Base:** node:18-bullseye
- **Framework:** Express.js
- **Base de Datos:** PostgreSQL

**Endpoints disponibles:**

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/health` | Verificar estado de la API |
| GET | `/garcia` | Retorna nombre completo: "Ulises García" |
| GET | `/api/users` | Obtener todos los usuarios |
| POST | `/api/users` | Crear nuevo usuario |
| PUT | `/api/users/:id` | Actualizar usuario |
| DELETE | `/api/users/:id` | Eliminar usuario |

**Variables de Entorno:**
```
DB_USER=ulises_user
DB_PASSWORD=secure_password_123
DB_HOST=ulises-db
DB_PORT=5432
DB_NAME=ulises_db
PORT=5000
```

### 3. **Base de Datos (ulises-db)**
- **Puerto:** 5432
- **Imagen:** postgres:15-alpine
- **Nombre de BD:** ulises_db
- **Usuario:** ulises_user
- **Volumen Persistente:** ulises_db_data

**Tabla de usuarios:**
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔧 Requisitos Previos

1. **Docker Desktop** instalado y ejecutándose
2. **Docker Compose** (incluido en Docker Desktop)
3. **Git** (opcional, para versionamiento)
4. Puerto 80, 5000 y 5432 disponibles

### Verificar instalación:
```powershell
docker --version
docker-compose --version
```

---

## 🚀 Instrucciones de Instalación y Ejecución

### 1. Clonar o descargar el proyecto

```powershell
# Si está en un repositorio Git
git clone https://github.com/ulisesgarcia/microservicios-docker.git
cd microservicios-docker

# O simplemente navegar a la carpeta del proyecto
cd c:\Users\Ulises\Downloads\alonocito
```

### 2. Construir y levantar los contenedores

```powershell
# Construir las imágenes y levantar los servicios
docker-compose up -d --build

# Verificar que los servicios están en ejecución
docker-compose ps
```

**Salida esperada:**
```
NAME                     COMMAND                  SERVICE             STATUS              PORTS
ulises-database          "docker-entrypoint.s…"   ulises-db           Up 30s              0.0.0.0:5432->5432/tcp
ulises-backend-api       "npm start"              ulises-api          Up 20s              0.0.0.0:5000->5000/tcp
ulises-web-frontend      "http-server -p 80 …"   ulises-frontend     Up 10s              0.0.0.0:80->80/tcp
```

### 3. Acceder a los servicios

- **Frontend:** http://localhost
- **API (Health Check):** http://localhost:5000/health
- **API (Endpoint Personal):** http://localhost:5000/garcia

### 4. Verificar conectividad

Desde PowerShell:
```powershell
# Probar API
curl http://localhost:5000/health

# Probar endpoint personal
curl http://localhost:5000/garcia

# Probar obtener usuarios
curl http://localhost:5000/api/users
```

---

## 📊 Estructura de Directorios

```
alonocito/
├── docker-compose.yml          # Orquestación de contenedores
├── .env                         # Variables de entorno
├── README.md                    # Este archivo
│
├── frontend/
│   ├── Dockerfile              # Imagen personalizada del frontend
│   ├── index.html              # Interfaz web
│   └── [Assets]
│
├── backend/
│   ├── Dockerfile              # Imagen personalizada del backend
│   ├── package.json            # Dependencias de Node.js
│   ├── server.js               # API Express
│   ├── .env                    # Variables de entorno del backend
│   └── node_modules/           # Dependencias instaladas
│
└── database/
    └── init.sql                # Script de inicialización SQL
```

---

## 🔄 Comunicación entre Contenedores

### Red Docker (ulises_network)

Los contenedores se comunican a través de la red `ulises_network` usando nombres de servicio:

1. **Frontend → Backend API:**
   ```javascript
   fetch('http://localhost:5000/api/users')
   // o desde dentro del contenedor:
   fetch('http://ulises-api:5000/api/users')
   ```

2. **Backend → Base de Datos:**
   ```javascript
   const pool = new Pool({
     host: 'ulises-db',  // Nombre del contenedor en la red
     port: 5432,
     user: 'ulises_user',
     password: 'secure_password_123',
     database: 'ulises_db'
   });
   ```

### Variables de Entorno

El archivo `.env` en la raíz del proyecto se carga automáticamente:
```env
DB_USER=ulises_user
DB_PASSWORD=secure_password_123
DB_NAME=ulises_db
```

---

## 💾 Persistencia de Datos

### Volumen Persistente

El volumen `ulises_db_data` almacena los datos de PostgreSQL:

```yaml
volumes:
  ulises_db_data:
    driver: local
```

**Verificar volumen:**
```powershell
docker volume ls
docker volume inspect alonocito_ulises_db_data
```

### Prueba de Persistencia

1. Agregar un usuario desde el frontend
2. Detener los contenedores:
   ```powershell
   docker-compose down
   ```
3. Reinicios los contenedores:
   ```powershell
   docker-compose up -d
   ```
4. Verificar que el usuario sigue existiendo en http://localhost

---

## 🧪 Pruebas Manuales

### Test 1: Verificar Conectividad

```powershell
# Probar API
curl http://localhost:5000/health
# Respuesta: {"status":"API funcionando","author":"Ulises García"}

# Probar endpoint personal
curl http://localhost:5000/garcia
# Respuesta: {"fullName":"Ulises García","message":"Endpoint del apellido García"}
```

### Test 2: CRUD de Usuarios

```powershell
# Crear usuario
$body = @{
    name = "Test User"
    email = "test@example.com"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:5000/api/users" `
  -Method POST `
  -Body $body `
  -ContentType "application/json"

# Obtener todos los usuarios
Invoke-WebRequest -Uri "http://localhost:5000/api/users" -Method GET
```

### Test 3: Frontend

1. Abrir http://localhost en el navegador
2. Verificar que se muestra "Ulises García"
3. Ver la lista de usuarios
4. Agregar un nuevo usuario
5. Verificar que aparece en la lista
6. Eliminar un usuario
7. Verificar que desaparece de la lista

---

## 🛠️ Administración de Contenedores

### Ver logs de los servicios

```powershell
# Logs de todos los servicios
docker-compose logs -f

# Logs de un servicio específico
docker-compose logs -f ulises-api
docker-compose logs -f ulises-db
docker-compose logs -f ulises-frontend
```

### Entrar en un contenedor

```powershell
# Acceder al contenedor de la API
docker exec -it ulises-backend-api sh

# Acceder a la base de datos
docker exec -it ulises-database psql -U ulises_user -d ulises_db
```

### Detener y reinicios

```powershell
# Detener todos los servicios
docker-compose stop

# Iniciar de nuevo
docker-compose start

# Reiniciar
docker-compose restart

# Detener y eliminar contenedores (mantiene volúmenes)
docker-compose down

# Eliminar todo incluido volúmenes
docker-compose down -v
```

### Reconstruir imágenes

```powershell
# Reconstruir sin caché
docker-compose build --no-cache

# Levantar con nuevas imágenes
docker-compose up -d
```

---

## 🔐 Seguridad

**IMPORTANTE:** Las credenciales en este proyecto son solo para desarrollo.

Para producción:
1. Usar variables de entorno seguros
2. Cambiar contraseñas por defecto
3. Implementar autenticación JWT
4. Usar HTTPS
5. Aplicar límites de recursos
6. Implementar health checks más robustos

---

## 📝 Dependencias

### Backend (Node.js)
- express: 4.18.2 - Framework web
- pg: 8.10.0 - Driver PostgreSQL
- cors: 2.8.5 - Manejo de CORS
- dotenv: 16.3.1 - Carga de variables de entorno

### Frontend
- HTML5
- JavaScript vanilla
- CSS3

### Base de Datos
- PostgreSQL 15 Alpine

---

## 🐛 Solución de Problemas

### Puerto 80 en uso

```powershell
# Encontrar proceso usando puerto 80
netstat -ano | findstr :80

# Cambiar puerto en docker-compose.yml
# Cambiar "80:80" por "8080:80"
```

### Conexión rechazada a la API

1. Verificar que los contenedores están corriendo:
   ```powershell
   docker-compose ps
   ```

2. Ver logs de la API:
   ```powershell
   docker-compose logs ulises-api
   ```

3. Verificar que CORS está habilitado en el backend

### Base de datos no inicializa

1. Verificar archivo `database/init.sql`
2. Ver logs de la BD:
   ```powershell
   docker-compose logs ulises-db
   ```

3. Reconstruir desde cero:
   ```powershell
   docker-compose down -v
   docker-compose up -d --build
   ```

---

## 📊 Métricas y Monitoreo

### Ver uso de recursos

```powershell
# Estadísticas de contenedores
docker stats

# Inspeccionar contenedor específico
docker inspect ulises-backend-api
```

---

## 🎓 Conceptos Aprendidos

Este proyecto demuestra:

1. **Contenedores Docker**
   - Construcción de imágenes personalizadas
   - Gestión del ciclo de vida de contenedores

2. **Docker Compose**
   - Orquestación de múltiples servicios
   - Dependencias entre servicios

3. **Networking**
   - Redes internas entre contenedores
   - Resolución de nombres (DNS)

4. **Volúmenes**
   - Persistencia de datos
   - Mapeo de volúmenes

5. **Arquitectura de Microservicios**
   - Separación de responsabilidades
   - Escalabilidad

6. **API REST**
   - Operaciones CRUD
   - Respuestas JSON

---

## 📚 Referencias

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Docker Hub](https://hub.docker.com/_/postgres)
- [Node.js Docker Hub](https://hub.docker.com/_/node)
- [Express.js Documentation](https://expressjs.com/)

---

## 🤝 Contribuciones

Este es un proyecto educativo. Para mejoras o correcciones, crear un fork del repositorio.

---

## 📄 Licencia

ISC

---

## 👤 Autor

**Ulises García**  
Diciembre 2025

---

## 🔗 Repositorio

[GitHub - Microservicios Docker](https://github.com/ulisesgarcia/microservicios-docker)

---

## ✅ Checklist de Verificación

- [x] Frontend implementado con HTML/JavaScript
- [x] Backend API con Node.js y Express
- [x] Base de datos PostgreSQL
- [x] Docker Compose con tres servicios
- [x] Redes internas configuradas
- [x] Volúmenes persistentes
- [x] Variables de entorno
- [x] Dockerfile personalizado para frontend
- [x] Dockerfile personalizado para backend
- [x] Comunicación entre servicios
- [x] Endpoint con apellido (/garcia)
- [x] Nombre visible en frontend
- [x] Nombre en base de datos
- [x] Documentación completa
- [x] Pruebas de persistencia
- [x] Diagramas de arquitectura
