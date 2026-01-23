## API standards (tRPC + Vertical Slice Architecture)

### Architecture Overview

Organize by feature using Vertical Slice Architecture. Each slice owns its entire stack: procedure, validation schemas, data access, and tests.

```
packages/api/src/
  features/
    invitations/
      create/
        create.procedure.ts
        create.schema.ts
        create.repository.ts
        create.test.ts
      accept/
        accept.procedure.ts
        accept.schema.ts
        accept.repository.ts
      list/
        ...
      router.ts              # Combines procedures into invitationsRouter
    members/
      ...
    organizations/
      ...
  shared/
    procedures.ts            # Base procedures (public, protected, org, admin)
    context.ts               # tRPC context creation
    errors.ts                # Domain-specific error classes
    middleware/              # Cross-cutting concerns
  router.ts                  # Root appRouter combining all feature routers
```

### Core Principles

**1. Colocation over abstraction**

Each slice is self-contained. Keep related code together. Extract to `shared/` when two or more slices need identical behavior and the abstraction is stable.

**2. One procedure per file**

Each tRPC procedure lives in its own file with a clear name matching the operation.

```typescript
// features/invitations/create/create.procedure.ts
import { adminProcedure } from "@/shared/procedures";

import { findExistingInvitation, insertInvitation } from "./create.repository";
import { createInvitationInput, createInvitationOutput } from "./create.schema";

export const createInvitation = adminProcedure
	.input(createInvitationInput)
	.output(createInvitationOutput)
	.mutation(async ({ ctx, input }) => {
		const existing = await findExistingInvitation(
			ctx.db,
			input.email,
			ctx.organizationId,
		);
		if (existing) {
			throw new InvitationExistsError(input.email);
		}

		const invitation = await insertInvitation(ctx.db, {
			...input,
			organizationId: ctx.organizationId,
			invitedById: ctx.session.user.id,
		});

		return invitation;
	});
```

**3. Schemas always extracted**

All Zod schemas live in `*.schema.ts` files, even simple ones. This enables reuse and keeps procedures focused on logic.

```typescript
// features/invitations/create/create.schema.ts
import { z } from "zod";

export const createInvitationInput = z.object({
	email: z.string().email(),
	role: z.enum(["MEMBER", "AGENT", "ADMIN"]).default("MEMBER"),
});

export const createInvitationOutput = z.object({
	id: z.string(),
	email: z.string(),
	role: z.string(),
	expiresAt: z.date(),
});

export type CreateInvitationInput = z.infer<typeof createInvitationInput>;
export type CreateInvitationOutput = z.infer<typeof createInvitationOutput>;
```

**4. Repository per slice, not per entity**

Each slice has its own repository containing only the queries that slice needs. Avoids god-object repositories with dozens of methods.

```typescript
// features/invitations/create/create.repository.ts
import { invitations } from "@pitboss/db/schema";

import type { Database } from "@/shared/db";

export async function insertInvitation(db: Database, data: NewInvitation) {
	const [invitation] = await db.insert(invitations).values(data).returning();
	return invitation;
}

export async function findExistingInvitation(
	db: Database,
	email: string,
	organizationId: string,
) {
	return db.query.invitations.findFirst({
		where: (inv, { and, eq }) =>
			and(
				eq(inv.email, email),
				eq(inv.organizationId, organizationId),
				eq(inv.status, "PENDING"),
			),
	});
}
```

**5. Feature router combines procedures**

Each feature has a `router.ts` that exports the combined router.

```typescript
// features/invitations/router.ts
import { router } from "@/shared/procedures";

import { acceptInvitation } from "./accept/accept.procedure";
import { createInvitation } from "./create/create.procedure";
import { getInvitationByToken } from "./get-by-token/get-by-token.procedure";
import { listInvitations } from "./list/list.procedure";
import { resendInvitation } from "./resend/resend.procedure";
import { revokeInvitation } from "./revoke/revoke.procedure";

export const invitationsRouter = router({
	create: createInvitation,
	list: listInvitations,
	accept: acceptInvitation,
	revoke: revokeInvitation,
	resend: resendInvitation,
	getByToken: getInvitationByToken,
});
```

**6. Root router in `router.ts`**

```typescript
// router.ts
import { invitationsRouter } from "./features/invitations/router";
import { membersRouter } from "./features/members/router";
import { organizationsRouter } from "./features/organizations/router";
import { router } from "./shared/procedures";

export const appRouter = router({
	invitations: invitationsRouter,
	members: membersRouter,
	organizations: organizationsRouter,
});

export type AppRouter = typeof appRouter;
```

### Procedure Hierarchy

Use the established procedure chain for authorization:

```
publicProcedure          # No auth required
    ↓
protectedProcedure       # Requires authenticated session
    ↓
organizationProcedure    # Requires org membership (X-Organization-Id header)
    ↓
adminProcedure           # Requires ADMIN, OWNER, or MASTER_CHIEF role
```

Choose the most restrictive procedure that fits the use case.

### Naming Conventions

**Procedures**: Use verbs that describe the action

- `create`, `list`, `get`, `update`, `delete`, `revoke`, `accept`, `resend`
- Avoid generic names like `handle` or `process`

**Files**: kebab-case matching the operation

- `create.procedure.ts`, `list.schema.ts`, `accept.repository.ts`

**Routers**: camelCase with `Router` suffix

- `invitationsRouter`, `membersRouter`

### Error Handling

Throw domain-specific errors. Use tRPC error codes for HTTP semantics.

```typescript
// shared/errors.ts
import { TRPCError } from "@trpc/server";

export class InvitationExistsError extends TRPCError {
	constructor(email: string) {
		super({
			code: "CONFLICT",
			message: `A pending invitation already exists for ${email}`,
		});
	}
}

export class InvitationNotFoundError extends TRPCError {
	constructor(id: string) {
		super({
			code: "NOT_FOUND",
			message: "Invitation not found",
		});
	}
}

export class InvitationExpiredError extends TRPCError {
	constructor() {
		super({
			code: "BAD_REQUEST",
			message: "Invitation has expired",
		});
	}
}
```

### Cross-Slice Communication

Slices should not import from other slices. Use events for cross-cutting behavior.

```typescript
// In procedure
await events.emit("invitation.created", { invitationId, organizationId });

// Subscriber in another slice or shared module handles the side effect
```

For background jobs, use Trigger.dev tasks:

```typescript
await tasks.trigger("send-invitation-email", {
	inviteId: invitation.id,
	invitedByName: ctx.session.user.name,
});
```

### Testing

Tests live with the slice. Test the procedure as a unit, mocking at the database boundary.

```typescript
// features/invitations/create/create.test.ts
import { describe, expect, it, vi } from "vitest";

import { createInvitation } from "./create.procedure";

describe("createInvitation", () => {
	it("creates invitation and triggers email", async () => {
		// Test setup and assertions
	});

	it("throws conflict error for existing invitation", async () => {
		// Test error case
	});
});
```

### Output Schemas

Always define `.output()` schemas for procedures. This provides:

- Runtime validation of responses
- Automatic TypeScript types for clients
- Documentation of the API contract

```typescript
export const listInvitation = adminProcedure
	.input(listInvitationsInput)
	.output(listInvitationsOutput) // Always include
	.query(async ({ ctx, input }) => {
		// ...
	});
```

### When to Share Code

Extract to `shared/` when:

1. Two or more slices need identical behavior
2. The abstraction is stable (unlikely to diverge per slice)
3. It's truly cross-cutting (auth, logging, error formatting)

Don't duplicate code. If you find yourself copying logic between slices, extract it to `shared/`.
