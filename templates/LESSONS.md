# Lessons Learned

> Durable project memory. Read at the start of every session.
> Lessons override generic checklists when they conflict.

## How to add a lesson

After a task that surfaced a non-obvious pattern, append a dated entry:

```md
## YYYY-MM-DD .  short title
- **Context**: what task / what file
- **Surprise**: what was non-obvious
- **Rule**: the durable lesson, written as an instruction to future-you
- **Reference**: commit / PR / file:line
```

Keep entries short. If a section grows large, group it into a subsection at the bottom.

---

## Project Patterns

(Recurring patterns specific to this codebase. Examples: how errors are propagated, how config is loaded, naming conventions.)

## Commands

(Local quirks of running this project. Examples: which port the dev server uses, which env vars are required, how to seed the DB.)

## Testing Notes

(How tests are organized, what's flaky, what's slow, what's intentionally not covered.)

## Architecture Notes

(Decisions a newcomer wouldn't guess. Examples: why we use approach X over Y, where the public API boundary is.)

## Avoid

(Things tried in the past that didn't work, with the reason.)

## Risky Areas

(Files / modules / flows where mistakes are expensive. Add to the project's risk gates.)

## Common Bugs

(Recurring bug shapes. If you see one twice, add it.)

## Useful Files

(Files newcomers should read first.)

## Decisions

(Cross-references to ADRs, with one-line summary each.)

---

## Dated Lessons (most recent first)

<!-- New entries go above this line -->
