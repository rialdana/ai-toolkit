---
title: Single Responsibility
impact: CRITICAL
tags: principles, modularity, design
---

## Single Responsibility

Each function/module should do one thing well. If you can't describe what it does in one sentence, it's doing too much.

**Incorrect (multiple responsibilities):**

```typescript
async function processUserRegistration(data: FormData) {
  // Validates input
  if (!data.email || !data.password) throw new Error('Invalid');

  // Creates user in database
  const user = await db.users.create({ ... });

  // Sends welcome email
  await sendEmail(user.email, 'Welcome!', ...);

  // Logs analytics event
  await analytics.track('user_registered', { userId: user.id });

  // Updates cache
  await cache.invalidate('users');

  return user;
}
```

**Correct (separated responsibilities):**

```typescript
async function registerUser(input: RegistrationInput): Promise<User> {
  const validated = validateRegistration(input);
  const user = await createUser(validated);

  // Side effects handled separately via events or explicit calls
  await onUserRegistered(user);

  return user;
}

async function onUserRegistered(user: User) {
  await Promise.all([
    sendWelcomeEmail(user),
    trackRegistration(user),
    invalidateUserCache(),
  ]);
}
```

**Why it matters:** Functions with multiple responsibilities are hard to test, reuse, and modify. Changes to one responsibility risk breaking others.
