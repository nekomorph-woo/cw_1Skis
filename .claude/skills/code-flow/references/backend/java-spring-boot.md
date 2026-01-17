# Java / Spring Boot - Backend Development Guide

## Purpose

Technology-specific guidance for Java and Spring Boot development workflows. Use this as a supplement to core templates when working with Java/Spring Boot projects.

## Technology Detection

**Detect Java/Spring Boot when:**
- `pom.xml` exists (Maven project)
- `build.gradle` exists (Gradle project)
- Files in `src/main/java/` directory
- Spring annotations: `@SpringBootApplication`, `@RestController`, `@Service`
- Dependencies: `spring-boot-starter`

---

## Project Structure

```
project-root/
├── src/main/java/
│   └── com/company/project/
│       ├── controller/     # REST endpoints (@RestController)
│       ├── service/        # Business logic (@Service)
│       ├── manager/        # Complex business logic
│       ├── dao/            # Data access (@Repository)
│       ├── pojo/           # Entity classes (@Entity, @TableName)
│       ├── config/         # Configuration (@Configuration)
│       └── utils/          # Utility classes
├── src/main/resources/
│   ├── mapper/             # MyBatis XML mappers
│   ├── application.yml     # Configuration
│   └── application.properties
├── src/test/java/          # Test files
├── pom.xml                 # Maven dependencies
└── build.gradle            # Gradle build (optional)
```

---

## Writing Plans - Java/Spring Boot Specific

### Compile Command

```bash
# Maven
mvn compile -DskipTests
Expected: BUILD SUCCESS

# Gradle
./gradlew compileJava
Expected: BUILD SUCCESSFUL
```

### Test Commands

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=ClassName

# Run specific test method
mvn test -Dtest=ClassName#methodName

# Skip tests during build
mvn clean install -DskipTests
```

### Build & Package

```bash
# Maven
mvn clean package
Output: target/project-name.jar

# Gradle
./gradlew build
Output: build/libs/project-name.jar
```

### Run Application

```bash
# Maven
mvn spring-boot:run

# Gradle
./gradlew bootRun

# Run JAR directly
java -jar target/project-name.jar
```

---

## Executing Plans - Java/Spring Boot Specific

### File Conventions

| Type | Convention | Example |
|------|------------|---------|
| Controller | `*Controller.java` | `SceneController.java` |
| Service | `*Service.java` | `SceneService.java` |
| Repository/DAO | `*Mapper.java` / `*Repository.java` | `SceneMapper.java` |
| Entity/POJO | `*.java` with `@Entity` or `@TableName` | `Scene.java` |
| DTO/Request/Response | `*Request.java`, `*Response.java` | `SceneCreateRequest.java` |
| Configuration | `*Config.java` | `RedisConfig.java` |

### Code Style Guidelines

```java
// Controller layer - REST endpoints only
@RestController
@RequestMapping("/api/v1/scenes")
public class SceneController {

    @PostMapping
    public ResponseEntity<SceneResponse> createScene(@RequestBody @Valid SceneRequest request) {
        // Delegate to service layer
        SceneVO sceneVO = sceneService.createScene(request);
        return ResponseEntity.ok(SceneResponse.from(sceneVO));
    }
}

// Service layer - Business logic
@Service
public class SceneService {

    @Transactional
    public SceneVO createScene(SceneRequest request) {
        // Validate
        validateRequest(request);

        // Build entity
        Scene scene = buildSceneEntity(request);

        // Save
        sceneMapper.insert(scene);

        // Convert to VO
        return convertToVO(scene);
    }
}

// DAO layer - Data access
@Mapper
public interface SceneMapper {
    int insert(Scene scene);
    Scene selectById(Long id);
}
```

### Common Dependencies

```xml
<!-- Spring Boot Web -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- MyBatis -->
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
</dependency>

<!-- Validation -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>

<!-- Lombok (optional) -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <scope>provided</scope>
</dependency>
```

### Common Patterns

#### Service Layer Pattern

```java
@Service
@RequiredArgsConstructor
public class DeviceService {

    private final DeviceMapper deviceMapper;
    private final RedisTemplate<String, Object> redisTemplate;

    public DeviceVO getDevice(Long deviceId) {
        // 1. Try cache first
        DeviceVO cached = (DeviceVO) redisTemplate.opsForValue().get("device:" + deviceId);
        if (cached != null) {
            return cached;
        }

        // 2. Query database
        Device device = deviceMapper.selectById(deviceId);
        if (device == null) {
            throw new DeviceNotFoundException(deviceId);
        }

        // 3. Convert to VO
        DeviceVO vo = DeviceVO.from(device);

        // 4. Cache result
        redisTemplate.opsForValue().set("device:" + deviceId, vo, 1, TimeUnit.HOURS);

        return vo;
    }
}
```

#### Exception Handling

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(DeviceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleDeviceNotFound(DeviceNotFoundException e) {
        ErrorResponse error = ErrorResponse.builder()
            .code("DEVICE_NOT_FOUND")
            .message(e.getMessage())
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException e) {
        // Handle validation errors
        String errors = e.getBindingResult().getFieldErrors().stream()
            .map(FieldError::getDefaultMessage)
            .collect(Collectors.joining(", "));
        ErrorResponse error = ErrorResponse.builder()
            .code("VALIDATION_ERROR")
            .message(errors)
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.badRequest().body(error);
    }
}
```

---

## Git Commit - Java/Spring Boot Specific

### Commit Message Examples

```
✨ feat: Add scene management REST API
- Implement SceneController with CRUD endpoints
- Add SceneService with business logic
- Create MyBatis mapper for database operations
- Add input validation using @Valid

🐛 fix: Fix device status query returning null
- Add null check in DeviceService.getDeviceStatus()
- Update error handling for missing devices

♻️ refactor: Refactor scene service layer
- Extract common validation logic to ValidationUtils
- Simplify scene creation flow
- Remove unused dependencies

📝 docs: Update API documentation for scene endpoints
- Add Swagger annotations for all controllers
- Update README with usage examples

✅ test: Add unit tests for SceneService
- Test scene creation with valid data
- Test scene validation with invalid data
- Mock dependencies using Mockito
```

---

## Common Issues & Solutions

### Issue 1: MyBatis Mapper Not Found

**Error:** `org.apache.ibatis.binding.BindingException: Invalid bound statement`

**Solution:**
1. Check `@MapperScan` annotation in main class
2. Verify XML mapper files in `src/main/resources/mapper/`
3. Check namespace in XML matches mapper interface

### Issue 2: Transaction Not Rolling Back

**Solution:**
1. Add `@Transactional` on service method
2. Ensure transaction manager is configured
3. Check for `@Transactional` on public methods only

### Issue 3: Bean Not Found

**Solution:**
1. Add `@Service`, `@Component`, `@Repository` annotations
2. Check component scan path: `@SpringBootApplication(scanBasePackages = "...")`
3. Verify class is in scanned package

---

## Quick Reference

| Action | Command |
|--------|---------|
| Compile | `mvn compile -DskipTests` |
| Test | `mvn test` |
| Package | `mvn clean package` |
| Run | `mvn spring-boot:run` |
| Clean | `mvn clean` |
| Check dependencies | `mvn dependency:tree` |

---

## Additional Resources

- **Spring Boot Documentation:** https://spring.io/projects/spring-boot
- **MyBatis Documentation:** https://mybatis.org/mybatis-3/
- **Maven Documentation:** https://maven.apache.org/guides/
