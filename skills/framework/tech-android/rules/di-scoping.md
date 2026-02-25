---
title: Scope Dependencies to Their Correct Lifecycle
impact: HIGH
tags: dependency-injection, hilt, scoping
---

## Scope Dependencies to Their Correct Lifecycle

Scope Hilt bindings to the narrowest appropriate lifecycle. Avoid `@Singleton` for everything — it keeps objects alive for the entire app lifetime.

**Incorrect (everything is Singleton):**

```kotlin
// Bad - ViewModel-lifetime object scoped as Singleton
@Module
@InstallIn(SingletonComponent::class)  // Lives forever!
object AppModule {
    @Provides
    @Singleton  // This repository holds a database connection open forever
    fun provideUserRepository(db: AppDatabase): UserRepository {
        return UserRepositoryImpl(db.userDao())
    }

    @Provides
    @Singleton  // Caches user data forever, even after logout
    fun provideUserCache(): UserCache {
        return InMemoryUserCache()
    }

    @Provides
    @Singleton  // Screen-specific presenter as Singleton — memory waste
    fun provideCheckoutPresenter(): CheckoutPresenter {
        return CheckoutPresenter()
    }
}
```

**Correct (lifecycle-appropriate scoping):**

```kotlin
// Good - app-wide dependencies in SingletonComponent
@Module
@InstallIn(SingletonComponent::class)
object AppModule {
    @Provides
    @Singleton  // Database is truly app-wide
    fun provideDatabase(@ApplicationContext context: Context): AppDatabase {
        return Room.databaseBuilder(context, AppDatabase::class.java, "app.db").build()
    }

    @Provides
    @Singleton  // OkHttpClient is expensive to create, share it
    fun provideOkHttpClient(): OkHttpClient {
        return OkHttpClient.Builder().build()
    }
}

// Good - activity-scoped dependencies
@Module
@InstallIn(ActivityRetainedComponent::class)
object ActivityModule {
    @Provides
    @ActivityRetainedScoped  // Survives rotation, cleared on Activity finish
    fun provideUserCache(): UserCache {
        return InMemoryUserCache()
    }
}

// Good - unscoped (new instance each time) for cheap objects
@Module
@InstallIn(ViewModelComponent::class)
object ViewModelModule {
    @Provides  // No scope annotation — new instance per injection
    fun provideMapper(): UserMapper {
        return UserMapper()
    }
}
```

**Hilt scope reference:**

| Component | Scope | Lifetime |
|-----------|-------|----------|
| `SingletonComponent` | `@Singleton` | App process |
| `ActivityRetainedComponent` | `@ActivityRetainedScoped` | Survives rotation |
| `ViewModelComponent` | `@ViewModelScoped` | ViewModel lifetime |
| `ActivityComponent` | `@ActivityScoped` | Activity instance |
| `FragmentComponent` | `@FragmentScoped` | Fragment instance |

**Why it matters:**
- Over-scoping wastes memory by keeping unused objects alive
- Under-scoping creates redundant instances and breaks shared state
- Incorrect scoping causes subtle bugs (stale caches after logout, leaked connections)
- Matching scope to lifecycle ensures predictable cleanup

Reference: [Scoping in Hilt](https://developer.android.com/training/dependency-injection/hilt-android#component-scopes)
