import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../services/api'
import { BriefcaseIcon, BuildingIcon, ClockIcon, StarIcon } from '../components/Icons'

const ROLES = [
  'Software Engineer',
  'Frontend Engineer',
  'Backend Engineer',
  'Full Stack Engineer',
  'Mobile Engineer (iOS)',
  'Mobile Engineer (Android)',
  'DevOps / Platform Engineer',
  'ML / AI Engineer',
  'Data Scientist',
  'Data Engineer',
  'Product Manager',
  'Engineering Manager',
  'Tech Lead',
  'QA Engineer',
  'Security Engineer',
]

const TIMELINE_OPTIONS = [
  { value: 'ZERO_TO_THREE_MONTHS', label: '0 – 3 months' },
  { value: 'THREE_TO_SIX_MONTHS', label: '3 – 6 months' },
  { value: 'SIX_TO_TWELVE_MONTHS', label: '6 – 12 months' },
  { value: 'JUST_EXPLORING', label: 'Just exploring' },
]

const TIMELINE_LABELS = Object.fromEntries(TIMELINE_OPTIONS.map((o) => [o.value, o.label]))

function SelectField({ icon, options, value, onChange, name, placeholder }) {
  return (
    <div className="relative">
      <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-neutral-500 pointer-events-none">
        {icon}
      </span>
      <select
        name={name}
        value={value}
        onChange={onChange}
        className="w-full appearance-none rounded-lg bg-neutral-800/80 border border-neutral-700 pl-10 pr-8 py-2.5 text-sm text-white focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500/50 transition-colors"
      >
        <option value="" disabled className="text-neutral-500 bg-neutral-900">
          {placeholder}
        </option>
        {options.map((opt) =>
          typeof opt === 'string' ? (
            <option key={opt} value={opt} className="bg-neutral-900">
              {opt}
            </option>
          ) : (
            <option key={opt.value} value={opt.value} className="bg-neutral-900">
              {opt.label}
            </option>
          )
        )}
      </select>
      <span className="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none text-neutral-500">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-3.5 h-3.5">
          <path strokeLinecap="round" strokeLinejoin="round" d="M19 9l-7 7-7-7" />
        </svg>
      </span>
    </div>
  )
}

export default function OnboardingPage() {
  const navigate = useNavigate()
  const [form, setForm] = useState({
    currentRole: '',
    targetRole: '',
    targetCompany: '',
    timeline: '',
    yearsOfExperience: '',
  })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  function handleChange(e) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }))
  }

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await api.post('/api/onboarding/profile', {
        ...form,
        yearsOfExperience: Number(form.yearsOfExperience),
      })
      navigate('/onboarding/resume')
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to save profile. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  const isValid =
    form.currentRole && form.targetRole && form.timeline && form.yearsOfExperience !== ''

  const timelineLabel = TIMELINE_LABELS[form.timeline]

  return (
    <div className="min-h-screen bg-neutral-950 flex items-center justify-center px-4 py-10 relative overflow-hidden">
      <div className="absolute -top-10 -left-10 w-40 h-40 rotate-12 opacity-60 [clip-path:polygon(50%_0%,0%_100%,100%_100%)] bg-gradient-to-br from-neutral-700 to-neutral-900" />
      <div className="absolute -bottom-16 -right-10 w-56 h-56 -rotate-12 opacity-60 [clip-path:polygon(50%_0%,0%_100%,100%_100%)] bg-gradient-to-br from-neutral-700 to-neutral-900" />

      <div className="relative w-full max-w-5xl grid grid-cols-1 md:grid-cols-2 bg-neutral-900/80 border border-neutral-800 rounded-3xl shadow-2xl overflow-hidden">
        {/* Left — form */}
        <div className="p-8 md:p-10 flex flex-col">
          <div className="flex items-center gap-2 mb-6">
            <span className="w-8 h-8 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center">
              <span className="w-3 h-3 rounded-full bg-emerald-400" />
            </span>
            <span className="text-white font-semibold tracking-wide">Career OS</span>
          </div>

          {/* Step indicator */}
          <div className="flex items-center gap-3 mb-7">
            <div className="flex items-center gap-2">
              <span className="w-6 h-6 rounded-full bg-emerald-500 flex items-center justify-center text-xs font-bold text-white">
                1
              </span>
              <span className="text-xs font-medium text-white">Profile</span>
            </div>
            <div className="flex-1 h-px bg-neutral-700 max-w-10" />
            <div className="flex items-center gap-2">
              <span className="w-6 h-6 rounded-full bg-neutral-700 flex items-center justify-center text-xs font-bold text-neutral-500">
                2
              </span>
              <span className="text-xs font-medium text-neutral-500">Resume</span>
            </div>
          </div>

          <h1 className="text-2xl font-semibold text-white mb-1">Build your career profile</h1>
          <p className="text-sm text-neutral-400 mb-6">Tell us where you are and where you want to go.</p>

          {error && (
            <div className="mb-4 rounded-lg bg-red-500/10 border border-red-500/30 px-4 py-3 text-sm text-red-400">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4 flex-1 flex flex-col">
            <div className="space-y-4 flex-1">
              <div>
                <label className="block text-xs font-medium text-neutral-400 mb-1.5">Current Role</label>
                <SelectField
                  icon={<BriefcaseIcon />}
                  options={ROLES}
                  value={form.currentRole}
                  onChange={handleChange}
                  name="currentRole"
                  placeholder="Select your current role"
                />
              </div>

              <div>
                <label className="block text-xs font-medium text-neutral-400 mb-1.5">Target Role</label>
                <SelectField
                  icon={<BriefcaseIcon />}
                  options={ROLES}
                  value={form.targetRole}
                  onChange={handleChange}
                  name="targetRole"
                  placeholder="Select your target role"
                />
              </div>

              <div>
                <label className="block text-xs font-medium text-neutral-400 mb-1.5">
                  Target Company{' '}
                  <span className="text-neutral-600 font-normal">(optional)</span>
                </label>
                <div className="relative">
                  <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-neutral-500 pointer-events-none">
                    <BuildingIcon />
                  </span>
                  <input
                    type="text"
                    name="targetCompany"
                    value={form.targetCompany}
                    onChange={handleChange}
                    placeholder="e.g. Google, Stripe…"
                    className="w-full rounded-lg bg-neutral-800/80 border border-neutral-700 pl-10 pr-3 py-2.5 text-sm text-white placeholder-neutral-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500/50 transition-colors"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-medium text-neutral-400 mb-1.5">Timeline</label>
                  <SelectField
                    icon={<ClockIcon />}
                    options={TIMELINE_OPTIONS}
                    value={form.timeline}
                    onChange={handleChange}
                    name="timeline"
                    placeholder="Select timeline"
                  />
                </div>
                <div>
                  <label className="block text-xs font-medium text-neutral-400 mb-1.5">
                    Years of Experience
                  </label>
                  <div className="relative">
                    <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-neutral-500 pointer-events-none">
                      <StarIcon />
                    </span>
                    <input
                      type="number"
                      name="yearsOfExperience"
                      value={form.yearsOfExperience}
                      onChange={handleChange}
                      min="0"
                      max="50"
                      placeholder="0"
                      required
                      className="w-full rounded-lg bg-neutral-800/80 border border-neutral-700 pl-10 pr-3 py-2.5 text-sm text-white placeholder-neutral-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500/50 transition-colors"
                    />
                  </div>
                </div>
              </div>
            </div>

            <button
              type="submit"
              disabled={loading || !isValid}
              className="w-full rounded-lg bg-white px-4 py-2.5 text-sm font-medium text-neutral-900 hover:bg-neutral-200 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2"
            >
              {loading ? (
                'Saving…'
              ) : (
                <>
                  Continue
                  <svg
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    className="w-4 h-4"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                    />
                  </svg>
                </>
              )}
            </button>
          </form>
        </div>

        {/* Right — live career preview */}
        <div className="hidden md:flex flex-col items-center justify-center p-10 bg-neutral-900 gap-5">
          <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest self-start">
            Career Preview
          </p>

          <div className="w-full space-y-3">
            <div className="rounded-xl p-4 bg-neutral-800 border border-neutral-700/60">
              <p className="text-xs text-neutral-500 mb-1">Now</p>
              <p className="text-sm font-semibold text-white">
                {form.currentRole || (
                  <span className="text-neutral-600">Your current role</span>
                )}
              </p>
            </div>

            <div className="flex justify-center">
              <div className="flex flex-col items-center gap-1">
                <div className="w-px h-4 bg-neutral-700" />
                <div className="w-7 h-7 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center text-emerald-400 text-xs font-bold">
                  →
                </div>
                <div className="w-px h-4 bg-neutral-700" />
              </div>
            </div>

            <div className="rounded-xl p-4 bg-emerald-500/10 border border-emerald-500/20">
              <p className="text-xs text-emerald-500 mb-1">Target</p>
              <p className="text-sm font-semibold text-white">
                {form.targetRole || (
                  <span className="text-neutral-600">Your target role</span>
                )}
              </p>
            </div>
          </div>

          <div className="w-full grid grid-cols-2 gap-3">
            <div className="rounded-lg p-3 bg-neutral-800 border border-neutral-700/50">
              <p className="text-xs text-neutral-500 mb-1">Timeline</p>
              <p className="text-sm text-white font-medium">{timelineLabel || '—'}</p>
            </div>
            <div className="rounded-lg p-3 bg-neutral-800 border border-neutral-700/50">
              <p className="text-xs text-neutral-500 mb-1">Experience</p>
              <p className="text-sm text-white font-medium">
                {form.yearsOfExperience !== ''
                  ? `${form.yearsOfExperience} yr${form.yearsOfExperience == 1 ? '' : 's'}`
                  : '—'}
              </p>
            </div>
          </div>

          {form.targetCompany && (
            <div className="w-full rounded-lg p-3 bg-neutral-800 border border-neutral-700/50">
              <p className="text-xs text-neutral-500 mb-1">Target Company</p>
              <p className="text-sm text-white font-medium">{form.targetCompany}</p>
            </div>
          )}

          {!form.targetCompany && (
            <div className="w-full rounded-lg p-3 bg-neutral-800/40 border border-neutral-700/30">
              <p className="text-xs text-neutral-600 mb-1">Target Company</p>
              <p className="text-sm text-neutral-600">—</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
