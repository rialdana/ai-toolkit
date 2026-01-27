---
title: Use .regular Variant as Default for Standard UI
impact: HIGH
tags: liquid-glass, variants, regular, default
---

## Use .regular Variant as Default for Standard UI

The `.regular` variant is the default and correct choice for all standard UI elements like navigation bars, toolbars, tab bars, and sheets. Other variants are for specific use cases only.

**Incorrect:**

```swift
// ❌ WRONG: Using .clear for standard navigation
struct AppView: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            NavigationStack {
                ContentView()
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("My App")
                                .glassEffect(.clear)  // ❌ Wrong variant
                        }
                    }
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: .regular for standard navigation
struct AppView: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            NavigationStack {
                ContentView()
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("My App")
                                .glassEffect(.regular)  // ✅ Default variant
                        }
                    }
            }
        }
    }
}
```

**Why it matters:** The `.regular` variant provides optimal contrast and readability for standard UI contexts. Using `.clear` in non-media contexts reduces legibility and violates Apple's design guidelines. `.clear` is only for overlaying rich media content like video players.

Reference: [HIG - Choosing Glass Variants](https://developer.apple.com/design/human-interface-guidelines/liquid-glass#choosing-variants)
