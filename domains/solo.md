# Solo / side project domain

Loaded when `team_size == solo` (often combined with `internal-oss`).

## Risk philosophy

Solo projects don't need enterprise rigor. **Speed > formality** for low-stakes work, but the safety floor stays.

### What to relax
- ADRs (Architecture Decision Records) — optional, not required.
- Multi-step approval before refactors — proceed if the diff is small.
- Migration plan templates — a brief inline plan is enough for non-destructive changes.
- "Tests required" at Risk 2 — keep, but accept smoke tests instead of unit + integration.

### What to keep
- **Risk gates for destructive operations** (drop tables, delete files, force push, secret leaks). The fact you're alone makes mistakes more dangerous, not less.
- **API reality check** — hallucinations cost the same whether you're solo or not.
- **No silent dependency adds** — supply chain risk is real for solo too.
- **Validation chain before declaring "done"** — solo developers ship broken code most when they skip this.

## Default response shortening

For Risk 0–2 tasks in a solo project, drop the response shape to:

```
- Plan: <one line>
- Risk: <score>/10 (<short reason>)
- Validation: <command I'll run>
```

No need for the full 6-section response.

## Common solo failure modes (be alert)

1. **Dependency drift**: solo devs add packages without running `audit`.
2. **Stale tests**: skipped tests accumulate; flag any `it.skip` / `#[ignore]` you see.
3. **Untracked secrets**: solo devs paste tokens in commits.
4. **No backup of local DB**: if a migration is destructive, ensure a recent dump.
