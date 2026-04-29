# Contributing

Thanks for considering a contribution. This skill grows by **real usage**, not speculation.

## Most useful contributions

### 1. Add a stack file

If `onboard.sh` detects a stack but no `stacks/<name>.md` exists, the skill falls back to `stacks/_generic.md`. Add a stack file to give other users real guidance.

See `stacks/_README.md` for the required sections and tone.

A great stack PR includes:
- A new `stacks/<framework>.md`
- One concrete real-world example that motivated the rules (a bug, a near-miss, a footgun you've seen)
- A note in `scripts/onboard.sh` if detection logic needs updating

### 2. Add a domain file

Same pattern under `domains/<domain>.md`. Domains capture **risk shape**, not stack details.

We already cover: `solo`, `b2c`, `b2b-saas`, `fintech`, `healthcare`, `internal-oss`. Open new ones (gaming, embedded, ML/research, agency client work, etc.) if you have lived experience to draw on.

### 3. Improve a workflow

Workflows describe how to **operate** on a task type. If you've used the skill on a real bug or refactor and a workflow had a gap, propose the patch with the concrete situation that exposed the gap.

### 4. Expand `examples/`

Real transcripts are gold. Anonymize details, keep the shape, contribute. The current examples cover 5 task types — there's room for more (architecture decisions, mobile-specific, ML training).

### 5. Improve detection in `scripts/onboard.sh` / `onboard.ps1`

If the script misidentifies your stack, fix it. Test on at least 2 representative projects before opening the PR.

## Style

- **Concrete over abstract.** "Adding `'use client'` to a server component is Risk 2" beats "Be careful with rendering boundaries."
- **Why, not just what.** Always include the *reason* a rule exists.
- **Example commands, not placeholders.** Write `cargo clippy -- -D warnings`, not `<lint command>`.
- **Hebrew or English.** The skill itself works in either; user-facing text should match the user's language.

## Avoid

- AI-generated boilerplate (we can tell).
- Sweeping rewrites without concrete motivation.
- Adding workflows that overlap heavily with existing ones — extend an existing one or write a delta-only file (see `workflows/refactor.md` as an example).

## Pull request process

1. Open an issue first for anything more than a typo. We may have context on why a rule is shaped a certain way.
2. Keep PRs focused. One stack, one domain, one workflow per PR.
3. Include a real example or transcript when adding/changing rules.
4. The maintainer will respond within ~7 days.

## Code of conduct

Be direct. Be specific. Be respectful. We're all here to ship better software faster — feedback is the point.
