# Obsidian Sync — The Human-Readable Layer

Git stays authoritative. Obsidian is where a human reads, searches and edits the same
Markdown files. This page describes the pattern and the two scripts that implement it:

- [`scripts/sync-obsidian-mirror.py`](../scripts/sync-obsidian-mirror.py) — a conflict-safe,
  Markdown-only mirror between the repository and an Obsidian vault
- [`scripts/sync-obsidian-git.sh`](../scripts/sync-obsidian-git.sh) — the scheduled wrapper:
  pull, mirror, then commit and push what a human changed in Obsidian

It replaces the earlier Siyuan sync, which is deprecated (see
[`Infrastructure/skills/siyuan/`](../Infrastructure/skills/siyuan/SKILL.md)). The design
question behind both is recorded in [`known-gaps.md`](../known-gaps.md) under
*Human-Readable Layer as Two-Way Channel*.

---

## The Mirror

`sync-obsidian-mirror.py` copies `*.md` files between the repository and a folder inside the
vault (default `Repo Mirror`). Nothing else is copied — no images, no `.obsidian/` settings.
Repository files are the ones Git knows about (tracked plus untracked, minus ignored);
`.git`, `.obsidian`, `.obsidian-sync-trash` and `node_modules` are skipped.

After every successful run the script stores a hash of each file that is identical on both
sides (in `.git/obsidian-mirror-state.json`). The next run compares three versions — repo,
vault, and that last common state — and decides per file:

| Situation | Action |
|-----------|--------|
| Changed only in the vault | **Imported** into the repository |
| Changed only in the repository | **Exported** into the vault |
| Changed on both sides | **Stop.** Nothing is overwritten; the script lists the files and exits with code 2 |
| Deleted in the vault, still in the repository | **Restored** from the repository |
| Deleted in Git, unchanged in the vault | **Moved** to `.obsidian-sync-trash/<timestamp>/` in the vault — recoverable, not deleted |

A conflict stops the whole run before any file is touched. A human resolves it, and the next
run continues.

Other safeguards in the script:

- A lock file (`.git/obsidian-mirror.lock`) prevents two runs at once.
- Files are written via a temporary file and an atomic rename.
- If iCloud holds a file locked while it syncs, the file is retried and then skipped for this
  run instead of crashing the sync.
- `--export-only` publishes repository changes but never imports from Obsidian. If the vault
  holds a change that has not been imported yet, the run stops with a conflict (exit 2) and
  exports nothing; run once without the flag first. (Known limitation: it reports this as
  "both sides differ" even when only the vault changed.)

## The Git Wrapper

`sync-obsidian-git.sh` is the entry point for the scheduler. One run:

1. `git pull --rebase --autostash` — bring the clone up to date
2. `sync-obsidian-mirror.py` — reconcile repository and vault
3. If Markdown files changed in the working tree (i.e. came in from Obsidian): commit and push
   them

Commits keep both parties visible: the **author** is the human who edited in Obsidian
(`OBSIDIAN_AUTHOR_NAME`, `OBSIDIAN_AUTHOR_EMAIL`), the **committer** — and signature, if the
clone signs — is the clone's own identity, i.e. the agent instance running the job.

**The brake.** If more than 15 files changed, or any change is a deletion or rename, the
wrapper commits nothing and reports the problem. Such changes usually mean a bulk operation
in Obsidian (a renamed folder, for example), and a human must look at `git status` first.

Failures raise one macOS notification per distinct problem, not one on every run.

## Configuration

| Setting | Where | Default |
|---------|-------|---------|
| Vault root | `--vault <path>` or `OBSIDIAN_VAULT_ROOT` | the iCloud Obsidian folder `<Your Vault>` (edit `DEFAULT_VAULT` in the script) |
| Mirror folder inside the vault | `OBSIDIAN_MIRROR_DIR` | `Repo Mirror` |
| Commit author for vault edits | `OBSIDIAN_AUTHOR_NAME`, `OBSIDIAN_AUTHOR_EMAIL` | `Human (Obsidian)`, `obsidian@localhost` |

If no vault is configured and no local iCloud Obsidian container exists, the mirror skips the
run and exits successfully, so the same wrapper can sit on machines without Obsidian.

The wrapper is written for macOS (`zsh`, Homebrew path, `osascript` notifications). On other
systems, adapt those lines.

## Scheduling (macOS LaunchAgent)

Run the wrapper every 600 seconds with a LaunchAgent, e.g.
`~/Library/LaunchAgents/com.example.syncobsidian.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.example.syncobsidian</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>/path/to/your/repo/scripts/sync-obsidian-git.sh</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>OBSIDIAN_AUTHOR_NAME</key><string>Your Name</string>
    <key>OBSIDIAN_AUTHOR_EMAIL</key><string>you@example.com</string>
  </dict>
  <key>StartInterval</key><integer>600</integer>
  <key>StandardOutPath</key><string>/path/to/your/repo/obsidian-sync.log</string>
  <key>StandardErrorPath</key><string>/path/to/your/repo/obsidian-sync-error.log</string>
</dict>
</plist>
```

Load it with `launchctl load ~/Library/LaunchAgents/com.example.syncobsidian.plist`.
Add the log files to `.gitignore`.

## Warning: Rename in Git, Not in Obsidian

Do not rename or move folders (or files) inside Obsidian. To the sync, a renamed folder looks
like many deleted files plus many new ones — the brake stops it, and a human has to clean up.
Rename with `git mv` in the repository instead; the next run carries the change into the vault.
