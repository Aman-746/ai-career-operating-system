import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import api from '../services/api'

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

const BAND = {
  STRONG:     { label: 'Strong',     chip: 'bg-emerald-500/10 border-emerald-500/20 text-emerald-400', bar: 'bg-emerald-500' },
  PROFICIENT: { label: 'Proficient', chip: 'bg-sky-500/10 border-sky-500/20 text-sky-400',             bar: 'bg-sky-500' },
  DEVELOPING: { label: 'Developing', chip: 'bg-amber-500/10 border-amber-500/20 text-amber-400',       bar: 'bg-amber-500' },
  WEAK:       { label: 'Weak',       chip: 'bg-rose-500/10 border-rose-500/20 text-rose-400',          bar: 'bg-rose-500' },
}

const DIFFICULTY_CHIP = {
  EASY:   'bg-emerald-500/10 border-emerald-500/20 text-emerald-400',
  MEDIUM: 'bg-amber-500/10 border-amber-500/20 text-amber-400',
  HARD:   'bg-rose-500/10 border-rose-500/20 text-rose-400',
}

const SEVERITY_CHIP = {
  CRITICAL: 'bg-rose-500/10 border-rose-500/20 text-rose-400',
  MODERATE: 'bg-amber-500/10 border-amber-500/20 text-amber-400',
  MINOR:    'bg-sky-500/10 border-sky-500/20 text-sky-400',
}

function scoreColor(score) {
  if (score >= 80) return { text: 'text-emerald-400', stroke: '#10b981', label: 'Strong' }
  if (score >= 60) return { text: 'text-sky-400',     stroke: '#38bdf8', label: 'Proficient' }
  if (score >= 40) return { text: 'text-amber-400',   stroke: '#f59e0b', label: 'Developing' }
  return               { text: 'text-rose-400',    stroke: '#f43f5e', label: 'Weak' }
}

function formatDate(iso) {
  if (!iso) return '—'
  return new Date(iso).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

function groupByTopic(questions) {
  const groups = []
  const seen = new Map()
  for (const q of questions) {
    if (!seen.has(q.topic)) {
      const group = { topic: q.topic, displayName: TOPIC_DISPLAY[q.topic] ?? q.topic, questions: [] }
      seen.set(q.topic, group)
      groups.push(group)
    }
    seen.get(q.topic).questions.push(q)
  }
  return groups
}

// ─── Page ───────────────────────────────────────────────────────────────────

export default function AssessmentResultPage() {
  const { sessionId } = useParams()
  const navigate = useNavigate()
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    api
      .get(`/api/assessment/result/${sessionId}`)
      .then((r) => setData(r.data))
      .catch((err) => setError(err.response?.data?.error ?? 'Failed to load results.'))
      .finally(() => setLoading(false))
  }, [sessionId])

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
          <div className="max-w-lg mx-auto"><ErrorState message={error} navigate={navigate} /></div>
        ) : (
          <PageContent data={data} navigate={navigate} />
        )}
      </div>
    </div>
  )
}

// ─── Loading ─────────────────────────────────────────────────────────────────

function LoadingSkeleton() {
  return (
    <div className="flex flex-col gap-5">
      <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex items-center justify-between">
        <div className="flex flex-col gap-3">
          <Skeleton className="h-5 w-48" />
          <Skeleton className="h-4 w-36" />
          <div className="flex gap-2">
            <Skeleton className="h-6 w-24 rounded-lg" />
            <Skeleton className="h-6 w-24 rounded-lg" />
            <Skeleton className="h-6 w-24 rounded-lg" />
          </div>
        </div>
        <Skeleton className="w-28 h-28 rounded-full" />
      </div>
      <Skeleton className="h-56 rounded-2xl" />
      <Skeleton className="h-40 rounded-2xl" />
      <Skeleton className="h-40 rounded-2xl" />
    </div>
  )
}

function Skeleton({ className = '' }) {
  return <div className={`animate-pulse bg-neutral-800 rounded ${className}`} />
}

// ─── Error ────────────────────────────────────────────────────────────────────

function ErrorState({ message, navigate }) {
  return (
    <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
      <div className="rounded-lg bg-red-500/10 border border-red-500/30 px-4 py-3 text-sm text-red-400">
        {message}
      </div>
      <button
        onClick={() => navigate('/assessment')}
        className="w-full rounded-lg bg-white px-4 py-2.5 text-sm font-medium text-neutral-900 hover:bg-neutral-200 transition-colors"
      >
        Back to Assessment
      </button>
    </div>
  )
}

// ─── Page content ─────────────────────────────────────────────────────────────

function PageContent({ data, navigate }) {
  const topicGroups = groupByTopic(data.questionResults ?? [])

  return (
    <div className="grid grid-cols-1 lg:grid-cols-5 gap-6 items-start">

      {/* ── Left: score + topic summary + CTAs (sticky) ── */}
      <div className="lg:col-span-2 flex flex-col gap-4 lg:sticky lg:top-6">
        <HeroCard data={data} />
        <TopicBreakdown topicScores={data.topicScores ?? []} />
        <CtaSection navigate={navigate} />
      </div>

      {/* ── Right: question review + gap analysis ── */}
      <div className="lg:col-span-3 flex flex-col gap-5">
        <QuestionReview groups={topicGroups} />
        {data.gapAnalysisStatus === 'READY' && data.gapAnalysis && (
          <GapAnalysisCard analysis={data.gapAnalysis} />
        )}
      </div>

    </div>
  )
}

// ─── Hero card ────────────────────────────────────────────────────────────────

function HeroCard({ data }) {
  const wrong = data.totalQuestions - data.totalCorrect

  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6">
      <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest mb-4">
        Assessment Complete
      </p>
      <div className="flex items-center justify-between gap-6">
        <div className="flex flex-col gap-3 min-w-0">
          <div>
            <h1 className="text-xl font-semibold text-white truncate">{data.targetRole}</h1>
            <p className="text-sm text-neutral-400 mt-0.5">Completed {formatDate(data.completedAt)}</p>
          </div>
          <div className="flex flex-wrap gap-2">
            <span className="bg-neutral-800 border border-neutral-700 text-white text-xs rounded-lg px-2.5 py-1">
              {data.totalQuestions} questions
            </span>
            <span className="bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs rounded-lg px-2.5 py-1">
              {data.totalCorrect} correct
            </span>
            {wrong > 0 && (
              <span className="bg-rose-500/10 border border-rose-500/20 text-rose-400 text-xs rounded-lg px-2.5 py-1">
                {wrong} incorrect
              </span>
            )}
          </div>
        </div>
        <ScoreRing score={data.overallScore} />
      </div>
    </section>
  )
}

function ScoreRing({ score }) {
  const r = 46
  const circ = 2 * Math.PI * r
  const offset = circ - (score / 100) * circ
  const { stroke, label, text } = scoreColor(score)

  return (
    <div className="flex flex-col items-center gap-1 flex-shrink-0">
      <svg width="112" height="112" viewBox="0 0 112 112">
        <circle cx="56" cy="56" r={r} fill="none" stroke="#262626" strokeWidth="8" />
        <circle
          cx="56" cy="56" r={r} fill="none"
          stroke={stroke} strokeWidth="8"
          strokeDasharray={circ}
          strokeDashoffset={offset}
          strokeLinecap="round"
          style={{ transform: 'rotate(-90deg)', transformOrigin: '56px 56px' }}
        />
        <text x="56" y="51" textAnchor="middle" fill="white" fontSize="24" fontWeight="600">{score}</text>
        <text x="56" y="66" textAnchor="middle" fill="#6b7280" fontSize="10">out of 100</text>
      </svg>
      <span className={`text-xs font-medium ${text}`}>{label}</span>
    </div>
  )
}

// ─── Topic breakdown ──────────────────────────────────────────────────────────

function TopicBreakdown({ topicScores }) {
  if (!topicScores.length) return null

  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
      <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">
        Topic Breakdown
      </p>
      <div className="flex flex-col gap-4">
        {topicScores.map((ts) => {
          const b = BAND[ts.band] ?? BAND.WEAK
          return (
            <div key={ts.topic} className="flex flex-col gap-1.5">
              <div className="flex items-center justify-between gap-3">
                <span className="text-sm text-white truncate">{ts.topicDisplayName}</span>
                <div className="flex items-center gap-2 flex-shrink-0">
                  <span className="text-xs text-neutral-500">{ts.correct}/{ts.asked}</span>
                  <span className={`text-xs border rounded-full px-2 py-0.5 ${b.chip}`}>
                    {b.label}
                  </span>
                </div>
              </div>
              <div className="h-1.5 bg-neutral-800 rounded-full overflow-hidden">
                <div
                  className={`h-full rounded-full transition-all duration-500 ${b.bar}`}
                  style={{ width: `${ts.score}%` }}
                />
              </div>
            </div>
          )
        })}
      </div>
    </section>
  )
}

// ─── Question review ──────────────────────────────────────────────────────────

function QuestionReview({ groups }) {
  if (!groups.length) return null

  return (
    <div className="flex flex-col gap-3">
      <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest px-1">
        Question Review
      </p>
      {groups.map((g) => (
        <TopicGroup key={g.topic} group={g} />
      ))}
    </div>
  )
}

function TopicGroup({ group }) {
  const [open, setOpen] = useState(false)
  const correct = group.questions.filter((q) => q.correct).length
  const total = group.questions.length
  const allCorrect = correct === total

  return (
    <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl overflow-hidden">
      <button
        onClick={() => setOpen((o) => !o)}
        className="w-full flex items-center justify-between gap-3 px-5 py-4 hover:bg-neutral-800/40 transition-colors text-left"
      >
        <div className="flex items-center gap-3 min-w-0">
          <span className="text-sm font-medium text-white truncate">{group.displayName}</span>
        </div>
        <div className="flex items-center gap-2.5 flex-shrink-0">
          <span className={`text-xs font-medium ${allCorrect ? 'text-emerald-400' : 'text-neutral-400'}`}>
            {correct}/{total}
          </span>
          <ChevronIcon open={open} />
        </div>
      </button>

      {open && (
        <div className="border-t border-neutral-800 divide-y divide-neutral-800/60">
          {group.questions.map((q, i) => (
            <QuestionCard key={q.questionId} q={q} index={i + 1} />
          ))}
        </div>
      )}
    </div>
  )
}

function QuestionCard({ q, index }) {
  return (
    <div className="px-5 py-4 flex flex-col gap-3">
      <div className="flex items-center gap-2">
        <span className="text-xs text-neutral-500 font-medium">Q{index}</span>
        <span className={`text-xs border rounded-full px-2 py-0.5 ${DIFFICULTY_CHIP[q.difficulty] ?? ''}`}>
          {q.difficulty.charAt(0) + q.difficulty.slice(1).toLowerCase()}
        </span>
        {q.correct ? (
          <span className="ml-auto flex items-center gap-1 text-xs text-emerald-400">
            <CheckIcon /> Correct
          </span>
        ) : (
          <span className="ml-auto flex items-center gap-1 text-xs text-rose-400">
            <CrossIcon /> Incorrect
          </span>
        )}
      </div>

      <p className="text-sm text-neutral-200 leading-relaxed">{q.stem}</p>

      <div className="flex flex-col gap-1.5">
        {q.options.map((opt) => {
          const isCorrect = opt.id === q.correctOptionId
          const isWrong = opt.id === q.selectedOptionId && !q.correct

          let rowStyle = 'border-neutral-700/30 text-neutral-500'
          let badgeStyle = 'bg-neutral-800 text-neutral-500'

          if (isCorrect) {
            rowStyle = 'border-emerald-500/30 bg-emerald-500/5 text-neutral-200'
            badgeStyle = 'bg-emerald-500 text-white'
          } else if (isWrong) {
            rowStyle = 'border-rose-500/30 bg-rose-500/5 text-neutral-300'
            badgeStyle = 'bg-rose-500 text-white'
          }

          return (
            <div
              key={opt.id}
              className={`flex items-center gap-3 rounded-lg border px-3 py-2 ${rowStyle}`}
            >
              <span className={`w-5 h-5 rounded-md text-[10px] font-bold flex items-center justify-center flex-shrink-0 ${badgeStyle}`}>
                {opt.id.toUpperCase()}
              </span>
              <span className="text-sm leading-snug">{opt.text}</span>
              {isCorrect && (
                <span className="ml-auto flex-shrink-0">
                  <CheckIcon className="text-emerald-400" />
                </span>
              )}
              {isWrong && (
                <span className="ml-auto flex-shrink-0">
                  <CrossIcon className="text-rose-400" />
                </span>
              )}
            </div>
          )
        })}
      </div>

      {q.explanation && (
        <div className="flex gap-2.5 bg-neutral-800/50 border border-neutral-700/40 rounded-lg px-3 py-2.5">
          <LightbulbIcon />
          <p className="text-xs text-neutral-400 leading-relaxed">{q.explanation}</p>
        </div>
      )}
    </div>
  )
}

// ─── Gap analysis ─────────────────────────────────────────────────────────────

function GapAnalysisCard({ analysis }) {
  const { text: levelText, chip: levelChip } = readinessStyle(analysis.readinessLevel)

  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-5">
      <div className="flex items-center justify-between gap-3">
        <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">Skill Gap Analysis</p>
        <span className={`text-xs border rounded-full px-2.5 py-0.5 ${levelChip}`}>
          {levelText}
        </span>
      </div>

      <p className="text-sm text-neutral-300 leading-relaxed">{analysis.readinessSummary}</p>

      {analysis.strengths?.length > 0 && (
        <div className="flex flex-col gap-2">
          <p className="text-xs text-neutral-500 font-medium">What's working</p>
          <div className="flex flex-col gap-2">
            {analysis.strengths.map((s, i) => (
              <div key={i} className="flex gap-3 bg-emerald-500/5 border border-emerald-500/15 rounded-xl p-3">
                <span className="w-5 h-5 rounded-full bg-emerald-500/20 border border-emerald-500/30 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <CheckIcon className="text-emerald-400 w-2.5 h-2.5" />
                </span>
                <div>
                  <p className="text-sm font-medium text-white">{s.area}</p>
                  <p className="text-xs text-neutral-400 mt-0.5">{s.evidence}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {analysis.gaps?.length > 0 && (
        <div className="flex flex-col gap-2">
          <p className="text-xs text-neutral-500 font-medium">Gaps to address</p>
          <div className="flex flex-col gap-3">
            {analysis.gaps.map((g, i) => (
              <div key={i} className="bg-neutral-800/60 border border-neutral-700/40 rounded-xl p-4 flex flex-col gap-2">
                <div className="flex items-center gap-2 flex-wrap">
                  <span className="text-sm font-medium text-white">{g.area}</span>
                  <span className={`text-xs border rounded-full px-2 py-0.5 ${SEVERITY_CHIP[g.severity] ?? ''}`}>
                    {g.severity.charAt(0) + g.severity.slice(1).toLowerCase()}
                  </span>
                  {g.evidenceSource === 'BOTH' && (
                    <span className="text-xs border border-rose-500/30 bg-rose-500/10 text-rose-400 rounded-full px-2 py-0.5">
                      ⚠ Credibility gap
                    </span>
                  )}
                </div>
                <p className="text-xs text-neutral-400 leading-relaxed">{g.insight}</p>
                <div className="h-px bg-neutral-700/40" />
                <div className="flex gap-2">
                  <span className="text-xs text-neutral-500 flex-shrink-0 mt-0.5">→</span>
                  <p className="text-xs text-neutral-300 leading-relaxed">{g.recommendation}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </section>
  )
}

function readinessStyle(level) {
  switch (level) {
    case 'INTERVIEW_READY': return { text: 'Interview Ready', chip: 'bg-emerald-500/10 border-emerald-500/20 text-emerald-400' }
    case 'DEVELOPING':      return { text: 'Developing',      chip: 'bg-amber-500/10 border-amber-500/20 text-amber-400' }
    default:                return { text: 'Not Ready',       chip: 'bg-rose-500/10 border-rose-500/20 text-rose-400' }
  }
}

// ─── CTA ─────────────────────────────────────────────────────────────────────

function CtaSection({ navigate }) {
  return (
    <section className="flex flex-col gap-3 pb-4">
      <button
        onClick={() => navigate('/roadmap')}
        className="w-full rounded-lg bg-white px-4 py-3 text-sm font-medium text-neutral-900 hover:bg-neutral-200 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 transition-colors flex items-center justify-center gap-2"
      >
        Generate my roadmap
        <ArrowRightIcon />
      </button>
      <button
        onClick={() => navigate('/dashboard')}
        className="w-full rounded-lg border border-neutral-700 px-4 py-2.5 text-sm font-medium text-neutral-400 hover:text-white hover:border-neutral-600 transition-colors"
      >
        Go to Dashboard
      </button>
    </section>
  )
}

// ─── Icons ────────────────────────────────────────────────────────────────────

function ChevronIcon({ open }) {
  return (
    <svg
      viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"
      className={`w-4 h-4 text-neutral-500 transition-transform duration-200 ${open ? 'rotate-180' : ''}`}
    >
      <path strokeLinecap="round" strokeLinejoin="round" d="M19 9l-7 7-7-7" />
    </svg>
  )
}

function CheckIcon({ className = 'w-3 h-3' }) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className={className}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
    </svg>
  )
}

function CrossIcon({ className = 'w-3 h-3' }) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className={className}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
    </svg>
  )
}

function LightbulbIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" className="w-4 h-4 text-amber-400 flex-shrink-0 mt-0.5">
      <path strokeLinecap="round" strokeLinejoin="round" d="M12 18v-5.25m0 0a6.01 6.01 0 001.5-.189m-1.5.189a6.01 6.01 0 01-1.5-.189m3.75 7.478a12.06 12.06 0 01-4.5 0m3.75 2.383a14.406 14.406 0 01-3 0M14.25 18v-.192c0-.983.658-1.823 1.508-2.316a7.5 7.5 0 10-7.517 0c.85.493 1.509 1.333 1.509 2.316V18" />
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
