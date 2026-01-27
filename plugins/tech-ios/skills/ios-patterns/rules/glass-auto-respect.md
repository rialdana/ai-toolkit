---
title: Glass Auto-Respects Reduce Transparency and Increase Contrast
impact: CRITICAL
tags: liquid-glass, accessibility, reduce-transparency, increase-contrast, a11y
---

## Glass Auto-Respects Reduce Transparency and Increase Contrast

Glass effects automatically adapt to Reduce Transparency and Increase Contrast accessibility settings. Never override this behavior or implement custom fallbacks—the system handles it correctly.

**Incorrect:**

```swift
// ❌ WRONG: Manual fallback overrides automatic behavior
struct NavBar: View {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency

    var body: some View {
        if #available(iOS 26.0, *) {
            Text("App Name")
                .background {
                    if reduceTransparency {
                        Color.black.opacity(0.9)  // ❌ Manual override
                    } else {
                        Color.clear
                            .glassEffect()
                    }
                }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Glass auto-adapts, no manual handling needed
struct NavBar: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            Text("App Name")
                .glassEffect()  // ✅ Auto-respects all a11y settings
        }
    }
}
```

**Why it matters:** When Reduce Transparency is enabled, glass automatically renders as a frostier, more opaque material with increased contrast. When Increase Contrast is enabled, glass is replaced with solid black/white backgrounds with borders. Manual fallbacks create inconsistent experiences and often have insufficient contrast, violating WCAG 2.1 AA standards. Trust the system's automatic adaptation.

Reference: [Accessibility and Glass Effects](https://developer.apple.com/documentation/swiftui/glasseffect/accessibility)
