# Go stack rules

Loaded when `go` is in `languages`.

## Default validation chain
1. `go vet ./...`
2. `golangci-lint run` (if installed; otherwise `staticcheck ./...`)
3. `go test ./... -race`
4. `go build ./...` for any package change

## Files that are Risk 2+
- `go.mod`, `go.sum` — dependency contract
- `internal/` package boundaries — Go enforces these
- Public exported names (capitalized symbols)
- `main.go` for binaries

## Files that are Risk 3+
- Anything under `pkg/auth`, `pkg/security`, or named handlers for sensitive routes
- Background goroutines lacking shutdown signals
- Channel close logic — easy to introduce panics

## Anti-patterns to refuse
- Naked `for { ... }` without a select on `ctx.Done()` in production code.
- Goroutines spawned without a `sync.WaitGroup` or `errgroup`.
- `panic()` in a library; return errors instead.
- Ignoring errors with `_ = someFn()` without a comment.
- Mutex held across function calls that may also lock.

## Error handling
- Wrap with `fmt.Errorf("doing X: %w", err)` to preserve chain.
- Use `errors.Is` / `errors.As` for typed checks; not string matching.
- Sentinel errors (`var ErrFoo = errors.New(...)`) for stable public API.

## Testing notes
- Table-driven tests are the default; deviate only with reason.
- Use `t.Parallel()` aggressively; flakes here usually indicate shared state.
- For HTTP: `httptest.NewServer` for integration; `httptest.NewRecorder` for handler unit tests.
- Race detector (`-race`) should be on in CI.
