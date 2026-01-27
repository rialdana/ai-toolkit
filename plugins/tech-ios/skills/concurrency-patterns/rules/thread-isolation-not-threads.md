---
title: Think in Isolation Domains Not Threads
impact: HIGH
tags: threading, isolation, actors, mindset
---

## Think in Isolation Domains Not Threads

Swift Concurrency uses isolation domains (actors, `@MainActor`, nonisolated), not direct thread management. Tasks can switch threads but maintain isolation.

**Incorrect (thread-based thinking):**

```swift
func updateUI() {
    // ❌ Thread.current unreliable in async contexts
    if Thread.isMainThread {
        label.text = "Updated"
    } else {
        DispatchQueue.main.async {
            label.text = "Updated"
        }
    }
}
```

**Correct (isolation-based thinking):**

```swift
@MainActor
func updateUI() {
    // ✅ Guaranteed to be on MainActor, compiler-verified
    label.text = "Updated"
}

// Or explicit hop
func updateUIFromBackground() async {
    await MainActor.run {
        label.text = "Updated"
    }
}
```

**Why it matters:** Swift tasks don't map 1:1 to threads - a task may resume on a different thread after `await`. `Thread.current` is unreliable in async contexts (unavailable in Swift 6 language mode). Isolation domains (`@MainActor`, actors) provide the guarantee you actually need: serialized access to shared state. Actors serialize task execution regardless of underlying threads. Think "which actor isolation?" not "which thread?"

Reference: [Swift Concurrency Course - Threading](https://www.swiftconcurrencycourse.com)
