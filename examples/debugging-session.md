# Example: Debugging Session

A real transcript on a Node.js API project.

---

**User:**
> Here is the error from production logs:
> `TypeError: Cannot read properties of undefined (reading 'id')`
> at `services/orders.ts:142`
>
> Use the debugging workflow. Don't edit yet.

**Claude:**
> **Loaded profile**: Node.js + Express + Postgres / small team / B2B SaaS / live-with-paying-customers
>
> ## Symptom
> `TypeError: Cannot read properties of undefined (reading 'id')` at `services/orders.ts:142`.
>
> ## Inspection
> Reading `services/orders.ts` lines 130–160.

*(Reads the file.)*

**Claude:**
> ## Known facts
> - Line 142: `const userId = session.user.id;`
> - This service is called from two routes: `/orders/create` and `/orders/list`.
> - The error implies `session` is undefined OR `session.user` is undefined.
>
> ## Likely root causes (ranked)
> 1. **Most likely**: `/orders/list` allows guest users — a `requireAuth` bypass was added last week. `session` is undefined for guests, but `services/orders.ts` assumes it's always present.
>    - Evidence to check: `git log` on the route file; presence of any `requireAuth: false` flag.
> 2. **Possible**: race where session expires between auth middleware and the service call.
>    - Evidence to check: time between request entry and the throw; any session-refresh logic.
> 3. **Less likely**: malformed JWT producing `{ user: undefined }`.
>    - Evidence to check: JWT parsing upstream.
>
> ## Files to inspect next
> - `routes/orders.ts` (the calling routes)
> - `middleware/auth.ts` (session shape)
> - Recent diff on `routes/orders.ts`
>
> ## Minimal fix candidate (for hypothesis #1)
> Make `services/orders.ts:listOrders` accept an optional session and branch:
> - With session → return user's orders
> - Without session → return 401 (or public-listing orders, depending on product intent — needs your call)
>
> ## What I will not touch
> - The auth middleware. If the bug is there, that's Risk 4 — needs explicit approval.
>
> ## Validation
> - Add a regression test: `listOrders` called without a session should not throw.
> - `pnpm test orders` after the fix.
>
> Approve hypothesis #1 investigation? Or do you want me to gather more evidence first?

---

## What this transcript shows

- No edit happened. The agent stopped at "evidence gathering."
- Hypotheses were ranked, not just listed.
- The agent flagged an area it would refuse to touch (auth middleware) without explicit approval.
- A regression test was proposed before the fix, not after.

## Bad behavior the workflow prevents

- **Editing immediately**: "Looks like a null check; I'll add `?.`." That hides the real bug (route ran without auth).
- **Adding `?.` everywhere**: silences the symptom, doesn't fix the cause.
- **Refactoring the unrelated flow** because it was nearby.
