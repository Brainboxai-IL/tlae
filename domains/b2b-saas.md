# B2B SaaS domain

Loaded when `domain == b2b-saas`.

## Auto risk modifiers

- Multi-tenant data access: **+2** to risk score.
- Quota / rate-limit logic: **+1**.
- Onboarding / invite flows: **+1**.

## Hard stops (Risk 3+)

- Tenant isolation logic (any code that reads `tenant_id` / `org_id`).
- Billing-tier feature gates.
- SSO / SAML / SCIM logic.
- Audit log emission paths.
- Enterprise admin endpoints.

## Multi-tenant rules

- **Every query must filter by tenant** unless explicitly system-wide; refuse to write a query that omits it.
- New columns/indexes on tenant-scoped tables must include `tenant_id` in the index when the query path uses it.
- Background jobs operating across tenants must batch per-tenant, not iterate flat .  for blast-radius containment.

## Plan limits / quotas

- Adding a new feature: ask which plan tier exposes it before implementing.
- Quota enforcement should be at the API layer AND the data layer; flag if only one is present.

## Webhook outbound

- Treat customer webhooks as untrusted destinations; timeout, retry with backoff, dead-letter queue.
- Never block a user-facing request on an outbound webhook delivery.

## Common anti-patterns

- "I'll add the tenant filter later" .  refuse.
- Caching keyed without `tenant_id` .  leak risk.
- Soft-delete that doesn't filter in default queries .  surfaces other tenants' data.
- Admin endpoints reachable without `is_admin` AND `tenant_id` checks.
