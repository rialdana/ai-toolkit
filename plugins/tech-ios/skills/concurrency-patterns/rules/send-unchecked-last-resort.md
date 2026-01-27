---
title: Use @unchecked Sendable Only as Documented Last Resort
impact: CRITICAL
tags: sendable, data-safety, manual-synchronization
---

## Use @unchecked Sendable Only as Documented Last Resort

`@unchecked Sendable` disables compiler safety checks. It should only be used when you have proven thread-safety through manual synchronization, and the reason must be documented.

**Incorrect (hiding safety issues):**

```swift
final class Cache: @unchecked Sendable {
    private let lock = NSLock()
    private var items: [String: Data] = [:]

    // ⚠️ Forgot lock - data race!
    var count: Int {
        items.count
    }

    func get(_ key: String) -> Data? {
        lock.lock()
        defer { lock.unlock() }
        return items[key]
    }
}
```

**Correct (use actor instead):**

```swift
actor Cache {
    private var items: [String: Data] = [:]

    var count: Int { items.count }  // ✅ Compiler-verified safety

    func get(_ key: String) -> Data? {
        items[key]
    }

    func set(_ key: String, value: Data) {
        items[key] = value
    }
}
```

**Why it matters:** `@unchecked Sendable` eliminates compile-time safety without adding runtime checks. It's easy to forget synchronization in one code path, introducing data races that are difficult to debug. Thread Sanitizer may not catch all cases. Use actors for automatic, compiler-verified thread-safety instead.

Reference: [SE-0302: Sendable and @Sendable closures](https://github.com/apple/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-closures.md)
