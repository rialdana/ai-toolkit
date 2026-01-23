---
title: Follow the AAA Pattern
impact: HIGH
tags: structure, readability, consistency
---

## Follow the AAA Pattern

Structure tests with Arrange, Act, Assert. This makes tests readable and consistent.

**Incorrect (unstructured test):**

```typescript
// Bad - everything mixed together
test('invitation flow', async () => {
  const org = await createTestOrg();
  const admin = await createTestUser({ orgId: org.id, role: 'ADMIN' });
  expect(admin.role).toBe('ADMIN'); // premature assertion
  const ctx = createTestContext({ user: admin, orgId: org.id });
  const result = await ctx.caller.invitations.create({
    email: 'new@example.com',
  });
  const found = await db.query.invitations.findFirst({ where: ... });
  expect(result.status).toBe('PENDING');
  expect(found).toBeDefined();
  expect(found.email).toBe('new@example.com');
});
```

**Correct (AAA pattern):**

```typescript
test('creates invitation for new email', async () => {
  // Arrange - set up test data and dependencies
  const org = await createTestOrg();
  const admin = await createTestUser({ orgId: org.id, role: 'ADMIN' });
  const ctx = createTestContext({ user: admin, orgId: org.id });

  // Act - perform the action being tested
  const result = await ctx.caller.invitations.create({
    email: 'new@example.com',
    role: 'MEMBER',
  });

  // Assert - verify the outcomes
  expect(result.email).toBe('new@example.com');
  expect(result.status).toBe('PENDING');
  expect(result.role).toBe('MEMBER');
});
```

**Guidelines:**

- **Arrange**: Create test data, mocks, and context
- **Act**: Execute the single action under test
- **Assert**: Verify all expected outcomes

**Why it matters:**
- Easy to scan and understand tests
- Clear separation of setup, action, and verification
- Consistent structure across the codebase
- Easier to debug failing tests
