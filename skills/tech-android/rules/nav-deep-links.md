---
title: Declare Deep Links in Navigation Graph, Not Manifest Only
impact: MEDIUM
tags: navigation, deep-links, compose
---

## Declare Deep Links in Navigation Graph, Not Manifest Only

Register deep links in the Compose Navigation graph so they resolve to the correct screen with proper back stack handling, not just in the AndroidManifest.

**Incorrect (manifest-only deep links):**

```xml
<!-- Bad - deep link only in manifest, no navigation graph binding -->
<activity android:name=".MainActivity">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" android:host="example.com" android:pathPrefix="/profile" />
    </intent-filter>
</activity>
```

```kotlin
// Bad - manually parsing intent in Activity
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val uri = intent.data  // Manual URI parsing
        if (uri?.pathSegments?.first() == "profile") {
            // Navigate manually — no back stack, no type safety
        }
    }
}
```

**Correct (deep links in navigation graph):**

```xml
<!-- Manifest still declares the intent filter for the OS -->
<activity android:name=".MainActivity">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" android:host="example.com" />
    </intent-filter>
</activity>
```

```kotlin
// Good - deep link declared in navigation graph
NavHost(navController, startDestination = Home) {
    composable<Home> { HomeScreen() }

    composable<Profile>(
        deepLinks = listOf(
            navDeepLink<Profile>(basePath = "https://example.com/profile")
        )
    ) { backStackEntry ->
        val profile: Profile = backStackEntry.toRoute()
        ProfileScreen(profile.userId)
    }
}

// Navigation automatically:
// 1. Matches the URI to the correct composable
// 2. Extracts typed arguments
// 3. Builds the correct back stack (Home → Profile)
```

**Why it matters:**
- Navigation graph deep links get automatic argument extraction and type safety
- Back stack is synthesized correctly — pressing Back goes to the parent, not exit
- Centralizes routing logic in one place instead of scattered intent parsing
- Deep link testing is easier with Navigation's `TestNavHostController`

Reference: [Create a deep link for a destination](https://developer.android.com/guide/navigation/design/deep-link)
