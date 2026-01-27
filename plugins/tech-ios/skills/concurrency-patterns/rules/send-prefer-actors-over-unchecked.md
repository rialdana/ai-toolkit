---
title: Prefer Actors Over @unchecked Sendable for Mutable State
impact: HIGH
tags: sendable, actors, unchecked, safety
---

## Prefer Actors Over @unchecked Sendable for Mutable State

When you need thread-safe mutable state, use actors for compiler-verified safety instead of `@unchecked Sendable` with manual locks.

**Incorrect (@unchecked Sendable, manual locking):**

```swift
final class UserCache: @unchecked Sendable {
    private let lock = NSLock()
    private var users: [UUID: User] = [:]

    func getUser(_ id: UUID) -> User? {
        lock.lock()
        defer { lock.unlock() }
        return users[id]
    }

    func setUser(_ user: User) {
        lock.lock()  // ⚠️ Easy to forget
        defer { lock.unlock() }
        users[user.id] = user
    }

    // ❌ Forgot lock - data race!
    func count() -> Int {
        users.count
    }
}
```

**Correct (actor with automatic safety):**

```swift
actor UserCache {
    private var users: [UUID: User] = [:]

    func getUser(_ id: UUID) -> User? {
        users[id]  // ✅ Compiler guarantees isolation
    }

    func setUser(_ user: User) {
        users[user.id] = user
    }

    func count() -> Int {
        users.count  // ✅ Impossible to forget isolation
    }
}
```

**Why it matters:** `@unchecked Sendable` disables all compiler safety checks, making it easy to introduce data races through forgotten locks or incorrect lock ordering. Actors provide compile-time verification that all state access is serialized. The compiler prevents direct property access and enforces isolation. Only use `@unchecked Sendable` for proven thread-safe code with manual synchronization you can't refactor, and document why it's safe.

Reference: [SE-0306: Actors](https://github.com/apple/swift-evolution/blob/main/proposals/0306-actors.md)
