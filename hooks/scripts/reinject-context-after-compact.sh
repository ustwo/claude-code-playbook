#!/usr/bin/env bash
# SessionStart hook (compact): re-injects key context after compaction.

set -euo pipefail

BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
CHANGED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
RECENT=$(git log --oneline -3 2>/dev/null || echo "no commits")

cat <<EOF
=== Post-compact context ===
Branch: $BRANCH
Uncommitted changes: $CHANGED files
Recent commits:
$RECENT

Reminders:
# Customise these for your project:
# - Your branching convention (e.g. branch from develop, hotfixes from main)
# - Your commit message format (e.g. conventional commits)
# - Your pre-commit checks (e.g. run tests before committing)
# - Your code style rules (e.g. no console.log in committed code)
EOF
