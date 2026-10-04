#!/usr/bin/env bash
# Maps this repo's skills for Claude Code.
#
# WHY THIS IS NEEDED
# Claude Code looks for skills only in `.claude/skills/<name>/SKILL.md` (project) and
# `~/.claude/skills/<name>/SKILL.md` (user, applies in all projects). There is no settings key
# for additional skill paths. A human-friendly structure such as
# `Team Memory/skills/<department>/roles/...` is therefore NEVER found on its own.
#
# WHAT IT DOES NOT DO
# It copies nothing. It creates **symlinks** to the directories in the repo. The shared repo
# stays the single source; when another instance changes a skill, the change applies as soon
# as this clone has pulled it. Claude Code follows symlinks and reads SKILL.md together with
# references/ and assets/ from the target directory.
#
# WHY PER MACHINE
# `~/.claude/skills/` lives in each instance's home directory. That does not contradict the
# shared repo: the card index is local, the shelf is shared. Every instance runs this one
# script and gets the same mapping.
#
# Usage:  bash scripts/generate-claude-skills.sh [--dry-run]
set -euo pipefail

# --- Bash 4+ required (mapfile, associative arrays) ------------------------------------------
# macOS ships bash 3.2, where this script used to no-op SILENTLY (exit 0, no mapping).
# Instead of failing silently: re-exec under a newer bash if the current one is too old,
# otherwise abort LOUDLY.
if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
  for _b in /opt/homebrew/bin/bash /usr/local/bin/bash /usr/bin/bash; do
    if [ -x "$_b" ]; then
      _v="$("$_b" -c 'echo "${BASH_VERSINFO:-0}"' 2>/dev/null || echo 0)"
      [ "$_v" -ge 4 ] && exec "$_b" "$0" "$@"
    fi
  done
  echo "ERROR: generate-claude-skills.sh needs bash >= 4 (mapfile + associative arrays)." >&2
  echo "       Current: bash ${BASH_VERSION:-?}. On macOS: 'brew install bash', then retry." >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

mkdir -p "$TARGET"

# --- 1. Find skill directories in the repo ---------------------------------------------------
# A skill is a directory containing SKILL.md or Skill.md. The second spelling is the older
# convention; Claude Code recognises ONLY SKILL.md (Linux is case-sensitive). For the old
# spelling, a directory of individual symlinks is built instead of a directory symlink.
mapfile -t FOUND < <(
  find "$REPO_ROOT/Team Memory/skills" "$REPO_ROOT/Infrastructure/skills" \
       \( -name SKILL.md -o -name Skill.md \) -type f 2>/dev/null | sort
)

# --- 2. Assign names, resolve collisions -----------------------------------------------------
declare -A NAME_TO_PATH
for file in "${FOUND[@]}"; do
  dir="$(dirname "$file")"
  name="$(basename "$dir")"
  # Qualify generic subfolders (e.g. cowork) with the parent name, otherwise they collide.
  if [[ "$name" == "cowork" || "$name" == "roles" ]]; then
    name="$(basename "$(dirname "$dir")")-$name"
  fi
  # Still taken? Then prefix the parent name.
  if [[ -n "${NAME_TO_PATH[$name]:-}" ]]; then
    name="$(basename "$(dirname "$dir")")-$name"
  fi
  NAME_TO_PATH["$name"]="$dir"
done

# --- 3. Remove orphaned links from earlier runs ---------------------------------------------
# Only what this script created: symlinks pointing into the repo. Other skills stay.
removed=0
for entry in "$TARGET"/*; do
  [ -e "$entry" ] || [ -L "$entry" ] || continue
  name="$(basename "$entry")"
  ours=0
  if [ -L "$entry" ] && [[ "$(readlink "$entry")" == "$REPO_ROOT"* ]]; then ours=1; fi
  if [ -d "$entry" ] && [ -L "$entry/SKILL.md" ] && [[ "$(readlink "$entry/SKILL.md")" == "$REPO_ROOT"* ]]; then ours=1; fi
  [ "$ours" = 1 ] || continue
  if [[ -z "${NAME_TO_PATH[$name]:-}" ]]; then
    [ "$DRY_RUN" = 1 ] && echo "  would remove: $name" || rm -rf "$entry"
    removed=$((removed+1))
  fi
done

# --- 4. Create links -------------------------------------------------------------------------
new=0; updated=0; bridged=0
for name in "${!NAME_TO_PATH[@]}"; do
  source="${NAME_TO_PATH[$name]}"
  link="$TARGET/$name"

  if [ -f "$source/SKILL.md" ]; then
    # Normal case: one symlink to the whole directory.
    if [ -L "$link" ] && [ "$(readlink "$link")" = "$source" ]; then continue; fi
    if [ "$DRY_RUN" = 1 ]; then echo "  would link: $name -> ${source#$REPO_ROOT/}"; else
      rm -rf "$link"; ln -s "$source" "$link"
    fi
    [ -e "$link" ] && updated=$((updated+1)) || new=$((new+1))
  else
    # Special case Skill.md: create a directory with one link per file, so that
    # SKILL.md exists in the spelling Claude Code expects.
    if [ "$DRY_RUN" = 1 ]; then echo "  would bridge (Skill.md): $name"; bridged=$((bridged+1)); continue; fi
    rm -rf "$link"; mkdir -p "$link"
    ln -s "$source/Skill.md" "$link/SKILL.md"
    for entry in "$source"/*; do
      b="$(basename "$entry")"
      [ "$b" = "Skill.md" ] && continue
      ln -s "$entry" "$link/$b"
    done
    bridged=$((bridged+1))
  fi
done

echo "✓ ${#NAME_TO_PATH[@]} skills mapped to $TARGET"
echo "  via the Skill.md bridge: $bridged   orphans removed: $removed"
[ "$DRY_RUN" = 1 ] && echo "  (dry run — nothing changed)"
exit 0
