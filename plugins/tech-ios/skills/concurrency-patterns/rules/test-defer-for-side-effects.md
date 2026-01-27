---
title: Use Defer Trick for Testing Async Side Effects
impact: MEDIUM
tags: testing, side-effects, defer, unstructured-tasks
---

## Use Defer Trick for Testing Async Side Effects

When testing unstructured tasks that produce side effects, use defer trick with continuations to observe completion.

**Incorrect (no way to observe completion):**

```swift
@MainActor
final class Logger {
    private(set) var logs: [String] = []

    func log(_ message: String) {
        Task {
            try? await Task.sleep(for: .milliseconds(100))
            logs.append(message)  // Side effect in unstructured task
        }
    }
}

@Test
@MainActor
func logsMessage() async {
    let logger = Logger()
    logger.log("test")
    #expect(logger.logs == ["test"])  // ❌ Fails - task not complete
}
```

**Correct (defer trick observes side effect):**

```swift
@MainActor
final class Logger {
    private(set) var logs: [String] = []
    var onLog: (() -> Void)?

    func log(_ message: String) {
        Task {
            defer { onLog?() }  // ✅ Signal completion

            try? await Task.sleep(for: .milliseconds(100))
            logs.append(message)
        }
    }
}

@Test
@MainActor
func logsMessage() async {
    let logger = Logger()

    await withCheckedContinuation { continuation in
        logger.onLog = {
            continuation.resume()
        }
        logger.log("test")
    }

    #expect(logger.logs == ["test"])  // ✅ Passes
}
```

**Why it matters:** Unstructured tasks (`Task { }`) don't provide a direct way to await their completion. The defer trick uses a callback to signal when the task finishes, allowing tests to observe side effects reliably. Use continuations or confirmations to await the callback. This pattern works for logging, analytics, cache updates, and other fire-and-forget operations that need testing.

Reference: [Swift Concurrency Course - Testing](https://www.swiftconcurrencycourse.com)
