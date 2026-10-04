# Quickstart — Living Skills

Get a Living Skill working in under 10 minutes.

---

## Prerequisites

- An AI agent with filesystem read/write access (Claude Code, Cursor, Codex, etc.)
- Git installed and configured
- A Git remote (GitHub, GitLab, Gitea, or self-hosted)

---

## Step 1: Clone or fork this repository

```bash
git clone https://github.com/Heimstatt/living-skills.git   # or your fork
cd living-skills
```

The repository already contains the working directory structure:

```
Infrastructure/     ← domain skills for systems and tools
  skills/
Projects/           ← domain skills for ongoing projects
Team Memory/        ← instance memory and behavioral skills
  shared/           ← human-contributed context (decisions, constraints, notes)
  skills/           ← behavioral skills (methodologies, workflows)
```

Your agent will add its own folder under `Team Memory/` during onboarding.

---

## Step 2: Run onboarding

Point your agent at the onboarding guide:

> "Read `setup/onboarding-new-instance.md` and set up this repository for me as a new instance."

To create your first own skill afterwards, use the skill-creator example (`examples/skill-creator/SKILL.md`).

Or follow [onboarding-new-instance.md](onboarding-new-instance.md) manually — it takes about 5 minutes.

---

## Step 3: Create your first skill

Pick a template based on what you want:

**Behavioral Skill** — for workflows, methodologies, how your agent approaches a problem:
```bash
cp -r templates/behavioral-skill/ "Team Memory/skills/my-first-skill/"
```

**Domain Skill** — for a specific system or technical domain:
```bash
# For infrastructure/tooling:
cp -r templates/domain-skill/ Infrastructure/skills/my-system/

# For a project:
mkdir -p Projects/my-project/skills
cp -r templates/domain-skill/ Projects/my-project/skills/my-skill/
```

---

## Step 4: Fill in the template

Open `SKILL.md` and replace all placeholders. The most important fields:

- `name` — short, memorable
- `description` — this is how your agent decides when to use the skill; be specific
- `## Session Start` — what files to read, what context to load
- `## Session End` — what to write back to living-checklist.md

Open `living-checklist.md` and add at least one seed entry.
Start with something you already know — a pitfall, a pattern, a lesson learned.
Do not leave it empty.

---

## Step 5: Tell your agent about the skill

At the start of a session, instruct your agent:

> "Before we begin: read `Team Memory/skills/my-skill/SKILL.md` and
> `Team Memory/skills/my-skill/living-checklist.md`."

At the end of a session:

> "Write any new learnings to the living-checklist and commit."

That's it. The skill will grow from here.

---

## Step 6: Commit and push

```bash
git add "Team Memory/skills/my-skill/"
git commit -m "MyInstance: my-skill — initial skill [$(date +%Y-%m-%d)]"
git push
```

---

## Next Steps

- [agent-configuration.md](agent-configuration.md) — complete CLAUDE.md / Cursor / system prompt examples
- [sync-setup.md](sync-setup.md) — connect multiple instances to the same skill pool
- [onboarding-new-instance.md](onboarding-new-instance.md) — add a second agent or a different model
- [framework.md](../framework.md) — full specification for advanced usage
