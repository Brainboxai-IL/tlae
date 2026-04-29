# Context Management Workflow

Use to keep agent context efficient, accurate, and cheap.

## Principles
- Start narrow.
- Read entry points first.
- Trace imports only as needed.
- Prefer search over full repo scanning.
- Summarize before expanding context.
- Avoid reading generated, build, vendor, lock, or dist files unless needed.

## Working Summary
When context gets large, create:

```md
# Working Summary

## Task

## Relevant files read

## Current understanding

## Decisions made

## Open questions

## Files likely to edit

## Files to avoid
```

## Anti-Patterns
- Loading entire repo for a small fix.
- Reading huge generated files.
- Forgetting prior constraints.
- Using stale assumptions after code changes.
