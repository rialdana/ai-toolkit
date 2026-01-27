---
title: Add .interactive() for Touch-Responsive Elements
impact: MEDIUM
tags: liquid-glass, interactive, touch, feedback, animation
---

## Add .interactive() for Touch-Responsive Elements

Apply `.interactive()` modifier to glass elements that respond to touch (buttons, controls) to provide elastic visual feedback that enhances perceived responsiveness.

**Incorrect:**

```swift
// ❌ WRONG: Button has no touch feedback
struct PlayButton: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            Button {
                playVideo()
            } label: {
                Image(systemName: "play.fill")
            }
            .glassEffect(.regular)  // ❌ Missing interactive feedback
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Interactive glass responds to touch
struct PlayButton: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            Button {
                playVideo()
            } label: {
                Image(systemName: "play.fill")
            }
            .glassEffect(.regular.interactive())  // ✅ Elastic touch response
        }
    }
}
```

**Why it matters:** The `.interactive()` modifier adds subtle elastic compression/expansion animations when the element is touched, providing immediate visual feedback that the button is responding. This improves perceived performance and makes the UI feel more responsive, especially important for glass buttons where the visual style is subtle.

Reference: [SwiftUI GlassEffect Interactive API](https://developer.apple.com/documentation/swiftui/glasseffect/interactive)
