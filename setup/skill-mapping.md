# Skill Mapping — Making Skills Visible to Your Tools

How to let tools that expect their own skill location find the skills in this repo,
without copying them.

---

## The Problem

Skills live in one shared place (`Team Memory/skills/`, `Infrastructure/skills/`), in a
nested structure organised for humans. **No tool finds them there on its own.** Each tool
looks in its own location and expects its own format:

| Tool | Looks in | Format | Bridge |
|------|----------|--------|--------|
| Cursor | `.cursor/rules/*.mdc` | one generated text file | `scripts/generate-cursor-rules.sh` |
| Claude Code | `.claude/skills/<name>/SKILL.md` or `~/.claude/skills/<name>/SKILL.md` | one directory per skill | `scripts/generate-claude-skills.sh` |

Claude Code discovers skills **only** in `.claude/skills/<name>/SKILL.md` (project) and
`~/.claude/skills/<name>/SKILL.md` (user, applies to all projects). There is no settings key
for additional skill paths, so a path like `Team Memory/skills/<department>/roles/<name>/`
is never discovered by itself. Symlinks are the documented way around this.

The file name matters: Claude Code recognises `SKILL.md` exactly, and on case-sensitive
file systems `Skill.md` is a different file.

---

## The Principle: A Card Index, Not a Copy

The shared repo stays the **single source**. What gets created per tool is a set of
**references**, not copies.

> The repo is the shelf. `~/.claude/skills/` is the card index that says where each book
> stands. Every machine has its own card index, but all of them point at the same shelf.

So a per-machine `~/.claude/skills/` does not contradict the shared repo. When one instance
changes a skill, every other instance sees the change after its next `git pull` — there is
nothing to re-sync and nothing that can drift apart.

The script is committed to the repo: one shared generator that each instance runs locally,
rather than each instance building its own.

---

## `generate-claude-skills.sh`

```bash
bash scripts/generate-claude-skills.sh            # create and update links
bash scripts/generate-claude-skills.sh --dry-run  # only show what would happen
```

What it does:

- Creates one **symlink** per skill under `~/.claude/skills/<name>/`, pointing into the repo.
  Claude Code follows the link and reads `SKILL.md` together with `references/` and `assets/`
  from the target directory.
- Copies nothing.
- Is idempotent. Orphaned links from earlier runs are removed — but **only links that point
  into this repo**. Other skills in the same directory are left untouched.
- Derives the repo path from its own location, so there is nothing to configure.

**Examples are not mapped.** The script only searches `Team Memory/skills/` and
`Infrastructure/skills/`. The skills under `examples/` are references; copy the ones you want
to use into one of the two skill folders first, then run the script. In a fresh clone it
finds only the deprecated Siyuan skill.

Override the target directory with `CLAUDE_SKILLS_DIR`:

```bash
CLAUDE_SKILLS_DIR=/path/to/skills bash scripts/generate-claude-skills.sh
```

**Requires bash >= 4.** macOS ships bash 3.2. The script tries to re-run itself under a newer
bash if one is installed (for example via `brew install bash`) and otherwise aborts with an
error — it does not fail silently.

**When to run it:** whenever skills are added, renamed, or removed. Run it on every machine
that uses Claude Code.

---

## When the List Gets Long

Every mapped skill's description costs context budget. If that becomes a problem, individual
skills can be adjusted via `skillOverrides` in Claude Code's `settings.json` — hidden
(`"off"`), set to manual invocation only (`"user-invocable-only"`), or listed without a
description (`"name-only"`) — **without touching the skill files themselves**.

In the organisational model ([framework-organisation.md](../framework-organisation.md)) a human
normally only needs to know the department heads, so internal role skills are the first
candidates to hide.

---

## See Also

- [framework.md](../framework.md) — the Living Skills framework
- [known-gaps.md](../known-gaps.md) — known limitations
