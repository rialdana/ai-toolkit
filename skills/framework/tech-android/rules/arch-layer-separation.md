---
title: Enforce Clean Architecture Layer Boundaries
impact: CRITICAL
tags: architecture, layers, separation-of-concerns
---

## Enforce Clean Architecture Layer Boundaries

Domain and data layers must never depend on the UI layer. Dependencies flow inward: UI → Domain → Data.

**Incorrect (domain depends on Android UI):**

```kotlin
// Bad - domain layer imports Android/UI types
// domain/usecase/GetUserUseCase.kt
import android.content.Context          // Framework leak!
import androidx.lifecycle.LiveData       // UI type in domain!

class GetUserUseCase(
    private val context: Context,       // Framework dependency
    private val repo: UserRepository
) {
    fun execute(id: String): LiveData<User> {  // UI type in return
        val prefs = context.getSharedPreferences("app", Context.MODE_PRIVATE)
        return repo.getUser(id)
    }
}
```

**Correct (clean layer boundaries):**

```kotlin
// domain/usecase/GetUserUseCase.kt
// No Android imports — pure Kotlin
class GetUserUseCase(
    private val userRepository: UserRepository
) {
    suspend operator fun invoke(id: String): Result<User> {
        return userRepository.getUser(id)
    }
}

// domain/repository/UserRepository.kt
interface UserRepository {
    suspend fun getUser(id: String): Result<User>
}

// data/repository/UserRepositoryImpl.kt
class UserRepositoryImpl(
    private val api: UserApi,
    private val dao: UserDao,
    private val prefs: AppPreferences   // Abstracted, not Context
) : UserRepository {
    override suspend fun getUser(id: String): Result<User> {
        return runCatching { api.getUser(id).toDomain() }
    }
}
```

**Layer dependency rules:**

| Layer | Can depend on | Must NOT depend on |
|-------|--------------|-------------------|
| UI (Compose, ViewModel) | Domain | Data implementation |
| Domain (UseCases, Entities) | Nothing | UI, Data, Android SDK |
| Data (Repos, DAOs, API) | Domain interfaces | UI |

**Why it matters:**
- Domain logic becomes testable without Android instrumentation
- Swapping data sources (API → local) requires no UI changes
- Compile-time enforcement prevents accidental coupling
- Enables feature modules with clear boundaries

Reference: [Guide to app architecture](https://developer.android.com/topic/architecture)
