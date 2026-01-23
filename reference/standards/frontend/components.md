## Component standards (React + Vertical Slice Architecture)

### Core Principles

1. **Vertical slices**: Organize by feature, not by technical layer
2. **kebab-case everything**: All files, all folders, no exceptions
3. **Named exports only**: No default exports
4. **No barrel files**: Import directly from the file, not from index.ts
5. **Colocation**: Keep related code together within a feature

### File Organization

```
apps/web/src/
  features/
    auth/
      sign-in/
        sign-in-form.tsx
        sign-in-form.schema.ts
        sign-in-form.test.ts
        use-sign-in.ts
      sign-up/
        sign-up-form.tsx
        ...
    dashboard/
      dashboard-page.tsx
      dashboard-stats.tsx
      use-dashboard-data.ts
    events/
      event-list/
        event-list.tsx
        event-list-item.tsx
        use-events.ts
      event-detail/
        event-detail-page.tsx
        ...
  shared/
    components/
      ui/                    # shadcn components
        button.tsx
        input.tsx
        card.tsx
      layouts/
        app-sidebar.tsx
        nav-user.tsx
      loader.tsx
    hooks/
      use-mobile.ts
    lib/
      utils.ts
      auth-client.ts
    contexts/
      organization-context.tsx
  routes/                    # TanStack Router files
    __root.tsx
    dashboard.tsx
    events/
      index.tsx
      $event-id.tsx
```

### Feature Slices

Each feature is a vertical slice containing everything it needs:

```
features/events/event-list/
  event-list.tsx           # Main component
  event-list-item.tsx      # Child component
  event-list.schema.ts     # Zod schemas if needed
  use-events.ts            # Data fetching hook
  event-list.test.ts       # Tests
```

**Features don't import from other features.** If two features need the same thing, move it to `shared/`.

### Naming Conventions

**Everything is kebab-case:**

```
# Files
sign-in-form.tsx
use-auth-session.ts
organization-context.tsx

# Folders
features/
  event-management/
    event-list/
```

**Components are PascalCase in code:**

```tsx
// sign-in-form.tsx
export function SignInForm() {}
```

### Exports

**Named exports only. No default exports:**

```tsx
// Good
export function SignInForm() {}
export function useSignIn() {}

// Bad
export default function SignInForm() {}
```

**No barrel files (index.ts re-exports):**

```tsx
// Good - import directly
import { SignInForm } from "@/features/auth/sign-in/sign-in-form";
import { Button } from "@/shared/components/ui/button";

// Bad - barrel file
import { SignInForm } from "@/features/auth";
import { Button, Input, Card } from "@/shared/components/ui";
```

Why no barrel files?

- They slow down IDE auto-import suggestions
- They can cause circular dependency issues
- They make it harder to trace where code lives
- They bundle more code than necessary

### Route Files

TanStack Router files delegate to feature components:

```tsx
// routes/dashboard.tsx
import { createFileRoute } from "@tanstack/react-router";

import { DashboardPage } from "@/features/dashboard/dashboard-page";

export const Route = createFileRoute("/dashboard")({
	component: DashboardPage,
});
```

### Component Structure

```tsx
// 1. External imports
import { useState } from "react";
import { useForm } from "@tanstack/react-form";
import { z } from "zod";

// 2. Shared imports
import { Button } from "@/shared/components/ui/button";
import { Input } from "@/shared/components/ui/input";

// 3. Feature imports (same feature only)
import { signInSchema } from "./sign-in-form.schema";
import { useSignIn } from "./use-sign-in";

// 4. Types
interface SignInFormProps {
  onSuccess?: () => void;
}

// 5. Component
export function SignInForm({ onSuccess }: SignInFormProps) {
  // Hooks
  const [showPassword, setShowPassword] = useState(false);
  const signIn = useSignIn();

  // Derived state
  const isValid = /* ... */;

  // Handlers
  function handleSubmit() { /* ... */ }

  // Render
  return (
    <form onSubmit={handleSubmit}>
      {/* ... */}
    </form>
  );
}
```

### State Management

**Local state first:**

```tsx
const [isOpen, setIsOpen] = useState(false);
```

**Lift when siblings need it:**

```tsx
function EventPage() {
	const [selectedId, setSelectedId] = useState<string | null>(null);
	return (
		<>
			<EventList onSelect={setSelectedId} />
			<EventDetail id={selectedId} />
		</>
	);
}
```

**Zustand for global client state:**

```tsx
// shared/stores/theme-store.ts
import { create } from "zustand";

interface ThemeState {
	theme: "light" | "dark";
	setTheme: (theme: "light" | "dark") => void;
}

export const useThemeStore = create<ThemeState>((set) => ({
	theme: "dark",
	setTheme: (theme) => set({ theme }),
}));
```

**TanStack Query for server state:**

```tsx
const { data, isLoading } = trpc.events.list.useQuery();
```

### Forms

Use TanStack Form with Zod:

```tsx
// sign-in-form.schema.ts
import { z } from "zod";

export const signInSchema = z.object({
	email: z.string().email("Invalid email"),
	password: z.string().min(8, "Min 8 characters"),
});

export type SignInInput = z.infer<typeof signInSchema>;
```

```tsx
// sign-in-form.tsx
import { useForm } from "@tanstack/react-form";

import { signInSchema } from "./sign-in-form.schema";

export function SignInForm() {
	const form = useForm({
		defaultValues: { email: "", password: "" },
		validators: { onSubmit: signInSchema },
		onSubmit: async ({ value }) => {
			/* ... */
		},
	});
	// ...
}
```

### Composition Over Props

Prefer composable components:

```tsx
// Good - composable
<Card>
  <CardHeader>
    <CardTitle>Event Details</CardTitle>
  </CardHeader>
  <CardContent>
    <EventInfo event={event} />
  </CardContent>
</Card>

// Avoid - prop explosion
<Card
  title="Event Details"
  subtitle="..."
  headerAction={<Button />}
  content={<EventInfo />}
  footer={<Actions />}
/>
```

### Icons

Lucide React, imported individually:

```tsx
import { Calendar, Clock, Users } from "lucide-react";

<Calendar className="h-4 w-4" />;
```

### Path Aliases

Use `@/` for src imports:

```tsx
import { useEvents } from "@/features/events/event-list/use-events";
import { Button } from "@/shared/components/ui/button";
```

### When to Split Components

Split when:

- Component exceeds ~200 lines
- Logic is reusable elsewhere in the feature
- Testing requires isolation

Don't split prematurely. But if you're copying code, extract it.

### You Might Not Need useEffect

`useEffect` is for synchronizing with external systems. Most of the time, you don't need it.

**Don't use useEffect for:**

1. **Transforming data for rendering** - Calculate during render instead:

```tsx
// Bad - unnecessary effect
const [fullName, setFullName] = useState('');
useEffect(() => {
  setFullName(firstName + ' ' + lastName);
}, [firstName, lastName]);

// Good - calculate during render
const fullName = firstName + ' ' + lastName;
```

2. **Handling user events** - Use event handlers:

```tsx
// Bad - effect for user action
useEffect(() => {
	if (submitted) {
		postData(formData);
	}
}, [submitted]);

// Good - event handler
function handleSubmit() {
	postData(formData);
}
```

3. **Resetting state when props change** - Use a key:

```tsx
// Bad - effect to reset
useEffect(() => {
	setComment("");
}, [userId]);

// Good - key forces remount
<Profile userId={userId} key={userId} />;
```

4. **Notifying parent of state changes** - Call in the event handler:

```tsx
// Bad - effect to notify parent
useEffect(() => {
	onChange(isOn);
}, [isOn, onChange]);

// Good - notify in handler
function handleToggle() {
	const next = !isOn;
	setIsOn(next);
	onChange(next);
}
```

5. **Chains of effects updating state** - Calculate in one place:

```tsx
// Bad - chain of effects
useEffect(() => {
	setA(b + 1);
}, [b]);
useEffect(() => {
	setC(a + 1);
}, [a]);

// Good - calculate together
function handleChange(newB) {
	setB(newB);
	setA(newB + 1);
	setC(newB + 2);
}
```

**Do use useEffect for:**

- Fetching data (though TanStack Query is preferred)
- Setting up subscriptions to external stores
- Syncing with non-React widgets (maps, video players)
- Sending analytics on page view
- Managing focus for accessibility (see accessibility.md)

See: https://react.dev/learn/you-might-not-need-an-effect

### Performance

**Measure before optimizing.** Don't add `useMemo`, `useCallback`, or `React.memo` preemptively.

```tsx
// Don't do this without measuring
const memoizedValue = useMemo(() => expensiveCalc(data), [data]);
const memoizedCallback = useCallback(() => handleClick(), []);

// Instead, write simple code first
const value = expensiveCalc(data);
function handleClick() {}
```

Premature memoization can make performance worse. Only optimize when:

1. You've measured a real performance problem
2. Profiling shows the specific component/calculation is the bottleneck
3. The optimization actually improves the measured metric

### Shared vs Feature Code

Move to `shared/` when:

- 2+ features need identical behavior
- The abstraction is stable
- It's truly cross-cutting (auth, layouts, utilities)

Don't duplicate code. If you find yourself copying logic between features, extract it to `shared/`.

### Navigation

**Always use `Link` component for internal navigation.** Never use raw `<a href>` tags for internal routes.

```tsx
// Good - use Link component
import { Link } from "@tanstack/react-router"; // web
import { Link } from "expo-router"; // mobile

<Link to="/dashboard">Go to Dashboard</Link>

// Bad - raw anchor tag breaks client-side routing
<a href="/dashboard">Go to Dashboard</a>
```

External links are the exception - use `<a>` with `target="_blank"` and `rel="noopener noreferrer"`:

```tsx
<a href="https://example.com" target="_blank" rel="noopener noreferrer">
	External Site
</a>
```

### Mutations

**Do NOT use `onSuccess`, `onError`, or `onSettled` callbacks** in TanStack Query/tRPC mutations. These are deprecated and will be removed in v6. Handle responses at the call site instead:

```tsx
// BAD - deprecated callbacks
const mutation = useMutation({
  mutationFn: async (data) => { ... },
  onSuccess: (data) => {
    toast.success("Saved!");
    navigate("/dashboard");
  },
  onError: (error) => {
    toast.error(error.message);
  },
});

// GOOD - handle at call site
const mutation = useMutation({
  mutationFn: async (data) => { ... },
});

async function handleSubmit(data) {
  try {
    await mutation.mutateAsync(data);
    toast.success("Saved!");
    navigate("/dashboard");
  } catch (error) {
    toast.error(error.message);
  }
}
```

This pattern is clearer, more explicit about control flow, and future-proof.
