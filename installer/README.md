# tlae

> **One-command installer for TLAE — Tech Lead Agentic Engineering.**
> A Claude Code skill that adapts to your stack, risk profile, and domain.

## Install

```bash
npx tlae
```

That's it. Installs the TLAE skill to `~/.claude/skills/tlae`.

Open Claude Code on any project and say `use tlae` to activate it.

## Targets

| Command | Where it installs |
|---|---|
| `npx tlae` | `~/.claude/skills/tlae` (default) |
| `npx tlae --project` | `./.claude/skills/tlae` (current project only) |
| `npx tlae --cursor` | `./.cursor/rules/tlae` |
| `npx tlae --codex` | `~/.codex/skills/tlae` |
| `npx tlae --gemini` | `~/.gemini/skills/tlae` |
| `npx tlae --aider` | `./.aider/skills/tlae` |
| `npx tlae --all` | All of the above |

## Options

- `--force` / `-f`: overwrite existing install
- `--help` / `-h`: show help
- `--version` / `-v`: show version

## What is TLAE?

A Claude Code skill that turns the agent into a disciplined Tech Lead:

- Auto-detects your stack (11 languages, 15 frameworks)
- Asks 3 questions on first use (team size, domain, production state)
- Computes a dynamic risk score for every task
- Refuses to touch sensitive areas (auth, billing, schema, secrets) without approval
- Learns from each fix into a project-local `LESSONS.md`

Full docs: https://github.com/Brainboxai-IL/tlae

## License

MIT.
