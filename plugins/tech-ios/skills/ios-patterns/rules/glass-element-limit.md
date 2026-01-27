---
title: Maximum ~20 Glass Elements on Screen Simultaneously
impact: HIGH
tags: liquid-glass, performance, limits, gpu, rendering
---

## Maximum ~20 Glass Elements on Screen Simultaneously

Limit the number of simultaneous glass effects to approximately 20 on screen at any time. Exceeding this causes GPU overload, frame drops, and battery drain.

**Incorrect:**

```swift
// ❌ WRONG: 100 glass elements cause performance collapse
struct GalleryView: View {
    let items = Array(0..<100)

    var body: some View {
        if #available(iOS 26.0, *) {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(items, id: \.self) { item in
                        ThumbnailCard(item)
                            .glassEffect()  // ❌ 100 glass effects!
                    }
                }
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Glass only on visible navigation/chrome
struct GalleryView: View {
    let items = Array(0..<100)

    var body: some View {
        if #available(iOS 26.0, *) {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(items, id: \.self) { item in
                            ThumbnailCard(item)  // ✅ No glass on content
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Gallery")
                            .glassEffect()  // ✅ Single glass element
                    }
                }
            }
        }
    }
}
```

**Why it matters:** Each glass effect requires GPU computation for real-time optical distortion and rendering. The GPU can efficiently handle ~20 effects while maintaining 120fps on ProMotion devices. Beyond this, frame rate drops below 60fps, device heats up, and battery drains rapidly. Glass is for navigation chrome, not repeated content.

Reference: [WWDC 2025 Session 219 - Performance Guidelines](https://developer.apple.com/videos/wwdc2025/)
