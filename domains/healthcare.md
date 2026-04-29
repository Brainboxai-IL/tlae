# Healthcare / regulated domain

Loaded when `domain == healthcare`. Treat as fintech-equivalent strictness.

## Auto risk modifiers

- PHI (Protected Health Information) handling: **+2**.
- Audit log paths: **+2**.
- Consent / authorization flows: **+2**.
- Anything that crosses a covered/business associate boundary: **+2**.

## Hard stops (Risk 4)

- Logging that could include PHI (request/response bodies, query params, error messages with user data).
- Encryption-at-rest configuration.
- Data export / report generation.
- Role-based access control (RBAC) policy code.
- Audit log emission and retention.
- Backup/restore paths.

## PHI hygiene

- **No PHI in logs** .  refuse to add a log line that includes a body or untrusted fields. Log IDs only; ferry PHI through dedicated audit channels.
- **No PHI in URLs** (path or query) .  they leak to access logs and analytics.
- **No PHI in error messages** returned to clients.
- **No PHI in telemetry / Sentry / Datadog** unless the SDK has a documented redaction policy and tests for it.

## Consent

- Any new data collection or use must check an explicit consent record.
- Consent records are append-only; updates create a new revision.

## Testing

- Tests must not commit real PHI. Use synthetic data fixtures.
- Test data generation must be deterministic and committable; no random PHI-looking strings.

## Common anti-patterns

- "Temporary debug log of the full request" .  refuse.
- Caching responses that contain PHI in a CDN/edge.
- Sharing a single error tracking instance across covered and non-covered code paths.
