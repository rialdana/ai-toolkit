---
title: Describe Behavior in Test Names
impact: MEDIUM
tags: structure, readability, documentation
---

## Describe Behavior in Test Names

Test names should describe what the code does, not how it's implemented. Good names serve as documentation.

**Incorrect (implementation-focused names):**

```typescript
// Bad - describes implementation
test('calls insertUser', async () => { ... });
test('sets status to PENDING', async () => { ... });
test('validates email format', async () => { ... });
test('test1', async () => { ... });
test('invitation test', async () => { ... });
```

**Correct (behavior-focused names):**

```typescript
// Good - describes behavior
test('creates invitation for new email', async () => { ... });
test('rejects invitation for existing pending email', async () => { ... });
test('expires invitation after 7 days', async () => { ... });
test('sends email notification when invitation created', async () => { ... });
test('requires admin role to create invitation', async () => { ... });
```

**Naming patterns:**

```typescript
// Action + condition
test('creates user when email is valid', ...);
test('throws error when email already exists', ...);

// Behavior description
test('invitation expires after configured duration', ...);
test('deleted users cannot log in', ...);

// Error cases
test('rejects negative amounts', ...);
test('requires authentication', ...);
```

**Why it matters:**
- Failed tests immediately explain what broke
- Tests serve as behavior documentation
- New developers understand expectations quickly
- Easier to identify missing test cases
