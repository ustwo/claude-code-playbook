# Settings reference

A field-by-field reference for `.claude/settings.json`. This file controls permissions, hooks, and other Claude Code behaviour for the project.

## Table of Contents

1. [File location](#1-file-location)
2. [Permissions](#2-permissions)
3. [Hooks](#3-hooks)
4. [Notification hooks](#4-notification-hooks)
5. [Tips](#5-tips)

---

## 1. File location

| File | Scope | Committed to version control? |
|---|---|---|
| `.claude/settings.json` | Project-wide, shared by all contributors | Yes |
| `.claude/settings.local.json` | Personal overrides for a single developer | No - add to `.gitignore` |

When both files exist, `settings.local.json` is merged on top of `settings.json`. Use the local file for developer-specific overrides (like enabling a hook that only works on your machine) without affecting teammates.

---

## 2. Permissions

The `"permissions"` key controls what Claude can do without asking first.

```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm test *)",
      "Read(**/*)"
    ],
    "deny": [
      "Read(.env)",
      "Read(**/*.pem)",
      "Bash(git push --force *)"
    ]
  }
}
```

**`allow`** - a list of glob patterns Claude can execute without requesting permission. Patterns use the format `ToolName(argument-glob)`.

**`deny`** - a list of patterns Claude is never allowed to execute, even if you explicitly ask. Deny rules win over allow rules.

**Common allow patterns:**

| Pattern | What it allows |
|---|---|
| `Bash(git *)` | Any git command |
| `Bash(npm test *)` | Running the test suite |
| `Bash(npm run lint *)` | Running the linter |
| `Read(**/*.ts)` | Reading TypeScript files |
| `Write(src/**)` | Writing files inside `src/` |

**Common deny patterns:**

| Pattern | What it blocks |
|---|---|
| `Read(.env)` | Reading the local env file |
| `Read(**/*.pem)` | Reading certificate files |
| `Bash(git push --force *)` | Force-pushing to any remote |
| `Bash(rm -rf *)` | Recursive deletions |

---

## 3. Hooks

The `"hooks"` key declares scripts that run at lifecycle events. Each entry is an event name mapped to an array of matchers.

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
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/scripts/prettier-format.sh",
            "async": true
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
    ]
  }
}
```

**Event names:** `PreToolUse`, `PostToolUse`, `PermissionRequest`, `Stop`, `SessionStart`, `Notification`

**Matcher fields:**

| Field | Type | Description |
|---|---|---|
| `matcher` | string | Pipe-separated list of tool names to match. Omit to match all tools. |

**Hook object fields:**

| Field | Type | Default | Description |
|---|---|---|---|
| `type` | string | required | Always `"command"` for shell hooks |
| `command` | string | required | Shell command to run |
| `timeout` | number | 10000 | Milliseconds before the hook process is killed |
| `async` | boolean | `false` | When `true`, Claude doesn't wait for the hook to finish |
| `statusMessage` | string | none | Message shown in the Claude UI while the hook is running |

**Exit codes for blocking hooks (PreToolUse, PermissionRequest):**

| Exit code | Meaning |
|---|---|
| `0` | Allow the tool call to proceed |
| Non-zero | Block the tool call; stdout is shown to Claude as the reason |

**PermissionRequest response format:** return a JSON object to stdout instead of using exit codes:

```json
{ "decision": "approve" }
```

```json
{ "decision": "deny", "reason": "Use a separate terminal for dev servers." }
```

---

## 4. Notification hooks

Use a `Notification` hook to route Claude's alerts wherever you want.

**macOS desktop notification:**

```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude needs input\" with title \"Claude Code\"'",
            "async": true
          }
        ]
      }
    ]
  }
}
```

You can replace the `osascript` command with anything: a Slack webhook, a terminal bell (`tput bel`), or a custom script. Mark it `async: true` so Claude isn't blocked waiting for the notification to fire.

---

## 5. Tips

**Use `$CLAUDE_PROJECT_DIR` for portable paths.** This environment variable is set to the project root at runtime. Using it in hook commands means the settings file works correctly regardless of where the project is cloned on disk.

```json
"command": "$CLAUDE_PROJECT_DIR/.claude/hooks/scripts/prettier-format.sh"
```

**Use `async: true` for non-blocking hooks.** Formatters, loggers, and notification scripts don't need to block Claude. Mark them async so they run in the background and Claude continues immediately.

**Use `timeout` to protect against slow hooks.** A hook that hangs will block Claude indefinitely unless you set a timeout. Set a short timeout (3000-5000ms) for hooks that should be fast, so a malfunction doesn't freeze the session.

**Use `settings.local.json` for personal hooks.** If you have a hook that only works on your machine (like a custom notification script), put it in `settings.local.json` and add that file to `.gitignore`. Teammates won't see it and it won't break their setup.
