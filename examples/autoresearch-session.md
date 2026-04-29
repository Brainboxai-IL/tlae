# Example: AutoResearch Session

A real transcript reducing a dashboard's bundle size on a Next.js app.

---

**User:**
> Use AutoResearch-inspired mode. Goal: reduce dashboard bundle size. Run up to 3 experiments.

**Claude:**
> **Loaded profile**: Next.js 15 + Vercel / small team / B2B SaaS / live
>
> Setting up the experiment loop. Before any change:
>
> ## Setup
> - **Goal**: reduce `app/dashboard` First Load JS
> - **Baseline command**: `pnpm build` and read the dashboard route entry from the build output
> - **Primary metric**: First Load JS (KB) for `/dashboard`
> - **Secondary metrics**: number of routes affected, build time
> - **Allowed files**: `app/dashboard/**`, `components/dashboard/**`
> - **Forbidden**: any auth, billing, schema, API route, or middleware
> - **Experiment budget**: 3 experiments; abort if no improvement after 2
> - **Keep rule**: keep only changes that reduce KB by ≥ 5% AND pass build
> - **Validation per experiment**: `pnpm build`, `pnpm typecheck`, `pnpm lint`
>
> Running baseline now.

```
pnpm build
...
First Load JS for /dashboard: 412 KB
```

> **Baseline: 412 KB.** Target: reduce by ≥ 5% (≤ 391 KB).

### Experiment 1
> **Hypothesis**: The chart library (Recharts) is imported eagerly. Lazy-loading it should drop ~40 KB on initial load.
>
> **Change**: convert `<RevenueChart>` import in `app/dashboard/page.tsx` to `next/dynamic` with `ssr: false`.

```
pnpm build
First Load JS for /dashboard: 368 KB
```

> **Result: 412 → 368 KB (-44 KB, -10.7%)**. Passes keep rule. Build green. Typecheck green.
>
> **Decision: KEEP.**

### Experiment 2
> **Hypothesis**: `lodash` is fully imported in 3 places where only `debounce` is used. Tree-shake should help.
>
> **Change**: replace `import _ from 'lodash'` with `import debounce from 'lodash/debounce'` in 3 files.

```
pnpm build
First Load JS for /dashboard: 365 KB
```

> **Result: 368 → 365 KB (-3 KB, -0.8%)**. Below 5% threshold per experiment.
>
> **Decision: REVERT.** (The optimization is real but our keep-rule says ≥ 5%.)
>
> Note for follow-up: bundling `lodash-es` instead would tree-shake automatically. Worth a separate ADR.

### Experiment 3
> **Hypothesis**: The dashboard imports `date-fns` in full (~13 KB). We use only 2 functions.
>
> **Change**: replace `import { format, parseISO } from 'date-fns'` with subpath imports.

```
pnpm build
First Load JS for /dashboard: 358 KB
```

> **Result: 365 → 358 KB (-7 KB, -1.9%)**. Below 5% threshold.
>
> **Decision: REVERT.**

## Final summary

| # | Hypothesis | Change | Before | After | Keep? | Validation |
|---|------------|--------|--------|-------|-------|------------|
| 1 | Lazy-load chart | `next/dynamic` | 412 | 368 | ✅ | build + types pass |
| 2 | Tree-shake lodash | subpath import | 368 | 365 | ❌ | below threshold |
| 3 | Tree-shake date-fns | subpath import | 365 | 358 | ❌ | below threshold |

> **Net result: 412 → 368 KB (-44 KB / -10.7%)**, one experiment kept.
>
> **Open follow-ups** (not done in this session):
> - Migrate `lodash` → `lodash-es` (architectural change; needs ADR).
> - Audit other heavy imports (the chart was the obvious one .  others may need `bundle-analyzer`).
>
> **Validation**: `pnpm build`, `pnpm typecheck`, `pnpm lint` all green.
> **Risk score**: 2/10 (UI-only, reversible, no API change, no auth/billing).

---

## What this transcript shows

- The setup happened **before** any change. Goal, metric, threshold, validation .  all defined upfront.
- One variable per experiment.
- A 1.9% improvement was **honestly reverted** because the keep-rule said ≥ 5%. No silently keeping borderline wins.
- The final summary distinguishes "kept" from "reverted" experiments .  no fake claims.
- Follow-ups that would need a separate plan are noted, not silently bundled in.
