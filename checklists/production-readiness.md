# Production Readiness Checklist

Use before declaring production-impacting work complete.

## Behavior
- Goal implemented.
- Scope did not expand.
- Backward compatibility considered.
- Edge cases handled.
- Failure modes handled.

## Risk
- Risk level stated.
- Auth/permissions impact considered.
- Billing/payment impact considered.
- Data integrity considered.
- Privacy/PII considered.

## Validation
- Relevant tests pass.
- Typecheck passes if available.
- Lint passes if available.
- Build passes if relevant.
- Manual QA steps listed.

## Observability
- Errors are visible.
- Logs do not leak secrets/PII.
- Metrics/alerts considered for risky paths.

## Rollout
- Feature flag needed?
- Migration order needed?
- Rollback path known?
- Partial deploy safe?

## Documentation
- Diff summary provided.
- Known limitations documented.
- Follow-up tasks listed.
