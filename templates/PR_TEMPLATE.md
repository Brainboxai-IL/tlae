# PR: <title>

## Summary
What this PR does, in one sentence.

## Why
The motivation. Link the issue / ADR / customer ticket if relevant.

## What changed
Bullet list of the actual changes, grouped by area.

## Risk score
N/10 with one-line breakdown.
Example: `5/10 — base 3 (public API change) + 2 (live with paying customers) + 1 (no tests) - 1 (reversible / feature-flagged)`

See `workflows/risk-calculator.md` for the formula.

## Validation
- [ ] Typecheck
- [ ] Lint
- [ ] Tests (new + existing)
- [ ] Build
- [ ] Manual QA

## Screenshots / recordings
For any UI-visible change.

## Security / privacy
What sensitive surface (auth, billing, PHI/PII, secrets) this PR touches, and how it was handled. Write "none" if it doesn't apply.

## Data / migration
Schema changes, backfill plan, rollout order. Write "none" if it doesn't apply.

## Rollback plan
How to undo this PR if it goes wrong. Be specific (commit, feature flag, migration down step).

## Notes for reviewer
Anything non-obvious about the diff that would help a reviewer.
