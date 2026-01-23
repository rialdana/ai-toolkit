---
title: Use Button Elements for Actions
impact: HIGH
tags: semantic, interactive, buttons
---

## Use Button Elements for Actions

Use `<button>` for clickable actions. Never use divs or spans with click handlers.

**Incorrect (div as button):**

```tsx
// Bad - div with click handler
<div onClick={handleSubmit} className="btn">Submit</div>

// Problems:
// - Not in tab order (can't Tab to it)
// - No keyboard activation (Enter/Space don't work)
// - Screen readers don't announce as button
// - No :focus or :disabled states
```

**Correct (native button):**

```tsx
// Good - real button element
<button onClick={handleSubmit} className="btn">Submit</button>

// Or with component library
<Button onClick={handleSubmit}>Submit</Button>

// Disabled state works correctly
<button onClick={handleSubmit} disabled={isLoading}>
  {isLoading ? 'Saving...' : 'Submit'}
</button>
```

**Button vs Link:**

| Action | Element |
|--------|---------|
| Performs action (submit, delete, toggle) | `<button>` |
| Navigates to URL | `<a>` or Link component |
| Opens external site | `<a target="_blank">` |

**Why it matters:**
- 15% of users rely on keyboard navigation
- Screen readers announce "button" for assistive tech
- Built-in keyboard support (Enter, Space)
- Native disabled, focus states

Reference: [WCAG 2.1.1 Keyboard](https://www.w3.org/WAI/WCAG21/Understanding/keyboard.html)
