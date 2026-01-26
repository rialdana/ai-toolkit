## Code commenting standards

### Core Philosophy

Code should be self-documenting through clear structure and naming. Comments are a last resort, not a first choice.

### When to Comment

**Do comment:**

- Complex business logic that isn't obvious from the code
- Non-obvious "why" decisions (not "what" - the code shows what)
- Public API documentation (JSDoc on exported functions)
- Regex patterns or complex algorithms

```typescript
/**
 * Calculates pro-rated pay for partial event coverage.
 * Uses the organization's configured rounding rules.
 */
export function calculateProRatedPay(/* ... */) {}

// Match ISO 8601 duration format (e.g., "PT2H30M")
const durationRegex = /^PT(\d+H)?(\d+M)?(\d+S)?$/;
```

**Don't comment:**

- What the code does (the code already says that)
- Obvious things
- Temporary changes or fixes
- TODOs without action (either fix it or delete it)

```typescript
// Bad - obvious
// Loop through users
for (const user of users) {
}

// Bad - what, not why
// Set status to active
user.status = "active";

// Bad - stale/temporary
// TODO: fix this later
// HACK: workaround for bug #123

// Good - why
// Skip deactivated users to avoid sending them notifications
if (user.status === "deactivated") continue;
```

### Comment Style

Keep comments concise. If you need a paragraph, the code is probably too complex.

```typescript
// Good
// Expire invitations after 7 days

// Bad
// This function checks if the invitation has expired by comparing
// the created date plus seven days against the current date and
// returning true if the current date is after the expiry date
```

### JSDoc

Use JSDoc for exported functions that aren't self-explanatory:

```typescript
/**
 * Sends invitation email and creates audit log entry.
 * @throws {InvitationExpiredError} If invitation has expired
 */
export async function sendInvitation(invitationId: string): Promise<void> {
	// ...
}
```

Don't over-document. If the function name and types make it clear, skip JSDoc:

```typescript
// No JSDoc needed - obvious from signature
export function formatCurrency(amount: number, currency: string): string {
	// ...
}
```
