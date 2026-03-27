---
description: "Full pre-PR verification. Build, types, lint, tests, security scan."
argument-hint: "[]"
allowed-tools: "Bash"
model: "sonnet"
---

# /gate-check

Run all pre-PR checks in sequence. Stop at the first failure. Don't skip steps.

## Checks

Run these commands in order, stopping at the first non-zero exit code:

```bash
npm run build
```

```bash
npx tsc --noEmit
```

```bash
npm run lint
```

```bash
npm test -- --coverage
```

```bash
npm audit --audit-level=high
```

Adapt the commands to your project's toolchain. For example:
- Replace `npm run build` with your build command (`make build`, `cargo build`, etc.)
- Replace `npx tsc --noEmit` with your type checker if you're not using TypeScript
- Replace `npm run lint` with your linter (`ruff check .`, `golangci-lint run`, etc.)
- Replace `npm test` with your test runner (`pytest`, `go test ./...`, etc.)

## Report

After all checks complete, output a summary table:

| Check    | Status |
|----------|--------|
| Build    | PASS / FAIL |
| Types    | PASS / FAIL |
| Lint     | PASS / FAIL |
| Tests    | PASS / FAIL |
| Security | PASS / FAIL |

**Overall: READY** if all checks pass.
**Overall: NOT READY** if any check failed. Show the error output for the first failure.
