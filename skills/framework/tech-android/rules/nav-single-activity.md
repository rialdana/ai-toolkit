---
title: Prefer Single-Activity Architecture with Compose Navigation
impact: MEDIUM
tags: navigation, architecture, compose
---

## Prefer Single-Activity Architecture with Compose Navigation

Use one `Activity` as the host and handle all screen transitions with Compose Navigation. Avoid multi-activity architectures for in-app navigation.

**Incorrect (multiple activities for screens):**

```kotlin
// Bad - separate Activity per screen
class HomeActivity : ComponentActivity() { /* ... */ }
class ProfileActivity : ComponentActivity() { /* ... */ }
class SettingsActivity : ComponentActivity() { /* ... */ }

// Bad - Intent-based navigation between screens
fun navigateToProfile(context: Context, userId: String) {
    val intent = Intent(context, ProfileActivity::class.java)
    intent.putExtra("USER_ID", userId)  // Untyped, error-prone
    context.startActivity(intent)
}
```

**Correct (single Activity with Compose Navigation):**

```kotlin
// Good - one Activity hosts the entire app
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AppTheme {
                AppNavigation()
            }
        }
    }
}

// Good - all screens are composables in the navigation graph
@Composable
fun AppNavigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Home) {
        composable<Home> {
            HomeScreen(
                onNavigateToProfile = { userId ->
                    navController.navigate(Profile(userId))
                }
            )
        }
        composable<Profile> { backStackEntry ->
            val profile: Profile = backStackEntry.toRoute()
            ProfileScreen(userId = profile.userId)
        }
        composable<Settings> {
            SettingsScreen()
        }
    }
}
```

**When multiple Activities are still appropriate:**
- Launching external apps (camera, file picker, maps)
- Android system requirements (e.g., separate process for media playback)
- Legacy module integration during migration
- Different `windowSoftInputMode` requirements (rare)

**Why it matters:**
- Shared state (theme, auth, nav controller) lives in one component tree
- Compose Navigation provides typed arguments, animations, and back stack management
- Activity transitions are heavier than composable transitions
- Single Activity simplifies deep link handling and process death restoration

Reference: [Navigation with Compose](https://developer.android.com/develop/ui/compose/navigation)
