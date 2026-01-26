## Security standards

### Authentication

Better-Auth handles authentication. Key practices:

**Always use the procedure hierarchy:**

```
publicProcedure          → No auth required
protectedProcedure       → Requires valid session
organizationProcedure    → Requires org membership
adminProcedure           → Requires admin role
```

**Never bypass auth checks:**

```typescript
// Bad - direct DB access without auth
app.get("/users/:id", async (req, res) => {
  const user = await db.query.users.findFirst({ where: ... });
  res.json(user);
});

// Good - uses tRPC procedure with auth
export const getUser = protectedProcedure
  .input(z.object({ id: z.string() }))
  .query(async ({ ctx, input }) => {
    // ctx.session is guaranteed to exist
  });
```

### Multi-Tenancy

Pitboss is multi-tenant. **Every org-scoped query must filter by organizationId.**

```typescript
// Good - always filter by org
export const listEvents = organizationProcedure
  .query(async ({ ctx }) => {
    return db.query.events.findMany({
      where: (e, { eq }) => eq(e.organizationId, ctx.organizationId),
    });
  });

// DANGEROUS - no org filter
export const listEvents = protectedProcedure
  .query(async ({ ctx }) => {
    return db.query.events.findMany(); // Returns ALL events!
  });
```

The `organizationProcedure` middleware provides `ctx.organizationId`. Use it.

### Secrets Management

**Never commit secrets:**

- API keys
- Database URLs
- Auth secrets
- Encryption keys

**Use environment variables:**

```bash
# .env.local (git-ignored)
DATABASE_URL=postgres://...
BETTER_AUTH_SECRET=...
STRIPE_SECRET_KEY=...
RESEND_API_KEY=...
```

**Never log secrets:**

```typescript
// Bad
console.log("Connecting with:", process.env.DATABASE_URL);

// Good
console.log("Connecting to database...");
```

### Input Validation

Zod + tRPC handles input validation at the API boundary. This prevents:

- SQL injection (parameterized queries via Drizzle)
- Type coercion attacks
- Malformed data

**Always define strict schemas:**

```typescript
// Good - explicit types and constraints
.input(z.object({
  email: z.string().email(),
  role: z.enum(["MEMBER", "ADMIN"]),
  amount: z.number().positive().max(10000),
}))

// Bad - too permissive
.input(z.object({
  data: z.any(),
}))
```

### Authorization

Authentication ≠ Authorization.

- **Authentication**: Who are you? (Better-Auth)
- **Authorization**: What can you do? (Your code)

**Check permissions explicitly:**

```typescript
export const deleteEvent = organizationProcedure
	.input(z.object({ id: z.string() }))
	.mutation(async ({ ctx, input }) => {
		const event = await findEvent(ctx.db, input.id, ctx.organizationId);

		if (!event) {
			throw new NotFoundError("Event", input.id);
		}

		// Authorization check
		if (
			event.createdById !== ctx.session.user.id &&
			ctx.member.role !== "ADMIN"
		) {
			throw new ForbiddenError(
				"Only the creator or admin can delete this event",
			);
		}

		await deleteEvent(ctx.db, input.id);
	});
```

### Rate Limiting

Implement rate limiting for:

- Login attempts
- Password reset requests
- API endpoints (especially public ones)

Consider using middleware or a service like Upstash for rate limiting.

### Sensitive Data

**Don't expose sensitive fields:**

```typescript
// Bad - returns everything including password hash
return db.query.users.findFirst({ where: ... });

// Good - select specific columns
return db.query.users.findFirst({
  where: ...,
  columns: {
    id: true,
    email: true,
    name: true,
    // NOT: passwordHash, NOT: resetToken
  },
});
```

**Don't log sensitive data:**

```typescript
// Bad
console.log("User data:", user);

// Good
console.log("Processing user:", user.id);
```

### HTTPS

Always use HTTPS in production. Railway handles TLS termination.

### CORS

Configure CORS to allow only your domains:

```typescript
// In Hono setup
app.use(
	cors({
		origin: ["https://pitboss.app", "https://app.pitboss.app"],
		credentials: true,
	}),
);
```

### Error Messages

Don't leak information in error messages:

```typescript
// Bad - reveals user existence
if (!user) throw new Error("User not found");
if (!passwordMatch) throw new Error("Incorrect password");

// Good - generic message
if (!user || !passwordMatch) {
	throw new Error("Invalid email or password");
}
```

### Dependencies

- Keep dependencies updated (`pnpm outdated`)
- Review new dependencies before adding
- Prefer well-maintained packages with security track records
- Run `pnpm audit` periodically

### Checklist

Before deploying:

- [ ] All secrets are in environment variables
- [ ] No secrets in code or logs
- [ ] All org-scoped queries filter by organizationId
- [ ] Sensitive endpoints have appropriate auth checks
- [ ] User input is validated with Zod
- [ ] Sensitive data is not exposed in responses
- [ ] Error messages don't leak information
