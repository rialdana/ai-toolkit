## Development conventions

### Package Manager

**pnpm only.** Never use npm or yarn.

```bash
pnpm install
pnpm add <package>
pnpm remove <package>
```

### Git Workflow

**Commit messages**: Clear, concise, present tense.

```
# Good
Add invitation expiry validation
Fix member role update bug
Update dashboard stats query

# Bad
Fixed stuff
WIP
asdf
```

**Branches**: Use descriptive branch names.

```
feature/invitation-system
fix/member-permissions
refactor/event-queries
```

**Commits**: Commit logical chunks. Don't commit half-finished work or bundle unrelated changes.

### Environment Variables

**Never commit secrets.** Use `.env` files locally, environment variables in deployment.

```bash
# .env.local (git-ignored)
DATABASE_URL=postgres://...
BETTER_AUTH_SECRET=...
```

**Reference in code via `process.env`:**

```typescript
const dbUrl = process.env.DATABASE_URL;
```

### Dependencies

**Keep dependencies minimal.** Before adding a package:

1. Is it necessary, or can you write it in < 50 lines?
2. Is it actively maintained?
3. What's the bundle size impact?

**Update regularly.** Don't let dependencies get years out of date.

```bash
pnpm outdated
pnpm update
```

### Project Structure

See individual standards for structure:

- **Backend API**: `backend/api.md` (Vertical Slice Architecture)
- **Frontend**: `frontend/components.md` (Feature-based organization)
- **Database**: `backend/models.md` (Schema organization)

### TypeScript

**Strict mode always.** No `any` unless absolutely necessary.

```typescript
// Bad
function processData(data: any) {}

// Good
function processData(data: EventData) {}
```

**Fix ALL type errors.** When running type checking, fix every error in the codebase - not just errors related to the current task. Pre-existing type errors must be resolved before continuing with new work. This keeps the codebase healthy and prevents error accumulation.

**Prefer `interface` for object shapes, `type` for unions/aliases:**

```typescript
interface User {
	id: string;
	email: string;
}

type Status = "pending" | "active" | "cancelled";
type UserOrNull = User | null;
```

### Imports

**Order**: External → Shared → Feature/Local

```typescript
// External packages
import { useState } from "react";

import { z } from "zod";

import { db } from "@pitboss/db";

// Shared/internal packages
import { Button } from "@/shared/components/ui/button";

// Local/feature imports
import { useEvents } from "./use-events";
```

**Named imports only. No default exports.**

### Async/Await

**Prefer async/await over .then() chains:**

```typescript
// Good
const user = await db.query.users.findFirst({ where: ... });
const org = await db.query.organizations.findFirst({ where: ... });

// Avoid
db.query.users.findFirst({ where: ... })
  .then(user => db.query.organizations.findFirst({ where: ... }))
  .then(org => { ... });
```

**Parallel when independent:**

```typescript
const [user, org] = await Promise.all([
  db.query.users.findFirst({ where: ... }),
  db.query.organizations.findFirst({ where: ... }),
]);
```

### Common Commands

**Development:**

```bash
pnpm dev              # Start all apps (web, server, trigger)
pnpm dev:web          # Start web app only
pnpm dev:server       # Start server only
pnpm dev:native       # Start Expo/mobile
```

**Database:**

```bash
pnpm db:push          # Push schema changes (local dev only)
pnpm db:generate      # Generate migration (before commit)
pnpm db:migrate       # Run migrations
pnpm db:studio        # Open Drizzle Studio
```

**Quality:**

```bash
pnpm check            # Biome lint + format (with auto-fix)
pnpm check-types      # TypeScript type checking
pnpm build            # Build all packages
```

**Package Management:**

```bash
pnpm add <pkg>                    # Add to root
pnpm add <pkg> -F @pitboss/api    # Add to specific package
pnpm add <pkg> -D                 # Add as dev dependency
pnpm outdated                     # Check for updates
```

**Turborepo Filtering:**

```bash
pnpm turbo -F web <command>           # Run in apps/web
pnpm turbo -F @pitboss/api <command>  # Run in packages/api
pnpm turbo -F "./packages/*" build    # Run in all packages
```
