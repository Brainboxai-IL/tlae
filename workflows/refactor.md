# Refactor Workflow

> Use only for **behavior-preserving** changes. If behavior changes, use `feature-change.md` instead.
> All steps in the SKILL.md "Default Operating Loop" still apply. This file lists only the deltas specific to refactors.

## Delta from default loop

### Definition

A refactor changes **structure without changing externally visible behavior**. If a single test would notice the change, it's not a refactor .  it's a feature change.

### Pre-conditions

Before starting:

1. **Behavior must be tested.** If there are no tests covering the area, your first move is to add characterization tests, then refactor. A refactor on untested code is a rewrite in disguise.
2. **Define what "behavior" means here.** Public API, return values, side effects, exception types, log lines that downstream relies on. Write it down.

### What changes about risk

- Add **+1** to base if you're refactoring a public API surface (even if behavior is preserved, the structure is consumed externally).
- The "no tests" modifier is **non-negotiable**: if there are no tests, refactor is Risk 4 minimum until you've added them.

### Plan template (refactor-specific)

```md
# Refactor Plan

## Target
Which file/module/concept.

## Behavior to preserve
Bullet list. If unsure, write "I will not preserve X without explicit approval."

## Current pain
Why refactor now? (duplication, complexity, blocked feature, perf hot path)

## Approach
What changes structurally.

## Public API impact
None / list of consumers.

## Test strategy
Which existing tests cover this. If gaps, what tests I'll add first.

## Steps
Smallest sequence of commits. Each step compiles and passes tests.

## Rollback
Per step.
```

### Hard refusals

- No behavior changes mixed in. If you spot a bug while refactoring, **note it, don't fix it here**.
- No formatting-only rewrites disguised as refactors.
- No dependency changes.
- No migrations.
- No "while we're at it" scope expansion.
