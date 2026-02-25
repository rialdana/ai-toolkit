---
title: Use Structured Concurrency with viewModelScope/lifecycleScope
impact: CRITICAL
tags: coroutines, lifecycle, structured-concurrency
---

## Use Structured Concurrency with viewModelScope/lifecycleScope

Always launch coroutines in a lifecycle-aware scope. This ensures automatic cancellation when the ViewModel or lifecycle owner is destroyed.

**Incorrect (unstructured coroutine launch):**

```kotlin
// Bad - manual CoroutineScope with no cancellation
class ProfileViewModel : ViewModel() {
    private val scope = CoroutineScope(Dispatchers.Main) // Never cancelled!

    fun loadProfile() {
        scope.launch {
            val user = repository.getUser()  // Runs even after ViewModel cleared
            _uiState.value = ProfileUiState(user)
        }
    }
}

// Bad - launching in init without scope management
class OrderViewModel : ViewModel() {
    init {
        CoroutineScope(Dispatchers.IO).launch { // Leaked scope
            repository.syncOrders()
        }
    }
}
```

**Correct (lifecycle-aware scopes):**

```kotlin
// Good - viewModelScope cancels when ViewModel is cleared
class ProfileViewModel(
    private val repository: ProfileRepository
) : ViewModel() {

    fun loadProfile() {
        viewModelScope.launch {
            val user = repository.getUser()
            _uiState.value = ProfileUiState(user)
        }
    }
}

// Good - lifecycleScope in UI layer
class ProfileActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        lifecycleScope.launch {
            repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.uiState.collect { state ->
                    // Only collects when STARTED or above
                }
            }
        }
    }
}

// Good - structured child coroutines
class SyncViewModel(
    private val orderRepo: OrderRepository,
    private val inventoryRepo: InventoryRepository
) : ViewModel() {

    fun syncAll() {
        viewModelScope.launch {
            // Both cancel if viewModelScope is cancelled
            val orders = async { orderRepo.sync() }
            val inventory = async { inventoryRepo.sync() }
            orders.await()
            inventory.await()
        }
    }
}
```

**Why it matters:**
- Unstructured scopes leak coroutines after screen rotation or back navigation
- Leaked coroutines waste resources, crash on cancelled UI updates
- `viewModelScope` and `lifecycleScope` tie coroutine lifetime to Android components
- Child coroutines inherit cancellation from parent — no manual cleanup needed

Reference: [Kotlin coroutines on Android](https://developer.android.com/kotlin/coroutines)
