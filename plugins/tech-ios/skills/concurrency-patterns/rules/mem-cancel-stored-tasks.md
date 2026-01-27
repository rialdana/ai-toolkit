---
title: Cancel Stored Tasks to Prevent Retain Cycles
impact: HIGH
tags: memory, tasks, cancellation, deinit
---

## Cancel Stored Tasks to Prevent Retain Cycles

When storing tasks as properties, cancel them in `deinit` to break potential retain cycles and stop unnecessary work.

**Incorrect (task continues after deallocation attempt):**

```swift
final class DataManager {
    var task: Task<Void, Never>?

    func startWork() {
        task = Task {
            await self.work()  // ⚠️ Retain cycle if not using weak self
        }
    }

    // Missing: deinit { task?.cancel() }
}
```

**Correct (cancel task in deinit):**

```swift
final class DataManager {
    var task: Task<Void, Never>?

    func startWork() {
        task = Task { [weak self] in
            while let self = self {
                await self.work()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    deinit {
        task?.cancel()  // ✅ Stops task when object deallocates
    }
}

// Or with isolated deinit (Swift 6.2+)
@MainActor
final class DataManager {
    var task: Task<Void, Never>?

    isolated deinit {
        task?.cancel()  // ✅ Can access actor-isolated state
    }
}
```

**Why it matters:** Stored tasks without `deinit` cancellation continue running even when the owner is being deallocated. If the task uses `[weak self]`, cancellation stops unnecessary work. If the task uses strong `self`, cancellation is necessary to break the retain cycle. Canceling tasks is good resource hygiene. Use `isolated deinit` (Swift 6.2+) when the task is stored in actor-isolated state.

Reference: [Swift Concurrency Course - Memory Management](https://www.swiftconcurrencycourse.com)
