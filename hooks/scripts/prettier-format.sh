#!/usr/bin/env bash
# PostToolUse hook: auto-format files after Edit or Write.

set -euo pipefail

FILE=$(jq -r '.tool_input.file_path // ""')

if echo "$FILE" | grep -qE '\.(ts|tsx|js|jsx|json|css)$'; then
  RESOLVED=$(cd "$(dirname "$FILE")" 2>/dev/null && pwd)/$(basename "$FILE")
  if npx prettier --write "$RESOLVED" > /dev/null 2>&1; then
    echo "[Hook] Formatted: $FILE" >&2
  else
    echo "[Hook] Prettier skipped: $FILE" >&2
  fi
fi
