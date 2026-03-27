# Code review format

When you're giving review feedback, follow this format. It keeps reviews consistent and easy to act on.

## Comment labels

Use [conventional comments](https://conventionalcomments.org/):

| Label | When to use |
|---|---|
| `issue (critical):` | Must be fixed before merging |
| `issue:` | Should be fixed before merging |
| `suggestion:` | Nice to have, not blocking |
| `nitpick (non-blocking):` | Take it or leave it |

## Tone

Keep it casual and conversational. Write like you're pairing with someone, not filing a report. Two lines max per comment. Be direct about what the problem is.

## Comment structure

Every comment needs these four parts:

1. **File and line number** - the exact line in the diff where the comment applies
2. **Label** - one of the labels above
3. **Problem and fix** - what's wrong and how to fix it, in one or two sentences
4. **Reference link** - MDN, the language spec, a relevant RFC, or a widely recognised resource

Example:

```
src/routes/orders.ts:47
issue: this query runs inside a loop and fires one database call per order
fetch all orders in a single query with an IN clause instead
https://use-the-index-luke.com/sql/where-clause/the-equals-operator/in-list
```

## Before you post a comment

Check it against these before including it in your review:

- Does the project actually use the tool or pattern you're suggesting? Don't recommend something that isn't already in use.
- Is the scenario realistic? Don't add defensive code for edge cases that can't happen in this context.
- Does the fix add more complexity than the problem it solves? If yes, drop the comment.
- Is this already handled elsewhere (middleware, a base class, a shared utility)? If yes, point to that instead.

Don't over-engineer. If a comment takes more than two sentences to justify, reconsider whether it belongs in the review.
