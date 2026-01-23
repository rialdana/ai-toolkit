---
title: Test Behavior, Not Implementation
impact: HIGH
tags: philosophy, maintainability, refactoring
---

## Test Behavior, Not Implementation

Test what the code does (behavior), not how it does it (implementation). Tests should survive refactoring.

**Incorrect (testing implementation):**

```typescript
// Bad - tests internal implementation details
test('calls insertUser with correct params', async () => {
  const spy = jest.spyOn(repository, 'insertUser');

  await createUser({ email: 'test@test.com', name: 'Test' });

  expect(spy).toHaveBeenCalledWith({
    id: expect.any(String),
    email: 'test@test.com',
    name: 'Test',
    createdAt: expect.any(Date),
  });
});

// If repository signature changes, test breaks
// Even if the actual behavior is still correct
```

**Correct (testing behavior):**

```typescript
// Good - tests observable behavior
test('creates user with provided email and name', async () => {
  const result = await createUser({
    email: 'test@test.com',
    name: 'Test',
  });

  expect(result.email).toBe('test@test.com');
  expect(result.name).toBe('Test');
  expect(result.id).toBeDefined();
});

test('created user can be retrieved', async () => {
  const created = await createUser({ email: 'test@test.com', name: 'Test' });

  const retrieved = await getUser(created.id);

  expect(retrieved.email).toBe('test@test.com');
});
```

**Signs you're testing implementation:**

- Spying on internal function calls
- Asserting specific method call order
- Testing private methods
- Asserting internal state structures

**Why it matters:**
- Implementation changes shouldn't break tests
- Refactoring becomes terrifying when every change breaks tests
- Tests become documentation of behavior, not code structure
- Less maintenance burden over time
