#!/bin/bash
# sync-to-siyuan.sh — Git → Siyuan Sync
# Direction: one-way (Git is authoritative)
# Trigger: manually after successful git push (part of session-end ritual)
#
# Mirrors ALL .md files from the repo to Siyuan:
#   Infrastructure/system-state.md   →  /Infrastructure/System State
#   Projects/example/foo.md          →  /Projects/Example/Foo
#   Team Memory/instance-a/status.md  →  /Team Memory/Instance A/Status
#
# Title: first H1 heading in the document, or humanized filename
# New folders/files are auto-detected — no manual mapping needed
#
# IMPORTANT: Only run after a successful git push.
# The script syncs ALL .md files — whoever pushes last wins with the complete state.
# Running before push risks pushing a partial state to Siyuan.
#
# Credentials: set SIYUAN_URL and SIYUAN_TOKEN as env vars,
# or place them in a .env file at the repo root (sourced automatically).

set -euo pipefail

# Load credentials from .env if present (repo root, 3 levels up from this script)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
ENV_FILE="$REPO_DIR/.env"
if [ -f "$ENV_FILE" ]; then
    # shellcheck disable=SC1090
    source "$ENV_FILE"
fi

SIYUAN_URL="${SIYUAN_URL:-}"
SIYUAN_TOKEN="${SIYUAN_TOKEN:-}"
NOTEBOOK_ID="${SIYUAN_NOTEBOOK_ID:-}"
LOG="${LOG:-/tmp/siyuan-sync.log}"

if [[ -z "$SIYUAN_URL" || -z "$SIYUAN_TOKEN" || -z "$NOTEBOOK_ID" ]]; then
    echo "ERROR: SIYUAN_URL, SIYUAN_TOKEN, and SIYUAN_NOTEBOOK_ID must be set."
    echo "Create a .env file at the repo root or export these variables."
    exit 1
fi

AUTH="Authorization: Token $SIYUAN_TOKEN"
CT="Content-Type: application/json"

log() { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG"; }

siyuan_api() {
    curl -s "$SIYUAN_URL/api/$1" -H "$AUTH" -H "$CT" -d "$2"
}

# Titel aus Markdown: erste H1-Zeile, sonst Dateiname humanisiert
get_title() {
    local file="$1"
    local h1
    h1=$(grep -m1 '^# ' "$file" 2>/dev/null | sed 's/^# //' | tr -d '\r' || true)
    if [[ -n "$h1" ]]; then
        echo "$h1"
    else
        basename "$file" .md | sed 's/[-_]/ /g' | python3 -c "import sys; print(sys.stdin.read().strip().title())"
    fi
}

# Siyuan HPath aus relativem Pfad berechnen
# z.B. "Infrastructure/system-state.md" → "/Infrastructure/System State"
get_hpath() {
    local rel_path="$1"
    local dir_part title
    dir_part=$(dirname "$rel_path")
    title=$(get_title "$REPO_DIR/$rel_path")
    if [[ "$dir_part" == "." ]]; then
        echo "/$title"
    else
        echo "/$dir_part/$title"
    fi
}

# Doc-ID per SQL anhand HPath finden
find_doc_by_hpath() {
    local hpath="$1"
    # SQL-Sonderzeichen escapen (einfache Anführungszeichen)
    local escaped_hpath="${hpath//\'/\'\'}"
    siyuan_api "query/sql" "{\"stmt\":\"SELECT id FROM blocks WHERE type='d' AND hpath='$escaped_hpath' AND box='$NOTEBOOK_ID' LIMIT 1\"}" | \
        python3 -c "import json,sys; rows=json.load(sys.stdin).get('data',[]); print(rows[0]['id'] if rows else '')" 2>/dev/null
}

# Aktuellen Markdown-Inhalt eines Siyuan-Dokuments holen
get_siyuan_content() {
    local doc_id="$1"
    siyuan_api "export/exportMdContent" "{\"id\":\"$doc_id\"}" | \
        python3 -c "import json,sys; print(json.load(sys.stdin).get('data',{}).get('content',''))" 2>/dev/null
}

# Compare Git and Siyuan content by word fingerprint.
# Siyuan's Markdown export differs cosmetically (frontmatter, duplicate H1,
# zero-width chars, table formatting, whitespace). Instead of normalizing
# every edge case, we extract only the words and compare those.
# This means: if the actual text content is the same, we skip the update —
# preserving Siyuan's timestamp for human-edit detection.
content_differs() {
    local git_content="$1"
    local siyuan_content="$2"

    python3 -c "
import sys, re

def fingerprint(text):
    # Strip YAML frontmatter
    text = re.sub(r'^---\n.*?\n---\n*', '', text, count=1, flags=re.DOTALL)
    # Remove duplicate H1 (Siyuan repeats title as first heading)
    lines = text.strip().split('\n')
    first_h1 = None; first_h1_idx = None
    for i, line in enumerate(lines):
        if line.strip() == '': continue
        if line.startswith('# '):
            if first_h1 is None: first_h1 = line.strip(); first_h1_idx = i
            elif line.strip() == first_h1: lines = lines[:first_h1_idx] + lines[i:]; break
            else: break
        else: break
    text = '\n'.join(lines)
    # Extract only word characters — ignores all formatting differences
    return ' '.join(re.findall(r'[\w]+', text, re.UNICODE))

git = fingerprint(sys.argv[1])
siyuan = fingerprint(sys.argv[2])
sys.exit(0 if git != siyuan else 1)
" "$git_content" "$siyuan_content"
}

# Doc-Inhalt komplett ersetzen
update_doc() {
    local doc_id="$1"
    local content="$2"

    # Alle Kind-Blöcke löschen
    siyuan_api "block/getChildBlocks" "{\"id\":\"$doc_id\"}" | \
        python3 -c "import json,sys; [print(b['id']) for b in json.load(sys.stdin).get('data',[])]" 2>/dev/null | \
        while read -r child_id; do
            [[ -n "$child_id" ]] && siyuan_api "block/deleteBlock" "{\"id\":\"$child_id\"}" > /dev/null
        done

    local escaped
    escaped=$(python3 -c "import json,sys; print(json.dumps(sys.argv[1]))" "$content")
    siyuan_api "block/prependBlock" "{\"parentID\":\"$doc_id\",\"dataType\":\"markdown\",\"data\":$escaped}" > /dev/null
}

# Eine .md-Datei nach Siyuan synchronisieren
# Key design: only write if content actually changed — this preserves Siyuan
# timestamps on unchanged docs, enabling human-edit detection via timestamp comparison.
sync_file() {
    local rel_path="$1"
    local abs_path="$REPO_DIR/$rel_path"
    local hpath doc_id content escaped result new_id

    hpath=$(get_hpath "$rel_path")
    content=$(cat "$abs_path")

    doc_id=$(find_doc_by_hpath "$hpath")

    if [[ -n "$doc_id" ]]; then
        # Diff before write: fetch current Siyuan content and compare
        local siyuan_content
        siyuan_content=$(get_siyuan_content "$doc_id")

        if content_differs "$content" "$siyuan_content"; then
            update_doc "$doc_id" "$content"
            log "UPDATE: $hpath"
        else
            log "SKIP (unchanged): $hpath"
        fi
    else
        escaped=$(python3 -c "import json,sys; print(json.dumps(sys.argv[1]))" "$content")
        result=$(siyuan_api "filetree/createDocWithMd" \
            "{\"notebook\":\"$NOTEBOOK_ID\",\"path\":\"$hpath\",\"markdown\":$escaped}")
        new_id=$(echo "$result" | python3 -c "import json,sys; print(json.load(sys.stdin).get('data',''))" 2>/dev/null)
        if [[ -n "$new_id" ]]; then
            log "CREATE: $hpath"
        else
            log "ERROR: $hpath — $(echo "$result" | python3 -c "import json,sys; print(json.load(sys.stdin).get('msg','?'))" 2>/dev/null)"
        fi
    fi
}

# ============================================================

# Siyuan-Verbindung prüfen
if ! curl -s -o /dev/null -w "%{http_code}" "$SIYUAN_URL/api/system/version" -H "$AUTH" | grep -q 200; then
    log "ERROR: Siyuan nicht erreichbar unter $SIYUAN_URL"
    exit 1
fi

log "=== Git → Siyuan Sync ($(git -C "$REPO_DIR" log --oneline -1 2>/dev/null || echo 'manual')) ==="

# Sync all .md files in the repo
find "$REPO_DIR" -name "*.md" \
    -not -path "*/.git/*" \
    -not -name "CLAUDE.md" \
    -not -name "AGENTS.md" \
    | sort \
    | while read -r abs_path; do
        rel_path="${abs_path#$REPO_DIR/}"
        sync_file "$rel_path"
    done

log "=== Sync fertig ==="
