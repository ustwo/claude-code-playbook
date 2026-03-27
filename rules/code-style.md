---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---

# Code style

## Exports

Use named exports. Default exports make refactoring harder and break the ability to search by name across the codebase.

```ts
// good
export function getUser(id: string): Promise<User> { ... }

// avoid
export default function getUser(id: string): Promise<User> { ... }
```

## Environment variables

Document every environment variable in `.env.example`. Never hardcode values that differ between environments.

```ts
// good
const apiUrl = process.env.API_URL
if (!apiUrl) throw new Error('API_URL is not set')

// bad
const apiUrl = 'https://api.my-project.internal'
```

## Module system

Use ESM imports. Don't use CommonJS `require()` in new code.

```ts
// good
import { createOrder } from './orders.js'

// bad
const { createOrder } = require('./orders')
```

## Immutability

Prefer immutable operations over mutation.

```ts
// good
const updated = { ...user, name: 'Alice' }

// avoid
user.name = 'Alice'
```

## Error handling

Use try-catch with your project's logger. Don't use `console.error` in production code. Don't swallow errors silently.

```ts
// good
try {
  await processOrder(orderId)
} catch (err) {
  logger.error({ err, orderId }, 'failed to process order')
  throw err
}

// bad
try {
  await processOrder(orderId)
} catch (err) {
  console.error(err)
}
```

## Logging

No `console.log` in committed code. Use your project's logger for all output.

## Type safety

- Don't use `any` unless the reason is documented with a comment
- Don't double-cast (`value as unknown as SomeType`) without justification
- Use `satisfies` to validate object literals against a type without widening

```ts
const config = {
  timeout: 5000,
  retries: 3,
} satisfies RequestConfig
```

## API response format

Use a consistent envelope for API responses:

```ts
// success
{ data: T }

// error
{ error: { code: string; message: string } }
```

## Repository pattern

Put data access behind an interface so the implementation can be swapped or mocked in tests:

```ts
interface UserRepository {
  findById(id: string): Promise<User | null>
  save(user: User): Promise<User>
  delete(id: string): Promise<void>
}
```

## Formatting

Run Prettier on all changed files before committing. Document your Prettier config in `.prettierrc` at the repo root so the whole team uses the same settings.
