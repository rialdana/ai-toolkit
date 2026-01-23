## Responsive design standards (Tailwind)

### Core Principle

Every view must be usable on mobile. No exceptions.

### Mobile-First

Write base styles for mobile, add breakpoint variants for larger screens:

```tsx
// Mobile-first approach
<div className="flex flex-col md:flex-row">
<div className="w-full md:w-1/2 lg:w-1/3">
<div className="p-4 md:p-6 lg:p-8">
```

### Breakpoints

Use Tailwind's default breakpoints consistently:

| Prefix | Min Width | Typical Use      |
| ------ | --------- | ---------------- |
| (none) | 0px       | Mobile (default) |
| `sm:`  | 640px     | Large phones     |
| `md:`  | 768px     | Tablets          |
| `lg:`  | 1024px    | Laptops          |
| `xl:`  | 1280px    | Desktops         |
| `2xl:` | 1536px    | Large screens    |

**Common pattern:** Base → `md:` → `lg:` covers most cases.

### Layout Patterns

**Stacking to row:**

```tsx
<div className="flex flex-col gap-4 md:flex-row">
	<div className="md:w-1/2">Left</div>
	<div className="md:w-1/2">Right</div>
</div>
```

**Hide/show elements:**

```tsx
// Mobile only
<div className="md:hidden">Mobile menu</div>

// Desktop only
<div className="hidden md:block">Desktop nav</div>
```

**Grid adjustments:**

```tsx
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
```

### Container Widths

Use `max-w-*` for content constraints:

```tsx
// Page content
<main className="max-w-7xl mx-auto px-4">

// Narrow content (forms, articles)
<div className="max-w-md mx-auto">

// Full width with padding
<div className="w-full px-4 md:px-6">
```

### Touch Targets

Ensure interactive elements are touch-friendly (minimum 44x44px):

```tsx
// Good - adequate touch target
<button className="p-3">  {/* 44px+ with content */}
<Button size="lg">        {/* h-11 = 44px */}

// Icon buttons need explicit sizing
<button className="p-2.5"> {/* 40px */}
  <Icon className="h-5 w-5" />
</button>
```

### Typography Scaling

Keep text readable across sizes:

```tsx
// Scale heading sizes
<h1 className="text-xl md:text-2xl lg:text-3xl">

// Base body text is usually fine as-is
<p className="text-sm md:text-base">
```

### Component Responsiveness

**Tables → Cards on mobile:**

```tsx
// Desktop: table, Mobile: cards
<div className="hidden md:block">
  <Table>...</Table>
</div>
<div className="md:hidden space-y-4">
  {items.map(item => <Card key={item.id}>...</Card>)}
</div>
```

**Sidebars:**

```tsx
// Desktop: visible sidebar, Mobile: collapsible/drawer
<Sidebar className="hidden md:flex">
<Sheet className="md:hidden">  {/* Mobile drawer */}
```

### Use the `useMobile` Hook

For logic that depends on screen size:

```tsx
import { useMobile } from "@/shared/hooks/use-mobile";

function Component() {
	const isMobile = useMobile();

	return isMobile ? <MobileView /> : <DesktopView />;
}
```

Use sparingly - prefer CSS breakpoints when possible.

### Testing

Test at these key widths:

- 375px (iPhone SE)
- 768px (iPad portrait)
- 1024px (laptop)
- 1440px (desktop)

Browser DevTools device mode is sufficient for development testing.
