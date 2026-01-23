---
title: Never Swallow Errors
impact: MEDIUM-HIGH
tags: errors, debugging, reliability
---

## Never Swallow Errors

Empty catch blocks hide problems. Either handle the error meaningfully or let it propagate.

**Incorrect:**

```typescript
// Silent failure - impossible to debug
try {
  await saveUser(user);
} catch {
  // 🦗 crickets
}

// Logging isn't handling
try {
  await processPayment(order);
} catch (error) {
  console.log(error); // Then what? Payment silently failed?
}
```

**Correct:**

```typescript
// Handle with recovery
try {
  await saveUser(user);
} catch (error) {
  await saveToBackupStore(user);
  notifyOpsTeam('Primary store failed, using backup');
}

// Handle with user feedback
try {
  await processPayment(order);
} catch (error) {
  logger.error('Payment failed', { orderId: order.id, error });
  throw new PaymentError('Payment processing failed', { cause: error });
}

// Let it propagate if you can't handle it
async function saveUser(user: User) {
  // No try/catch - let caller decide how to handle
  await db.users.insert(user);
}
```

**Why it matters:** Swallowed errors make systems unreliable and nearly impossible to debug. Silent failures are worse than loud failures.
