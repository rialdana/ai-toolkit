---
title: Ensure Sufficient Color Contrast
impact: MEDIUM
tags: visual, color, contrast
---

## Ensure Sufficient Color Contrast

Text must have sufficient contrast against its background. WCAG AA requires 4.5:1 for normal text, 3:1 for large text.

**WCAG 2.1 AA Requirements:**

| Text Size | Minimum Ratio |
|-----------|---------------|
| Normal text (< 18pt) | 4.5:1 |
| Large text (≥ 18pt or 14pt bold) | 3:1 |
| UI components, graphics | 3:1 |

**Incorrect (low contrast):**

```tsx
// Bad - light gray on white (approximately 2:1)
<p className="text-gray-400 bg-white">Hard to read</p>

// Bad - placeholder text too light
<input placeholder="Email" className="placeholder:text-gray-300" />
```

**Correct (sufficient contrast):**

```tsx
// Good - using design system tokens
<p className="text-foreground bg-background">Clear to read</p>
<p className="text-muted-foreground">Secondary text (still accessible)</p>

// Good - checking contrast
// Use browser DevTools or contrast checker tools
// text-gray-600 on white ≈ 5.7:1 ✓
```

**Don't rely on color alone:**

```tsx
// Bad - color only indicates error
<span className="text-red-500">Error</span>

// Good - icon reinforces meaning
<span className="text-destructive flex items-center gap-1">
  <AlertCircle className="h-4 w-4" />
  Error
</span>
```

**Tools to check contrast:**

- Browser DevTools (color picker shows contrast)
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- Figma plugins (Contrast, Stark)

**Why it matters:**
- 8% of men have color vision deficiency
- Low vision users need high contrast
- Required for WCAG 2.1 Level AA
- Good contrast helps everyone in poor lighting

Reference: [WCAG 1.4.3 Contrast (Minimum)](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
