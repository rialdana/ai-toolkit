## Coding style standards

### Formatting

Biome handles formatting automatically. Don't bikeshed on style - run `pnpm check` and move on.

### Naming

**Files and folders**: kebab-case everywhere, no exceptions.

```
sign-in-form.tsx
use-auth-session.ts
organization-context.tsx
```

**Variables and functions**: camelCase.

```typescript
const userId = "123";
function handleSubmit() {}
```

**Components and types**: PascalCase.

```typescript
function SignInForm() {}
interface UserProfile {}
type EventStatus = "pending" | "active";
```

**Constants**: SCREAMING_SNAKE_CASE for true constants.

```typescript
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = "https://api.example.com";
```

**Common abbreviations**: These are acceptable:

- `ctx` (context)
- `db` (database)
- `id` (identifier)
- `props` (properties)
- `req`, `res` (request, response)
- `env` (environment)
- `config` (configuration)

Otherwise, prefer full words. `getUserById` not `getUsrById`.

### Functions

**Clear inputs, clear outputs, minimal side effects.**

A good function:

- Has obvious inputs (parameters) and outputs (return value)
- Reads top to bottom without jumping around
- Minimizes side effects
- Has a single, clear responsibility

**Size is not the metric.** Don't aim for arbitrary line counts. Instead:

- If you're jumping between files constantly, functions may be too small
- If you can't understand what a function does or what it might break, it's too big
- If variables are only used in a small scope within a function, consider extracting

**Err on the side of smaller.** Small functions are easy to combine. Untangling a massive function is hard. Functions tend to grow over time, so start small.

```typescript
// Good - clear responsibility, easy to understand
function calculateInvitationExpiry(createdAt: Date): Date {
	const expiryDays = 7;
	return addDays(createdAt, expiryDays);
}

// Bad - doing too many things
function processInvitation(invitation, user, org) {
	// 200 lines of validation, email sending, database updates,
	// logging, notification, and error handling all tangled together
}
```

### Principles

**DRY (Don't Repeat Yourself)**: Extract common logic into reusable functions. If you're copying code, stop and refactor.

**KISS (Keep It Simple)**: Prefer simple solutions. Don't over-engineer. The best code is code you don't have to write.

**Single Responsibility**: Each function/module should do one thing well. If you can't describe what it does in one sentence, it's doing too much.

### Type Safety

**Never disable type checking.** TypeScript's type system is your safety net - don't circumvent it.

Do NOT use:

- `@ts-nocheck` - never
- `@ts-ignore` - only with explicit user approval for exceptional cases
- `any` types - must be justified; prefer `unknown` and narrow

When encountering type errors from dependencies (e.g., React 18 vs 19 type incompatibility):

1. Fix the underlying type issue if possible
2. Use package-level overrides in `package.json` (pnpm overrides, npm overrides)
3. If the fix is complex, ask the user before proceeding

```typescript
// Bad - bypassing the type system
// @ts-nocheck
import { Component } from "problematic-library";

// Bad - hiding real issues
// @ts-ignore
const data: any = fetchData();

// Good - fix at the package level
// In package.json: "pnpm": { "overrides": { "@types/react": "18.3.18" } }
```

### Avoid

**Dead code**: Delete unused code, commented-out blocks, and unused imports. Version control is your backup.

**Premature abstraction**: Don't create abstractions until you need them. Concrete code that works beats elegant abstractions that don't.

**Clever code**: Write code for humans to read. Clarity beats cleverness.

```typescript
// Bad - clever but unclear
const x = arr.reduce((a, b) => ((a[b] = (a[b] || 0) + 1), a), {});

// Good - clear intent
const counts: Record<string, number> = {};
for (const item of arr) {
	counts[item] = (counts[item] ?? 0) + 1;
}
```

**Backward compatibility code**: Unless specifically required, don't write extra logic for backward compatibility. Keep the codebase clean.

### Further Reading

- [John Carmack on Inlined Code](http://number-none.com/blow/blog/programming/2014/09/26/carmack-on-inlined-code.html)
- [A Philosophy of Software Design](https://www.amazon.com/Philosophy-Software-Design-John-Ousterhout/dp/1732102201) by John Ousterhout
