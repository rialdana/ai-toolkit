---
title: First Rule of ARIA - Don't Use ARIA
impact: MEDIUM
tags: aria, semantic, html
---

## First Rule of ARIA - Don't Use ARIA

Use native HTML elements before reaching for ARIA. ARIA is for when HTML isn't sufficient.

**The rules of ARIA:**

1. Don't use ARIA if you can use native HTML
2. Don't change native semantics unless necessary
3. All interactive ARIA elements must be keyboard accessible
4. Don't use `role="presentation"` or `aria-hidden="true"` on focusable elements
5. All interactive elements must have an accessible name

**Incorrect (unnecessary ARIA):**

```tsx
// Bad - ARIA when HTML works
<div role="button" tabIndex={0} onClick={onClick}>
  Click me
</div>

// Bad - redundant ARIA
<button role="button">Submit</button>
<a href="/home" role="link">Home</a>
<nav role="navigation">...</nav>
```

**Correct (native HTML):**

```tsx
// Good - native button
<button onClick={onClick}>Click me</button>

// Good - no redundant roles
<button>Submit</button>
<a href="/home">Home</a>
<nav>...</nav>
```

**When ARIA is appropriate:**

```tsx
// Custom disclosure widget
<button
  aria-expanded={isOpen}
  aria-controls="panel-content"
  onClick={() => setIsOpen(!isOpen)}
>
  Show details
</button>
<div id="panel-content" hidden={!isOpen}>
  Content here
</div>

// Live region for dynamic updates
<div aria-live="polite">
  {statusMessage}
</div>

// Describing related content
<input
  aria-describedby="password-hint"
/>
<p id="password-hint">Must be at least 8 characters</p>
```

**Why it matters:**
- ARIA can break accessibility if misused
- Native elements have built-in support
- Less code, fewer bugs
- ARIA requires careful implementation

Reference: [Using ARIA](https://www.w3.org/TR/using-aria/)
