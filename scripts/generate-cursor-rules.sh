#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cat "$REPO_ROOT/.cursor/rules/living-skills-header.mdc" \
    "$REPO_ROOT/TEAM.md" \
    > "$REPO_ROOT/.cursor/rules/living-skills.mdc"
echo "✓ .cursor/rules/living-skills.mdc regenerated"
