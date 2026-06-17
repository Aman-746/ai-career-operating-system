export default function AuthLayout({ title, subtitle, footer, children }) {
  return (
    <div className="min-h-screen bg-neutral-950 flex items-center justify-center px-4 py-10 relative overflow-hidden">
      <div className="absolute -top-10 -left-10 w-40 h-40 rotate-12 opacity-60 [clip-path:polygon(50%_0%,0%_100%,100%_100%)] bg-gradient-to-br from-neutral-700 to-neutral-900" />
      <div className="absolute -bottom-16 -right-10 w-56 h-56 -rotate-12 opacity-60 [clip-path:polygon(50%_0%,0%_100%,100%_100%)] bg-gradient-to-br from-neutral-700 to-neutral-900" />

      <div className="relative w-full max-w-4xl grid grid-cols-1 md:grid-cols-2 bg-neutral-900/80 border border-neutral-800 rounded-3xl shadow-2xl overflow-hidden">
        <div className="p-8 md:p-10 flex flex-col">
          <div className="flex items-center gap-2 mb-10">
            <span className="w-8 h-8 rounded-full bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center">
              <span className="w-3 h-3 rounded-full bg-emerald-400" />
            </span>
            <span className="text-white font-semibold tracking-wide">Career OS</span>
          </div>

          <h1 className="text-2xl font-semibold text-white mb-1">{title}</h1>
          <p className="text-sm text-neutral-400 mb-8">{subtitle}</p>

          {children}

          <p className="mt-8 text-sm text-neutral-400">{footer}</p>
        </div>

        <div className="hidden md:flex items-center justify-center p-6 bg-neutral-900">
          <div className="relative w-full h-full rounded-2xl overflow-hidden bg-gradient-to-b from-neutral-800 to-neutral-950 flex items-center justify-center">
            <div className="absolute w-40 h-40 rounded-full bg-emerald-500/20 blur-3xl" />
            <div
              className="relative w-32 h-32 bg-gradient-to-br from-emerald-300 via-emerald-500 to-emerald-700 shadow-[0_0_60px_rgba(16,185,129,0.45)]"
              style={{ clipPath: 'polygon(50% 0%, 0% 100%, 100% 100%)' }}
            />
          </div>
        </div>
      </div>
    </div>
  )
}
