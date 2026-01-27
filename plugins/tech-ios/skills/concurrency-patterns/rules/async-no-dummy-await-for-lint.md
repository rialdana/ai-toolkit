---
title: Never Fix async_without_await With Dummy Suspension
impact: HIGH
tags: async-await, linting, suspension-points
---

## Never Fix async_without_await With Dummy Suspension

When a linter warns that an `async` function has no `await`, adding dummy `Task.yield()` or `Task.sleep()` just to silence the warning is dangerous and misleading.

**Incorrect (dummy suspension to silence warning):**

```swift
func processData(_ data: Data) async -> Result {
    await Task.yield()  // ❌ Dummy suspension, no actual async work

    let processed = transform(data)  // Synchronous work
    return Result(processed)
}
```

**Correct (remove async if no suspension needed):**

```swift
func processData(_ data: Data) -> Result {
    let processed = transform(data)
    return Result(processed)
}
```

**Or (if async is needed for protocol conformance):**

```swift
protocol DataProcessor {
    func processData(_ data: Data) async -> Result
}

// Keep async for protocol conformance, document why
func processData(_ data: Data) async -> Result {
    // Synchronous implementation of async protocol requirement
    let processed = transform(data)
    return Result(processed)
}
```

**Why it matters:** Dummy suspension points mislead callers into thinking the function does async work, add unnecessary overhead from task switching, hide the fact that the function could be synchronous, and violate the principle that `async` indicates actual asynchronous operations. Only mark functions `async` if they genuinely perform asynchronous work or must conform to an async protocol.

Reference: [Swift Concurrency Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
