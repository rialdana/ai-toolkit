---
title: HTTP Clients — Retrofit, Ktor, Error Handling
impact: HIGH
tags: networking, retrofit, ktor, error-handling
---

## HTTP Clients — Retrofit, Ktor, Error Handling

Use suspend functions, handle errors with `Result`, and configure clients with interceptors/plugins for cross-cutting concerns. Choose between Retrofit and Ktor based on project needs.

### Retrofit

Use `suspend` functions, not `Call<T>`. Configure OkHttp interceptors for auth and logging.

**Incorrect:**

```kotlin
// Bad - blocking Call, no cancellation support
interface UserApi {
    @GET("users/{id}")
    fun getUser(@Path("id") id: String): Call<UserDto>
}

// Bad - swallows all errors
class UserRepository(private val api: UserApi) {
    suspend fun getUser(id: String): UserDto? {
        return try {
            api.getUser(id).execute().body()  // Blocks!
        } catch (e: Exception) {
            null  // Network error? 404? Parse failure? Who knows
        }
    }
}
```

**Correct:**

```kotlin
// Good - suspend functions
interface UserApi {
    @GET("users/{id}")
    suspend fun getUser(@Path("id") id: String): UserDto

    @GET("users")
    suspend fun getUsers(@Query("page") page: Int): List<UserDto>
}

// Good - structured error handling with Result
class UserRepositoryImpl(private val api: UserApi) : UserRepository {
    override suspend fun getUser(id: String): Result<User> {
        return runCatching { api.getUser(id).toDomain() }
    }
}

// Good - OkHttp client with interceptors
val okHttpClient = OkHttpClient.Builder()
    .addInterceptor(AuthInterceptor(tokenProvider))
    .addInterceptor(HttpLoggingInterceptor().apply {
        level = if (BuildConfig.DEBUG) HttpLoggingInterceptor.Level.BODY
        else HttpLoggingInterceptor.Level.NONE
    })
    .connectTimeout(30, TimeUnit.SECONDS)
    .readTimeout(30, TimeUnit.SECONDS)
    .build()

val retrofit = Retrofit.Builder()
    .baseUrl("https://api.example.com/")
    .client(okHttpClient)
    .addConverterFactory(Json.asConverterFactory("application/json".toMediaType()))
    .build()
```

### Ktor

Configure with plugins for content negotiation, logging, and timeouts. Use `HttpClient` as a singleton.

**Incorrect:**

```kotlin
// Bad - raw client, manual JSON, no error handling
val client = HttpClient()
val json = client.get("https://api.example.com/users/$id").bodyAsText()
return Json.decodeFromString(json)  // Crashes on non-200
```

**Correct:**

```kotlin
// Good - configured singleton with plugins
val client = HttpClient(OkHttp) {
    install(ContentNegotiation) {
        json(Json { ignoreUnknownKeys = true; isLenient = true })
    }
    install(Logging) {
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
}

// Good - repository with Result wrapper
class UserRepositoryImpl(private val client: HttpClient) : UserRepository {
    override suspend fun getUser(id: String): Result<User> {
        return runCatching { client.get("users/$id").body<UserDto>().toDomain() }
    }
}
```

### Choosing Between Retrofit and Ktor

| Criteria | Retrofit | Ktor |
|----------|----------|------|
| **API style** | Interface + annotations | DSL builder |
| **KMP support** | Android/JVM only | Multiplatform |
| **WebSocket** | Via OkHttp | First-class support |
| **Testing** | MockWebServer | MockEngine (no server) |
| **Ecosystem** | Mature, widely adopted | Growing, JetBrains-maintained |

- **Retrofit** — Android-only REST APIs, team familiarity, mature interceptor ecosystem
- **Ktor** — Kotlin Multiplatform, first-class WebSocket, DSL-based config, MockEngine testing
- **Both together** is fine — e.g., Retrofit for REST, Ktor for WebSocket

**Why it matters:**
- `Call<T>` blocks threads and ignores coroutine cancellation
- Swallowing exceptions hides network, auth, and parsing failures
- Interceptors/plugins centralize auth, logging, and retry — don't repeat per-endpoint
- `HttpClient` and `OkHttpClient` should be singletons — creating per-request wastes resources

Reference: [Retrofit](https://square.github.io/retrofit/) | [Ktor Client](https://ktor.io/docs/client-create-new-application.html)
