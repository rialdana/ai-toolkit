## Database query standards (Drizzle)

### Query Priority

**Correctness > Readability > Optimization**

1. First, ensure the query returns correct data
2. Then, make it readable and maintainable
3. Only optimize when the query is run frequently or traverses large datasets

### Repository Pattern

Queries live in `*.repository.ts` files within each feature slice:

```typescript
// features/invitations/list/list.repository.ts
import type { Database } from "@/shared/db";

export async function findPendingInvitations(
	db: Database,
	organizationId: string,
	options?: { search?: string },
) {
	return db.query.invitations.findMany({
		where: (inv, { and, eq }) =>
			and(eq(inv.organizationId, organizationId), eq(inv.status, "PENDING")),
		with: {
			invitedBy: {
				columns: { id: true, name: true },
			},
		},
		orderBy: (inv, { desc }) => [desc(inv.createdAt)],
	});
}
```

### Drizzle Query Patterns

**Prefer relational queries for reads with relations:**

```typescript
// Good - uses relational query API
const user = await db.query.users.findFirst({
	where: (u, { eq }) => eq(u.id, userId),
	with: {
		organizations: true,
	},
});

// Avoid - manual joins for simple relations
const result = await db
	.select()
	.from(users)
	.leftJoin(userOrganizations, eq(users.id, userOrganizations.userId))
	.where(eq(users.id, userId));
```

**Use query builder for complex queries:**

```typescript
// Complex aggregations, CTEs, or when you need more control
const result = await db
	.select({
		organizationId: events.organizationId,
		eventCount: count(events.id),
		totalRevenue: sum(events.revenue),
	})
	.from(events)
	.where(gte(events.createdAt, startDate))
	.groupBy(events.organizationId);
```

**Use raw SQL sparingly, for edge cases:**

```typescript
import { sql } from "drizzle-orm";

// Only when Drizzle doesn't support the operation
const result = await db.execute(sql`
  SELECT * FROM users 
  WHERE email ILIKE ${`%${search}%`}
`);
```

### Select Only What You Need

**Specify columns in relational queries:**

```typescript
// Good - explicit columns
const users = await db.query.users.findMany({
  columns: {
    id: true,
    email: true,
    name: true,
  },
});

// Avoid - fetches all columns
const users = await db.query.users.findMany();
```

**Limit related data columns:**

```typescript
const invitations = await db.query.invitations.findMany({
	with: {
		invitedBy: {
			columns: {
				id: true,
				name: true,
				// Don't include email, phone, etc. if not needed
			},
		},
	},
});
```

### Avoid N+1 Queries

**Use `with` for eager loading:**

```typescript
// Good - single query with join
const members = await db.query.userOrganizations.findMany({
	where: (uo, { eq }) => eq(uo.organizationId, orgId),
	with: {
		user: {
			columns: { id: true, name: true, email: true },
		},
	},
});

// Bad - N+1 queries
const memberships = await db.query.userOrganizations.findMany({
	where: (uo, { eq }) => eq(uo.organizationId, orgId),
});
for (const m of memberships) {
	const user = await db.query.users.findFirst({
		where: (u, { eq }) => eq(u.id, m.userId),
	});
}
```

### Filter Early, Aggregate Late

**Reduce the dataset before aggregating:**

```typescript
// Good - filter first
const activeEvents = await db
	.select({
		month: sql`date_trunc('month', ${events.startDate})`,
		count: count(events.id),
	})
	.from(events)
	.where(
		and(
			eq(events.organizationId, orgId),
			eq(events.status, "ACTIVE"),
			gte(events.startDate, startOfYear),
		),
	)
	.groupBy(sql`date_trunc('month', ${events.startDate})`);
```

### WHERE Clause Best Practices

**Avoid functions on indexed columns:**

```typescript
// Bad - prevents index usage
.where(sql`LOWER(${users.email}) = ${email.toLowerCase()}`)

// Good - store normalized, query directly
.where(eq(users.email, email.toLowerCase()))
```

**Prefer `eq` over `like` when possible:**

```typescript
// Good - exact match, uses index
.where(eq(users.status, "ACTIVE"))

// Use like only when pattern matching is needed
.where(like(users.email, `%@${domain}`))
```

**Avoid leading wildcards:**

```typescript
// Bad - forces full table scan
.where(like(users.name, `%${search}%`))

// Better - only trailing wildcard
.where(like(users.name, `${search}%`))

// Best for search - use proper full-text search
.where(sql`${users.name} ILIKE ${search + '%'}`)
```

**Prefer `exists` over `in` for subqueries:**

```typescript
// Good - exits early when found
.where(
  exists(
    db.select().from(userOrganizations)
      .where(and(
        eq(userOrganizations.userId, users.id),
        eq(userOrganizations.organizationId, orgId),
      ))
  )
)

// Slower for large subquery results
.where(
  inArray(
    users.id,
    db.select({ id: userOrganizations.userId })
      .from(userOrganizations)
      .where(eq(userOrganizations.organizationId, orgId))
  )
)
```

### Transactions

**Wrap related mutations in transactions:**

```typescript
await db.transaction(async (tx) => {
	// Create membership
	await tx.insert(userOrganizations).values({
		id: crypto.randomUUID(),
		userId: session.user.id,
		organizationId: invitation.organizationId,
		role: invitation.role,
	});

	// Mark invitation as accepted
	await tx
		.update(invitations)
		.set({ status: "ACCEPTED", acceptedAt: new Date() })
		.where(eq(invitations.id, invitationId));
});
```

**Keep transactions short:**

- Don't include API calls or slow operations inside transactions
- Fetch data before the transaction, mutate inside it

### Sorting

**Avoid unnecessary sorting, especially in subqueries:**

```typescript
// Only sort at the final result level
const results = await db.query.events.findMany({
	where: (e, { eq }) => eq(e.organizationId, orgId),
	orderBy: (e, { desc }) => [desc(e.startDate)], // Sort here, not in subqueries
	limit: 20,
});
```

**Use indexed columns for sorting when possible.**

### Common Table Expressions (CTEs)

**Use CTEs for complex queries:**

```typescript
import { sql } from "drizzle-orm";

const result = await db.execute(sql`
  WITH active_members AS (
    SELECT user_id, organization_id, role
    FROM user_organizations
    WHERE active = true
  ),
  member_event_counts AS (
    SELECT 
      am.user_id,
      COUNT(e.id) as event_count
    FROM active_members am
    LEFT JOIN event_staff es ON es.user_id = am.user_id
    LEFT JOIN events e ON e.id = es.event_id
    WHERE e.organization_id = ${orgId}
    GROUP BY am.user_id
  )
  SELECT 
    u.id,
    u.name,
    mec.event_count
  FROM users u
  JOIN member_event_counts mec ON mec.user_id = u.id
  ORDER BY mec.event_count DESC
`);
```

### UNION

**Prefer `UNION ALL` when duplicates are acceptable:**

```typescript
// UNION ALL is faster - no deduplication
const allNotifications = await db.execute(sql`
  SELECT id, message, created_at FROM email_notifications
  WHERE user_id = ${userId}
  UNION ALL
  SELECT id, message, created_at FROM sms_notifications  
  WHERE user_id = ${userId}
  ORDER BY created_at DESC
`);
```

### Performance Debugging

**Use EXPLAIN ANALYZE for slow queries:**

```typescript
// In development, prefix your raw SQL with EXPLAIN ANALYZE
const plan = await db.execute(sql`
  EXPLAIN ANALYZE
  SELECT * FROM events
  WHERE organization_id = ${orgId}
  AND start_date > ${startDate}
`);
console.log(plan);
```

Look for:

- Sequential scans on large tables (consider adding an index)
- Nested loops with high row counts
- Sort operations on unindexed columns

### Multi-Tenant Queries

**Always scope queries to the organization:**

```typescript
// Every org-scoped query must include organizationId filter
export async function findEvents(db: Database, organizationId: string) {
	return db.query.events.findMany({
		where: (e, { eq }) => eq(e.organizationId, organizationId),
		// ...
	});
}
```

The `organizationProcedure` middleware provides `ctx.organizationId` - use it in every repository function for tenant data.

### Query Comments

**Document the "why" for complex queries:**

```typescript
export async function findEligibleStaff(db: Database, eventId: string) {
	return db.query.users.findMany({
		where: (u, { and, eq, notExists }) =>
			and(
				eq(u.active, true),
				// Exclude users already assigned to this event
				notExists(
					db
						.select()
						.from(eventStaff)
						.where(
							and(eq(eventStaff.eventId, eventId), eq(eventStaff.userId, u.id)),
						),
				),
			),
	});
}
```
