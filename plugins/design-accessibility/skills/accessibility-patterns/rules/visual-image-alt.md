---
title: Provide Alt Text for Images
impact: MEDIUM
tags: visual, images, alt-text
---

## Provide Alt Text for Images

Informative images need descriptive alt text. Decorative images should have empty alt.

**Incorrect (missing or bad alt):**

```tsx
// Bad - no alt
<img src={user.avatar} />

// Bad - filename as alt
<img src="/IMG_1234.jpg" alt="IMG_1234.jpg" />

// Bad - redundant
<img src="/logo.png" alt="image of our logo" />
```

**Correct (appropriate alt):**

```tsx
// Informative - describe the content
<img src={user.avatar} alt={`${user.name}'s profile photo`} />
<img src="/chart.png" alt="Sales growth chart showing 25% increase in Q4" />

// Decorative - empty alt (not omitted!)
<img src="/decorative-pattern.svg" alt="" />

// Image in link - describe the destination
<a href="/profile">
  <img src="/avatar.jpg" alt="View your profile" />
</a>
```

**Alt text guidelines:**

| Image Type | Alt Text |
|------------|----------|
| Photo of person | "[Name]" or "[Name]'s profile photo" |
| Product image | "[Product name] - [key details]" |
| Chart/graph | Describe the data shown |
| Decorative | Empty string: `alt=""` |
| Icon with text | Empty (text provides meaning) |
| Icon-only button | Describe the action |

**Icons with adjacent text:**

```tsx
// Icon is decorative - text provides meaning
<button>
  <Trash aria-hidden="true" />
  Delete
</button>
// Screen reader: "Delete, button"
```

**Why it matters:**
- Screen readers announce alt text
- Alt text displays if image fails to load
- Search engines use alt for indexing
- Required for WCAG 1.1.1 Non-text Content

Reference: [WCAG 1.1.1 Non-text Content](https://www.w3.org/WAI/WCAG21/Understanding/non-text-content.html)
