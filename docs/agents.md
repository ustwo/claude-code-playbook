# Agents

Agents are specialised subagents that run in their own context window. They let you delegate focused work without burning the main session's context on exploration, search, or domain-specific review.

## Table of Contents

1. [What agents are](#1-what-agents-are)
2. [When to delegate](#2-when-to-delegate)
3. [Model selection](#3-model-selection)
4. [Scoping rules](#4-scoping-rules)
5. [Available agents](#5-available-agents)

---

## 1. What agents are

An agent is a `.md` file in `.claude/agents/`. Like commands, the file contains instructions Claude follows. Unlike commands, an agent runs as a subagent: it gets its own context window, its own tool set, and returns a summary to the calling session when it's done.

Agents are useful because they isolate expensive work. If you ask the main session to read 20 files, all 20 files land in the main context and stay there. If you delegate that same task to an agent, only the agent's summary comes back. The main session stays lean.

---

## 2. When to delegate

Delegate when **any** of these apply:

- **The task spans more than three files.** Exploration burns context fast. Let an agent do the reading and return a focused summary.
- **The domain is specialised.** Database schema review, security auditing, and infrastructure validation all benefit from a dedicated agent with domain-specific instructions.
- **The work can run in parallel.** Two agents working on separate concerns finish faster than one session doing them sequentially.
- **The exploration is open-ended.** If you don't know where the answer is, let an agent search. The main session should handle decisions and edits, not grep.

A good rule of thumb: if completing the task would require Claude to read more than three files in the main session, delegate it.

---

## 3. Model selection

Pick the model that matches the complexity of the task, not the one with the highest capability ceiling.

| Model | Best for |
|---|---|
| Haiku | Search, grep, file lookups, quick summaries, simple Q&A |
| Sonnet | Code writing, bug fixes, reviews, standard engineering tasks |
| Opus | Architecture decisions, ADRs, complex multi-step planning, system design |

Using Haiku for search agents cuts cost and latency significantly. Reserve Opus for tasks where the quality of reasoning genuinely changes the outcome.

---

## 4. Scoping rules

**One agent = one concern.** Don't bundle a database review and a security audit into the same agent. Split them. A tightly scoped agent produces a cleaner summary and is easier to reason about.

**Limit tools to what the agent needs.** A read-only research agent shouldn't have Write access. A formatting agent doesn't need Bash. Restricting tools reduces the surface area for mistakes and makes the agent's behaviour predictable.

**Background vs foreground:**

- Run an agent in the **background** when its output doesn't affect the next step. For example, generating a report while you continue writing code.
- Run an agent in the **foreground** when the main session needs the result before it can continue. For example, a database reviewer whose schema feedback determines what migrations to write.

**Return a summary, not raw data.** Tell agents to return a concise summary rather than dumping file contents back into the main context. The main session needs conclusions, not transcripts.

---

## 5. Available agents

| Agent | What it does |
|---|---|
| [planner.md](../agents/planner.md) | Spikes a codebase, identifies affected areas, and produces a structured implementation plan |
| [architect.md](../agents/architect.md) | Evaluates design options and produces an ADR or architecture recommendation |
| [build-error-resolver.md](../agents/build-error-resolver.md) | Diagnoses build and type errors, identifies the root cause, and suggests a fix |
| [database-reviewer.md](../agents/database-reviewer.md) | Reviews migrations, schema changes, and queries for correctness and safety |
