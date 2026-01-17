# Code Insight - Code Exploration Template

## Purpose

Explore existing codebase to understand implementation details, call chains, and key code logic. Document entry points, call flows, key implementations, and answer specific questions about how features work.

## When to Use

- Need to modify existing code
- New feature depends on existing modules
- Tracking bugs or performance issues
- Understanding call flows and data paths
- Documenting existing implementation before changes

## Announcement

Start with: "I'm using the code-insight sub-skill to explore the existing codebase..."

## Document Structure

### Metadata Table

```markdown
## Exploration Metadata

| Field | Value |
|------|-------|
| Date | [MM-DD HH:mm] |
| Scope | [Brief description of explored module, e.g., Scene creation functionality, Device control flow] |
| Trigger | [Why this feature needs exploration, e.g., Need to modify existing logic, New feature depends on this module] |
```

### Exploration Questions

```markdown
## Exploration Questions

> **Questions to Answer**

1. **[Question 1]** - [Brief description, e.g., How are device permissions validated during scene creation?]
2. **[Question 2]** - [Brief description, e.g., What is the retry mechanism when device control fails?]
3. **[Question 3]** - [More questions...]
```

### Call Chain Analysis

```markdown
## Call Chain Analysis

### Entry Point

| Type | Location | Method |
|------|----------|--------|
| Controller / EventHandler / Handler | `path/to/Entry.{java|js|py|go}` | `methodName()` |

### Call Chain Diagram

```
[Entry] Entry.methodName()
    ↓
[Service] Service.doSomething()
    ↓
[DAO/Repository] Repository.selectXxx()
    ↓
[SQL/ORM] SQL statement / Query
```

**Document each layer:**
- **Controller/Handler Layer:** [Responsibility, e.g., Parameter validation, Permission check]
- **Service/Business Layer:** [Responsibility, e.g., Business logic orchestration]
- **Manager/Helper Layer:** [Responsibility, e.g., Complex business processing]
- **DAO/Repository Layer:** [Responsibility, e.g., Data access]
- **SQL/ORM Layer:** [Responsibility, e.g., Query execution]
```

### Key Code Explanation

```markdown
## Key Code Explanation

> **Note:** Examples shown for different backends. Use the one matching your project's technology stack.

---

### Backend: Java / Spring Boot

```java
// File: service/SceneService.java:123-145

public SceneVO createScene(SceneCreateRequest request) {
    // Step 1: Validate device permissions
    validateDevicePermissions(request.getDeviceIds());

    // Step 2: Build scene entity
    Scene scene = buildSceneEntity(request);

    // Step 3: Save to database
    sceneMapper.insert(scene);

    // Step 4: Return result
    return convertToVO(scene);
}
```

---

### Backend: Node.js / Express

```javascript
// File: services/sceneService.js:45-60

async function createScene(request) {
    // Step 1: Validate device permissions
    await validateDevicePermissions(request.deviceIds);

    // Step 2: Build scene entity
    const scene = buildSceneEntity(request);

    // Step 3: Save to database
    await sceneMapper.insert(scene);

    // Step 4: Return result
    return convertToVO(scene);
}
```

---

### Backend: Python / Django

```python
# File: services/scene_service.py:45-60

def create_scene(request):
    # Step 1: Validate device permissions
    validate_device_permissions(request.device_ids)

    # Step 2: Build scene entity
    scene = build_scene_entity(request)

    # Step 3: Save to database
    scene_mapper.insert(scene)

    # Step 4: Return result
    return convert_to_vo(scene)
```

---

### Backend: Python / FastAPI

```python
# File: services/scene_service.py:45-60

async def create_scene(request: SceneCreateRequest):
    # Step 1: Validate device permissions
    await validate_device_permissions(request.device_ids)

    # Step 2: Build scene entity
    scene = build_scene_entity(request)

    # Step 3: Save to database
    await scene_mapper.insert(scene)

    # Step 4: Return result
    return convert_to_vo(scene)
```

---

### Backend: Go / Gin

```go
// File: services/scene_service.go:45-60

func (s *SceneService) CreateScene(request SceneCreateRequest) (SceneVO, error) {
    // Step 1: Validate device permissions
    s.ValidateDevicePermissions(request.DeviceIds)

    // Step 2: Build scene entity
    scene := s.BuildSceneEntity(request)

    // Step 3: Save to database
    s.SceneMapper.Insert(scene)

    // Step 4: Return result
    return s.ConvertToVO(scene)
}
```

**Key Points:**
- [Key point 1, e.g., Permission validation happens before creation]
- [Key point 2, e.g., Using transactions to ensure data consistency]
- [Key point 3, e.g., Notifying other services via Kafka asynchronously]
```

### Questions & Answers

```markdown
## Questions & Answers

### Q1: [Question 1]

**Answer:**

[Detailed answer including:
- Specific implementation approach
- Key code locations and logic
- Related configurations or dependencies
- Possible edge cases
]

**Code Reference:**
```
// File: service/XxxService.{java|js|py|go}:45-60
// [Relevant code snippet]
```
```

### Related Files Inventory

```markdown
## Related Files Inventory

| File | Responsibility | Key Methods/Notes | Remarks |
|------|-----------------|-------------------|---------|
| `controller/api/SceneController.{java|js|py}` | API Entry | `createScene()`, `updateScene()` | REST/HTTP interface layer |
| `service/SceneService.{java|js|py|go}` | Business Logic | `createScene()`, `validateScene()` | Core business processing |
| `dao/SceneRepository.{java|js|py|go}` | Data Access | `insert()`, `selectById()` | Repository pattern/DAO layer |
| `models/Scene.{java|js|py|go}` | Entity | - | Scene entity definition |
| `mapper/SceneMapper.{xml|py}` | SQL/ORM | `insertScene`, `selectSceneById` | SQL/ORM statement definitions |
| `config/config.{js|py|go}` | Configuration | Database URL, API keys | Configuration management |
```

### Conclusions

```markdown
## Exploration Conclusions

### Key Findings

- **[Finding 1]** - [Description of finding, e.g., Scene creation doesn't validate device online status]
- **[Finding 2]** - [Description, e.g., Uses Redis cache for scene config with 1 hour TTL]
- **[Finding 3]** - [More findings...]

### Architecture Insights

- **[Insight 1]** - [Architecture characteristic, e.g., Uses layered architecture, Service layer handles business orchestration]
- **[Insight 2]** - [Architecture characteristic, e.g., Decouples services via Kafka]

### Recommendations

- **[Recommendation 1]** - [For future development, e.g., Pay attention to transaction boundaries when modifying]
- **[Recommendation 2]** - [For future development, e.g., Recommend adding device status validation]
- **[Recommendation 3]** - [More recommendations...]

### Next Steps

- [ ] [Next action 1, e.g., Design new feature based on exploration results]
- [ ] [Next action 2, e.g., Fix discovered potential issues]
- [ ] [Next action 3, e.g., Update related documentation]
```

## Output Path

`flow-docs/<feature-name>/01_dev/code_insight/<seq>-insight-YYYY-MM-DD.md`

## Remember

- Always trace complete call chain from entry point to data access
- Document exact file paths and line numbers for code references
- Explain not just "what" but "why" - document design decisions
- Answer each question with code references and context
- Identify potential issues or improvements during exploration
- Include both happy path and edge cases in analysis
- Use **user's language** for all descriptions and explanations
- Ensure UTF-8 encoding to avoid character corruption

## Handoff

After saving:

"**Exploration complete and saved to `flow-docs/<feature-name>/01_dev/code_insight/<seq>-insight-YYYY-MM-DD.md`. Key findings documented. Ready to proceed with feature design or implementation planning.**"

**Next steps:**
- If designing new feature or modifying code: Proceed to feature-design
- If fixing bugs: Proceed directly to implementation
