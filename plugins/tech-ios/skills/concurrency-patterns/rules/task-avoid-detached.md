---
title: Use Task.detached Only With Clear Justification
impact: HIGH
tags: tasks, detached-tasks, priority, task-local
---

## Use Task.detached Only With Clear Justification

`Task.detached` creates tasks with no connection to the caller - no priority inheritance, no task-local values, no cancellation propagation. This is rarely what you want.

**Incorrect (detached task loses context):**

```swift
@MainActor
func processData(_ data: Data) {
    Task.detached {  // ❌ Loses @MainActor context
        let result = await process(data)
        // How do we update UI? Not on MainActor anymore!
    }
}
```

**Correct (regular Task inherits context):**

```swift
@MainActor
func processData(_ data: Data) {
    Task {  // ✅ Inherits @MainActor, priority, cancellation
        let result = await process(data)
        updateUI(result)  // Safe - still on @MainActor
    }
}
```

**Valid use case (completely independent background work):**

```swift
Task.detached(priority: .background) {
    await DirectoryCleaner.cleanup()  // Truly independent, low priority
}
```

**Why it matters:** Detached tasks lose actor isolation, priority, task-local values, and cancellation state. They're isolated from the caller's execution context, making it easy to violate thread-safety assumptions. Regular `Task { }` inherits priority and can be used in most cases. Only use `Task.detached` for truly independent background work that should run regardless of caller state.

Reference: [Swift Concurrency Course - Detached Tasks](https://www.swiftconcurrencycourse.com)
