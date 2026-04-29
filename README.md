# 🧠 TLAE — Tech Lead Agentic Engineering

[![npm version](https://img.shields.io/npm/v/@brainboxai/tlae.svg)](https://www.npmjs.com/package/@brainboxai/tlae)
[![npm downloads](https://img.shields.io/npm/dm/@brainboxai/tlae.svg)](https://www.npmjs.com/package/@brainboxai/tlae)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **A Claude Code skill that adapts to your project. Not a generic checklist.**

---

## ⚡ Install (one command)

```bash
npx @brainboxai/tlae
```

That's it. Open Claude Code on any project and say `use tlae`.

---

## 🎯 What it does

Most "AI engineering rules" are static text. They tell a junior dev and a staff engineer the same thing, regardless of stack, team size, or whether you're shipping to live customers or playing on localhost.

TLAE is different. On first run it:

1. **Detects your stack** automatically (language, framework, package manager, tests, CI, deployment).
2. **Asks 3 short questions** (team size, domain, production state).
3. **Writes a profile** to `.tlae/profile.md` and uses it for every task from then on.

Every workflow, risk gate, and validation command gets **scoped to that profile**.

---

## 🧪 Same task, different worlds

> *"Add a `referrer_url` column to the `signups` table."*

| Profile | Risk score | What happens |
|---|---|---|
| Solo, B2C, pre-launch | **2/10** | Proceed with brief plan |
| Small team, B2B SaaS, live | **6/10** | Plan-first, approval, tests required |
| Larger team, fintech, paying customers | **7/10** | **Stop.** Analysis-only until exact diff approved |

A static checklist gives all three the same answer. TLAE doesn't.

---

## 📦 Installation options

### Default (Claude Code, global)
```bash
npx @brainboxai/tlae
```
Installs to `~/.claude/skills/tlae`. Available across all your Claude Code projects.

### Per-project (Claude Code)
```bash
cd your-project
npx @brainboxai/tlae --project
```
Installs to `./.claude/skills/tlae`. Only for this project.

### Other AI coding tools

| Tool | Command |
|---|---|
| **Cursor** | `npx @brainboxai/tlae --cursor` |
| **Codex CLI** | `npx @brainboxai/tlae --codex` |
| **Gemini CLI** | `npx @brainboxai/tlae --gemini` |
| **Aider** | `npx @brainboxai/tlae --aider` |
| **Everything** | `npx @brainboxai/tlae --all` |

### Manual install (no Node.js)
```bash
git clone https://github.com/Brainboxai-IL/tlae ~/.claude/skills/tlae
```

---

## 🚀 First run — what to expect

Open Claude Code on any project and say:

> use tlae

You'll see:

```
Detected: Next.js + Prisma + Vercel + pnpm.

Before I touch your task, 3 short questions:

1. Team size?
   (a) Solo / side project
   (b) Small team (2-5)
   (c) Larger team (6+)
```

Answer each one (just type `a`, `b`, or `c`). After the third question:

```
Profile saved.
Loaded: Next.js + Prisma + Vercel / small team / B2B SaaS / live-with-paying-customers
```

From now on, every task gets a real risk score and proper handling.

---

## 🛡️ What you get

### Auto-detection
- **Languages**: JS / TS / Python / Rust / Go / Java / Ruby / PHP / Elixir / C# / Swift
- **Frameworks**: Next.js, Nuxt, Vite, Remix, SvelteKit, Astro, Django, FastAPI, Flask, Rails, Spring Boot, Tauri, and more
- **Package managers**: pnpm, yarn, bun, npm, cargo, poetry, uv, pipenv, pip, bundler, composer, mix
- **Databases**: Prisma, Drizzle, Supabase, Django ORM, Rails AR, sqlx, sea-orm, diesel
- **CI**: GitHub Actions, GitLab CI, CircleCI
- **Deployment**: Vercel, Netlify, Docker, Kubernetes, Fly, Railway

If your stack isn't listed, you'll get a clear message instead of a hallucinated guess.

### Dynamic risk calculator
Every Risk-2+ task gets a visible breakdown:

```
Risk score: 5/10
  base: 3 (public API change)
  +2 touches order state machine
  +1 no test covers the new branch
  -1 reversible (feature-flagged)

→ Plan-first; approval required.
```

No more cryptic "Risk 3" labels.

### Stack-specific rules
- **Next.js**: flipping `"use client"` is Risk 2; `middleware.ts` is Risk 2+; auth routes are Risk 3+.
- **Rust**: `unsafe` blocks are Risk 3 each; `unwrap()` outside tests is flagged.
- **Django**: a model change without a migration is incomplete; renaming a column requires the three-step expand/contract.
- **Go**: goroutines without `ctx.Done()` are flagged; race detector required in CI.

### Domain-specific gates
- **Fintech**: currency math is always Risk 3+; floats banned; audit trail required.
- **B2B SaaS**: queries without `tenant_id` filter are Risk 3+.
- **Healthcare**: PHI in logs / URLs / errors is Risk 4 (refused).
- **Solo**: relaxed formality, kept safety floor for destructive ops.

### Project-local memory (`LESSONS.md`)
After each fix, the skill prompts:
> *"This surprised me. Should I add it to LESSONS.md?"*

Your project gets smarter every session.

---

## 🛠️ Updating the profile

Your profile is just a markdown file at `.tlae/profile.md`. Edit it any time.

To regenerate from scratch (re-detect stack and re-ask the 3 questions):
```bash
rm -rf .tlae
npx @brainboxai/tlae --project --force
```

---

## 📁 Repo structure

```
SKILL.md                        Entry point + risk calculator
scripts/
  onboard.sh / onboard.ps1      Auto-detect + write profile
  validate.sh                   Run typecheck, lint, test from profile
  detect_project.sh             Lightweight detection
  repo_snapshot.sh              Map a repo for the first time
  diff_summary.sh               Summarize a diff
  run_experiment.sh             Baseline / experiment / log loop
stacks/                         Per-language/framework rules
domains/                        Per-domain gates
workflows/                      One per task type
checklists/                     Reusable safety lists
prompts/                        Standard prompts
templates/                      Files to copy into the user's repo
examples/                       Real session transcripts
installer/                      Source of the npm installer
```

---

## 🤔 Why "agentic engineering"?

In 2026 the bottleneck isn't writing code. It's making sure the AI doesn't ship the wrong code. TLAE enforces the rules that real tech leads enforce on real teams:

- Read before edit.
- Plan before edit.
- Confirm APIs exist before using them.
- Smallest safe diff.
- Tests at Risk 2+.
- Stop at Risk 7+ for explicit approval.
- Record what you learned.

Same playbook, AI-native.

---

## 🤝 Contributing

Missing a stack? Drop a `stacks/<your-stack>.md` and open a PR.
Missing a domain? Same with `domains/<your-domain>.md`.

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## 📜 License

MIT. See [LICENSE](LICENSE).

---

Built by [BrainboxAI](https://brainboxai.io) ⋅ [npm](https://www.npmjs.com/package/@brainboxai/tlae) ⋅ [Issues](https://github.com/Brainboxai-IL/tlae/issues)
