---
title: Use derivedStateOf for Expensive Computations on State
impact: MEDIUM
tags: compose, state, performance
---

## Use derivedStateOf for Expensive Computations on State

When a composable needs a value derived from state, use `derivedStateOf` to avoid recomputing on every recomposition.

**Incorrect (recomputing derived value every recomposition):**

```kotlin
// Bad - filtering runs on every recomposition, even if 'items' hasn't changed
@Composable
fun TaskList(viewModel: TaskViewModel) {
    val items by viewModel.items.collectAsStateWithLifecycle()
    val showCompleted by viewModel.showCompleted.collectAsStateWithLifecycle()

    // Runs every recomposition, not just when inputs change
    val filteredItems = if (showCompleted) items else items.filter { !it.completed }

    LazyColumn {
        items(filteredItems, key = { it.id }) { task ->
            TaskRow(task)
        }
    }
}
```

**Correct (derivedStateOf caches until inputs change):**

```kotlin
// Good - only recomputes when 'items' or 'showCompleted' changes
@Composable
fun TaskList(viewModel: TaskViewModel) {
    val items by viewModel.items.collectAsStateWithLifecycle()
    val showCompleted by viewModel.showCompleted.collectAsStateWithLifecycle()

    val filteredItems by remember(items, showCompleted) {
        derivedStateOf {
            if (showCompleted) items else items.filter { !it.completed }
        }
    }

    LazyColumn {
        items(filteredItems, key = { it.id }) { task ->
            TaskRow(task)
        }
    }
}

// Good - derived state for scroll-dependent UI
@Composable
fun ScrollToTopButton(listState: LazyListState) {
    val showButton by remember {
        derivedStateOf { listState.firstVisibleItemIndex > 0 }
    }

    AnimatedVisibility(visible = showButton) {
        FloatingActionButton(onClick = { /* scroll to top */ }) {
            Icon(Icons.Default.ArrowUpward, contentDescription = "Scroll to top")
        }
    }
}
```

**When to use `derivedStateOf`:**
- Filtering or transforming a list based on state
- Boolean derived from frequently-changing state (scroll position, text length)
- Any computation where the input changes more often than the output

**When NOT to use it:**
- Simple property access (`uiState.name`) — no computation to cache
- One-to-one mapping — output changes every time input changes

**Why it matters:**
- Prevents expensive recomputations on unrelated state changes
- `derivedStateOf` only triggers recomposition when the derived value actually changes
- Critical for scroll-based UI where `listState` changes on every frame
- Reduces unnecessary LazyColumn recompositions

Reference: [derivedStateOf](https://developer.android.com/develop/ui/compose/side-effects#derivedstateof)
