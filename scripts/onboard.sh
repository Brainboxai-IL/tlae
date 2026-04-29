#!/usr/bin/env bash
# Onboarding script: detects stack and writes a draft profile.
# Cross-platform-friendly (mac/linux/git-bash on windows).

set -euo pipefail

PROFILE_DIR=".tlae"
PROFILE_FILE="$PROFILE_DIR/profile.md"
mkdir -p "$PROFILE_DIR"

# ---------- helpers ----------
exists() { [ -f "$1" ] || [ -d "$1" ]; }
has_any() { for f in "$@"; do exists "$f" && return 0; done; return 1; }

# ---------- detect language(s) ----------
LANGS=()

if [ -f package.json ]; then LANGS+=("javascript"); fi
if [ -f tsconfig.json ]; then LANGS+=("typescript"); fi
if [ -f Cargo.toml ]; then LANGS+=("rust"); fi
if [ -f go.mod ]; then LANGS+=("go"); fi
if [ -f pyproject.toml ] || [ -f requirements.txt ] || [ -f setup.py ] || [ -f Pipfile ]; then
  LANGS+=("python")
fi
if [ -f pom.xml ] || [ -f build.gradle ] || [ -f build.gradle.kts ]; then
  LANGS+=("java")
fi
if [ -f Gemfile ]; then LANGS+=("ruby"); fi
if [ -f composer.json ]; then LANGS+=("php"); fi
if [ -f mix.exs ]; then LANGS+=("elixir"); fi
if ls *.csproj 1>/dev/null 2>&1; then LANGS+=("dotnet"); fi
if [ -f Package.swift ]; then LANGS+=("swift"); fi

LANG_LIST=$(IFS=, ; echo "${LANGS[*]:-unknown}")

# ---------- detect framework ----------
FRAMEWORK="unknown"
if [ -f next.config.js ] || [ -f next.config.mjs ] || [ -f next.config.ts ]; then FRAMEWORK="nextjs"
elif [ -f nuxt.config.ts ] || [ -f nuxt.config.js ]; then FRAMEWORK="nuxt"
elif [ -f vite.config.js ] || [ -f vite.config.ts ]; then FRAMEWORK="vite"
elif [ -f remix.config.js ]; then FRAMEWORK="remix"
elif [ -f svelte.config.js ]; then FRAMEWORK="sveltekit"
elif [ -f astro.config.mjs ]; then FRAMEWORK="astro"
elif [ -f manage.py ]; then FRAMEWORK="django"
elif grep -q "fastapi" requirements.txt pyproject.toml 2>/dev/null; then FRAMEWORK="fastapi"
elif grep -q "flask" requirements.txt pyproject.toml 2>/dev/null; then FRAMEWORK="flask"
elif [ -f config/application.rb ]; then FRAMEWORK="rails"
elif [ -d src/main/java ] && grep -q "spring-boot" pom.xml build.gradle 2>/dev/null; then FRAMEWORK="spring-boot"
elif [ -f Cargo.toml ] && grep -q "tauri" Cargo.toml 2>/dev/null; then FRAMEWORK="tauri"
elif [ -f Cargo.toml ] && grep -q "axum\|actix-web\|rocket = \|warp = " Cargo.toml 2>/dev/null; then FRAMEWORK="rust-server"
elif [ -f Cargo.toml ] && grep -q "bevy\|macroquad\|ggez" Cargo.toml 2>/dev/null; then FRAMEWORK="rust-game"
elif [ -f Cargo.toml ] && grep -q "leptos\|dioxus\|yew" Cargo.toml 2>/dev/null; then FRAMEWORK="rust-frontend"
fi

# ---------- detect package manager ----------
PM="unknown"
if [ -f pnpm-lock.yaml ]; then PM="pnpm"
elif [ -f yarn.lock ]; then PM="yarn"
elif [ -f bun.lockb ] || [ -f bun.lock ]; then PM="bun"
elif [ -f package-lock.json ]; then PM="npm"
elif [ -f Cargo.toml ]; then PM="cargo"
elif [ -f go.sum ]; then PM="go"
elif [ -f poetry.lock ]; then PM="poetry"
elif [ -f Pipfile.lock ]; then PM="pipenv"
elif [ -f pyproject.toml ] && grep -q "uv" pyproject.toml 2>/dev/null; then PM="uv"
elif [ -f requirements.txt ]; then PM="pip"
elif [ -f Gemfile.lock ]; then PM="bundler"
elif [ -f composer.lock ]; then PM="composer"
elif [ -f mix.exs ]; then PM="mix"
fi

# ---------- detect database ----------
DB="none-detected"
if [ -f prisma/schema.prisma ]; then DB="prisma"
elif has_any "drizzle.config.ts" "drizzle.config.js"; then DB="drizzle"
elif [ -d supabase ]; then DB="supabase"
elif [ -d migrations ] && grep -q "django" requirements.txt pyproject.toml 2>/dev/null; then DB="django-orm"
elif [ -d db/migrate ]; then DB="rails-active-record"
elif grep -q "sqlx\|sea-orm\|diesel" Cargo.toml 2>/dev/null; then DB="rust-sql"
fi

# ---------- detect tests ----------
TEST_CMD="unknown"
if [ -f package.json ]; then
  if grep -q '"test"' package.json; then
    case "$PM" in
      pnpm) TEST_CMD="pnpm test" ;;
      yarn) TEST_CMD="yarn test" ;;
      bun) TEST_CMD="bun test" ;;
      *) TEST_CMD="npm test" ;;
    esac
  fi
elif [ -f Cargo.toml ]; then TEST_CMD="cargo test"
elif [ -f go.mod ]; then TEST_CMD="go test ./..."
elif [ -f pyproject.toml ] || [ -f requirements.txt ]; then
  if grep -q "pytest" pyproject.toml requirements.txt 2>/dev/null; then TEST_CMD="pytest"
  else TEST_CMD="python -m unittest"; fi
elif [ -f manage.py ]; then TEST_CMD="python manage.py test"
elif [ -f Gemfile ]; then TEST_CMD="bundle exec rspec || bundle exec rake test"
elif [ -f mix.exs ]; then TEST_CMD="mix test"
fi

# ---------- detect typecheck/lint commands ----------
TYPECHECK_CMD="unknown"
LINT_CMD="unknown"
if [ -f package.json ]; then
  grep -q '"typecheck"' package.json && TYPECHECK_CMD="$PM run typecheck" || true
  grep -q '"lint"' package.json && LINT_CMD="$PM run lint" || true
elif [ -f Cargo.toml ]; then
  TYPECHECK_CMD="cargo check"
  LINT_CMD="cargo clippy -- -D warnings"
elif [ -f go.mod ]; then
  TYPECHECK_CMD="go vet ./..."
  LINT_CMD="golangci-lint run"
elif [ -f pyproject.toml ] && grep -q "ruff\|mypy" pyproject.toml 2>/dev/null; then
  grep -q "mypy" pyproject.toml && TYPECHECK_CMD="mypy ." || true
  grep -q "ruff" pyproject.toml && LINT_CMD="ruff check ." || true
fi

# ---------- detect CI ----------
CI="none"
[ -d .github/workflows ] && CI="github-actions"
[ -f .gitlab-ci.yml ] && CI="gitlab-ci"
[ -f .circleci/config.yml ] && CI="circleci"

# ---------- detect monorepo ----------
MONOREPO="no"
if [ -f pnpm-workspace.yaml ] || [ -f turbo.json ] || [ -f nx.json ] || [ -f lerna.json ] || [ -f go.work ]; then
  MONOREPO="yes"
elif [ -f package.json ] && grep -q '"workspaces"' package.json 2>/dev/null; then
  MONOREPO="yes"
elif [ -f Cargo.toml ] && grep -q "^\[workspace\]" Cargo.toml 2>/dev/null; then
  MONOREPO="yes"
fi

# ---------- detect deployment ----------
DEPLOY="none"
[ -f vercel.json ] || [ -d .vercel ] && DEPLOY="vercel"
[ -f netlify.toml ] && DEPLOY="netlify"
[ -f Dockerfile ] && DEPLOY="docker"
[ -f docker-compose.yml ] && DEPLOY="docker-compose"
[ -d k8s ] || [ -d kubernetes ] && DEPLOY="kubernetes"
[ -f fly.toml ] && DEPLOY="fly"
[ -f railway.json ] && DEPLOY="railway"

# ---------- write profile ----------
DATE=$(date '+%Y-%m-%d')
cat > "$PROFILE_FILE" <<EOF
# Project Profile

> Auto-generated on $DATE by tlae onboard.sh
> Edit this file freely; the skill re-reads it every session.

## Auto-detected

- **Languages**: $LANG_LIST
- **Framework**: $FRAMEWORK
- **Package manager**: $PM
- **Database / ORM**: $DB
- **CI**: $CI
- **Deployment**: $DEPLOY
- **Monorepo**: $MONOREPO

## Commands

- **Test**: \`$TEST_CMD\`
- **Typecheck**: \`$TYPECHECK_CMD\`
- **Lint**: \`$LINT_CMD\`
- **Validate (chain)**: typecheck → lint → test

## User answers (filled in by Claude during onboarding)

- **Team size**: ___ (solo / small 2-5 / large 6+)
- **Domain**: ___ (b2c / b2b-saas / fintech / healthcare / internal-oss)
- **Production state**: ___ (pre-launch / live / live-with-paying-customers)

## Risk modifiers

These are applied automatically by the risk calculator (see SKILL.md):

- domain == fintech | healthcare → +1
- production_state == live-with-paying-customers → +2
- team_size == solo → -1
EOF

echo "✓ Wrote draft profile to $PROFILE_FILE"

# Add .tlae/ to .gitignore (so private profile + lessons stay local)
if [ -f .gitignore ]; then
  if ! grep -qE "^\.tlae/?$" .gitignore; then
    echo "" >> .gitignore
    echo "# tlae skill (local profile + lessons)" >> .gitignore
    echo ".tlae/" >> .gitignore
    echo "✓ Added .tlae/ to .gitignore"
  fi
elif [ -d .git ]; then
  # Repo exists but no .gitignore - create one
  echo "# tlae skill (local profile + lessons)" > .gitignore
  echo ".tlae/" >> .gitignore
  echo "✓ Created .gitignore with .tlae/"
fi

echo ""
echo "Detected:"
echo "  languages   = $LANG_LIST"
echo "  framework   = $FRAMEWORK"
echo "  pkg manager = $PM"
echo "  database    = $DB"
echo "  CI          = $CI"
echo "  deployment  = $DEPLOY"
echo "  monorepo    = $MONOREPO"
echo "  test cmd    = $TEST_CMD"
echo ""
echo "Now Claude will ask you 3 questions to complete the profile."
