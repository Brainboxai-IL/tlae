# CLAUDE.md

This project follows the **Tech Lead Agentic Engineering** workflow.
See `.tlae/profile.md` for the active stack and risk profile.

## Default Behavior
1. Read relevant code before editing.
2. Compute risk score (see `workflows/risk-calculator.md`).
3. Propose plan-first for Risk 3+ work.
4. Stop at Risk 7+ for explicit approval of the exact diff.
5. Edit narrowly. No unrelated refactor.
6. Validate: typecheck → lint → tests, using commands from `.tlae/profile.md`.
7. Review the diff. Report what changed and why.

## Hard Stops (require explicit approval)
- Auth / session / permissions.
- Billing / payments / webhooks.
- Database schema / migrations / backfills.
- Secrets / env files.
- CI/CD / deployment / infra.
- Production config.
- Destructive data operations.
- New dependencies.

## Validation Commands
The skill reads these from `.tlae/profile.md`. Common defaults:

- **JS/TS**: `pnpm typecheck && pnpm lint && pnpm test` (or `npm`/`yarn`/`bun`)
- **Rust**: `cargo check && cargo clippy -- -D warnings && cargo test`
- **Python**: `mypy . && ruff check . && pytest`
- **Go**: `go vet ./... && golangci-lint run && go test ./... -race`

If the project's commands differ, the profile is the source of truth.

## Response Expectations
After edits, report:
- Files changed (with one-line "why" each).
- Validation: command + actual output (not "tests pass" .  show it).
- Risk score with breakdown.
- Manual test steps the user can run.
- Rollback path.

## When in Doubt
Read, then plan, then ask. Never expand scope silently.
