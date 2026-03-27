#!/usr/bin/env bash
# Stop hook: warns if any modified files contain console.log statements.

set -euo pipefail

# Prevent infinite loops if this hook triggers another stop
if [[ "${CLAUDE_STOP_HOOK_ACTIVE:-}" == "1" ]]; then
  exit 0
fi
export CLAUDE_STOP_HOOK_ACTIVE=1

# Get list of modified files (staged + unstaged)
FILES=$(git diff --name-only --diff-filter=ACMR HEAD 2>/dev/null || true)

if [[ -z "$FILES" ]]; then
  exit 0
fi

FOUND=""
while IFS= read -r file; do
  if echo "$file" | grep -qE '\.(ts|tsx|js|jsx)$'; then
    if grep -n 'console\.log' "$file" 2>/dev/null; then
      FOUND="$FOUND\n  $file"
    fi
  fi
done <<< "$FILES"

if [[ -n "$FOUND" ]]; then
  echo ""
  echo "Warning: console.log found in modified files:$FOUND"
  echo "Remove before committing."
fi
