import { useState, useEffect, useMemo } from 'react'
import { useNavigate } from 'react-router-dom'
import api from '../services/api'

const CATEGORY_ORDER = ['DSA', 'System Design', 'Behavioral', 'Language/Framework', 'Other']

const CATEGORY_STYLE = {
  'DSA':                'bg-emerald-500/10 border-emerald-500/20 text-emerald-400',
  'System Design':      'bg-sky-500/10 border-sky-500/20 text-sky-400',
  'Behavioral':         'bg-violet-500/10 border-violet-500/20 text-violet-400',
  'Language/Framework': 'bg-amber-500/10 border-amber-500/20 text-amber-400',
  'Other':              'bg-neutral-700/40 border-neutral-600/60 text-neutral-400',
}

function todayIso() {
  return new Date().toISOString().slice(0, 10)
}

function friendlyDate(dateStr) {
  if (!dateStr) return '—'
  const [y, m, d] = dateStr.split('-').map(Number)
  return new Date(y, m - 1, d).toLocaleDateString('en-US', {
    weekday: 'short', month: 'short', day: 'numeric',
  })
}

function groupByCategory(items) {
  const map = {}
  CATEGORY_ORDER.forEach((cat) => { map[cat] = [] })
  items.forEach((item) => {
    const cat = item.category in map ? item.category : 'Other'
    map[cat].push(item)
  })
  return CATEGORY_ORDER
    .map((cat) => ({ category: cat, items: map[cat] }))
    .filter((g) => g.items.length > 0)
}

// ─── Page ─────────────────────────────────────────────────────────────────────

export default function DailyUpdatePage() {
  const navigate = useNavigate()
  const [pageState, setPageState] = useState('loading') // loading | ready | error
  const [error, setError] = useState('')
  const [roadmapItems, setRoadmapItems] = useState([])
  const [updates, setUpdates] = useState([])
  const [analysis, setAnalysis] = useState(null)

  useEffect(() => { loadAll() }, [])

  async function loadAll() {
    setPageState('loading')
    try {
      const [roadmapRes, updatesRes, analysisRes] = await Promise.allSettled([
        api.get('/api/roadmap'),
        api.get('/api/daily-updates'),
        api.get('/api/daily-updates/analysis'),
      ])

      if (roadmapRes.status === 'fulfilled') {
        setRoadmapItems(roadmapRes.value.data.weeks.flatMap((w) => w.items))
      }
      if (updatesRes.status === 'fulfilled') {
        setUpdates(updatesRes.value.data)
      }
      if (analysisRes.status === 'fulfilled') {
        setAnalysis(analysisRes.value.data)
      }
      setPageState('ready')
    } catch {
      setError('Failed to load. Please try again.')
      setPageState('error')
    }
  }

  function onUpdateSaved(update) {
    setUpdates((prev) => {
      const idx = prev.findIndex((u) => u.date === update.date)
      if (idx >= 0) return prev.map((u, i) => (i === idx ? update : u))
      return [update, ...prev].sort((a, b) => b.date.localeCompare(a.date))
    })
  }

  const today = todayIso()
  const todayUpdate = updates.find((u) => u.date === today) ?? null
  const totalHoursAll = updates.reduce((sum, u) => sum + Number(u.totalHours || 0), 0)
  const thisWeekCount = updates.filter((u) => {
    const d = new Date(u.date + 'T00:00:00')
    const cutoff = new Date(); cutoff.setDate(cutoff.getDate() - 6); cutoff.setHours(0, 0, 0, 0)
    return d >= cutoff
  }).length

  return (
    <div className="min-h-screen bg-neutral-950 flex items-start justify-center px-4 py-10 relative overflow-hidden">
      <div className="absolute -top-10 -left-10 w-40 h-40 rotate-12 opacity-60 [clip-path:polygon(50%_0%,0%_100%,100%_100%)] bg-gradient-to-br from-neutral-700 to-neutral-900" />
      <div className="absolute -bottom-16 -right-10 w-56 h-56 -rotate-12 opacity-60 [clip-path:polygon(50%_0%,0%_100%,100%_100%)] bg-gradient-to-br from-neutral-700 to-neutral-900" />

      <div className="relative w-full max-w-2xl flex flex-col gap-5">
        {/* Logo */}
        <div className="flex items-center gap-2">
          <span className="w-8 h-8 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center">
            <span className="w-3 h-3 rounded-full bg-emerald-400" />
          </span>
          <span className="text-white font-semibold tracking-wide">Career OS</span>
        </div>

        {pageState === 'loading' && <LoadingSkeleton />}
        {pageState === 'error' && (
          <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-4">
            <div className="rounded-lg bg-rose-500/10 border border-rose-500/30 px-4 py-3 text-sm text-rose-400">
              {error}
            </div>
            <button
              onClick={loadAll}
              className="w-full rounded-lg bg-white px-4 py-2.5 text-sm font-medium text-neutral-900 hover:bg-neutral-200 transition-colors"
            >
              Try again
            </button>
          </div>
        )}
        {pageState === 'ready' && (
          <>
            <StatsCard total={updates.length} hours={totalHoursAll} thisWeek={thisWeekCount} />
            <LogCard
              key={todayUpdate?.id ?? 'new'}
              roadmapItems={roadmapItems}
              existingUpdate={todayUpdate}
              onSaved={onUpdateSaved}
            />
            <AnalysisCard analysis={analysis} onRefresh={setAnalysis} />
            {updates.length > 0 && <HistorySection updates={updates} />}
            <div className="pb-4">
              <button
                onClick={() => navigate('/roadmap')}
                className="w-full rounded-lg border border-neutral-700 px-4 py-2.5 text-sm font-medium text-neutral-400 hover:text-white hover:border-neutral-600 transition-colors"
              >
                Back to roadmap
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  )
}

// ─── Loading skeleton ─────────────────────────────────────────────────────────

function LoadingSkeleton() {
  return (
    <div className="flex flex-col gap-4">
      <div className="h-20 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
      <div className="h-64 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
      <div className="h-40 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
      <div className="h-16 rounded-2xl bg-neutral-900/80 border border-neutral-800 animate-pulse" />
    </div>
  )
}

// ─── Stats card ───────────────────────────────────────────────────────────────

function StatsCard({ total, hours, thisWeek }) {
  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-5">
      <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest mb-4">
        Daily Updates
      </p>
      <div className="grid grid-cols-3 gap-4">
        <StatItem value={total} label="Days logged" />
        <StatItem value={hours.toFixed(1) + 'h'} label="Hours total" />
        <StatItem value={thisWeek} label="Days this week" />
      </div>
    </section>
  )
}

function StatItem({ value, label }) {
  return (
    <div className="flex flex-col gap-1">
      <span className="text-2xl font-semibold text-white">{value}</span>
      <span className="text-xs text-neutral-500">{label}</span>
    </div>
  )
}

// ─── Log card ─────────────────────────────────────────────────────────────────

function LogCard({ roadmapItems, existingUpdate, onSaved }) {
  const [isEditing, setIsEditing] = useState(!existingUpdate)
  const [saving, setSaving] = useState(false)
  const [saveError, setSaveError] = useState('')

  // { [roadmapItemId]: hoursString }
  const [selected, setSelected] = useState(() =>
    existingUpdate
      ? Object.fromEntries(existingUpdate.items.map((i) => [i.roadmapItemId, String(i.hours)]))
      : {}
  )
  const [notes, setNotes] = useState(existingUpdate?.notes ?? '')

  // Sync form when existingUpdate changes (e.g. after save)
  useEffect(() => {
    if (existingUpdate) {
      setSelected(Object.fromEntries(existingUpdate.items.map((i) => [i.roadmapItemId, String(i.hours)])))
      setNotes(existingUpdate.notes ?? '')
    }
  }, [existingUpdate])

  const grouped = useMemo(() => groupByCategory(roadmapItems), [roadmapItems])
  const selectedCount = Object.keys(selected).length
  const totalHours = Object.values(selected).reduce((sum, h) => sum + (parseFloat(h) || 0), 0)

  function toggleItem(itemId) {
    setSelected((prev) => {
      if (itemId in prev) {
        const copy = { ...prev }
        delete copy[itemId]
        return copy
      }
      return { ...prev, [itemId]: '1' }
    })
  }

  function setHours(itemId, value) {
    setSelected((prev) => ({ ...prev, [itemId]: value }))
  }

  async function handleSubmit() {
    setSaveError('')
    if (selectedCount === 0) { setSaveError('Select at least one topic.'); return }
    if (totalHours <= 0) { setSaveError('Enter hours for at least one topic.'); return }

    const items = Object.entries(selected).map(([id, h]) => ({
      roadmapItemId: id,
      hours: parseFloat(h) || 0,
    }))
    const payload = {
      date: todayIso(),
      totalHours,
      notes: notes.trim() || null,
      items,
    }

    setSaving(true)
    try {
      const res = existingUpdate
        ? await api.put(`/api/daily-updates/${todayIso()}`, payload)
        : await api.post('/api/daily-updates', payload)
      onSaved(res.data)
      setIsEditing(false)
    } catch (err) {
      setSaveError(err.response?.data?.error ?? 'Failed to save. Please try again.')
    } finally {
      setSaving(false)
    }
  }

  const today = todayIso()

  // ── Summary view (logged, not editing) ──
  if (existingUpdate && !isEditing) {
    return (
      <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6">
        <div className="flex items-center justify-between gap-3 mb-4">
          <div>
            <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">Today's Update</p>
            <p className="text-sm text-neutral-400 mt-0.5">{friendlyDate(today)}</p>
          </div>
          <div className="flex items-center gap-2">
            <span className="flex items-center gap-1.5 bg-emerald-500/10 border border-emerald-500/20 rounded-lg px-3 py-1.5">
              <CheckIcon className="w-3 h-3 text-emerald-400" />
              <span className="text-xs font-medium text-emerald-400">Logged</span>
            </span>
            <button
              onClick={() => setIsEditing(true)}
              className="text-xs text-neutral-500 hover:text-neutral-300 px-2 py-1.5 transition-colors"
            >
              Edit
            </button>
          </div>
        </div>

        <div className="flex flex-col gap-3">
          <div className="flex items-center gap-2">
            <ClockIcon />
            <span className="text-sm font-medium text-white">{existingUpdate.totalHours}h studied</span>
          </div>
          <div className="flex flex-wrap gap-1.5">
            {existingUpdate.items.map((item) => (
              <span
                key={item.id}
                className={`text-xs border rounded-full px-2.5 py-1 ${CATEGORY_STYLE[item.category] ?? CATEGORY_STYLE['Other']}`}
              >
                {item.topicName} · {item.hours}h
              </span>
            ))}
          </div>
          {existingUpdate.notes && (
            <p className="text-xs text-neutral-400 leading-relaxed border-t border-neutral-800 pt-3">
              {existingUpdate.notes}
            </p>
          )}
        </div>
      </section>
    )
  }

  // ── Form view ──
  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-5">
      <div className="flex items-center justify-between gap-3">
        <div>
          <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">
            {existingUpdate ? "Edit Today's Update" : "Log Today's Update"}
          </p>
          <p className="text-sm text-neutral-400 mt-0.5">{friendlyDate(today)}</p>
        </div>
        {existingUpdate && (
          <button
            onClick={() => setIsEditing(false)}
            className="text-xs text-neutral-500 hover:text-neutral-300 transition-colors"
          >
            Cancel
          </button>
        )}
      </div>

      {roadmapItems.length === 0 ? (
        <div className="rounded-lg bg-amber-500/10 border border-amber-500/20 px-4 py-3 text-sm text-amber-400">
          Generate your roadmap first to see topics here.
        </div>
      ) : (
        <div className="flex flex-col gap-4">
          <p className="text-xs text-neutral-500">Select topics you studied today</p>
          {grouped.map((group) => (
            <CategoryGroup
              key={group.category}
              group={group}
              selected={selected}
              onToggle={toggleItem}
              onHoursChange={setHours}
            />
          ))}
        </div>
      )}

      <div className="flex flex-col gap-1.5">
        <label className="text-xs text-neutral-500">Notes (optional)</label>
        <textarea
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
          placeholder="What clicked today? What was hard?"
          rows={2}
          className="w-full bg-neutral-800/60 border border-neutral-700 rounded-lg px-3 py-2.5 text-sm text-white placeholder:text-neutral-600 focus:outline-none focus:border-neutral-600 resize-none"
        />
      </div>

      {selectedCount > 0 && (
        <div className="flex items-center gap-3 bg-neutral-800/40 rounded-lg px-4 py-2.5">
          <span className="text-xs text-neutral-400">
            {selectedCount} topic{selectedCount !== 1 ? 's' : ''} selected
          </span>
          <span className="text-xs text-neutral-700">·</span>
          <span className="text-xs font-medium text-white">{totalHours.toFixed(1)}h total</span>
        </div>
      )}

      {saveError && (
        <div className="rounded-lg bg-rose-500/10 border border-rose-500/20 px-3 py-2.5 text-xs text-rose-400">
          {saveError}
        </div>
      )}

      <button
        onClick={handleSubmit}
        disabled={saving || selectedCount === 0}
        className="w-full rounded-lg bg-white px-4 py-2.5 text-sm font-medium text-neutral-900 hover:bg-neutral-200 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
      >
        {saving ? 'Saving…' : existingUpdate ? 'Save changes' : 'Log update'}
      </button>
    </section>
  )
}

// ─── Category group (inside topic picker) ────────────────────────────────────

function CategoryGroup({ group, selected, onToggle, onHoursChange }) {
  const [open, setOpen] = useState(true)
  const selectedInGroup = group.items.filter((i) => i.id in selected).length

  return (
    <div className="flex flex-col gap-1">
      <button
        onClick={() => setOpen((o) => !o)}
        className="flex items-center gap-2 text-left py-0.5"
      >
        <span className={`text-xs border rounded-full px-2.5 py-0.5 ${CATEGORY_STYLE[group.category] ?? CATEGORY_STYLE['Other']}`}>
          {group.category}
        </span>
        {selectedInGroup > 0 && (
          <span className="text-xs text-neutral-500">{selectedInGroup} selected</span>
        )}
        <ChevronDownIcon
          className={`w-3 h-3 text-neutral-600 ml-auto transition-transform duration-200 ${open ? 'rotate-180' : ''}`}
        />
      </button>

      {open && (
        <div className="flex flex-col mt-1">
          {group.items.map((item) => {
            const isSelected = item.id in selected
            return (
              <div
                key={item.id}
                className={`flex items-center gap-3 rounded-lg px-3 py-2.5 transition-colors ${
                  isSelected ? 'bg-neutral-800/60' : 'hover:bg-neutral-800/20'
                }`}
              >
                <button
                  onClick={() => onToggle(item.id)}
                  className={`w-5 h-5 rounded-md border-2 flex items-center justify-center flex-shrink-0 transition-colors ${
                    isSelected
                      ? 'bg-emerald-500 border-emerald-500'
                      : 'border-neutral-600 hover:border-neutral-500'
                  }`}
                >
                  {isSelected && <CheckIcon className="w-2.5 h-2.5 text-white" />}
                </button>

                <span
                  onClick={() => onToggle(item.id)}
                  className={`text-sm flex-1 leading-snug cursor-pointer select-none transition-colors ${
                    isSelected ? 'text-white' : 'text-neutral-400 hover:text-neutral-300'
                  }`}
                >
                  {item.topicName}
                </span>

                {isSelected && (
                  <div className="flex items-center gap-1.5 flex-shrink-0" onClick={(e) => e.stopPropagation()}>
                    <input
                      type="number"
                      min="0"
                      max="24"
                      step="0.5"
                      value={selected[item.id]}
                      onChange={(e) => onHoursChange(item.id, e.target.value)}
                      className="w-14 bg-neutral-700/60 border border-neutral-600 rounded-md px-2 py-1 text-xs text-white text-center focus:outline-none focus:border-neutral-500"
                    />
                    <span className="text-xs text-neutral-500">h</span>
                  </div>
                )}
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}

// ─── Analysis card ────────────────────────────────────────────────────────────

function AnalysisCard({ analysis, onRefresh }) {
  const [refreshing, setRefreshing] = useState(false)

  async function handleRefresh() {
    setRefreshing(true)
    try {
      const r = await api.get('/api/daily-updates/analysis')
      onRefresh(r.data)
    } catch {
      // silent — user can try again
    } finally {
      setRefreshing(false)
    }
  }

  if (!analysis) return null

  if (analysis.status === 'INSUFFICIENT_DATA') {
    return (
      <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6">
        <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest mb-5">
          Progress Analysis
        </p>
        <div className="flex flex-col items-center gap-4 py-4 text-center">
          <div className="w-14 h-14 rounded-full bg-neutral-800 border border-neutral-700 flex items-center justify-center">
            <span className="text-xl font-bold text-neutral-300">{analysis.updatesNeeded}</span>
          </div>
          <div>
            <p className="text-sm font-medium text-white">
              {analysis.updatesNeeded} more {analysis.updatesNeeded === 1 ? 'update' : 'updates'} to unlock
            </p>
            <p className="text-xs text-neutral-500 mt-1.5 max-w-xs">
              Log your daily study sessions and AI will analyze your progress once you reach 3 updates.
            </p>
          </div>
          <div className="flex gap-1.5">
            {[1, 2, 3].map((n) => (
              <div
                key={n}
                className={`w-2 h-2 rounded-full ${
                  n <= 3 - analysis.updatesNeeded ? 'bg-emerald-500' : 'bg-neutral-700'
                }`}
              />
            ))}
          </div>
        </div>
      </section>
    )
  }

  // READY
  const a = analysis.analysis
  return (
    <section className="bg-neutral-900/80 border border-neutral-800 rounded-2xl p-6 flex flex-col gap-5">
      <div className="flex items-start justify-between gap-3">
        <div>
          <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest">
            Progress Analysis
          </p>
          <p className="text-xs text-neutral-600 mt-1">
            {friendlyDate(analysis.fromDate)} → {friendlyDate(analysis.toDate)}
            {' · '}{analysis.updatesCount} updates{' · '}{Number(analysis.totalHours).toFixed(1)}h
          </p>
        </div>
        <button
          onClick={handleRefresh}
          disabled={refreshing}
          className="flex items-center gap-1.5 text-xs text-neutral-500 hover:text-neutral-300 disabled:opacity-40 transition-colors flex-shrink-0 mt-0.5"
        >
          <RefreshIcon className={refreshing ? 'animate-spin' : ''} />
          Refresh
        </button>
      </div>

      <p className="text-sm text-neutral-300 leading-relaxed">{a?.summary}</p>

      {a?.hoursPaceComment && (
        <div className="flex gap-2.5 bg-neutral-800/50 border border-neutral-700/40 rounded-lg px-3 py-2.5">
          <ClockIcon />
          <p className="text-xs text-neutral-400 leading-relaxed">{a.hoursPaceComment}</p>
        </div>
      )}

      {a?.strengths?.length > 0 && (
        <div className="flex flex-col gap-2">
          <p className="text-xs text-neutral-500 font-medium">What's working</p>
          <div className="flex flex-col gap-1.5">
            {a.strengths.map((s, i) => (
              <div
                key={i}
                className="flex gap-2.5 bg-emerald-500/5 border border-emerald-500/15 rounded-xl px-3 py-2.5"
              >
                <span className="w-5 h-5 rounded-full bg-emerald-500/20 border border-emerald-500/30 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <CheckIcon className="w-2.5 h-2.5 text-emerald-400" />
                </span>
                <p className="text-sm text-neutral-300 leading-snug">{s}</p>
              </div>
            ))}
          </div>
        </div>
      )}

      {a?.areasToImprove?.length > 0 && (
        <div className="flex flex-col gap-2">
          <p className="text-xs text-neutral-500 font-medium">Areas to improve</p>
          <div className="flex flex-col gap-1.5">
            {a.areasToImprove.map((s, i) => (
              <div
                key={i}
                className="flex gap-2.5 bg-amber-500/5 border border-amber-500/15 rounded-xl px-3 py-2.5"
              >
                <span className="w-5 h-5 rounded-full bg-amber-500/20 border border-amber-500/30 flex items-center justify-center flex-shrink-0 mt-0.5">
                  <span className="text-[10px] font-bold text-amber-400">!</span>
                </span>
                <p className="text-sm text-neutral-300 leading-snug">{s}</p>
              </div>
            ))}
          </div>
        </div>
      )}

      {a?.recommendedFocus?.length > 0 && (
        <div className="flex flex-col gap-2">
          <p className="text-xs text-neutral-500 font-medium">Study next</p>
          <div className="flex flex-wrap gap-1.5">
            {a.recommendedFocus.map((f, i) => (
              <span
                key={i}
                className="text-xs border border-sky-500/20 bg-sky-500/10 text-sky-400 rounded-full px-2.5 py-1"
              >
                → {f}
              </span>
            ))}
          </div>
        </div>
      )}
    </section>
  )
}

// ─── History section ──────────────────────────────────────────────────────────

function HistorySection({ updates }) {
  return (
    <div className="flex flex-col gap-3">
      <p className="text-xs font-medium text-neutral-500 uppercase tracking-widest px-1">
        Update History
      </p>
      {updates.map((update) => (
        <HistoryEntry key={update.id} update={update} />
      ))}
    </div>
  )
}

function HistoryEntry({ update }) {
  const [open, setOpen] = useState(false)
  const isToday = update.date === todayIso()

  return (
    <div className="bg-neutral-900/80 border border-neutral-800 rounded-2xl overflow-hidden">
      <button
        onClick={() => setOpen((o) => !o)}
        className="w-full flex items-center justify-between gap-3 px-5 py-4 hover:bg-neutral-800/40 transition-colors text-left"
      >
        <div className="flex items-center gap-2.5 min-w-0">
          <span className="text-sm font-medium text-white">{friendlyDate(update.date)}</span>
          {isToday && (
            <span className="text-xs bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 rounded-full px-2 py-0.5">
              Today
            </span>
          )}
        </div>
        <div className="flex items-center gap-2.5 flex-shrink-0">
          <span className="text-xs text-white font-medium">{update.totalHours}h</span>
          <span className="text-xs text-neutral-600">
            {update.items?.length ?? 0} topic{(update.items?.length ?? 0) !== 1 ? 's' : ''}
          </span>
          <ChevronDownIcon
            className={`w-4 h-4 text-neutral-500 transition-transform duration-200 ${open ? 'rotate-180' : ''}`}
          />
        </div>
      </button>

      {open && (
        <div className="border-t border-neutral-800 px-5 py-4 flex flex-col gap-3">
          <div className="flex flex-wrap gap-1.5">
            {update.items?.map((item) => (
              <span
                key={item.id}
                className={`text-xs border rounded-full px-2.5 py-1 ${CATEGORY_STYLE[item.category] ?? CATEGORY_STYLE['Other']}`}
              >
                {item.topicName} · {item.hours}h
              </span>
            ))}
          </div>
          {update.notes && (
            <p className="text-xs text-neutral-400 leading-relaxed border-t border-neutral-800/60 pt-3">
              {update.notes}
            </p>
          )}
        </div>
      )}
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

function RefreshIcon({ className = 'w-3 h-3' }) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className={className}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99" />
    </svg>
  )
}

function ClockIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5"
      className="w-4 h-4 text-neutral-500 flex-shrink-0 mt-0.5">
      <path strokeLinecap="round" strokeLinejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
  )
}
