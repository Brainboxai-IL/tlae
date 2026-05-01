# 🧠 TLAE - Tech Lead Agentic Engineering

[![npm version](https://img.shields.io/npm/v/@brainboxai/tlae.svg)](https://www.npmjs.com/package/@brainboxai/tlae)
[![npm downloads](https://img.shields.io/npm/dm/@brainboxai/tlae.svg)](https://www.npmjs.com/package/@brainboxai/tlae)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Built for Claude Code](https://img.shields.io/badge/Built%20for-Claude%20Code-d97757)](https://docs.anthropic.com/en/docs/claude-code/overview)

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

## 🆚 How is this different from Cursor Rules / CONVENTIONS.md / Memory Bank?

Short answer: most existing tools give the AI a **fixed text file**. TLAE gives it a **decision system** that adapts per task.

| | Cursor Rules / `.cursor/rules` | Aider `CONVENTIONS.md` | Cline Memory Bank | **TLAE** |
|---|---|---|---|---|
| Static rules file | ✅ | ✅ | ✅ | ✅ |
| Auto-detects your stack | ❌ | ❌ | partial | ✅ |
| Per-task **risk score** with breakdown | ❌ | ❌ | ❌ | ✅ |
| Different rules for solo vs paying-customer apps | ❌ | ❌ | ❌ | ✅ |
| Stops the AI at high-risk tasks | ❌ | ❌ | ❌ | ✅ |
| Domain-aware (fintech ≠ B2C ≠ healthcare) | ❌ | ❌ | ❌ | ✅ |
| Project memory that grows over time | ❌ | ❌ | ✅ | ✅ |
| Works in Cursor, Codex, Gemini, Aider | partial | only Aider | only Cline | ✅ |

If you're happy with Cursor Rules and you ship to localhost, you don't need this. If you've ever watched an AI confidently rewrite your auth middleware on a Tuesday, you do.

---

## 🙅 Who this isn't for

- **Greenfield throwaway projects.** If you're spiking an idea on a Saturday, the gates will feel like overhead.
- **People who want the AI to "just do it".** TLAE will sometimes stop and ask. That's the point.
- **Teams that already have a strong written engineering handbook.** You can fold pieces of TLAE into your handbook instead of installing it whole.
- **Pure prompt-engineering use cases** (writing copy, generating data). TLAE is built for code.

If any of these is you, save the npm install — Cursor Rules or a plain `CLAUDE.md` will do.

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

## 📈 What it looks like after a month of use

After a few weeks the skill stops feeling generic. Your `.tlae/LESSONS.md` fills with project-specific rules that the AI re-reads on every session:

```md
## 2026-04-22 - tenant_id is enforced via Postgres RLS, not app code
- Context: refactor of /api/orders/list
- Surprise: removing the explicit `where tenant_id = ?` looked safe (RLS covers it)
  but broke read replicas where RLS isn't enforced.
- Rule: keep the explicit tenant_id filter in queries even when RLS exists.
  Defense in depth, and read replicas are a footgun.
- Reference: PR #142

## 2026-04-15 - Stripe webhooks are NOT idempotent on our side
- Context: bug where a refund fired twice
- Surprise: Stripe retries on 5xx; our handler wasn't keyed on event.id
- Rule: every webhook handler must dedupe on `event.id` before any DB write
- Reference: incident-2026-04-15.md
```

The AI reads this at the start of every session. Your project gets smarter, not just bigger.

---

## 🛡️ What you get

<details>
<summary><strong>Auto-detection</strong> (click to expand)</summary>

- **Languages**: JS / TS / Python / Rust / Go / Java / Ruby / PHP / Elixir / C# / Swift
- **Frameworks**: Next.js, Nuxt, Vite, Remix, SvelteKit, Astro, Django, FastAPI, Flask, Rails, Spring Boot, Tauri, and more
- **Package managers**: pnpm, yarn, bun, npm, cargo, poetry, uv, pipenv, pip, bundler, composer, mix
- **Databases**: Prisma, Drizzle, Supabase, Django ORM, Rails AR, sqlx, sea-orm, diesel
- **CI**: GitHub Actions, GitLab CI, CircleCI
- **Deployment**: Vercel, Netlify, Docker, Kubernetes, Fly, Railway

If your stack isn't listed, you'll get a clear message instead of a hallucinated guess.
</details>

<details>
<summary><strong>Dynamic risk calculator</strong></summary>

Every Risk-2+ task gets a visible breakdown:

```
Risk score: 5/10
  base: 3 (public API change)
  +2 touches order state machine
  +1 no test covers the new branch
  -1 reversible (feature-flagged)

→ Plan-first; approval required.
```

No more cryptic "Risk 3" labels. You see the math.
</details>

<details>
<summary><strong>Stack-specific rules</strong></summary>

- **Next.js**: flipping `"use client"` is Risk 2; `middleware.ts` is Risk 2+; auth routes are Risk 3+.
- **Rust**: `unsafe` blocks are Risk 3 each; `unwrap()` outside tests is flagged.
- **Django**: a model change without a migration is incomplete; renaming a column requires the three-step expand/contract.
- **Go**: goroutines without `ctx.Done()` are flagged; race detector required in CI.
</details>

<details>
<summary><strong>Domain-specific gates</strong></summary>

- **Fintech**: currency math is always Risk 3+; floats banned; audit trail required.
- **B2B SaaS**: queries without `tenant_id` filter are Risk 3+.
- **Healthcare**: PHI in logs / URLs / errors is Risk 4 (refused).
- **Solo**: relaxed formality, kept safety floor for destructive ops.
</details>

<details>
<summary><strong>Project-local memory (<code>LESSONS.md</code>)</strong></summary>

After each fix, the skill prompts:
> *"This surprised me. Should I add it to LESSONS.md?"*

Your project gets smarter every session. Lessons override generic checklists when they conflict.
</details>

---

## ❓ FAQ

<details>
<summary><strong>Does this send my code anywhere?</strong></summary>

No. TLAE is a markdown-and-shell-script skill that runs entirely inside your existing Claude Code (or Cursor / Codex / Gemini / Aider) session. The npm package is just an installer; once installed, no network calls. Your code, your profile, and your `LESSONS.md` never leave your machine.
</details>

<details>
<summary><strong>How is this different from a long <code>CLAUDE.md</code>?</strong></summary>

A `CLAUDE.md` is a single static file the model reads. TLAE is a **set of conditional rules** that load based on your stack and risk profile. A Next.js / fintech / live-customers project sees different rules than a Python / internal-tool / pre-launch one. With a static `CLAUDE.md`, you'd have to maintain a different one per project (and remember to keep them in sync).

That said: TLAE writes a `templates/CLAUDE.md` you can copy into your repo if you want a static fallback.
</details>

<details>
<summary><strong>Can I disable the risk-7+ stop behavior?</strong></summary>

Yes. Edit `.tlae/profile.md` and set the production state lower (e.g. from `live-with-paying-customers` to `pre-launch`). The risk math will scale down automatically. Don't do this on a live system.
</details>

<details>
<summary><strong>Does it work on Windows?</strong></summary>

Yes. `scripts/onboard.ps1` handles PowerShell; `scripts/onboard.sh` handles macOS/Linux/Git-Bash. The npm installer picks the right one.
</details>

<details>
<summary><strong>Does it slow Claude Code down?</strong></summary>

It adds a ~10-second onboarding the first time, then nothing. Subsequent sessions just read `.tlae/profile.md` (one short file) at start. The risk gates don't add latency — they replace work that would otherwise need a human review pass.
</details>

<details>
<summary><strong>What if my stack isn't supported?</strong></summary>

You'll see: *"No stack-specific rules for `<framework>`. Falling back to generic rules."* The generic rules still cover risk scoring, validation chain, sensitive-area gates, and `LESSONS.md`. You also get a working baseline you can extend — drop a `stacks/<your-stack>.md` and open a PR.
</details>

<details>
<summary><strong>Is this overkill for solo projects?</strong></summary>

Solo + pre-launch is exactly the profile where TLAE relaxes the most. Risk gates drop, formality drops, but the safety floor (don't silently rm -rf, don't push to main, don't commit secrets) stays. Read [Who this isn't for](#-who-this-isnt-for) above.
</details>

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

## 🗺️ Roadmap

- [ ] More stacks: SwiftUI, Kotlin/Compose, Elixir/Phoenix, Laravel
- [ ] More domains: e-commerce, ML/data, gov/compliance
- [ ] Optional Git hooks that block risky commits without TLAE approval
- [ ] VS Code extension that surfaces risk score in the status bar
- [ ] Telemetry-free usage stats (opt-in, local only) so you can see your own patterns

Have a request? Open an issue.

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
