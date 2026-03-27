# Testing

## Test types

### Unit tests

Test individual functions, utilities, and pure logic in isolation. No network calls, no filesystem, no database.

Examples:
- Validation logic
- Data transformation functions
- Business rule calculations
- Error formatting utilities

### Integration tests

Test how components work together: API endpoints, database operations, service interactions.

Examples:
- HTTP handler receives a request and returns the correct response
- A service method writes to the database and returns the saved record
- A queue consumer processes a message and triggers the expected side effect

### End-to-end tests

Test critical user flows from the outside, exercising the full stack.

Examples:
- User registers, receives a confirmation, and can log in
- User submits an order and sees it appear in their order history
- User fills in a form and sees validation errors on invalid input

## Guidelines

- Write tests for every bug fix. A failing test that reproduces the bug, then passes after the fix, proves the fix works.
- Write tests for new features as part of the same PR - not as a follow-up.
- Tests must not share state. Each test must set up its own data and clean up after itself.
- Fix the implementation, not the test. If a test fails after a change, understand why before modifying the test.
- Make sure your mocks accurately reflect how the real dependency behaves.

## File naming

Keep test files alongside the source files they test:

```
src/
  services/
    user.service.ts
    user.service.test.ts       # unit tests
  routes/
    orders.route.ts
    orders.route.test.ts       # integration tests
e2e/
  checkout.spec.ts             # end-to-end critical flows
  authentication.spec.ts
```

## ESM mocking

```ts
import { vi } from 'vitest'

vi.mock('../db/client', () => ({
  db: {
    query: vi.fn().mockResolvedValue({ rows: [] }),
  },
}))
```

Adapt to your test runner. The key principle: mock at the module boundary, not inside the implementation.

## Type-safe test helpers

Use factory functions to create test data. This keeps you from littering brittle object literals across every test file.

```ts
function createUser(overrides: Partial<User> = {}): User {
  return {
    id: 'user-123',
    email: 'test@example.com',
    name: 'Test User',
    createdAt: new Date('2024-01-01'),
    ...overrides,
  }
}

function createOrder(overrides: Partial<Order> = {}): Order {
  return {
    id: 'order-456',
    userId: 'user-123',
    status: 'pending',
    total: 100,
    ...overrides,
  }
}
```

Pass `overrides` in individual tests to set up the specific scenario you're testing:

```ts
it('rejects orders from suspended users', async () => {
  const user = createUser({ status: 'suspended' })
  const order = createOrder({ userId: user.id })
  // ...
})
```
