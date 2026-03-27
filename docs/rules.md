# Rules

Rules are markdown files Claude loads as ambient context. They encode team conventions that apply to every response, without you having to repeat them.

## Table of Contents

1. [What rules are](#1-what-rules-are)
2. [How Claude loads them](#2-how-claude-loads-them)
3. [How to structure rules](#3-how-to-structure-rules)
4. [Available rules](#4-available-rules)

---

## 1. What rules are

A rule is a `.md` file in `.claude/rules/`. Claude reads these files and treats them as standing instructions that persist across the session.

Rules are different from commands: commands describe a procedure to follow when invoked; rules describe conventions that always apply. A rule file might specify how to write commit messages, how to handle errors, or what patterns to avoid in a particular part of the codebase.

Rules are also different from `CLAUDE.md`: `CLAUDE.md` is a high-level project overview with quick-reference tables; rules files contain the detailed guidance for a specific topic. `CLAUDE.md` typically links to or mentions the rules that exist.

---

## 2. How Claude loads them

Claude loads `.claude/rules/` at session start. All files in the directory are read and kept in context.

You can scope a rule to specific file types using YAML frontmatter with a `glob` pattern. When a glob is present, Claude applies the rule only when working on files that match.

```markdown
---
glob: "**/*.sql"
---

All queries must use parameterised inputs. Never interpolate user-supplied values directly into a query string.
```

Without a glob, the rule applies globally.

Rules are additive: later rules can extend or override earlier ones. If two rules conflict, Claude will try to reconcile them, but keeping rules focused on distinct topics avoids ambiguity.

---

## 3. How to structure rules

**Keep the directory flat or one level deep.** Something like `rules/code-style.md` and `rules/git-workflow.md` is easier to maintain than deeply nested subdirectories. One level of grouping (e.g. `rules/common/`, `rules/frontend/`) is fine when the codebase has genuinely separate domains.

**One file per topic.** A rule file should cover one concern: commit conventions, API design, testing patterns, naming conventions. Mixing topics makes rules hard to update and easy to contradict.

**Use clear file names.** `rules/commit-conventions.md` is better than `rules/guidelines.md`. The filename is the first hint to Claude about what the file covers.

**Write rules as direct instructions.** Avoid hedging language. "Always use named exports" is clearer than "We tend to prefer named exports where possible." Claude follows instructions literally, so precision matters.

**Keep rules short.** A rule file that runs to hundreds of lines is hard to maintain and competes with other context. If a topic needs that much detail, consider splitting it.

---

## 4. Available rules

| Rule file | What it covers |
|---|---|
| [code-style.md](../rules/code-style.md) | Language conventions, formatting rules, and patterns to avoid |
| [git-workflow.md](../rules/git-workflow.md) | Branch naming, commit message format, and PR workflow |
| [testing.md](../rules/testing.md) | Test types, file naming, isolation requirements, and mock patterns |
| [security.md](../rules/security.md) | Mandatory checks before commit, secret handling, and input validation |
| [code-review-format.md](../rules/code-review-format.md) | Conventional comment labels, tone, structure, and validation rules for reviews |
