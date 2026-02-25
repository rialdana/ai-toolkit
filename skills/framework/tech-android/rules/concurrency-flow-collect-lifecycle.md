---
title: Collect Flows with Lifecycle Awareness
impact: HIGH
tags: coroutines, flow, lifecycle, compose
---

## Collect Flows with Lifecycle Awareness

Use `collectAsStateWithLifecycle` in Compose (or `repeatOnLifecycle` in Views) to stop collecting when the UI is not visible.

**Incorrect (lifecycle-unaware collection):**

```kotlin
// Bad - collectAsState keeps collecting when app is backgrounded
@Composable
fun LocationScreen(viewModel: LocationViewModel) {
    val location by viewModel.locationFlow.collectAsState()  // Collects in background!
    Text("Lat: ${location.lat}, Lng: ${location.lng}")
}

// Bad - collecting in lifecycleScope without repeatOnLifecycle
class LocationActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        lifecycleScope.launch {
            viewModel.locationFlow.collect { location ->
                // Keeps collecting when Activity is STOPPED (in background)
                updateUI(location)
            }
        }
    }
}
```

**Correct (lifecycle-aware collection):**

```kotlin
// Good - stops collecting when Compose lifecycle < STARTED
@Composable
fun LocationScreen(viewModel: LocationViewModel) {
    val location by viewModel.locationFlow.collectAsStateWithLifecycle()
    Text("Lat: ${location.lat}, Lng: ${location.lng}")
}

// Good - repeatOnLifecycle in View system
class LocationActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        lifecycleScope.launch {
            repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.locationFlow.collect { location ->
                    // Only collects when STARTED or RESUMED
                    updateUI(location)
                }
            }
        }
    }
}
```

**Why it matters:**
- Background collection wastes battery (GPS, network, sensors keep running)
- Processing UI updates for invisible screens is wasted work
- `collectAsState` does not respect lifecycle — only `collectAsStateWithLifecycle` does
- `repeatOnLifecycle` restarts collection each time lifecycle reaches the target state

Reference: [collectAsStateWithLifecycle](https://developer.android.com/reference/kotlin/androidx/lifecycle/compose/package-summary#collectAsStateWithLifecycle)
