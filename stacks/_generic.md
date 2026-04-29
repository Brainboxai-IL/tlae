# Generic stack rules

This file is loaded as a fallback when no stack-specific file exists for the detected stack. Tell the user: *"I don't have stack-specific rules for `<detected_stack>`. Falling back to generic rules. Consider contributing a `stacks/<your_stack>.md`."*

## Universal rules

- **Read before edit**: trace the call chain before modifying any file.
- **API reality check**: confirm imports, exports, and signatures exist before using them (`checklists/api-reality-check.md`).
- **Smallest safe diff**: change only what the task requires.
- **Validation chain**: typecheck → lint → tests, in that order. Use commands from `.tlae/profile.md`.
- **Tests required at Risk 2+**: a behavior change without a test is incomplete.
- **No silent dependency adds**: every new package requires explicit approval.
- **Public API stability**: any change to an exported symbol or HTTP route is Risk 2+.

## Files to inspect first in any repo

- README, CONTRIBUTING, CHANGELOG (if present).
- Top-level config files (anything that ends in `.toml`, `.yaml`, `.json`, `.config.*`).
- Lockfile to identify the package manager.
- CI workflow files to understand the contract.
- Test directory layout to understand the testing convention.

## When you don't recognize a tool

Stop and ask the user instead of guessing. Generic guesses ruin trust.
