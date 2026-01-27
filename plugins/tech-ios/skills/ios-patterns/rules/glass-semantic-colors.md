---
title: Use Semantic Colors, Never Hardcoded RGB Values
impact: MEDIUM
tags: liquid-glass, colors, semantic, dark-mode, accessibility
---

## Use Semantic Colors, Never Hardcoded RGB Values

Always use semantic system colors (`.blue`, `.red`, etc.) for glass tinting. Never use hardcoded RGB values, as glass auto-adapts semantic colors to light/dark mode.

**Incorrect:**

```swift
// ❌ WRONG: Hardcoded RGB prevents dark mode adaptation
struct PrimaryButton: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            Button("Submit") {}
                .glassEffect(.regular.tint(
                    Color(red: 0.0, green: 0.478, blue: 1.0)  // ❌ Hardcoded
                ))
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Semantic colors adapt automatically
struct PrimaryButton: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            Button("Submit") {}
                .glassEffect(.regular.tint(.blue))  // ✅ Semantic color
        }
    }
}

// Or use custom semantic colors from asset catalog
extension Color {
    static let brandPrimary = Color("BrandPrimary")  // ✅ Asset catalog
}

struct BrandButton: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            Button("Continue") {}
                .glassEffect(.regular.tint(.brandPrimary))
        }
    }
}
```

**Why it matters:** Glass effects automatically adjust semantic colors for light/dark mode, increasing/decreasing saturation and brightness as needed. Hardcoded RGB values don't adapt, resulting in poor contrast in dark mode or washed-out colors in light mode. Semantic colors also respect accessibility settings like Increase Contrast.

Reference: [HIG - Color and Semantic Colors](https://developer.apple.com/design/human-interface-guidelines/color)
