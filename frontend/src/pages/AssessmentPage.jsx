import { useState, useEffect, useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../services/api'

const DIFFICULTY_LABELS = {
  JUNIOR: 'Foundational',
  MID: 'Intermediate',
  SENIOR: 'Advanced',
  STAFF: 'Expert',
}

const UNLOCKS = [
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
    title: 'Resume Score',
    desc: 'Know where your resume stands against your target role.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4">
        <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09z" />
      </svg>
    ),
  },
  {
    title: 'Mock Interview Prep',
    desc: 'Practice real interviews tailored to your target company.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4">
        <path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z" />
      </svg>
    ),
  },
]

export default function AssessmentPage() {
  const navigate = useNavigate()
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  const fetchIntro = useCallback(() => {
    setLoading(true)
    setError(null)
    api
      .get('/api/assessment/intro')
      .then((res) => setData(res.data))
      .catch((err) => {
        const msg = err.response?.data?.error ?? ''
        if (err.response?.status === 404 && msg.toLowerCase().includes('profile')) {
          setError('profile_missing')
        } else if (err.response?.status === 404) {
          setError('resume_missing')
        } else {
          setError('generic')
        }
      })
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => {
    fetchIntro()
  }, [fetchIntro])

  return (
    <div className="min-h-screen bg-neutral-950">
      <div className="max-w-7xl mx-auto px-6 py-8">
        <div className="flex items-center gap-2 mb-6">
          <span className="w-8 h-8 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center">
            <span className="w-3 h-3 rounded-full bg-emerald-400" />
          </span>
          <span className="text-white font-semibold tracking-wide">Career OS</span>
        </div>

        {loading ? (
          <div className="max-w-lg mx-auto"><LoadingSkeleton /></div>
        ) : error ? (
          <div className="max-w-lg mx-auto"><ErrorState error={error} navigate={navigate} onRetry={fetchIntro} /></div>
        ) : (
          <PageContent data={data} navigate={navigate} />
        )}
      </div>
    </div>
  )
}

function LoadingSkeleton() {
  return (
    <div className="flex flex-col gap-5">
      <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
        <div className="flex gap-2">
          <Skeleton className="h-6 w-36 rounded-full" />
          <Skeleton className="h-6 w-32 rounded-full" />
        </div>
        <Skeleton className="h-7 w-56" />
        <Skeleton className="h-4 w-48" />
        <div className="flex gap-2">
          <Skeleton className="h-6 w-32 rounded-lg" />
          <Skeleton className="h-6 w-4" />
          <Skeleton className="h-6 w-32 rounded-lg" />
        </div>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Skeleton className="h-64 rounded-2xl" />
        <Skeleton className="h-64 rounded-2xl" />
      </div>
      <Skeleton className="h-52 rounded-2xl" />
      <Skeleton className="h-20 rounded-2xl" />
    </div>
  )
}

function ErrorState({ error, navigate, onRetry }) {
  const configs = {
    profile_missing: {
      text: 'Please complete your profile before accessing the assessment.',
      actionLabel: 'Go to Profile',
      onAction: () => navigate('/onboarding'),
    },
    resume_missing: {
      text: 'Please upload your resume before accessing the assessment.',
      actionLabel: 'Upload Resume',
      onAction: () => navigate('/onboarding/resume'),
    },
    generic: {
      text: 'Something went wrong. Please try again.',
      actionLabel: 'Retry',
      onAction: onRetry,
    },
  }

  const { text, actionLabel, onAction } = configs[error] ?? configs.generic

  return (
    <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
      <div className="rounded-lg bg-red-500/10 border border-red-500/30 px-4 py-3 text-sm text-red-400">
        {text}
      </div>
      <button
        onClick={onAction}
        className="w-full rounded-lg bg-white px-4 py-2.5 text-sm font-medium text-neutral-900 hover:bg-neutral-200 transition-colors"
      >
        {actionLabel}
      </button>
    </div>
  )
}

function PageContent({ data, navigate }) {
  const {
    userName,
    currentRole,
    targetRole,
    targetCompany,
    yearsOfExperience,
    detectedSkills,
    experienceLevel,
    assessmentConfig,
    completedSessionId,
  } = data

  const { topics, questionCount, estimatedMinutes, difficultyLevel } = assessmentConfig
  const difficultyLabel = DIFFICULTY_LABELS[difficultyLevel] ?? difficultyLevel
  const experienceLevelLabel =
    experienceLevel
      ? experienceLevel.charAt(0) + experienceLevel.slice(1).toLowerCase()
      : null

  return (
    <div className="grid grid-cols-1 lg:grid-cols-5 gap-6 items-start">

      {/* ── Left: hero + CTA (sticky) ── */}
      <div className="lg:col-span-2 flex flex-col gap-4 lg:sticky lg:top-6">
        {/* Hero */}
        <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
          <div className="flex flex-wrap gap-2">
            <span className="inline-flex items-center gap-1.5 bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-medium rounded-full px-3 py-1">
              <CheckIcon />
              Resume uploaded
            </span>
            <span className="inline-flex items-center gap-1.5 bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-medium rounded-full px-3 py-1">
              <CheckIcon />
              Resume analyzed
            </span>
          </div>

          <div>
            <h1 className="text-2xl font-semibold text-white">You're all set, {userName}.</h1>
            <p className="text-sm text-neutral-400 mt-1">Your personalized assessment is ready.</p>
          </div>

          <div className="flex flex-wrap items-center gap-2">
            <span className="bg-neutral-800 border border-neutral-700 text-white text-xs rounded-lg px-2.5 py-1">
              {currentRole}
            </span>
            <span className="text-neutral-600 text-sm">→</span>
            <span className="bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs rounded-lg px-2.5 py-1">
              {targetRole}
            </span>
            {targetCompany && (
              <span className="text-neutral-500 text-xs">@ {targetCompany}</span>
            )}
          </div>
        </section>

        {/* CTA */}
        <section className="flex flex-col gap-3">
          {completedSessionId ? (
            <>
              <div className="flex items-center gap-3 rounded-xl bg-emerald-500/10 border border-emerald-500/20 px-4 py-3">
                <span className="w-5 h-5 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center flex-shrink-0">
                  <CheckIcon className="w-2.5 h-2.5 text-emerald-400" />
                </span>
                <p className="text-sm text-emerald-300 font-medium">Assessment already completed</p>
              </div>
              <button
                onClick={() => navigate(`/assessment/result/${completedSessionId}`)}
                className="w-full rounded-lg bg-white px-4 py-3 text-sm font-medium text-neutral-900 hover:bg-neutral-200 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 transition-colors flex items-center justify-center gap-2"
              >
                View my results
                <ArrowRightIcon />
              </button>
              <button
                onClick={() => navigate('/roadmap')}
                className="w-full rounded-lg border border-neutral-700 px-4 py-2.5 text-sm font-medium text-neutral-400 hover:text-white hover:border-neutral-600 transition-colors"
              >
                Go to my roadmap
              </button>
            </>
          ) : (
            <>
              <button
                onClick={() => navigate('/assessment/start')}
                className="w-full rounded-lg bg-white px-4 py-3 text-sm font-medium text-neutral-900 hover:bg-neutral-200 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 transition-colors flex items-center justify-center gap-2"
              >
                Start Assessment
                <ArrowRightIcon />
              </button>
              <div className="flex items-center justify-center gap-4">
                <button
                  onClick={() => navigate('/onboarding')}
                  className="text-xs text-neutral-500 hover:text-neutral-400 transition-colors"
                >
                  Edit Profile
                </button>
                <span className="text-neutral-700 text-xs">|</span>
                <button
                  onClick={() => navigate('/onboarding/resume')}
                  className="text-xs text-neutral-500 hover:text-neutral-400 transition-colors"
                >
                  Re-upload Resume
                </button>
              </div>
            </>
          )}
        </section>
      </div>

      {/* ── Right: resume analysis + overview + unlocks ── */}
      <div className="lg:col-span-3 flex flex-col gap-5">
        {/* Resume Analysis */}
        <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
          <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">
            Resume Analysis
          </p>
          <div>
            <p className="text-xs text-neutral-500 mb-2">Skills Identified</p>
            {detectedSkills && detectedSkills.length > 0 ? (
              <div className="flex flex-wrap gap-1.5">
                {detectedSkills.map((skill) => (
                  <span
                    key={skill}
                    className="bg-neutral-800 border border-neutral-700 text-white text-xs rounded-full px-2.5 py-1"
                  >
                    {skill}
                  </span>
                ))}
              </div>
            ) : (
              <span className="text-xs text-neutral-600 border border-neutral-800 rounded-full px-2.5 py-1 inline-block">
                No skills detected
              </span>
            )}
          </div>
          <div className="flex flex-wrap items-center gap-2 pt-1">
            <span className="bg-neutral-800 border border-neutral-700 text-white text-xs rounded-lg px-2.5 py-1">
              {yearsOfExperience} yr{yearsOfExperience !== 1 ? 's' : ''} experience
            </span>
            {experienceLevelLabel && (
              <span className="bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs rounded-lg px-2.5 py-1">
                {experienceLevelLabel}
              </span>
            )}
          </div>
        </section>

        {/* Assessment Overview */}
        <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
          <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">
            Assessment Overview
          </p>
          <div className="flex flex-col gap-3">
            <StatRow icon={<ClockIcon />}    label="Estimated time"  value={`${estimatedMinutes} minutes`} />
            <StatRow icon={<QuestionIcon />} label="Total questions" value={`${questionCount} questions`} />
            <StatRow icon={<BoltIcon />}     label="Difficulty level" value={difficultyLabel} valueClassName="text-emerald-400" />
          </div>
          <div>
            <div className="h-px bg-neutral-800 mb-3" />
            <p className="text-xs text-neutral-500 mb-2.5">Topics Covered</p>
            <ul className="grid grid-cols-2 gap-x-4 gap-y-1.5">
              {topics.map((topic) => (
                <li key={topic} className="flex items-center gap-2 text-sm text-neutral-300">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-500/60 flex-shrink-0" />
                  {topic}
                </li>
              ))}
            </ul>
          </div>
        </section>

        {/* What You'll Unlock */}
        <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6">
          <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest mb-4">
            What You'll Unlock
          </p>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {UNLOCKS.map(({ icon, title, desc }) => (
              <div
                key={title}
                className="flex gap-3 items-start bg-neutral-800/60 border border-neutral-700/40 rounded-xl p-4"
              >
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
        </section>
      </div>

    </div>
  )
}

function StatRow({ icon, label, value, valueClassName = 'text-white' }) {
  return (
    <div className="flex items-center gap-3">
      <div className="w-8 h-8 rounded-lg bg-neutral-800 border border-neutral-700/60 flex items-center justify-center flex-shrink-0 text-neutral-400">
        {icon}
      </div>
      <div>
        <p className="text-xs text-neutral-500">{label}</p>
        <p className={`text-sm font-semibold ${valueClassName}`}>{value}</p>
      </div>
    </div>
  )
}

function Skeleton({ className = '' }) {
  return <div className={`animate-pulse rounded bg-neutral-800 ${className}`} />
}

function CheckIcon({ className = 'w-3 h-3' }) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className={className}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
    </svg>
  )
}

function ArrowRightIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-4 h-4">
      <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
    </svg>
  )
}

function ClockIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4">
      <path strokeLinecap="round" strokeLinejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
  )
}

function QuestionIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4">
      <path strokeLinecap="round" strokeLinejoin="round" d="M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9 5.25h.008v.008H12v-.008z" />
    </svg>
  )
}

function BoltIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4">
      <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 13.5l10.5-11.25L12 10.5h8.25L9.75 21.75 12 13.5H3.75z" />
    </svg>
  )
}
