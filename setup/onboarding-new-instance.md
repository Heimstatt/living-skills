# Onboarding a New Instance

How to add a new agent or AI model to an existing Living Skills pool.

---

## What "onboarding" means

Adding a new instance means two things:
1. Registering it in the shared team context (`TEAM.md`)
2. Giving it its own memory folder (`Team Memory/<your-instance>/`)

The skills themselves do not need to change. They are model-agnostic by design.

**Before you start:** This assumes a team context (`TEAM.md`) already exists.
If you are setting up the shared environment from scratch, read
[`team-charter-setup.md`](team-charter-setup.md) first.

---

## Step 1: Access to the Repository

Follow [sync-setup.md](sync-setup.md) to connect the new machine or environment
to the shared Git remote.

```bash
git clone <remote-url> living-skills
cd living-skills
git log --oneline -5   # verify you see commits from other instances
```

---

## Step 2: Register in TEAM.md

Open `TEAM.md` and add a row for the new instance to the Team table:

```markdown
| **Your-Instance-Name** | Tool (Claude Code / Cursor / Codex / …) | `Team Memory/your-instance/` |
```

Also add your folder to the repository layout section if it has one.

Choose an instance name that appears in commit messages:
```
Your-Instance-Name: home-assistant — fix motion automation trigger [YYYY-MM-DD]
```

Examples: `Claude-Desktop`, `Claude-Server`, `Codex-Laptop`, `Cursor-Desktop`

---

## Step 3: Create your Team Memory folder

```bash
mkdir -p "Team Memory/your-instance"
```

Create `Team Memory/your-instance/config.md` with instance-specific details:

```markdown
# Your-Instance-Name — Configuration

**Identity:** Your-Instance-Name — [tool] on [machine description]

## Repository path
/absolute/path/to/living-skills

## Notes
[Any local paths, service URLs, or setup notes specific to this instance.
Never put credentials here — only note where they live.]
```

Create `Team Memory/your-instance/status.md` for session notes (can start empty).

### How the agent knows who it is

Identity is established in two layers:

**Outside the repo (machine-local):** Your tool's global configuration tells the
agent its instance name. For Claude Code this is `~/.claude/CLAUDE.md` or a
project-level memory file; for other tools, their equivalent global config.
Add one line: `My instance name is: Your-Instance-Name`

**Inside the repo:** `Team Memory/your-instance/config.md` reinforces identity
with an explicit declaration (`Identity: Your-Instance-Name — [tool] on [machine]`).
At session start, `TEAM.md` instructs every instance to read its own config.md —
the agent finds the right one because it matches the identity it already knows
from the machine-local config.

The two-layer approach means: the repo stays machine-agnostic; each machine
contributes only its own folder; no instance accidentally reads another's config.

---

## Step 4: Update Cursor rules (if applicable)

> Cursor: not actively tested in recent releases; generator kept for reference.

If any instance in the team uses Cursor, regenerate the Cursor rules file:

```bash
# macOS / Linux:
bash scripts/generate-cursor-rules.sh
# Windows (PowerShell):
pwsh scripts/generate-cursor-rules.ps1
```

This keeps `.cursor/rules/living-skills.mdc` in sync with the updated `TEAM.md`.

---

## Step 5: Commit and push

```bash
git add TEAM.md "Team Memory/your-instance/" .cursor/rules/living-skills.mdc
git commit -m "Your-Instance-Name: onboard new instance [$(date +%Y-%m-%d)]"
git push
```

---

## Step 6: Run a first session

Pick one existing skill and use it for a real task:

1. `git pull`
2. Read the relevant `SKILL.md`
3. Read the relevant `living-checklist.md`
4. Complete the task
5. Write at least one entry to `living-checklist.md`
6. Commit and push

Verify on another instance:
```bash
git pull
cat "Team Memory/skills/<skill-name>/living-checklist.md"
```

The new instance's entry should appear. The loop is closed.

---

## Notes on Different Model Families

Living Skills work with any model that can read files, write files, and run Git.

**Claude Code:** Built-in filesystem and bash access. Works out of the box.
`CLAUDE.md` is a symlink to `TEAM.md` — no separate configuration needed.

**OpenAI Codex:** Filesystem access via editor integration.
`AGENTS.md` is a symlink to `TEAM.md` — same pattern.

**Cursor** (not actively tested in recent releases; generator kept for reference): Reads `.cursor/rules/living-skills.mdc`, generated from `TEAM.md`.
Run `scripts/generate-cursor-rules.sh` (macOS/Linux) or `.ps1` (Windows) after any `TEAM.md` change.

**Local models via agent frameworks (Ollama, LM Studio, etc.):**
Requires a framework that provides file tools. Copy `TEAM.md` content into
the system prompt, or point the agent at the file directly.

**Aider:** Can read/write files natively. Add the repository to its working directory.

---

## What different models bring

Different model families approach problems differently. This is a feature:

- One model may catch patterns another misses
- Different reasoning styles produce richer living-checklists over time
- The skill grows from multiple perspectives

Do not normalize entries across models. Diversity in the checklist is the point.
