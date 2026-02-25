---
title: Choose the Correct Dispatcher for Each Operation
impact: HIGH
tags: coroutines, dispatchers, performance, threading
---

## Choose the Correct Dispatcher for Each Operation

Use `Dispatchers.Main` for UI updates, `Dispatchers.IO` for disk/network/database operations, and `Dispatchers.Default` for CPU-intensive work. Never block `Dispatchers.Main`, and don't misuse one dispatcher for another's workload.

**Incorrect (blocking Main and misusing dispatchers):**

```kotlin
// Bad - blocking call on Main dispatcher
class FileViewModel : ViewModel() {
    fun readLog() {
        viewModelScope.launch {  // Defaults to Dispatchers.Main
            val content = File("/data/app/log.txt").readText()  // Blocks UI!
            _logContent.value = content
        }
    }
}

// Bad - CPU-heavy work on IO (wastes the larger IO thread pool)
class SortViewModel : ViewModel() {
    fun sortItems(items: List<Item>) {
        viewModelScope.launch {
            val sorted = withContext(Dispatchers.IO) {  // Wrong dispatcher!
                items.sortedByDescending { it.score }   // CPU-bound, not blocking I/O
            }
            _sortedItems.value = sorted
        }
    }
}

// Bad - JSON parsing on Main
class ApiRepository {
    suspend fun parseResponse(json: String): List<Item> {
        // This runs on whatever dispatcher the caller uses
        return Json.decodeFromString(json)  // CPU-intensive on Main
    }
}
```

**Correct (proper dispatcher usage):**

```kotlin
// Good - IO for file reads
class FileViewModel : ViewModel() {
    fun readLog() {
        viewModelScope.launch {
            val content = withContext(Dispatchers.IO) {
                File("/data/app/log.txt").readText()
            }
            _logContent.value = content  // Back on Main for UI update
        }
    }
}

// Good - Default for CPU-bound sorting
class SortViewModel : ViewModel() {
    fun sortItems(items: List<Item>) {
        viewModelScope.launch {
            val sorted = withContext(Dispatchers.Default) {
                items.sortedByDescending { it.score }  // CPU work on Default
            }
            _sortedItems.value = sorted  // Back on Main for UI update
        }
    }
}

// Good - repository enforces its own dispatcher
class ApiRepository(
    private val defaultDispatcher: CoroutineDispatcher = Dispatchers.Default
) {
    suspend fun parseResponse(json: String): List<Item> {
        return withContext(defaultDispatcher) {
            Json.decodeFromString(json)  // CPU-intensive parsing on Default
        }
    }
}
```

**Dispatcher reference:**

| Dispatcher | Use for | Thread pool | Examples |
|-----------|---------|-------------|----------|
| `Main` | UI updates, state emission, lightweight work | Main/UI thread (single) | Updating `StateFlow`, navigating, showing snackbars |
| `IO` | Disk, network, database — blocking I/O | Shared pool (64+ threads) | File reads, Retrofit calls, Room queries, SharedPreferences |
| `Default` | CPU-heavy computation | Core count threads | Sorting large lists, JSON parsing, image processing, regex |
| `Unconfined` | Testing only | Caller's thread | Unit tests with `runTest` |

> **Rule of thumb:** If the operation waits for something external (disk, network), use `IO`. If it crunches data in memory, use `Default`. If it touches the UI, stay on `Main`.

**Why it matters:**
- Blocking Main causes ANR (Application Not Responding) dialogs after 5 seconds
- UI freezes degrade user experience and app store ratings
- Using IO for CPU-bound work wastes threads — Default's pool is sized to CPU cores for optimal throughput
- Injecting dispatchers makes code testable with `TestDispatcher`
- `withContext` is cheap — it doesn't create a new coroutine

Reference: [Kotlin coroutines on Android](https://developer.android.com/kotlin/coroutines/coroutines-adv)
