# Definition of Done

> Validation commands come from `.tlae/profile.md`. Use those, not generic placeholders.

A task is **done** only when all of the following are true:

## 1. The change works

- [ ] Manual test of the happy path completed.
- [ ] At least one edge case considered and handled or documented.

## 2. Validation passed

- [ ] Typecheck command from profile ran and passed (skip if not configured).
- [ ] Lint command from profile ran and passed (or warnings explicitly accepted).
- [ ] Test command from profile ran and passed.
- [ ] If validation cannot run locally (e.g., requires CI secrets), **say so explicitly** .  don't silently skip.

## 3. Diff is honest

- [ ] No unrelated files changed.
- [ ] No commented-out code left behind.
- [ ] No `TODO` / `FIXME` / `XXX` added without an issue link.
- [ ] No `console.log` / `print` / `dbg!` / debug logging that wasn't there before.
- [ ] No new dependencies added without explicit approval.

## 4. Risk addressed

- [ ] Risk score was computed and shown.
- [ ] If Risk 3+, the user gave explicit approval **for the exact diff**.
- [ ] Rollback / revert path is known (commit hash, feature flag, migration down step).

## 5. Knowledge captured

- [ ] If the task surfaced a non-obvious pattern, append a row to `.tlae/LESSONS.md`.
- [ ] If a workflow was wrong/missing, mention it so the user can update the skill.

## 6. Reported clearly

The final message includes:

```md
## Done

- **Files changed**: <list>
- **Behavior change**: <one line>
- **Validation**: <commands run + result>
- **Risk score**: <N/10 + breakdown>
- **Manual test**: <step-by-step the user can run>
- **Rollback**: <how to undo>
- **Follow-up** (if any): <next steps not done in this PR>
```

## Anti-patterns

- "Tests pass" without showing the command output. **Don't say it; show it.**
- "Should work" .  either you tested it or you didn't. Be honest.
- Marking done while a TODO is in the diff.
- Marking done while a known regression exists ("we'll fix it later").
