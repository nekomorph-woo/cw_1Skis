# Writing Plans - Implementation Plan Template

## Purpose

Write comprehensive implementation plans that convert design documents into actionable tasks. Assume the engineer has zero context for the codebase. Document everything needed: files to touch, code, testing, docs, how to test. Break down into bite-sized tasks following DRY, YAGNI, TDD principles with frequent commits.

## When to Use

- Have feature design document requiring implementation plan
- Have requirements needing multi-step implementation
- Preparing to start coding

## Trigger Keywords

Common phrases that indicate this sub-skill should be used:
- "create plan", "write implementation plan", "generate fix plan", "break down tasks"
- "convert design to plan", "create actionable tasks"
- "--fix-for" flag for fix plan mode

## Context Determination

Follow context management rules: See `context-management.md`

**Quick reference:**
1. Check if user explicitly specified `<feature-name>`
2. If not, use current context from conversation
3. If no context, ask user to specify

## Announcement

Start with: "I'm using the writing-plans sub-skill to create the implementation plan..."

If user hasn't provided design document, prompt: "Please provide design document from `flow-docs/*/01_dev/feature_design/` or requirements description."

## Sequence Determination

See `SKILL.md:130` for sequence number rules: Auto-increment based on existing files in target directory.

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

**Step 5: Code review**

Run: `/code-flow code-review`
Expected: Review document generated with no P0 issues

**Step 6: Commit**

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
- Use user's language for all content

## Output Path

`flow-docs/<feature-name>/01_dev/impl_plan/<seq>-plan-YYYY-MM-DD.md`

---

## Fix Plan Mode

When invoked with `--fix-for <review-doc>`:

### Purpose

Generate fix plan from code review document, extracting `[MUST_FIX]` issues.

### Step 1: Load Review Document and Extract Context

Read the specified review document from `flow-docs/<feature-name>/01_dev/code_review/<seq>-review-YYYY-MM-DD.md`.

**Extract context from review document path:**
- Parse `<feature-name>` from the review document path
- Switch to this context (discard current context)
- Output: `"**Context Switch:** → <feature-name> (from review document)"`

**Example:**
```
Review document: flow-docs/scene-creation/01_dev/code_review/001-review-2024-01-15.md
→ Extract: feature-name = "scene-creation"
→ Switch context to "scene-creation"
→ Fix plan output: flow-docs/scene-creation/01_dev/impl_plan/fix-001-plan-2024-01-15.md
```

### Step 2: Extract Issues

Parse review document for issues marked with:
- `[MUST_FIX]` marker in issue title
- P1 priority level

### Step 3: Generate Fix Tasks

For each `[MUST_FIX]` issue:

```markdown
### Task N: Fix [Issue Title]

**Issue Reference:** [Original issue from review document]
**Location:** `filepath:Lstart-Lend`

**Step 1: Write failing test for the fix**

```javascript
function test_fixed_behavior() {
    // Test that verifies the bug is fixed
}
```

**Step 2: Run test to verify it fails**

Run: `npm test` / `pytest` / `mvn test`
Expected: FAIL

**Step 3: Apply the fix**

```javascript
// File: filepath:Lstart-Lend
// Fixed code from suggested fix in review
```

**Step 4: Run test to verify it passes**

Run: `npm test` / `pytest` / `mvn test`
Expected: PASS

**Step 5: Code review**

Run: `/code-flow code-review`
Expected: No more issues for this location

**Step 6: Commit**

Use `/code-flow git-commit` sub-skill to commit changes.
```

### Step 4: Output Path

Fix plan documents use `fix-` prefix:
`flow-docs/<feature-name>/01_dev/impl_plan/fix-<seq>-plan-YYYY-MM-DD.md`

### Step 5: Handoff

After saving fix plan:

"**Fix plan complete and saved to `flow-docs/<feature-name>/01_dev/impl_plan/fix-<seq>-plan-YYYY-MM-DD.md`**"

"**Plan includes N fix tasks extracted from code review.**"

"**Next step: Use `/code-flow executing-plans` to execute the fix plan.**"

---

## Handoff

After saving:

"**Plan complete and saved to `flow-docs/<feature-name>/01_dev/impl_plan/<seq>-plan-YYYY-MM-DD.md`**"

"**Next step: Use `/code-flow executing-plans` to execute the plan.**"
