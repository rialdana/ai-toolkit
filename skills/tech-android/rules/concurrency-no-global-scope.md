---
title: Never Use GlobalScope
impact: CRITICAL
tags: coroutines, lifecycle, memory-leak
---

## Never Use GlobalScope

`GlobalScope` launches coroutines that live for the entire process lifetime. They cannot be cancelled and are a source of memory leaks and wasted work.

**Incorrect (GlobalScope usage):**

```kotlin
// Bad - coroutine outlives the screen
class SearchViewModel : ViewModel() {
    fun search(query: String) {
        GlobalScope.launch {  // Runs forever, even after user leaves
            val results = repository.search(query)
            _results.value = results  // May update destroyed ViewModel
        }
    }
}

// Bad - GlobalScope in a click handler
@Composable
fun UploadButton(onUpload: suspend () -> Unit) {
    Button(onClick = {
        GlobalScope.launch { onUpload() }  // Untracked, uncancellable
    }) {
        Text("Upload")
    }
}

// Bad - GlobalScope for "fire-and-forget"
fun logAnalyticsEvent(event: AnalyticsEvent) {
    GlobalScope.launch {  // Seems harmless but accumulates
        analyticsService.send(event)
    }
}
```

**Correct (scoped alternatives):**

```kotlin
// Good - viewModelScope cancels with ViewModel
class SearchViewModel : ViewModel() {
    fun search(query: String) {
        viewModelScope.launch {
            val results = repository.search(query)
            _results.value = results
        }
    }
}

// Good - rememberCoroutineScope for composables
@Composable
fun UploadButton(onUpload: suspend () -> Unit) {
    val scope = rememberCoroutineScope()
    Button(onClick = {
        scope.launch { onUpload() }  // Cancelled when leaving composition
    }) {
        Text("Upload")
    }
}

// Good - application-scoped work uses a custom scope
class AnalyticsLogger(
    private val analyticsService: AnalyticsService,
    private val scope: CoroutineScope  // Injected, testable, cancellable
) {
    fun logEvent(event: AnalyticsEvent) {
        scope.launch { analyticsService.send(event) }
    }
}
```

**Why it matters:**
- `GlobalScope` coroutines survive configuration changes and back navigation
- No way to cancel them — leads to wasted network/CPU after user leaves
- Can crash by updating UI state of destroyed components
- Violates structured concurrency principles

Reference: [GlobalScope — Kotlin docs](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-global-scope/)
