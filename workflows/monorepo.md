# Monorepo Workflow

Loaded when the repo has multiple packages (`pnpm-workspace.yaml`, `nx.json`, `turbo.json`, `lerna.json`, Cargo workspace, Go workspace, etc.).

## Detection signals
- `pnpm-workspace.yaml` or `package.json > workspaces`
- `turbo.json`, `nx.json`, `lerna.json`
- `Cargo.toml` with `[workspace]`
- `go.work`
- Multiple `package.json` files at different paths
- Top-level dirs `apps/`, `packages/`, `services/`, `libs/`

## Adjusted onboarding

If a monorepo is detected:

1. **The single profile is not enough.** Each package may have a different stack, framework, and risk surface.
2. Recommend the user run `onboard.sh` **inside each package** that they actively work on, or accept a top-level profile that lists the dominant stack.
3. The risk calculator should add **+1** when a change spans multiple packages (cross-package coupling is a hidden risk).

## Risk modifiers specific to monorepos

| Condition | Delta |
|---|---|
| Change touches more than 1 package | +1 |
| Change touches a `packages/` library that other apps consume | +2 |
| Change to root config (turbo.json, pnpm-workspace.yaml) | +2 |
| Change to a CI workflow that builds the whole repo | +2 |

## Files that are Risk 3+

- Workspace root config (turbo, nx, pnpm-workspace, Cargo `[workspace]`)
- Any `packages/<lib>/package.json > version` bump (semver matters; downstreams break)
- `tsconfig.base.json` or shared tsconfig — affects all packages
- Shared CI runners / cache config

## Anti-patterns to refuse
- "Just bump the major version" of a shared lib without scanning consumers.
- Adding a dep to a leaf package that already exists at the root (causes hoisting confusion).
- Cross-package imports via relative paths instead of the package alias (breaks moves and refactors).
- Turning off `nx affected` / `turbo run --filter` and rebuilding the whole monorepo "to be safe" — wastes CI time and hides what's actually changing.

## When validating a monorepo change

- Use the workspace-aware command: `pnpm -r test`, `cargo test --workspace`, `turbo run test`, `nx affected -t test`.
- Don't run validation only on the package you edited; run it on **every package that depends on it**.
- The validation chain in the profile may need to be widened — flag this if you see it.
