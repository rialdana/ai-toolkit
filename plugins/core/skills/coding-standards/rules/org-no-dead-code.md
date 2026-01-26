---
title: Delete Dead Code
impact: MEDIUM
tags: organization, maintenance, cleanup
---

## Delete Dead Code

Delete unused code, commented-out blocks, and unused imports. Version control is your backup.

**Incorrect:**

```typescript
function processOrder(order: Order) {
  // Old implementation - keeping for reference
  // const total = order.items.reduce((sum, item) => {
  //   return sum + item.price * item.quantity;
  // }, 0);

  const total = calculateTotal(order.items);

  // TODO: Might need this later
  // const discount = applyDiscount(total, order.coupon);

  return total;
}

// Unused function, "might need it"
function legacyOrderProcessor(order: Order) { ... }
```

**Correct:**

```typescript
function processOrder(order: Order) {
  return calculateTotal(order.items);
}

// If you need the old code, git has it:
// git log -p --all -S 'legacyOrderProcessor'
```

**Why it matters:** Dead code is noise that obscures real code. It raises questions ("is this used?", "why is it commented?") and slows down comprehension.
