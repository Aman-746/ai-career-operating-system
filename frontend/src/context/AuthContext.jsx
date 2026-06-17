import { createContext, useContext, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../services/api'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    const token = localStorage.getItem('token')
    const name = localStorage.getItem('name')
    const email = localStorage.getItem('email')
    return token ? { token, name, email } : null
  })

  const navigate = useNavigate()

  async function register(name, email, password) {
    const { data } = await api.post('/api/auth/register', { name, email, password })
    persist(data)
    await redirectAfterAuth()
  }

  async function login(email, password) {
    const { data } = await api.post('/api/auth/login', { email, password })
    persist(data)
    await redirectAfterAuth()
  }

  async function redirectAfterAuth() {
    try {
      const { data: status } = await api.get('/api/onboarding/status')
      console.log('[AuthContext] onboarding status:', status)
      navigate(status.completed ? '/dashboard' : '/onboarding')
    } catch (err) {
      console.error('[AuthContext] onboarding status check failed:', err?.response?.status, err?.response?.data ?? err?.message)
      navigate('/onboarding')
    }
  }

  function logout() {
    localStorage.removeItem('token')
    localStorage.removeItem('name')
    localStorage.removeItem('email')
    setUser(null)
    navigate('/login')
  }

  function persist({ token, name, email }) {
    localStorage.setItem('token', token)
    localStorage.setItem('name', name)
    localStorage.setItem('email', email)
    setUser({ token, name, email })
  }

  return (
    <AuthContext.Provider value={{ user, login, register, logout }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  return useContext(AuthContext)
}
