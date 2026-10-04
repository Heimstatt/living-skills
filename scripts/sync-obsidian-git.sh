#!/bin/zsh
# LaunchAgent entry point (com.example.syncobsidian, every 10 min):
#   1. git pull --rebase --autostash   (bring the clone up to date)
#   2. sync-obsidian-mirror.py         (copy .md files between repo and Obsidian vault)
#   3. commit + push of Markdown changes that came in from Obsidian
# Author is the human editing in Obsidian (OBSIDIAN_AUTHOR_NAME), committer/signature is the clone's own identity
# (the agent instance running the job) so it stays visible that the scheduled automation committed it.
# Brake: more than 15 changed files or any deletion/rename means a bulk operation
# (folder renamed in Obsidian etc.) - nothing is committed, a human must look.
# Failures raise one macOS notification per distinct problem, not one every 10 minutes.

export PATH="/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
cd "$(dirname "$0")/.." || exit 1

echo "== $(date '+%Y-%m-%d %H:%M:%S')"
problem=""

if ! git pull --rebase --autostash --quiet 2>&1; then
  git rebase --abort 2>/dev/null
  problem="git pull failed (conflict with local changes or no network)"
  echo "$problem" >&2
fi

python3 scripts/sync-obsidian-mirror.py
rc=$?
if [ $rc -ne 0 ]; then
  problem="${problem:+$problem; }Obsidian mirror exit $rc (see obsidian-sync-error.log)"
fi

if [ $rc -eq 0 ]; then
  changes=$(git status --porcelain -uall -- '*.md')
  if [ -n "$changes" ]; then
    count=$(printf '%s\n' "$changes" | wc -l | tr -d ' ')
    if [ "$count" -gt 15 ] || printf '%s\n' "$changes" | grep -qE '^( D|D |R |.R)'; then
      problem="${problem:+$problem; }Obsidian: $count changes, including deletions/renames or too many - nothing committed, please check (git status)"
      echo "$problem" >&2
    else
      files=$(printf '%s\n' "$changes" | sed 's/^...//; s/^"//; s/"$//' | sed 's#.*/##' | head -5 | paste -sd, - | sed 's/,/, /g')
      [ "$count" -gt 5 ] && files="$files, ..."
      git add -A -- '*.md'
      if GIT_AUTHOR_NAME="${OBSIDIAN_AUTHOR_NAME:-Human (Obsidian)}" GIT_AUTHOR_EMAIL="${OBSIDIAN_AUTHOR_EMAIL:-obsidian@localhost}" \
           git commit -q -m "Obsidian-Sync: $count Markdown change(s) from Obsidian [$(date +%F)]

$files" 2>&1 \
         && git pull --rebase --quiet 2>&1 && git push --quiet 2>&1; then
        echo "Obsidian changes committed and pushed: $count"
      else
        git rebase --abort 2>/dev/null
        problem="${problem:+$problem; }Commit/push of Obsidian changes failed (check git status)"
        echo "$problem" >&2
      fi
    fi
  fi
fi

flag=".git/obsidian-sync-last-problem"
if [ -n "$problem" ]; then
  if [ "$(cat "$flag" 2>/dev/null)" != "$problem" ]; then
    printf '%s' "$problem" > "$flag"
    osascript -e "display notification \"$problem\" with title \"Obsidian-Sync\"" 2>/dev/null
  fi
  exit 1
fi
rm -f "$flag"
