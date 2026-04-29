# Example: Full-Stack Session

A real transcript on a Next.js + Supabase project.

---

**User:**
> Add a loading state to the login form. Don't edit until you inspect and propose a plan.

**Claude:**
> **Loaded profile**: Next.js 15 + Supabase / small team / B2B SaaS / live-with-paying-customers
>
> ## Task classification
> Local UI change (loading state on a form).
>
> ## Risk score: 3/10
> ```
> base: 2 (local feature change, no public API)
> +2: live with paying customers (login is critical path)
> -1: reversible (UI-only, no API change)
> ```
>
> ## Inspection plan
> 1. Find the login form component
> 2. Check whether `useFormStatus` or a similar hook is already used elsewhere
> 3. Check if there's a shared `Button` with built-in pending state
>
> Investigating now.

*(Reads `app/(auth)/login/page.tsx`, `components/ui/Button.tsx`, and one other form already in the codebase.)*

**Claude:**
> ## Findings
> - The form uses Server Actions (`signIn`).
> - `components/ui/Button.tsx` already has a `loading` prop with a spinner.
> - `useFormStatus()` from `react-dom` is the idiomatic Next.js 15 pattern.
>
> ## Proposed plan
> 1. Add a small client component `SubmitButton` that reads `useFormStatus()` and passes `loading` to `Button`.
> 2. Use it in the login form.
> 3. No changes to the server action.
>
> ## Files I'll edit
> - `app/(auth)/login/_components/SubmitButton.tsx` (new, ~18 lines)
> - `app/(auth)/login/page.tsx` (3-line diff)
>
> ## Files I will NOT touch
> - The `signIn` server action (auth-adjacent .  Risk 3+).
> - `components/ui/Button.tsx` (out of scope).
>
> ## Validation
> - `pnpm typecheck`
> - `pnpm lint`
> - Manual test: submit valid + invalid credentials.
>
> Approve to proceed?

**User:** *yes*

*(Edits 2 files. Runs validation.)*

**Claude:**
> ## Done
> - **Files changed**:
>   - `app/(auth)/login/_components/SubmitButton.tsx` (new, 18 lines)
>   - `app/(auth)/login/page.tsx` (3-line diff)
> - **Behavior change**: submit button now disables and shows a spinner during pending submission.
> - **Validation**:
>   - `pnpm typecheck` → ✓
>   - `pnpm lint` → ✓
> - **Risk score**: 3/10 (approved)
> - **Manual test**:
>   1. Open `/login`
>   2. Enter valid creds → button shows spinner, then redirects
>   3. Enter invalid creds → spinner shows, then form re-enables with error
> - **Rollback**: revert the commit; no schema/migration involved.

---

## What this transcript shows

- Risk was computed with a clear breakdown, not just a label.
- Plan came before edits.
- Inspection was scoped .  Claude didn't read the whole repo.
- Auth-adjacent code was explicitly excluded.
- Validation output was shown, not just claimed.
- Rollback path was stated.
