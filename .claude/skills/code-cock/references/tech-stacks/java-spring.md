# Java / Spring - Technology Stack Guide

## Purpose

Technology-specific guidance for Java and Spring Boot development workflows. Use this as a supplement to core templates when working with Java/Spring projects.

## Technology Detection {#java-spring-detection}

**Detect Java/Spring Boot when:**
- `pom.xml` exists (Maven project) with `spring-boot-starter`
- `build.gradle` or `build.gradle.kts` with Spring dependencies
- `@SpringBootApplication`, `@RestController`, `@Service` annotations
- `src/main/java/` directory structure
- `application.properties` or `application.yml`

**Spring Version Detection:**
```xml
<!-- pom.xml -->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.2.0</version>  <!-- Detected: Spring Boot 3.2.0 -->
</parent>
```

---

## Auto-Inferred Constraint Files {#java-spring-constraints}

Based on Java/Spring detection, suggest these `cock-docs/tech-guidance` files:

| File | Description |
|------|-------------|
| `spring-service-layer-rules.md` | Service layer patterns, transaction management |
| `spring-rest-controller-rules.md` | REST API design, validation, error handling |
| `spring-data-jpa-rules.md` | JPA repository patterns, N+1 prevention |
| `java-stream-rules.md` | Stream API usage, lazy evaluation |
| `java-exception-handling-rules.md` | Exception hierarchy, @ControllerAdvice |
| `spring-security-rules.md` | Security configuration, authentication/authorization |

---

## Mode Configuration {#java-spring-modes}

### Single-Stack (Backend)

**Mode A: Backend / Core Logic**
- **Trigger:** Working on `src/main/java/`, domain, service, controller layers
- **File Extensions:** `*.java`
- **Workflow:** TDD (Test-Driven Development)
- **Testing Framework:** JUnit 5 + Mockito + AssertJ

**Layer Separation:**
- Controller Layer: REST endpoints only, delegate to services
- Service Layer: Business logic, transaction boundaries
- Repository/DAO Layer: Data access, queries only
- DTO Layer: Data transfer objects for API contracts

---

## Project Structure Patterns

### Standard Spring Boot Project

```
project-root/
├── src/main/java/
│   └── com/company/project/
│       ├── controller/           # REST endpoints (@RestController)
│       │   └── *Controller.java
│       ├── service/              # Business logic (@Service)
│       │   ├── impl/             # Service implementations
│       │   └── *Service.java     # Service interfaces
│       ├── repository/           # Data access (@Repository)
│       │   └── *Repository.java
│       ├── entity/               # JPA entities (@Entity)
│       │   └── *.java
│       ├── dto/                  # Data transfer objects
│       │   ├── request/          # Request DTOs
│       │   └── response/         # Response DTOs
│       ├── config/               # Spring configuration (@Configuration)
│       │   └── *Config.java
│       ├── exception/            # Custom exceptions
│       │   └── *Exception.java
│       └── util/                 # Utility classes
├── src/main/resources/
│   ├── application.yml           # Configuration
│   ├── application.properties
│   └── db/migration/             # Database migrations (Flyway)
├── src/test/java/                # Test files (mirror main structure)
├── pom.xml                       # Maven dependencies
└── Dockerfile
```

---

## Java/Spring-Specific Standards

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Package | `all.lowercase` | `com.example.project.controller` |
| Class | `PascalCase` | `UserController`, `UserService` |
| Interface | `PascalCase` (often prefix with I) | `IUserService`, `UserRepository` |
| Method | `camelCase` | `getUserById()`, `validateInput()` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT` |
| Test Method | `camelCase`, descriptive | `shouldReturnUserWhenFound()` |

### Code Style Guidelines

```java
// ✅ Good: Layered architecture
@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping
    public ResponseEntity<UserResponse> createUser(@RequestBody @Valid UserRequest request) {
        UserResponse response = userService.createUser(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getUserById(@PathVariable String id) {
        UserResponse response = userService.getUserById(id);
        return ResponseEntity.ok(response);
    }
}

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public UserResponse getUserById(String id) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new UserNotFoundException(id));
        return userMapper.toResponse(user);
    }

    @Transactional
    public UserResponse createUser(UserRequest request) {
        User user = userMapper.toEntity(request);
        user = userRepository.save(user);
        return userMapper.toResponse(user);
    }
}

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    // Custom query methods
    Optional<User> findByEmail(String email);
}
```

```java
// ❌ Bad: Business logic in controller
@RestController
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/{id}")
    public ResponseEntity<User> getUser(@PathVariable String id) {
        // Business logic in controller - bad practice!
        User user = userRepository.findById(id).orElse(null);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(user);
    }
}
```

---

## Testing Standards

### Test Structure

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private UserService userService;

    @Test
    @DisplayName("Should return user when found")
    void shouldReturnUserWhenFound() {
        // Given
        String userId = "123";
        User user = new User(userId, "John", "john@example.com");
        UserResponse expectedResponse = new UserResponse(userId, "John", "john@example.com");

        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(userMapper.toResponse(user)).thenReturn(expectedResponse);

        // When
        UserResponse actualResponse = userService.getUserById(userId);

        // Then
        assertThat(actualResponse).isEqualTo(expectedResponse);
        verify(userRepository).findById(userId);
        verify(userMapper).toResponse(user);
    }

    @Test
    @DisplayName("Should throw exception when user not found")
    void shouldThrowExceptionWhenUserNotFound() {
        // Given
        String userId = "999";
        when(userRepository.findById(userId)).thenReturn(Optional.empty());

        // When/Then
        assertThatThrownBy(() -> userService.getUserById(userId))
            .isInstanceOf(UserNotFoundException.class)
            .hasMessageContaining(userId);
    }
}
```

### Mockito Patterns

```java
// Mock verification
verify(repository).findById(anyString());
verify(repository, times(1)).save(any(User.class));
verify(repository, never()).deleteById(anyString());

// Mock stubbing
when(repository.findById("123")).thenReturn(Optional.of(user));
when(repository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));
when(service.process(any())).thenThrow(new ValidationException("Invalid"));

// Argument matching
when(repository.findById(argThat(id -> id != null && id.length() > 0)))
    .thenReturn(Optional.of(user));

// InOrder verification
InOrder inOrder = inOrder(repository, emailService);
inOrder.verify(repository).save(any());
inOrder.verify(emailService).sendWelcomeEmail(any());
```

---

## Spring-Specific Patterns

### Exception Handling

```java
// ✅ Good: Centralized exception handling
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUserNotFound(UserNotFoundException ex) {
        ErrorResponse error = ErrorResponse.builder()
            .code("USER_NOT_FOUND")
            .message(ex.getMessage())
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        String errors = ex.getBindingResult().getFieldErrors().stream()
            .map(FieldError::getDefaultMessage)
            .collect(Collectors.joining(", "));
        ErrorResponse error = ErrorResponse.builder()
            .code("VALIDATION_ERROR")
            .message(errors)
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.badRequest().body(error);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneric(Exception ex) {
        ErrorResponse error = ErrorResponse.builder()
            .code("INTERNAL_ERROR")
            .message("An unexpected error occurred")
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
```

### DTO Mapping

```java
// ✅ Good: Separate DTOs from entities
@Data
public class UserRequest {
    @NotBlank(message = "Name is required")
    private String name;

    @Email(message = "Invalid email format")
    private String email;
}

@Data
public class UserResponse {
    private String id;
    private String name;
    private String email;
}

@Component
public class UserMapper {

    public User toEntity(UserRequest request) {
        return User.builder()
            .name(request.getName())
            .email(request.getEmail())
            .build();
    }

    public UserResponse toResponse(User user) {
        return UserResponse.builder()
            .id(user.getId())
            .name(user.getName())
            .email(user.getEmail())
            .build();
    }
}
```

---

## Build Commands

### Maven

```bash
# Build project
mvn clean install

# Run tests
mvn test

# Run specific test
mvn test -Dtest=UserServiceTest

# Run specific test method
mvn test -Dtest=UserServiceTest#shouldReturnUserWhenFound

# Skip tests during build
mvn clean install -DskipTests

# Package without tests
mvn clean package -DskipTests

# Run Spring Boot application
mvn spring-boot:run

# Check dependency tree
mvn dependency:tree
```

### Gradle

```bash
# Build project
./gradlew build

# Run tests
./gradlew test

# Run specific test
./gradlew test --tests UserServiceTest

# Boot run
./gradlew bootRun

# Check dependencies
./gradlew dependencies
```

---

## Quick Reference

| Action | Maven | Gradle |
|--------|-------|--------|
| Build | `mvn clean install` | `./gradlew build` |
| Test | `mvn test` | `./gradlew test` |
| Clean | `mvn clean` | `./gradlew clean` |
| Package | `mvn package` | `./gradlew bootJar` |
| Run | `mvn spring-boot:run` | `./gradlew bootRun` |

---

## Common Pitfalls

### 1. N+1 Query Problem

```java
// ❌ Bad: N+1 queries
@OneToMany(mappedBy = "user")
private List<Order> orders;  // Fetches orders for each user separately

// ✅ Good: Use JOIN FETCH
@Query("SELECT u FROM User u LEFT JOIN FETCH u.orders WHERE u.id = :id")
Optional<User> findByIdWithOrders(@Param("id") String id);

// Or use entity graph
@EntityGraph(attributePaths = {"orders"})
Optional<User> findById(String id);
```

### 2. Transaction Boundaries

```java
// ❌ Bad: Transaction not committed
@Transactional
public void createUserAndSendEmail(UserRequest request) {
    User user = userRepository.save(userMapper.toEntity(request));
    emailService.sendEmail(user);  // Exception rolls back transaction!
}

// ✅ Good: Separate transaction boundaries
@Transactional
public User createUser(UserRequest request) {
    return userRepository.save(userMapper.toEntity(request));
}

@Transactional(propagation = Propagation.REQUIRES_NEW)
public void sendWelcomeEmail(User user) {
    emailService.sendEmail(user);
}
```

### 3. LazyInitializationException

```java
// ❌ Bad: Access lazy collection outside transaction
@Service
public class UserService {
    public User getUserWithOrders(String id) {
        return userRepository.findById(id).get();  // Orders not loaded
    }
}
@RestController
public class UserController {
    @GetMapping("/{id}/orders")
    public List<Order> getOrders(@PathVariable String id) {
        User user = userService.getUserWithOrders(id);
        return user.getOrders();  // LazyInitializationException!
    }
}

// ✅ Good: Use DTO projection or JOIN FETCH
@Data
public class UserWithOrdersDTO {
    private String id;
    private String name;
    private List<OrderDTO> orders;
}
```

---

## Integration with CLAUDE.md

### Knowledge Base Indexing

Add to **Tech Constraints** table:

```markdown
| `cock-docs/tech-guidance/spring-service-layer-rules.md` | Service layer patterns, transaction management |
| `cock-docs/tech-guidance/spring-rest-controller-rules.md` | REST API design, validation, error handling |
| `cock-docs/tech-guidance/spring-data-jpa-rules.md` | JPA repository patterns, N+1 prevention |
```

### Self-Verification Loop

```markdown
- [ ] Spring: [OK/Unclear] - Checked `cock-docs/tech-guidance/spring-*-rules.md`?
- [ ] Layer Separation: [Yes/No] - Business logic in service layer?
- [ ] Transactions: [Yes/No] - Proper @Transactional usage?
- [ ] N+1 Queries: [Yes/No] - Used JOIN FETCH or entity graphs?
```

---

## Additional Resources

- **Spring Boot Documentation:** https://spring.io/projects/spring-boot
- **Spring Framework:** https://spring.io/projects/spring-framework
- **Spring Data JPA:** https://spring.io/projects/spring-data-jpa
- **JUnit 5:** https://junit.org/junit5/docs/current/user-guide/
- **Mockito:** https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html
