# Skills

Skills are reusable knowledge files that commands and agents can load on demand. They let you extract a well-defined capability -- like "how to do a code review" or "how to write a migration" -- and share it across multiple commands without duplicating instructions.

## Table of Contents

1. [What skills are](#1-what-skills-are)
2. [How to create one](#2-how-to-create-one)
3. [How commands and agents load skills](#3-how-commands-and-agents-load-skills)
4. [Available skills](#4-available-skills)
5. [Authoring with skill-creator](#5-authoring-with-skill-creator)

---

## 1. What skills are

A skill is a `SKILL.md` file inside a named directory under `.claude/skills/`. The directory name becomes the skill identifier.

```
.claude/skills/
  code-review/
    SKILL.md
  write-migration/
    SKILL.md
```

Skills differ from rules and commands:

| Concept | Loaded | Triggered by |
|---------|--------|--------------|
| Rule | Always (ambient) | Nothing -- always active |
| Command | On demand | User types `/<command-name>` |
| Skill | On demand | A command or agent explicitly loads it |

Skills sit between rules and commands. They're not always active (that would pollute every session), and they're not entry points (users don't invoke them directly). They're knowledge modules that get pulled in when relevant.

---

## 2. How to create one

Create a directory under `.claude/skills/` and add a `SKILL.md` file inside it.

```
mkdir -p .claude/skills/my-skill
touch .claude/skills/my-skill/SKILL.md
```

The `SKILL.md` file should contain:

- **What the skill does** -- one sentence at the top
- **The process** -- step-by-step instructions Claude follows when applying the skill
- **Output format** -- what the result should look like
- **What to skip** -- explicit exclusions to keep the skill focused

Keep skills single-purpose. A skill that does "code review and also writes tests and also updates docs" is three skills in a trenchcoat.

---

## 3. How commands and agents load skills

Reference the skill path in the instruction body of a command or agent file:

```markdown
Before reviewing, load and apply the instructions in `.claude/skills/code-review/SKILL.md`.
```

Claude will read the skill file and apply its instructions for the duration of the task. You can load multiple skills in one command if the task genuinely requires it, but keep the list short -- each loaded skill adds to the context.

---

## 4. Available skills

| Skill | What it does |
|-------|--------------|
| [skills/code-review/](../skills/code-review/SKILL.md) | Structured code review with severity-grouped findings and a clear verdict |

---

## 5. Authoring with skill-creator

[skill-creator](https://claude.com/plugins/skill-creator) is a Claude Code plugin that guides you through writing a new skill interactively. It asks about the task, the expected output, and edge cases, then produces a ready-to-use `SKILL.md`.

Install it once globally:

```
/plugin install skill-creator
```

Then invoke it whenever you want to add a new skill:

```
/skill-creator
```

It's particularly useful for skills with complex output formats or multi-step processes where getting the instruction structure right matters.
