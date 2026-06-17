export default function IconInput({ icon, error, ...inputProps }) {
  return (
    <div>
      <div className="relative">
        <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-neutral-500">
          {icon}
        </span>
        <input
          {...inputProps}
          className="w-full rounded-lg bg-neutral-800/80 border border-neutral-700 pl-10 pr-3 py-2.5 text-sm text-white placeholder-neutral-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/50 focus:border-emerald-500/50 transition-colors"
        />
      </div>
      {error && <p className="mt-1 text-xs text-red-400">{error}</p>}
    </div>
  )
}
