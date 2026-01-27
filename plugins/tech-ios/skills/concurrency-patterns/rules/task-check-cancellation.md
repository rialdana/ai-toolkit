---
title: Check Cancellation at Natural Breakpoints
impact: HIGH
tags: tasks, cancellation, resource-management
---

## Check Cancellation at Natural Breakpoints

Tasks don't stop automatically when canceled. You must manually check `Task.isCancelled` or call `Task.checkCancellation()` at appropriate points to stop work.

**Incorrect (ignores cancellation):**

```swift
let task = Task {
    let data = try await URLSession.shared.data(from: url)
    // No cancellation check - continues even if canceled
    let processed = await expensiveProcessing(data)  // Wastes resources
    let stored = await storeInDatabase(processed)     // Wasteful work
    return stored
}

task.cancel()  // Task continues running!
```

**Correct (checks cancellation at breakpoints):**

```swift
let task = Task {
    try Task.checkCancellation()  // Before network

    let data = try await URLSession.shared.data(from: url)

    try Task.checkCancellation()  // After network, before processing

    let processed = await expensiveProcessing(data)

    try Task.checkCancellation()  // Before database

    return await storeInDatabase(processed)
}

task.cancel()  // Stops at next checkpoint
```

**Why it matters:** Unchecked cancellation wastes CPU, memory, network bandwidth, and battery. Long-running tasks may continue indefinitely even after being canceled. Check cancellation before expensive operations, after await points, and in loops. Use `try Task.checkCancellation()` to throw `CancellationError`, or `guard !Task.isCancelled` for custom handling.

Reference: [Swift Concurrency Course - Task Cancellation](https://www.swiftconcurrencycourse.com)
