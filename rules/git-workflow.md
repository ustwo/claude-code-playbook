# Git workflow

## Branch strategy

Create branches from your team's integration branch (commonly `main` or `develop`). Make sure the integration branch is up to date before branching.

The important thing is that the whole team branches from the same place. Pick one and stick to it.

## Branch naming

| Prefix | When to use |
|---|---|
| `feature/<number>-<slug>` | New functionality |
| `fix/<number>-<slug>` | Bug fixes |
| `refactor/<number>-<slug>` | Refactoring with no behaviour change |
| `chore/<number>-<slug>` | Maintenance, dependency updates, config |

Keep slugs short and descriptive: `feature/42-user-invitations`, not `feature/42-add-the-user-invitation-feature-that-was-requested`.

## Commit message format

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>: <description>
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`

Style guidelines:
- Sentence case, present tense
- No em dashes and no colons in the description text (the type separator is required)
- Keep descriptions concise

Good examples:

```
feat: add user profile endpoint
fix: correct email validation for subdomains
refactor: extract order status reducer
chore: update dependencies to latest minor versions
test: add coverage for order cancellation edge case
```

## Reversible commits principle

Every commit must be independently revertable. That means:

- **One logical change per commit.** Don't bundle unrelated changes.
- **One domain per commit.** Separate API changes from UI changes from config changes.
- **Separate concerns.** Implementation in one commit, tests in another if they can be cleanly separated.

If reverting a commit would break something that has nothing to do with it, the commit is too large.

Good commit sequence:

```
feat: add order cancellation endpoint
test: add tests for order cancellation endpoint
docs: document order cancellation in API reference
```

Bad commit:

```
feat: order cancellation, fix email bug, update readme
```

## Pull request workflow

1. Diff against the base branch to review everything that will be in the PR before you create it:
   ```bash
   git log <base-branch>...HEAD --oneline
   git diff <base-branch>...HEAD
   ```
2. PR title follows the same format as commit messages: `<type>: <description>` (under 70 characters)
3. Fill in the PR template if one exists at `.github/pull_request_template.md`
4. Link the issue: `Closes #<number>`
5. Open as draft if the work isn't ready for review

## Pre-commit checklist

Before every commit:

- [ ] Run your formatter (`prettier --write`, `gofmt`, `black`, etc.)
- [ ] Run your linter and fix any errors
- [ ] No `console.log` left in
- [ ] No hardcoded secrets or environment-specific values
- [ ] Tests pass locally

## Before merging

- CI checks are green (build, types, lint, tests, security scan)
- At least one approval from a reviewer
- All review threads resolved
