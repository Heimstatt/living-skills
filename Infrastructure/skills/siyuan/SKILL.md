---
name: "Siyuan Knowledge Base"
description: "Use for ANY Siyuan setup, configuration, or sync work — connecting Siyuan to a Living Skills repo, MCP setup, API access, notebook structure, Git sync. Trigger: 'Siyuan', 'knowledge base', 'LLM wiki', 'sync to knowledge base'."
type: "domain"
living-checklist: "yes"
---

# Siyuan Knowledge Base — Living Skill

> **Deprecated — no longer maintained, kept as an optional example of a human-readable layer.**

Knowledge checked: <date>, against Siyuan <version>
> The maintained human layer is an Obsidian vault mirrored from the repository — see
> [`setup/obsidian-sync.md`](../../../setup/obsidian-sync.md).

*Template example of a domain skill. Hosts, IDs and paths are placeholders — replace them
with your own.*

Siyuan is an open-source, self-hostable knowledge base that serves as the human-readable
layer in a Living Skills setup. Agents write to Git; Siyuan mirrors the content for
human navigation, search, and annotation.

**Session Start:** Read `living-checklist.md` first.

---

## What Siyuan Does in This Framework

```
Git repository (authoritative)
       │
       │  sync-to-siyuan.sh (session-end, after git push)
       │  Only writes docs whose content actually changed (diff-before-write).
       │  Unchanged docs keep their Siyuan timestamp.
       ▼
Siyuan Knowledge Base (human-readable view)
       │
       │  Human reads, annotates, adds notes → Siyuan timestamp updates
       │
       │  check-siyuan-edits.sh (session-start)
       │  Compares Siyuan timestamps against last Git commit.
       │  Any doc with a newer timestamp = human edit.
       ▼
Agent reads human edits at session start → incorporates into work
```

Git is the source of truth. Siyuan is the reading and annotation interface.
Human edits in Siyuan are detected at session start and flow into the agent's work.
At session end, the agent's output goes through Git → Siyuan as usual.

**Important:** The sync script runs after every successful `git push` — not via a daemon,
not via a git hook. The agent is responsible. This ensures the sync always reflects
the complete, merged state of the repository.

---

## Setup — Interactive Onboarding

Work through these steps with the user when setting up Siyuan for a new instance:

### Step 1: Deployment

Ask the user:
> "Are you running Siyuan yourself, or using a hosted version?"

**Self-hosted (recommended for full control):**
- Docker: `docker run -d -p 6806:6806 -v /path/to/workspace:/siyuan/workspace b3log/siyuan`
- Default URL: `http://localhost:6806`
- Set an access token in Settings → About → API Token

**Hosted / cloud:**
- Note the URL provided by the hosting service
- Retrieve API token from account settings

---

### Step 2: Notebook Structure

Ask the user:
> "Do you want one notebook per domain (Infrastructure, Projects, Team Memory)
> or one shared notebook for everything?"

**Recommended:** One notebook named after your team or project.
Subdirectory structure mirrors the Git repo:
```
<NotebookName>/
  Infrastructure/
  Projects/
  Team Memory/
```

Note the Notebook ID — you will need it in the next step.
Find it via: Siyuan → Settings → About → Notebook ID, or from the URL when viewing the notebook.

---

### Step 3: Create the .env File

The sync script reads credentials from a `.env` file at the repo root.
This file is excluded from Git (listed in `.gitignore`) — each instance creates it locally.

Create `<repo-root>/.env`:
```bash
SIYUAN_URL="http://<host>:6806"
SIYUAN_TOKEN="<your-token>"
SIYUAN_NOTEBOOK_ID="<notebook-id>"
```

**Test the connection:**
```bash
curl -s http://<host>:6806/api/system/version \
  -H "Authorization: Token <your-token>"
# Should return: {"code":0,"data":{"ver":"..."}}
```

---

### Step 4: Run the First Sync

```bash
git push && bash Infrastructure/skills/siyuan/scripts/sync-to-siyuan.sh
```

Check the output — files should show `UPDATE`, `CREATE`, or `SKIP (unchanged)`.
Then open Siyuan and verify the notebook structure matches your repo.

**Note:** The sync uses diff-before-write — it compares a word fingerprint of the Git
content against the Siyuan export and only writes if content actually changed. This
preserves Siyuan timestamps on unchanged docs, which is essential for human-edit detection.

---

### Step 5: Add to Session Rituals

Add these to your `TEAM.md` (or equivalent agent config):

**Session start:**
```bash
git pull --rebase
bash Infrastructure/skills/siyuan/scripts/check-siyuan-edits.sh
# Review any human edits before starting work
```

**Session end:**
```bash
git add <changed files>
git commit -m "<Instance>: <what> [YYYY-MM-DD]"
git push && bash Infrastructure/skills/siyuan/scripts/sync-to-siyuan.sh
```

The `&&` ensures Siyuan sync only runs after a successful push.
The script syncs ALL `.md` files — whoever pushes last writes the complete state to Siyuan.

---

### Step 6: MCP Access (optional, for agents)

MCP lets agents query Siyuan directly — useful for reading human annotations at session start.

**Install:** `siyuan-mcp` (check npm for current version)

**Claude Code config** (`~/.claude.json`):
```json
{
  "mcpServers": {
    "siyuan": {
      "command": "npx",
      "args": ["-y", "siyuan-mcp"],
      "env": {
        "SIYUAN_URL": "http://<host>:6806",
        "SIYUAN_TOKEN": "<your-token>"
      }
    }
  }
}
```

Restart Claude Code for MCP tools to activate.

---

## Proven Approaches

- Always test the API connection before running the sync script
- Use the Notebook ID, not the display name — display names can change, IDs don't
- The sync script derives the Siyuan HPath from the first `# H1` heading in each file.
  If a heading changes, Siyuan creates a new document instead of updating the existing one.
- Run sync only after `git push` — never before. A failed push means another instance
  may have newer changes; syncing before rebasing would push a stale state to Siyuan.

---

## Known Limitations

**Markdown roundtrip differences:** Siyuan's Markdown parser transforms some formatting
on export (e.g., table whitespace, code block markers, special characters). For documents
where the roundtrip changes the word content, the sync will rewrite them every time —
giving them a fresh timestamp and causing false positives in the human-edit check.

The affected documents tend to be the same on every run, so agents can learn to
recognize them.

## Open TODOs

- [ ] Reduce roundtrip differences (investigate Siyuan export API options)
- [ ] Notion equivalent of this skill
- [ ] Obsidian equivalent of this skill

---

## Session End

After each session: write new learnings, configuration patterns, API quirks,
or sync edge cases to `living-checklist.md`.
Commit, push, and sync to Siyuan.
