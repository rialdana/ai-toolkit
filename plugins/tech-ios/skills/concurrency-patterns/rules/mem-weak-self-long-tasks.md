---
title: Use Weak Self for Long-Running and Infinite Tasks
impact: HIGH
tags: memory, retain-cycles, tasks, weak-self
---

## Use Weak Self for Long-Running and Infinite Tasks

When a task captures `self` strongly and runs for an extended period or indefinitely, create a retain cycle if `self` owns the task.

**Incorrect (retain cycle with long-running task):**

```swift
@MainActor
final class ImageLoader {
    var task: Task<Void, Never>?

    func startPolling() {
        task = Task {
            while true {
                self.pollImages()  // ❌ Strong capture, retain cycle
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }
}

var loader: ImageLoader? = .init()
loader?.startPolling()
loader = nil  // ⚠️ Loader never deallocated!
```

**Correct (weak self breaks cycle):**

```swift
@MainActor
final class ImageLoader {
    var task: Task<Void, Never>?

    func startPolling() {
        task = Task { [weak self] in
            while let self = self {  // ✅ Exits when self deallocates
                self.pollImages()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }
}

var loader: ImageLoader? = .init()
loader?.startPolling()
loader = nil  // ✅ Loader deallocated, task stops
```

**Why it matters:** When `self` owns the task and the task strongly captures `self`, neither can be deallocated (retain cycle). Long-running tasks keep the cycle alive indefinitely. Use `[weak self]` for: polling loops, infinite async sequences, long-running monitoring, and any task stored as a property. Short-lived tasks can use strong captures if acceptable for the object to live until completion.

Reference: [Swift Concurrency Course - Memory Management](https://www.swiftconcurrencycourse.com)
