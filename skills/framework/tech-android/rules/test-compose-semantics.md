---
title: Test Compose UI via Semantics, Not Implementation Details
impact: HIGH
tags: testing, compose, semantics
---

## Test Compose UI via Semantics, Not Implementation Details

Test composables by querying semantics (text, content descriptions, test tags) — never by internal state, class names, or node position.

**Incorrect (testing implementation details):**

```kotlin
// Bad - testing internal state directly
@Test
fun loginButton_showsLoading() {
    val viewModel = LoginViewModel()
    composeTestRule.setContent { LoginScreen(viewModel) }

    // Testing ViewModel internals, not UI
    viewModel.onLoginClicked("user", "pass")
    assertTrue(viewModel.uiState.value.isLoading)  // Not a UI test!
}

// Bad - fragile node index queries
@Test
fun thirdItem_isVisible() {
    composeTestRule.setContent { ItemList(items) }

    // Position-dependent — breaks if layout changes
    composeTestRule.onAllNodes(hasClickAction())[2].assertIsDisplayed()
}
```

**Correct (semantic-based testing):**

```kotlin
// Good - test what the user sees
@Test
fun loginButton_showsLoadingIndicator() {
    composeTestRule.setContent {
        LoginScreen(viewModel = LoginViewModel())
    }

    composeTestRule.onNodeWithText("Log in").performClick()

    composeTestRule
        .onNodeWithContentDescription("Loading")
        .assertIsDisplayed()
}

// Good - test tag for elements without text
@Test
fun profileImage_isDisplayed() {
    composeTestRule.setContent {
        ProfileScreen(user = testUser)
    }

    composeTestRule
        .onNodeWithTag("profile_avatar")
        .assertIsDisplayed()
}

// Good - combined matchers for specificity
@Test
fun deleteButton_inFirstItem_isClickable() {
    composeTestRule.setContent { ItemList(items) }

    composeTestRule
        .onNode(
            hasText("Delete") and hasAnyAncestor(hasText(items.first().title))
        )
        .assertHasClickAction()
}

// Good - test user flows end-to-end
@Test
fun signUpFlow_showsSuccessMessage() {
    composeTestRule.setContent { SignUpScreen() }

    composeTestRule.onNodeWithText("Email").performTextInput("test@example.com")
    composeTestRule.onNodeWithText("Password").performTextInput("securePass123")
    composeTestRule.onNodeWithText("Sign Up").performClick()

    composeTestRule.onNodeWithText("Account created").assertIsDisplayed()
}
```

**Why it matters:**
- Semantic tests survive refactors (reorder components, change layout)
- Tests verify what users experience, not how it's implemented
- `testTag` is available when text/description isn't sufficient
- Matches how accessibility tools interact with the UI

Reference: [Testing your Compose layout](https://developer.android.com/develop/ui/compose/testing)
