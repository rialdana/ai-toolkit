---
title: Never Nest Task Blocks Inside Task Groups
impact: CRITICAL
tags: tasks, structured-concurrency, cancellation
---

## Never Nest Task Blocks Inside Task Groups

Nesting `Task { }` blocks inside task groups or structured concurrency creates unstructured tasks that don't participate in the parent's cancellation hierarchy.

**Incorrect (nested Task loses cancellation):**

```swift
await withTaskGroup(of: Void.self) { group in
    for item in items {
        group.addTask {
            // ❌ This nested Task is UNSTRUCTURED
            Task {
                await process(item)  // Won't cancel when group cancels!
            }
        }
    }

    group.cancelAll()  // Nested tasks continue running!
}
```

**Correct (direct work in task group):**

```swift
await withTaskGroup(of: Void.self) { group in
    for item in items {
        group.addTask {
            await process(item)  // ✅ Cancels with group
        }
    }

    group.cancelAll()
}
```

**Why it matters:** Nested `Task { }` blocks inherit actor context (e.g., `@MainActor`) but do NOT inherit cancellation. When the parent group or task is canceled, nested tasks continue executing, leading to resource leaks, unnecessary work, and potential crashes when accessing deallocated state.

Reference: [Swift Concurrency Course - Task Groups](https://www.swiftconcurrencycourse.com)
