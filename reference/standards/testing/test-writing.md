## Testing standards

### Philosophy

> "Write tests. Not too many. Mostly integration."
> — Guillermo Rauch

> "The more your tests resemble the way your software is used, the more confidence they can give you."
> — Kent C. Dodds

Testing is about **confidence**, not coverage percentages. The goal is confidence that your code works, with the least time investment.

### The Testing Trophy

```
    ┌─────────────┐
    │   E2E       │  ← Few, slow, high confidence
    ├─────────────┤
    │ Integration │  ← Most tests here
    ├─────────────┤
    │    Unit     │  ← Some, for complex logic
    ├─────────────┤
    │   Static    │  ← TypeScript + Biome (free)
    └─────────────┘
```

**Static analysis** (TypeScript, Biome) catches a huge class of bugs for free. This is your foundation.

**Integration tests** give the best ROI. Test multiple units working together. Don't mock everything - the integration is what you're testing.

**Unit tests** are for isolated, complex logic (calculations, transformations). If it has no dependencies, unit test it.

**E2E tests** are expensive but high confidence. Use sparingly for critical user flows.

### What to Test

**Do test:**

- Critical business logic (payment calculations, permissions, scheduling conflicts)
- Complex procedures that are hard to manually verify
- Regressions (when a bug is found, write a test before fixing)
- Integration between units (API → DB, Component → API)

**Don't test:**

- Implementation details (internal state, private methods)
- Framework code (React, tRPC already test themselves)
- Simple CRUD with no logic
- Things TypeScript already catches

### Test Structure

**AAA Pattern: Arrange, Act, Assert**

Every test follows this structure:

```typescript
it("creates invitation for new email", async () => {
	// Arrange - set up test data
	const org = await createTestOrg();
	const admin = await createTestUser({ orgId: org.id, role: "ADMIN" });
	const ctx = createTestContext({ user: admin, orgId: org.id });
	const caller = appRouter.createCaller(ctx);

	// Act - perform the action
	const result = await caller.invitations.create({
		email: "new@example.com",
		role: "MEMBER",
	});

	// Assert - verify the outcome
	expect(result.email).toBe("new@example.com");
	expect(result.status).toBe("PENDING");
});
```

**Flat, Self-Contained Tests**

Each test should set up its own data. Avoid shared mutable state:

```typescript
// Bad - shared state causes coupling and flakiness
describe("invitations", () => {
	let testOrg: Organization;
	let testUser: User;

	beforeEach(async () => {
		testOrg = await createTestOrg();
		testUser = await createTestUser({ orgId: testOrg.id });
	});

	it("test 1", async () => {
		/* uses testOrg, testUser */
	});
	it("test 2", async () => {
		/* uses testOrg, testUser */
	});
});

// Good - each test is independent
describe("invitations", () => {
	it("creates invitation for new email", async () => {
		const org = await createTestOrg();
		const user = await createTestUser({ orgId: org.id, role: "ADMIN" });
		// ... rest of test
	});

	it("throws conflict for existing invitation", async () => {
		const org = await createTestOrg();
		const user = await createTestUser({ orgId: org.id, role: "ADMIN" });
		// ... rest of test
	});
});
```

**Why flat tests?**

- Tests can run in parallel without conflicts
- Failing tests are easier to debug (all context is visible)
- No hidden dependencies between tests
- Refactoring one test doesn't break others

**Keep tests small:** Aim for <10 statements per test. If a test is getting long, you're probably testing multiple behaviors—split it up.

### Integration Tests for tRPC

Test procedures against a real test database, not mocks:

```typescript
// features/invitations/create/create.test.ts
import { describe, expect, it } from "vitest";

import { appRouter } from "@/router";
import {
	createTestContext,
	createTestOrg,
	createTestUser,
} from "@/test/helpers";

describe("invitations.create", () => {
	it("creates invitation for new email", async () => {
		// Arrange
		const org = await createTestOrg();
		const admin = await createTestUser({ orgId: org.id, role: "ADMIN" });
		const ctx = createTestContext({ user: admin, orgId: org.id });
		const caller = appRouter.createCaller(ctx);

		// Act
		const result = await caller.invitations.create({
			email: "new@example.com",
			role: "MEMBER",
		});

		// Assert
		expect(result.email).toBe("new@example.com");
		expect(result.status).toBe("PENDING");
	});

	it("throws conflict for existing pending invitation", async () => {
		// Arrange
		const org = await createTestOrg();
		const admin = await createTestUser({ orgId: org.id, role: "ADMIN" });
		const ctx = createTestContext({ user: admin, orgId: org.id });
		const caller = appRouter.createCaller(ctx);

		// Create first invitation
		await caller.invitations.create({ email: "existing@example.com" });

		// Act & Assert
		await expect(
			caller.invitations.create({ email: "existing@example.com" }),
		).rejects.toThrow("already exists");
	});
});
```

### Unit Tests for Complex Logic

Isolate and test pure functions:

```typescript
// shared/lib/pay-calculation.test.ts
import { describe, expect, it } from "vitest";

import { calculateProRatedPay } from "./pay-calculation";

describe("calculateProRatedPay", () => {
	it("calculates full pay for complete shift", () => {
		const result = calculateProRatedPay({
			hourlyRate: 20,
			scheduledHours: 8,
			workedHours: 8,
		});
		expect(result).toBe(160);
	});

	it("pro-rates for partial shift", () => {
		const result = calculateProRatedPay({
			hourlyRate: 20,
			scheduledHours: 8,
			workedHours: 6,
		});
		expect(result).toBe(120);
	});
});
```

### Frontend Testing

Use Testing Library. Test behavior, not implementation:

```typescript
// features/auth/sign-in/sign-in-form.test.tsx
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { SignInForm } from "./sign-in-form";

describe("SignInForm", () => {
  it("shows validation error for invalid email", async () => {
    render(<SignInForm />);

    await userEvent.type(screen.getByLabelText(/email/i), "not-an-email");
    await userEvent.click(screen.getByRole("button", { name: /sign in/i }));

    expect(screen.getByText(/invalid email/i)).toBeInTheDocument();
  });

  it("submits with valid credentials", async () => {
    const onSuccess = vi.fn();
    render(<SignInForm onSuccess={onSuccess} />);

    await userEvent.type(screen.getByLabelText(/email/i), "test@example.com");
    await userEvent.type(screen.getByLabelText(/password/i), "password123");
    await userEvent.click(screen.getByRole("button", { name: /sign in/i }));

    await waitFor(() => expect(onSuccess).toHaveBeenCalled());
  });
});
```

### What Not to Mock

**Don't mock:**

- Your own code (test the integration!)
- The database in integration tests (use a test DB)
- Simple utilities

**Do mock:**

- External APIs (Stripe, Resend)
- Time-dependent code (`vi.useFakeTimers()`)
- Things that cost money or send real emails

### Mocking External APIs with MSW

Use [MSW (Mock Service Worker)](https://mswjs.io/) to intercept HTTP requests at the network level. This is cleaner than stubbing `fetch` or mocking modules.

**Setup:**

```typescript
// test/mocks/handlers.ts
import { HttpResponse, http } from "msw";

export const handlers = [
	// Resend email API
	http.post("https://api.resend.com/emails", () => {
		return HttpResponse.json({ id: "email_123" });
	}),

	// Stripe payment intent
	http.post("https://api.stripe.com/v1/payment_intents", () => {
		return HttpResponse.json({
			id: "pi_123",
			status: "succeeded",
			amount: 5000,
		});
	}),
];
```

```typescript
// test/setup.ts
import { setupServer } from "msw/node";

import { handlers } from "./mocks/handlers";

export const server = setupServer(...handlers);

beforeAll(() => server.listen({ onUnhandledRequest: "error" }));
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

**Per-test overrides:**

```typescript
import { HttpResponse, http } from "msw";

import { server } from "@/test/setup";

it("handles payment failure", async () => {
	// Override default handler for this test
	server.use(
		http.post("https://api.stripe.com/v1/payment_intents", () => {
			return HttpResponse.json(
				{ error: { message: "Card declined" } },
				{ status: 402 },
			);
		}),
	);

	// Test error handling...
});
```

**Why MSW over jest.mock?**

- Tests real HTTP behavior (headers, status codes, network errors)
- Same mocks work in browser and Node.js
- No coupling to implementation (axios vs fetch vs native)
- Handlers are reusable across tests

**Fail on unmocked requests:**

The `onUnhandledRequest: "error"` option ensures tests fail if they hit an external API you forgot to mock. This prevents accidental real API calls.

### Test Organization

Tests live with the code they test (VSA):

```
features/invitations/create/
  create.procedure.ts
  create.schema.ts
  create.repository.ts
  create.test.ts        ← Test lives here
```

Test infrastructure lives in a `test/` directory at the package root:

```
packages/api/
  src/
    features/...
  test/
    helpers.ts          ← Test context factories
    factories.ts        ← Data factories (createTestOrg, etc.)
    setup.ts            ← Global test setup
    mocks/
      handlers.ts       ← MSW handlers

apps/web/
  src/
    features/...
  test/
    setup.ts
    mocks/
      handlers.ts
```

### Test Infrastructure

**Test Database**

Use a real PostgreSQL database for integration tests, not SQLite or in-memory fakes. Schema differences cause false positives.

```typescript
// test/helpers.ts
import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";

const testDbUrl = process.env.TEST_DATABASE_URL;
const client = postgres(testDbUrl);
export const testDb = drizzle(client);

export function createTestContext(overrides?: Partial<Context>) {
	return {
		db: testDb,
		session: null,
		organizationId: null,
		...overrides,
	};
}
```

**Data Isolation**

Each test creates its own data. Use unique identifiers to avoid conflicts:

```typescript
// test/factories.ts
import { nanoid } from "nanoid";

export async function createTestOrg(overrides?: Partial<NewOrganization>) {
	const [org] = await testDb
		.insert(organizations)
		.values({
			id: nanoid(),
			name: `Test Org ${nanoid(6)}`,
			slug: `test-org-${nanoid(6)}`,
			...overrides,
		})
		.returning();
	return org;
}

export async function createTestUser(overrides?: Partial<NewUser>) {
	const [user] = await testDb
		.insert(users)
		.values({
			id: nanoid(),
			email: `test-${nanoid(6)}@example.com`,
			name: "Test User",
			...overrides,
		})
		.returning();
	return user;
}
```

**Why random IDs?**

- Tests can run in parallel without conflicts
- No need for cleanup between tests
- Mimics production behavior

**Global cleanup (optional):**

Clean up old test data periodically, not between each test:

```typescript
// test/setup.ts
afterAll(async () => {
	// Clean up test data older than 1 hour
	await testDb
		.delete(organizations)
		.where(
			and(
				like(organizations.name, "Test Org%"),
				lt(organizations.createdAt, subHours(new Date(), 1)),
			),
		);
});
```

**Docker for local testing:**

```yaml
# docker-compose.test.yml
services:
  test-db:
    image: postgres:16
    environment:
      POSTGRES_DB: pitboss_test
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
    ports:
      - "5433:5432"
    command: postgres -c fsync=off -c full_page_writes=off
```

The `fsync=off` flag makes the test DB 20-40% faster by skipping durability guarantees (fine for tests, never for production).

### Test Naming

Describe what the code does, not how:

```typescript
// Good - describes behavior
it("creates invitation for new email");
it("throws conflict for existing pending invitation");
it("sends email after creating invitation");

// Bad - describes implementation
it("calls insertInvitation with correct params");
it("sets status to PENDING");
```

### When to Write Tests

1. **Before fixing a bug** - Write a failing test that reproduces it, then fix
2. **For complex logic** - If you can't easily verify it manually
3. **For critical paths** - Payments, permissions, data integrity
4. **When refactoring** - Tests let you refactor with confidence

### Test Completeness Checklist

For each API procedure test, verify all relevant outcomes:

**1. Response**

- Correct data returned
- Correct status/error codes
- Response matches schema

```typescript
expect(result.id).toBeDefined();
expect(result.status).toBe("PENDING");
expect(result.email).toBe(input.email);
```

**2. State changes**

- Database records created/updated/deleted
- Verify via API, not direct DB queries when possible

```typescript
// Verify via API (preferred)
const invitations = await caller.invitations.list();
expect(invitations).toHaveLength(1);

// Direct DB query (when API doesn't expose it)
const dbRecord = await testDb.query.invitations.findFirst({
	where: eq(invitations.id, result.id),
});
expect(dbRecord.status).toBe("PENDING");
```

**3. External calls**

- Emails sent (via MSW assertions)
- Background jobs triggered
- Third-party APIs called correctly

```typescript
// Assert MSW handler was called
expect(resendHandler).toHaveBeenCalledTimes(1);

// Or check Trigger.dev task was triggered
expect(mockTrigger).toHaveBeenCalledWith("send-invitation-email", {
	invitationId: result.id,
});
```

**4. Side effects avoided**

- Other records unchanged
- No unintended mutations

```typescript
// Create another org's invitation first
const otherOrg = await createTestOrg();
await createTestInvitation({ orgId: otherOrg.id });

// Perform action on our org
await caller.invitations.create({ email: "new@example.com" });

// Verify other org's data is untouched
const otherInvitations = await testDb.query.invitations.findMany({
	where: eq(invitations.organizationId, otherOrg.id),
});
expect(otherInvitations).toHaveLength(1); // Still just the original
```

**5. Error cases**

- Invalid input rejected
- Unauthorized access blocked
- Conflicts handled

```typescript
// Unauthorized
await expect(
	callerWithoutAuth.invitations.create({ email: "test@example.com" }),
).rejects.toThrow("UNAUTHORIZED");

// Conflict
await caller.invitations.create({ email: "existing@example.com" });
await expect(
	caller.invitations.create({ email: "existing@example.com" }),
).rejects.toThrow("already exists");
```

### Coverage

Don't chase 100% coverage. Aim for confidence in critical paths. Diminishing returns kick in around 70-80%.

Coverage tools can help identify untested critical code, but don't treat coverage as a goal in itself.

### Further Reading

- [Write tests. Not too many. Mostly integration.](https://kentcdodds.com/blog/write-tests) - Kent C. Dodds
- [Testing Implementation Details](https://kentcdodds.com/blog/testing-implementation-details)
- [Static vs Unit vs Integration vs E2E](https://kentcdodds.com/blog/static-vs-unit-vs-integration-vs-e2e-tests)
- [Testing Library Docs](https://testing-library.com/)
