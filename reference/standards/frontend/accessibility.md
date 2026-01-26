## Accessibility standards

Target: WCAG 2.1 AA where practical. shadcn/ui components handle most accessibility concerns out of the box.

### Use shadcn Components Correctly

shadcn (built on Radix) provides accessible primitives. Don't break them:

```tsx
// Good - uses shadcn Button
<Button onClick={handleSubmit}>Save</Button>

// Bad - div with click handler
<div onClick={handleSubmit} className="button-styles">Save</div>
```

### Semantic HTML

Use the right element for the job:

```tsx
// Good
<button>Submit</button>
<a href="/settings">Settings</a>
<nav>...</nav>
<main>...</main>

// Bad
<div onClick={...}>Submit</div>
<span onClick={...}>Settings</span>
<div className="nav">...</div>
```

### Form Labels

Every input needs a label. shadcn's form components handle this:

```tsx
// Good - using shadcn Form
<FormField
  control={form.control}
  name="email"
  render={({ field }) => (
    <FormItem>
      <FormLabel>Email</FormLabel>
      <FormControl>
        <Input {...field} />
      </FormControl>
    </FormItem>
  )}
/>

// Bad - no label
<Input placeholder="Email" />
```

### Color Contrast

- Text: 4.5:1 minimum contrast ratio against background
- Large text (18px+): 3:1 minimum
- Don't rely on color alone to convey information (add icons, text, or patterns)

```tsx
// Good - icon reinforces meaning
<Badge variant="destructive">
  <AlertCircle className="h-3 w-3 mr-1" />
  Error
</Badge>

// Risky - color alone
<span className="text-red-500">Error</span>
```

### Keyboard Navigation

- All interactive elements must be reachable via Tab
- Visible focus indicators (shadcn provides these)
- Escape closes modals/dialogs
- Enter/Space activates buttons

shadcn handles most of this. Don't override focus styles without providing alternatives:

```css
/* Bad - removes focus indicator entirely */
*:focus {
	outline: none;
}

/* OK - custom focus style */
*:focus-visible {
	outline: 2px solid var(--ring);
	outline-offset: 2px;
}
```

### Focus Management

When opening modals or dialogs, focus should move to the dialog. When closing, focus should return to the trigger. shadcn's Dialog handles this automatically.

For custom dynamic content:

```tsx
// After adding content, focus the new element
const newItemRef = useRef<HTMLElement>(null);

useEffect(() => {
	if (newItemAdded) {
		newItemRef.current?.focus();
	}
}, [newItemAdded]);
```

### Images

Informative images need alt text. Decorative images should have empty alt:

```tsx
// Informative - describe the content
<img src={user.avatar} alt={`${user.name}'s profile photo`} />

// Decorative - empty alt
<img src="/decorative-pattern.svg" alt="" />

// Icon with adjacent text - hide from screen readers
<Lucide.Check aria-hidden="true" />
<span>Completed</span>
```

### Heading Structure

One `h1` per page. Headings should nest logically:

```tsx
// Good
<h1>Event Details</h1>
  <h2>Schedule</h2>
  <h2>Staff</h2>
    <h3>Assigned</h3>
    <h3>Available</h3>

// Bad - skipped levels
<h1>Event Details</h1>
  <h4>Schedule</h4>
```

### ARIA

Only use ARIA when semantic HTML isn't enough. shadcn components include appropriate ARIA attributes.

Common valid uses:

- `aria-label` for icon-only buttons
- `aria-describedby` for additional context
- `aria-live` for dynamic updates

```tsx
// Icon-only button needs label
<Button variant="ghost" size="icon" aria-label="Delete item">
	<Trash className="h-4 w-4" />
</Button>
```

### What We Don't Do

- Formal screen reader testing (rely on shadcn's tested components)
- WCAG AAA compliance
- Automated accessibility audits in CI (consider adding later)

This is pragmatic for a solo developer. If accessibility issues are reported, address them.
