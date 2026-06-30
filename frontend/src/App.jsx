import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from './context/AuthContext'
import ProtectedRoute from './components/ProtectedRoute'
import LoginPage from './pages/LoginPage'
import RegisterPage from './pages/RegisterPage'
import DashboardPage from './pages/DashboardPage'
import OnboardingPage from './pages/OnboardingPage'
import OnboardingResumePage from './pages/OnboardingResumePage'
import AssessmentPage from './pages/AssessmentPage'
import AssessmentQuizPage from './pages/AssessmentQuizPage'
import AssessmentResultPage from './pages/AssessmentResultPage'
import RoadmapPage from './pages/RoadmapPage'
import DailyUpdatePage from './pages/DailyUpdatePage'

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />
          <Route
            path="/onboarding"
            element={
              <ProtectedRoute>
                <OnboardingPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/onboarding/resume"
            element={
              <ProtectedRoute>
                <OnboardingResumePage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/assessment"
            element={
              <ProtectedRoute>
                <AssessmentPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/assessment/start"
            element={
              <ProtectedRoute>
                <AssessmentQuizPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/assessment/result/:sessionId"
            element={
              <ProtectedRoute>
                <AssessmentResultPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/roadmap"
            element={
              <ProtectedRoute>
                <RoadmapPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/daily-updates"
            element={
              <ProtectedRoute>
                <DailyUpdatePage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/dashboard"
            element={
              <ProtectedRoute>
                <DashboardPage />
              </ProtectedRoute>
            }
          />
          <Route path="*" element={<Navigate to="/login" replace />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  )
}
