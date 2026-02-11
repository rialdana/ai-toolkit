---
title: Design Room Entities with Non-Null Defaults and Proper Types
impact: MEDIUM
tags: room, database, entities
---

## Design Room Entities with Non-Null Defaults and Proper Types

Room entities should use non-null Kotlin types with sensible defaults. Avoid nullable fields when a default value is appropriate, and use proper column types.

**Incorrect (nullable fields with no defaults):**

```kotlin
// Bad - nullable fields that should have defaults
@Entity(tableName = "tasks")
data class TaskEntity(
    @PrimaryKey val id: String?,          // Primary key is nullable!
    val title: String?,                    // Should never be null
    val description: String?,              // Could default to ""
    val isCompleted: Boolean?,             // Should default to false
    val createdAt: Long?,                  // Should never be null
    val priority: String?                  // Untyped — "HIGH"? "high"? "1"?
)
```

**Correct (non-null defaults and proper types):**

```kotlin
// Good - non-null with defaults, typed columns
@Entity(tableName = "tasks")
data class TaskEntity(
    @PrimaryKey
    val id: String,
    val title: String,
    val description: String = "",
    val isCompleted: Boolean = false,
    @ColumnInfo(name = "created_at")
    val createdAt: Long = System.currentTimeMillis(),
    val priority: Int = Priority.MEDIUM   // Int enum, not free-form String
) {
    companion object {
        object Priority {
            const val LOW = 0
            const val MEDIUM = 1
            const val HIGH = 2
        }
    }
}

// Good - TypeConverter for complex types
class Converters {
    @TypeConverter
    fun fromInstant(value: Long?): Instant? = value?.let { Instant.fromEpochMilliseconds(it) }

    @TypeConverter
    fun toEpochMilli(instant: Instant?): Long? = instant?.toEpochMilliseconds()
}
```

**Why it matters:**
- Nullable primary keys cause crashes on insert
- Null checks propagate through the entire codebase unnecessarily
- Default values ensure entities are always in a valid state
- Typed fields prevent invalid data from being persisted

Reference: [Defining data using Room entities](https://developer.android.com/training/data-storage/room/defining-data)
