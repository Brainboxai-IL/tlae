# Next.js stack rules

Loaded automatically when `framework == nextjs` in profile.

> Detection: read `package.json > dependencies.next` to know the major version. Next.js 13/14/15/16 differ significantly.

## Default validation chain
1. `{{pm}} run typecheck` (or `tsc --noEmit` if not scripted)
2. `{{pm}} run lint`
3. `{{pm}} test` (only if a test script exists; many Next apps skip unit tests)
4. `{{pm}} run build` for any change touching middleware, routes, layouts, RSC components, or cache directives

## Files that are Risk 2+
- `middleware.ts` — runs on every request
- `app/layout.tsx`, any `(*)/layout.tsx` — affects all child routes
- `next.config.{js,mjs,ts}` — build behavior, headers, redirects, experimental flags
- `app/api/**/*.ts` — public API surface
- `instrumentation.ts` — runtime instrumentation

## Files that are Risk 3+
- Anything under `app/api/auth/**` or routes handling sessions
- `middleware.ts` if it does auth/redirects (a single typo can lock everyone out)
- `.env*` files
- `vercel.json`, `.vercel/` (production deploy config)

## Common anti-patterns to refuse without approval
- Adding `"use client"` to a server component "to make it work" — investigate the cause first; the boundary matters.
- Calling `cookies()` / `headers()` from inside a cached function — breaks PPR/cache (see Next.js 16 rules below).
- Importing `server-only` utilities into client components.
- Wrapping route handlers in middleware logic that should live in the route itself.
- Using `dangerouslySetInnerHTML` with user content without explicit sanitization.

## Next.js 16+ specifics (cacheComponents / Cache Components)

If `next.config.js` has `cacheComponents: true` (or you're on v16+):

- The legacy `export const revalidate` and `export const dynamic = 'force-dynamic'` route segment configs **no longer apply** the same way; the new model is **explicit `'use cache'` directive**.
- `'use cache'` at function or component level marks it cacheable; `cacheLife()` and `cacheTag()` control TTL and invalidation.
- `experimental.ppr` is **removed** — `cacheComponents` is the supported flag.
- A change that adds/removes `'use cache'` is **Risk 2** — it changes data freshness contracts.
- Inside a cached function, do NOT call `cookies()`, `headers()`, `searchParams`, or any dynamic API. Pass them in as args instead.
- Server Actions can pass through cached components only as **props**, not invoked inside them.

If the project is still on Next.js 14/15:
- `revalidate`, `dynamic`, and `experimental.ppr` are still valid; treat changes to them as Risk 2.

## Server Components vs Client Components
- Flipping `"use client"` is **Risk 2** because it changes the rendering boundary.
- Importing a Client Component into a Server Component is fine; the reverse requires careful prop serialization.
- `next/dynamic` with `ssr: false` is **only valid in Client Components** (since Next.js 15.0).

## Server Actions
- Adding a new Server Action: **Risk 2+** because it's a new public mutation endpoint.
- Server Actions get CSRF protection automatically; do not disable it.
- If the action mutates auth/billing/schema, escalate to Risk 3.

## Testing notes
- If no test setup exists and the user requests one: propose **Vitest** first (faster, less config); Jest only if the project already uses it.
- E2E: Playwright is the modern default for new Next.js projects.
- `next/jest` exists but is being deprecated in favor of plain Vitest configs.

## Performance gotchas
- A new dependency on the user-facing critical path: **+1** risk.
- Adding `dynamic = 'force-dynamic'` (or removing `'use cache'`) on a hot route: **Risk 2**.
- Bundle size budget changes need explicit approval if the project has a budget set.

## Vercel-specific
- If `deployment == vercel`:
  - Migrations (Prisma, Drizzle, etc.) typically run as part of the build command — verify in `vercel.json` or `package.json > scripts.build`. If they do, a schema change auto-deploys without a separate step (this is fast, but also dangerous — flag it).
  - Preview deployments share env vars with production by default unless explicitly scoped — verify env scope on any change.
