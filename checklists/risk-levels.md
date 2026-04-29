# Risk Levels

> Use the dynamic [risk calculator](../workflows/risk-calculator.md) for any task at Risk 2+.
> The classes below are the **base** scores. Modifiers are applied per profile.

## Risk 0 — Read-only

Examples:
- Explain code.
- Map repo.
- Review diff.
- Trace a flow.
- Answer a question about how something works.

Allowed: read, search, summarize.
Not allowed: edits.

## Risk 1 — Safe local change

Examples:
- Copy / string change.
- Isolated UI state.
- Adding a small utility test for an existing function.
- Type-only fix.
- Renaming a local (non-exported) variable.

Required: brief plan in chat, diff summary, validation if available.

## Risk 2 — Product behavior change

Examples:
- New endpoint behavior.
- Form validation logic.
- Business logic change.
- API response shape change.
- Adding a feature flag.

Required: plan before edit, tests/validation, manual test steps.

## Risk 3 — Sensitive system change

Examples:
- Auth, authorization, permissions.
- Billing / payments.
- Database writes / migrations.
- User data / privacy.
- Background jobs.
- External integrations.
- Multi-tenant boundary code (b2b-saas).

Required: explicit approval before edits, risk analysis, rollback plan, tests.

## Risk 4 — Dangerous change

Examples:
- Secrets, env vars, key rotation.
- Production config.
- Infrastructure (Terraform, k8s, Vercel project settings).
- Destructive data operations.
- Deleting migrations.
- Access control changes without tests.
- Broad dependency upgrades (major versions).

Default: refuse to proceed with direct edit. Propose a safe plan and wait for explicit approval of the exact diff.

## Domain overrides

The base class can be raised by domain. Example:

- `domain == fintech`: any change to currency math is **always Risk 3+** regardless of how small.
- `domain == healthcare`: any code path that *might* touch PHI is **always Risk 3+**.
- `domain == b2b-saas`: any query without a tenant filter is **always Risk 3+**.
- `domain == solo`: Risk 2 changes can sometimes proceed with a one-line plan.

See `domains/<your-domain>.md` for the active overrides.
