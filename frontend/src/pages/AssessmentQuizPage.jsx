import { useState, useEffect, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../services/api'

function formatTime(totalSeconds) {
  const m = Math.floor(totalSeconds / 60)
  const s = totalSeconds % 60
  return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
}

const TOPIC_DISPLAY = {
  DATA_STRUCTURES_ALGORITHMS: 'Data Structures & Algorithms',
  OBJECT_ORIENTED_DESIGN: 'Object-Oriented Design',
  SYSTEM_DESIGN: 'System Design',
  DATABASES_AND_SQL: 'Databases & SQL',
  API_AND_WEB_FUNDAMENTALS: 'API & Web Fundamentals',
  CONCURRENCY_AND_PARALLELISM: 'Concurrency & Parallelism',
  FRONTEND_ENGINEERING: 'Frontend Engineering',
  JAVASCRIPT_AND_TYPESCRIPT: 'JavaScript & TypeScript',
  TESTING_AND_CODE_QUALITY: 'Testing & Code Quality',
}

const OPTION_BADGE = {
  a: 'bg-violet-500/20 text-violet-300 border border-violet-500/30',
  b: 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/30',
  c: 'bg-amber-500/20 text-amber-300 border border-amber-500/30',
  d: 'bg-rose-500/20 text-rose-300 border border-rose-500/30',
}

const QS_PER_TOPIC = 6

export default function AssessmentQuizPage() {
  const navigate = useNavigate()
  const [session, setSession] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [answers, setAnswers] = useState({})
  const [currentIdx, setCurrentIdx] = useState(0)
  const [submitting, setSubmitting] = useState(false)
  const [secondsLeft, setSecondsLeft] = useState(null)
  const timerRef = useRef(null)

  useEffect(() => {
    api
      .post('/api/assessment/start')
      .then((r) => {
        setSession(r.data)
        if (r.data.estimatedMinutes) {
          setSecondsLeft(r.data.estimatedMinutes * 60)
        }
      })
      .catch((e) => setError(e.response?.data?.error ?? 'Failed to start assessment.'))
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => {
    if (secondsLeft === null) return
    if (secondsLeft <= 0) return
    timerRef.current = setInterval(() => {
      setSecondsLeft((s) => Math.max(0, s - 1))
    }, 1000)
    return () => clearInterval(timerRef.current)
  }, [secondsLeft === null])

  if (loading) return <LoadingScreen />
  if (error || !session) return <ErrorScreen message={error} onBack={() => navigate('/assessment')} />

  const { sessionId, questions, totalQuestions } = session
  const current = questions[currentIdx]
  const answeredCount = Object.keys(answers).length
  const progressPct = Math.round((answeredCount / totalQuestions) * 100)
  const isLast = currentIdx === totalQuestions - 1
  const hasAnsweredCurrent = !!answers[current.id]

  // Ordered unique topics (preserves question order)
  const topics = [...new Set(questions.map((q) => q.topic))]
  const topicStartIdx = (t) => topics.indexOf(t) * QS_PER_TOPIC
  const currentTopic = current.topic
  const questionInTopic = currentIdx - topicStartIdx(currentTopic) + 1

  function answeredInTopic(topic) {
    const start = topicStartIdx(topic)
    return questions.slice(start, start + QS_PER_TOPIC).filter((q) => answers[q.id]).length
  }

  function goTo(idx) {
    if (idx >= 0 && idx < totalQuestions) setCurrentIdx(idx)
  }

  function selectAnswer(optionId) {
    setAnswers((prev) => ({ ...prev, [current.id]: optionId }))
  }

  async function handleNext() {
    if (!hasAnsweredCurrent) return
    if (isLast) {
      await submit()
    } else {
      setCurrentIdx((i) => i + 1)
    }
  }

  async function submit() {
    if (submitting) return
    // Guard: jump to first unanswered if navigator was used to skip
    const firstSkipped = questions.findIndex((q) => !answers[q.id])
    if (firstSkipped !== -1) {
      setCurrentIdx(firstSkipped)
      return
    }
    setSubmitting(true)
    try {
      const res = await api.post('/api/assessment/submit', {
        sessionId,
        answers: questions.map((q) => ({ questionId: q.id, selectedOptionId: answers[q.id] })),
      })
      navigate(`/assessment/result/${res.data.sessionId}`)
    } catch (e) {
      setError(e.response?.data?.error ?? 'Submission failed. Please try again.')
      setSubmitting(false)
    }
  }

  return (
    <div className="min-h-screen bg-neutral-950 flex flex-col font-sans">
      {/* ── Header ── */}
      <header className="sticky top-0 z-20 border-b border-neutral-800 bg-neutral-900/90 backdrop-blur-sm">
        <div className="max-w-[1440px] mx-auto px-5 h-14 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="w-7 h-7 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center">
              <span className="w-2.5 h-2.5 rounded-full bg-emerald-400" />
            </span>
            <span className="text-white font-semibold tracking-wide text-sm">Career OS</span>
          </div>
          <button
            onClick={() => navigate('/assessment')}
            className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium text-neutral-400 border border-neutral-700 rounded-lg hover:text-rose-400 hover:border-rose-500/50 transition-colors"
          >
            <ExitIcon />
            Exit Assessment
          </button>
        </div>
      </header>

      {/* ── Progress strip ── */}
      <div className="border-b border-neutral-800 bg-neutral-900/60">
        <div className="max-w-[1440px] mx-auto px-5 py-3 flex items-center gap-5">
          {/* Progress % + timer side-by-side */}
          <div className="flex items-center gap-4 flex-shrink-0">
            <div>
              <p className="text-2xl font-bold text-white leading-none">{progressPct}%</p>
              <p className="text-xs text-neutral-500 mt-0.5">Overall progress</p>
            </div>
            {secondsLeft !== null && (
              <div className="border-l border-neutral-700 pl-4">
                <p className={`text-xl font-mono font-bold leading-none tabular-nums ${
                  secondsLeft < 120 ? 'text-rose-400' : 'text-emerald-400'
                }`}>
                  {formatTime(secondsLeft)}
                </p>
                <p className="text-xs text-neutral-500 mt-0.5">time left</p>
              </div>
            )}
          </div>

          {/* Bar */}
          <div className="flex-1">
            <div className="h-2.5 bg-neutral-800 rounded-full overflow-hidden">
              <div
                className="h-full rounded-full bg-gradient-to-r from-emerald-600 to-emerald-400 transition-all duration-500"
                style={{ width: `${progressPct}%` }}
              />
            </div>
            <p className="text-xs text-neutral-500 mt-1.5 text-center">
              {answeredCount} of {totalQuestions} questions answered
            </p>
          </div>

          <div className="min-w-[80px] text-right flex-shrink-0">
            <p className="text-sm font-semibold text-white">{totalQuestions - answeredCount}</p>
            <p className="text-xs text-neutral-500">remaining</p>
          </div>
        </div>
      </div>

      {/* ── Three-column body ── */}
      <div className="flex-1 max-w-[1440px] mx-auto w-full px-4 py-5 grid grid-cols-[210px_1fr_196px] gap-4">

        {/* ── Left: Topics ── */}
        <aside className="flex flex-col gap-2">
          <p className="text-[10px] font-semibold text-neutral-500 uppercase tracking-widest px-1 mb-0.5">
            Topics
          </p>

          {topics.map((topic) => {
            const done = answeredInTopic(topic)
            const pct = Math.round((done / QS_PER_TOPIC) * 100)
            const active = topic === currentTopic
            return (
              <button
                key={topic}
                onClick={() => goTo(topicStartIdx(topic))}
                className={`group w-full text-left flex items-center gap-3 p-3 rounded-xl border transition-all ${
                  active
                    ? 'bg-neutral-800 border-emerald-500/40'
                    : 'bg-neutral-900/60 border-neutral-800 hover:border-neutral-700 hover:bg-neutral-800/60'
                }`}
              >
                <div className="flex-1 min-w-0">
                  <p className={`text-xs font-medium leading-tight truncate ${active ? 'text-white' : 'text-neutral-300'}`}>
                    {TOPIC_DISPLAY[topic] ?? topic}
                  </p>
                  <p className="text-[10px] text-neutral-500 mt-0.5">
                    {done} / {QS_PER_TOPIC} answered
                  </p>
                </div>
                <MiniRing pct={pct} active={active} />
              </button>
            )
          })}

          {/* Motivational card */}
          <div className="mt-auto pt-3">
            <div className="bg-emerald-500/5 border border-emerald-500/15 rounded-xl p-4 text-center">
              <div className="text-xl mb-1">🏆</div>
              <p className="text-xs font-semibold text-white">Keep it up!</p>
              <p className="text-[10px] text-neutral-500 mt-1 leading-relaxed">
                Every question brings you closer to your dream role.
              </p>
            </div>
          </div>
        </aside>

        {/* ── Center: Question panel ── */}
        <main className="bg-neutral-900/80 border border-neutral-800 rounded-2xl flex flex-col overflow-hidden">
          {/* Topic header */}
          <div className="flex items-center justify-between px-6 py-4 border-b border-neutral-800">
            <span className="text-xs font-semibold text-neutral-400 uppercase tracking-wide">
              {TOPIC_DISPLAY[currentTopic] ?? currentTopic}
            </span>
            <span className="text-xs text-neutral-500">
              Question {questionInTopic} of {QS_PER_TOPIC}
            </span>
          </div>

          {/* Question body */}
          <div className="flex-1 px-6 py-6 flex flex-col gap-6 overflow-y-auto">
            <div>
              <p className="text-xs text-neutral-500 mb-3">Select one option</p>
              <h2 className="text-xl font-semibold text-white leading-relaxed">{current.stem}</h2>
            </div>

            <div className="flex flex-col gap-3">
              {current.options.map((opt) => {
                const selected = answers[current.id] === opt.id
                return (
                  <button
                    key={opt.id}
                    onClick={() => selectAnswer(opt.id)}
                    className={`flex items-center gap-4 w-full text-left px-4 py-3.5 rounded-xl border transition-all ${
                      selected
                        ? 'border-emerald-500 bg-emerald-500/10'
                        : 'border-neutral-700 bg-neutral-800/40 hover:border-neutral-600 hover:bg-neutral-800'
                    }`}
                  >
                    {/* Radio circle */}
                    <span
                      className={`w-4 h-4 rounded-full border-2 flex-shrink-0 flex items-center justify-center transition-colors ${
                        selected ? 'border-emerald-400' : 'border-neutral-600'
                      }`}
                    >
                      {selected && <span className="w-2 h-2 rounded-full bg-emerald-400" />}
                    </span>

                    {/* Letter badge */}
                    <span
                      className={`w-7 h-7 rounded-lg text-xs font-bold flex items-center justify-center flex-shrink-0 uppercase ${OPTION_BADGE[opt.id] ?? ''}`}
                    >
                      {opt.id}
                    </span>

                    {/* Option text */}
                    <span className={`text-sm ${selected ? 'text-white font-medium' : 'text-neutral-300'}`}>
                      {opt.text}
                    </span>
                  </button>
                )
              })}
            </div>

            <div className="flex items-start gap-2 text-xs text-neutral-600 pt-1">
              <LightbulbIcon />
              <span>Not sure? Take your best guess. You can go back and change your answer anytime.</span>
            </div>
          </div>

          {/* Navigation footer */}
          <div className="px-6 py-4 border-t border-neutral-800 flex items-center justify-between">
            <button
              onClick={() => goTo(currentIdx - 1)}
              disabled={currentIdx === 0}
              className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-neutral-300 border border-neutral-700 rounded-lg hover:border-neutral-600 hover:text-white disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
            >
              <ArrowLeftIcon />
              Previous
            </button>

            {!hasAnsweredCurrent && (
              <span className="text-xs text-neutral-600">Select an option to continue</span>
            )}

            <button
              onClick={handleNext}
              disabled={!hasAnsweredCurrent || submitting}
              className="flex items-center gap-2 px-5 py-2 text-sm font-medium bg-white text-neutral-900 rounded-lg hover:bg-neutral-200 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
            >
              {submitting ? (
                <>
                  <span className="w-3.5 h-3.5 border-2 border-neutral-400 border-t-neutral-900 rounded-full animate-spin" />
                  Submitting…
                </>
              ) : isLast ? (
                'Submit Assessment'
              ) : (
                <>Next <ArrowRightIcon /></>
              )}
            </button>
          </div>
        </main>

        {/* ── Right: Navigator ── */}
        <aside className="flex flex-col gap-3">
          <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-4 flex flex-col gap-3">
            <p className="text-xs font-semibold text-neutral-400">Question Navigator</p>

            <div className="grid grid-cols-6 gap-1">
              {questions.map((q, i) => {
                const isAnswered = !!answers[q.id]
                const isCurrent = i === currentIdx
                return (
                  <button
                    key={q.id}
                    onClick={() => goTo(i)}
                    title={`Q${i + 1}`}
                    className={`aspect-square text-[10px] font-medium rounded-md flex items-center justify-center transition-all ${
                      isCurrent
                        ? 'ring-2 ring-emerald-500 ring-offset-1 ring-offset-neutral-900 bg-neutral-700 text-white'
                        : isAnswered
                        ? 'bg-emerald-500/20 text-emerald-400'
                        : 'bg-neutral-800 text-neutral-500 hover:bg-neutral-700 hover:text-neutral-300'
                    }`}
                  >
                    {i + 1}
                  </button>
                )
              })}
            </div>

            {/* Legend */}
            <div className="pt-2 border-t border-neutral-800 flex flex-col gap-1.5">
              <p className="text-[10px] font-semibold text-neutral-500 uppercase tracking-wider mb-0.5">
                Legend
              </p>
              <LegendRow dotClass="bg-emerald-500/20 border border-emerald-500/30" label="Answered" />
              <LegendRow dotClass="ring-2 ring-emerald-500 bg-neutral-700" label="Current" />
              <LegendRow dotClass="bg-neutral-800 border border-neutral-700" label="Not answered" />
            </div>
          </div>

          {/* Stats */}
          <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-4 flex flex-col gap-2.5">
            <StatRow
              dot="bg-neutral-600"
              label="Total"
              value={totalQuestions}
            />
            <StatRow
              dot="bg-emerald-500"
              label="Answered"
              value={answeredCount}
            />
            <StatRow
              dot="bg-neutral-700"
              label="Remaining"
              value={totalQuestions - answeredCount}
            />
          </div>
        </aside>
      </div>

      {/* ── Status bar ── */}
      <div className="border-t border-neutral-800 bg-neutral-900/50">
        <div className="max-w-[1440px] mx-auto px-5 h-10 flex items-center justify-center">
          <div className="flex items-center gap-2 text-xs text-neutral-600">
            <ShieldIcon />
            Every answer helps us build a more personalized roadmap toward your target role.
          </div>
        </div>
      </div>
    </div>
  )
}

// ── Sub-components ──────────────────────────────────────────────

function MiniRing({ pct, active }) {
  const r = 14
  const circ = 2 * Math.PI * r
  const offset = circ - (pct / 100) * circ
  return (
    <svg width="36" height="36" viewBox="0 0 36 36" className="-rotate-90 flex-shrink-0">
      <circle cx="18" cy="18" r={r} fill="none" stroke="#262626" strokeWidth="3" />
      <circle
        cx="18" cy="18" r={r} fill="none"
        stroke={active ? '#34d399' : '#4b5563'}
        strokeWidth="3"
        strokeDasharray={circ}
        strokeDashoffset={offset}
        strokeLinecap="round"
        style={{ transition: 'stroke-dashoffset 0.4s ease' }}
      />
    </svg>
  )
}

function LegendRow({ dotClass, label }) {
  return (
    <div className="flex items-center gap-2">
      <span className={`w-3.5 h-3.5 rounded-sm flex-shrink-0 ${dotClass}`} />
      <span className="text-[11px] text-neutral-400">{label}</span>
    </div>
  )
}

function StatRow({ dot, label, value }) {
  return (
    <div className="flex items-center justify-between">
      <span className="flex items-center gap-2 text-xs text-neutral-400">
        <span className={`w-2 h-2 rounded-full ${dot}`} />
        {label}
      </span>
      <span className="text-xs font-semibold text-white">{value}</span>
    </div>
  )
}

function LoadingScreen() {
  return (
    <div className="min-h-screen bg-neutral-950 flex items-center justify-center">
      <div className="flex flex-col items-center gap-3">
        <div className="w-8 h-8 border-2 border-emerald-400 border-t-transparent rounded-full animate-spin" />
        <p className="text-sm text-neutral-400">Loading your assessment…</p>
      </div>
    </div>
  )
}

function ErrorScreen({ message, onBack }) {
  return (
    <div className="min-h-screen bg-neutral-950 flex items-center justify-center px-4">
      <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-8 max-w-md w-full flex flex-col gap-4">
        <div className="rounded-lg bg-red-500/10 border border-red-500/30 px-4 py-3 text-sm text-red-400">
          {message ?? 'Something went wrong.'}
        </div>
        <button
          onClick={onBack}
          className="w-full rounded-lg bg-white px-4 py-2.5 text-sm font-medium text-neutral-900 hover:bg-neutral-200 transition-colors"
        >
          Go Back
        </button>
      </div>
    </div>
  )
}

// ── Icons ──────────────────────────────────────────────────────

function ExitIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-3.5 h-3.5">
      <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75" />
    </svg>
  )
}

function ArrowLeftIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-4 h-4">
      <path strokeLinecap="round" strokeLinejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18" />
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

function LightbulbIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-3.5 h-3.5 flex-shrink-0 mt-0.5">
      <path strokeLinecap="round" strokeLinejoin="round" d="M12 18v-5.25m0 0a6.01 6.01 0 001.5-.189m-1.5.189a6.01 6.01 0 01-1.5-.189m3.75 7.478a12.06 12.06 0 01-4.5 0m3.75 2.383a14.406 14.406 0 01-3 0M14.25 18v-.192c0-.983.658-1.823 1.508-2.316a7.5 7.5 0 10-7.517 0c.85.493 1.509 1.333 1.509 2.316V18" />
    </svg>
  )
}

function ShieldIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-3.5 h-3.5 flex-shrink-0">
      <path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z" />
    </svg>
  )
}
