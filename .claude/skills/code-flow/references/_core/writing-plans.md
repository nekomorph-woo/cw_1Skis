# Writing Plans - Implementation Plan Template

## Purpose

Write comprehensive implementation plans that convert design documents into actionable tasks. Assume the engineer has zero context for the codebase. Document everything needed: files to touch, code, testing, docs, how to test. Break down into bite-sized tasks following DRY, YAGNI, TDD principles with frequent commits.

## When to Use

- Have feature design document requiring implementation plan
- Have requirements needing multi-step implementation
- Preparing to start coding

## Announcement

Start with: "I'm using the writing-plans sub-skill to create the implementation plan. If user hasn't provided a design document, prompt user to provide design document from `flow-docs/*/01_dev/feature_design/` or provide requirements description."

## Document Header

Every plan MUST start with:

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use code-flow:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries - specify actual stack detected]

---
```

## Task Structure

Each task should be 10-20 minutes of work with 2-5 minute steps:

```markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.{js|py|java|go}`
- Modify: `exact/path/to/existing.{js|py|java|go}:123-145`
- Test: `tests/path/to/test.{js|py|java|go}`

**Step 1: Write the failing test**

```javascript
// JavaScript (Jest example)
function test_specific_behavior() {
    const result = function(input);
    expect(result).toBe(expected);
}
```

```python
# Python (pytest example)
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

```java
// Java (JUnit example)
@Test
public void test_specific_behavior() {
    assertEquals(expected, function(input));
}
```

**Step 2: Run test to verify it fails**

Run: `npm test` / `pytest` / `mvn test`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```javascript
function function(input) {
    return expected;
}
```

**Step 4: Run test to verify it passes**

Run: `npm test` / `pytest` / `mvn test`
Expected: PASS

**Step 5: Commit**

Use `/code-flow git-commit` sub-skill to commit changes.

Follow git-commit workflow:
1. Check staged files with `git status`
2. Analyze changes with `git diff --cached`
3. Generate commit message with emoji prefix (following Conventional Commits)
4. Execute commit using file-based method on Windows for UTF-8 safety
```

## Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

**Each task should be:**
- Focused on one component/file
- 10-20 minutes of work
- Self-contained (can be executed independently)
- Includes verification steps

## Technology-Specific Commands

### Compile & Test Commands Reference

| Technology | Install | Dev Server | Build | Test | Lint |
|------------|---------|------------|-------|------|------|
| **Java/Spring Boot** | `mvn install` | `mvn spring-boot:run` | `mvn package` | `mvn test` | - |
| **Node.js/Express** | `npm install` | `npm start` / `npm run dev` | - | `npm test` | `npm run lint` |
| **Python/Django** | `pip install -r` | `python manage.py runserver` | - | `pytest` | `flake8` |
| **Python/FastAPI** | `pip install -r` | `uvicorn main:app --reload` | - | `pytest` | `ruff` |
| **Go/Gin** | `go mod download` | `air` | `go build` | `go test` | `golangci-lint run` |
| **React** | `npm install` | `npm run dev` | `npm run build` | `npm test` | `npm run lint` |
| **Vue** | `npm install` | `npm run dev` | `npm run build` | `npm run test` | `npm run lint` |
| **Angular** | `npm install` | `ng serve` | `ng build` | `ng test` | `ng lint` |
| **Next.js** | `npm install` | `npm run dev` | `npm run build` | `npm run test` | `npm run lint` |

> **For detailed technology-specific commands and patterns, see:**
> - Backend: `backend/<tech>.md` (e.g., `backend/java-spring-boot.md`)
> - Frontend: `frontend/<tech>.md` (e.g., `frontend/react.md`)
> - Full-stack: `fullstack/<stack>.md` (e.g., `fullstack/mern.md`)

### File Conventions

| Technology | File Convention | Example |
|------------|-----------------|----------|
| Java | `PascalCase.java` | `UserController.java`, `UserService.java` |
| Python | `snake_case.py` | `user_controller.py`, `user_service.py` |
| Node.js/JavaScript | `camelCase.js` | `userController.js`, `userService.js` |
| Go | `PascalCase.go` | `UserController.go`, `UserService.go` |
| React | `PascalCase.jsx` | `UserProfile.jsx` |
| Vue | `PascalCase.vue` | `UserProfile.vue` |
| Angular | `PascalCase.ts` | `user-profile.component.ts` |
| Next.js | `PascalCase.tsx` | `UserProfile.tsx` |
| Nuxt.js | `PascalCase.vue` | `UserProfile.vue` |

## Remember

- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits
- Use user's **user's language** for all content
- Ensure UTF-8 encoding to avoid character corruption

## Output Path

`flow-docs/<feature-name>/01_dev/impl_plan/<seq>-plan-YYYY-MM-DD.md`

## Handoff

After saving:

"**Plan complete and saved to `flow-docs/<feature-name>/01_dev/impl_plan/<seq>-plan-YYYY-MM-DD.md`**"

"**Next step: Use `/code-flow executing-plans` to execute the plan.**"
