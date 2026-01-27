---
title: Max 5 Concurrent Morphing Transitions
impact: HIGH
tags: liquid-glass, morphing, performance, animation, transitions
---

## Max 5 Concurrent Morphing Transitions

Limit concurrent glass morphing animations to 5 simultaneous transitions. More than this causes animation jank, frame drops, and poor user experience.

**Incorrect:**

```swift
// ❌ WRONG: 20 elements morphing simultaneously
struct DashboardGrid: View {
    @Namespace private var glassNamespace
    @State private var expandedIDs: Set<Int> = []

    var body: some View {
        if #available(iOS 26.0, *) {
            LazyVGrid(columns: columns) {
                ForEach(0..<20) { index in
                    WidgetCard(
                        isExpanded: expandedIDs.contains(index)
                    )
                    .glassEffectID("widget-\(index)", in: glassNamespace)
                    .onTapGesture {
                        // ❌ Can trigger 20 simultaneous morphs
                        withAnimation {
                            expandedIDs.toggle(index)
                        }
                    }
                }
            }
            .glassEffect()
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Limit to single expanded item (1 morph at a time)
struct DashboardGrid: View {
    @Namespace private var glassNamespace
    @State private var expandedID: Int? = nil

    var body: some View {
        if #available(iOS 26.0, *) {
            LazyVGrid(columns: columns) {
                ForEach(0..<20) { index in
                    WidgetCard(
                        isExpanded: expandedID == index
                    )
                    .glassEffectID("widget-\(index)", in: glassNamespace)
                    .onTapGesture {
                        withAnimation {
                            expandedID = expandedID == index ? nil : index
                        }  // ✅ Only 1 morph at a time
                    }
                }
            }
            .glassEffect()
        }
    }
}
```

**Why it matters:** Glass morphing requires real-time computation of interpolated optical distortion between source and destination shapes. Each morph is GPU-intensive. Running more than 5 concurrently exceeds available GPU bandwidth, causing animations to stutter or drop frames. Limiting to 1-2 simultaneous morphs provides the smoothest experience.

Reference: [WWDC 2025 Session 323 - Animation Performance](https://developer.apple.com/videos/wwdc2025/)
