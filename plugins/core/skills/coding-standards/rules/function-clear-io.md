---
title: Clear Inputs and Outputs
impact: HIGH
tags: functions, design, readability
---

## Clear Inputs and Outputs

A good function has obvious inputs (parameters) and outputs (return value). It reads top to bottom without jumping around.

**Incorrect (unclear contract):**

```typescript
// What does this return? What can options contain?
function processData(data, options?) {
  // 50 lines later...
  return result;
}

// Relies on external state
let lastResult;
function calculate(value) {
  lastResult = value * multiplier; // Where is multiplier from?
  return lastResult;
}
```

**Correct (explicit contract):**

```typescript
interface ProcessOptions {
  format: 'json' | 'csv';
  includeMetadata: boolean;
}

function processData(
  data: RawData,
  options: ProcessOptions
): ProcessedResult {
  // Clear what goes in, clear what comes out
  return { ... };
}

function calculate(value: number, multiplier: number): number {
  return value * multiplier;
}
```

**Why it matters:** Functions with unclear contracts require reading the implementation to understand usage. This multiplies the time needed to work with the codebase.
