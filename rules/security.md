# Security

## Mandatory checks before any commit

- [ ] No hardcoded secrets (API keys, passwords, tokens, connection strings)
- [ ] All user inputs validated with a schema library before use
- [ ] Database queries use parameterised statements - no string concatenation
- [ ] User-generated content is sanitised before rendering to prevent XSS
- [ ] Every protected API route has authentication middleware
- [ ] Rate limiting applied to all public-facing endpoints
- [ ] Error responses don't expose stack traces or internal implementation details
- [ ] No sensitive data (tokens, PII, credentials) passed to the logger

## Secret management

Never hardcode values that should be secret. Load them from environment variables at runtime.

```ts
// good
const apiKey = process.env.THIRD_PARTY_API_KEY
if (!apiKey) throw new Error('THIRD_PARTY_API_KEY is not set')

// bad
const apiKey = 'sk-live-abc123...'
```

Document every required environment variable in `.env.example` with a description and a placeholder value. Never commit a `.env` file containing real secrets.

If a secret is accidentally committed, treat it as compromised immediately - rotate the credential before removing it from history.

## Input validation

Validate all external input at the boundary of your system (HTTP request bodies, query parameters, headers, queue messages). Reject invalid input early with a clear error. Don't pass unvalidated data deeper into the system.

## Authentication

Every API route that requires a logged-in user must apply authentication middleware. Don't rely on client-side checks alone. Validate tokens server-side on every request.

## Client builds

Don't bundle secrets into client-side builds. Environment variables injected at build time are visible to anyone who downloads the bundle. Only expose values that are genuinely public.

## Dependency scanning

Run a dependency audit as part of CI:

```bash
npm audit --audit-level=high
```

Review and resolve high and critical vulnerabilities before merging. For issues that can't be resolved immediately, document them and track them as issues.

## When a security issue is found

1. Stop work on the current task
2. Fix CRITICAL issues immediately before continuing
3. Rotate any exposed credentials - assume they're compromised
4. Document what was exposed, for how long, and what was done to remediate
