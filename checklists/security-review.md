# Security Review Checklist

Use for every Risk 2+ change and all public-facing features.

## AuthN / AuthZ
- Authentication enforced where needed.
- Authorization checked server-side.
- Tenant/user ownership validated.
- No IDOR exposure.

## Input / Output
- Inputs validated.
- Outputs encoded/sanitized where relevant.
- No SQL/NoSQL injection.
- No command injection.
- No SSRF.
- No unsafe file path handling.

## Web
- XSS considered.
- CSRF considered for cookie-based auth.
- CORS not overly broad.
- Cookies secure/httpOnly/sameSite where relevant.

## Secrets / PII
- No secrets in code/logs/client bundles.
- No PII in logs unless explicitly allowed and redacted.
- Error messages do not leak internals.

## LLM / Agent Features
- Prompt injection considered.
- Tool access constrained.
- User-supplied content not blindly trusted.
- Sensitive files not exposed to model/tool output.

## Dependencies
- New dependency justified.
- Known risky package avoided.
- Lockfile changes reviewed.
