# Adoption

You don't need to adopt everything at once. Start with the hooks that give immediate value, then layer in commands, rules, and agents as your team finds them useful.

## Table of Contents

1. [Minimal start (10 minutes)](#1-minimal-start-10-minutes)
2. [Add commands](#2-add-commands)
3. [Add rules](#3-add-rules)
4. [Add agents](#4-add-agents)
5. [CLAUDE.md scaffold](#5-claudemd-scaffold)

---

## 1. Minimal start (10 minutes)

Three hooks give you the highest return for the least setup:

1. **Copy the three core hook scripts** into your project's `.claude/hooks/scripts/`:
   - `dev-server-block.sh` - stops Claude from running long-lived processes that block the terminal
   - `prettier-format.sh` (or your formatter of choice) - auto-formats files after every edit
   - `auto-approve-safe-commands.sh` - removes permission interrupts for read-only commands

2. **Copy `settings-template.json`** to `.claude/settings.json` and adjust the paths to point at your hook scripts.

3. That's it. Hooks fire automatically from this point on.

If you want the full set of hooks, copy all scripts from `hooks/scripts/` and uncomment the corresponding entries in `settings-template.json`.

---

## 2. Add commands

Copy the `commands/` directory into your project's `.claude/commands/`.

The commands that need the least customisation are `check-pr-comments.md`, `raise-pr.md`, and `raise-draft-pr.md` - they work with any git host that has a CLI.

**Customise `gate-check.md`** to match your actual build tooling. Replace the generic steps with your specific commands for type-checking, linting, and testing. The structure stays the same; only the shell commands change.

**Customise `start-ticket.md`** with your issue tracker URL pattern and any project-specific context you want Claude to pull when starting a ticket.

---

## 3. Add rules

Copy the `rules/` directory to `.claude/rules/` in your project.

Go through each file and edit it to reflect your actual conventions:

- **`code-style.md`** - update with your language, formatter settings, and any patterns specific to your codebase
- **`git-workflow.md`** - update branch naming, commit type list, and PR base branch
- **`testing.md`** - update with your test framework, file naming convention, and mock patterns
- **`security.md`** - keep the generic checks but add any stack-specific requirements
- **`code-review-format.md`** - adjust the tone section if your team has a different preference

Delete any rule files that don't apply. A rules directory with five relevant files is more effective than one with fifteen generic ones.

---

## 4. Add agents

Copy the `agents/` directory to `.claude/agents/` in your project.

Agents need less customisation than commands because they describe general workflows (plan, review, diagnose) rather than project-specific procedures. Review each file and add any domain context that would help Claude delegate more precisely.

If your project has a specialised domain not covered here - data pipelines, mobile builds, ML model management - create a new agent file following the same structure as the existing ones and document it in [docs/agents.md](./agents.md).

---

## 5. CLAUDE.md scaffold

`CLAUDE.md` is the entry point Claude reads at session start. It should give a quick orientation to the project and point to the detailed files in `commands/`, `agents/`, and `rules/`.

Here's a minimal template:

```markdown
# <Project name>

<One to three sentences: what this codebase does and who it's for.>

## Repository overview

<Brief description of the main packages or services and how data flows between them.>

## Build and test

- Install: `<install command>`
- Dev: `<dev command>` (run in a separate terminal)
- Test: `<test command>`
- Lint: `<lint command>`
- Format: `<format command>`
- Typecheck: `<typecheck command>`

## Key components

### Commands

| Command | Purpose |
|---------|---------|
| `/start-ticket <n>` | Fetch issue, explore codebase, create branch, produce plan |
| `/gate-check` | Build, types, lint, tests, security scan |
| `/bug-fix` | Reproduce, minimal fix, verify |
| `/raise-pr` | Create a ready PR using the project template |
| `/raise-draft-pr` | Create a draft PR using the project template |
| `/check-pr-comments` | Fetch reviews and inline comments for a PR |

### Agents

| Agent | When used |
|-------|-----------|
| `planner` | Spike codebase and produce an implementation plan |
| `architect` | Architecture decisions and ADR creation |
| `build-error-resolver` | Diagnose build and type errors |
| `database-reviewer` | SQL, migrations, schema design |

### Hooks

| Hook | Event | Action |
|------|-------|--------|
| `dev-server-block.sh` | PreToolUse (Bash) | Blocks dev servers - run in separate terminal |
| `prettier-format.sh` | PostToolUse (Edit/Write) | Auto-formats edited files |
| `auto-approve-safe-commands.sh` | PermissionRequest (Bash) | Auto-approves read-only commands |
| `reinject-context-after-compact.sh` | SessionStart | Restores context after compaction |
| `console-log-check.sh` | Stop | Scans for debug statements |

### Rules

- `rules/code-style.md` - language conventions and patterns
- `rules/git-workflow.md` - branch naming, commits, PRs
- `rules/testing.md` - test types, file naming, isolation
- `rules/security.md` - pre-commit checks, secret handling
- `rules/code-review-format.md` - review comment format and tone
```
