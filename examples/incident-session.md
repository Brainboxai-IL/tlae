# Example: Incident Session

A real transcript during a production incident on a Stripe-integrated checkout.

---

**User:**
> Production checkout is failing for ~30% of users after the deploy 20 minutes ago. Use incident debugging mode.

**Claude:**
> **Loaded profile**: Next.js + Supabase + Stripe / small team / fintech / live-with-paying-customers
>
> Switching to **war-room priority order**: safety → mitigation → evidence → root cause → fix → prevention.
>
> ## Severity
> **SEV-1**: revenue impact (checkout = money path), 30% failure rate, fintech domain.
>
> ## Blast radius
> All paying customers attempting checkout. Stripe webhooks may be in inconsistent state.
>
> ## Step 1 — Mitigation FIRST (before any code changes)
>
> What I need from you (1 minute):
> 1. **Can we roll back the last deploy now?** That's the fastest path to recovery if the incident started 20 min after deploy.
> 2. **Is there a feature flag wrapping the new behavior?** If yes, name it and I'll prepare a flip command.
> 3. **What did the deploy change?** Last commit message or PR title is enough.
>
> ## Step 2 — Evidence I'll gather while you answer
> - Recent diff on `app/api/checkout/**` (read-only).
> - Recent diff on `lib/stripe/**` (read-only).
> - Stripe webhook handler (last 50 lines of changes).
>
> ## What I will NOT do
> - Edit billing/payment code directly. Risk 4 in fintech, even mid-incident.
> - Apply a "quick fix" without confirming root cause.
> - Touch the database state of in-flight orders.
>
> Tell me about rollback availability and the flag, please.

**User:**
> No feature flag. We can roll back. The PR added a new "fee calculation" function used during checkout.

**Claude:**
> ## Decision: roll back NOW.
>
> Reasoning:
> - No feature flag → can't flip behavior in place.
> - Fee calculation is currency math (Risk 4 in fintech).
> - 30% failure rate, ongoing revenue loss.
> - A roll-forward fix to currency math without analysis is a bigger risk than the rollback.
>
> ## Recommended commands (you run these — I won't deploy)
> 1. `git revert <last-deploy-sha>` (preserves history)
> 2. Push to your prod branch.
> 3. Confirm Stripe webhook handler version matches the rolled-back app version.
>
> ## After rollback — postmortem track
>
> While you roll back, I'll:
> 1. Read the fee calculation code to understand what broke.
> 2. Identify what test would have caught this (currency math without a property test? float drift? rounding edge case?).
> 3. Write up a fix plan for review — not to implement.
>
> ## Hypothesis (top of my list, to verify after rollback)
> Fee math used floats somewhere it shouldn't, or rounded in the middle of a calculation. Common fintech footgun. Will confirm.
>
> Reply when rollback is in. Then we postmortem.

---

## What this transcript shows

- **Mitigation before fix.** The agent did not propose code changes during the active incident.
- **Refused to edit billing code** mid-incident even when asked.
- **Asked about rollback availability** before doing anything else — the fastest path to recovery.
- **Postmortem track started in parallel** so engineering effort isn't wasted while the rollback runs.
- **No drama, no speculation about cause** until after recovery.
