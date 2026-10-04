# Agent Configuration — Living Skills

In this repository, all AI tools read from a single source of truth: `TEAM.md`.
You do not configure each agent separately.

---

## How it works

```
TEAM.md  ←──────────────────────── single source of truth
    │
    ├── CLAUDE.md           (symlink)   ← Claude Code reads this
    ├── AGENTS.md           (symlink)   ← Codex reads this
    └── .cursor/rules/
          living-skills.mdc (generated) ← Cursor reads this
```

**Claude Code and Codex** read `TEAM.md` automatically via symlinks.
No separate configuration file needed.

> **Cursor: not actively tested in recent releases; generator kept for reference.**

**Cursor** reads `.cursor/rules/living-skills.mdc`, which is generated from
`TEAM.md` by running:

```bash
# macOS / Linux:
bash scripts/generate-cursor-rules.sh
# Windows (PowerShell):
pwsh scripts/generate-cursor-rules.ps1
```

Run this script whenever `TEAM.md` changes. Commit the result.

---

## Instance-specific configuration

Things that differ per instance (local paths, service URLs, credentials location)
do **not** belong in `TEAM.md`. Put them in:

```
Team Memory/<your-instance>/config.md
```

This file is read-only for all other instances. It is the right place for:
- absolute paths on this machine
- tool-specific setup notes
- pointers to where credentials live (never the credentials themselves)
- anything else that only applies to this one instance

Your instance name in commit messages comes from this file and from the identity
row you added to `TEAM.md` during onboarding.

---

## Adding a new tool or AI model

If you want to connect a tool that is not yet listed in `TEAM.md`:

1. Add a row to the Team table in `TEAM.md`
2. Create `Team Memory/<your-instance>/config.md`
3. Run `scripts/generate-cursor-rules.sh` (or `.ps1` on Windows) if the new tool is Cursor
4. Commit and push

See [onboarding-new-instance.md](onboarding-new-instance.md) for the full flow.

---

## Tested environments

| Environment | Config | Status |
|-------------|--------|--------|
| Claude Code | `CLAUDE.md` → symlink to `TEAM.md` | ✅ Tested |
| Codex (OpenAI) | `AGENTS.md` → symlink to `TEAM.md` | ✅ Tested |
| Cursor | `.cursor/rules/living-skills.mdc` (generated from `TEAM.md`) | ⚠️ Rules load reliably; session rituals not enforced (see below); not actively tested in recent releases; generator kept for reference |
| Generic system prompt | copy TEAM.md content into system field | 🔬 Untested |
| Aider | `.aider.conf.yml` or system prompt | 🔬 Untested |
| Open WebUI | System prompt field | 🔬 Untested |

If you get it working in an environment not listed here, please
[contribute a configuration example](../CONTRIBUTING.md).

---

## Known Limitations — Cursor

> Not actively tested in recent releases; generator kept for reference.

Cursor reads `.cursor/rules/*.mdc` reliably at session start. However:

**Cursor has no session lifecycle hooks.**

Claude Code enforces "pull before acting" and "commit after acting" because
`CLAUDE.md` instructions are processed before every response.

Cursor treats rules as guidelines, not enforced hooks. In practice:

- Cursor may start working without pulling first
- Cursor may complete a task without committing
- There is no automatic fallback if Cursor skips a step

If you use Cursor in a multi-instance setup, verify at the start and end of
each session that it pulled and committed. A brief reminder is enough.

This is not a framework bug. It is a property of the tool.

---

## Human responsibility in collaborative setups

Living Skills does not replace good Git hygiene — it assumes it.

In any multi-instance setup, the following remain human responsibilities:

- Verifying all instances pulled before starting
- Confirming all instances committed and pushed before leaving
- Resolving conflicts that tools did not catch

The framework provides structure. It does not provide enforcement.
