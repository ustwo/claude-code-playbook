#!/usr/bin/env bash
# PreToolUse hook: blocks dev servers from running directly (they'd hang the session).

set -euo pipefail

CMD=$(jq -r '.tool_input.command // ""')

if echo "$CMD" | grep -qE '(npm run dev|yarn dev|pnpm dev|bun run dev)'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Dev server would hang the session. Run it in a separate terminal instead."
    }
  }'
else
  exit 0
fi
