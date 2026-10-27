# Living Skills for a Software Team

A short path for a development or DevOps team that wants the software-relevant skills without
adopting a whole multi-agent setup. You get a shared repository of methods your agents load
before they work, and that the team extends with its own experience.

---

## What you take over

| Skill | Use it for | Start with it? |
|---|---|---|
| [`surgical-changes`](../examples/surgical-changes/SKILL.md) | Every change to existing code: scope contract before the edit, hunk-by-hunk diff audit after | **Yes** |
| [`pair-review`](../examples/pair-review/SKILL.md) | Review between two agents (ideally two model families): findings, a critical answer to each, re-review against a named commit | **Yes** |
| [`business-analysis`](../examples/business-analysis/SKILL.md) | New features or products: stakeholders, requirements with acceptance criteria, gaps, risks, out of scope | **Yes** |
| [`secure-architecture`](../examples/secure-architecture/SKILL.md) | Authentication and authorization design, "only X may do Y" requirements | When such work comes up |
| [`advocatus-diaboli`](../examples/advocatus-diaboli/SKILL.md) | Challenging a plan or architecture decision before it is built | When a decision is expensive to reverse |
| [`token-optimization`](../examples/token-optimization/SKILL.md) | Planning larger agent tasks: context budget, reuse, when to use sub-agents | Once tasks get long |
| [`playwright`](../examples/playwright/SKILL.md) | Checking a web UI in a real browser instead of trusting the code | If you build web front ends |
| [`skill-creator`](../examples/skill-creator/SKILL.md) | Writing your own skills (domain skills for your systems, team workflows) | After the first weeks |

The checklists ship with **seed rules**: generalised rules distilled from long use of each skill.
They are a starting point, not your experience. Your own entries go below them.

What you do **not** need: instance memory folders, chat integrations, scheduled routines,
knowledge-base sync. All of that is optional and described elsewhere in `setup/`.

---

## Setup (about 30 minutes)

1. **Create a team repository** (internal Git server is fine) and copy the structure:
   ```bash
   TEAM_REMOTE="https://git.example.com/your-team/team-skills.git"   # replace with your remote
   git clone https://github.com/Heimstatt/living-skills.git team-skills
   cd team-skills
   mkdir -p "Team Memory/skills"
   for s in surgical-changes pair-review business-analysis secure-architecture \
            advocatus-diaboli token-optimization skill-creator; do
     cp -r "examples/$s" "Team Memory/skills/$s"
   done
   mkdir -p Infrastructure/skills && cp -r examples/playwright Infrastructure/skills/playwright
   git remote set-url origin "$TEAM_REMOTE"
   ```
2. **Write `TEAM.md`** from [`templates/TEAM.md`](../templates/TEAM.md): team name, the repository
   layout, session start and end, and a skill register (one row per skill with "when to use").
   The register is what makes agents pick a skill without being told. Keep `CLAUDE.md` and
   `AGENTS.md` as symlinks to `TEAM.md`, so Claude Code and Codex read the same rules.
3. **Make the skills discoverable** for Claude Code: `bash scripts/generate-claude-skills.sh`
   links every skill into `~/.claude/skills/` (run it on each machine, again after adding or
   renaming skills). Codex reads `AGENTS.md` and follows the paths in the register.
   See [`skill-mapping.md`](skill-mapping.md).
4. **Name each agent instance** (for example `<team>-laptop-claude`, `<team>-ci-codex`). The name
   goes into commit messages and checklist entries, so a later reader knows who learned what.
5. **Commit and push.** Every agent pulls at session start; that is how one agent's lesson
   reaches the others.

---

## The two rules that make it work

1. **Read before use.** Before an agent applies a skill, it reads `SKILL.md` and
   `living-checklist.md` and writes the activation block (skill, date, number of entries,
   the most relevant rule quoted verbatim, the approach). The quote proves the checklist was
   read, not just opened.
2. **Write back after use, with evidence.** When something went wrong or nearly went wrong and
   would go wrong again without a reminder, the agent adds an entry to the checklist and commits.
   Every new entry names its evidence in an `**Evidence:**` line: the commit, ticket or PR where
   it happened. Without it, nobody can later check whether the rule is still true.

Humans review checklist changes like code. A rule nobody can trace back gets removed.

---

## First weeks

- **Week 1:** `surgical-changes` on every change to existing code, `pair-review` on every
  merge request an agent prepared. Expect friction: the contract and the audit feel slow until
  the first unrequested change is caught.
- **Week 2–3:** `business-analysis` for the next feature that starts from scratch.
  `secure-architecture` when a permission question appears.
- **After a month:** read the checklists together. Which entries were added, which seed rules
  never mattered for you? Delete what does not fit your team, and write your first own domain
  skill with `skill-creator` (for example for your deployment pipeline).

---

## Limits

- The skills are text. They guide an agent; they do not enforce anything. Where a step must
  happen exactly the same way every time, write a script or a CI check and let the skill point
  to it.
- Seed rules are generalised from one team's practice. Treat each as a hypothesis for yours.
