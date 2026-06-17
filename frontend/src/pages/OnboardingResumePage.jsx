import { useState, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../services/api'

const ALLOWED_TYPES = [
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
]

const UNLOCKS = [
  {
    title: 'AI Resume Analysis',
    desc: 'Your resume is scored and parsed for key signals instantly.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4">
        <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z" />
      </svg>
    ),
  },
  {
    title: 'Skill Gap Report',
    desc: 'See exactly what skills to build for your target role.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4">
        <path strokeLinecap="round" strokeLinejoin="round" d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 013 19.875v-6.75zM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V8.625zM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V4.125z" />
      </svg>
    ),
  },
  {
    title: 'Personalized Roadmap',
    desc: 'A week-by-week plan from where you are to where you want to be.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4">
        <path strokeLinecap="round" strokeLinejoin="round" d="M9 6.75V15m6-6v8.25m.503 3.498l4.875-2.437c.381-.19.622-.58.622-1.006V4.82c0-.836-.88-1.38-1.628-1.006l-3.869 1.934c-.317.159-.69.159-1.006 0L9.503 3.252a1.125 1.125 0 00-1.006 0L3.622 5.689C3.24 5.88 3 6.27 3 6.695V19.18c0 .836.88 1.38 1.628 1.006l3.869-1.934c.317-.159.69-.159 1.006 0l4.994 2.497c.317.158.69.158 1.006 0z" />
      </svg>
    ),
  },
  {
    title: 'ATS Optimization',
    desc: 'Beat applicant tracking systems at your target companies.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4">
        <path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z" />
      </svg>
    ),
  },
]

export default function OnboardingResumePage() {
  const navigate = useNavigate()
  const fileInputRef = useRef(null)
  const [file, setFile] = useState(null)
  const [isDragging, setIsDragging] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  function handleFileSelect(selected) {
    if (!selected) return
    setError('')
    if (!ALLOWED_TYPES.includes(selected.type)) {
      setError('Only PDF, DOC, or DOCX files are accepted.')
      return
    }
    if (selected.size > 5 * 1024 * 1024) {
      setError('File must be under 5 MB.')
      return
    }
    setFile(selected)
  }

  function handleDrop(e) {
    e.preventDefault()
    setIsDragging(false)
    handleFileSelect(e.dataTransfer.files[0])
  }

  async function handleSubmit(e) {
    e.preventDefault()
    if (!file) { setError('Please select a resume file.'); return }
    setError('')
    setLoading(true)
    try {
      const formData = new FormData()
      formData.append('file', file)
      await api.post('/api/onboarding/resume', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      })
      navigate('/assessment')
    } catch (err) {
      setError(err.response?.data?.error || 'Upload failed. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-neutral-950 flex items-center justify-center px-4 py-10 relative overflow-hidden">
      <div className="absolute -top-10 -left-10 w-40 h-40 rotate-12 opacity-60 [clip-path:polygon(50%_0%,0%_100%,100%_100%)] bg-gradient-to-br from-neutral-700 to-neutral-900" />
      <div className="absolute -bottom-16 -right-10 w-56 h-56 -rotate-12 opacity-60 [clip-path:polygon(50%_0%,0%_100%,100%_100%)] bg-gradient-to-br from-neutral-700 to-neutral-900" />

      <div className="relative w-full max-w-5xl grid grid-cols-1 md:grid-cols-2 bg-neutral-900/80 border border-neutral-800 rounded-3xl shadow-2xl overflow-hidden">
        {/* Left — upload */}
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
              <span className="w-6 h-6 rounded-full bg-emerald-500/30 border border-emerald-500/40 flex items-center justify-center">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className="w-3 h-3 text-emerald-400">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                </svg>
              </span>
              <span className="text-xs font-medium text-neutral-500">Profile</span>
            </div>
            <div className="flex-1 h-px bg-emerald-500/30 max-w-10" />
            <div className="flex items-center gap-2">
              <span className="w-6 h-6 rounded-full bg-emerald-500 flex items-center justify-center text-xs font-bold text-white">
                2
              </span>
              <span className="text-xs font-medium text-white">Resume</span>
            </div>
          </div>

          <h1 className="text-2xl font-semibold text-white mb-1">Upload your resume</h1>
          <p className="text-sm text-neutral-400 mb-6">
            Required to generate your skill gap report and career roadmap.
          </p>

          {error && (
            <div className="mb-4 rounded-lg bg-red-500/10 border border-red-500/30 px-4 py-3 text-sm text-red-400">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="flex flex-col gap-4 flex-1">
            {/* Drop zone */}
            <div
              onClick={() => fileInputRef.current?.click()}
              onDrop={handleDrop}
              onDragOver={(e) => { e.preventDefault(); setIsDragging(true) }}
              onDragLeave={() => setIsDragging(false)}
              className={`flex-1 min-h-48 flex flex-col items-center justify-center gap-3 rounded-2xl border-2 border-dashed px-6 py-10 cursor-pointer transition-all ${
                isDragging
                  ? 'border-emerald-500/60 bg-emerald-500/5'
                  : file
                  ? 'border-emerald-500/40 bg-emerald-500/5'
                  : 'border-neutral-700 bg-neutral-800/40 hover:border-neutral-600 hover:bg-neutral-800/60'
              }`}
            >
              <input
                ref={fileInputRef}
                type="file"
                accept=".pdf,.doc,.docx"
                className="hidden"
                onChange={(e) => handleFileSelect(e.target.files[0])}
              />

              {file ? (
                <>
                  <div className="w-12 h-12 rounded-xl bg-emerald-500/20 border border-emerald-500/30 flex items-center justify-center">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-6 h-6 text-emerald-400">
                      <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m2.25 0H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z" />
                    </svg>
                  </div>
                  <p className="text-sm font-medium text-white text-center break-all">{file.name}</p>
                  <p className="text-xs text-neutral-500">
                    {(file.size / 1024).toFixed(0)} KB · click to change
                  </p>
                </>
              ) : (
                <>
                  <div className="w-12 h-12 rounded-xl bg-neutral-700/50 border border-neutral-700 flex items-center justify-center">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-6 h-6 text-neutral-400">
                      <path strokeLinecap="round" strokeLinejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5" />
                    </svg>
                  </div>
                  <p className="text-sm text-neutral-300">
                    <span className="font-medium text-white">Click to upload</span> or drag and drop
                  </p>
                  <p className="text-xs text-neutral-500">PDF, DOC, DOCX · max 5 MB</p>
                </>
              )}
            </div>

            <button
              type="submit"
              disabled={loading || !file}
              className="w-full rounded-lg bg-white px-4 py-2.5 text-sm font-medium text-neutral-900 hover:bg-neutral-200 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2"
            >
              {loading ? (
                'Uploading…'
              ) : (
                <>
                  Complete Onboarding
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-4 h-4">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
                  </svg>
                </>
              )}
            </button>

            <button
              type="button"
              onClick={() => navigate('/onboarding')}
              className="text-xs text-neutral-500 hover:text-neutral-400 transition-colors text-center"
            >
              ← Back to profile
            </button>
          </form>
        </div>

        {/* Right — what gets unlocked */}
        <div className="hidden md:flex flex-col justify-center p-10 bg-neutral-900 gap-6">
          <div>
            <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest mb-2">
              What happens next
            </p>
            <p className="text-lg font-semibold text-white leading-snug">
              Your career intelligence<br />starts here
            </p>
          </div>

          <div className="space-y-5">
            {UNLOCKS.map(({ icon, title, desc }) => (
              <div key={title} className="flex gap-3 items-start">
                <div className="w-8 h-8 rounded-lg bg-emerald-500/20 border border-emerald-500/30 flex items-center justify-center flex-shrink-0 text-emerald-400">
                  {icon}
                </div>
                <div>
                  <p className="text-sm font-medium text-white">{title}</p>
                  <p className="text-xs text-neutral-500 mt-0.5">{desc}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="rounded-xl p-4 bg-emerald-500/5 border border-emerald-500/20 mt-2">
            <p className="text-xs text-emerald-400 font-medium">
              Resume stays private — never shared outside your account.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
