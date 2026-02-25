---
title: Provide Content Descriptions for Non-Text Elements
impact: HIGH
tags: accessibility, compose, screen-reader
---

## Provide Content Descriptions for Non-Text Elements

Every meaningful non-text element (icons, images, buttons without text) must have a content description for screen readers.

**Incorrect (missing content descriptions):**

```kotlin
// Bad - icon button with no description
IconButton(onClick = { onDelete() }) {
    Icon(Icons.Default.Delete, contentDescription = null) // Silent to TalkBack!
}

// Bad - decorative image announced with filename
Image(
    painter = painterResource(R.drawable.hero_banner),
    contentDescription = "hero_banner"  // Meaningless to users
)

// Bad - clickable row with no semantics
Row(modifier = Modifier.clickable { navigateToProfile() }) {
    Icon(Icons.Default.Person, contentDescription = null)
    Text("View Profile")
}
```

**Correct (proper content descriptions):**

```kotlin
// Good - meaningful description for action icon
IconButton(onClick = { onDelete() }) {
    Icon(Icons.Default.Delete, contentDescription = "Delete item")
}

// Good - decorative image marked as such
Image(
    painter = painterResource(R.drawable.hero_banner),
    contentDescription = null  // null = decorative, skipped by TalkBack
)

// Good - clickable row with merged semantics
Row(
    modifier = Modifier
        .semantics(mergeDescendants = true) { }
        .clickable { navigateToProfile() }
) {
    Icon(Icons.Default.Person, contentDescription = null) // Merged with text
    Text("View Profile")
}
```

**Decision guide:**
- **Actionable icon** → describe the action ("Delete item", "Open menu")
- **Informational image** → describe the content ("Photo of sunset over ocean")
- **Decorative image** → set `contentDescription = null`
- **Clickable row with text** → use `mergeDescendants = true`

**Why it matters:**
- TalkBack users cannot interact with unlabeled elements
- Meaningless descriptions (filenames, "icon") confuse users
- Decorative elements announced as content waste time
- Required for WCAG 2.1 Level A compliance

Reference: [Accessibility in Compose](https://developer.android.com/develop/ui/compose/accessibility)
