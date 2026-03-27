# Commands

Commands are markdown files that define reusable, multi-step workflows. They turn common but complex tasks into a single slash command that any team member can invoke.

## Table of Contents

1. [What commands are](#1-what-commands-are)
2. [How to create one](#2-how-to-create-one)
3. [How they compose](#3-how-they-compose)
4. [Available commands](#4-available-commands)

---

## 1. What commands are

A command is a `.md` file placed in `.claude/commands/`. When you type `/<command-name>`, Claude reads the file and follows the instructions inside it.

Commands are different from rules: rules set ambient context that applies to every response; commands are triggered intentionally and describe a specific procedure. Think of them as team-agreed playbooks for tasks you repeat often, like starting a ticket, running a gate check, or raising a pull request.

Commands live in source control, so the whole team shares the same workflow. They can be overridden per-developer using `.claude/commands/` in a personal config directory.

---

## 2. How to create one

Create a `.md` file in `.claude/commands/`. The filename becomes the slash command (e.g. `gate-check.md` becomes `/gate-check`).

A command file has two parts: optional YAML frontmatter and the instruction body.

```markdown
---
description: Run all quality gates before raising a PR
argument-hint: "[package-name]"
allowed-tools: Bash, Read, Glob
model: sonnet
---

Run the following checks in order. Stop and report if any step fails.

1. Install dependencies.
2. Run the type-checker.
3. Run the linter with auto-fix.
4. Run the test suite.
5. Report a pass/fail summary.
```

**Frontmatter fields:**

- **`description`** - shown in the command picker. Keep it to one sentence.
- **`argument-hint`** - shown as placeholder text when you invoke the command. Optional.
- **`allowed-tools`** - comma-separated list of tools Claude may use. Omit to allow all tools.
- **`model`** - override the model for this command. Options: `haiku`, `sonnet`, `opus`. Omit to use the session default.

**Instruction body:** write step-by-step instructions in plain English. Be explicit about what to do when a step fails. Claude will follow them literally, so clarity matters more than brevity.

---

## 3. How they compose

Commands can reference other commands, rules, and agents.

**Calling another command:** mention it by name in the instructions. For example, `/gate-check` can tell Claude to run `/raise-pr` only if all checks pass. Claude will invoke the referenced command as a sub-step.

**Loading rules:** reference a rules file by path. Claude will read it and apply the conventions during that command's execution.

```markdown
Before writing any code, read `.claude/rules/code-style.md` and follow it throughout.
```

**Spawning agents:** tell Claude to delegate work to an agent defined in `.claude/agents/`.

```markdown
Delegate the database schema review to the `database-reviewer` agent and wait for its report before continuing.
```

This lets complex commands stay readable at the top level while delegating heavy exploration or specialist checks to subagents with their own context windows.

---

## 4. Available commands

| Command | What it does |
|---|---|
| [start-ticket.md](../commands/start-ticket.md) | Fetch an issue, explore the codebase for relevant context, create a branch, and produce an implementation plan |
| [gate-check.md](../commands/gate-check.md) | Run build, type-check, lint, tests, and a security audit in sequence |
| [bug-fix.md](../commands/bug-fix.md) | Reproduce a bug, identify the root cause, apply a minimal fix, and verify it |
| [raise-pr.md](../commands/raise-pr.md) | Analyse the full commit history and create a pull request using the project template |
| [raise-draft-pr.md](../commands/raise-draft-pr.md) | Same as raise-pr but marks the PR as a draft |
| [check-pr-comments.md](../commands/check-pr-comments.md) | Fetch all reviews, general comments, and inline review threads for a pull request |
