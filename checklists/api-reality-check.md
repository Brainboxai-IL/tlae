# API Reality Check

Prevent hallucinated code.

Before using any internal function, component, hook, class, endpoint, CLI command, env var, config key, or import path:

1. Search for existing usage.
2. Confirm the file exists.
3. Confirm exported name exists.
4. Confirm signature/props.
5. Confirm expected error behavior.
6. Reuse existing patterns.
7. If not found, say so instead of inventing.

## Required Evidence
When proposing implementation, include:

```md
## Existing patterns confirmed
- `X` is used in `file:path` for similar behavior.
- `Y` exports `functionName(args)`.
- Command `pnpm test` exists in package scripts.
```

## Red Flags
- Import path guessed from naming convention.
- Component props guessed.
- API response shape guessed.
- Env var guessed.
- CLI command guessed.
