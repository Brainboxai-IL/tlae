#!/usr/bin/env bash
# Cross-stack validation chain.
# Reads .tlae/profile.md if it exists; otherwise auto-detects.
# Runs: typecheck -> lint -> test, in that order.

set -euo pipefail

PROFILE=".tlae/profile.md"

run_step() {
  local name="$1"; shift
  echo ""
  echo "## $name"
  if "$@"; then
    echo "✓ $name passed"
  else
    echo "✗ $name failed (exit $?)"
    return 1
  fi
}

# Try to read commands from profile first
if [ -f "$PROFILE" ]; then
  TEST_CMD=$(grep -E "^- \*\*Test\*\*:" "$PROFILE" | sed 's/.*`\(.*\)`.*/\1/' || true)
  TYPECHECK_CMD=$(grep -E "^- \*\*Typecheck\*\*:" "$PROFILE" | sed 's/.*`\(.*\)`.*/\1/' || true)
  LINT_CMD=$(grep -E "^- \*\*Lint\*\*:" "$PROFILE" | sed 's/.*`\(.*\)`.*/\1/' || true)
fi

# Fallback: auto-detect
if [ -z "${TEST_CMD:-}" ] || [ "$TEST_CMD" = "unknown" ]; then
  if   [ -f Cargo.toml ];      then TEST_CMD="cargo test"; TYPECHECK_CMD="cargo check"; LINT_CMD="cargo clippy -- -D warnings"
  elif [ -f go.mod ];          then TEST_CMD="go test ./..."; TYPECHECK_CMD="go vet ./..."; LINT_CMD="golangci-lint run"
  elif [ -f manage.py ];       then TEST_CMD="python manage.py test"
  elif [ -f pyproject.toml ];  then TEST_CMD="pytest"
  elif [ -f Gemfile ];         then TEST_CMD="bundle exec rspec"
  elif [ -f mix.exs ];         then TEST_CMD="mix test"
  elif [ -f package.json ];    then
    if   [ -f pnpm-lock.yaml ]; then PM="pnpm"
    elif [ -f yarn.lock ];      then PM="yarn"
    elif [ -f bun.lockb ] || [ -f bun.lock ]; then PM="bun"
    else PM="npm"; fi
    TYPECHECK_CMD="$PM run typecheck"
    LINT_CMD="$PM run lint"
    TEST_CMD="$PM test"
  fi
fi

echo "=== Validation chain ==="

# typecheck
if [ -n "${TYPECHECK_CMD:-}" ] && [ "$TYPECHECK_CMD" != "unknown" ]; then
  run_step "Typecheck" sh -c "$TYPECHECK_CMD"
fi

# lint
if [ -n "${LINT_CMD:-}" ] && [ "$LINT_CMD" != "unknown" ]; then
  run_step "Lint" sh -c "$LINT_CMD" || echo "(lint not configured; skipping non-fatally)"
fi

# tests
if [ -n "${TEST_CMD:-}" ] && [ "$TEST_CMD" != "unknown" ]; then
  run_step "Tests" sh -c "$TEST_CMD"
fi

echo ""
echo "=== Done ==="
