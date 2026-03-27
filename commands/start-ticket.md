---
description: "Start working on a ticket. Fetches issue, explores codebase, creates branch, produces plan."
argument-hint: "[ticket-number]"
allowed-tools: "Read, Edit, Write, Bash, Grep, Glob"
model: "sonnet"
---

# /start-ticket

Start working on a ticket end-to-end: fetch the issue, spike the codebase, identify risks, create a branch, and produce a phased plan.

## Steps

### 1. Fetch the issue

```bash
gh issue view $ARGUMENTS
```

Read the issue title, description, and acceptance criteria in full. Understand what's being asked before touching any code.

### 2. Spike the codebase

Explore the codebase to identify every file and module involved. Trace the data flow end-to-end:

- Which service or package owns this feature?
- What are the key types, interfaces, and schemas involved?
- Which other modules depend on the affected code?
- Are there existing tests that cover this area?

Use Grep and Glob to search broadly. Read the relevant files to understand the current implementation.

### 3. Identify risks

Before planning, flag anything that could cause problems:

- **Breaking changes** - public interfaces, shared types, or API contracts that other code depends on
- **Cascading effects** - changes in one module that ripple into others
- **Schema or data changes** - any modification to stored data structures
- **Infrastructure changes** - configuration, environment variables, or deployment concerns
- **Missing context** - anything the issue description doesn't make clear

If a risk is ambiguous, note it in the plan and ask the user before proceeding.

### 4. Create the branch

Customise the base branch for your workflow (e.g. `main`, `develop`, or another integration branch).

```bash
git checkout <base-branch>
git pull
git checkout -b feature/$ARGUMENTS-<short-slug>
```

Use `fix/` prefix for bug fix tickets, `refactor/` for refactoring, `feature/` for new functionality.

### 5. Produce a phased plan

Write a plan with:

- **Phase 1 - Foundation:** shared types, interfaces, schemas, migrations (anything others depend on)
- **Phase 2 - Core implementation:** the main logic change
- **Phase 3 - Integration:** wiring the implementation into the rest of the system
- **Phase 4 - Tests and verification:** unit, integration, or E2E tests as appropriate
- **Phase 5 - Cleanup:** remove scaffolding, dead code, temporary workarounds

Each phase must list exact file paths that will be created or modified.

**Don't start implementation until the user confirms the plan.**
