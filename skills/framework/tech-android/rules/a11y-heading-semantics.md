---
title: Mark Headings with Semantic Properties
impact: MEDIUM
tags: accessibility, compose, semantics
---

## Mark Headings with Semantic Properties

Use the `heading()` semantic property so TalkBack users can navigate between sections with swipe gestures.

**Incorrect (no heading semantics):**

```kotlin
// Bad - visually styled as heading but no semantics
Text(
    text = "Account Settings",
    style = MaterialTheme.typography.headlineMedium
    // TalkBack reads this as plain text — users can't jump to it
)

// Bad - using role incorrectly
Text(
    text = "Account Settings",
    modifier = Modifier.semantics { role = Role.Button }  // Wrong role!
)
```

**Correct (semantic headings):**

```kotlin
// Good - semantic heading property
Text(
    text = "Account Settings",
    style = MaterialTheme.typography.headlineMedium,
    modifier = Modifier.semantics { heading() }
)

// Good - section headings in a settings screen
@Composable
fun SettingsScreen() {
    LazyColumn {
        item {
            Text(
                text = "General",
                style = MaterialTheme.typography.titleLarge,
                modifier = Modifier.semantics { heading() }
            )
        }
        // ... general settings items

        item {
            Text(
                text = "Privacy",
                style = MaterialTheme.typography.titleLarge,
                modifier = Modifier.semantics { heading() }
            )
        }
        // ... privacy settings items
    }
}
```

**When to apply `heading()`:**
- Screen titles
- Section headers in lists or forms
- Category labels that group related content
- Any text visually styled as a heading (`headlineMedium`, `titleLarge`, etc.)

**Why it matters:**
- TalkBack users navigate by headings (swipe up/down in heading mode)
- Without heading semantics, users must listen through every item sequentially
- Improves screen comprehension for long, sectioned content
- Mirrors the `<h1>`–`<h6>` pattern from web accessibility

Reference: [Accessibility in Compose — Headings](https://developer.android.com/develop/ui/compose/accessibility#headings)
