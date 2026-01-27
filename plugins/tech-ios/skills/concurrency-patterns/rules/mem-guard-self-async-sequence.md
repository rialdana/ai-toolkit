---
title: Guard Let Self in Async Sequence Loops
impact: HIGH
tags: memory, async-sequences, weak-self, loops
---

## Guard Let Self in Async Sequence Loops

Async sequences may run indefinitely. Use `[weak self]` with `guard let self` to exit the loop when the object deallocates.

**Incorrect (strong capture in infinite sequence):**

```swift
@MainActor
final class AppLifecycleViewModel {
    private(set) var isActive = false
    private var task: Task<Void, Never>?

    func startObserving() {
        task = Task {
            for await _ in NotificationCenter.default.notifications(
                named: .didBecomeActive
            ) {
                isActive = true  // ❌ Strong capture, never ends
            }
        }
    }
}

var viewModel: AppLifecycleViewModel? = .init()
viewModel?.startObserving()
viewModel = nil  // ⚠️ Never deallocated - sequence continues forever
```

**Correct (weak self + guard exits loop):**

```swift
@MainActor
final class AppLifecycleViewModel {
    private(set) var isActive = false
    private var task: Task<Void, Never>?

    func startObserving() {
        task = Task { [weak self] in
            for await _ in NotificationCenter.default.notifications(
                named: .didBecomeActive
            ) {
                guard let self = self else { return }  // ✅ Exits when self deallocates
                self.isActive = true
            }
        }
    }
}

var viewModel: AppLifecycleViewModel? = .init()
viewModel?.startObserving()
viewModel = nil  // ✅ Deallocated, loop exits
```

**Why it matters:** Async sequences (notifications, websockets, streams) often run indefinitely. Without `[weak self]`, the task holds `self` alive forever. `guard let self` provides an early exit point when the object is released. The loop terminates cleanly when `self` becomes `nil`. Use this pattern for: notification observers, async stream monitoring, websocket handlers, and any infinite async sequence.

Reference: [Swift Concurrency Course - Memory Management](https://www.swiftconcurrencycourse.com)
