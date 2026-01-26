---
title: Never Swallow Errors Silently
impact: HIGH
tags: error, debugging, reliability
---

## Never Swallow Errors Silently

Empty catch blocks hide bugs and make debugging impossible. Always handle or rethrow errors.

**Incorrect (swallowing errors):**

```typescript
// Bad - silently ignores all errors
try {
  await riskyOperation();
} catch (e) {
  // do nothing
}

// Bad - returns null instead of surfacing error
async function getUser(id: string) {
  try {
    return await db.findUser(id);
  } catch {
    return null; // Database down? Network error? No idea!
  }
}
```

**Correct (handle or rethrow):**

```typescript
// Good - log and rethrow
try {
  await riskyOperation();
} catch (error) {
  console.error('Operation failed:', error);
  throw error;
}

// Good - explicit error handling
async function getUser(id: string) {
  try {
    return await db.findUser(id);
  } catch (error) {
    // Log for debugging
    console.error('Failed to fetch user:', { id, error });
    // Rethrow with context or throw domain error
    throw new DatabaseError('Failed to fetch user', { cause: error });
  }
}

// Good - if null is intentional, document why
async function findOptionalConfig(key: string) {
  try {
    return await db.findConfig(key);
  } catch (error) {
    // Config is optional - log but continue
    console.warn(`Config ${key} not found, using defaults`);
    return null;
  }
}
```

**Why it matters:**
- Silent failures lead to data corruption and inconsistent state
- Hours of debugging to find a swallowed error
- Production issues go undetected
- Even "expected" errors should be logged for monitoring
