---
title: Return Flow from DAO Queries for Reactive Updates
impact: MEDIUM
tags: room, database, flow, reactive
---

## Return Flow from DAO Queries for Reactive Updates

DAO queries should return `Flow<T>` to automatically emit new values when the underlying table changes.

**Incorrect (one-shot queries requiring manual refresh):**

```kotlin
// Bad - suspend function requires manual re-fetching
@Dao
interface TaskDao {
    @Query("SELECT * FROM tasks WHERE is_completed = 0")
    suspend fun getActiveTasks(): List<TaskEntity>  // Stale after any write
}

// Bad - ViewModel must manually refresh
class TaskViewModel(private val dao: TaskDao) : ViewModel() {
    private val _tasks = MutableStateFlow<List<Task>>(emptyList())

    fun loadTasks() {
        viewModelScope.launch {
            _tasks.value = dao.getActiveTasks()  // Must call again after every insert/update
        }
    }

    fun completeTask(id: String) {
        viewModelScope.launch {
            dao.markCompleted(id)
            loadTasks()  // Easy to forget this re-fetch!
        }
    }
}
```

**Correct (Flow-based reactive queries):**

```kotlin
// Good - Flow emits automatically on table changes
@Dao
interface TaskDao {
    @Query("SELECT * FROM tasks WHERE is_completed = 0")
    fun observeActiveTasks(): Flow<List<TaskEntity>>  // Not suspend — returns Flow

    @Query("SELECT * FROM tasks WHERE id = :id")
    fun observeTask(id: String): Flow<TaskEntity?>

    // Keep suspend for write operations
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(task: TaskEntity)

    @Query("UPDATE tasks SET is_completed = 1 WHERE id = :id")
    suspend fun markCompleted(id: String)
}

// Good - ViewModel just maps the Flow
class TaskViewModel(private val dao: TaskDao) : ViewModel() {
    val tasks: StateFlow<List<Task>> = dao.observeActiveTasks()
        .map { entities -> entities.map { it.toDomain() } }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    fun completeTask(id: String) {
        viewModelScope.launch {
            dao.markCompleted(id)
            // No manual refresh needed — Flow re-emits automatically
        }
    }
}
```

**When to use suspend vs Flow:**
- **`Flow<T>`** — read queries where the UI should reflect changes automatically
- **`suspend`** — write operations (`@Insert`, `@Update`, `@Delete`) and one-shot reads

**Why it matters:**
- Room's Flow integration re-queries automatically when the table is modified
- Eliminates an entire class of bugs where UI shows stale data
- No manual refresh logic to maintain or forget
- Composable with `collectAsStateWithLifecycle` for lifecycle-aware UI updates

Reference: [Write asynchronous DAO queries](https://developer.android.com/training/data-storage/room/async-queries)
