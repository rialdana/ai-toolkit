---
title: Right-Sized Functions
impact: HIGH
tags: functions, design, modularity
---

## Right-Sized Functions

Size is not the metric. Don't aim for arbitrary line counts. Instead, consider comprehension and coupling.

**Signs a function is too big:**

- You can't understand what it does without intense focus
- You can't predict what changes might break
- Variables are only used in a small scope within the function

**Signs a function is too small:**

- You're jumping between files constantly to follow logic
- The abstraction adds no value (just moves code)
- Single-line wrapper functions that add nothing

**Incorrect (too big):**

```typescript
async function handleOrder(order: Order) {
  // 200 lines of validation, pricing, inventory check,
  // payment processing, email sending, logging...
}
```

**Incorrect (too small / over-extracted):**

```typescript
function add(a: number, b: number) { return a + b; }
function multiply(a: number, b: number) { return a * b; }
function calculateSubtotal(price: number, qty: number) {
  return multiply(price, qty);
}
function calculateTax(subtotal: number, rate: number) {
  return multiply(subtotal, rate);
}
// Now follow 10 files to understand pricing...
```

**Correct (balanced):**

```typescript
function calculateOrderTotal(items: OrderItem[], taxRate: number): number {
  const subtotal = items.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );
  const tax = subtotal * taxRate;
  return subtotal + tax;
}
```

**Why it matters:** Err on the side of smaller - small functions are easy to combine. Untangling a massive function is hard. Functions tend to grow over time, so start small.

Reference: [John Carmack on Inlined Code](http://number-none.com/blow/blog/programming/2014/09/26/carmack-on-inlined-code.html)
