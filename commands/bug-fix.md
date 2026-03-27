---
description: "Investigate and fix a bug. Starts with reproduction, not planning."
argument-hint: "[issue-number]"
allowed-tools: "Read, Edit, Write, Bash, Grep, Glob"
model: "sonnet"
---

# /bug-fix

Investigate and fix a bug methodically. The rule is: reproduce before you plan, and understand the root cause before you write a fix.

## Steps

### 1. Understand the bug

If an issue number is provided, fetch it:

```bash
gh issue view $ARGUMENTS
```

Read the full description. Identify:
- What is the **expected** behaviour?
- What is the **actual** behaviour?
- Which package, service, or module is affected?
- Is there a stack trace or error message to work from?

### 2. Reproduce

Reproduce the bug locally before touching any code. If you can, write a failing test that demonstrates the problem. A failing test is the clearest proof of reproduction and becomes the acceptance criterion for the fix.

If the bug can't be covered by an automated test (e.g. it's a rendering or timing issue), document the exact steps to reproduce manually.

### 3. Find the root cause

Trace the code path from entry point to failure. Use Grep and Read to follow the execution. Identify the **exact line** where the wrong behaviour originates.

State the root cause explicitly before writing any fix:

> "The root cause is [X] because [Y]."

Don't proceed to the fix step until the root cause is clear.

### 4. Apply the fix

Make the **smallest possible change** that corrects the root cause. Rules:

- Touch only the code that is wrong
- Don't refactor surrounding code
- Don't improve unrelated things
- Don't change behaviour beyond what the issue describes

### 5. Confirm

Run the tests:

```bash
npm test
```

The failing test from step 2 must now pass. All other tests must still pass. If any previously passing test now fails, the fix has a side effect - go back to step 3.

### 6. Branch and ship

Create a branch for the fix:

```bash
git checkout -b fix/$ARGUMENTS-<short-slug>
```

Then run `/gate-check` to verify all checks pass, followed by `/raise-pr` to open the pull request.
