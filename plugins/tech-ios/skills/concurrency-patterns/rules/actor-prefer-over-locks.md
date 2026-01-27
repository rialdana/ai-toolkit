---
title: Prefer Actors Over Manual Locks for Async Code
impact: HIGH
tags: actors, locks, thread-safety, async
---

## Prefer Actors Over Manual Locks for Async Code

Actors provide compiler-verified thread-safety without manual lock management. Manual locks are error-prone and don't compose well with async/await.

**Incorrect (manual locking with @unchecked Sendable):**

```swift
final class Cache: @unchecked Sendable {
    private let lock = NSLock()
    private var items: [String: Data] = [:]

    func get(_ key: String) async -> Data? {
        lock.lock()
        defer { lock.unlock() }
        return items[key]  // ❌ Holding lock during async is wrong
    }

    // ⚠️ Easy to forget lock
    var count: Int {
        items.count  // Data race!
    }
}
```

**Correct (actor with compiler-verified safety):**

```swift
actor Cache {
    private var items: [String: Data] = [:]

    func get(_ key: String) -> Data? {
        items[key]  // ✅ Compiler guarantees isolation
    }

    func set(_ key: String, value: Data) {
        items[key] = value
    }

    var count: Int { items.count }  // ✅ Impossible to forget isolation
}
```

**Why it matters:** Manual locks require correct acquisition/release in all code paths, can't be held across suspension points, don't compose with async/await, and aren't checked by the compiler. Actors provide automatic serialization, compiler verification, support for async methods, and elimination of manual lock management. Use `Mutex` for synchronous low-contention cases; use actors for async contexts.

Reference: [SE-0306: Actors](https://github.com/apple/swift-evolution/blob/main/proposals/0306-actors.md)
