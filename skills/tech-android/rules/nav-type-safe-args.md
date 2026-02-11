---
title: Use Type-Safe Navigation Arguments
impact: HIGH
tags: navigation, compose, type-safety
---

## Use Type-Safe Navigation Arguments

Define navigation routes as data classes or sealed classes with typed parameters instead of raw strings with manual argument parsing.

**Incorrect (string-based routes with manual parsing):**

```kotlin
// Bad - raw string routes, no type safety
NavHost(navController, startDestination = "home") {
    composable("home") { HomeScreen() }
    composable("profile/{userId}") { backStackEntry ->
        val userId = backStackEntry.arguments?.getString("userId")  // Nullable String
            ?: return@composable
        ProfileScreen(userId)
    }
    composable("order/{orderId}?showReview={showReview}") { backStackEntry ->
        val orderId = backStackEntry.arguments?.getString("orderId")!!  // Crash-prone
        val showReview = backStackEntry.arguments?.getString("showReview")?.toBoolean() ?: false
        OrderScreen(orderId, showReview)
    }
}

// Bad - hardcoded route strings scattered everywhere
navController.navigate("profile/user123")
navController.navigate("order/ord456?showReview=true")
```

**Correct (type-safe navigation with serializable routes):**

```kotlin
// Good - typed route definitions (Navigation 2.8+)
@Serializable
data object Home

@Serializable
data class Profile(val userId: String)

@Serializable
data class Order(val orderId: String, val showReview: Boolean = false)

// Good - type-safe NavHost
NavHost(navController, startDestination = Home) {
    composable<Home> { HomeScreen() }
    composable<Profile> { backStackEntry ->
        val profile: Profile = backStackEntry.toRoute()
        ProfileScreen(profile.userId)
    }
    composable<Order> { backStackEntry ->
        val order: Order = backStackEntry.toRoute()
        OrderScreen(order.orderId, order.showReview)
    }
}

// Good - type-safe navigation calls
navController.navigate(Profile(userId = "user123"))
navController.navigate(Order(orderId = "ord456", showReview = true))
```

**Why it matters:**
- String routes fail at runtime, typed routes fail at compile time
- No more manual argument parsing or nullable casts
- Refactoring a parameter name updates all usages
- Default values are expressed in Kotlin, not URL query strings

Reference: [Type safe navigation](https://developer.android.com/guide/navigation/design/type-safety)
