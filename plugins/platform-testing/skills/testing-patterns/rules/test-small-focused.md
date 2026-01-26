---
title: Keep Tests Small and Focused
impact: MEDIUM
tags: structure, maintainability, debugging
---

## Keep Tests Small and Focused

Each test should verify one behavior. If a test is getting long, it's probably testing too many things.

**Incorrect (testing multiple behaviors):**

```typescript
// Bad - tests multiple behaviors in one test
test('invitation flow', async () => {
  // Creates invitation
  const invitation = await createInvitation({ email: 'test@test.com' });
  expect(invitation.status).toBe('PENDING');
  expect(invitation.expiresAt).toBeDefined();

  // Sends email
  expect(emailService.send).toHaveBeenCalled();

  // Cannot create duplicate
  await expect(
    createInvitation({ email: 'test@test.com' })
  ).rejects.toThrow();

  // Can accept invitation
  await acceptInvitation(invitation.token);
  const accepted = await getInvitation(invitation.id);
  expect(accepted.status).toBe('ACCEPTED');

  // Cannot accept twice
  await expect(acceptInvitation(invitation.token)).rejects.toThrow();
});
```

**Correct (one behavior per test):**

```typescript
describe('createInvitation', () => {
  test('creates pending invitation', async () => {
    const invitation = await createInvitation({ email: 'test@test.com' });

    expect(invitation.status).toBe('PENDING');
    expect(invitation.expiresAt).toBeDefined();
  });

  test('sends notification email', async () => {
    await createInvitation({ email: 'test@test.com' });

    expect(emailService.send).toHaveBeenCalledWith(
      expect.objectContaining({ to: 'test@test.com' })
    );
  });

  test('rejects duplicate pending invitation', async () => {
    await createInvitation({ email: 'test@test.com' });

    await expect(
      createInvitation({ email: 'test@test.com' })
    ).rejects.toThrow('already exists');
  });
});

describe('acceptInvitation', () => {
  test('marks invitation as accepted', async () => { ... });
  test('rejects already-accepted invitation', async () => { ... });
});
```

**Guideline:** If a test has more than ~10 statements, consider splitting it.

**Why it matters:**
- Failed tests pinpoint exactly what broke
- Easier to understand what each test covers
- Simpler to maintain and update
- Better test coverage visibility
