---
title: Configure Ktor Client with Proper Plugins and Error Handling
impact: HIGH
tags: networking, ktor, error-handling
---

## Configure Ktor Client with Proper Plugins and Error Handling

Configure Ktor with content negotiation, logging, and error handling plugins. Use `HttpClient` as a singleton and handle errors with `Result` or sealed types.

**Incorrect (no plugins, no error handling):**

```kotlin
// Bad - raw client with no configuration
val client = HttpClient()

// Bad - unhandled exceptions, manual JSON parsing
suspend fun getUser(id: String): User {
    val response = client.get("https://api.example.com/users/$id")
    val json = response.bodyAsText()
    return Json.decodeFromString(json)  // Crashes on non-200, no error handling
}
```

**Correct (configured client with plugins):**

```kotlin
// Good - configured singleton with plugins
val client = HttpClient(OkHttp) {  // or CIO, Android engine
    install(ContentNegotiation) {
        json(Json {
            ignoreUnknownKeys = true
            isLenient = true
        })
    }

    install(Logging) {
        logger = Logger.DEFAULT
        level = if (BuildConfig.DEBUG) LogLevel.BODY else LogLevel.NONE
    }

    install(HttpTimeout) {
        requestTimeoutMillis = 30_000
        connectTimeoutMillis = 15_000
    }

    install(DefaultRequest) {
        url("https://api.example.com/")
        contentType(ContentType.Application.Json)
    }

    HttpResponseValidator {
        handleResponseExceptionWithRequest { cause, _ ->
            throw ApiException(cause.message ?: "Unknown error", cause)
        }
    }
}

// Good - repository with Result wrapper
class UserRepository(private val client: HttpClient) {
    suspend fun getUser(id: String): Result<User> {
        return runCatching {
            client.get("users/$id").body<UserDto>().toDomain()
        }
    }
}

// Good - WebSocket with Ktor
suspend fun connectChat(client: HttpClient) {
    client.webSocket("wss://chat.example.com/ws") {
        for (frame in incoming) {
            when (frame) {
                is Frame.Text -> handleMessage(frame.readText())
                else -> Unit
            }
        }
    }
}
```

**Why it matters:**
- Unconfigured clients lack serialization, timeouts, and error handling
- Manual JSON parsing bypasses content negotiation and is error-prone
- Plugins centralize cross-cutting concerns (auth, logging, retry)
- `HttpClient` should be a singleton — creating per-request wastes resources

Reference: [Ktor Client](https://ktor.io/docs/client-create-new-application.html)
