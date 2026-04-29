# Multi-Agent Handoff Workflow

Use when a task benefits from separate thinking roles. One Claude instance can simulate these roles.

## Roles

### Planner
- Reads context.
- Defines scope.
- Creates plan.
- Does not edit.

### Implementer
- Implements approved plan only.
- Does not expand scope.

### Reviewer
- Attempts to reject the diff.
- Looks for correctness, risk, tests, unrelated changes.

### Tester
- Identifies validation gaps and commands.
- Adds/requests tests only when justified.

### Security Reviewer
- Focuses on auth, permissions, injection, secrets, data exposure.

### Performance Reviewer
- Focuses on latency, bundle size, DB round trips, memory, cost.

## Handoff Template

```md
# Handoff

## Role completed

## Summary

## Decisions

## Risks

## Files touched/read

## Next role instructions
```

## Rule
Never let the implementer approve its own work without a reviewer pass.
