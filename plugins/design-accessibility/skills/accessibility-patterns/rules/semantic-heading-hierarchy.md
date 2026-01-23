---
title: Use Proper Heading Hierarchy
impact: MEDIUM
tags: semantic, headings, structure
---

## Use Proper Heading Hierarchy

One `<h1>` per page. Headings should nest logically without skipping levels.

**Incorrect (skipped levels):**

```tsx
// Bad - skipped h2, h3
<h1>Dashboard</h1>
<h4>Recent Activity</h4>  {/* Skipped h2, h3! */}
<h6>Today</h6>            {/* Skipped h5! */}

// Bad - multiple h1s
<h1>Company Name</h1>
<h1>Page Title</h1>       {/* Two h1s! */}
```

**Correct (logical hierarchy):**

```tsx
// Good - proper nesting
<h1>Event Details</h1>
  <h2>Schedule</h2>
    <h3>Day 1</h3>
    <h3>Day 2</h3>
  <h2>Staff</h2>
    <h3>Assigned</h3>
    <h3>Available</h3>

// Visual size doesn't affect semantics - use CSS
<h2 className="text-sm">Section Title</h2>  {/* OK - small h2 */}
```

**Heading outline example:**

```
h1: Event Details
├── h2: Schedule
│   ├── h3: Day 1
│   └── h3: Day 2
├── h2: Staff
│   ├── h3: Assigned
│   └── h3: Available
└── h2: Location
```

**Why it matters:**
- Screen reader users navigate by headings
- Skipped levels confuse the document structure
- Search engines use heading hierarchy
- WCAG 1.3.1 requires meaningful structure

Reference: [WCAG 2.4.6 Headings and Labels](https://www.w3.org/WAI/WCAG21/Understanding/headings-and-labels.html)
