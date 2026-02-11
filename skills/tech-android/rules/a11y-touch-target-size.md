---
title: Ensure Minimum 48dp Touch Targets
impact: MEDIUM
tags: accessibility, compose, touch
---

## Ensure Minimum 48dp Touch Targets

All interactive elements must have a minimum touch target of 48×48dp, regardless of visual size.

**Incorrect (small touch targets):**

```kotlin
// Bad - icon is 24dp with no touch padding
Icon(
    Icons.Default.Close,
    contentDescription = "Close",
    modifier = Modifier
        .size(24.dp)
        .clickable { onClose() }  // Touch target = 24dp, too small!
)

// Bad - text button with tight padding
TextButton(
    onClick = { onRetry() },
    modifier = Modifier.height(32.dp),  // Below 48dp minimum
    contentPadding = PaddingValues(4.dp)
) {
    Text("Retry", style = MaterialTheme.typography.bodySmall)
}
```

**Correct (48dp+ touch targets):**

```kotlin
// Good - IconButton automatically ensures 48dp touch target
IconButton(onClick = { onClose() }) {
    Icon(
        Icons.Default.Close,
        contentDescription = "Close",
        modifier = Modifier.size(24.dp)  // Visual size is 24dp
    )
    // IconButton provides 48dp touch target automatically
}

// Good - explicit minimum touch target via sizeIn
Icon(
    Icons.Default.Close,
    contentDescription = "Close",
    modifier = Modifier
        .sizeIn(minWidth = 48.dp, minHeight = 48.dp)
        .clickable { onClose() }
)

// Good - standard Material button (already meets minimum)
TextButton(onClick = { onRetry() }) {
    Text("Retry")
}
```

**Why it matters:**
- Users with motor impairments cannot reliably tap small targets
- Material Design guidelines require 48dp minimum
- Required for WCAG 2.5.5 (Target Size) compliance
- Improves usability for all users, not just those with disabilities

Reference: [Accessibility — Touch target size](https://developer.android.com/develop/ui/compose/accessibility#touch-target-size)
