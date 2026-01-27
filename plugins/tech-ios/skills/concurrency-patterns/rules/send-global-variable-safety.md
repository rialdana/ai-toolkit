---
title: Use Actor Isolation for Global Mutable Variables
impact: HIGH
tags: sendable, global-variables, actors, isolation
---

## Use Actor Isolation for Global Mutable Variables

Global mutable variables are accessible from any context and must be concurrency-safe. Use actor isolation or make them immutable and Sendable.

**Incorrect (mutable global without isolation):**

```swift
class ImageCache {
    static var shared = ImageCache()  // ⚠️ Mutable, not concurrency-safe
    private var images: [URL: UIImage] = [:]
}
```

**Correct (actor isolation):**

```swift
@MainActor
class ImageCache {
    static var shared = ImageCache()  // ✅ Isolated to MainActor
    private var images: [URL: UIImage] = [:]
}
```

**Or (immutable + Sendable):**

```swift
final class ImageCache: Sendable {
    static let shared = ImageCache()  // ✅ Immutable, Sendable

    // Internal mutable state protected by actor or Mutex
}
```

**Or (nonisolated(unsafe) as last resort):**

```swift
struct APIProvider: Sendable {
    nonisolated(unsafe) static private(set) var shared: APIProvider!  // ⚠️ Document safety

    static func configure(apiURL: URL) {
        // Called once at app launch on main thread
        shared = APIProvider(apiURL: apiURL)
    }
}
```

**Why it matters:** Global variables can be accessed from any isolation domain (main thread, background tasks, actors). Without protection, concurrent access causes data races. Actor isolation (`@MainActor`) serializes all access. Immutable + `Sendable` guarantees thread-safety through immutability. `nonisolated(unsafe)` disables checks - use only when you can prove single-threaded initialization, and use `private(set)` to limit mutations.

Reference: [Swift Concurrency Course - Global Variables](https://www.swiftconcurrencycourse.com)
