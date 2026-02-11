---
title: Inject Dispatchers for Testable Coroutine Code
impact: HIGH
tags: testing, coroutines, dispatchers
---

## Inject Dispatchers for Testable Coroutine Code

Never hardcode `Dispatchers.IO` or `Dispatchers.Main` inside classes. Inject dispatchers so tests can substitute `TestDispatcher` for deterministic execution.

**Incorrect (hardcoded dispatchers):**

```kotlin
// Bad - hardcoded Dispatchers.IO, untestable
class UserRepository {
    suspend fun getUser(id: String): User {
        return withContext(Dispatchers.IO) {  // Can't control in tests
            api.getUser(id)
        }
    }
}

// Bad - test hangs or requires Dispatchers.setMain
@Test
fun loadUser_updatesState() = runTest {
    val viewModel = UserViewModel(repo)  // Uses Dispatchers.Main internally
    viewModel.loadUser("1")  // Hangs — Main dispatcher not available in tests
    assertEquals("Alice", viewModel.uiState.value.name)
}
```

**Correct (injected dispatchers):**

```kotlin
// Good - dispatcher injected via constructor
class UserRepository(
    private val api: UserApi,
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) {
    suspend fun getUser(id: String): User {
        return withContext(ioDispatcher) {
            api.getUser(id)
        }
    }
}

// Good - Hilt module for dispatchers
@Module
@InstallIn(SingletonComponent::class)
object DispatcherModule {
    @Provides
    @IoDispatcher
    fun provideIoDispatcher(): CoroutineDispatcher = Dispatchers.IO

    @Provides
    @DefaultDispatcher
    fun provideDefaultDispatcher(): CoroutineDispatcher = Dispatchers.Default
}

@Qualifier
@Retention(AnnotationRetention.BINARY)
annotation class IoDispatcher

@Qualifier
@Retention(AnnotationRetention.BINARY)
annotation class DefaultDispatcher

// Good - test with TestDispatcher
@Test
fun getUser_returnsUser() = runTest {
    val testDispatcher = UnconfinedTestDispatcher(testScheduler)
    val repo = UserRepository(
        api = FakeUserApi(),
        ioDispatcher = testDispatcher  // Deterministic, no threading
    )

    val user = repo.getUser("1")

    assertEquals("Alice", user.name)
}

// Good - ViewModel test with MainDispatcherRule
class UserViewModelTest {
    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    @Test
    fun loadUser_updatesState() = runTest {
        val viewModel = UserViewModel(FakeUserRepository())
        viewModel.loadUser("1")
        assertEquals("Alice", viewModel.uiState.value.name)
    }
}

class MainDispatcherRule(
    val testDispatcher: TestDispatcher = UnconfinedTestDispatcher()
) : TestWatcher() {
    override fun starting(description: Description) {
        Dispatchers.setMain(testDispatcher)
    }
    override fun finished(description: Description) {
        Dispatchers.resetMain()
    }
}
```

**Why it matters:**
- Hardcoded dispatchers make tests flaky or impossible to run
- `TestDispatcher` gives deterministic, synchronous execution
- `MainDispatcherRule` replaces `Dispatchers.Main` for ViewModel tests
- Injected dispatchers follow the dependency inversion principle

Reference: [Testing coroutines on Android](https://developer.android.com/kotlin/coroutines/test)
