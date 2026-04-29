# PR Review Workflow

Use for reviewing diffs, pull requests, or generated code.

## Review Priorities
1. Correctness.
2. Security.
3. Data integrity.
4. Auth/authorization.
5. Backward compatibility.
6. Production risk.
7. Test quality.
8. Performance.
9. Observability.
10. Maintainability.

## Output Format

```md
# PR Review

## Summary

## Overall risk
Low | Medium | High | Critical

## Blockers

## High severity

## Medium severity

## Low severity

## Nice to have

## Missing tests

## Questions for author

## Suggested follow-up
```

## Rules
- Do not nitpick style unless it impacts maintainability.
- Flag unrelated changes.
- Flag new dependencies.
- Flag missing auth checks.
- Flag untested behavior changes.
- Ask for evidence when claims are unverified.
