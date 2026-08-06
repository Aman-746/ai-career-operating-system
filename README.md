# AI Career Operating System

An AI-powered platform that helps software engineers prepare for product-based company interviews by assessing their skills, identifying gaps, and generating personalized learning roadmaps.

---

# Features

- User Registration & Login (JWT Authentication)
- Career Goal Onboarding
- Resume Upload
- AI Resume Analysis
- Skill Assessment
- AI Gap Analysis
- Personalized Learning Roadmap
- Progress Dashboard

---

# Tech Stack

## Frontend
- React
- Vite
- Tailwind CSS
- Axios
- React Router

## Backend
- Java 21
- Spring Boot
- Spring Security
- Spring Data JPA
- PostgreSQL
- JWT Authentication
- Maven

## AI Service
- Python
- FastAPI
- Google Gemini API
- PyMuPDF
- pdfplumber

---

# Project Structure

```
AI-Career-Operating-System
│
├── frontend/          # React Application
├── app/               # Spring Boot Backend
├── ai-service/        # FastAPI AI Service
└── README.md
```

---

# Prerequisites

Install the following:

- Java 21+
- Maven
- Node.js 20+
- Python 3.11+
- PostgreSQL 18

---

# Database Setup

Create a PostgreSQL database.

```sql
CREATE DATABASE career_os;
```

---

# Environment Variables

Create a `.env` file in the **backend (app)** directory.

```env
DB_URL=jdbc:postgresql://localhost:5432/career_os
DB_USERNAME=postgres
DB_PASSWORD=YOUR_POSTGRES_PASSWORD

JWT_SECRET=YOUR_BASE64_JWT_SECRET

AI_SERVICE_URL=http://localhost:8000
```

---

# Backend Configuration

`application.yml`

```yaml
spring:
  datasource:
    url: ${DB_URL}
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}

app:
  jwt:
    secret: ${JWT_SECRET}

  ai-service:
    base-url: ${AI_SERVICE_URL:http://localhost:8000}
```

---

# Running the Project

## Step 1 - Start PostgreSQL

Make sure PostgreSQL is running and the `career_os` database exists.

---

## Step 2 - Start AI Service

```bash
cd ai-service

python -m venv venv

source venv/bin/activate
```

Install dependencies

```bash
pip install -r requirements.txt
```

Run

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

AI Service

```
http://localhost:8000
```

---

## Step 3 - Start Backend

Open a new terminal.

```bash
cd AI-Career-Operating-System
```

Load environment variables

```bash
set -a
source .env
set +a
```

Run Spring Boot

```bash
mvn spring-boot:run
```

Backend

```
http://localhost:8080
```

---

## Step 4 - Start Frontend

Open another terminal.

```bash
cd frontend

npm install

npm run dev
```

Frontend

```
http://localhost:5173
```

---

# Application Startup Order

1. PostgreSQL
2. AI Service
3. Spring Boot Backend
4. React Frontend

---

# API URLs

Backend

```
http://localhost:8080
```

Frontend

```
http://localhost:5173
```

AI Service

```
http://localhost:5001
```

---

# Common Issues

## PostgreSQL Authentication Failed

Verify:

- PostgreSQL is running.
- `DB_USERNAME` and `DB_PASSWORD` are correct.
- `.env` is loaded before starting the backend.

---

## JWT Errors

If you encounter:

- Illegal Base64 character
- WeakKeyException
- SignatureException

Ensure:

- `JWT_SECRET` is a valid Base64-encoded key.
- Clear your browser's Local Storage after changing the JWT secret.
- Restart the backend.

---

## AI Service Connection Error

Verify:

- AI Service is running on port `5001`.
- `AI_SERVICE_URL` points to the correct port.

---

## Port Already in Use

Find the process:

```bash
lsof -i :5001
```

Terminate it:

```bash
kill -9 <PID>
```

---

# Future Enhancements

- Interview Simulator
- AI Mock Interviews
- Daily Coding Challenges
- Company-specific Learning Plans
- Progress Analytics
- Email Notifications
- Docker Deployment
- Cloud Deployment (Vercel + Render + Neon)

---

# Author

**Aman Kumar**

AI Career Operating System