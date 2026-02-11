---
title: Use Unidirectional Data Flow with UI State
impact: HIGH
tags: architecture, state, udf
---

## Use Unidirectional Data Flow with UI State

State flows down from ViewModel to UI; events flow up from UI to ViewModel. Never let the UI mutate state directly.

**Incorrect (bidirectional state mutation):**

```kotlin
// Bad - UI mutates state directly, no single source of truth
class ProfileViewModel : ViewModel() {
    var name = mutableStateOf("")        // Exposed mutable state
    var isLoading = mutableStateOf(false) // Multiple independent states
    var error = mutableStateOf<String?>(null)

    fun loadProfile() {
        isLoading.value = true
        // Multiple state fields can go out of sync
    }
}

@Composable
fun ProfileScreen(viewModel: ProfileViewModel) {
    // Bad - UI writes to ViewModel state directly
    TextField(
        value = viewModel.name.value,
        onValueChange = { viewModel.name.value = it }  // Direct mutation!
    )
}
```

**Correct (unidirectional data flow):**

```kotlin
// Good - sealed UI state, single source of truth
data class ProfileUiState(
    val name: String = "",
    val isLoading: Boolean = false,
    val error: String? = null
)

class ProfileViewModel(
    private val profileRepository: ProfileRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(ProfileUiState())
    val uiState: StateFlow<ProfileUiState> = _uiState.asStateFlow()

    fun onNameChanged(name: String) {           // Events come UP
        _uiState.update { it.copy(name = name) }
    }

    fun onSaveClicked() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true) }
            profileRepository.save(_uiState.value.name)
                .onSuccess { _uiState.update { it.copy(isLoading = false) } }
                .onFailure { e ->
                    _uiState.update { it.copy(isLoading = false, error = e.message) }
                }
        }
    }
}

@Composable
fun ProfileScreen(viewModel: ProfileViewModel) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    TextField(
        value = uiState.name,
        onValueChange = viewModel::onNameChanged  // Event flows UP
    )
}
```

**Why it matters:**
- Single source of truth prevents state inconsistencies
- UI is a pure function of state — easier to test and reason about
- State transitions are explicit and traceable
- Prevents race conditions from concurrent state mutations

Reference: [State and Jetpack Compose](https://developer.android.com/develop/ui/compose/state)
