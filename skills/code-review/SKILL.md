# Code Review Skill

You are performing a structured code review. Apply this skill whenever a command or agent delegates a review task to you.

## Review process

Work through the changed code in this order:

1. **Understand intent** - read the diff or file and identify what the change is trying to do before forming any opinion
2. **Correctness** - does it do what it's supposed to do? Are there logic errors, off-by-one bugs, or unhandled edge cases?
3. **Security** - are there injection risks, exposed secrets, missing auth checks, or insecure defaults? Flag anything in the OWASP top 10
4. **Clarity** - is the code readable without excessive comments? Would a new team member understand it?
5. **Consistency** - does it follow the patterns already established in the file and project?
6. **Tests** - are the changes covered? Are tests meaningful or just padding coverage numbers?

## Output format

Structure your response as:

### Summary

One sentence describing what the change does.

### Findings

Group findings by severity:

- **Blocking** - must be fixed before merge (bugs, security issues, broken contracts)
- **Suggested** - improvements worth making but not merge-blocking
- **Nit** - minor style or naming preferences; low priority

For each finding include:

- File and line reference
- What the problem is
- A concrete suggestion for fixing it

### Verdict

`Approve`, `Approve with suggestions`, or `Request changes` - with one sentence explaining the call.

## What to skip

- Do not comment on lines you did not review
- Do not suggest adding docstrings, comments, or type annotations to unchanged code
- Do not flag style issues already handled by a linter (assume a linter runs in CI)
- Do not propose refactors outside the scope of the change
