---
title: Testing is About Confidence, Not Coverage
impact: HIGH
tags: philosophy, coverage, priorities
---

## Testing is About Confidence, Not Coverage

The goal of testing is confidence that your code works. Coverage percentages don't guarantee quality.

> "Write tests. Not too many. Mostly integration." — Guillermo Rauch

**Incorrect (coverage-driven):**

```typescript
// Bad - testing trivial code to hit coverage numbers
test('getter returns value', () => {
  const user = new User({ name: 'Test' });
  expect(user.getName()).toBe('Test');
});

test('constructor sets properties', () => {
  const user = new User({ name: 'Test', email: 'test@test.com' });
  expect(user.name).toBe('Test');
  expect(user.email).toBe('test@test.com');
});

// These tests add coverage but zero confidence
```

**Correct (confidence-driven):**

```typescript
// Good - testing behavior that matters
test('creates invitation for new user', async () => {
  const result = await createInvitation({
    email: 'new@example.com',
    role: 'MEMBER',
  });

  expect(result.status).toBe('PENDING');
  expect(result.expiresAt).toBeAfter(new Date());
});

test('rejects duplicate invitation', async () => {
  await createInvitation({ email: 'existing@example.com' });

  await expect(
    createInvitation({ email: 'existing@example.com' })
  ).rejects.toThrow('already exists');
});
```

**What to test (high confidence):**

- Critical business logic (payments, permissions)
- Complex algorithms
- Integration between components
- Regression prevention (bugs that occurred)

**What NOT to test:**

- Trivial getters/setters
- Framework code (React, Express already tested)
- Simple CRUD with no logic
- Things TypeScript catches

**Why it matters:**
- Time spent on low-value tests is time not spent on high-value tests
- False confidence from high coverage, low quality tests
- Maintenance burden of tests that don't catch bugs
