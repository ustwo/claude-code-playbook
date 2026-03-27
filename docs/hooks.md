# Hooks

Hooks are shell scripts that Claude Code runs automatically at specific points in its lifecycle. They let you enforce team conventions without relying on Claude to remember them.

## Table of Contents

1. [What hooks are](#1-what-hooks-are)
2. [Hook lifecycle](#2-hook-lifecycle)
3. [How to wire hooks](#3-how-to-wire-hooks)
4. [Available hooks](#4-available-hooks)

---

## 1. What hooks are

A hook is a shell script that Claude Code calls when a specific event fires. The script gets context about the event via environment variables or stdin, and its exit code or output tells Claude what to do next.

Hooks are defined in `.claude/settings.json` and live as scripts in `.claude/hooks/scripts/` by convention. They fire for every matching event, regardless of which command or agent triggered it.

The key difference from a command or rule is that hooks are **automatic and unconditional**. You don't need to ask Claude to run them.

---

## 2. Hook lifecycle

| Event | When it fires | Can block? |
|---|---|---|
| `PreToolUse` | Before Claude runs any tool | Yes - non-zero exit cancels the tool call |
| `PostToolUse` | After a tool finishes | No - output is informational only |
| `PermissionRequest` | When Claude needs permission to run something | Yes - can auto-approve or auto-deny |
| `Stop` | When Claude finishes its response | No - runs after the turn completes |
| `SessionStart` | On session start and after compaction | No - used to re-inject context |
| `Notification` | When Claude needs user input | No - used to surface alerts |

**PreToolUse** is the most powerful event. Use it to block dangerous commands, enforce style, or redirect Claude to a safer alternative. Write a message to stdout and exit non-zero to cancel the tool call and show Claude the reason.

**PostToolUse** fires after the tool succeeds. Use it for formatting, linting, or logging. It can't undo a tool call.

**PermissionRequest** fires before Claude asks you for permission. Return `{"decision": "approve"}` or `{"decision": "deny", "reason": "..."}` as JSON to auto-handle the request without interrupting you.

**Stop** fires at the end of every turn. Use it for checks that should always run when Claude finishes, like scanning for debug statements. Be careful: Stop hooks can re-trigger Claude if they return output, so guard against infinite loops with a flag like `STOP_HOOK_ACTIVE`.

**SessionStart** fires when a session opens and again after the context window compacts. Use it to re-inject branch names, recent commits, or project reminders that would otherwise be lost after compaction.

**Notification** fires when Claude would normally show a desktop or terminal notification. Override it to route alerts to a different channel.

---

## 3. How to wire hooks

Declare hooks in `.claude/settings.json` under the `"hooks"` key.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/scripts/dev-server-block.sh",
            "timeout": 5000
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/scripts/prettier-format.sh"
          }
        ]
      }
    ],
    "PermissionRequest": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/scripts/auto-approve-safe-commands.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/scripts/console-log-check.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/scripts/reinject-context-after-compact.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude needs input\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

**Key fields:**

- **`matcher`** - a pipe-separated list of tool names to match. Omit to match all tools.
- **`command`** - the shell command to run. Use `$CLAUDE_PROJECT_DIR` for paths that work across machines.
- **`timeout`** - milliseconds before the hook is killed. Defaults to 10000.
- **`async`** - set to `true` to run the hook without blocking Claude. Useful for notifications and logging.

See [settings-reference.md](./settings-reference.md) for the full field reference.

---

## 4. Available hooks

| Script | What it does |
|---|---|
| [dev-server-block.sh](../hooks/scripts/dev-server-block.sh) | Blocks long-running dev server commands and tells Claude to use a separate terminal instead |
| [git-push-reminder.sh](../hooks/scripts/git-push-reminder.sh) | Prints a reminder to review changes before `git push` runs |
| [prettier-format.sh](../hooks/scripts/prettier-format.sh) | Runs a formatter on the edited file after every Edit or Write tool call |
| [auto-approve-safe-commands.sh](../hooks/scripts/auto-approve-safe-commands.sh) | Auto-approves read-only commands (status, diff, log, test) so Claude isn't interrupted |
| [reinject-context-after-compact.sh](../hooks/scripts/reinject-context-after-compact.sh) | Re-injects branch name, recent commits, and project reminders after the context window compacts |
| [console-log-check.sh](../hooks/scripts/console-log-check.sh) | Scans modified source files for debug log statements when Claude finishes a turn |
