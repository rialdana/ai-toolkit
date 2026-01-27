---
title: Avoid Thread.current in Async Contexts
impact: HIGH
tags: threading, async, isolation, swift-6
---

## Avoid Thread.current in Async Contexts

`Thread.current` is unreliable in async code because tasks can resume on different threads after suspension. In Swift 6 language mode, it's unavailable from async contexts.

**Incorrect (relying on Thread.current):**

```swift
func processData() async {
    print("Starting on: \(Thread.current)")  // ❌ Unreliable

    try await Task.sleep(for: .seconds(1))

    print("Resumed on: \(Thread.current)")  // ❌ Likely different thread!
}
```

**Correct (reason about isolation, not threads):**

```swift
@MainActor
func processData() async {
    // ✅ Guaranteed MainActor isolation, regardless of thread

    try await Task.sleep(for: .seconds(1))

    // ✅ Still on MainActor after suspension
}

// Or use actor isolation
actor DataProcessor {
    func process() async {
        // ✅ Guaranteed actor isolation
        try await Task.sleep(for: .seconds(1))
        // ✅ Still isolated to this actor
    }
}
```

**Why it matters:** Tasks use a cooperative thread pool and may resume on any available thread after `await`. Thread identity is not preserved across suspension points. In Swift 6, `Thread.current` is unavailable in async contexts to prevent reliance on this unstable property. Use actor isolation (`@MainActor`, custom actors) to guarantee execution context. Isolation domains are stable across suspensions; threads are not.

Reference: [Swift Evolution - SE-0392](https://github.com/apple/swift-evolution/blob/main/proposals/0392-custom-actor-executors.md)
