## Database schema standards (Drizzle)

### File Organization

```
packages/db/src/
  schema/
    index.ts           # Re-exports all tables and relations
    users.ts           # One table per file
    organizations.ts
    invitations.ts
    relations.ts       # All relations in one file (avoids circular imports)
  index.ts             # DB client export
```

**Export order in `schema/index.ts` matters:**

1. Base tables with no dependencies first
2. Tables with foreign keys after their dependencies
3. Relations last

```typescript
// schema/index.ts
export * from "./users"; // Base table
export * from "./organizations"; // Depends on users
export * from "./user-organizations"; // Depends on both
export * from "./invitations";
export * from "./auth";
export * from "./relations"; // Must be last
```

### Table Definition

**Structure:**

```typescript
import { sql } from "drizzle-orm";
import { index, pgTable, text, timestamp, varchar } from "drizzle-orm/pg-core";

/**
 * Table description explaining the domain concept.
 * Include any non-obvious business rules.
 */
export const tableName = pgTable(
	"table_name", // Use snake_case for Postgres
	{
		// Columns
	},
	(table) => [
		// Indexes
	],
);

export type TableName = typeof tableName.$inferSelect;
export type NewTableName = typeof tableName.$inferInsert;
```

**Naming conventions:**

- Table variable: camelCase plural (`users`, `organizations`)
- SQL table name: snake_case (`user_organizations`)
- Column variable: camelCase (`firstName`)
- SQL column name: snake_case (`first_name`)

### Required Columns

Every table should have:

```typescript
{
  id: text("id").primaryKey(),
  createdAt: timestamp("created_at", { withTimezone: true })
    .notNull()
    .defaultNow(),
  updatedAt: timestamp("updated_at", { withTimezone: true })
    .notNull()
    .defaultNow()
    .$onUpdate(() => sql`now()`),
}
```

**ID strategy:** Use text IDs with `crypto.randomUUID()` or nanoid. Better-Auth compatibility requires text, not UUID type.

### Column Types

**Prefer specific types:**

```typescript
// Good
email: varchar("email", { length: 255 }).notNull().unique(),
name: varchar("name", { length: 100 }).notNull(),
status: text("status").notNull().default("pending"),

// Avoid unbounded text for known-length fields
email: text("email"),  // Less explicit
```

**Timestamps always with timezone:**

```typescript
timestamp("created_at", { withTimezone: true });
```

**Booleans with explicit defaults:**

```typescript
active: boolean("active").notNull().default(true),
banned: boolean("banned").default(false),  // Nullable OK if tri-state needed
```

### Foreign Keys

Define inline with `references()`:

```typescript
ownerId: text("owner_id")
  .notNull()
  .references(() => users.id, { onDelete: "restrict" }),
```

**Cascade behaviors:**

- `restrict` - Prevent delete if referenced (default, safest)
- `cascade` - Delete children when parent deleted (use sparingly)
- `set null` - Nullify reference on delete (requires nullable column)

**Always index foreign keys:**

```typescript
(table) => [
  index("organizations_owner_id_idx").on(table.ownerId),
],
```

### Indexes

Define in the table's index function:

```typescript
export const users = pgTable(
	"user",
	{
		/* columns */
	},
	(table) => [
		index("user_email_idx").on(table.email),
		index("user_org_active_idx").on(table.organizationId, table.active),
	],
);
```

**Index naming:** `{table}_{column(s)}_{idx|unique}`

**When to add indexes:**

- Foreign key columns (always)
- Columns used in WHERE clauses frequently
- Columns used for sorting
- Unique constraints that need enforcement

### Relations

All relations go in `relations.ts`:

```typescript
import { relations } from "drizzle-orm";

import { organizations } from "./organizations";
import { users } from "./users";

export const usersRelations = relations(users, ({ many }) => ({
	sessions: many(session),
	organizations: many(userOrganizations),
}));

export const organizationsRelations = relations(
	organizations,
	({ one, many }) => ({
		owner: one(users, {
			fields: [organizations.ownerId],
			references: [users.id],
		}),
		members: many(userOrganizations),
	}),
);
```

**Relation naming:**

- `one()` - singular noun (`owner`, `organization`)
- `many()` - plural noun (`members`, `invitations`)

### Type Exports

Export inferred types for each table:

```typescript
export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
```

Use `NewUser` for inserts, `User` for selects and updates.

### Documentation

Add JSDoc to tables explaining:

- What the entity represents
- Non-obvious business rules
- Important constraints or behaviors

```typescript
/**
 * Organizations table
 *
 * Represents a company using Pitboss. Each organization has
 * one owner and multiple members via user_organizations.
 *
 * Trial: New orgs get 14-day trial. null trialEndsAt = no trial.
 */
export const organizations = pgTable(/* ... */);
```

### Multi-Tenant Patterns

For organization-scoped tables:

```typescript
export const events = pgTable(
	"events",
	{
		id: text("id").primaryKey(),
		organizationId: text("organization_id")
			.notNull()
			.references(() => organizations.id, { onDelete: "cascade" }),
		// ... other columns
	},
	(table) => [index("events_organization_id_idx").on(table.organizationId)],
);
```

**Always filter by `organizationId`** in queries for tenant data. The `organizationProcedure` middleware provides this context.
