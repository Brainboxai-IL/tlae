# Test Strategy Workflow

Use when deciding how to test a change.

## Goal
Protect important behavior with the cheapest reliable test level.

## Test Levels
- Unit: pure logic, parsers, formatters, validation.
- Integration: API route + DB or service boundaries.
- Component: UI states and interactions.
- E2E: critical user journeys only.
- Contract: external API assumptions.
- Manual: visual or environment-dependent checks.

## Output

```md
# Test Strategy

## Behavior to protect

## Risk level

## Existing test setup

## Proposed tests
### Unit
### Integration
### Component
### E2E
### Manual

## Edge cases

## What not to test

## Commands to run
```

## Rules
- Do not add a testing framework without approval.
- Prefer existing patterns.
- Tests must assert real behavior, not implementation details.
- Add regression tests for bugs when feasible.
