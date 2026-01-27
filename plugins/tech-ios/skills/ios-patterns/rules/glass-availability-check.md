---
title: Always Wrap Glass with #available(iOS 26.0, *)
impact: MEDIUM-HIGH
tags: liquid-glass, availability, ios26, backward-compatibility, platform
---

## Always Wrap Glass with #available(iOS 26.0, *)

Glass effects are only available on iOS 26.0+ and iPadOS 26.0+. Always wrap glass code in availability checks to prevent crashes on older iOS versions.

**Incorrect:**

```swift
// ❌ WRONG: No availability check, crashes on iOS 25 and below
struct NavBar: View {
    var body: some View {
        NavigationStack {
            ContentView()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("My App")
                            .glassEffect()  // ❌ Crashes on iOS < 26
                    }
                }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Availability check with fallback
struct NavBar: View {
    var body: some View {
        NavigationStack {
            ContentView()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        if #available(iOS 26.0, *) {
                            Text("My App")
                                .glassEffect()  // ✅ Safe on iOS 26+
                        } else {
                            Text("My App")
                                .background(.ultraThinMaterial)  // Fallback
                        }
                    }
                }
        }
    }
}
```

**Why it matters:** The `.glassEffect()` modifier and related APIs (`UIGlassEffect`, `GlassEffectContainer`) don't exist on iOS 25 and earlier. Calling them without availability checks causes immediate runtime crashes. Using `#available` ensures graceful degradation with appropriate fallback styling for older iOS versions.

Reference: [Checking API Availability](https://developer.apple.com/documentation/swift/checking-api-availability)
