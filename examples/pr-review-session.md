# Example: PR Review Session

A real transcript reviewing a 4-file PR on a B2B SaaS app.

---

**User:**
> Review this diff as a Staff Engineer:
> ```
> +++ app/api/users/route.ts
>   GET: return all users where org_id = ctx.user.org_id
>   POST: create user with role from req.body.role
>   DELETE: delete user where id = req.body.id
>
> +++ lib/email.ts
>   sendInvite(email): no auth check, just sends
>
> +++ db/migrations/20260429_add_users.sql
>   ALTER TABLE users ADD COLUMN role TEXT NOT NULL;
>
> +++ tests/users.test.ts
>   one test: GET returns 200
> ```

**Claude:**
> **Loaded profile**: Next.js + Postgres / small team / B2B SaaS / live-with-paying-customers
>
> # PR Review
>
> ## Overall risk: **Critical** .  do not merge.
>
> ## 🚨 Blockers (must fix)
>
> 1. **DELETE has no authorization check.** `app/api/users/route.ts` accepts an arbitrary `id` from the body and deletes it. Any authenticated user can delete any user, including from other tenants. This is a **tenant-isolation breach**.
>
> 2. **POST accepts `role` from request body without validation.** A user can promote themselves to `admin` by including `"role": "admin"` in the create payload. Privilege escalation.
>
> 3. **Migration is non-nullable on existing data.** `ADD COLUMN role TEXT NOT NULL` will fail on a non-empty `users` table because existing rows have no value. Either provide `DEFAULT` or do an expand/contract migration.
>
> 4. **`sendInvite()` has no auth check.** Anyone with the URL can spam invites to any email. Adds spam-list / deliverability risk.
>
> ## High severity
>
> 5. **Test coverage is one happy-path test.** No test for: unauthorized DELETE, role-escalation POST, cross-tenant GET, migration. For Risk 4 work, this is insufficient.
>
> 6. **No rate limit on POST/DELETE.** A bot can create or delete many users.
>
> ## Medium
>
> 7. GET doesn't paginate. Will time out on tenants with many users.
>
> 8. The migration filename uses today's date .  fine if you're solo, but the team should have a migration numbering convention (sequence number) to avoid race conditions when two PRs land on the same day.
>
> ## Low
>
> 9. `sendInvite` has no return type annotation.
>
> ## Missing tests
> - DELETE without ownership → expect 403
> - POST with `role: "admin"` from a non-admin → expect 403 or stripped role
> - GET as user from org A → must not see org B users
> - Migration tested against a non-empty fixtures DB
>
> ## Questions for author
> - Is the DELETE meant to be admin-only, owner-only, or self-only? The product intent affects the fix.
> - Is `sendInvite` reachable from the public surface, or only via authenticated routes?
>
> ## Suggested follow-up
> Pull the auth/permissions model into a shared middleware. Three of the four files would benefit from it.
>
> ---
>
> **My recommendation**: reject. The blockers are not fixable as drive-by review comments .  they need a redesign of the auth model on these endpoints.

---

## What this transcript shows

- Findings were **grouped by severity**, not just listed flat.
- The reviewer named **the actual security vulnerabilities** with mechanism (tenant breach, privilege escalation), not vague concerns.
- It refused to call this PR "almost ready with some nits" .  it called it Critical and recommended rejection.
- It separated **questions for the author** from **issues**, so the author isn't defensive about the wrong things.
