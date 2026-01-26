---
title: Don't Repeat Yourself (DRY)
impact: CRITICAL
tags: principles, duplication, refactoring
---

## Don't Repeat Yourself (DRY)

Extract common logic into reusable functions. If you're copying code, stop and refactor.

**Incorrect (duplicated logic):**

```typescript
// In user-service.ts
function formatUserDate(date: Date): string {
  return `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()}`;
}

// In order-service.ts (same logic duplicated)
function formatOrderDate(date: Date): string {
  return `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()}`;
}
```

**Correct (shared utility):**

```typescript
// In shared/utils/date.ts
export function formatDate(date: Date): string {
  return `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()}`;
}

// Used everywhere
import { formatDate } from '@/shared/utils/date';
```

**Why it matters:** Duplicated code means bugs must be fixed in multiple places. It increases maintenance burden and creates inconsistencies when one copy is updated but others are forgotten.
