# Onboarding script for Windows PowerShell.
# Mirrors onboard.sh logic; produces .tlae/profile.md.

param([switch]$Update)

$ErrorActionPreference = "Stop"
$ProfileDir = ".tlae"
$ProfileFile = "$ProfileDir/profile.md"
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null

function FileMatches { param($pattern) Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | Select-Object -First 1 }

# ---------- detect language(s) ----------
$Langs = @()
if (Test-Path "package.json")     { $Langs += "javascript" }
if (Test-Path "tsconfig.json")    { $Langs += "typescript" }
if (Test-Path "Cargo.toml")       { $Langs += "rust" }
if (Test-Path "go.mod")           { $Langs += "go" }
if ((Test-Path "pyproject.toml") -or (Test-Path "requirements.txt") -or (Test-Path "setup.py") -or (Test-Path "Pipfile")) { $Langs += "python" }
if ((Test-Path "pom.xml") -or (Test-Path "build.gradle") -or (Test-Path "build.gradle.kts")) { $Langs += "java" }
if (Test-Path "Gemfile")          { $Langs += "ruby" }
if (Test-Path "composer.json")    { $Langs += "php" }
if (Test-Path "mix.exs")          { $Langs += "elixir" }
if (FileMatches "*.csproj")       { $Langs += "dotnet" }
if (Test-Path "Package.swift")    { $Langs += "swift" }
$LangList = if ($Langs.Count -gt 0) { $Langs -join "," } else { "unknown" }

# ---------- framework ----------
$Framework = "unknown"
if ((Test-Path "next.config.js") -or (Test-Path "next.config.mjs") -or (Test-Path "next.config.ts")) { $Framework = "nextjs" }
elseif ((Test-Path "nuxt.config.ts") -or (Test-Path "nuxt.config.js")) { $Framework = "nuxt" }
elseif ((Test-Path "vite.config.js") -or (Test-Path "vite.config.ts")) { $Framework = "vite" }
elseif (Test-Path "remix.config.js") { $Framework = "remix" }
elseif (Test-Path "svelte.config.js") { $Framework = "sveltekit" }
elseif (Test-Path "astro.config.mjs") { $Framework = "astro" }
elseif (Test-Path "manage.py") { $Framework = "django" }
elseif ((Test-Path "requirements.txt") -and (Select-String "fastapi" "requirements.txt" -Quiet)) { $Framework = "fastapi" }
elseif ((Test-Path "requirements.txt") -and (Select-String "flask" "requirements.txt" -Quiet)) { $Framework = "flask" }
elseif (Test-Path "config/application.rb") { $Framework = "rails" }
elseif ((Test-Path "Cargo.toml") -and (Select-String "tauri" "Cargo.toml" -Quiet)) { $Framework = "tauri" }
elseif ((Test-Path "Cargo.toml") -and (Select-String "axum|actix-web|rocket =|warp =" "Cargo.toml" -Quiet)) { $Framework = "rust-server" }
elseif ((Test-Path "Cargo.toml") -and (Select-String "bevy|macroquad" "Cargo.toml" -Quiet)) { $Framework = "rust-game" }
elseif ((Test-Path "Cargo.toml") -and (Select-String "leptos|dioxus|yew" "Cargo.toml" -Quiet)) { $Framework = "rust-frontend" }

# ---------- package manager ----------
$PM = "unknown"
if (Test-Path "pnpm-lock.yaml") { $PM = "pnpm" }
elseif (Test-Path "yarn.lock") { $PM = "yarn" }
elseif ((Test-Path "bun.lockb") -or (Test-Path "bun.lock")) { $PM = "bun" }
elseif (Test-Path "package-lock.json") { $PM = "npm" }
elseif (Test-Path "Cargo.toml") { $PM = "cargo" }
elseif (Test-Path "go.sum") { $PM = "go" }
elseif (Test-Path "poetry.lock") { $PM = "poetry" }
elseif (Test-Path "Pipfile.lock") { $PM = "pipenv" }
elseif ((Test-Path "pyproject.toml") -and (Select-String "uv" "pyproject.toml" -Quiet)) { $PM = "uv" }
elseif (Test-Path "requirements.txt") { $PM = "pip" }
elseif (Test-Path "Gemfile.lock") { $PM = "bundler" }
elseif (Test-Path "composer.lock") { $PM = "composer" }
elseif (Test-Path "mix.exs") { $PM = "mix" }

# ---------- database ----------
$DB = "none-detected"
if (Test-Path "prisma/schema.prisma") { $DB = "prisma" }
elseif ((Test-Path "drizzle.config.ts") -or (Test-Path "drizzle.config.js")) { $DB = "drizzle" }
elseif (Test-Path "supabase") { $DB = "supabase" }
elseif (Test-Path "db/migrate") { $DB = "rails-active-record" }
elseif ((Test-Path "Cargo.toml") -and (Select-String "sqlx|sea-orm|diesel" "Cargo.toml" -Quiet)) { $DB = "rust-sql" }

# ---------- test command ----------
$TestCmd = "unknown"
if (Test-Path "package.json") {
  if (Select-String '"test"' "package.json" -Quiet) {
    $TestCmd = switch ($PM) {
      "pnpm" { "pnpm test" }
      "yarn" { "yarn test" }
      "bun" { "bun test" }
      default { "npm test" }
    }
  }
} elseif (Test-Path "Cargo.toml") { $TestCmd = "cargo test" }
elseif (Test-Path "go.mod") { $TestCmd = "go test ./..." }
elseif ((Test-Path "pyproject.toml") -and (Select-String "pytest" "pyproject.toml" -Quiet)) { $TestCmd = "pytest" }
elseif (Test-Path "manage.py") { $TestCmd = "python manage.py test" }
elseif (Test-Path "Gemfile") { $TestCmd = "bundle exec rspec" }
elseif (Test-Path "mix.exs") { $TestCmd = "mix test" }

# ---------- typecheck / lint ----------
$Typecheck = "unknown"
$Lint = "unknown"
if (Test-Path "package.json") {
  if (Select-String '"typecheck"' "package.json" -Quiet) { $Typecheck = "$PM run typecheck" }
  if (Select-String '"lint"' "package.json" -Quiet) { $Lint = "$PM run lint" }
} elseif (Test-Path "Cargo.toml") {
  $Typecheck = "cargo check"
  $Lint = "cargo clippy -- -D warnings"
} elseif (Test-Path "go.mod") {
  $Typecheck = "go vet ./..."
  $Lint = "golangci-lint run"
}

# ---------- CI ----------
$CI = "none"
if (Test-Path ".github/workflows") { $CI = "github-actions" }
elseif (Test-Path ".gitlab-ci.yml") { $CI = "gitlab-ci" }
elseif (Test-Path ".circleci/config.yml") { $CI = "circleci" }

# ---------- monorepo ----------
$Monorepo = "no"
if ((Test-Path "pnpm-workspace.yaml") -or (Test-Path "turbo.json") -or (Test-Path "nx.json") -or (Test-Path "lerna.json") -or (Test-Path "go.work")) { $Monorepo = "yes" }
elseif ((Test-Path "package.json") -and (Select-String '"workspaces"' "package.json" -Quiet)) { $Monorepo = "yes" }
elseif ((Test-Path "Cargo.toml") -and (Select-String "^\[workspace\]" "Cargo.toml" -Quiet)) { $Monorepo = "yes" }

# ---------- deployment ----------
$Deploy = "none"
if ((Test-Path "vercel.json") -or (Test-Path ".vercel")) { $Deploy = "vercel" }
elseif (Test-Path "netlify.toml") { $Deploy = "netlify" }
elseif (Test-Path "Dockerfile") { $Deploy = "docker" }
elseif (Test-Path "docker-compose.yml") { $Deploy = "docker-compose" }
elseif ((Test-Path "k8s") -or (Test-Path "kubernetes")) { $Deploy = "kubernetes" }
elseif (Test-Path "fly.toml") { $Deploy = "fly" }
elseif (Test-Path "railway.json") { $Deploy = "railway" }

# ---------- write profile ----------
$Date = Get-Date -Format "yyyy-MM-dd"
@"
# Project Profile

> Auto-generated on $Date by tlae onboard.ps1
> Edit this file freely; the skill re-reads it every session.

## Auto-detected

- **Languages**: $LangList
- **Framework**: $Framework
- **Package manager**: $PM
- **Database / ORM**: $DB
- **CI**: $CI
- **Deployment**: $Deploy
- **Monorepo**: $Monorepo

## Commands

- **Test**: ``$TestCmd``
- **Typecheck**: ``$Typecheck``
- **Lint**: ``$Lint``
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
"@ | Out-File -FilePath $ProfileFile -Encoding UTF8

Write-Host "OK Wrote draft profile to $ProfileFile" -ForegroundColor Green

# Add .tlae/ to .gitignore
if (Test-Path ".gitignore") {
  $gitignore = Get-Content ".gitignore" -Raw
  if ($gitignore -notmatch "(?m)^\.tlae/?$") {
    Add-Content -Path ".gitignore" -Value ""
    Add-Content -Path ".gitignore" -Value "# tlae skill (local profile + lessons)"
    Add-Content -Path ".gitignore" -Value ".tlae/"
    Write-Host "OK Added .tlae/ to .gitignore" -ForegroundColor Green
  }
} elseif (Test-Path ".git") {
  Set-Content -Path ".gitignore" -Value "# tlae skill (local profile + lessons)`n.tlae/"
  Write-Host "OK Created .gitignore with .tlae/" -ForegroundColor Green
}

Write-Host ""
Write-Host "Detected:"
Write-Host "  languages   = $LangList"
Write-Host "  framework   = $Framework"
Write-Host "  pkg manager = $PM"
Write-Host "  database    = $DB"
Write-Host "  CI          = $CI"
Write-Host "  deployment  = $Deploy"
Write-Host "  monorepo    = $Monorepo"
Write-Host "  test cmd    = $TestCmd"
Write-Host ""
Write-Host "Now Claude will ask you 3 questions to complete the profile."
