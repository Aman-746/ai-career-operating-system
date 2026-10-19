<p align="center">
  <img src="https://readme-typing-svg.herokuapp.com/?font=Fira+Code&size=34&duration=4000&pause=1000&color=3B82F6&center=true&vCenter=true&width=900&lines=AI+Career+Operating+System;Full-Stack+AI+Career+Coach+Platform;Gemini+%B7+Spring+Boot+%B7+React+%B7+PostgreSQL" alt="Typing SVG" />
</p>

<p align="center">
  <a href="https://github.com/Aman-746/ai-career-operating-system/stargazers">
    <img src="https://img.shields.io/github/stars/Aman-746/ai-career-operating-system?style=for-the-badge&logo=github&color=FFD700&labelColor=111827" alt="Stars"/>
  </a>
  <a href="https://github.com/Aman-746/ai-career-operating-system/network/members">
    <img src="https://img.shields.io/github/forks/Aman-746/ai-career-operating-system?style=for-the-badge&logo=github&color=0E75B6&labelColor=111827" alt="Forks"/>
  </a>
  <a href="https://github.com/Aman-746/ai-career-operating-system/issues">
    <img src="https://img.shields.io/github/issues/Aman-746/ai-career-operating-system?style=for-the-badge&logo=github&color=EF4444&labelColor=111827" alt="Issues"/>
  </a>
  <a href="https://github.com/Aman-746/ai-career-operating-system/commits/main">
    <img src="https://img.shields.io/github/last-commit/Aman-746/ai-career-operating-system?style=for-the-badge&logo=github&color=10B981&labelColor=111827" alt="Last Commit"/>
  </a>
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/aman-kumar-41090a200/" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-aman--kumar--41090a200-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
  </a>
  <a href="mailto:aman04012000@gmail.com">
    <img src="https://img.shields.io/badge/Email-aman04012000@gmail.com-EA4335?style=for-the-badge&logo=gmail&logoColor=white" alt="Email"/>
  </a>
</p>

---

## 📖 Overview

**AI Career Operating System** is a full-stack, AI-powered career preparation platform that helps software engineers and freshers transition into product-based companies. It assesses user skills, identifies knowledge gaps, and generates personalized, week-by-week learning roadmaps using Google Gemini — all the way from skill assessment to interview readiness.

> 🎯 **Built for:** Students, freshers, and working professionals targeting SDE roles at product-based companies.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔐 **JWT Authentication** | Secure user registration & login with Spring Security & JWT |
| 📄 **Resume Upload & Analysis** | Upload PDF resumes and get AI-powered ATS analysis |
| 📊 **Adaptive Assessment** | Role-based skill assessment engine with timed sessions |
| 🧠 **AI Gap Analysis** | Google Gemini analyzes assessment results to identify weak areas |
| 🗺️ **Personalized Roadmaps** | AI-generated week-by-week study plans (e.g., 48-week plans) |
| 📈 **Progress Tracking** | Daily progress logging with AI-powered performance insights |
| 🎯 **Role-Based Onboarding** | Tailored onboarding flow based on target role & company |

---

## 🛠️ Tech Stack

| Layer | Technologies |
|-------|-------------|
| **Frontend** | <a href="https://reactjs.org/" target="_blank"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/react/react-original-wordmark.svg" width="24" height="24"/></a> React · <a href="https://vitejs.dev/" target="_blank"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/vitejs/vitejs-original.svg" width="24" height="24"/></a> Vite · <a href="https://tailwindcss.com/" target="_blank"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tailwindcss/tailwindcss-original.svg" width="24" height="24"/></a> Tailwind CSS · <a href="https://reactrouter.com/" target="_blank"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/reactrouter/reactrouter-original.svg" width="24" height="24"/></a> React Router · Axios |
| **Backend** | <a href="https://spring.io/projects/spring-boot" target="_blank"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/spring/spring-original-wordmark.svg" width="24" height="24"/></a> Spring Boot · <a href="https://spring.io/projects/spring-security" target="_blank"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/spring/spring-original.svg" width="24" height="24"/></a> Spring Security · Spring Data JPA · <a href="https://www.postgresql.org/" target="_blank"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original-wordmark.svg" width="24" height="24"/></a> PostgreSQL · JWT · Maven · Java 21 |
| **AI Service** | <a href="https://fastapi.tiangolo.com/" target="_blank"><img src="https://cdn.simpleicons.org/fastapi/009688" width="24" height="24"/></a> FastAPI · <a href="https://python.org" target="_blank"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg" width="24" height="24"/></a> Python · <a href="https://ai.google.dev/" target="_blank"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/google/google-original.svg" width="24" height="24"/></a> Google Gemini API · PyMuPDF · pdfplumber |

---

## 📁 Project Structure

```
ai-career-operating-system/
├── frontend/                 # React + Vite + Tailwind CSS frontend
│   ├── src/
│   │   ├── components/       # Reusable UI components
│   │   ├── pages/            # Page components (Dashboard, Roadmap, Assessment, etc.)
│   │   ├── context/          # Auth context
│   │   └── services/         # API service layer
│   ├── package.json
│   └── vercel.json           # Vercel deployment config
│
├── Backend/                  # Spring Boot backend (Java 21)
│   ├── src/main/java/com/aman/careeros/
│   │   ├── dto/              # Data Transfer Objects
│   │   ├── controller/       # REST controllers
│   │   ├── service/          # Business logic
│   │   ├── repository/       # Spring Data JPA repositories
│   │   └── entity/           # JPA entities
│   └── pom.xml
│
├── ai-service/               # Python FastAPI AI microservice
│   ├── main.py               # FastAPI entry point
│   ├── config.py             # Configuration
│   ├── schemas/              # Pydantic schemas
│   ├── routes/               # API routes (roadmap, gap-analysis, progress)
│   ├── services/             # AI service logic
│   └── requirements.txt
│
└── docs/                     # Documentation
```

---

## 🚀 Quick Start

### Prerequisites

- Java 21+
- Maven 3.8+
- Node.js 20+
- Python 3.11+
- PostgreSQL 15+

### 1. Clone the Repository

```bash
git clone https://github.com/Aman-746/ai-career-operating-system.git
cd ai-career-operating-system
```

### 2. Database Setup

```sql
CREATE DATABASE career_os;
```

### 3. Backend Configuration

Create `Backend/.env`:

```env
DB_URL=jdbc:postgresql://localhost:5432/career_os
DB_USERNAME=postgres
DB_PASSWORD=YOUR_PASSWORD

JWT_SECRET=YOUR_BASE64_ENCODED_SECRET

AI_SERVICE_URL=http://localhost:8000
```

**Update `Backend/src/main/resources/application.yml`:**

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

### 4. AI Service Setup

```bash
cd ai-service
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Create `ai-service/.env`:

```env
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

### 5. Start Backend

```bash
cd Backend
mvn spring-boot:run
# http://localhost:8080
```

### 6. Start Frontend

```bash
cd frontend
npm install
npm run dev
# http://localhost:5173
```

---

## 🔧 API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/auth/register` | User registration |
| `POST` | `/api/auth/login` | User login |

### Assessment
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/assessment/start` | Start a new assessment |
| `POST` | `/api/assessment/submit` | Submit answers |
| `GET` | `/api/assessment/result` | Get assessment results |

### Roadmap
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/roadmap/generate` | Generate AI roadmap |
| `GET` | `/api/roadmap/{id}` | Get roadmap details |

### Progress
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/progress/update` | Log daily progress |
| `GET` | `/api/progress/analytics` | Get progress analytics |

---

## 📸 Screenshots

<table>
  <tr>
    <td><b>Dashboard</b></td>
    <td><b>Roadmap</b></td>
  </tr>
  <tr>
    <td>Track your daily progress</td>
    <td>AI-generated learning plan</td>
  </tr>
</table>

---

## 🔮 Future Enhancements

- [ ] Interview Simulator with AI mock interviews
- [ ] Daily Coding Challenges
- [ ] Company-specific learning plans
- [ ] Progress Analytics dashboard
- [ ] Email notifications
- [ ] Docker containerization
- [ ] Cloud deployment (Vercel + Render + Railway)

---

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a pull request

---

## 📞 Contact

**Aman Kumar** — Full Stack Developer | AI Engineer

📧 aman04012000@gmail.com &nbsp;•&nbsp; 📱 +91-7462933412 &nbsp;•&nbsp; 🇮🇳 India  
🔗 [LinkedIn](https://www.linkedin.com/in/aman-kumar-41090a200/) &nbsp;•&nbsp; [GitHub](https://github.com/Aman-746)

---

<p align="center">
  <img src="https://komarev.com/ghpvc/?username=Aman-746&repo=ai-career-operating-system&label=Repo%20views&color=0e75b6&style=flat-square" alt="Repo views"/>
</p>
