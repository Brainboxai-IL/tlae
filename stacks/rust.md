# Rust stack rules

Loaded when `rust` is in `languages`.

## Default validation chain
1. `cargo check` .  fast type check
2. `cargo clippy -- -D warnings` .  lints as errors
3. `cargo test` .  all tests
4. `cargo build --release` only when shipping

For workspaces: pass `--workspace` to all of the above, or scope with `-p <crate>`.

## Files that are Risk 2+
- `Cargo.toml` .  adds/removes dependencies; check semver of new deps
- `build.rs` .  runs at build time; can do anything
- `lib.rs` / `mod.rs` .  public re-exports affect all consumers
- Any `pub` symbol in a crate consumed by others

## Files that are Risk 3+
- `unsafe { ... }` blocks .  every change here is a memory-safety contract
- `Cargo.lock` if shipping a binary (the lockfile is part of the contract)
- `#[no_mangle]` and FFI definitions

## Anti-patterns to refuse
- `.unwrap()` / `.expect()` in non-test, non-`main` code paths without explicit reason.
- Suppressing clippy with `#[allow(...)]` without a comment explaining why.
- `unsafe` blocks without a `// SAFETY:` comment.
- Adding a dependency for a 5-line helper.
- Boxing futures unnecessarily.

## Concurrency / async
- Mixing `std::sync::Mutex` with `.await` .  use `tokio::sync::Mutex`.
- Holding a lock across an `.await` .  bug magnet; flag it.
- `block_on` inside async .  almost always wrong.

## Error handling
- Library code: `thiserror` for typed errors.
- Application code: `anyhow` for top-level error propagation.
- Don't mix `unwrap` with `?` in the same function .  pick one approach.

## Testing notes
- Unit tests in `#[cfg(test)] mod tests` at the bottom of the file under test.
- Integration tests in `tests/` directory.
- For async tests: `#[tokio::test]` with the `tokio` feature `macros`.
