# Architecture Decision Workflow

Use for cross-cutting decisions, new dependencies, public APIs, database shape, auth flow, state management, caching, background jobs, deployment strategy, or anything hard to reverse.

## Rule
Do not implement first. Write a short ADR first.

## ADR Shape

```md
# ADR: <decision title>

## Status
Proposed | Accepted | Superseded

## Context
What problem are we solving? What constraints exist?

## Goals

## Non-goals

## Options
### Option A
Pros:
Cons:
Risks:

### Option B
Pros:
Cons:
Risks:

### Option C
Pros:
Cons:
Risks:

## Decision
Chosen option and why.

## Tradeoffs

## Security / privacy implications

## Data / migration implications

## Observability implications

## Rollback plan

## Follow-up work
```

## Decision Quality Checklist
- Is this reversible?
- Does it add dependency or platform lock-in?
- Does it affect data model?
- Does it affect auth/permissions?
- Does it need feature flags?
- Does it need monitoring?
- Does it need phased rollout?
