## Validation standards

### Zod Everywhere

Use Zod for all validation. Single source of truth for types and runtime validation.

### tRPC Input Validation

Validation happens automatically via `.input()`:

```typescript
export const createEvent = organizationProcedure
	.input(
		z.object({
			name: z.string().min(1, "Name is required").max(100),
			startDate: z.coerce.date(),
			endDate: z.coerce.date(),
		}),
	)
	.mutation(async ({ ctx, input }) => {
		// input is already validated and typed
	});
```

tRPC returns `BAD_REQUEST` with field-specific errors automatically.

### Schema Organization

For VSA, schemas live with their slice:

```typescript
// features/events/create/create.schema.ts
import { z } from "zod";

export const createEventInput = z
	.object({
		name: z.string().min(1, "Name is required").max(100),
		startDate: z.coerce.date(),
		endDate: z.coerce.date(),
	})
	.refine((data) => data.endDate > data.startDate, {
		message: "End date must be after start date",
		path: ["endDate"],
	});

export type CreateEventInput = z.infer<typeof createEventInput>;
```

### Form Validation

TanStack Form integrates with Zod:

```typescript
const form = useForm({
	defaultValues: { name: "", startDate: "", endDate: "" },
	validators: {
		onSubmit: createEventInput,
	},
	onSubmit: async ({ value }) => {
		await createEvent.mutateAsync(value);
	},
});
```

### Common Patterns

**Strings:**

```typescript
z.string().min(1); // Required
z.string().email(); // Email format
z.string().url(); // URL format
z.string().uuid(); // UUID format
z.string().max(100); // Max length
z.string().trim(); // Trim whitespace
```

**Numbers:**

```typescript
z.number().positive(); // > 0
z.number().nonnegative(); // >= 0
z.number().int(); // Integer only
z.number().min(0).max(100); // Range
```

**Dates:**

```typescript
z.coerce.date(); // Parse string to Date
z.date().min(new Date()); // Future dates only
```

**Enums:**

```typescript
z.enum(["PENDING", "ACTIVE", "CANCELLED"]);
```

**Optional/Nullable:**

```typescript
z.string().optional(); // string | undefined
z.string().nullable(); // string | null
z.string().nullish(); // string | null | undefined
```

**Defaults:**

```typescript
z.string().default("");
z.enum(["MEMBER", "ADMIN"]).default("MEMBER");
```

### Cross-Field Validation

Use `.refine()` or `.superRefine()`:

```typescript
const dateRangeSchema = z
	.object({
		startDate: z.coerce.date(),
		endDate: z.coerce.date(),
	})
	.refine((data) => data.endDate > data.startDate, {
		message: "End date must be after start date",
		path: ["endDate"],
	});
```

### Business Rule Validation

Validate business rules in the procedure, not the schema:

```typescript
export const createInvitation = adminProcedure
	.input(createInvitationInput)
	.mutation(async ({ ctx, input }) => {
		// Schema validates format, procedure validates business rules
		const existingInvitation = await findPendingInvitation(
			ctx.db,
			input.email,
			ctx.organizationId,
		);

		if (existingInvitation) {
			throw new ConflictError(
				"A pending invitation already exists for this email",
			);
		}

		// ...
	});
```

### Output Validation

Always define `.output()` schemas for procedures:

```typescript
export const getEvent = organizationProcedure
	.input(z.object({ id: z.string() }))
	.output(eventSchema)
	.query(async ({ ctx, input }) => {
		// Response is validated against eventSchema
	});
```

### Error Messages

Write helpful, user-facing messages:

```typescript
// Good
z.string().email("Please enter a valid email address");
z.string().min(8, "Password must be at least 8 characters");
z.number().positive("Amount must be greater than zero");

// Bad (default messages)
z.string().email(); // "Invalid email"
z.string().min(8); // "String must contain at least 8 character(s)"
```

### Don't Validate Twice

- Schema handles format/type validation
- Procedure handles business rules
- Don't duplicate between them

```typescript
// Bad - duplicated
.input(z.object({
  email: z.string().email(),
}))
.mutation(async ({ input }) => {
  if (!input.email.includes("@")) {  // Already validated!
    throw new Error("Invalid email");
  }
});
```
