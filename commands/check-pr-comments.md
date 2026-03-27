---
description: "Fetch and display all comments, reviews, and threads for a PR."
argument-hint: "[pr-number]"
allowed-tools: "Bash"
model: "sonnet"
---

# /check-pr-comments

Fetch and display all reviews, inline comments, and general comments for a pull request.

## Steps

### 1. Get repository info

```bash
git remote get-url origin
```

Parse the owner and repo name from the URL. Works with both HTTPS (`https://github.com/owner/repo.git`) and SSH (`git@github.com:owner/repo.git`) formats.

### 2. Determine the PR number

If a number was passed in `$ARGUMENTS`, use it. Otherwise:

```bash
gh pr view --json number
```

If neither works, ask the user for the PR number.

### 3. Fetch reviews, comments, and inline comments

```bash
gh api repos/<owner>/<repo>/pulls/<pr-number>/reviews --paginate
gh api repos/<owner>/<repo>/pulls/<pr-number>/comments --paginate
gh api repos/<owner>/<repo>/issues/<pr-number>/comments --paginate
```

### 4. Display results

Structure the output in three sections:

**Reviews**

| Reviewer | State | Date |
|----------|-------|------|
| ... | APPROVED / CHANGES_REQUESTED / COMMENTED | ... |

Highlight any `CHANGES_REQUESTED` reviews.

**Inline comments (grouped by file)**

For each file with comments, show:
- File path and line number
- Whether the thread is resolved or unresolved
- The comment body (and any replies in the thread)

**General comments**

List in chronological order with author, date, and body.

**Summary**

- Total reviews
- Unresolved inline threads (count)
- Any `CHANGES_REQUESTED` reviews that haven't been followed up on

Usage: `/check-pr-comments` for the current branch's PR, or `/check-pr-comments 123` for a specific PR number.
