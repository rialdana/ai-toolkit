---
title: Never Stack Glass on Glass (Causes Visual Artifacts)
impact: CRITICAL
tags: liquid-glass, stacking, visual-artifacts, rendering
---

## Never Stack Glass on Glass (Causes Visual Artifacts)

Stacking multiple glass effects creates compounding optical distortion that produces visual artifacts, rendering glitches, and makes UI elements unreadable.

**Incorrect:**

```swift
// ❌ WRONG: Glass-on-glass stacking
struct ToolbarView: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack {
                Button("Option 1").glassEffect()
                Button("Option 2").glassEffect()
                Button("Option 3").glassEffect()
            }
            .glassEffect()  // Triple-stacked glass causes artifacts
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Use GlassEffectContainer for multiple elements
struct ToolbarView: View {
    @Namespace private var glassNamespace

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 40) {
                Button("Option 1")
                    .glassEffectID("btn1", in: glassNamespace)

                Button("Option 2")
                    .glassEffectID("btn2", in: glassNamespace)

                Button("Option 3")
                    .glassEffectID("btn3", in: glassNamespace)
            }
            .glassEffect()  // ✅ Single glass layer
        }
    }
}
```

**Why it matters:** Each glass layer adds optical distortion. Stacking them compounds the effect, causing visual artifacts like color fringing, blur halos, and rendering glitches that make UI unusable. GlassEffectContainer manages multiple elements within a single glass layer.

Reference: [WWDC 2025 Session 219 - Meet Liquid Glass](https://developer.apple.com/videos/wwdc2025/)
