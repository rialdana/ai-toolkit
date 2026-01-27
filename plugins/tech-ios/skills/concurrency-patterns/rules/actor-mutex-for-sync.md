---
title: Use Mutex for Synchronous Low-Contention Access
impact: MEDIUM
tags: actors, mutex, synchronization, performance
---

## Use Mutex for Synchronous Low-Contention Access

When you need thread-safe mutable state in synchronous code with low contention, use `Mutex` from the Synchronization framework instead of actors.

**Incorrect (actor forces async for sync code):**

```swift
actor Counter {
    private var count: Int = 0

    func increment() { count += 1 }  // Actor method
}

// Usage - forces async
func updateCount(counter: Counter) async {
    await counter.increment()  // ❌ Unnecessary suspension for sync work
}
```

**Correct (Mutex for synchronous access):**

```swift
import Synchronization

final class Counter {
    private let count = Mutex<Int>(0)

    var currentCount: Int {
        count.withLock { $0 }
    }

    func increment() {
        count.withLock { $0 += 1 }  // ✅ Synchronous, no await
    }
}

// Usage - synchronous
func updateCount(counter: Counter) {
    counter.increment()  // ✅ No await needed
}
```

**Why it matters:** Actors require `await` even for simple operations, adding suspension overhead. `Mutex` provides synchronous locking for simple state protection without async overhead. Use `Mutex` for synchronous contexts, legacy code integration, and fine-grained locking. Use actors when you can adopt async/await, need logical isolation, or work in async contexts. Requires iOS 18+, macOS 15+.

Reference: [Swift Synchronization](https://github.com/apple/swift-evolution/blob/main/proposals/0433-mutex.md)
