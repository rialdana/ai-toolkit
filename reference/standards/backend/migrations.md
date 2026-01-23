## Database migration standards (Drizzle + Neon)

### Workflow

**Local development:**

```bash
# Iterate rapidly with push (no migration files)
pnpm db:push

# When ready to commit, generate migration
pnpm db:generate
```

**Production deployment:**

```bash
# Run pending migrations
pnpm db:migrate
```

### Core Principles

**1. Push locally, generate before commit**

Use `db:push` during development for fast iteration. Generate migration files only when the schema change is complete and ready to commit. This keeps the migration history clean and intentional.

**2. One logical change per migration**

Each migration should represent a single, coherent schema change. Don't bundle unrelated changes.

```
# Good
0001_add_invitations_table.sql
0002_add_user_avatar_column.sql

# Bad
0001_add_invitations_and_update_users_and_fix_indexes.sql
```

**3. Forward-only migrations**

Drizzle does not support down migrations. Accept this constraint:

- Test migrations thoroughly before deploying
- Use database backups as the recovery mechanism
- For mistakes, write a new forward migration to fix

**4. Never modify deployed migrations**

Once a migration has been applied to staging or production, treat it as immutable. If you need to change something, create a new migration.

**5. Review generated SQL**

Always review the SQL that `drizzle-kit generate` produces before committing. Drizzle infers migrations from schema diff, which can sometimes produce unexpected results.

```bash
# Generate and review
pnpm db:generate
cat packages/db/drizzle/XXXX_migration_name.sql
```

### Schema Changes

**Adding columns:**

- Add with `DEFAULT` or as nullable to avoid locking issues on large tables
- Backfill data in a separate step if needed

```typescript
// Good - nullable, safe to add
newColumn: text("new_column"),

// Good - has default, safe to add
status: text("status").default("pending"),

// Risky on large tables - requires table rewrite
requiredColumn: text("required_column").notNull(),
```

**Removing columns:**

1. Stop reading from the column in application code
2. Deploy application
3. Create migration to drop column
4. Deploy migration

**Renaming columns:**
Drizzle may generate DROP + ADD instead of RENAME. Review carefully and manually adjust if needed.

**Adding indexes:**
For large tables, consider creating indexes concurrently to avoid locks:

```sql
-- Manual adjustment in migration file
CREATE INDEX CONCURRENTLY idx_name ON table_name (column);
```

Note: `CONCURRENTLY` cannot run inside a transaction, so you may need to split the migration.

### Environments

| Environment | Database                            | Migration Strategy      |
| ----------- | ----------------------------------- | ----------------------- |
| Local       | Local PostgreSQL or Neon dev branch | `db:push` for iteration |
| Staging     | Neon staging branch                 | `db:migrate` on deploy  |
| Production  | Neon main branch                    | `db:migrate` on deploy  |

### Data Migrations

Keep schema migrations separate from data migrations. For data backfills:

1. Create the schema migration first
2. Deploy it
3. Run data migration as a separate script or Trigger.dev task
4. Verify data
5. (Optional) Add constraints in a follow-up schema migration

```typescript
// packages/db/scripts/backfill-user-names.ts
// Run manually or via Trigger.dev task, not in migration
```

### Naming Conventions

Drizzle auto-generates migration names from timestamp. The format is:

```
XXXX_description.sql
```

When generating, Drizzle prompts for a name. Use descriptive, lowercase, snake_case names:

- `add_invitations_table`
- `add_index_on_users_email`
- `drop_legacy_columns`

### Troubleshooting

**Migration drift:**
If local schema and migrations get out of sync:

```bash
# Reset local and regenerate
pnpm db:push --force  # Caution: drops data
pnpm db:generate
```

**Failed migration:**
If a migration fails partway through in production:

1. Do not retry blindly
2. Check database state manually
3. Fix data/schema issues
4. Either complete manually or create a fixup migration
