---
title: Prefer Structured Concurrency Over Unstructured Tasks
impact: HIGH
tags: tasks, structured-concurrency, async-let, task-groups
---

## Prefer Structured Concurrency Over Unstructured Tasks

Structured concurrency (`async let`, task groups) provides automatic cancellation propagation and resource cleanup. Use unstructured `Task { }` only when you need independent lifecycle.

**Incorrect (unstructured tasks require manual management):**

```swift
func loadProfile() async throws -> Profile {
    let userTask = Task { try await fetchUser() }
    let settingsTask = Task { try await fetchSettings() }

    // ❌ Must manually manage cancellation and errors
    let user = try await userTask.value
    let settings = try await settingsTask.value

    return Profile(user: user, settings: settings)
}
// If function throws early, tasks keep running
```

**Correct (structured concurrency with auto-cleanup):**

```swift
func loadProfile() async throws -> Profile {
    async let user = fetchUser()
    async let settings = fetchSettings()

    // ✅ Automatic cancellation if scope exits
    return try await Profile(user: user, settings: settings)
}
// If function throws, user and settings tasks auto-cancel
```

**Why it matters:** Structured concurrency provides automatic cancellation propagation (child tasks cancel when parent does), guaranteed cleanup on scope exit, and compile-time safety. Unstructured tasks can leak, continue running after errors, and require manual cancellation. Only use unstructured `Task { }` for fire-and-forget work or when tasks must outlive their creation scope.

Reference: [SE-0304: Structured Concurrency](https://github.com/apple/swift-evolution/blob/main/proposals/0304-structured-concurrency.md)
