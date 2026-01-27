---
title: Apply Glass to Navigation Layer Only, Never Content
impact: CRITICAL
tags: liquid-glass, navigation, chrome, ui-layer
---

## Apply Glass to Navigation Layer Only, Never Content

Liquid Glass is designed exclusively for navigation and chrome elements (nav bars, toolbars, tab bars, sheets). Applying glass to content reduces readability and violates Apple's design system.

**Incorrect:**

```swift
// ❌ WRONG: Glass applied to content
struct ContentView: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            VStack {
                Image("photo")
                    .glassEffect()  // Content should not have glass

                Text("Description")
                    .glassEffect()  // Text content with glass is unreadable

                ContentCard()
                    .glassEffect()  // Cards are content, not navigation
            }
        }
    }
}
```

**Correct:**

```swift
// ✅ CORRECT: Glass only on navigation elements
struct ContentView: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            NavigationStack {
                ScrollView {
                    // Content with NO glass
                    Image("photo")
                    Text("Description")
                    ContentCard()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("My App")
                            .glassEffect()  // ✅ Navigation chrome only
                    }
                }
            }
        }
    }
}
```

**Why it matters:** Glass creates depth through optical distortion, which is perfect for separating navigation from content but makes text and images harder to read. Applying glass to content violates HIG guidelines and creates accessibility issues.

Reference: [HIG - Liquid Glass](https://developer.apple.com/design/human-interface-guidelines/liquid-glass)
