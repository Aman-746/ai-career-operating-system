import { useAuth } from '../context/AuthContext'

export default function DashboardPage() {
  const { user, logout } = useAuth()

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
        <span className="text-base font-semibold text-gray-900">Career OS</span>
        <button
          onClick={logout}
          className="text-sm text-gray-500 hover:text-gray-700 transition-colors"
        >
          Sign out
        </button>
      </header>

      <main className="max-w-2xl mx-auto px-6 py-16 text-center">
        <h1 className="text-3xl font-semibold text-gray-900 mb-2">
          Welcome, {user?.name}
        </h1>
        <p className="text-gray-500 text-sm">
          Your dashboard is under construction. More features coming soon.
        </p>
      </main>
    </div>
  )
}
