# Adding a new stack

The skill picks up `stacks/<name>.md` automatically based on the detected framework.

## When to add a stack file

Add one when:
- A real user runs the skill against a stack and gets `_generic.md` as fallback
- A stack has **non-obvious risk patterns** (e.g., flipping a boundary, magic config keys, common footguns)
- A stack has **distinct validation commands** worth documenting

## Naming

The filename is the value of `framework` from `onboard.sh`. Examples:
- `nextjs.md`, `tauri.md`, `django.md`, `rails.md`, `fastapi.md`, `spring-boot.md`

If a framework is detected as `unknown`, the language file (e.g. `python.md`, `rust.md`, `go.md`) is loaded.

## Required sections

Every stack file should answer:

1. **Default validation chain** .  exact commands, in order
2. **Files that are Risk 2+** .  files where a small change has wide impact
3. **Files that are Risk 3+** .  files where a mistake is a real incident
4. **Anti-patterns to refuse** .  concrete patterns the agent should never execute without approval
5. **Testing notes** .  what conventions exist, what's flaky, what's preferred for new tests

Optional but valuable:
- **Performance gotchas**
- **Distribution / deployment specifics**
- **Version-specific rules** (e.g. "Next.js 16+: use `cacheComponents`")

## Tone

- **Concrete over abstract.** "Adding `'use client'` to a server component is Risk 2" beats "Be careful with rendering boundaries".
- **Why, not just what.** When you flag something as risky, say *why* in one short clause.
- **Example commands, not placeholders.** Write `cargo clippy -- -D warnings`, not `<lint command>`.

## Updating an existing stack

If a major version of the framework changes the rules:
- Don't replace the old rules silently.
- Add a new section: "**Vue 3.5+ specifics**" or similar.
- Keep the old guidance for users still on the previous major.

## Pull requests

Open a PR with:
- The new file
- One concrete real-world example that motivated the rules
- A test project layout (in `examples/`) where `onboard.sh` would correctly detect this stack

This keeps the skill grounded in real usage, not speculation.
