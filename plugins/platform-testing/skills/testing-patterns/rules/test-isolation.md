---
title: Tests Must Be Independent
impact: HIGH
tags: structure, reliability, isolation
---

## Tests Must Be Independent

Each test should run in isolation. No shared mutable state, no dependency on other tests.

**Incorrect (shared state):**

```typescript
// Bad - shared mutable state causes coupling
describe('invitations', () => {
  let testOrg: Organization;
  let testUser: User;

  beforeAll(async () => {
    testOrg = await createTestOrg();
    testUser = await createTestUser({ orgId: testOrg.id });
  });

  test('creates invitation', async () => {
    // Modifies shared org's invitation count
    await createInvitation({ orgId: testOrg.id, email: 'a@test.com' });
  });

  test('lists invitations', async () => {
    // Depends on previous test having run!
    const invitations = await listInvitations({ orgId: testOrg.id });
    expect(invitations).toHaveLength(1); // Flaky!
  });
});
```

**Correct (isolated tests):**

```typescript
describe('invitations', () => {
  test('creates invitation', async () => {
    // Each test creates its own data
    const org = await createTestOrg();
    const user = await createTestUser({ orgId: org.id, role: 'ADMIN' });
    const ctx = createTestContext({ user, orgId: org.id });

    const result = await ctx.caller.invitations.create({
      email: 'new@example.com',
    });

    expect(result.status).toBe('PENDING');
  });

  test('lists invitations for organization', async () => {
    // Independent - creates its own data
    const org = await createTestOrg();
    const user = await createTestUser({ orgId: org.id, role: 'ADMIN' });
    const ctx = createTestContext({ user, orgId: org.id });

    // Create known data
    await ctx.caller.invitations.create({ email: 'a@test.com' });
    await ctx.caller.invitations.create({ email: 'b@test.com' });

    const invitations = await ctx.caller.invitations.list();

    expect(invitations).toHaveLength(2);
  });
});
```

**Benefits of isolation:**

- Tests can run in parallel
- Test order doesn't matter
- Failures are easier to debug
- No hidden dependencies between tests

**Why it matters:**
- Shared state causes intermittent failures
- Tests become order-dependent
- Debugging requires running entire suite
- Parallelization becomes impossible
