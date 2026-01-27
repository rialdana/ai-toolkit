---
title: Configure Default Actor Isolation for App Targets
impact: MEDIUM
tags: threading, mainactor, configuration, app-targets
---

## Configure Default Actor Isolation for App Targets

For app targets (not libraries), set `@MainActor` as default isolation to ensure UI code runs on the main thread by default.

**Incorrect (no default isolation, easy to forget @MainActor):**

```swift
// No default isolation configured
class ViewModel {  // ⚠️ Could be accessed from any thread
    var items: [Item] = []

    func updateItems(_ newItems: [Item]) {
        items = newItems  // ⚠️ May cause UI crashes
    }
}
```

**Correct (configure default @MainActor isolation):**

```swift
// In build settings, enable: Default Actor Isolation = @MainActor

class ViewModel {  // ✅ Implicitly @MainActor
    var items: [Item] = []

    func updateItems(_ newItems: [Item]) {
        items = newItems  // ✅ Safe - on main thread
    }
}

// Opt-out where needed
nonisolated class BackgroundProcessor {
    func process() async {
        // Runs on background
    }
}
```

**Configuration:**
```
// In target build settings or Package.swift
swiftSettings: [
    .enableUpcomingFeature("GlobalActorIsolatedTypesUsability"),
    .unsafeFlags(["-Xfrontend", "-default-actor-isolation=main-actor"])
]
```

**Why it matters:** App code is predominantly UI-bound. Defaulting to `@MainActor` isolation makes the common case (UI code) safe by default. Background processing can opt-out with `nonisolated`. This reduces boilerplate `@MainActor` annotations and prevents accidental main-thread violations. Don't use for library targets where callers control execution context.

Reference: [Swift Forums - Default Isolation](https://forums.swift.org/t/default-actor-isolation/64094)
