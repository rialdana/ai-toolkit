---
title: Use async let for Fixed Parallel Operations
impact: HIGH
tags: async-await, async-let, parallel-execution
---

## Use async let for Fixed Parallel Operations

When you have a fixed number of independent async operations, use `async let` for automatic structured concurrency with compile-time known parallelism.

**Incorrect (sequential execution):**

```swift
func loadProfile() async throws -> Profile {
    let user = try await fetchUser()
    let settings = try await fetchSettings()  // Waits for user first
    let notifications = try await fetchNotifications()  // Waits for settings

    return Profile(user: user, settings: settings, notifications: notifications)
}
```

**Correct (parallel execution):**

```swift
func loadProfile() async throws -> Profile {
    async let user = fetchUser()
    async let settings = fetchSettings()
    async let notifications = fetchNotifications()

    return try await Profile(
        user: user,
        settings: settings,
        notifications: notifications
    )
}
```

**Why it matters:** Sequential awaits waste time when operations are independent. `async let` starts all operations immediately in parallel, provides automatic cancellation on scope exit, and reduces total execution time proportionally to the number of parallel operations. For dynamic/loop-based parallelism, use task groups instead.

Reference: [Swift Concurrency Course](https://www.swiftconcurrencycourse.com)
