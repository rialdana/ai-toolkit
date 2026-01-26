---
title: Throw Early, Return Early
impact: MEDIUM
tags: error, readability, guard-clause
---

## Throw Early, Return Early

Check preconditions at the start of functions. Fail fast with clear errors instead of deeply nested conditionals.

**Incorrect (nested conditionals):**

```typescript
// Bad - deeply nested, hard to follow
async function processInvitation(ctx, input) {
  const invitation = await findInvitation(input.id);
  if (invitation) {
    if (invitation.organizationId === ctx.organizationId) {
      if (invitation.status === 'PENDING') {
        if (invitation.expiresAt > new Date()) {
          // Finally, the actual logic buried 4 levels deep
          await acceptInvitation(invitation);
          return { success: true };
        } else {
          throw new Error('Expired');
        }
      } else {
        throw new Error('Not pending');
      }
    } else {
      throw new Error('Wrong org');
    }
  } else {
    throw new Error('Not found');
  }
}
```

**Correct (early returns with guard clauses):**

```typescript
// Good - flat, clear flow
async function processInvitation(ctx, input) {
  const invitation = await findInvitation(input.id);

  // Guard clauses - check all preconditions first
  if (!invitation) {
    throw new NotFoundError('Invitation', input.id);
  }

  if (invitation.organizationId !== ctx.organizationId) {
    throw new ForbiddenError('Invitation belongs to different organization');
  }

  if (invitation.status !== 'PENDING') {
    throw new ConflictError('Invitation is no longer pending');
  }

  if (invitation.expiresAt <= new Date()) {
    throw new InvitationExpiredError();
  }

  // Happy path - all checks passed
  await acceptInvitation(invitation);
  return { success: true };
}
```

**Why it matters:**
- Linear code is easier to read and reason about
- Each error case is clearly visible at the top
- No cognitive load tracking nested if/else
- Easier to add new precondition checks
