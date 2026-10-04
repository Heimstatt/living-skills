# Living Skills — Team Configuration

> This file is the single source of truth for all AI tools in this repository.
> `CLAUDE.md` (Claude Code) and `AGENTS.md` (Codex) are symlinks pointing here.
> `.cursor/rules/living-skills.mdc` is generated from this file — run `bash scripts/generate-cursor-rules.sh` after edits
> (Cursor: not actively tested in recent releases; generator kept for reference).
> Edit only this file — all tools pick up the changes automatically.

## Who I am

Set your instance name here. It appears in every commit message:
```
<Your-Instance-Name>: <what changed> [YYYY-MM-DD]
```

Examples: `Claude-Desktop`, `Claude-Server`, `Claude-Laptop`

## Repository layout

```
Infrastructure/skills/     ← Domain Skills for systems and tools
Projects/<name>/skills/    ← Domain Skills for specific projects
Team Memory/skills/        ← Behavioral Skills (methodologies, workflows)
Team Memory/<instance>/    ← Your memory: status.md, config.md
Team Memory/shared/        ← Human-contributed context
```

## Session Start

At the beginning of every session involving a Living Skill:

1. `git pull` — get the latest learnings from all instances
2. Read the relevant `SKILL.md` — understand the approach
3. Read the relevant `living-checklist.md` — load accumulated knowledge
4. **Output the Skill Activation Protocol** before beginning work:
   ```
   SKILL ACTIVATED: <skill-name>
   Date: YYYY-MM-DD
   Checklist read: Yes — [N] active entries, newest: [date of most recent entry]
   Active rule: "[verbatim quote of the most recent relevant rule]"
   Approach: [2–3 sentences on what this skill will do in this session]
   ```
   Domain skills add one more line, after `Checklist read:`:
   ```
   Knowledge checked: <date>, against <system/version>
   ```
   State it, do not judge it. Behavioral skills omit this line.

## Session End

After completing a task that used a Living Skill:

1. Write new learnings to `living-checklist.md`:
   ```
   ### [YYYY-MM-DD] — [task context] · *unconfirmed (1 observation)*
   **Learning:** what was discovered or what failed
   **Why it matters:** context and consequences
   **Rule:** a concrete guideline for next time
   **Observed by:** <your instance> (YYYY-MM-DD)
   ```
   The `unconfirmed` marker and `Observed by:` line are **optional**: many teams
   verify before writing, through review and counter-tests, rather than
   confirming later. If you use them and hit a pattern another instance already
   recorded, do not open a second entry — remove its marker and add yourself to
   `Observed by:`.
   Once a checklist has more than 50 entries, keep a `## Distilled Rules` section
   at its top.
2. If skills were added, renamed or removed, refresh the skill mapping
   (symlinks under `~/.claude/skills/`, see `setup/skill-mapping.md`):
   ```bash
   bash scripts/generate-claude-skills.sh
   ```
3. Commit and push:
   ```bash
   git add <skill-path>/living-checklist.md
   git commit -m "<Your-Instance-Name>: <what changed> [YYYY-MM-DD]"
   git push
   ```

## Write boundaries

Write only to your own `Team Memory/<instance>/` folder.
Other instances' folders are read-only — even if a task seems to call for it.
Each instance documents its own work so others can read it.

## Available skills

Update this list as you add skills:

| Skill | Type | Path | Use for |
|-------|------|------|---------|
| **token-optimization** | behavioral | `Team Memory/skills/token-optimization/` | **Proactively before any non-trivial task** — context budget, knowledge reuse, sub-agent strategy, caveman output compression |
| **surgical-changes** | behavioral | `Team Memory/skills/surgical-changes/` | **Any change to existing code** (≥2 files / 20 lines) — scope contract before the edit, R/O/U diff audit after, noticed-list instead of drive-by fixes. Not for typos or one-liners |
| **advocatus-diaboli** | behavioral | `Team Memory/skills/advocatus-diaboli/` | Critical analysis, strategy review, stress-testing assumptions |
| **secure-architecture** | behavioral | `Team Memory/skills/secure-architecture/` | Auth/authorization model reviews: AuthN≠AuthZ, stable-ID anchors, SoD in the data model, protecting authorization records |
| **business-analysis** | behavioral | `Team Memory/skills/business-analysis/` | BABOK/CBAP procedure: stakeholders → personas → user stories with AC → FR/NFR → gap analysis → risk register → out-of-scope |
| **skill-creator** | behavioral | `Team Memory/skills/skill-creator/` | Creating new Living Skills |
| **pair-review** | behavioral | `Team Memory/skills/pair-review/` | Cross-model code review: findings, critical response, re-review against a named commit |
| **strategy** | behavioral | `Team Memory/skills/strategy/` | Strategy staff unit: diagnose the question, route to a role (`roles/`), return advice to the owning department |
| **home-assistant** | domain | `Infrastructure/skills/home-assistant/` | HA automations, entities, integrations, debugging |
| **playwright** | domain | `Infrastructure/skills/playwright/` | Browser automation and visual UI checks with playwright-cli |
| **siyuan** | domain | `Infrastructure/skills/siyuan/` | **Deprecated** — optional example of a human-readable layer; use Obsidian instead ([`setup/obsidian-sync.md`](setup/obsidian-sync.md)) |
| *(browse)* | domain | `Infrastructure/skills/` | Other domain skills — systems and tools |

**Token optimization — proactive rule:** Activate `token-optimization` **without being asked** whenever a task will likely consume >10K tokens, involve sub-agents, or use multiple MCP tools. Exempt: short answers, single-turn Q&A.

## First time setup?

See [`setup/onboarding-new-instance.md`](setup/onboarding-new-instance.md).
