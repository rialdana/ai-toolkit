---
title: Implement Timeout Using Task Group Pattern
impact: MEDIUM
tags: task-groups, timeout, cancellation, patterns
---

## Implement Timeout Using Task Group Pattern

Swift doesn't provide built-in timeout, but you can implement it using task groups by racing the operation against a sleep task.

**Incorrect (no timeout, hangs indefinitely):**

```swift
let data = try await slowNetworkRequest()  // ❌ May never complete
```

**Correct (timeout using task group):**

```swift
struct TimeoutError: Error {}

func withTimeout<T>(
    _ duration: Duration,
    operation: @Sendable @escaping () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask { try await operation() }

        group.addTask {
            try await Task.sleep(for: duration)
            throw TimeoutError()
        }

        guard let result = try await group.next() else {
            throw TimeoutError()
        }

        group.cancelAll()  // Cancel remaining task
        return result
    }
}

// Usage
let data = try await withTimeout(.seconds(5)) {
    try await slowNetworkRequest()
}
```

**Why it matters:** Operations without timeouts can hang indefinitely, consuming resources and blocking user workflows. The task group pattern provides a clean, reusable timeout mechanism. The first task to complete (either the operation or the timeout) wins, and the other is automatically canceled. This prevents resource leaks and provides predictable failure modes.

Reference: [Swift Concurrency Course - Task Groups](https://www.swiftconcurrencycourse.com)
