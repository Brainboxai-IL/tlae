# Internal tool / OSS / experimental domain

Loaded when `domain == internal-oss`.

## Risk philosophy

The blast radius is small or contained. Optimize for **speed and clarity**, not formality.

### Relaxed
- ADR templates — optional.
- Multi-step approval — only for destructive ops.
- "Tests required at Risk 2+" — replaced by "tests required at Risk 3+".

### Kept
- Read-before-edit (saves time in any codebase).
- API reality check (hallucinations are equally costly).
- Smallest safe diff (helps reviewers, including future-you).

## OSS-specific

If the project is public:
- **Public API surface is sacred** — any breaking change requires a deprecation cycle or a major version bump.
- Issue / PR templates and contribution docs are part of the contract.
- Releases need a changelog entry; don't ship without one.

## Internal-tool-specific

If the project is internal:
- Speed of iteration is the goal; favor it over abstraction.
- "It works on my machine" is acceptable for one-off scripts; document it.
- Keep the README's "how to run this from scratch" step accurate; that's the actual maintenance burden.

## What still raises risk to 3+

- Anything that could leak source code, secrets, or internal data publicly (e.g., misconfigured CI artifact upload).
- Anything that touches a build pipeline shared by other repos.
- Anything published to a public package registry.
