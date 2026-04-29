# Task Templates

## Read Repo
```txt
Read this repository. Do not edit files.
Create a concise repo map: purpose, stack, key folders, frontend entry points, backend/API entry points, data layer, validation commands, risky areas.
```

## Plan Before Edit
```txt
Before editing, inspect the relevant code and propose the smallest safe plan.
Include files to edit, files to avoid, risks, validation commands, and manual test steps.
Wait for approval before editing.
```

## Safe Feature Change
```txt
Goal: <goal>
Context: <context>
Constraints:
- Do not add dependencies.
- Do not change DB schema.
- Do not touch auth/billing/permissions unless necessary and approved.
- Do not refactor unrelated code.
Process:
1. Inspect relevant files.
2. Propose plan.
3. Wait for approval.
4. Implement smallest safe change.
5. Run validation.
6. Summarize diff.
```

## Debug
```txt
Here is the error:
<paste error>
Do not edit yet.
Explain what it means, identify likely root causes, list files to inspect, and propose a minimal fix with validation.
```

## Diff Review
```txt
Review this diff as a Staff Engineer.
Focus on correctness, security, data integrity, auth/permissions, backward compatibility, tests, and unrelated changes.
Group findings by severity: Blocker, High, Medium, Low, Nice to have.
Do not edit yet.
```
