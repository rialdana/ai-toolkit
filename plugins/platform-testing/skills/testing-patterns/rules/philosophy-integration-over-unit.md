---
title: Prefer Integration Tests Over Unit Tests
impact: HIGH
tags: philosophy, integration, testing-trophy
---

## Prefer Integration Tests Over Unit Tests

Integration tests provide the best return on investment. They test multiple units working together and catch real bugs.

> "The more your tests resemble the way your software is used, the more confidence they can give you." — Kent C. Dodds

**Testing trophy (bottom to top):**

```
    ┌─────────────┐
    │   E2E       │  ← Few, slow, high confidence
    ├─────────────┤
    │ Integration │  ← Most tests here (best ROI)
    ├─────────────┤
    │    Unit     │  ← Some, for complex logic
    ├─────────────┤
    │   Static    │  ← TypeScript + linting (free)
    └─────────────┘
```

**Incorrect (over-mocked unit tests):**

```typescript
// Bad - mocks everything, tests nothing real
test('createInvitation calls repository', async () => {
  const mockRepo = { insert: jest.fn() };
  const mockValidator = { validate: jest.fn() };
  const mockEmailer = { send: jest.fn() };

  await createInvitation(
    { email: 'test@test.com' },
    mockRepo, mockValidator, mockEmailer
  );

  expect(mockRepo.insert).toHaveBeenCalled();
  // This passes even if the actual integration is broken!
});
```

**Correct (integration test):**

```typescript
// Good - tests actual behavior through the stack
test('creates invitation and stores in database', async () => {
  const caller = createTestCaller({ user: adminUser, orgId: testOrg.id });

  const result = await caller.invitations.create({
    email: 'new@example.com',
    role: 'MEMBER',
  });

  // Verify response
  expect(result.status).toBe('PENDING');

  // Verify database state
  const stored = await db.query.invitations.findFirst({
    where: eq(invitations.id, result.id),
  });
  expect(stored).toBeDefined();
  expect(stored.email).toBe('new@example.com');
});
```

**When to use unit tests:**

- Pure functions with complex logic
- Algorithms (sorting, calculations, parsing)
- Code that's truly isolated

**Why it matters:**
- Integration tests catch bugs at boundaries
- Mocked unit tests can pass while real code fails
- Better resembles how users actually use the software
