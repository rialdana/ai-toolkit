---
title: Hoist State to the Caller
impact: HIGH
tags: compose, state, patterns
---

## Hoist State to the Caller

Composables should receive state as parameters and notify the caller of changes via callbacks, rather than owning their own state.

**Incorrect (internal state ownership):**

```kotlin
// Bad - composable owns its own state
@Composable
fun EmailField() {
    var email by remember { mutableStateOf("") }  // Hidden internal state
    var isError by remember { mutableStateOf(false) }

    OutlinedTextField(
        value = email,
        onValueChange = {
            email = it
            isError = !it.contains("@")
        },
        isError = isError,
        label = { Text("Email") }
    )
    // Parent has no access to 'email' value — can't validate or submit
}
```

**Correct (state hoisted to caller):**

```kotlin
// Good - state hoisted, composable is stateless
@Composable
fun EmailField(
    email: String,                          // State comes DOWN
    onEmailChange: (String) -> Unit,        // Events go UP
    isError: Boolean = false,
    modifier: Modifier = Modifier
) {
    OutlinedTextField(
        value = email,
        onValueChange = onEmailChange,
        isError = isError,
        label = { Text("Email") },
        modifier = modifier
    )
}

// Caller controls state
@Composable
fun SignUpForm(viewModel: SignUpViewModel) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    EmailField(
        email = uiState.email,
        onEmailChange = viewModel::onEmailChanged,
        isError = uiState.emailError != null
    )
}
```

**When to keep state internal:**
- Purely visual state (animation, scroll position)
- Transient UI state the parent never needs (tooltip visibility)
- Use `rememberSaveable` if internal state should survive configuration changes

**Why it matters:**
- Hoisted composables are reusable — any parent can control them
- Enables single source of truth (ViewModel owns the state)
- Makes composables testable — pass state in, assert output
- Follows Compose's unidirectional data flow model

Reference: [State hoisting](https://developer.android.com/develop/ui/compose/state#state-hoisting)
