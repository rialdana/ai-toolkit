---
title: Use Versioned Migrations Instead of Destructive Recreation
impact: HIGH
tags: room, database, migration
---

## Use Versioned Migrations Instead of Destructive Recreation

Always provide explicit `Migration` objects when changing your Room schema. Never use `fallbackToDestructiveMigration()` in production — it deletes all user data.

**Incorrect (destructive fallback):**

```kotlin
// Bad - destroys all data on schema change
val db = Room.databaseBuilder(context, AppDatabase::class.java, "app.db")
    .fallbackToDestructiveMigration()  // Wipes everything!
    .build()
```

**Correct (versioned migration):**

```kotlin
// Good - explicit migration preserving data
val MIGRATION_1_2 = object : Migration(1, 2) {
    override fun migrate(db: SupportSQLiteDatabase) {
        db.execSQL("ALTER TABLE tasks ADD COLUMN priority INTEGER NOT NULL DEFAULT 1")
    }
}

val MIGRATION_2_3 = object : Migration(2, 3) {
    override fun migrate(db: SupportSQLiteDatabase) {
        // Create new table with correct schema
        db.execSQL("""
            CREATE TABLE tasks_new (
                id TEXT NOT NULL PRIMARY KEY,
                title TEXT NOT NULL,
                description TEXT NOT NULL DEFAULT '',
                is_completed INTEGER NOT NULL DEFAULT 0,
                priority INTEGER NOT NULL DEFAULT 1
            )
        """)
        // Copy data
        db.execSQL("""
            INSERT INTO tasks_new (id, title, description, is_completed, priority)
            SELECT id, title, COALESCE(description, ''), is_completed, priority
            FROM tasks
        """)
        // Swap tables
        db.execSQL("DROP TABLE tasks")
        db.execSQL("ALTER TABLE tasks_new RENAME TO tasks")
    }
}

val db = Room.databaseBuilder(context, AppDatabase::class.java, "app.db")
    .addMigrations(MIGRATION_1_2, MIGRATION_2_3)
    .build()
```

**Testing migrations:**

```kotlin
@RunWith(AndroidJUnit4::class)
class MigrationTest {
    @get:Rule
    val helper = MigrationTestHelper(
        InstrumentationRegistry.getInstrumentation(),
        AppDatabase::class.java
    )

    @Test
    fun migrate1To2() {
        helper.createDatabase("test-db", 1).apply {
            execSQL("INSERT INTO tasks (id, title) VALUES ('1', 'Test')")
            close()
        }
        helper.runMigrationsAndValidate("test-db", 2, true, MIGRATION_1_2)
    }
}
```

**Why it matters:**
- `fallbackToDestructiveMigration` silently deletes all user data
- Users lose saved content, preferences, and offline data
- Explicit migrations are auditable and testable
- Migration tests catch SQL errors before they reach production

Reference: [Migrating Room databases](https://developer.android.com/training/data-storage/room/migrating-db-versions)
