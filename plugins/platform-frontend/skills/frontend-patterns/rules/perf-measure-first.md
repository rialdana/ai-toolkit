---
title: Measure Before Optimizing
impact: MEDIUM
tags: performance, optimization, profiling
---

## Measure Before Optimizing

Don't add optimization techniques preemptively. Measure actual performance, identify bottlenecks, then optimize.

**Incorrect (premature optimization):**

```typescript
// Bad - memoizing everything "just in case"
function UserList({ users }) {
  // Unnecessary memo - simple array map is fast
  const sortedUsers = useMemo(
    () => users.sort((a, b) => a.name.localeCompare(b.name)),
    [users]
  );

  // Unnecessary callback - parent doesn't re-render often
  const handleClick = useCallback(
    (id) => selectUser(id),
    [selectUser]
  );

  // Unnecessary memo - component is simple
  return useMemo(
    () => sortedUsers.map(u => <UserCard key={u.id} user={u} />),
    [sortedUsers]
  );
}
```

**Correct (optimize when needed):**

```typescript
// Good - simple first
function UserList({ users }) {
  const sortedUsers = users.sort((a, b) =>
    a.name.localeCompare(b.name)
  );

  return sortedUsers.map(user => (
    <UserCard key={user.id} user={user} />
  ));
}

// Later, IF profiling shows this is slow:
// 1. Check if parent re-renders too often
// 2. Check if sort is actually expensive (1000+ items?)
// 3. Add memoization only for proven bottlenecks
```

**When to optimize:**

1. You've measured a real performance problem
2. Profiling identifies this specific code as the cause
3. The optimization actually improves metrics

**Common false optimizations:**

- Memoizing simple computations (faster to recompute)
- useCallback without memo on child components
- Virtualizing lists under 100 items

**Why it matters:**
- Premature optimization adds complexity
- Can actually hurt performance (memo overhead)
- Time spent optimizing non-problems
- Makes code harder to read and maintain
