---
description: "Create a pull request for the current branch."
argument-hint: "[--draft]"
allowed-tools: "Bash"
model: "sonnet"
---

# /raise-pr

Create a pull request for the current branch. Pass `--draft` to open as a draft.

## Steps

### 1. Determine the base branch

Use your project's integration branch (e.g. `main`, `develop`). Customise this for your workflow.

### 2. Review all changes

```bash
git log <base-branch>...HEAD --oneline
git diff <base-branch>...HEAD
```

Read the **full commit history** and **all changes** since the branch diverged from the base. Don't rely on just the latest commit.

### 3. Draft the title and body

**Title format:** `<type>: <short description>` (under 70 characters)

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`

**Body:** If a PR template exists at `.github/pull_request_template.md`, fill it in. Otherwise write a concise summary covering:
- What changed and why
- How to test it
- Any deployment or migration steps required
- The issue it closes (`Closes #<number>`)

### 4. Show draft to user

Present the title and body for review before creating the PR. Wait for confirmation or edits.

### 5. Push the branch

If the branch hasn't been pushed yet:

```bash
git push -u origin HEAD
```

### 6. Create the PR

```bash
gh pr create --title "<title>" --body "<body>"
```

If `$ARGUMENTS` contains `--draft`, add the `--draft` flag:

```bash
gh pr create --title "<title>" --body "<body>" --draft
```

### 7. Return the PR URL

Output the URL of the newly created PR.
