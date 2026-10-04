#!/bin/bash
# check-siyuan-edits.sh — Detect human edits in Siyuan since last Git sync
# Direction: Siyuan → stdout (read-only, changes nothing)
# Trigger: session-start ritual, before any work begins
#
# Prerequisites: sync-to-siyuan.sh must use diff-before-write (only updates
# docs whose content actually changed). This ensures that Siyuan timestamps
# on unchanged docs remain stable — so any doc with a timestamp newer than
# the last Git commit was edited by a human directly in Siyuan.
#
# Detects:
#   1. Existing docs modified by human (timestamp > last Git commit)
#   2. New docs created by human in Siyuan (no Git counterpart)
#
# Output: human-readable report. Exit: 0 = edits found, 1 = none, 2 = error
#
# Credentials: same .env as sync-to-siyuan.sh

set -euo pipefail

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

# Timezone the Siyuan process runs in. Siyuan writes its `updated` field as a
# bare local-time string (YYYYMMDDHHmmss, no offset) in this zone. The default
# below assumes a container running with TZ=Asia/Shanghai (UTC+8); set SIYUAN_TZ
# to match your container's timezone.
SIYUAN_TZ="${SIYUAN_TZ:-Asia/Shanghai}"

if [[ -z "$SIYUAN_URL" || -z "$SIYUAN_TOKEN" || -z "$NOTEBOOK_ID" ]]; then
    echo "ERROR: SIYUAN_URL, SIYUAN_TOKEN, and SIYUAN_NOTEBOOK_ID must be set."
    exit 2
fi

AUTH="Authorization: Token $SIYUAN_TOKEN"
CT="Content-Type: application/json"

siyuan_api() {
    curl -s "$SIYUAN_URL/api/$1" -H "$AUTH" -H "$CT" -d "$2"
}

# Check Siyuan is reachable
if ! curl -s -o /dev/null -w "%{http_code}" "$SIYUAN_URL/api/system/version" -H "$AUTH" | grep -q 200; then
    echo "ERROR: Siyuan not reachable at $SIYUAN_URL"
    exit 2
fi

# --- Last Git commit timestamp + buffer, normalized into Siyuan's timezone ---
# Buffer: 2 minutes after Git commit. The sync-to-siyuan.sh runs right after git push,
# so docs it updates get timestamps a few seconds after the Git commit. The buffer
# ensures we don't flag sync-updated docs as human edits.
#
# TZ normalization: Siyuan's `updated` is a bare local-time string in $SIYUAN_TZ
# (no offset), while the git commit time carries a real UTC offset that differs
# per machine (e.g. server=UTC, laptop=local zone). We read the commit time as strict
# ISO-8601 with offset (%cI), then express both sides in $SIYUAN_TZ so the
# string comparison below (updated > CUTOFF_TS) is apples-to-apples.
LAST_GIT_TS_RAW=$(git -C "$REPO_DIR" log -1 --format=%cI 2>/dev/null || echo "")
if [[ -z "$LAST_GIT_TS_RAW" ]]; then
    echo "ERROR: Could not read last Git commit timestamp from $REPO_DIR"
    exit 2
fi

# Convert git commit time (ISO-8601 w/ offset) into Siyuan's zone, add 2-min
# buffer, and format as a bare YYYYMMDDHHmmss string in that same zone.
CUTOFF_TS=$(python3 -c "
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo
committed = datetime.fromisoformat('$LAST_GIT_TS_RAW')
buffered = committed.astimezone(ZoneInfo('$SIYUAN_TZ')) + timedelta(minutes=2)
print(buffered.strftime('%Y%m%d%H%M%S'))
")

echo "=== Siyuan Edit Check ==="
echo "Last Git commit: $LAST_GIT_TS_RAW ($(git -C "$REPO_DIR" log -1 --format='%s' 2>/dev/null))"
echo "Cutoff (commit + 2min buffer, in $SIYUAN_TZ): $CUTOFF_TS"
echo ""

FOUND_EDITS=false

# --- Step 1: Documents modified in Siyuan AFTER last Git commit ---
# With diff-before-write sync, only docs with real content changes get new timestamps.
# So anything newer than the last Git commit = human edit.
MODIFIED_DOCS=$(siyuan_api "query/sql" "{\"stmt\":\"SELECT id, hpath, updated FROM blocks WHERE type='d' AND box='$NOTEBOOK_ID' AND updated > '$CUTOFF_TS' ORDER BY updated DESC\"}" | \
    python3 -c "
import json, sys
data = json.load(sys.stdin).get('data', [])
for row in data:
    # Skip pure folder docs (hpath has no content — just structural containers)
    # Folder docs have hpaths like /Projects or /Infrastructure/skills
    # Real docs have titles derived from content
    print(f\"{row['id']}\t{row['hpath']}\t{row['updated']}\")
" 2>/dev/null || echo "")

if [[ -n "$MODIFIED_DOCS" ]]; then
    # Filter: fetch each doc and skip empty ones (Siyuan folder containers)
    REAL_EDITS=""
    while IFS=$'\t' read -r doc_id hpath updated; do
        [[ -z "$doc_id" ]] && continue

        CONTENT=$(siyuan_api "export/exportMdContent" "{\"id\":\"$doc_id\"}" | \
            python3 -c "import json,sys; print(json.load(sys.stdin).get('data',{}).get('content','').strip())" 2>/dev/null)

        # Skip empty docs (folder containers in Siyuan)
        [[ -z "$CONTENT" ]] && continue

        REAL_EDITS+="found"
        FOUND_EDITS=true

        echo "📝 Modified: $hpath"
        echo "   Updated: $updated"

        # Here-string, not `echo "$CONTENT" | head -20`: same SIGPIPE trap as
        # Step 2 — `head` closes the pipe early, `echo` dies (exit 141), and
        # `set -e`/pipefail would abort this loop mid-scan. (`wc -l` reads all
        # input, so it is not exposed and can stay as a pipe.)
        PREVIEW=$(head -20 <<< "$CONTENT")
        LINE_COUNT=$(echo "$CONTENT" | wc -l)
        echo "   --- content preview ---"
        echo "$PREVIEW" | sed 's/^/   /'
        if [[ "$LINE_COUNT" -gt 20 ]]; then
            echo "   ... ($LINE_COUNT lines total)"
        fi
        echo ""
    done <<< "$MODIFIED_DOCS"
fi

# --- Step 2: Documents in Siyuan that don't exist in Git ---
# These were created by a human directly in Siyuan.
ALL_SIYUAN_DOCS=$(siyuan_api "query/sql" "{\"stmt\":\"SELECT id, hpath, updated FROM blocks WHERE type='d' AND box='$NOTEBOOK_ID' ORDER BY hpath\"}" | \
    python3 -c "
import json, sys
data = json.load(sys.stdin).get('data', [])
for row in data:
    print(f\"{row['id']}\t{row['hpath']}\t{row['updated']}\")
" 2>/dev/null || echo "")

# Build Git hpaths for comparison (same logic as sync-to-siyuan.sh)
GIT_HPATHS=$(find "$REPO_DIR" -name "*.md" \
    -not -path "*/.git/*" \
    -not -name "CLAUDE.md" \
    -not -name "AGENTS.md" \
    | sort \
    | while read -r abs_path; do
        rel_path="${abs_path#$REPO_DIR/}"
        dir_part=$(dirname "$rel_path")
        h1=$(grep -m1 '^# ' "$abs_path" 2>/dev/null | sed 's/^# //' | tr -d '\r' || true)
        if [[ -n "$h1" ]]; then
            title="$h1"
        else
            title=$(basename "$abs_path" .md | sed 's/[-_]/ /g' | python3 -c "import sys; print(sys.stdin.read().strip().title())")
        fi
        # Match sync-to-siyuan.sh's get_hpath: Siyuan reads '/' in an HPath as a
        # folder separator, so the sync sanitizes slashes in the title segment
        # (title="${title//\//-}"). This reconstruction must apply the SAME
        # substitution, or a git-backed doc whose H1 contains '/' (e.g.
        # "# Entscheidungen / Festlegungen") never matches the sanitized hpath
        # Siyuan actually stored, and is wrongly reported as "New (Siyuan-only)".
        title="${title//\//-}"
        if [[ "$dir_part" == "." ]]; then
            echo "/$title"
        else
            echo "/$dir_part/$title"
        fi
    done)

while IFS=$'\t' read -r doc_id hpath updated; do
    [[ -z "$hpath" ]] && continue

    # Skip if this hpath exists in Git.
    # NB: use a here-string, not `echo "$GIT_HPATHS" | grep -qxF`. With
    # `set -o pipefail` (line 19), `grep -q` exits on the first match and closes
    # the pipe while `echo` is still writing the large (~170 KB) GIT_HPATHS list.
    # `echo` then dies from SIGPIPE, the pipeline's exit status becomes 141, and
    # `... && continue` never fires — so a git-backed doc that DID match gets
    # wrongly reported as "New (Siyuan-only)". A here-string has no pipe, so
    # grep's own exit code (0 match / 1 no-match) is what counts.
    if grep -qxF -- "$hpath" <<< "$GIT_HPATHS"; then
        continue
    fi

    # Fetch content — skip empty folder containers
    CONTENT=$(siyuan_api "export/exportMdContent" "{\"id\":\"$doc_id\"}" | \
        python3 -c "import json,sys; print(json.load(sys.stdin).get('data',{}).get('content','').strip())" 2>/dev/null)
    [[ -z "$CONTENT" ]] && continue

    FOUND_EDITS=true

    echo "🆕 New (Siyuan-only): $hpath"
    echo "   Updated: $updated"

    # Here-string, not `echo "$CONTENT" | head -20`: under `set -o pipefail`
    # `head` exits after 20 lines and closes the pipe, `echo` dies from SIGPIPE
    # (exit 141), and `set -e` then aborts the whole loop mid-scan — so Step 2
    # only ever saw the first handful of docs. A here-string avoids the pipe.
    PREVIEW=$(head -20 <<< "$CONTENT")
    LINE_COUNT=$(echo "$CONTENT" | wc -l)
    echo "   --- content preview ---"
    echo "$PREVIEW" | sed 's/^/   /'
    if [[ "$LINE_COUNT" -gt 20 ]]; then
        echo "   ... ($LINE_COUNT lines total)"
    fi
    echo ""
done <<< "$ALL_SIYUAN_DOCS"

# --- Result ---
if [[ "$FOUND_EDITS" == true ]]; then
    echo "=== Human edits detected — review before starting work ==="
    exit 0
else
    echo "✅ No human edits in Siyuan since last Git sync."
    exit 1
fi
