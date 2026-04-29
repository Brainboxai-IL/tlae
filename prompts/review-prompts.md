# Review Prompts

## Staff Engineer Review
```txt
Review this diff as a Staff Engineer.
Prioritize correctness, security, data integrity, backward compatibility, production risk, and test quality.
Do not focus on style nitpicks unless they affect maintainability.
Group findings by severity.
```

## Security Review
```txt
Review this change for security issues.
Focus on auth bypass, authorization, IDOR, input validation, injection, XSS, CSRF, SSRF, secrets, PII leakage, CORS, and unsafe logging.
```

## Production Readiness Review
```txt
Review whether this change is ready for production.
Check validation, rollback, observability, feature flag needs, migration order, edge cases, and manual QA.
```

## Test Review
```txt
Review the tests in this diff.
Do they protect behavior that matters?
Are they too coupled to implementation details?
What important cases are missing?
```
