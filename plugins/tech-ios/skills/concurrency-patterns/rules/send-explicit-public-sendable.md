---
title: Make Public Value Types Explicitly Sendable
impact: HIGH
tags: sendable, public-api, value-types, modules
---

## Make Public Value Types Explicitly Sendable

Public structs and enums require explicit `Sendable` conformance. The compiler can't verify internal details across module boundaries.

**Incorrect (implicit conformance for public type):**

```swift
public struct Person {  // ⚠️ Warning: Sendable conformance inferred, but public
    var name: String
    var age: Int
}
```

**Correct (explicit Sendable for public API):**

```swift
public struct Person: Sendable {  // ✅ Explicit conformance
    var name: String
    var age: Int
}
```

**Internal types can remain implicit:**

```swift
struct InternalPerson {  // ✅ OK - internal type, implicit Sendable
    var name: String
}
```

**Why it matters:** The compiler can't verify that future internal changes to public types maintain thread-safety across modules. Explicit `Sendable` makes the conformance intentional and part of the public contract. Non-public types can use implicit conformance when all stored properties are Sendable. This ensures that `Sendable` conformance is a deliberate, documented API decision.

Reference: [SE-0302: Sendable and @Sendable closures](https://github.com/apple/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-closures.md)
