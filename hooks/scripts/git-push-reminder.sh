#!/usr/bin/env bash
# PreToolUse hook: reminds to review changes before git push.

set -euo pipefail

CMD=$(jq -r '.tool_input.command // ""')

if echo "$CMD" | grep -q 'git push'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      additionalContext: "Reminder: review your changes before pushing."
    }
  }'
else
  exit 0
fi
