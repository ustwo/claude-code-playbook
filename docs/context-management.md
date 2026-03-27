# Context management

Claude has a finite context window. As it fills up, response quality degrades, Claude loses track of earlier instructions, and eventually the session compacts or cuts off. Managing context actively is one of the highest-leverage habits for teams using Claude Code heavily.

## Table of Contents

1. [Why context matters](#1-why-context-matters)
2. [Auto-compact threshold](#2-auto-compact-threshold)
3. [Delegation philosophy](#3-delegation-philosophy)
4. [Model cost vs capability](#4-model-cost-vs-capability)
5. [Background vs foreground](#5-background-vs-foreground)

---

## 1. Why context matters

Every file Claude reads, every tool output, every message in the conversation takes up tokens. Claude's effective reasoning window is smaller than its technical maximum: performance starts to degrade well before the window is technically full.

The practical consequence is that a session which started well can drift by the end of a long task. Claude starts missing earlier instructions, contradicts conventions it followed at the start, or produces less precise output. It's not a model bug - it's a physics-of-context problem.

The solution is to treat context like a resource to be managed, not a buffer to be filled.

---

## 2. Auto-compact threshold

Claude Code has a built-in auto-compact mechanism that summarises the conversation when the context window fills up. By default it triggers at 95% - far too late, because quality has already degraded by the time compaction runs.

Lower the threshold by setting an environment variable in your shell config:

```bash
# ~/.zshrc or ~/.bashrc
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=30
```

A threshold of 30% means compaction runs much earlier, keeping the active context lean. The trade-off is that compaction discards detail, so use the `reinject-context-after-compact.sh` hook to restore the most important state (branch name, recent commits, project reminders) immediately after compaction.

---

## 3. Delegation philosophy

The main session should handle decisions and edits. Subagents should handle exploration.

A concrete rule: **if completing a task requires reading more than three files, delegate it to an agent.** The agent reads everything it needs in its own context window, then returns a summary. Only the summary lands in the main session.

This keeps the main context available for the work that actually matters: understanding trade-offs, writing code, reviewing changes. Burning main context on `grep` and `cat` is the most common cause of quality degradation in long sessions.

See [agents.md](./agents.md) for how to scope and invoke subagents.

---

## 4. Model cost vs capability

A common mistake is defaulting to the most capable model for everything. Larger models use more tokens, cost more, and are often no better than smaller models for routine work.

| Model | Use when |
|---|---|
| Haiku | Subagents doing search, grep, file lookups, or simple summaries |
| Sonnet | Standard code writing, bug fixes, reviews, everyday engineering tasks |
| Opus | Architecture decisions, ADRs, complex planning where reasoning depth changes the outcome |

Using Haiku for search agents costs a fraction of Sonnet and is often faster. Reserve Opus for decisions where the quality of the reasoning genuinely matters.

Mixing models within a session is fine: use Sonnet as the main session model and spawn Haiku agents for exploration tasks.

---

## 5. Background vs foreground

When you spawn an agent, decide whether the main session needs to wait for the result.

**Run an agent in the foreground** when its output determines what the main session does next. For example: a schema reviewer whose feedback dictates which migrations to write. The main session blocks until the agent returns.

**Run an agent in the background** when the main session can keep working while the agent completes. For example: generating a changelog while writing tests. The agent result arrives later and can be incorporated when it's ready.

Background agents are particularly useful for parallelising independent work: two agents reviewing separate parts of a codebase simultaneously, rather than sequentially in a single session. The context savings compound because neither agent's exploration appears in the main window.
