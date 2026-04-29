# Tauri 2 stack rules

Loaded when `framework == tauri`. Tauri = Rust backend + web frontend.

## Default validation chain
1. `cargo check` (often nested in `src-tauri/`)
2. `cargo clippy -- -D warnings`
3. `cargo test`
4. Frontend: detect package manager separately and run its typecheck/lint/test
5. `cargo tauri build` only when shipping a release

## The Tauri 2 access control model (memorize)

Tauri 2 replaced the v1 `allowlist` with a **three-part system**:

- **Permissions**: on/off toggles for individual commands (e.g., `fs:allow-write-text-file`)
- **Scopes**: parameter validation that constrains where a permission applies (e.g., write only under `$APPDATA/**`)
- **Capabilities**: bundle permissions + scopes and attach them to specific windows/webviews

Files live under `src-tauri/capabilities/*.json`. Always inspect these before changing any IPC or filesystem behavior.

## Files that are Risk 2+
- `src-tauri/tauri.conf.json` — window config, CSP, identifier
- `src-tauri/Cargo.toml` — Rust deps (impacts binary size + security surface)
- Files defining `#[tauri::command]` — IPC boundary; treat like a public API
- `src-tauri/capabilities/*.json` — what the frontend is allowed to invoke

## Files that are Risk 3+
- Anything under `tauri.conf.json > app > security` (CSP, dangerous flags)
- Adding a new permission to a capability file (especially `fs:`, `shell:`, `process:`)
- Bundle / signing config (`bundle`, `updater`)
- Any `#[tauri::command]` that takes a path or shell argument

## Anti-patterns to refuse without approval
- **`withGlobalTauri: true` in production** — convenience for dev; widens attack surface.
- **Disabling CSP** (`"csp": null`) instead of narrowing it. CSP is the last line of defense.
- **Granting `fs:allow-write-text-file` without a `path` scope** — gives unrestricted write.
- **Using `Command::new` from a command** without sanitizing the input — shell injection.
- **Returning raw filesystem paths to the frontend** — path-traversal risk.
- **Holding `std::sync::Mutex` across `.await` in async commands** — use `tokio::sync::Mutex`.
- **`shell:allow-execute` with a wildcard** — frontend can run anything.

## CSP rules (from official Tauri 2 docs)

A reasonable starting CSP for a Tauri app:
```json
"csp": {
  "default-src": "'self' customprotocol: asset:",
  "connect-src": "ipc: http://ipc.localhost",
  "font-src": ["https://fonts.gstatic.com"],
  "img-src": "'self' asset: http://asset.localhost blob: data:",
  "style-src": "'unsafe-inline' 'self' https://fonts.googleapis.com"
}
```

Do NOT add `'unsafe-eval'` to `script-src` without explicit approval — it defeats most XSS protection.

## Frontend ↔ Backend boundary

Tauri commands are the API contract between worlds. Treat them like HTTP endpoints:
- Validate every input.
- Return typed errors, not strings.
- Never trust the frontend.

A change to a `#[tauri::command]` signature is **Risk 2** because both sides depend on it.

## Performance notes

- The frontend bundle ships inside the binary; size matters more than in a web app.
- Heavy work belongs in Rust, not JS.
- IPC has serialization overhead; batch calls when possible.

## Distribution

- macOS code signing: required for distribution; flag any change to signing config as Risk 3.
- Updater: `tauri.conf.json > plugins > updater > endpoints` is Risk 3+ (controls how the app receives updates — supply chain risk).

## Mobile (iOS / Android)

If the project has `src-tauri/gen/`, it's also a mobile build:
- Mobile permissions are platform-specific (Info.plist on iOS, AndroidManifest.xml on Android).
- Adding a permission like camera/location is Risk 3 on mobile due to store review implications.

## Quick references
- Capabilities live under `src-tauri/capabilities/`.
- Default capability in `default.json` applies to the `main` window unless overridden.
- Plugin permissions are in the plugin's docs (e.g., `fs:`, `dialog:`, `shell:`).
