---
title: Use GlassEffectContainer for Multiple Glass Elements
impact: CRITICAL
tags: liquid-glass, container, multi-element, spacing
---

## Use GlassEffectContainer for Multiple Glass Elements

When displaying multiple interactive elements that need glass, always use GlassEffectContainer with proper spacing to prevent visual artifacts and maintain optical clarity.

**Incorrect:**

```swift
// ❌ WRONG: Individual glass effects too close together
struct ActionBar: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            HStack(spacing: 8) {  // Too close!
                Button("Save").glassEffect()
                Button("Share").glassEffect()
                Button("Delete").glassEffect()
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: GlassEffectContainer with proper spacing
struct ActionBar: View {
    @Namespace private var glassNamespace

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 40) {  // ✅ 40pt spacing
                Button("Save")
                    .glassEffectID("save", in: glassNamespace)

                Button("Share")
                    .glassEffectID("share", in: glassNamespace)

                Button("Delete")
                    .glassEffectID("delete", in: glassNamespace)
            }
            .glassEffect(.regular)
        }
    }
}
```

**Why it matters:** Glass effects need physical separation (min 20pt, recommended 40pt) to prevent optical interference. GlassEffectContainer manages this spacing automatically and renders all children within a single glass layer, avoiding stacking artifacts while maintaining visual separation.

Reference: [SwiftUI GlassEffectContainer API](https://developer.apple.com/documentation/swiftui/glasseffectcontainer)
