---
title: Use Discarding Task Groups for Fire-and-Forget Work
impact: MEDIUM
tags: task-groups, discarding, memory, side-effects
---

## Use Discarding Task Groups for Fire-and-Forget Work

When you don't need task results (logging, analytics, preloading), use `withDiscardingTaskGroup` for better memory efficiency.

**Incorrect (storing unused results):**

```swift
await withTaskGroup(of: Void.self) { group in
    group.addTask { await logEvent("user_login") }
    group.addTask { await preloadCache() }
    group.addTask { await syncAnalytics() }

    // Must iterate to avoid leaking results
    for await _ in group { }  // ❌ Unnecessary overhead
}
```

**Correct (discarding task group):**

```swift
await withDiscardingTaskGroup { group in
    group.addTask { await logEvent("user_login") }
    group.addTask { await preloadCache() }
    group.addTask { await syncAnalytics() }
}  // ✅ Automatically waits, no result storage
```

**Why it matters:** Regular task groups store all results in memory until consumed with `next()` or iteration. For side-effect work where results don't matter, this wastes memory. Discarding task groups don't store results, automatically wait for completion, and prevent result buffer growth. Use for logging, analytics, cache warming, notifications, and other fire-and-forget operations.

Reference: [Swift Concurrency Course - Discarding Task Groups](https://www.swiftconcurrencycourse.com)
