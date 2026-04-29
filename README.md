# 🧠 TLAE — Tech Lead Agentic Engineering

> **A Claude Code skill that adapts to your project — not a generic checklist.**

Most "AI engineering rules" are static text. They tell a junior dev and a staff engineer the same thing, regardless of stack, team size, or whether you're shipping to live customers or playing on localhost.

This skill is different. On first run it:

1. **Detects your stack** — language, framework, package manager, tests, CI, deployment.
2. **Asks 3 questions** — team size, domain, production state.
3. **Writes a profile** to `.tlae/profile.md` and uses it from then on.

Every workflow, risk gate, and validation command is then **scoped to that profile**.

---

## Why this exists

Same task, different worlds:

> *"Add a `referrer_url` column to the `signups` table."*

| Profile | Risk score | What happens |
|---|---|---|
| Solo, B2C, pre-launch | **2/10** | Proceed with brief plan |
| Small team, B2B SaaS, live | **6/10** | Plan-first, approval, tests required |
| Larger team, fintech, paying customers | **7/10** | **Stop.** Analysis-only until exact diff approved |

A static checklist gives all three the same answer. This skill doesn't.

---

## Install

```bash
# Clone into your Claude Code skills directory
cd ~/.claude/skills
git clone https://github.com/Brainboxai-IL/tlae

# Or into a single project
mkdir -p .claude/skills && cd .claude/skills
git clone https://github.com/Brainboxai-IL/tlae
```

That's it. The next time you open a repo in Claude Code, it'll run onboarding.

---

## What you get

### Auto-detection (first run)
The onboarding script identifies:
- Languages: JS / TS / Python / Rust / Go / Java / Ruby / PHP / Elixir / C# / Swift
- Frameworks: Next.js / Nuxt / Vite / Remix / SvelteKit / Astro / Django / FastAPI / Flask / Rails / Spring / Tauri / ...
- Package managers: pnpm / yarn / bun / npm / cargo / poetry / uv / pipenv / pip / bundler / composer / mix
- Databases: Prisma / Drizzle / Supabase / Django ORM / Rails AR / sqlx / sea-orm / diesel
- CI: GitHub Actions / GitLab CI / CircleCI
- Deployment: Vercel / Netlify / Docker / Kubernetes / Fly / Railway

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
The skill loads the right rules for the right stack. Examples:

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
> *"This surprised me — should I add it to LESSONS.md?"*

Your project gets smarter every session.

---

## Files

```
SKILL.md                        Entry point + risk calculator
scripts/
  onboard.sh / onboard.ps1      Auto-detect + write profile
  validate.sh                   Run typecheck → lint → test from profile
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
```

---

## Manual override

Edit `.tlae/profile.md` any time. The skill re-reads it every session.

To force re-detection:
```bash
sh scripts/onboard.sh --update
# or
pwsh scripts/onboard.ps1 -Update
```

---

## Why "agentic engineering"?

Because in 2026 the bottleneck isn't writing code — it's making sure the AI doesn't ship the wrong code. This skill enforces the rules that real tech leads enforce on real teams:

- Read before edit.
- Plan before edit.
- Confirm APIs exist before using them.
- Smallest safe diff.
- Tests at Risk 2+.
- Stop at Risk 3+ for explicit approval.
- Record what you learned.

Same playbook, AI-native.

---

## Contributing

Missing a stack? Drop a `stacks/<your-stack>.md` and PR.
Missing a domain? Same with `domains/<your-domain>.md`.

The skill is designed to grow.

---

## License

MIT.
