---
title: Always Provide Stable Keys to Lazy Lists
impact: HIGH
tags: compose, performance, lazy-list
---

## Always Provide Stable Keys to Lazy Lists

Always provide a stable, unique `key` parameter to `items()` in `LazyColumn` and `LazyRow`. Without keys, Compose uses positional index and cannot efficiently handle reordering, insertion, or deletion.

**Incorrect (no keys or unstable keys):**

```kotlin
// Bad - no key, defaults to positional index
LazyColumn {
    items(messages) { message ->
        MessageRow(message)
        // Inserting at top causes ALL rows to recompose
    }
}

// Bad - index as key
LazyColumn {
    items(messages.size) { index ->
        MessageRow(messages[index])
        // Same problem — index shifts when items move
    }
}
```

**Correct (stable unique keys):**

```kotlin
// Good - unique ID as key
LazyColumn {
    items(messages, key = { it.id }) { message ->
        MessageRow(message)
        // Only new/changed items recompose
    }
}

// Good - composite key when no single ID
LazyColumn {
    items(chatEntries, key = { "${it.date}-${it.senderId}" }) { entry ->
        ChatBubble(entry)
    }
}

// Good - with itemsIndexed when index is also needed
LazyColumn {
    itemsIndexed(messages, key = { _, msg -> msg.id }) { index, message ->
        MessageRow(position = index + 1, message = message)
    }
}
```

**Benefits of stable keys:**
- Compose reuses compositions when items reorder instead of recreating
- `animateItem()` modifier works correctly for insert/remove/reorder animations
- Internal component state (focus, scroll, text input) follows the item, not the position
- Dramatically reduces recompositions for large, dynamic lists

**Why it matters:**
- Without keys, adding one item at the top recomposes every row
- Component state (expanded, selected, text input) drifts to wrong items
- Animations break without stable identity
- Performance degrades linearly with list size

Reference: [Lists and grids — Item keys](https://developer.android.com/develop/ui/compose/lists#item-keys)
