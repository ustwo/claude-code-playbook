#!/usr/bin/env bash
# PermissionRequest hook: auto-approves known safe commands.

set -euo pipefail

CMD=$(jq -r '.tool_input.command // ""')

case "$CMD" in
  # Test, lint, format commands (add your package manager variants)
  "npm test"*|"npm run lint"*|"npm run typecheck"*|"npm run format"*|\
  "yarn test"*|"yarn lint"*|"yarn typecheck"*|"yarn format"*|\
  "pnpm test"*|"pnpm lint"*|"pnpm typecheck"*|"pnpm format"*|\
  # Read-only git commands
  "git status"*|"git diff"*|"git log"*)
    jq -n '{
      hookSpecificOutput: {
        hookEventName: "PermissionRequest",
        decision: { behavior: "allow" }
      }
    }'
    ;;
esac

exit 0
