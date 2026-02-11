---
title: Use Turbine for Testing Flow Emissions
impact: MEDIUM
tags: testing, flow, turbine
---

## Use Turbine for Testing Flow Emissions

Use the Turbine library to test Flow emissions with clear, sequential assertions instead of manual collection with `toList()` or `first()`.

**Incorrect (manual flow collection):**

```kotlin
// Bad - collecting to list, timing-dependent
@Test
fun searchResults_emitFiltered() = runTest {
    val viewModel = SearchViewModel(FakeRepository())
    viewModel.search("kotlin")

    // Fragile — depends on timing, may miss emissions or collect too many
    val results = viewModel.results.take(1).toList()
    assertEquals(3, results.first().size)
}

// Bad - using first() with timeout
@Test
fun loading_stateTransitions() = runTest {
    val viewModel = DataViewModel(FakeRepository())
    viewModel.load()

    // Only checks final state, misses intermediate Loading state
    val state = viewModel.uiState.first { it is UiState.Success }
    assertTrue(state is UiState.Success)
}
```

**Correct (Turbine for sequential assertions):**

```kotlin
// Good - Turbine asserts emissions in order
@Test
fun search_emitsLoadingThenResults() = runTest {
    val viewModel = SearchViewModel(FakeRepository())

    viewModel.results.test {
        viewModel.search("kotlin")

        assertEquals(emptyList(), awaitItem())        // Initial state
        assertEquals(3, awaitItem().size)              // Search results

        cancelAndIgnoreRemainingEvents()
    }
}

// Good - test state transitions
@Test
fun load_transitionsThroughStates() = runTest {
    val viewModel = DataViewModel(FakeRepository())

    viewModel.uiState.test {
        assertEquals(UiState.Idle, awaitItem())        // Initial

        viewModel.load()

        assertEquals(UiState.Loading, awaitItem())     // Loading
        val success = awaitItem()                       // Success
        assertIs<UiState.Success>(success)
        assertEquals(5, success.items.size)

        cancelAndIgnoreRemainingEvents()
    }
}

// Good - test error handling
@Test
fun load_emitsErrorOnFailure() = runTest {
    val repo = FakeRepository(shouldFail = true)
    val viewModel = DataViewModel(repo)

    viewModel.uiState.test {
        skipItems(1)  // Skip initial Idle state

        viewModel.load()

        assertEquals(UiState.Loading, awaitItem())
        val error = awaitItem()
        assertIs<UiState.Error>(error)
        assertEquals("Network error", error.message)

        cancelAndIgnoreRemainingEvents()
    }
}
```

**Key Turbine APIs:**

| Method | Purpose |
|--------|---------|
| `awaitItem()` | Wait for and return next emission |
| `skipItems(n)` | Skip `n` emissions |
| `awaitComplete()` | Assert the Flow completed |
| `awaitError()` | Assert the Flow threw |
| `cancelAndIgnoreRemainingEvents()` | Clean up |
| `expectNoEvents()` | Assert nothing was emitted |

**Why it matters:**
- `toList()` / `first()` are timing-sensitive and miss intermediate states
- Turbine asserts each emission sequentially — catches regressions in state ordering
- Timeout errors from Turbine clearly identify which emission was missing
- Tests document the exact sequence of state transitions

Reference: [Turbine](https://github.com/cashapp/turbine)
