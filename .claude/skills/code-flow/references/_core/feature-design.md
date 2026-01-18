# Feature Design - Feature Design Template

## Purpose

Write comprehensive feature design documents for new features or major enhancements. Document requirements, technical approaches, API design, data design, risks, and test plans.

## When to Use

- Received new requirements requiring design
- Need to evaluate multiple technical approaches
- Need API design and data model specifications
- Require risk assessment and test planning
- Mode 0 (Inception) when analyzing requirements

## Trigger Keywords

> **Complete keyword list:** See `references/_core/trigger-keywords.md` for complete keyword list and routing logic.

**Common phrases that trigger this sub-skill:**
- "design feature"
- "create design doc"
- "technical approach"
- "API design"
- "design new functionality"
- "feature specification"

## Context Determination

Follow context management rules: See `context-management.md`

**Quick reference:**
1. Check if user explicitly specified `<feature-name>`
2. If not, use current context from conversation
3. If no context, ask user to specify

## Announcement

Start with: "I'm using the feature-design sub-skill to create the feature design document..."

If user hasn't provided requirements or insight document, prompt: "Please provide requirements description or insight document from `flow-docs/*/01_dev/code_insight/`."

## Sequence Determination

See `SKILL.md#seq-rules` for sequence number rules: Auto-increment based on existing files in target directory.

## Document Structure

### Metadata Table

```markdown
## Basic Information

| Field | Value |
|-------|-------|
| Feature Name | [Feature name] |
| Author | [Author] |
| Date | [YYYY-MM-DD] |
| Status | Draft / In Review / Approved / In Progress / Done |
| Priority | P0 / P1 / P2 / P3 |
```

### Requirement Summary

```markdown
## 1. Requirement Summary

### 1.1 Background

[Describe why this feature is needed, what problem it solves. Explain business background, user pain points, limitations of existing solutions.]

### 1.2 Goal

[Describe core objective in 1-2 sentences. Define business value and technical objectives to achieve.]

### 1.3 Scope

- **In Scope:** [Clearly define what's included, list main functionality points]
- **Out of Scope:** [Clearly define what's excluded, explain possible future extensions]
```

### Technical Design

```markdown
## 2. Technical Design

### 2.1 Approach Options

#### Option A: MVP (Minimum Viable Product)

- **Description:** [Brief description of implementation approach and core capabilities]
- **Pros:** [List advantages, e.g., short development cycle, low risk]
- **Cons:** [List disadvantages, e.g., limited functionality, poor scalability]
- **Effort:** [Effort estimate, e.g., 2 person-weeks]

#### Option B: Balanced

- **Description:** [Brief description of implementation approach and core capabilities]
- **Pros:** [List advantages, e.g., complete functionality, scalable]
- **Cons:** [List disadvantages, e.g., longer development cycle, medium complexity]
- **Effort:** [Effort estimate, e.g., 4 person-weeks]

#### Option C: Advanced

- **Description:** [Brief description of implementation approach and core capabilities]
- **Pros:** [List advantages, e.g., excellent performance, highly scalable, future-friendly]
- **Cons:** [List disadvantages, e.g., long development cycle, high complexity, potentially over-engineered]
- **Effort:** [Effort estimate, e.g., 8 person-weeks]

### 2.2 Selected Approach

[Explain which option (A/B/C) was chosen and why. Explain decision rationale, e.g., business priority, time constraints, technical debt considerations.]

### 2.3 Architecture Impact

- **New Components:** [List new components/modules/services being added]
- **Modified Components:** [List existing components that need modification]
- **Dependencies:** [List new dependency relationships being added]
```

### API Design

```markdown
## 3. API Design

### 3.1 REST API

> **Note:** Different technologies have different syntax. Use the example matching your technology stack.

**Java / Spring Boot:**

```java
// Controller: [ControllerName]

/**
 * [Interface description - Explain interface purpose, business logic]
 *
 * @param request [Request parameter description]
 * @return [Return value description]
 */
@PostMapping("/api/v1/xxx")
public ResponseEntity<XxxResponse> methodName(@RequestBody @Valid XxxRequest request);
```

**Node.js / Express:**

```javascript
// Router: [RouterName]

/**
 * [Interface description - Explain interface purpose, business logic]
 *
 * @param {XxxRequest} req - [Request parameter description]
 * @returns {Promise<XxxResponse>} res - [Return value description]
 */
router.post('/api/v1/xxx', async (req, res) => {
    // Implementation
});
```

**Python / Django:**

```python
# View: [ViewName]

"""
Interface description: [Explain interface purpose, business logic]

Args:
    request (XxxRequest): Request parameter description
    Returns:
    Response (XxxResponse): Return value description
"""
@PostMapping("/api/v1/xxx", response=XxxResponse)
def method_name(request: XxxRequest) -> XxxResponse:
    # Implementation
```

**Python / FastAPI:**

```python
# Route: [RouteName]

"""
Interface description: [Explain interface purpose, business logic]

Args:
    request (XxxRequest): Request parameter description
    Returns:
    Response (XxxResponse): Return value description
"""
@app.post("/api/v1/xxx", response_model=XxxResponse)
async def method_name(request: XxxRequest) -> XxxResponse:
    # Implementation
```

**Go / Gin:**

```go
// Handler: [HandlerName]

/**
 * Interface description: [Explain interface purpose, business logic]
 *
 * @param request (XxxRequest) - Request parameter description
 * @returns {XxxResponse} - Return value description
 */
func PostXxx(c *gin.Context, request XxxRequest) (XxxResponse, error) {
    // Implementation
}
```

### 3.2 Request/Response DTOs

**Java / Spring Boot:**

```java
// Request DTO: controller/reqresp/XxxRequest.java
public class XxxRequest {
    @NotNull(message = "Field cannot be empty")
    private String field1;

    private Integer field2;
}
```

**Node.js / Express:**

```javascript
// Request schema (using Zod)
const xxxRequestSchema = z.object({
    field1: z.string().min(1).max(100),
    field2: z.number().int().optional()
});

// Type definition (TypeScript)
interface XxxRequest {
    field1: string;
    field2?: number;
}
```

**Python / Django:**

```python
from django.db import models

class XxxRequest(models.Model):
    field1 = models.CharField(max_length=100)
    field2 = models.IntegerField()
```

**Python / FastAPI:**

```python
class XxxRequest(BaseModel):
    field1: str
    field2: int = None
```

**Go / Gin:**

```go
type XxxRequest struct {
    Field1 string `json:"field1" binding:"required,min=1,max=100"`
    Field2 int `json:"field2,omitempty"`
}
```
```

---

## Data Design

```markdown
## 4. Data Design

### 4.1 Database Changes

- [ ] **New Table:** `[table_name]` - [Explain table purpose and main fields]
- [ ] **Alter Table:** `[table_name]` - [Explain modifications, e.g., Add field `column_name` type `VARCHAR(255)`]
- [ ] **Index Changes:** [If there are index changes, explain reasons and impact]
```

---

## Risk Assessment

```markdown
## 5. Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| [Risk description] | High/Medium/Low | High/Medium/Low | [Mitigation measures] |
```

---

## Test Plan

```markdown
## 6. Test Plan

### 6.1 Integration Tests

- [ ] **[Test scenario 1]** - [Describe test scenario, e.g., Normal scene creation with valid data]
- [ ] **[Test scenario 2]** - [Describe test scenario, e.g., Parameter validation failure]

### 6.2 Edge Cases

- [ ] **[Edge case 1]** - [Describe edge case, e.g., Empty list, null values, concurrent updates]
- [ ] **[Edge case 2]** - [Describe edge case, e.g., Data doesn't exist, permission denied]
```

---

## Implementation Checklist

```markdown
## 7. Implementation Checklist

- [ ] Requirements document complete
- [ ] Technical approach confirmed
- [ ] Interface design confirmed
- [ ] Database changes prepared
- [ ] Code implementation complete
- [ ] Integration tests complete
- [ ] Code review complete
```

---

## Output Path

`flow-docs/<feature-name>/01_dev/feature_design/<seq>-ft-YYYY-MM-DD.md`

## Remember

- Always provide multiple approach options (MVP / Balanced / Advanced) with trade-offs
- Document exact API signatures with request/response DTOs
- Identify all database changes and data model impacts
- Assess risks with probability, Impact, and mitigation strategies
- Include comprehensive test scenarios and edge cases
- Use **user's language** for all descriptions and explanations

## Handoff

After saving:

"**Design complete and saved to `flow-docs/<feature-name>/01_dev/feature_design/<seq>-ft-YYYY-MM-DD.md`. Please review and approve the design before proceeding to implementation planning.**"

**After approval:**
- Proceed to create implementation plan using writing-plans
- Or proceed directly to implementation if design is simple enough
