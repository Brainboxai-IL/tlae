# Diff Review Checklist

Use after every edit.

## Changed Files
For each changed file:
- Why was it necessary?
- Is it directly related to the task?
- Could it be smaller?
- Does it change behavior?
- Does it need tests?

## Correctness
- Handles expected cases.
- Handles edge cases.
- Does not mask errors.
- Does not introduce race conditions.

## Safety
- No unrelated refactor.
- No new dependency unless approved.
- No generated files changed unless expected.
- No secrets/PII exposed.
- No auth/permissions regression.

## Validation
- Commands run.
- Results.
- Failures explained.
- Manual test steps.

## Output

```md
# Diff Summary

## Files changed

## Why each file changed

## Behavior changed

## Validation run

## Risks

## Manual test steps

## Follow-up
```
