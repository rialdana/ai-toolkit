## Performance standards

### Core Principle

**Measure before optimizing.** Don't guess at performance problems - profile and prove them first.

Premature optimization wastes time and often makes code harder to maintain without meaningful improvement.

### When to Optimize

1. **User experience is noticeably degraded** - Page loads > 3s, interactions feel sluggish
2. **You've measured the bottleneck** - Profiling shows a specific cause
3. **The fix is proportional** - Time spent optimizing is justified by improvement

### Database Performance

**Most performance issues are database issues.** Check there first.

#### Always Do (Best Practices)

These are not premature optimizations - they're baseline good practices:

**Index foreign keys:**

```typescript
(table) => [
  index("events_organization_id_idx").on(table.organizationId),
],
```

**Avoid N+1 queries:**

```typescript
// Bad - N+1
const events = await db.query.events.findMany();
for (const event of events) {
  event.staff = await db.query.eventStaff.findMany({
    where: eq(eventStaff.eventId, event.id)
  });
}

// Good - eager load
const events = await db.query.events.findMany({
  with: { staff: true },
});
```

**Use transactions for related mutations.**

#### Measure First

These optimizations matter for large tables or hot paths. Profile before applying:

**Select specific columns** (matters for wide tables or large result sets):

```typescript
// Consider for large tables
const users = await db.query.users.findMany({
	columns: { id: true, name: true, email: true },
});
```

**Add indexes for WHERE/ORDER BY columns** (profile queries first):

```typescript
index("events_start_date_idx").on(table.startDate),
```

**Use EXPLAIN ANALYZE** to identify slow queries:

```typescript
const plan = await db.execute(sql`
  EXPLAIN ANALYZE
  SELECT * FROM events
  WHERE organization_id = ${orgId}
`);
```

Look for sequential scans on large tables.

### Frontend Performance

**Bundle size:**

- Import only what you need from libraries
- Use dynamic imports for large components
- Check bundle size impact before adding dependencies

```typescript
// Good - tree-shakeable
import { Calendar, Clock } from "lucide-react";
// Bad - imports everything
import * as Icons from "lucide-react";
```

**React performance:**

Don't add `useMemo`/`useCallback`/`React.memo` by default. Only add them when:

1. You've measured a real performance problem
2. Profiling shows that specific component is the bottleneck
3. The optimization actually improves the metric

```typescript
// Usually unnecessary
const memoizedValue = useMemo(() => items.filter((x) => x.active), [items]);

// Just write it simply
const activeItems = items.filter((x) => x.active);
```

**Images:**

- Use appropriate sizes (don't load 4000px images for thumbnails)
- Use modern formats (WebP, AVIF)
- Lazy load images below the fold

### API Performance

**Pagination:**

```typescript
// Always paginate list endpoints
.input(z.object({
  limit: z.number().min(1).max(100).default(20),
  cursor: z.string().optional(),
}))
```

**Parallel requests:**

```typescript
// Good - parallel when independent
const [user, org] = await Promise.all([
  getUser(userId),
  getOrganization(orgId),
]);

// Bad - sequential when could be parallel
const user = await getUser(userId);
const org = await getOrganization(orgId);
```

**Caching:**
TanStack Query handles client-side caching. For server-side:

- Cache expensive computations
- Cache external API responses
- Use appropriate cache TTLs

### Background Jobs

Move slow operations to background jobs:

- Sending emails
- Generating reports
- Processing large data sets
- External API calls

```typescript
// Don't block the request waiting for the job to complete
export const createInvitation = adminProcedure.mutation(
	async ({ ctx, input }) => {
		const invitation = await insertInvitation(ctx.db, input);

		// Trigger returns immediately - job runs in background
		await tasks.trigger("send-invitation-email", {
			invitationId: invitation.id,
		});

		return invitation;
	},
);
```

### Measuring

**Chrome DevTools:**

- Network tab for request timing
- Performance tab for runtime profiling
- Lighthouse for overall metrics

**Database:**

- `EXPLAIN ANALYZE` for query plans
- Neon dashboard for query metrics

**React:**

- React DevTools Profiler
- Why Did You Render (development only)

### Red Flags

Investigate if you see:

- Page loads > 3 seconds
- API responses > 500ms
- Sequential queries that could be parallel
- Queries without indexes on filtered columns
- Full table scans on large tables
- Bundle size growing unexpectedly
