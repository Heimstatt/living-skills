# Sync Setup — Multi-Instance Living Skills

How to share a skill pool across multiple agents, machines, or AI models.

---

## The Model

Git is the sync layer. Every instance reads from and writes to the same remote repository.
No custom sync protocol, no special infrastructure beyond what Git already provides.

```
Instance A (Claude Code, Machine 1)
    ↓ git pull before session
    ↑ git push after session
         ↕
    Git Remote (GitHub / GitLab / Gitea / self-hosted)
         ↕
    ↓ git pull before session
    ↑ git push after session
Instance B (Codex, Machine 2)
```

The living-checklist.md files are plain Markdown. Any agent that can read a file
and run `git pull` / `git push` can participate.

---

## Option 1: GitHub / GitLab (simplest)

Best for: small teams, public or private repos, cloud-based sync.

**Setup:**
1. Create a repository on GitHub or GitLab
2. Add each instance as a collaborator (or use a shared deploy key)
3. Each machine clones the repo
4. Each agent runs `git pull` at session start, `git push` at session end

**For agents without direct internet access:**
Use a personal access token (PAT) stored in the environment:
```bash
git remote set-url origin https://<token>@github.com/your-org/living-skills.git
```

---

## Option 2: Self-Hosted Git (Gitea / Forgejo)

Best for: air-gapped networks, homelabs, full data sovereignty.

**Setup (Docker example):**
```bash
docker run -d \
  --name gitea \
  -p 3000:3000 \
  -p 2222:22 \
  -v gitea_data:/data \
  gitea/gitea:latest
```

1. Create repository in Gitea web UI
2. Generate SSH keys for each instance:
   ```bash
   ssh-keygen -t ed25519 -C "instance-name" -f ~/.ssh/living-skills-instance
   ```
3. Add public key to Gitea user settings
4. Clone via SSH:
   ```bash
   git clone git@<gitea-host>:your-user/living-skills.git
   ```

---

## Option 3: Shared Network Folder (simplest for local networks)

Best for: instances on the same local network, no internet dependency.

Use a bare Git repository on a NAS or file server:

```bash
# On the server / NAS:
mkdir -p /shared/living-skills.git
cd /shared/living-skills.git
git init --bare

# On each client machine:
git clone /mnt/nas/living-skills.git
# or via SSH:
git clone user@fileserver:/shared/living-skills.git
```

Each instance treats the bare repo as its remote. Pull before, push after.

**Note:** Avoid direct file sharing (SMB/NFS mount) without Git — concurrent writes
will corrupt the living-checklist files. Always go through Git.

---

## Session Discipline

Multi-instance sync only works if every instance follows the same discipline:

```bash
# Session start (always):
git pull

# ... do the work, read SKILL.md, read living-checklist.md ...

# Session end (always):
# If TEAM.md changed, regenerate cursor rules first:
bash scripts/generate-cursor-rules.sh   # macOS / Linux
pwsh scripts/generate-cursor-rules.ps1  # Windows

git add <skill-path>/living-checklist.md .cursor/rules/living-skills.mdc
git commit -m "<Instance>: <what changed> [YYYY-MM-DD]"
git push
```

If `git push` fails due to concurrent changes by another instance:
```bash
git pull --rebase
git push
```

Living-checklist files are append-only by convention. Rebasing almost never
produces meaningful conflicts — different instances write to different entries.

---

## Conflict Resolution

If a merge conflict occurs in `living-checklist.md`:

1. Keep both versions — never delete another instance's entries
2. Manually join the two versions (append the other instance's entries below yours)
3. Commit the resolved file

If a conflict occurs in `SKILL.md`:
1. Stop — this requires human judgment
2. Review both versions, decide which reflects current best practice
3. Commit with a clear message explaining the decision

---

## Automating Pull/Push (Optional)

For instances running on a schedule or as a service, automate the sync:

**Pre-session hook (example):**
```bash
#!/bin/bash
cd /path/to/living-skills
git pull --rebase --autostash
```

**Post-session hook (example):**
```bash
#!/bin/bash
cd /path/to/living-skills
git add skills/
git diff --cached --quiet || git commit -m "$INSTANCE_NAME: session end [$(date +%Y-%m-%d)]"
git push
```

Set `INSTANCE_NAME` as an environment variable on each machine.

---

## Human-Readable Layer: Obsidian (Optional)

Humans can read and edit the same Markdown in an Obsidian vault. A scheduled wrapper pulls,
mirrors `*.md` files between repository and vault, and commits vault edits with the human as
author and the agent instance as committer. Conflicts stop the run instead of overwriting;
bulk changes (more than 15 files, any deletion or rename) are left for a human.

Setup, configuration and scheduling: [`obsidian-sync.md`](obsidian-sync.md).
Rename folders with `git mv` in the repository, never inside Obsidian.

---

## Verifying the Setup

To check that all instances are synced:
```bash
git log --oneline --all | head -20
```

You should see commits from multiple instances interleaved in the history.
That's the system working as intended.
