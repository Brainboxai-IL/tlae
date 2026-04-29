# Risk Gates

Stop and request explicit approval before editing any of these areas.

## Auth / Authorization
- Login/session handling.
- JWT/cookies.
- Role checks.
- Permission checks.
- Tenant isolation.
- OAuth callbacks.

## Billing / Payments
- Payment provider logic.
- Subscription status.
- Invoicing.
- Usage metering.
- Webhooks.

## Database / Data Integrity
- Schema files.
- Migrations.
- Backfills.
- Deletes.
- Bulk updates.
- Constraints/indexes.

## Secrets / Privacy
- API keys.
- Environment variables.
- PII handling.
- Logging user data.

## Infra / Production
- Deployment files.
- CI/CD.
- Docker/Kubernetes/Terraform.
- Production config.
- Feature flag defaults.

## Dependencies
- package.json / lockfiles.
- Major version upgrades.
- New runtime libraries.

## Stop Message Template

```txt
This touches a Risk 3/4 area: <area>.
I will not edit yet.
Here is the plan, risk, validation, and rollback path.
Please explicitly approve before implementation.
```
