import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import api from '../services/api'

const TIMELINE_LABEL = {
  ZERO_TO_THREE_MONTHS:  '3-month plan',
  THREE_TO_SIX_MONTHS:   '6-month plan',
  SIX_TO_TWELVE_MONTHS:  '12-month plan',
  JUST_EXPLORING:        'Exploring',
}

function todayIso() {
  return new Date().toISOString().slice(0, 10)
}

function greeting() {
  const h = new Date().getHours()
  if (h < 12) return 'Good morning'
  if (h < 17) return 'Good afternoon'
  return 'Good evening'
}

function friendlyDate(dateStr) {
  if (!dateStr) return '—'
  const [y, m, d] = dateStr.split('-').map(Number)
  return new Date(y, m - 1, d).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
}

// ─── Page ─────────────────────────────────────────────────────────────────────

export default function DashboardPage() {
  const navigate = useNavigate()
  const { user, logout } = useAuth()

  const [profile, setProfile]         = useState(null)
  const [roadmap, setRoadmap]         = useState(null)
  const [updates, setUpdates]         = useState([])
  const [analysis, setAnalysis]       = useState(null)
  const [introData, setIntroData]     = useState(null)
  const [loading, setLoading]         = useState(true)

  useEffect(() => {
    async function load() {
      const [profileRes, roadmapRes, updatesRes, analysisRes, introRes] =
        await Promise.allSettled([
          api.get('/api/onboarding/profile'),
          api.get('/api/roadmap'),
          api.get('/api/daily-updates'),
          api.get('/api/daily-updates/analysis'),
          api.get('/api/assessment/intro'),
        ])

      if (profileRes.status  === 'fulfilled') setProfile(profileRes.value.data)
      if (roadmapRes.status  === 'fulfilled') setRoadmap(roadmapRes.value.data)
      if (updatesRes.status  === 'fulfilled') setUpdates(updatesRes.value.data)
      if (analysisRes.status === 'fulfilled') setAnalysis(analysisRes.value.data)
      if (introRes.status    === 'fulfilled') setIntroData(introRes.value.data)
      setLoading(false)
    }
    load()
  }, [])

  const totalHours    = updates.reduce((s, u) => s + Number(u.totalHours || 0), 0)
  const loggedToday   = updates.some((u) => u.date === todayIso())
  const recentUpdates = updates.slice(0, 3)

  // Step statuses
  const steps = buildSteps({ profile, introData, roadmap, updates })

  return (
    <div className="min-h-screen bg-neutral-950">

      {/* ── Navbar ── */}
      <nav className="border-b border-neutral-800/70 bg-neutral-950/80 backdrop-blur-sm sticky top-0 z-10">
        <div className="max-w-7xl mx-auto px-6 py-3.5 flex items-center justify-between gap-6">
          <div className="flex items-center gap-2.5">
            <span className="w-7 h-7 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center">
              <span className="w-2.5 h-2.5 rounded-full bg-emerald-400" />
            </span>
            <span className="text-white font-semibold tracking-wide text-sm">Career OS</span>
          </div>

          <div className="hidden md:flex items-center gap-1">
            {[
              { label: 'Roadmap',       path: '/roadmap' },
              { label: 'Daily Updates', path: '/daily-updates' },
              { label: 'Assessment',    path: '/assessment' },
              { label: 'Profile',       path: '/onboarding' },
            ].map(({ label, path }) => (
              <button
                key={path}
                onClick={() => navigate(path)}
                className="px-3 py-1.5 rounded-lg text-sm text-neutral-400 hover:text-white hover:bg-neutral-800/60 transition-colors"
              >
                {label}
              </button>
            ))}
          </div>

          <div className="flex items-center gap-3">
            {loggedToday && (
              <span className="hidden sm:flex items-center gap-1.5 bg-emerald-500/10 border border-emerald-500/20 rounded-full px-3 py-1">
                <span className="w-1.5 h-1.5 rounded-full bg-emerald-400" />
                <span className="text-xs text-emerald-400 font-medium">Logged today</span>
              </span>
            )}
            <span className="text-sm text-neutral-400">{user?.name}</span>
            <button
              onClick={logout}
              className="text-xs text-neutral-600 hover:text-neutral-400 transition-colors"
            >
              Sign out
            </button>
          </div>
        </div>
      </nav>

      {/* ── Main ── */}
      <div className="max-w-7xl mx-auto px-6 py-8 flex flex-col gap-7">

        {loading ? (
          <DashboardSkeleton />
        ) : (
          <>
            {/* ── Hero ── */}
            <HeroCard
              user={user}
              profile={profile}
              roadmap={roadmap}
              loggedToday={loggedToday}
              navigate={navigate}
            />

            {/* ── Stats row ── */}
            <StatsRow
              roadmap={roadmap}
              updates={updates}
              totalHours={totalHours}
              introData={introData}
            />

            {/* ── Main grid ── */}
            <div className="grid grid-cols-1 lg:grid-cols-5 gap-6">

              {/* Left: Journey + Recent activity */}
              <div className="lg:col-span-3 flex flex-col gap-6">
                <JourneySection steps={steps} navigate={navigate} introData={introData} />
                {recentUpdates.length > 0 && (
                  <RecentActivityCard updates={recentUpdates} navigate={navigate} />
                )}
              </div>

              {/* Right: Quick actions + About */}
              <div className="lg:col-span-2 flex flex-col gap-6">
                <QuickActionsCard
                  navigate={navigate}
                  introData={introData}
                  loggedToday={loggedToday}
                  roadmap={roadmap}
                  analysis={analysis}
                />
                <AboutCard />
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  )
}

// ─── Step builder ─────────────────────────────────────────────────────────────

function buildSteps({ profile, introData, roadmap, updates }) {
  const profileDone     = !!profile
  const resumeDone      = !!profile?.resumeUploaded
  const assessmentDone  = !!introData?.completedSessionId
  const roadmapExists   = !!roadmap
  const updatesExist    = updates.length > 0

  return [
    {
      number: 1,
      title: 'Profile Setup',
      description: 'Set your target role and experience level',
      status: profileDone ? 'complete' : 'not_started',
      link: '/onboarding',
      action: profileDone ? 'Edit profile' : 'Set up profile',
    },
    {
      number: 2,
      title: 'Resume Upload',
      description: 'AI extracts your current skills automatically',
      status: resumeDone ? 'complete' : profileDone ? 'in_progress' : 'not_started',
      link: '/onboarding/resume',
      action: resumeDone ? 'Re-upload' : 'Upload resume',
    },
    {
      number: 3,
      title: 'Skill Assessment',
      description: '30-question quiz calibrated to your target role',
      status: assessmentDone ? 'complete' : resumeDone ? 'in_progress' : 'not_started',
      link: '/assessment',
      action: assessmentDone ? 'View intro' : 'Take assessment',
    },
    {
      number: 4,
      title: 'Gap Analysis',
      description: 'AI identifies exactly what\'s holding you back',
      status: assessmentDone ? 'complete' : 'not_started',
      link: introData?.completedSessionId
        ? `/assessment/result/${introData.completedSessionId}`
        : '/assessment',
      action: assessmentDone ? 'View analysis' : 'Complete assessment first',
    },
    {
      number: 5,
      title: 'Learning Roadmap',
      description: 'Week-by-week study plan tailored to your gaps',
      status: roadmapExists
        ? (roadmap.completionPercent > 0 ? 'in_progress' : 'complete')
        : assessmentDone ? 'in_progress' : 'not_started',
      link: '/roadmap',
      action: roadmapExists ? 'Continue roadmap' : 'Generate roadmap',
      meta: roadmapExists ? `${roadmap.completionPercent}% done` : null,
    },
    {
      number: 6,
      title: 'Daily Updates',
      description: 'Log progress, get AI coaching every 3 days',
      status: updatesExist ? 'in_progress' : roadmapExists ? 'in_progress' : 'not_started',
      link: '/daily-updates',
      action: 'Log today\'s update',
      meta: updatesExist ? `${updates.length} days logged` : null,
    },
  ]
}

// ─── Dashboard skeleton ───────────────────────────────────────────────────────

function DashboardSkeleton() {
  return (
    <div className="flex flex-col gap-7">
      <div className="h-44 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[0,1,2,3].map((i) => (
          <div key={i} className="h-24 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
        ))}
      </div>
      <div className="grid grid-cols-1 lg:grid-cols-5 gap-6">
        <div className="lg:col-span-3 h-96 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
        <div className="lg:col-span-2 h-96 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
      </div>
    </div>
  )
}

// ─── Hero card ────────────────────────────────────────────────────────────────

function HeroCard({ user, profile, roadmap, loggedToday, navigate }) {
  const pct = roadmap?.completionPercent ?? 0

  return (
    <section className="relative bg-neutral-900/80 border border-neutral-800 rounded-2xl overflow-hidden">
      {/* Subtle gradient overlay */}
      <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/5 via-transparent to-transparent pointer-events-none" />
      <div className="absolute top-0 right-0 w-64 h-64 bg-emerald-500/5 rounded-full blur-3xl pointer-events-none" />

      <div className="relative p-7 flex items-center justify-between gap-6">
        <div className="flex flex-col gap-4 min-w-0">
          <div>
            <p className="text-xs text-emerald-400 font-medium tracking-widest uppercase mb-1.5">
              {greeting()}
            </p>
            <h1 className="text-3xl font-bold text-white truncate">
              {user?.name ?? 'there'}
            </h1>
            {profile ? (
              <div className="flex flex-wrap items-center gap-2 mt-2">
                <span className="text-neutral-400 text-sm">Preparing for</span>
                <span className="text-white font-medium text-sm">{profile.targetRole}</span>
                {profile.targetCompany && (
                  <>
                    <span className="text-neutral-600 text-sm">at</span>
                    <span className="text-white font-medium text-sm">{profile.targetCompany}</span>
                  </>
                )}
              </div>
            ) : (
              <p className="text-neutral-500 text-sm mt-1">Complete your profile to get started</p>
            )}
          </div>

          <div className="flex flex-wrap gap-2">
            {profile?.timeline && (
              <span className="bg-neutral-800 border border-neutral-700 text-neutral-300 text-xs rounded-lg px-2.5 py-1">
                {TIMELINE_LABEL[profile.timeline] ?? profile.timeline}
              </span>
            )}
            {profile?.yearsOfExperience !== undefined && (
              <span className="bg-neutral-800 border border-neutral-700 text-neutral-300 text-xs rounded-lg px-2.5 py-1">
                {profile.yearsOfExperience}y experience
              </span>
            )}
            {roadmap && (
              <span className="bg-neutral-800 border border-neutral-700 text-neutral-300 text-xs rounded-lg px-2.5 py-1">
                {roadmap.totalWeeks}-week roadmap
              </span>
            )}
            {!loggedToday && roadmap && (
              <button
                onClick={() => navigate('/daily-updates')}
                className="bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-xs rounded-lg px-2.5 py-1 hover:bg-emerald-500/20 transition-colors"
              >
                + Log today's update
              </button>
            )}
          </div>
        </div>

        {/* Completion ring */}
        {roadmap && (
          <div className="flex-shrink-0 flex flex-col items-center gap-2">
            <HeroRing pct={pct} />
            <span className="text-xs text-neutral-500">roadmap progress</span>
          </div>
        )}
      </div>
    </section>
  )
}

function HeroRing({ pct }) {
  const r = 52, circ = 2 * Math.PI * r
  const offset = circ - (pct / 100) * circ
  const color  = pct >= 80 ? '#10b981' : pct >= 40 ? '#f59e0b' : '#38bdf8'

  return (
    <svg width="128" height="128" viewBox="0 0 128 128">
      <circle cx="64" cy="64" r={r} fill="none" stroke="#262626" strokeWidth="9" />
      <circle
        cx="64" cy="64" r={r} fill="none"
        stroke={color} strokeWidth="9"
        strokeDasharray={circ} strokeDashoffset={offset}
        strokeLinecap="round"
        style={{ transform: 'rotate(-90deg)', transformOrigin: '64px 64px', transition: 'stroke-dashoffset .4s ease' }}
      />
      <text x="64" y="58" textAnchor="middle" fill="white" fontSize="26" fontWeight="700">{pct}%</text>
      <text x="64" y="74" textAnchor="middle" fill="#6b7280" fontSize="10">complete</text>
    </svg>
  )
}

// ─── Stats row ────────────────────────────────────────────────────────────────

function StatsRow({ roadmap, updates, totalHours, introData }) {
  const assessmentScore = introData?.completedSessionId ? null : null // fetched inline via result page

  return (
    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
      <StatCard
        label="Roadmap"
        value={roadmap ? `${roadmap.completionPercent}%` : '—'}
        sub={roadmap ? `${roadmap.totalWeeks}-week plan` : 'Not started'}
        accent="emerald"
        bar={roadmap?.completionPercent}
      />
      <StatCard
        label="Days logged"
        value={updates.length}
        sub={updates.length === 0 ? 'Start logging' : `${updates.filter(u => {
          const d = new Date(u.date + 'T00:00:00')
          const c = new Date(); c.setDate(c.getDate() - 6); c.setHours(0,0,0,0)
          return d >= c
        }).length} this week`}
        accent="sky"
      />
      <StatCard
        label="Hours studied"
        value={totalHours > 0 ? `${totalHours.toFixed(1)}h` : '—'}
        sub={updates.length > 0 ? `avg ${(totalHours / updates.length).toFixed(1)}h/day` : 'No updates yet'}
        accent="violet"
      />
      <StatCard
        label="Assessment"
        value={introData?.completedSessionId ? 'Done' : '—'}
        sub={introData?.completedSessionId ? 'Gap analysis ready' : 'Not completed'}
        accent={introData?.completedSessionId ? 'emerald' : 'neutral'}
      />
    </div>
  )
}

function StatCard({ label, value, sub, accent, bar }) {
  const accentMap = {
    emerald: { text: 'text-emerald-400', bg: 'bg-emerald-500', border: 'border-emerald-500/20', card: 'bg-emerald-500/5' },
    sky:     { text: 'text-sky-400',     bg: 'bg-sky-500',     border: 'border-sky-500/20',     card: 'bg-sky-500/5' },
    violet:  { text: 'text-violet-400',  bg: 'bg-violet-500',  border: 'border-violet-500/20',  card: 'bg-violet-500/5' },
    amber:   { text: 'text-amber-400',   bg: 'bg-amber-500',   border: 'border-amber-500/20',   card: 'bg-amber-500/5' },
    neutral: { text: 'text-neutral-400', bg: 'bg-neutral-600', border: 'border-neutral-700',    card: '' },
  }
  const a = accentMap[accent] ?? accentMap.neutral

  return (
    <div className={`bg-neutral-900/80 border border-neutral-800 rounded-2xl p-5 flex flex-col gap-3 ${a.card}`}>
      <p className="text-xs text-neutral-500 font-medium">{label}</p>
      <div>
        <p className={`text-2xl font-bold ${a.text}`}>{value}</p>
        <p className="text-xs text-neutral-600 mt-0.5">{sub}</p>
      </div>
      {bar !== undefined && bar !== null && (
        <div className="h-1 bg-neutral-800 rounded-full overflow-hidden">
          <div
            className={`h-full rounded-full ${a.bg} transition-all duration-500`}
            style={{ width: `${bar}%` }}
          />
        </div>
      )}
    </div>
  )
}

// ─── Journey section ──────────────────────────────────────────────────────────

function JourneySection({ steps, navigate, introData }) {
  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-5">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">Your Journey</p>
          <p className="text-sm text-neutral-400 mt-0.5">6 steps to land your dream role</p>
        </div>
        <span className="text-xs text-neutral-600">
          {steps.filter((s) => s.status === 'complete').length}/{steps.length} complete
        </span>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3">
        {steps.map((step) => (
          <StepCard key={step.number} step={step} navigate={navigate} />
        ))}
      </div>
    </section>
  )
}

function StepCard({ step, navigate }) {
  const { status } = step

  const containerStyle = {
    complete:    'border-emerald-500/20 bg-emerald-500/5',
    in_progress: 'border-sky-500/20 bg-sky-500/5',
    not_started: 'border-neutral-800 bg-neutral-800/20',
  }[status]

  const numberStyle = {
    complete:    'bg-emerald-500 border-emerald-500 text-white',
    in_progress: 'bg-sky-500/20 border-sky-500/40 text-sky-400',
    not_started: 'bg-neutral-800 border-neutral-700 text-neutral-500',
  }[status]

  const actionStyle = {
    complete:    'text-emerald-400 hover:text-emerald-300',
    in_progress: 'text-sky-400 hover:text-sky-300',
    not_started: 'text-neutral-600 hover:text-neutral-400',
  }[status]

  return (
    <div className={`rounded-xl border p-4 flex flex-col gap-3 transition-colors hover:border-neutral-700 ${containerStyle}`}>
      <div className="flex items-center justify-between gap-2">
        <span className={`w-6 h-6 rounded-full border flex items-center justify-center flex-shrink-0 text-xs font-bold ${numberStyle}`}>
          {status === 'complete' ? <CheckIcon className="w-3 h-3" /> : step.number}
        </span>
        <StatusPill status={status} />
      </div>

      <div className="flex-1">
        <p className={`text-sm font-medium leading-snug ${status === 'not_started' ? 'text-neutral-500' : 'text-white'}`}>
          {step.title}
        </p>
        <p className="text-xs text-neutral-600 mt-0.5 leading-relaxed">{step.description}</p>
        {step.meta && (
          <p className={`text-xs font-medium mt-1.5 ${status === 'complete' ? 'text-emerald-400' : 'text-sky-400'}`}>
            {step.meta}
          </p>
        )}
      </div>

      <button
        onClick={() => navigate(step.link)}
        disabled={status === 'not_started' && step.number > 1}
        className={`text-xs font-medium text-left transition-colors disabled:opacity-30 disabled:cursor-not-allowed ${actionStyle}`}
      >
        {step.action} →
      </button>
    </div>
  )
}

function StatusPill({ status }) {
  const styles = {
    complete:    'bg-emerald-500/15 border-emerald-500/25 text-emerald-400',
    in_progress: 'bg-sky-500/15 border-sky-500/25 text-sky-400',
    not_started: 'bg-neutral-800 border-neutral-700 text-neutral-600',
  }
  const labels = {
    complete:    'Done',
    in_progress: 'Active',
    not_started: 'Pending',
  }

  return (
    <span className={`text-[10px] font-medium border rounded-full px-2 py-0.5 ${styles[status]}`}>
      {labels[status]}
    </span>
  )
}

// ─── Recent activity card ─────────────────────────────────────────────────────

const CATEGORY_STYLE = {
  'DSA':                'bg-emerald-500/10 border-emerald-500/20 text-emerald-400',
  'System Design':      'bg-sky-500/10 border-sky-500/20 text-sky-400',
  'Behavioral':         'bg-violet-500/10 border-violet-500/20 text-violet-400',
  'Language/Framework': 'bg-amber-500/10 border-amber-500/20 text-amber-400',
  'Other':              'bg-neutral-700/40 border-neutral-600/60 text-neutral-400',
}

function RecentActivityCard({ updates, navigate }) {
  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
      <div className="flex items-center justify-between gap-3">
        <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">Recent Activity</p>
        <button
          onClick={() => navigate('/daily-updates')}
          className="text-xs text-neutral-500 hover:text-neutral-300 transition-colors"
        >
          View all →
        </button>
      </div>

      <div className="flex flex-col divide-y divide-neutral-800/60">
        {updates.map((u, i) => (
          <div key={u.id} className={`flex items-start gap-4 ${i > 0 ? 'pt-3.5' : ''} ${i < updates.length - 1 ? 'pb-3.5' : ''}`}>
            <div className="flex flex-col items-center gap-1 flex-shrink-0 pt-0.5">
              <span className="text-xs font-medium text-white">
                {friendlyDate(u.date)}
              </span>
              <span className="text-xs text-neutral-600">{u.totalHours}h</span>
            </div>
            <div className="flex flex-wrap gap-1 flex-1 min-w-0">
              {u.items?.slice(0, 3).map((item) => (
                <span
                  key={item.id}
                  className={`text-xs border rounded-full px-2 py-0.5 ${CATEGORY_STYLE[item.category] ?? CATEGORY_STYLE['Other']}`}
                >
                  {item.topicName}
                </span>
              ))}
              {(u.items?.length ?? 0) > 3 && (
                <span className="text-xs text-neutral-600 py-0.5">+{u.items.length - 3} more</span>
              )}
            </div>
          </div>
        ))}
      </div>
    </section>
  )
}

// ─── Quick actions card ───────────────────────────────────────────────────────

function QuickActionsCard({ navigate, introData, loggedToday, roadmap, analysis }) {
  const actions = [
    {
      label: loggedToday ? "View today's update" : "Log today's update",
      sub: loggedToday ? 'You\'ve logged for today' : 'Keep your streak going',
      path: '/daily-updates',
      primary: !loggedToday,
      accent: 'emerald',
    },
    {
      label: roadmap ? 'Continue roadmap' : 'Generate roadmap',
      sub: roadmap ? `${roadmap.completionPercent}% complete · ${roadmap.totalWeeks} weeks` : 'Build your study plan',
      path: '/roadmap',
      primary: false,
      accent: 'sky',
    },
    ...(introData?.completedSessionId ? [{
      label: 'Review gap analysis',
      sub: 'See your strengths & gaps',
      path: `/assessment/result/${introData.completedSessionId}`,
      primary: false,
      accent: 'violet',
    }] : [{
      label: 'Take assessment',
      sub: 'Calibrate your knowledge level',
      path: '/assessment',
      primary: false,
      accent: 'violet',
    }]),
    {
      label: 'Edit profile',
      sub: 'Update role or experience',
      path: '/onboarding',
      primary: false,
      accent: 'neutral',
    },
  ]

  const dotColor = {
    emerald: 'bg-emerald-400',
    sky:     'bg-sky-400',
    violet:  'bg-violet-400',
    amber:   'bg-amber-400',
    neutral: 'bg-neutral-600',
  }

  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
      <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">Quick Actions</p>

      <div className="flex flex-col gap-2">
        {actions.map((action) => (
          <button
            key={action.path}
            onClick={() => navigate(action.path)}
            className={
              action.primary
                ? 'w-full rounded-xl bg-white px-4 py-3 text-left hover:bg-neutral-100 transition-colors group'
                : 'w-full rounded-xl border border-neutral-800 bg-neutral-800/30 px-4 py-3 text-left hover:bg-neutral-800/60 hover:border-neutral-700 transition-colors group'
            }
          >
            <div className="flex items-center gap-3">
              <span className={`w-2 h-2 rounded-full flex-shrink-0 ${dotColor[action.accent]}`} />
              <div className="flex-1 min-w-0">
                <p className={`text-sm font-medium ${action.primary ? 'text-neutral-900' : 'text-white'}`}>
                  {action.label}
                </p>
                <p className={`text-xs mt-0.5 ${action.primary ? 'text-neutral-500' : 'text-neutral-600'}`}>
                  {action.sub}
                </p>
              </div>
              <ArrowRightIcon className={`w-3.5 h-3.5 flex-shrink-0 opacity-0 group-hover:opacity-100 transition-opacity ${action.primary ? 'text-neutral-400' : 'text-neutral-500'}`} />
            </div>
          </button>
        ))}
      </div>
    </section>
  )
}

// ─── About card ───────────────────────────────────────────────────────────────

function AboutCard() {
  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-5">
      <div>
        <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest mb-2">About Career OS</p>
        <p className="text-sm text-neutral-300 leading-relaxed">
          A personalized AI coaching system that guides software engineers from their current role to their
          dream company — through structured assessment, gap analysis, and daily accountability.
        </p>
      </div>

      <div className="flex flex-col gap-2.5">
        {[
          { n: '01', title: 'Profile Setup',     desc: 'Define your target role and timeline' },
          { n: '02', title: 'Resume Analysis',   desc: 'AI extracts your existing skill set' },
          { n: '03', title: 'Skill Assessment',  desc: '30-question quiz calibrated to your role' },
          { n: '04', title: 'Gap Analysis',      desc: 'AI identifies your weakest areas to fix' },
          { n: '05', title: 'Learning Roadmap',  desc: 'Week-by-week plan prioritized by gaps' },
          { n: '06', title: 'Daily Updates',     desc: 'Log progress · Get AI coaching every 3 days' },
        ].map(({ n, title, desc }) => (
          <div key={n} className="flex items-start gap-3">
            <span className="text-[10px] font-bold text-neutral-700 w-5 pt-0.5 flex-shrink-0">{n}</span>
            <div className="min-w-0">
              <span className="text-xs font-medium text-neutral-300">{title}</span>
              <span className="text-neutral-700 text-xs mx-1.5">·</span>
              <span className="text-xs text-neutral-600">{desc}</span>
            </div>
          </div>
        ))}
      </div>
    </section>
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

function ArrowRightIcon({ className = 'w-4 h-4' }) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className={className}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
    </svg>
  )
}
