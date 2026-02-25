---
title: Avoid Unstable Lambda Allocations in Composables
impact: HIGH
tags: compose, performance, recomposition
---

## Avoid Unstable Lambda Allocations in Composables

Lambdas that capture unstable references cause unnecessary recompositions. Use method references or remembered lambdas to keep composables skippable.

**Incorrect (new lambda allocation every recomposition):**

```kotlin
// Bad - lambda captures 'viewModel' which is unstable
@Composable
fun ItemList(viewModel: ListViewModel) {
    val items by viewModel.items.collectAsStateWithLifecycle()

    LazyColumn {
        items(items, key = { it.id }) { item ->
            ItemRow(
                item = item,
                // New lambda instance every recomposition — ItemRow always recomposes
                onDelete = { viewModel.deleteItem(item.id) }
            )
        }
    }
}

// Bad - inline lambda wrapping a method call
Button(onClick = { viewModel.submit() }) {  // New lambda each time
    Text("Submit")
}
```

**Correct (stable lambda references):**

```kotlin
// Good - hoist callback to avoid capture inside lazy scope
@Composable
fun ItemList(viewModel: ListViewModel) {
    val items by viewModel.items.collectAsStateWithLifecycle()
    val onDelete = viewModel::deleteItem  // Stable method reference

    LazyColumn {
        items(items, key = { it.id }) { item ->
            ItemRow(
                item = item,
                onDelete = { onDelete(item.id) }
            )
        }
    }
}

// Good - method reference for simple cases
Button(onClick = viewModel::submit) {
    Text("Submit")
}

// Good - remember lambda when it captures stable values
@Composable
fun ItemRow(item: Item, onDelete: (String) -> Unit) {
    val handleDelete = remember(item.id) { { onDelete(item.id) } }
    IconButton(onClick = handleDelete) {
        Icon(Icons.Default.Delete, contentDescription = "Delete")
    }
}
```

**Why it matters:**
- Unstable lambdas prevent Compose from skipping unchanged composables
- In LazyColumn, this means every visible row recomposes on any state change
- Method references and remembered lambdas are referentially stable
- Compose compiler reports help identify skippability issues

Reference: [Jetpack Compose stability explained](https://developer.android.com/develop/ui/compose/performance/stability)
