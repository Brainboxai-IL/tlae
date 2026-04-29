# Feature Change Workflow

Use for small UI, API, product behavior, or full-stack feature changes.

> Validation commands come from `.tlae/profile.md`. Risk modifiers come from the profile + the loaded `domains/<domain>.md` and `stacks/<stack>.md`.

## Required Flow

1. **Inspect** the current implementation. Use Read/Grep, not guessing.
2. **Trace** the relevant data and control flow.
3. **Confirm** existing patterns (see `checklists/api-reality-check.md`).
4. **Classify** risk using `workflows/risk-calculator.md`.
5. **Propose** the smallest safe plan. Show the risk score and breakdown.
6. **Wait** for approval if Risk 2+ or if the user asked for plan-first.
7. **Implement** only the approved scope. Nothing extra.
8. **Validate** with the chain from the profile (typecheck → lint → test).
9. **Report** the diff, validation output, and manual test steps.

## Plan Template

```md
# Feature Plan

## Goal
What we're solving.

## Current behavior
How it works today (file:line if relevant).

## Proposed change
What changes, in plain language.

## Files to edit
- path/to/file.ts (why)
- ...

## Files I will not touch
- path/to/file.ts (because: not in scope / sensitive area / etc.)

## Risk score
N/10 with breakdown.

## Risks and mitigations
- Risk: X. Mitigation: Y.

## Validation
- Commands I'll run (from profile).
- What "passing" means.

## Manual test steps
1. ...
2. ...
3. Expected: ...

## Rollback
How to undo if this goes wrong.
```

## Guardrails
- No new dependency without approval.
- No schema / auth / billing / permission changes without explicit approval.
- No broad refactor while doing a feature change.
- Do not change public API contracts unless asked.
- Prefer existing components / utilities. If you reach for a new abstraction, justify it.

## After implementation
- Run the validation chain from the profile.
- If anything fails, **explain** the failure before fixing it. Don't silently re-run.
- Mark the task done only when `checklists/definition-of-done.md` is satisfied.
