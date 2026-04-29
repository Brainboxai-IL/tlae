# Risk Calculator (Dynamic)

Compute and **show** a risk score for any task at Risk 2+ before editing.

## Formula

```
score = base + sum(modifiers)
```

### Base (task type)

| Task type | Base |
|---|---|
| Read-only analysis | 0 |
| Cosmetic / docs / small typing fix | 1 |
| Local feature change (no public API) | 2 |
| Public API change / behavior change | 3 |
| Auth / billing / schema / secrets / infra | 4 |

### Modifiers (apply each independently; do NOT add a "touches auth/billing/schema" modifier — that's already in the base score)

| Condition | Delta |
|---|---|
| No tests cover the affected area | +1 |
| `production_state == live-with-paying-customers` | +2 |
| `production_state == live` (no paying customers yet) | +1 |
| `domain == fintech` or `healthcare` | +1 |
| Multi-tenant data path AND `domain == b2b-saas` | +1 |
| Change is fully reversible (nullable, feature-flagged, no destructive ops) | -1 |
| `team_size == solo` AND change is not destructive | -1 |
| First task in this repo (you don't yet have a mental model) | +1 |

**Cap:** the maximum score is 10. Anything calculated above 10 is treated as 10.

Domain files (`domains/<domain>.md`) may add further modifiers (e.g., fintech adds +2 for currency math). Apply those on top.

## Decision matrix

| Score | What to do |
|---|---|
| **0–2** | Proceed. One-line plan in chat is enough. |
| **3–4** | Plan-first. Validation step required. Tests recommended. |
| **5–6** | Plan-first. Approval required before editing. Tests required. |
| **7+** | Stop. Analysis-only until the user approves the exact diff. |

## How to present the score

Always show the breakdown, not just the number.

### Bad

> "Risk 3."

### Good

> ```
> Risk score: 5/10
>   base: 3 (public API change — adds a new query param to /v1/orders)
>   +2: touches order state machine
>   +1: no test covers the new branch
>   -1: change is reversible (feature-flagged)
> 
> → Plan-first; approval required before edit.
> ```

## Example: same task, different profiles

Task: *"Add a new column `referrer_url` to the `signups` table."*

### Solo, b2c, pre-launch
```
base 4 (schema change)
-1 solo
-1 reversible (nullable column, no backfill needed yet)
= 2 → proceed with brief plan
```

### Small team, b2b-saas, live
```
base 4
+1 live
+1 multi-tenant
= 6 → plan-first, approval required, tests required
```

### Larger team, fintech, live-with-paying-customers
```
base 4
+1 fintech
+2 live-with-paying-customers
= 7 → STOP. Analysis-only.
```

Same code change. Different worlds. **The skill enforces the difference.**

## When you don't have a profile yet

If `.tlae/profile.md` doesn't exist, run onboarding first. As a fallback for one-off questions, assume the most conservative profile:
- `team_size = small`
- `domain = b2b-saas`
- `production_state = live`

This errs on the side of caution.

## Anti-pattern: hand-waving the score

Do not make up a score. If you can't compute it (e.g., you don't know if tests cover the area), say so:

> ```
> Risk score: cannot compute yet.
> Need to confirm: does any test exercise this code path?
> Inspecting `tests/` first.
> ```
