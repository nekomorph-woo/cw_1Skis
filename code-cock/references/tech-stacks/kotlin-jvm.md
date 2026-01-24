# Kotlin / JVM - Technology Stack Guide

## Purpose

Technology-specific guidance for Kotlin and JVM development workflows. Use this as a supplement to core templates when working with Kotlin/JVM projects.

## Technology Detection {#kotlin-detection}

**Detect Kotlin/JVM when:**
- `build.gradle.kts` exists (Kotlin DSL Gradle project)
- `pom.xml` contains `kotlin-stdlib` or `kotlin-maven-plugin`
- `*.kt` source files are present
- `@NotNull`, `@Nullable` annotations (JetBrains annotations)
- IntelliJ Platform SDK dependencies

**Kotlin Version Detection:**
```kotlin
// build.gradle.kts
plugins {
    kotlin("jvm") version "2.1.0"  // Detected: Kotlin 2.1
}
```

---

## Auto-Inferred Constraint Files {#kotlin-constraints}

Based on Kotlin/JVM detection, suggest these `cock-docs/tech-guidance` files:

| File | Description |
|------|-------------|
| `kotlin-coroutines-rules.md` | Coroutine usage, dispatchers, scope management |
| `kotlin-null-safety-rules.md` | Null safety, nullable types, platform types |
| `kotlin-flow-rules.md` | Flow operators, exception handling, cancellation |
| `intellij-edt-rules.md` | EDT threading for IntelliJ Platform plugins |
| `kotlin-result-pattern-rules.md` | Result<T> pattern for error handling |
| `jvm-module-system-rules.md` | Java modules, JPMS, split packages |

---

## Mode Configuration {#kotlin-modes}

### Single-Stack (Backend/Logic)

**Mode A: Backend / Core Logic**
- **Trigger:** Working on `src/main/kotlin/`, `domain/`, `service/`, `infrastructure/`
- **File Extensions:** `*.kt`, `*.java`
- **Workflow:** TDD (Test-Driven Development)
- **Testing Framework:** JUnit 5 + MockK + AssertJ

**Code Style:**
- Kotlin idiomatic code (data classes, extension functions, sealed classes)
- Immutability by default (`val` over `var`)
- Expression-oriented programming
- Null-safe design (avoid `!!` operator)

### Multi-Stack (IntelliJ Platform Plugin)

**Mode A: Backend / Core Logic** (same as above)
**Mode B: UI / Swing**
- **Trigger:** Working on `src/main/kotlin/.../ui/`, tool windows, dialogs
- **File Extensions:** `*.kt` (UI components)
- **Workflow:** VDD (Visually Driven Development)
- **UI Toolkit:** Swing with IntelliJ UI extensions

---

## Project Structure Patterns

### Standard Kotlin/JVM Project

```
project-root/
├── src/main/kotlin/
│   └── com/company/project/
│       ├── domain/              # Domain layer (entities, value objects)
│       │   ├── model/           # Data classes, sealed classes
│       │   ├── repository/      # Repository interfaces
│       │   └── service/         # Business logic interfaces
│       ├── application/         # Application layer (use cases)
│       ├── infrastructure/      # Infrastructure (repositories, services)
│       │   ├── persistence/     # Database, file I/O
│       │   ├── network/         # HTTP clients, API calls
│       │   └── messaging/       # Kafka, RabbitMQ, etc.
│       └── interfaces/          # External interfaces (REST, CLI)
├── src/test/kotlin/             # Test files (mirror main structure)
├── build.gradle.kts             # Gradle build file
└── gradle.properties            # Gradle properties
```

### IntelliJ Platform Plugin

```
plugin-root/
├── src/main/kotlin/
│   └── com/company/plugin/
│       ├── domain/              # Core business logic
│       ├── infrastructure/
│       │   └── intellij/        # IntelliJ platform integration
│       │       ├── actions/     # AnAction implementations
│       │       ├── toolwindow/  # Tool Window factories
│       │       └── settings/    # Configurable settings
│       └── shared/              # Utilities, exceptions
├── src/main/resources/
│   └── META-INF/
│       └── plugin.xml           # Plugin descriptor
├── build.gradle.kts
└── plugin.xml                   # IntelliJ platform configuration
```

---

## Kotlin-Specific Standards

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Package | `all.lowercase` | `com.example.project.service` |
| Class | `PascalCase` | `UserRepository`, `LoginUseCase` |
| Function | `camelCase` | `getUserById()`, `validateInput()` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT` |
| Test Function | `camelCase` with backticks | `` `getUserById should return user when found` `` |

### Code Style Guidelines

```kotlin
// ✅ Good: Kotlin idiomatic code
data class User(
    val id: String,
    val name: String,
    val email: String,
)

sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val error: Error) : Result<Nothing>()
}

// Extension function
fun String.isValidEmail(): Boolean =
    contains("@") && length > 5

// Immutable by default
class UserService(
    private val userRepository: UserRepository,
    private val emailService: EmailService,
) {
    fun getUser(id: String): Result<User> =
        userRepository.findById(id)
            ?.let { Result.Success(it) }
            ?: Result.Error(Error.UserNotFound(id))
}
```

```kotlin
// ❌ Bad: Java-style code in Kotlin
class User {
    var id: String? = null
    var name: String? = null
    // Use data class instead
}

fun getUser(id: String): User? {
    val user = userRepository.findById(id)
    if (user == null) {
        return null  // Use Result<T> or sealed class instead
    }
    return user
}
```

---

## Testing Standards

### Test Structure

```kotlin
class UserServiceTest {
    private lateinit var sut: UserService  // System Under Test
    private lateinit var mockRepository: UserRepository
    private lateinit var mockEmailService: EmailService

    @BeforeEach
    fun setup() {
        mockRepository = mockk()
        mockEmailService = mockk()
        sut = UserService(mockRepository, mockEmailService)
    }

    @Test
    fun `getUserById should return user when found`() {
        // Given
        val expectedUser = User(id = "123", name = "John", email = "john@example.com")
        every { mockRepository.findById("123") } returns expectedUser

        // When
        val result = sut.getUser("123")

        // Then
        assertThat(result).isEqualTo(Result.Success(expectedUser))
        verify { mockRepository.findById("123") }
    }

    @Test
    fun `getUserById should return error when not found`() {
        // Given
        every { mockRepository.findById("999") } returns null

        // When
        val result = sut.getUser("999")

        // Then
        assertThat(result).isInstanceOf(Result.Error::class.java)
    }
}
```

### MockK Patterns

```kotlin
// Mock verification
verify { repository.findById(any()) }
verify(exactly = 1) { repository.save(any()) }
verify(exactly = 0) { emailService.sendEmail(any()) }

// Mock stubbing
every { repository.findById("123") } returns user
every { repository.save(any()) } returnsArgument 0
every { service.process(any()) } throws ValidationException("Invalid")

// Relaxed mock (returns default values)
val relaxedMock = mockk<Repository>(relaxed = true)
```

---

## IntelliJ Platform Specific (EDT Rules)

### EDT Threading

```kotlin
// ❌ Bad: Blocking EDT with long operation
class MyAction : AnAction() {
    override fun actionPerformed(e: AnActionEvent) {
        val result = heavyComputation()  // Blocks EDT!
        updateUI(result)
    }
}

// ✅ Good: Offload to background thread
class MyAction : AnAction() {
    override fun actionPerformed(e: AnActionEvent) {
        val project = e.project ?: return
        Task.Backgroundable(project, "Processing") {
            override fun run(indicator: ProgressIndicator) {
                val result = heavyComputation()
                // Switch back to EDT for UI updates
                EdtExecutor.getInstance().execute {
                    updateUI(result)
                }
            }
        }.queue()
    }
}
```

### Read/Write Actions

```kotlin
// For PSI modifications
WriteAction.run<RuntimeException> {
    element.setName(newName)  // Modifies PSI
}

// For read-only PSI access
ReadAction.run<RuntimeException> {
    val text = element.text  // Reads PSI
}
```

---

## Build Commands

### Gradle (Kotlin DSL)

```bash
# Build project
./gradlew build

# Run tests
./gradlew test

# Compile only
./gradlew compileKotlin

# Clean build
./gradlew clean build

# Run specific test
./gradlew test --tests "UserServiceTest"

# Generate test coverage
./gradlew test jacocoTestReport
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Build | `./gradlew build` |
| Test | `./gradlew test` |
| Clean | `./gradlew clean` |
| Compile | `./gradlew compileKotlin` |
| Format | `./gradlew spotlessApply` |
| Lint | `./gradlew ktlintCheck` |

---

## Common Pitfalls

### 1. Platform Types (Java Interop)

```kotlin
// ❌ Bad: Java code returns null, Kotlin assumes non-null
val name: String = javaClass.getName()  // Can throw NPE!

// ✅ Good: Declare as nullable
val name: String? = javaClass.getName()
// Or use platform type with care
val name = javaClass.getName()  // String! (platform type)
```

### 2. Coroutine Cancellation

```kotlin
// ❌ Bad: Ignoring coroutine cancellation
suspend fun processData(): Data {
    delay(1000)  // Can throw CancellationException
    return heavyComputation()  // Won't execute if cancelled
}

// ✅ Good: Check for cancellation
suspend fun processData(): Data = ensureActive();
    delay(1000)
    return heavyComputation()
}
```

### 3. Extension Function Conflicts

```kotlin
// ❌ Bad: Ambiguous extension functions
fun String.format(): String = this.lowercase()
fun String.format(): String = this.uppercase()  // Conflict!

// ✅ Good: Use distinct names
fun String.toLowercaseFormat(): String = this.lowercase()
fun String.toUppercaseFormat(): String = this.uppercase()
```

---

## Integration with CLAUDE.md

### Knowledge Base Indexing

Add to **Tech Constraints** table:

```markdown
| `cock-docs/tech-guidance/kotlin-coroutines-rules.md` | Kotlin coroutine usage, dispatchers, scope management |
| `cock-docs/tech-guidance/intellij-edt-rules.md` | EDT threading rules for IntelliJ Platform development |
| `cock-docs/tech-guidance/kotlin-null-safety-rules.md` | Null safety, platform types, nullable design |
```

### Self-Verification Loop

```markdown
- [ ] Kotlin: [OK/Unclear] - Checked `cock-docs/tech-guidance/kotlin-*-rules.md`?
- [ ] Coroutines: [Yes/No] - Proper dispatcher usage?
- [ ] Null Safety: [Yes/No] - Avoided platform types and `!!`?
- [ ] EDT: [Yes/N/A] - All UI updates on EDT thread?
```

---

## Additional Resources

- **Kotlin Documentation:** https://kotlinlang.org/docs/
- **Kotlin Coroutines:** https://kotlinlang.org/docs/coroutines-guide.html
- **MockK:** https://mockk.io/
- **IntelliJ Platform SDK:** https://plugins.jetbrains.com/docs/intellij/welcome.html
