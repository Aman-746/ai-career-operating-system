import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../services/api'

const TIMELINE_WEEKS = {
  ZERO_TO_THREE_MONTHS: 12,
  THREE_TO_SIX_MONTHS:  24,
  SIX_TO_TWELVE_MONTHS: 48,
  JUST_EXPLORING:       12,
}

const CATEGORY_STYLE = {
  'DSA':                'bg-emerald-500/10 border-emerald-500/20 text-emerald-400',
  'System Design':      'bg-sky-500/10 border-sky-500/20 text-sky-400',
  'Behavioral':         'bg-violet-500/10 border-violet-500/20 text-violet-400',
  'Language/Framework': 'bg-amber-500/10 border-amber-500/20 text-amber-400',
  'Other':              'bg-neutral-700/40 border-neutral-600/60 text-neutral-400',
}

function computeCompletion(weeks) {
  const all = weeks.flatMap((w) => w.items)
  if (!all.length) return 0
  return Math.round(all.filter((i) => i.status === 'COMPLETED').length * 100 / all.length)
}

// ─── Page ─────────────────────────────────────────────────────────────────────

export default function RoadmapPage() {
  const navigate = useNavigate()
  const [pageState, setPageState] = useState('loading') // loading | generating | roadmap | error
  const [roadmap, setRoadmap] = useState(null)
  const [error, setError] = useState('')
  const [confirmRegen, setConfirmRegen] = useState(false)

  useEffect(() => { loadOrGenerate() }, [])

  async function loadOrGenerate() {
    setPageState('loading')
    try {
      const r = await api.get('/api/roadmap')
      setRoadmap(r.data)
      setPageState('roadmap')
    } catch (err) {
      if (err.response?.status === 404) {
        await autoGenerate()
      } else {
        setError(err.response?.data?.error || 'Failed to load roadmap.')
        setPageState('error')
      }
    }
  }

  async function autoGenerate() {
    setPageState('generating')
    try {
      const profileRes = await api.get('/api/onboarding/profile')
      const profile = profileRes.data
      const totalWeeks = TIMELINE_WEEKS[profile.timeline] ?? 12

      const r = await api.post('/api/roadmap/generate', {
        targetRole: profile.targetRole,
        totalWeeks,
      })
      setRoadmap(r.data)
      setPageState('roadmap')
    } catch (err) {
      setError(err.response?.data?.error || 'Roadmap generation failed. Please try again.')
      setPageState('error')
    }
  }

  async function handleRegenerate() {
    setConfirmRegen(false)
    await autoGenerate()
  }

  async function toggleItem(weekIdx, itemIdx, item) {
    const newStatus = item.status === 'COMPLETED' ? 'NOT_STARTED' : 'COMPLETED'
    try {
      const r = await api.patch(`/api/roadmap/items/${item.id}`, { status: newStatus })
      setRoadmap((prev) => {
        const weeks = prev.weeks.map((week, wi) =>
          wi !== weekIdx
            ? week
            : {
                ...week,
                items: week.items.map((it, ii) =>
                  ii === itemIdx ? { ...it, status: r.data.status } : it
                ),
              }
        )
        return { ...prev, weeks, completionPercent: computeCompletion(weeks) }
      })
    } catch {
      // non-critical; checkbox will visually revert on next load
    }
  }

  return (
    <div className="min-h-screen bg-neutral-950">
      <div className="max-w-7xl mx-auto px-6 py-8">
        <Logo />

        {(pageState === 'loading' || pageState === 'generating' || pageState === 'error') && (
          <div className="max-w-lg mx-auto">
            {pageState === 'loading'    && <LoadingSkeleton />}
            {pageState === 'generating' && <GeneratingView />}
            {pageState === 'error'      && <ErrorState message={error} onRetry={loadOrGenerate} navigate={navigate} />}
          </div>
        )}

        {pageState === 'roadmap' && roadmap && (
          <RoadmapView
            roadmap={roadmap}
            onToggleItem={toggleItem}
            confirmRegen={confirmRegen}
            onRequestRegen={() => setConfirmRegen(true)}
            onCancelRegen={() => setConfirmRegen(false)}
            onConfirmRegen={handleRegenerate}
            navigate={navigate}
          />
        )}
      </div>
    </div>
  )
}

// ─── Logo ─────────────────────────────────────────────────────────────────────

function Logo() {
  return (
    <div className="flex items-center gap-2 mb-6">
      <span className="w-8 h-8 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center">
        <span className="w-3 h-3 rounded-full bg-emerald-400" />
      </span>
      <span className="text-white font-semibold tracking-wide">Career OS</span>
    </div>
  )
}

// ─── Loading skeleton ─────────────────────────────────────────────────────────

function LoadingSkeleton() {
  return (
    <div className="flex flex-col gap-4">
      <div className="h-36 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
      <div className="h-16 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
      <div className="h-16 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
      <div className="h-16 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
    </div>
  )
}

// ─── Generating view ──────────────────────────────────────────────────────────

function GeneratingView() {
  return (
    <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-10 flex flex-col items-center gap-6 text-center">
      <div className="w-12 h-12 rounded-full border-2 border-emerald-500/30 border-t-emerald-500 animate-spin" />
      <div className="flex flex-col gap-2">
        <p className="text-white font-semibold text-lg">Building your roadmap…</p>
        <p className="text-neutral-400 text-sm max-w-xs">
          AI is analyzing your resume, assessment results, and gap analysis. This takes 15–30 seconds.
        </p>
      </div>
      <div className="flex flex-col gap-2.5 w-full max-w-xs text-left">
        {[
          'Reading your resume & detected skills',
          'Analyzing assessment scores & gaps',
          'Sequencing topics week-by-week',
        ].map((step) => (
          <div key={step} className="flex items-center gap-3">
            <div className="w-1.5 h-1.5 rounded-full bg-emerald-500/60 flex-shrink-0" />
            <span className="text-sm text-neutral-500">{step}</span>
          </div>
        ))}
      </div>
    </div>
  )
}

// ─── Error state ──────────────────────────────────────────────────────────────

function ErrorState({ message, onRetry, navigate }) {
  return (
    <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
      <div className="rounded-lg bg-red-500/10 border border-red-500/30 px-4 py-3 text-sm text-red-400">
        {message}
      </div>
      <button
        onClick={onRetry}
        className="w-full rounded-lg bg-white px-4 py-2.5 text-sm font-medium text-neutral-900 hover:bg-neutral-200 transition-colors"
      >
        Try again
      </button>
      <button
        onClick={() => navigate('/dashboard')}
        className="w-full rounded-lg border border-neutral-700 px-4 py-2.5 text-sm font-medium text-neutral-400 hover:text-white hover:border-neutral-600 transition-colors"
      >
        Back to dashboard
      </button>
    </div>
  )
}

// ─── Roadmap view ─────────────────────────────────────────────────────────────

function RoadmapView({ roadmap, onToggleItem, confirmRegen, onRequestRegen, onCancelRegen, onConfirmRegen, navigate }) {
  return (
    <div className="grid grid-cols-1 lg:grid-cols-5 gap-6 items-start">

      {/* ── Left: sticky sidebar ── */}
      <div className="lg:col-span-2 flex flex-col gap-4 lg:sticky lg:top-6">
        <HeroCard
          roadmap={roadmap}
          confirmRegen={confirmRegen}
          onRequestRegen={onRequestRegen}
          onCancelRegen={onCancelRegen}
          onConfirmRegen={onConfirmRegen}
        />
        <button
          onClick={() => navigate('/daily-updates')}
          className="w-full rounded-lg bg-white px-4 py-3 text-sm font-medium text-neutral-900 hover:bg-neutral-200 transition-colors flex items-center justify-center gap-2"
        >
          Log today's update
          <ArrowRightIcon />
        </button>
        <button
          onClick={() => navigate('/dashboard')}
          className="w-full rounded-lg border border-neutral-700 px-4 py-2.5 text-sm font-medium text-neutral-400 hover:text-white hover:border-neutral-600 transition-colors"
        >
          Back to dashboard
        </button>
      </div>

      {/* ── Right: scrollable week list ── */}
      <div className="lg:col-span-3">
        <WeekList weeks={roadmap.weeks} onToggleItem={onToggleItem} />
      </div>

    </div>
  )
}

// ─── Hero card ────────────────────────────────────────────────────────────────

function HeroCard({ roadmap, confirmRegen, onRequestRegen, onCancelRegen, onConfirmRegen }) {
  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-5">
      <div className="flex items-center justify-between gap-3">
        <div>
          <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest mb-1">Your Roadmap</p>
          <h1 className="text-xl font-semibold text-white">{roadmap.targetRole}</h1>
          <p className="text-sm text-neutral-500 mt-0.5">{roadmap.totalWeeks} weeks</p>
        </div>
        <CompletionRing percent={roadmap.completionPercent} />
      </div>

      {roadmap.rationale && (
        <p className="text-sm text-neutral-400 leading-relaxed border-t border-neutral-800 pt-4">
          {roadmap.rationale}
        </p>
      )}

      {/* Regenerate */}
      {!confirmRegen ? (
        <button
          onClick={onRequestRegen}
          className="self-start flex items-center gap-1.5 text-xs text-neutral-600 hover:text-neutral-400 transition-colors"
        >
          <RefreshIcon />
          Regenerate roadmap
        </button>
      ) : (
        <div className="flex items-center gap-3 border-t border-neutral-800 pt-4">
          <span className="text-xs text-neutral-400 flex-1">
            This will replace your current roadmap. Continue?
          </span>
          <button
            onClick={onConfirmRegen}
            className="text-xs font-medium text-rose-400 hover:text-rose-300 transition-colors"
          >
            Yes, regenerate
          </button>
          <button
            onClick={onCancelRegen}
            className="text-xs text-neutral-500 hover:text-neutral-300 transition-colors"
          >
            Cancel
          </button>
        </div>
      )}
    </section>
  )
}

function CompletionRing({ percent }) {
  const r = 38
  const circ = 2 * Math.PI * r
  const offset = circ - (percent / 100) * circ
  const color = percent >= 80 ? '#10b981' : percent >= 40 ? '#f59e0b' : '#38bdf8'

  return (
    <div className="flex-shrink-0">
      <svg width="96" height="96" viewBox="0 0 96 96">
        <circle cx="48" cy="48" r={r} fill="none" stroke="#262626" strokeWidth="7" />
        <circle
          cx="48" cy="48" r={r}
          fill="none"
          stroke={color}
          strokeWidth="7"
          strokeDasharray={circ}
          strokeDashoffset={offset}
          strokeLinecap="round"
          style={{ transform: 'rotate(-90deg)', transformOrigin: '48px 48px', transition: 'stroke-dashoffset 0.4s ease' }}
        />
        <text x="48" y="44" textAnchor="middle" fill="white" fontSize="20" fontWeight="600">{percent}%</text>
        <text x="48" y="58" textAnchor="middle" fill="#6b7280" fontSize="9">complete</text>
      </svg>
    </div>
  )
}

// ─── Week list ────────────────────────────────────────────────────────────────

function WeekList({ weeks, onToggleItem }) {
  return (
    <div className="flex flex-col gap-3">
      <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest px-1">
        Week-by-week plan
      </p>
      {weeks.map((week, wi) => (
        <WeekCard key={week.weekNumber} week={week} weekIdx={wi} onToggleItem={onToggleItem} />
      ))}
    </div>
  )
}

function WeekCard({ week, weekIdx, onToggleItem }) {
  const [open, setOpen] = useState(weekIdx === 0)
  const completed = week.items.filter((i) => i.status === 'COMPLETED').length
  const total = week.items.length
  const allDone = completed === total && total > 0

  return (
    <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl overflow-hidden">
      <button
        onClick={() => setOpen((o) => !o)}
        className="w-full flex items-center justify-between gap-3 px-5 py-4 hover:bg-neutral-800/40 transition-colors text-left"
      >
        <div className="flex items-center gap-3">
          <span
            className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 transition-colors ${
              allDone
                ? 'bg-emerald-500 text-white'
                : 'bg-neutral-800 border border-neutral-700 text-neutral-400'
            }`}
          >
            {allDone ? <CheckIcon className="w-3 h-3" /> : week.weekNumber}
          </span>
          <span className="text-sm font-medium text-white">Week {week.weekNumber}</span>
        </div>
        <div className="flex items-center gap-2.5 flex-shrink-0">
          <span className={`text-xs font-medium ${allDone ? 'text-emerald-400' : 'text-neutral-400'}`}>
            {completed}/{total}
          </span>
          <ChevronDownIcon
            className={`w-4 h-4 text-neutral-500 transition-transform duration-200 ${open ? 'rotate-180' : ''}`}
          />
        </div>
      </button>

      {open && (
        <div className="border-t border-neutral-800 divide-y divide-neutral-800/50">
          {week.items.map((item, ii) => (
            <ItemRow key={item.id} item={item} onToggle={() => onToggleItem(weekIdx, ii, item)} />
          ))}
        </div>
      )}
    </div>
  )
}

// ─── Item row ─────────────────────────────────────────────────────────────────

function ItemRow({ item, onToggle }) {
  const done = item.status === 'COMPLETED'

  return (
    <div
      onClick={onToggle}
      className="flex items-center gap-3 px-5 py-3.5 hover:bg-neutral-800/30 transition-colors cursor-pointer group"
    >
      <div
        className={`w-5 h-5 rounded-md border-2 flex items-center justify-center flex-shrink-0 transition-colors ${
          done ? 'bg-emerald-500 border-emerald-500' : 'border-neutral-600 group-hover:border-neutral-500'
        }`}
      >
        {done && <CheckIcon className="w-2.5 h-2.5 text-white" />}
      </div>
      <span
        className={`text-sm flex-1 leading-snug transition-colors ${
          done ? 'line-through text-neutral-600' : 'text-neutral-200 group-hover:text-white'
        }`}
      >
        {item.topicName}
      </span>
      <span
        className={`text-xs border rounded-full px-2 py-0.5 flex-shrink-0 ${
          CATEGORY_STYLE[item.category] ?? CATEGORY_STYLE['Other']
        }`}
      >
        {item.category}
      </span>
    </div>
  )
}

// ─── Icons ────────────────────────────────────────────────────────────────────

function CheckIcon({ className = 'w-3 h-3' }) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className={className}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
    </svg>
  )
}

function ChevronDownIcon({ className = 'w-3.5 h-3.5' }) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className={className}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M19 9l-7 7-7-7" />
    </svg>
  )
}

function RefreshIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-3 h-3">
      <path strokeLinecap="round" strokeLinejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99" />
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
