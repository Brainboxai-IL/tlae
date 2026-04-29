# Incident Debugging / War Room Mode

Use for production issues, outages, high-severity bugs, customer-impacting failures, data corruption, billing/auth problems, or urgent regressions.

## Priority Order
1. Safety and blast radius.
2. Mitigation/rollback.
3. Evidence gathering.
4. Root cause.
5. Fix.
6. Prevention.

## Required Questions
- What changed recently?
- What is impacted?
- Who is impacted?
- Is data at risk?
- Is money/billing/auth affected?
- Is there a rollback path?
- What evidence do we have?
- What evidence is missing?
- What is the fastest safe mitigation?

## Output

```md
# Incident Triage

## Severity

## Impact / blast radius

## Timeline

## Recent changes

## Current evidence

## Top hypotheses

## Immediate mitigation

## Rollback path

## Safe fix plan

## Validation

## Follow-up prevention
```

## Rules
- Do not start with code edits.
- Do not make destructive changes.
- Do not change migrations, production config, secrets, or data without explicit approval.
- Prefer rollback/feature flag/mitigation before root-cause refactor.
