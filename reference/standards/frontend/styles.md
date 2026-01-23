## CSS standards (Tailwind v4)

### Core Principles

1. **Use Tailwind utilities** - Avoid custom CSS
2. **Use design tokens** - Never hardcode colors (no `#EFEFEF`, `rgb()`, etc.)
3. **Use theme hooks** - Access colors via hooks, not constants

### Class Ordering

Use the Prettier Tailwind plugin for automatic sorting. Don't manually organize classes.

```bash
# The plugin handles ordering automatically
pnpm add -D prettier-plugin-tailwindcss
```

### Conditional Classes

Use `cn()` (from `tailwind-merge` + `clsx`) for conditional classes:

```tsx
import { cn } from "@/shared/utils/cn";

<button
	className={cn(
		"rounded-md px-4 py-2",
		isActive && "bg-primary text-primary-foreground",
		isDisabled && "cursor-not-allowed opacity-50",
	)}
/>;
```

### Design Tokens

**Never hardcode colors.** Use CSS variables via Tailwind classes or theme hooks.

```tsx
// GOOD - uses design tokens
<div className="bg-background text-foreground border-border" />
<button className="bg-primary text-primary-foreground" />
<span className="text-muted-foreground" />

// BAD - hardcoded colors
<div className="bg-zinc-900 text-white border-zinc-800" />
<div style={{ backgroundColor: '#1a1a1a' }} />

// BAD - color constants
const BRAND_COLOR = '#594BFF';  // Never do this
const COLORS = { primary: '#594BFF', error: '#EF4444' };  // Never do this
```

#### Web (shadcn/ui) Tokens

- `background`, `foreground` - Page backgrounds, text
- `card`, `card-foreground` - Card surfaces
- `primary`, `primary-foreground` - Primary actions
- `secondary`, `secondary-foreground` - Secondary actions
- `muted`, `muted-foreground` - Subtle backgrounds, secondary text
- `accent`, `accent-foreground` - Highlights, hovers
- `destructive`, `destructive-foreground` - Errors, deletions
- `border`, `input`, `ring` - Borders, inputs, focus rings

#### Native (heroui-native) Tokens

**IMPORTANT:** Native tokens differ from web. Do NOT use `text-muted-foreground` in native - use `text-muted` instead.

| Purpose           | Web (shadcn/ui)         | Native (heroui-native)     |
| ----------------- | ----------------------- | -------------------------- |
| Primary text      | `text-foreground`       | `text-foreground`          |
| Secondary text    | `text-muted-foreground` | `text-muted`               |
| Card backgrounds  | `bg-card`               | `Card variant="secondary"` |
| Input backgrounds | `bg-input`              | `bg-default`               |
| Borders           | `border-border`         | `border-divider`           |

Use `useThemeColor` hook from heroui-native for dynamic color access:

```tsx
import { useThemeColor } from "heroui-native";

// Single color
const accentColor = useThemeColor("accent");

// Multiple colors (more efficient)
const [accent, muted, divider] = useThemeColor(["accent", "muted", "divider"]);
```

**Available tokens:**

- `background`, `foreground` - Base colors (foreground = white in dark mode)
- `surface` - Card/elevated surfaces
- `accent`, `accent-foreground` - Brand/primary color
- `success`, `warning`, `danger` - Semantic status colors
- `muted` - Secondary text, icons (use `text-muted` class)
- `divider` - Separator lines
- `default` - Input/field backgrounds (use `bg-default` class)

**When to use Tailwind classes vs hooks:**

- Use **Tailwind classes** (`className="bg-accent"`) when the color is static
- Use **useThemeColor hook** when you need the color value for:
  - Icon `color` prop (Ionicons, etc.)
  - Dynamic `style` prop
  - Passing to third-party components
  - Conditional logic based on color values

```tsx
// Tailwind class for background
<View className="bg-default" />

// Hook for icon color (can't use className)
const mutedColor = useThemeColor("muted");
<Ionicons name="calendar" color={mutedColor} />

// Text styling
<Text className="text-foreground" />      // Primary text
<Text className="text-muted" />           // Secondary text (NOT text-muted-foreground)
```

### Spacing

Use Tailwind's spacing scale:

```tsx
<div className="p-4">        {/* 16px padding */}
<div className="space-y-4">  {/* 16px gap between children */}
<div className="gap-2">      {/* 8px gap in flex/grid */}
```

Common patterns:

- Cards: `p-4` or `p-6`
- Form fields: `space-y-4`
- Inline elements: `gap-2`
- Page sections: `space-y-6` or `space-y-8`

### Typography

```tsx
// Headings
<h1 className="text-2xl font-semibold" />
<h2 className="text-xl font-semibold" />

// Body (web uses text-muted-foreground, native uses text-muted)
<p className="text-sm text-muted-foreground" />  // web
<Text className="text-sm text-muted" />          // native

// Small/labels
<span className="text-xs text-muted-foreground" />  // web
<Text className="text-xs text-muted" />             // native
```

### Sizing

```tsx
// Icons
<Icon className="size-4" />      // 16px (small)
<Icon className="size-5" />      // 20px (default)

// Buttons
<Button className="h-9" />       // Default
<Button className="h-10" />      // Large
<Button className="h-11" />      // Extra large (forms)

// Avatars
<Avatar className="size-8" />    // Small
<Avatar className="size-10" />   // Default
```

### Dark Mode

CSS variables auto-adapt. The `dark:` variant is rarely needed:

```tsx
// Usually not needed - CSS vars handle it
<div className="bg-background" /> // Works in both modes

// Only use dark: for edge cases
<div className="border-gray-200 dark:border-gray-800" />
```

### What to Avoid

```tsx
// NEVER hardcode colors
const BRAND_COLOR = '#594BFF';  // Bad
const COLORS = { error: '#EF4444' };  // Bad
<div style={{ color: '#666' }} />  // Bad

// Avoid inline styles for static values
<div style={{ padding: '16px' }} />  // Use className="p-4"

// Avoid !important
<div className="!p-0" />  // If you need !, reconsider the approach

// Avoid custom CSS classes
.my-special-button { }  // Use Tailwind utilities

// Avoid creating custom "semantic" color systems
// The theme already provides semantic colors (success, warning, danger, etc.)
```

**Prefer:**

- Tailwind design tokens: `bg-accent`, `text-muted` (native) / `text-muted-foreground` (web)
- Theme hooks for dynamic access: `useThemeColor("accent")`
- `style` prop only for truly dynamic values (computed at runtime, not colors)

### Performance

Tailwind v4 handles tree-shaking automatically. Unused styles are removed in production.
