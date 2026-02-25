---
title: Keep ViewModels Free of Android Framework Imports
impact: HIGH
tags: architecture, viewmodel, testability
---

## Keep ViewModels Free of Android Framework Imports

ViewModels should contain no references to `Context`, `Activity`, `Fragment`, `View`, or other Android framework types.

**Incorrect (ViewModel with Android imports):**

```kotlin
// Bad - ViewModel depends on Android framework
class ProfileViewModel(
    private val context: Context   // Leaks Activity/Application
) : ViewModel() {

    fun getGreeting(): String {
        // Direct resource access — untestable without Android
        return context.getString(R.string.greeting)
    }

    fun saveProfile(name: String) {
        // Direct SharedPreferences — hard to test
        val prefs = context.getSharedPreferences("profile", Context.MODE_PRIVATE)
        prefs.edit().putString("name", name).apply()
    }
}
```

**Correct (ViewModel with abstracted dependencies):**

```kotlin
// Good - pure Kotlin dependencies, no Android imports
class ProfileViewModel(
    private val stringProvider: StringProvider,
    private val profileRepository: ProfileRepository
) : ViewModel() {

    fun getGreeting(): String {
        return stringProvider.getString(StringRes.Greeting)
    }

    fun saveProfile(name: String) {
        viewModelScope.launch {
            profileRepository.saveName(name)
        }
    }
}

// The abstraction lives in the domain layer
interface StringProvider {
    fun getString(res: StringRes): String
}

// Implementation lives in the data/framework layer
class AndroidStringProvider(
    private val context: Context
) : StringProvider {
    override fun getString(res: StringRes): String {
        return context.getString(res.resId)
    }
}
```

**What to abstract away from ViewModels:**
- `Context` → inject repository or provider interfaces
- `R.string.*` → `StringProvider` interface
- `SharedPreferences` → `PreferencesRepository`
- `ConnectivityManager` → `NetworkMonitor` interface
- `Intent` / `Bundle` → typed navigation arguments

**Why it matters:**
- ViewModels become testable with plain JUnit (no Robolectric)
- Prevents Activity/Context memory leaks
- Forces clean separation of concerns
- Makes ViewModels reusable across different UI hosts

Reference: [ViewModel overview](https://developer.android.com/topic/libraries/architecture/viewmodel)
