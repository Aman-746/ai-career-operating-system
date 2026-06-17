import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import AuthLayout from '../components/AuthLayout'
import IconInput from '../components/IconInput'
import { MailIcon, LockIcon, UserIcon } from '../components/Icons'

export default function RegisterPage() {
  const { register } = useAuth()
  const [form, setForm] = useState({ name: '', email: '', password: '' })
  const [errors, setErrors] = useState({})
  const [loading, setLoading] = useState(false)

  function handleChange(e) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }))
  }

  async function handleSubmit(e) {
    e.preventDefault()
    setErrors({})
    setLoading(true)
    try {
      await register(form.name, form.email, form.password);
    } catch (err) {
      const data = err.response?.data
      if (data && typeof data === 'object' && !data.error) {
        setErrors(data)
      } else {
        setErrors({ _global: data?.error || 'Registration failed. Please try again.' })
      }
    } finally {
      setLoading(false)
    }
  }

  return (
    <AuthLayout
      title="Create an account"
      subtitle="Start building your career OS"
      footer={
        <>
          Already have an account?{' '}
          <Link to="/login" className="text-emerald-400 hover:text-emerald-300 font-medium">
            Sign in
          </Link>
        </>
      }
    >
      {errors._global && (
        <div className="mb-4 rounded-lg bg-red-500/10 border border-red-500/30 px-4 py-3 text-sm text-red-400">
          {errors._global}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-xs font-medium text-neutral-400 mb-1.5">Full name</label>
          <IconInput
            icon={<UserIcon />}
            type="text"
            name="name"
            value={form.name}
            onChange={handleChange}
            required
            placeholder="Jane Doe"
            error={errors.name}
          />
        </div>

        <div>
          <label className="block text-xs font-medium text-neutral-400 mb-1.5">Email</label>
          <IconInput
            icon={<MailIcon />}
            type="email"
            name="email"
            value={form.email}
            onChange={handleChange}
            required
            placeholder="you@example.com"
            error={errors.email}
          />
        </div>

        <div>
          <label className="block text-xs font-medium text-neutral-400 mb-1.5">Password</label>
          <IconInput
            icon={<LockIcon />}
            type="password"
            name="password"
            value={form.password}
            onChange={handleChange}
            required
            placeholder="Min. 6 characters"
            error={errors.password}
          />
        </div>

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-white px-4 py-2.5 text-sm font-medium text-neutral-900 hover:bg-neutral-200 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          {loading ? 'Creating account...' : 'Create account'}
        </button>
      </form>
    </AuthLayout>
  )
}
