---
title: Use Named Exports, Not Default Exports
impact: LOW
tags: organization, imports, consistency
---

## Use Named Exports, Not Default Exports

Prefer named exports over default exports for consistency and better tooling support.

**Incorrect (default exports):**

```typescript
// button.tsx
export default function Button() { }

// Usage - can be named anything
import Btn from './button';
import MyButton from './button';
import Button from './button';
// Same component, different names across codebase
```

**Correct (named exports):**

```typescript
// button.tsx
export function Button() { }

// Usage - consistent name everywhere
import { Button } from './button';
// Always "Button", can't accidentally rename
```

**Benefits of named exports:**

- Consistent naming across codebase
- Better IDE auto-import suggestions
- Explicit about what's exported
- Easier refactoring (rename symbol works)
- Can export multiple things cleanly

**When default exports are acceptable:**

- Pages/routes (many routers expect them)
- Dynamic imports in specific frameworks
- Following a library's convention

**Why it matters:**
- `grep "Button"` finds all usages
- Renaming is IDE-assisted across files
- No confusion about what a file exports
- Team consistency without bikeshedding
