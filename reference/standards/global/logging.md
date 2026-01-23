## Logging standards

### When to Log

**Do log:**

- Errors and exceptions
- Important business events (user signup, payment processed, invitation accepted)
- External service interactions (API calls, email sends)
- Security-relevant events (login attempts, permission denials)

**Don't log:**

- Sensitive data (passwords, tokens, PII)
- Every request (use metrics/tracing instead)
- Debug statements in production
- Success cases for routine operations

### Log Levels

```typescript
// Error - Something failed, needs attention
console.error("Payment failed:", { userId, error: error.message });

// Warn - Unexpected but handled
console.warn("Rate limit approached:", { userId, requestCount });

// Info - Important business events
console.info("User signed up:", { userId, plan });

// Debug - Development only
console.debug("Query result:", result);
```

### Structured Logging

Log objects, not string concatenation:

```typescript
// Good - structured, queryable
console.error("Invitation send failed", {
	invitationId,
	email: invitation.email,
	error: error.message,
	organizationId,
});

// Bad - string concatenation
console.error(
	`Failed to send invitation ${invitationId} to ${email}: ${error}`,
);
```

### What to Include

**Context that helps debugging:**

```typescript
console.error("Operation failed", {
	// What failed
	operation: "createInvitation",
	error: error.message,

	// Context
	userId: ctx.session.user.id,
	organizationId: ctx.organizationId,

	// Input (sanitized)
	email: input.email,
	role: input.role,
});
```

**Never include:**

```typescript
// Bad - sensitive data
console.log({
	password: input.password,
	token: invitation.token,
	creditCard: paymentMethod.cardNumber,
	sessionToken: ctx.session.token,
});
```

### Error Logging

Log the error, but don't expose it to users:

```typescript
export const createInvitation = adminProcedure
	.input(createInvitationInput)
	.mutation(async ({ ctx, input }) => {
		try {
			return await insertInvitation(ctx.db, input);
		} catch (error) {
			// Log full error for debugging
			console.error("Failed to create invitation", {
				error: error instanceof Error ? error.message : error,
				stack: error instanceof Error ? error.stack : undefined,
				input: { email: input.email, role: input.role },
				userId: ctx.session.user.id,
				organizationId: ctx.organizationId,
			});

			// Throw generic error to user
			throw new TRPCError({
				code: "INTERNAL_SERVER_ERROR",
				message: "Failed to create invitation",
			});
		}
	});
```

### Background Jobs

Log job progress for debugging:

```typescript
export const sendInvitationEmail = task({
	id: "send-invitation-email",
	run: async ({ invitationId }) => {
		console.info("Starting invitation email task", { invitationId });

		const invitation = await getInvitation(invitationId);
		if (!invitation) {
			console.error("Invitation not found", { invitationId });
			throw new Error(`Invitation not found: ${invitationId}`);
		}

		await resend.emails.send({
			/* ... */
		});

		console.info("Invitation email sent", {
			invitationId,
			email: invitation.email,
		});
	},
});
```

### Production Logging

In production, logs go to Railway's logging. Use Sentry for error tracking.

**How console and Sentry work together:**

- Use `console.error()` for all error logging - these go to Railway logs
- Sentry auto-captures unhandled exceptions
- Add Sentry context for better debugging, but don't manually call `Sentry.captureException()` unless adding extra context beyond what auto-capture provides

```typescript
// Add context that Sentry will include in captured errors
Sentry.setUser({ id: userId, email: userEmail });
Sentry.setTag("organization", organizationId);

// In error handlers, log to console (goes to Railway)
// Sentry captures unhandled errors automatically
console.error("Payment failed", { userId, error: error.message });
```

### Development vs Production

```typescript
// Only log verbose output in development
if (process.env.NODE_ENV === "development") {
	console.debug("Query:", query);
}
```

Or use a proper logging library that respects log levels per environment.

### Request Logging

Don't log every request body. Use request IDs for tracing:

```typescript
// Middleware adds request ID
app.use((c, next) => {
	const requestId = crypto.randomUUID();
	c.set("requestId", requestId);
	return next();
});

// Include in error logs
console.error("Request failed", {
	requestId: c.get("requestId"),
	error: error.message,
});
```
