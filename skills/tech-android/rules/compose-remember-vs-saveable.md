---
title: Use remember and rememberSaveable Correctly
impact: HIGH
tags: compose, state, remember, configuration-change
---

## Use remember and rememberSaveable Correctly

Use `remember` for state that can be lost on configuration change, and `rememberSaveable` for state that must survive rotation, process death, or back stack restoration.

**Incorrect (wrong remember variant):**

```kotlin
// Bad - user input lost on rotation
@Composable
fun SearchBar(onSearch: (String) -> Unit) {
    var query by remember { mutableStateOf("") }  // Gone after rotation!
    TextField(
        value = query,
        onValueChange = { query = it },
        placeholder = { Text("Search...") }
    )
}

// Bad - rememberSaveable for derived/expensive state
@Composable
fun FilteredList(items: List<Item>) {
    // Wasteful — recomputable from 'items', not user state
    val sorted by rememberSaveable { mutableStateOf(items.sortedBy { it.name }) }
    LazyColumn { items(sorted) { ItemRow(it) } }
}

// Bad - remember without key, stale closure
@Composable
fun UserGreeting(userId: String) {
    // Bug — callback captures first userId, never updates
    val greet = remember {
        { "Hello, user $userId" }
    }
    Text(greet())
}
```

**Correct (appropriate remember variant):**

```kotlin
// Good - rememberSaveable for user input that must survive rotation
@Composable
fun SearchBar(onSearch: (String) -> Unit) {
    var query by rememberSaveable { mutableStateOf("") }
    TextField(
        value = query,
        onValueChange = { query = it },
        placeholder = { Text("Search...") }
    )
}

// Good - remember for derived/expensive computation
@Composable
fun FilteredList(items: List<Item>) {
    val sorted = remember(items) { items.sortedBy { it.name } }
    LazyColumn { items(sorted) { ItemRow(it) } }
}

// Good - remember with key to track parameter changes
@Composable
fun UserGreeting(userId: String) {
    val greet = remember(userId) {
        { "Hello, user $userId" }
    }
    Text(greet())
}

// Good - rememberSaveable with custom Saver for complex types
@Composable
fun DatePicker() {
    var selectedDate by rememberSaveable(stateSaver = localDateSaver) {
        mutableStateOf(LocalDate.now())
    }
}

val localDateSaver = Saver<LocalDate, Long>(
    save = { it.toEpochDay() },
    restore = { LocalDate.ofEpochDay(it) }
)
```

**Decision guide:**

| Scenario | Use |
|----------|-----|
| User-typed text, toggle state, scroll position | `rememberSaveable` |
| Computed/derived values from parameters | `remember(key)` |
| Expensive object creation (Regex, Formatter) | `remember` |
| Animation state | `remember` (via `Animatable`, `animate*AsState`) |
| Objects not `Parcelable`/`Serializable` | `rememberSaveable` with custom `Saver` |

**Why it matters:**
- `remember` only survives recomposition — lost on rotation, process death, and back stack restore
- `rememberSaveable` persists through configuration changes and process death via `Bundle`
- Missing `key` parameter causes stale closures and bugs when inputs change
- Over-using `rememberSaveable` wastes serialization work on recomputable state

Reference: [State in Compose — rememberSaveable](https://developer.android.com/develop/ui/compose/state#restore-ui-state)
