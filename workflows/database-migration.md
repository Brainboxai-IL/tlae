# Database Migration Safety Workflow

Use for schema changes, migrations, data backfills, database writes, indexes, constraints, or changes to data access.

## Hard Rule
Never edit schema/migrations first. Propose a migration plan and wait for explicit approval.

## Required Analysis
1. Current schema.
2. Current read paths.
3. Current write paths.
4. Existing data assumptions.
5. Compatibility needs.
6. Backfill needs.
7. Rollback limitations.
8. Deployment order.
9. Validation queries.

## Plan Template

```md
# Migration Plan

## Current state

## Desired state

## Risk level

## Compatibility strategy

## Migration steps

## Backfill plan

## Deployment order

## Rollback plan

## Validation queries

## Application code changes

## Monitoring / alerts
```

## Zero-Downtime Preference
Prefer expand/contract:
1. Add nullable/new structures.
2. Deploy app writing both/reading compatible.
3. Backfill.
4. Switch reads.
5. Remove old structures later.

## Stop Conditions
- Destructive migration.
- Non-null column without default/backfill.
- Renaming columns in-place.
- Dropping indexes/constraints.
- Large table rewrite.
- Data deletion.
