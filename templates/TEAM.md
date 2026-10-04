# Team Name — Shared Context

> This file is the single source of truth for team-specific operating rules in this repository.
> Tool-specific entrypoints such as `CLAUDE.md`, `AGENTS.md`, or Cursor rules should point here
> or mirror its content as closely as the tool allows.

## Team

| Identity | Tool | Writes in |
|----------|------|-----------|
| `Example-Mac` | Claude Code | `Team Memory/example-mac/` |
| `Example-Codex` | OpenAI Codex | `Team Memory/example-codex/` |
| `Example-Cursor` | Cursor | `Team Memory/example-cursor/` |

## Write Rule

Each identity reads the whole repository but writes only to its own designated area.
Other identities' memory folders are read-only unless a task explicitly requires collaboration
in a shared area.

Collaborative areas should be named explicitly here, for example:
- `Team Memory/shared/`
- `Team Memory/skills/`
- selected documentation folders

## Repository Layout

```text
Infrastructure/           ← domain documentation and domain skills
Projects/                 ← project-specific documentation and project skills
Team Memory/
  <identity>/             ← one folder per persistent participant
  shared/                 ← shared human/team context
  skills/                 ← behavioral skills
```

## Session Start

```bash
git pull --rebase && git log --oneline -5
```

Then read:
1. this `TEAM.md`
2. your own `Team Memory/<identity>/config.md` if used
3. the relevant `SKILL.md` and `living-checklist.md` for the current task

If your workflow requires additional startup checks, define them here.

## Session End

```bash
git add <changed-files>
git commit -m "<Identity>: <what changed> [YYYY-MM-DD]"
git push
```

If your environment requires additional sync steps after push, define them here.

## Living Skills

Behavioral skills live in:
- `Team Memory/skills/`

Domain skills live in:
- `Infrastructure/skills/`
- `Projects/<project>/skills/`

For every skill use:
1. Read `SKILL.md`
2. Read `living-checklist.md`
3. Output the Skill Activation Protocol in the conversation — domain skills additionally
   state the line `Knowledge checked: <date>, against <system/version>`
4. Write back reusable learnings after the task if something new was learned

## Tool Bindings

- `CLAUDE.md` should symlink to or import `TEAM.md`
- `AGENTS.md` should symlink to or import `TEAM.md`
- Cursor should mirror the relevant rules in `.cursor/rules/`

## Local Environment Notes

Document here:
- important local paths
- location of credentials (not the secret values themselves)
- service URLs
- machine names
- environment-specific caveats

## Language and Conventions

- Documentation language: [set this]
- Commit language/style: [set this]
- Naming rules for identities: [set this]
