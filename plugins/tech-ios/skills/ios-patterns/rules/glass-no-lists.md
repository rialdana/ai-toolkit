---
title: Never Apply Glass in Scrolling Lists or Grids
impact: HIGH
tags: liquid-glass, performance, lists, scrolling, rendering
---

## Never Apply Glass in Scrolling Lists or Grids

Never apply glass effects to list rows, grid cells, or any repeated elements in scrollable containers. This causes severe performance degradation and frame drops during scrolling.

**Incorrect:**

```swift
// ❌ WRONG: Glass on every list row
struct MessageList: View {
    let messages: [Message]

    var body: some View {
        if #available(iOS 26.0, *) {
            List(messages) { message in
                MessageRow(message)
                    .glassEffect()  // ❌ Hundreds of glass effects while scrolling
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Glass only on fixed navigation elements
struct MessageList: View {
    let messages: [Message]

    var body: some View {
        if #available(iOS 26.0, *) {
            NavigationStack {
                List(messages) { message in
                    MessageRow(message)  // ✅ Standard row styling
                }
                .navigationTitle("Messages")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ComposeButton()
                            .glassEffect()  // ✅ Single fixed element
                    }
                }
            }
        }
    }
}
```

**Why it matters:** During scrolling, iOS constantly creates/destroys views for list cells. Each new glass effect requires GPU initialization and rendering setup. With dozens of cells scrolling at 120fps, this creates hundreds of effect instantiations per second, overwhelming the GPU and causing visible stuttering. Glass is designed for static navigation chrome, not dynamic content.

Reference: [Performance Best Practices for Glass](https://developer.apple.com/documentation/swiftui/glasseffect/performance)
