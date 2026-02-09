# Pre- Screening Project - Documentation

## **1. Project Overview**

The **Todo Project** is a full-stack application with:

- **Backend:** Laravel (PHP 8.3, Composer, MySQL)
- **Frontend:** Vue.js (Vite)
- **Containerization:** Docker & Docker Compose
- **Purpose:** Manage Todo tasks with a clean frontend and robust backend API.

---

## **2. Prerequisites**

To run this project locally, you only need:

- Docker
- Docker Compose
- (Optional) WSL on Windows for smooth filesystem handling

**No need to install** Node.js, npm, PHP, or Composer locally — everything runs inside Docker.

---

## **3. Folder Structure**

```
.
├── todo-backend/# Laravel backend
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── app, config, routes, storage, bootstrap
│
├── todo-frontend/# Vue.js frontend
│   ├── Dockerfile
│   ├── package.json
│   └── src,public
│
└── DOC.doc# This documentation

```

---

## **4. Running the Project**

### **A. Backend (Laravel)**

1. Navigate to backend directory:

```
cd todo-backend

```

1. Build and start the container:

```
docker compose up -d--build

```

1. Container tasks:
- Installs PHP dependencies via Composer
- Sets correct permissions for `storage` and `bootstrap/cache`
- Starts PHP-FPM
1. Optional Laravel commands:

```
docker composeexec app sh
php artisan key:generate
php artisan migrate

```

**Backend API is now accessible on port 9000.**

---

### **B. Frontend (Vue.js)**

1. Navigate to frontend directory:

```
cd todo-frontend

```

1. Build the Docker image:

```
docker build -t todo-frontend-image .

```

1. Run the container:

```
docker run--name todo-frontend-container -p 8080:80 -d todo-frontend-image

```

1. Open browser at:

```
http://localhost:8080

```

**Vue frontend is now running and connected to backend API.**