# Example: First-Run Onboarding Transcript

A real transcript of what a user sees the first time the skill activates on a Next.js + Supabase SaaS project.

---

**User:** *"add a `referrer_url` column to the `signups` table"*

**Claude:** *(detects no `.tlae/profile.md` exists; runs onboarding)*

```
Running tlae onboarding...

✓ Wrote draft profile to .tlae/profile.md
✓ Added .tlae/ to .gitignore

Detected:
  languages   = javascript,typescript
  framework   = nextjs
  pkg manager = pnpm
  database    = prisma
  CI          = github-actions
  deployment  = vercel
  test cmd    = pnpm test
```

> Before I touch your task, 3 short questions to set the risk profile:
>
> **1. Team size?**
> (a) Solo / side project
> (b) Small team (2–5)
> (c) Larger team (6+)

**User:** *b*

> **2. Domain?**
> (a) B2C consumer
> (b) B2B SaaS
> (c) Fintech / payments
> (d) Healthcare / regulated
> (e) Internal tool / OSS

**User:** *b*

> **3. Production state?**
> (a) Pre-launch
> (b) Live with users
> (c) Live with paying customers / SLAs

**User:** *c*

**Claude:**
> Profile saved.
>
> **Loaded**: Next.js + Prisma + Vercel / small team / B2B SaaS / live-with-paying-customers
>
> Now back to your task: *add `referrer_url` column to `signups`*.
>
> ## Task classification
> Database schema change.
>
> ## Risk score: **9/10 ⚠️ STOP**
> ```
> base 4   (schema change touches DB)
> +2       live with paying customers
> +1       multi-tenant table (b2b-saas, signups likely has tenant_id)
> +1       no tests cover the new column path yet
> -1       reversible (nullable column, no backfill)
> ```
>
> ## What I will not edit yet
> - `prisma/schema.prisma`
> - The migration file
> - Any code that reads/writes `signups`
>
> ## Inspection plan first
> 1. Read `prisma/schema.prisma` to see current `signups` model
> 2. Check whether `signups.tenant_id` exists (b2b-saas isolation)
> 3. Search `app/api/signups/**` for current write paths
> 4. Check `prisma/migrations/` for migration patterns
>
> ## Proposed plan (for your approval)
> 1. Add `referrerUrl String?` to Prisma schema
> 2. Generate migration: `pnpm prisma migrate dev --name add-referrer-url`
> 3. Update signup write path to capture from request body
> 4. Add tests covering null + populated cases
> 5. Deploy via standard PR → Vercel preview → main
>
> ## Rollback path
> `pnpm prisma migrate resolve --rolled-back add-referrer-url`. Column is nullable so no data loss on rollback.
>
> **Do you approve this plan? Reply `yes` to proceed, or tell me what to change.**

**User:** *"yes, but skip step 4 .  we don't have a test setup yet"*

**Claude:**
> Acknowledged. Proceeding without tests.
>
> ⚠️ Note: skipping tests on a Risk 9 task in production raises the score to **10/10**. I'm logging this in `.tlae/LESSONS.md` so we remember to backfill a test in the next sprint.

*(executes steps 1, 2, 3, 5 .  runs `pnpm typecheck` and `pnpm lint` afterwards .  reports diff summary with files changed and validation results)*

---

## Why this transcript matters

Notice what didn't happen:
- Claude didn't immediately edit the schema.
- Claude didn't invent a test strategy.
- Claude didn't silently make assumptions about tenant isolation.

What did happen:
- The user saw the risk before touching production.
- The user got an explicit choice (skip tests / keep them).
- The skipped step was logged for follow-up.

This is what "Tech Lead" looks like in practice.
