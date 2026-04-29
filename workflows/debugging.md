# Debugging Workflow

Use for bugs that are not active incidents. For production incidents, use `workflows/incident-debugging.md`.

> Severity is read from `.tlae/profile.md`. The same bug in a side project is not the same bug in fintech with paying customers.

## Required Flow
1. **Capture** the exact symptom / error / stack trace.
2. **Identify** when it happens — every time, sometimes, after specific action?
3. **Trace** the related flow with Read/Grep.
4. **List hypotheses** ranked by likelihood, not by what's easiest to check.
5. **Identify evidence** needed to confirm or rule out each hypothesis.
6. **Inspect** the minimum files needed.
7. **Propose** the minimum fix.
8. **Implement** only after the plan is accepted, or for trivial obvious fixes (typo, off-by-one in a guard).
9. **Add a regression test** when practical. If the profile shows `production_state == live-with-paying-customers`, **a regression test is required** — not optional.
10. **Validate** with the profile's chain.

## Output Before Editing

```md
# Debug Plan

## Symptom
What the user / monitor reports. Include stack trace if available.

## Known facts
What we know is true. (e.g., "happens only on POST /checkout", "started after deploy on YYYY-MM-DD")

## Likely root causes (ranked)
1. ___ (evidence: ___)
2. ___ (evidence: ___)
3. ___ (evidence: ___)

## Evidence to check next
What I'll look at to narrow down.

## Files to inspect
- path/to/file.ts:line

## Minimal fix candidate
What I'd change, assuming hypothesis #1 is correct.

## Validation
How I'll prove the fix works AND didn't break anything else.
```

## Rules
- **Don't shotgun-edit.** Hypothesis → evidence → fix. One thread at a time.
- **Don't fix unrelated errors** you spot in the file. Note them in the response, fix later.
- **Don't rewrite the flow** unless the root cause demands it.
- **Logging adds risk.** If you propose adding logs:
  - In `domain == healthcare` or `fintech`: refuse to log request bodies, params with possible PHI/PII, or auth tokens. Log IDs only.
  - In any domain: log additions are Risk 2 if the route is on a hot path (perf cost) or handles sensitive data.
- **Reproduction first.** If you can't reproduce locally, say so. Don't guess from the stack trace alone unless the cause is obvious.

## When the bug is "fixed"
- Run the validation chain from the profile.
- Confirm the original symptom no longer reproduces.
- If you added a regression test, confirm it FAILS without your fix and PASSES with it. Show both runs.
- Append to `.tlae/LESSONS.md` if the bug surfaced a non-obvious pattern.
