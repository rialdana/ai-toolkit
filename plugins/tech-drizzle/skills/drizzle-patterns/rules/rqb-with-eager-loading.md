---
title: Use 'with' for Eager Loading
impact: HIGH
tags: query, relations, n-plus-one
---

## Use 'with' for Eager Loading

Use the `with` clause to eagerly load relations in a single query. This prevents N+1 queries.

**Incorrect (N+1 queries):**

```typescript
// Bad - N+1: one query per member
const memberships = await db.query.userOrganizations.findMany({
  where: (uo, { eq }) => eq(uo.organizationId, orgId),
});

// Then fetch each user separately (N more queries!)
for (const m of memberships) {
  const user = await db.query.users.findFirst({
    where: (u, { eq }) => eq(u.id, m.userId),
  });
}
```

**Correct (eager loading with 'with'):**

```typescript
// Good - single query with JOIN
const members = await db.query.userOrganizations.findMany({
  where: (uo, { eq }) => eq(uo.organizationId, orgId),
  with: {
    user: {
      columns: {
        id: true,
        name: true,
        email: true,
        // Don't include passwordHash!
      },
    },
  },
});

// members[0].user is already populated
```

**Limit columns in related tables:**

```typescript
// Good - select only needed columns from relations
const invitations = await db.query.invitations.findMany({
  where: (inv, { eq }) => eq(inv.organizationId, orgId),
  with: {
    invitedBy: {
      columns: {
        id: true,
        name: true,
        // Exclude: email, passwordHash, etc.
      },
    },
  },
});
```

**Why it matters:**
- N+1 queries scale linearly with data
- 100 members = 101 queries without eager loading
- Network round-trips dominate query time
- Database connection pool exhaustion

Reference: [Drizzle with clause](https://orm.drizzle.team/docs/rqb#include-relations)
