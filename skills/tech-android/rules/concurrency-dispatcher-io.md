---
title: Use Dispatchers.IO for Blocking Operations
impact: HIGH
tags: coroutines, dispatchers, performance
---

## Use Dispatchers.IO for Blocking Operations

Run disk I/O, network calls, and other blocking work on `Dispatchers.IO`. Never block `Dispatchers.Main`.

**Incorrect (blocking the main thread):**

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
// Good - switch to IO for file reads
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

// Good - repository enforces its own dispatcher
class ApiRepository(
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) {
    suspend fun parseResponse(json: String): List<Item> {
        return withContext(ioDispatcher) {
            Json.decodeFromString(json)
        }
    }
}
```

**Dispatcher reference:**

| Dispatcher | Use for | Thread pool |
|-----------|---------|-------------|
| `Main` | UI updates, state emission | Main/UI thread |
| `IO` | Disk, network, database | Shared pool (64+ threads) |
| `Default` | CPU-heavy (sorting, parsing) | Core count threads |
| `Unconfined` | Testing only | Caller's thread |

**Why it matters:**
- Blocking Main causes ANR (Application Not Responding) dialogs after 5 seconds
- UI freezes degrade user experience and app store ratings
- Injecting dispatchers makes code testable with `TestDispatcher`
- `withContext` is cheap — it doesn't create a new coroutine

Reference: [Kotlin coroutines on Android](https://developer.android.com/kotlin/coroutines/coroutines-adv)
