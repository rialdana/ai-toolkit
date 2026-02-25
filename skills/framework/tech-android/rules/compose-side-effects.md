---
title: Use Side Effect Handlers Correctly
impact: HIGH
tags: compose, side-effects, launched-effect, lifecycle
---

## Use Side Effect Handlers Correctly

Use `LaunchedEffect`, `DisposableEffect`, and `SideEffect` to safely perform side effects from composables. Never launch coroutines or register listeners directly in the composition body.

**Incorrect (side effects in composition):**

```kotlin
// Bad - coroutine launched on every recomposition
@Composable
fun UserProfile(userId: String) {
    val scope = rememberCoroutineScope()
    // Launches a NEW coroutine on EVERY recomposition!
    scope.launch { viewModel.loadUser(userId) }
    // ...
}

// Bad - listener registered without cleanup
@Composable
fun SensorScreen(sensorManager: SensorManager) {
    val listener = object : SensorEventListener { /* ... */ }
    // Registers on every recomposition, never unregisters!
    sensorManager.registerListener(listener, sensor, SENSOR_DELAY_NORMAL)
}

// Bad - analytics fired on every recomposition
@Composable
fun CheckoutScreen() {
    analytics.logScreenView("checkout")  // Fires on every recomposition!
}
```

**Correct (proper side effect handlers):**

```kotlin
// Good - LaunchedEffect runs once per key, cancels on key change or leave
@Composable
fun UserProfile(userId: String) {
    LaunchedEffect(userId) {  // Re-launches only when userId changes
        viewModel.loadUser(userId)
    }
}

// Good - DisposableEffect for register/unregister patterns
@Composable
fun SensorScreen(sensorManager: SensorManager) {
    DisposableEffect(Unit) {
        val listener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent) { /* ... */ }
            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) { }
        }
        sensorManager.registerListener(listener, sensor, SENSOR_DELAY_NORMAL)

        onDispose {
            sensorManager.unregisterListener(listener)  // Cleanup guaranteed
        }
    }
}

// Good - SideEffect for non-suspend code that must run after every commit
@Composable
fun CheckoutScreen() {
    SideEffect {
        // Runs after every successful recomposition (not during)
        analytics.logScreenView("checkout")
    }
}

// Good - LaunchedEffect with snapshotFlow for reacting to state changes
@Composable
fun ScrollTracker(listState: LazyListState) {
    LaunchedEffect(listState) {
        snapshotFlow { listState.firstVisibleItemIndex }
            .distinctUntilChanged()
            .collect { index ->
                analytics.logScroll(index)
            }
    }
}
```

**Side effect handler reference:**

| Handler | Suspend? | Cleanup? | Use case |
|---------|----------|----------|----------|
| `LaunchedEffect(key)` | Yes | Auto-cancels on key change/leave | One-shot loads, snapshotFlow |
| `DisposableEffect(key)` | No | `onDispose` block | Register/unregister listeners |
| `SideEffect` | No | None | Sync Compose state to non-Compose code |
| `rememberCoroutineScope` | Yes | Cancels on leave | User-triggered events (onClick) |

**Why it matters:**
- Side effects in the composition body run on every recomposition — unpredictable frequency
- Missing cleanup leaks listeners, observers, and callbacks
- `LaunchedEffect` ties coroutine lifetime to composition and key changes
- Using the wrong handler leads to duplicate work, leaks, or missed cleanup

Reference: [Side effects in Compose](https://developer.android.com/develop/ui/compose/side-effects)
