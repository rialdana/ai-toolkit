## Error handling standards

### tRPC Errors

Use `TRPCError` with appropriate codes. Define domain-specific error classes:

```typescript
// shared/errors.ts
import { TRPCError } from "@trpc/server";

export class NotFoundError extends TRPCError {
	constructor(resource: string, id: string) {
		super({
			code: "NOT_FOUND",
			message: `${resource} not found: ${id}`,
		});
	}
}

export class ForbiddenError extends TRPCError {
	constructor(message = "You don't have permission to perform this action") {
		super({ code: "FORBIDDEN", message });
	}
}

export class ConflictError extends TRPCError {
	constructor(message: string) {
		super({ code: "CONFLICT", message });
	}
}
```

**Common tRPC error codes:**

- `BAD_REQUEST` - Invalid input (though Zod handles most of this)
- `UNAUTHORIZED` - Not logged in
- `FORBIDDEN` - Logged in but not permitted
- `NOT_FOUND` - Resource doesn't exist
- `CONFLICT` - Resource already exists, duplicate, etc.
- `INTERNAL_SERVER_ERROR` - Unexpected errors

### Throwing Errors

Throw early, throw specific:

```typescript
export const getEvent = organizationProcedure
	.input(z.object({ id: z.string() }))
	.query(async ({ ctx, input }) => {
		const event = await findEventById(ctx.db, input.id, ctx.organizationId);

		if (!event) {
			throw new NotFoundError("Event", input.id);
		}

		return event;
	});
```

### Client-Side Error Handling

Use Sonner for user-facing errors:

```typescript
import { toast } from "sonner";

const mutation = trpc.events.create.useMutation({
	onSuccess: () => {
		toast.success("Event created");
	},
	onError: (error) => {
		toast.error(error.message);
	},
});
```

For expected errors, provide helpful messages:

```typescript
onError: (error) => {
	if (error.data?.code === "CONFLICT") {
		toast.error("An event with this name already exists");
	} else {
		toast.error("Something went wrong. Please try again.");
	}
};
```

### Don't Catch and Ignore

```typescript
// Bad - swallows errors silently
try {
	await riskyOperation();
} catch (e) {
	// do nothing
}

// Good - handle or rethrow
try {
	await riskyOperation();
} catch (e) {
	console.error("Operation failed:", e);
	throw e; // or handle appropriately
}
```

### Async Error Boundaries

For background jobs (Trigger.dev), let errors bubble up so they can be retried:

```typescript
export const sendInvitationEmail = task({
	id: "send-invitation-email",
	run: async ({ invitationId }) => {
		const invitation = await getInvitation(invitationId);

		if (!invitation) {
			// Don't retry - invitation doesn't exist
			throw new Error(`Invitation not found: ${invitationId}`);
		}

		// This might fail transiently - Trigger.dev will retry
		await resend.emails.send({
			/* ... */
		});
	},
});
```

### User-Facing vs Technical Errors

**User-facing**: Clear, actionable, no technical details.

```typescript
// Good
"Email address is already in use";
"Event date must be in the future";
"You don't have permission to delete this event";

// Bad
"UNIQUE constraint failed: users.email";
"TypeError: Cannot read property 'id' of undefined";
```

**Logging**: Include technical details for debugging (see logging.md).

### Don't Expose Internals

Never expose:

- Stack traces
- Database errors
- Internal IDs or paths
- Configuration details

```typescript
// Bad - leaks internals
throw new TRPCError({
	code: "INTERNAL_SERVER_ERROR",
	message: `Database error: ${dbError.message}`,
});

// Good - generic message, log details
console.error("Database error:", dbError);
throw new TRPCError({
	code: "INTERNAL_SERVER_ERROR",
	message: "An unexpected error occurred",
});
```
