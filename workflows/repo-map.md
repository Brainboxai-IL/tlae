# Repo Map Workflow

Use when entering a project, onboarding, or before a large change.

## Goal
Create a concise technical map without editing files.

## Steps
1. Inspect top-level files and folders.
2. Identify package manager and framework.
3. Identify frontend entry points.
4. Identify backend/API entry points.
5. Identify database/data access layer.
6. Identify test framework and validation commands.
7. Identify generated files and folders to avoid.
8. Identify high-risk areas: auth, billing, permissions, migrations, secrets, infra.
9. Summarize architecture in 10-20 bullets.

## Output

```md
# Repo Map

## Purpose

## Stack

## Key folders

## Frontend entry points

## Backend/API entry points

## Data layer

## Tests and validation commands

## Generated/avoid-edit areas

## Risky areas

## Open questions
```

## Rules
- Do not edit.
- Do not read the entire repo if a narrower map is enough.
- Do not infer commands if package scripts are available.
