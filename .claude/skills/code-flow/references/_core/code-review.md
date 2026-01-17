# Code Review - Code Review Guide

## Purpose

Review code changes for compilation issues, bugs, security vulnerabilities, and best practice violations. Output findings to structured review documents for tracking and fixing.

## When to Use

- **Implicitly:** After completing each task during plan execution (executing-plans)
- **Explicitly:** User requests standalone code review via `/code-flow code-review`

## Announcement

Start with: "I'm using the code-review sub-skill to review the code..."

## Review Scope

### Implicit Mode (Plan Execution)

When called during plan execution:
- **Review only files modified in the current task**
- P0 (compilation/runtime/security) errors must be fixed immediately
- P1-P3 issues are documented and accumulated

### Explicit Mode (User Invocation)

When user invokes `/code-flow code-review` directly:

**Ask user to specify review scope:**

```
Please specify review scope:
1. Local unpushed commits (current branch vs remote)
2. Local uncommitted changes (working directory + staged)
3. Specific commit hash (provide hash)
4. Branch diff from origin (branch name)
5. Specific files (provide paths)
6. Type any (describe your scope)
```

**Based on user choice:**

| Option | Git Command | Scope |
|--------|-------------|-------|
| Local unpushed | `git log origin/<branch>..HEAD` | Commits not on remote |
| Uncommitted | `git diff HEAD` | Working + staged changes |
| Commit hash | `git show <hash>` | Single commit |
| Branch diff | `git diff origin/<main>..<branch>` | All changes since fork |
| Files | `git diff -- <paths>` | Specified files only |
| Any | Parse user input | Custom scope |

---

## Problem Categories

| Category | Priority | Action |
|----------|----------|--------|
| **Compilation** | P0 | Fix immediately (blocker) |
| **Runtime Bug** | P0 | Fix immediately (blocker) |
| **Security** | P0 | Fix immediately (blocker) |
| **Logic Error** | P1 | Mark with `[MUST_FIX]` |
| **Performance** | P2 | Note in review |
| **Style/Convention** | P3 | Note in review |
| **Documentation** | P3 | Note in review |

---

## What to Review

### 1. Compilation Check (P0) - CRITICAL

**First action:** Always run compilation/build to check for syntax errors.

| Technology | Command |
|------------|---------|
| Java/Spring Boot | `mvn compile -DskipTests` |
| Node.js/Express | `npm run build` |
| Python/Django | `python -m py_compile *.py` |
| Python/FastAPI | `python -m py_compile *.py` |
| Go/Gin | `go build` |
| React/Vue/Next.js | `npm run build` |

**If compilation fails:**
- Output `❌ COMPILATION FAILED` section
- List all compilation errors
- **Return immediately** (no need for further review)

### 2. Code Logic (P0/P1)

- Off-by-one errors
- Null pointer risks
- Race conditions
- Edge cases not handled
- Resource leaks (file handles, connections)
- Error handling gaps

### 3. Security (P0)

- SQL injection
- XSS vulnerabilities
- Authentication/authorization issues
- Input validation missing
- Sensitive data exposure

### 4. Best Practices (P2/P3)

- Code duplication
- Naming conventions
- Error handling completeness
- Resource cleanup
- Code organization

---

## What NOT to Review

- Pre-existing issues (not part of this change)
- Issues caught by linter/typechecker (assumed to run in CI)
- Pedantic nitpicks not in project guidelines
- Stylistic preferences without explicit project rules
- Lines not modified by the current change (unless it's a standalone review)

---

## Workflow

### Step 1: Determine Scope

**Implicit mode (plan execution):**
- Use files listed in current task's "Files:" section

**Explicit mode (user invocation):**
- Ask user to specify scope
- Parse and determine git command to get diff

### Step 2: Get Code Changes

```bash
# Based on scope determined in Step 1
git diff <commit-range>      # For commit ranges
git show <hash>              # For single commit
git diff HEAD                # For uncommitted changes
git diff -- <filepaths>      # For specific files
```

### Step 3: Compile Check (Critical)

Run compilation command for detected technology.

**If compilation fails:**
- Generate "COMPILATION FAILED" output
- Return immediately

### Step 4: Analyze Code

For each modified file:

1. **Read the file** to understand context
2. **Check against common issues** by category
3. **Document findings** with location and suggested fix

### Step 5: Determine Sequence

Check existing review documents:
```bash
ls flow-docs/*/01_dev/code_review/
```
- Extract sequence numbers: `001-review-`, `002-review-`, etc.
- Next sequence = max + 1
- Start with `001` if no files exist

### Step 6: Generate Output Document

---

## Output Templates

### If Compilation Failed

```markdown
# [Feature Name] Code Review

## ❌ COMPILATION FAILED

**Date:** [MM-DD HH:mm]
**Files Reviewed:** [List]
**Review Scope:** [Task scope / User-specified scope]

### Compilation Errors

| File | Line | Error |
|------|------|-------|
| `path/to/file.java` | 42 | `error: cannot find symbol` |
| `path/to/file.js` | 15 | `SyntaxError: Unexpected token` |

### Action Required

Fix compilation errors before proceeding.

---

📅 Generated: [MM-DD HH:mm]
🔍 Review ID: <seq>
```

### If Compilation Passed with Issues

```markdown
# [Feature Name] Code Review

## ✅ Compilation Passed

**Date:** [MM-DD HH:mm]
**Files Reviewed:** [List]
**Review Scope:** [Task scope / User-specified scope]
**Total Issues:** N

### Summary

| Priority | Count | Action |
|----------|-------|--------|
| P0 (Fix Immediately) | 0 | - |
| P1 ([MUST_FIX]) | X | Generate fix plan |
| P2 (Should Fix) | Y | Review at discretion |
| P3 (Nice to Have) | Z | Optional |

---

## Detailed Issues

### [P1] [MUST_FIX] Issue Title

**Location:** `filepath:Lstart-Lend`
**Category:** Logic / Security / Performance

**Description:**
[Clear description of the problem and its impact]

**Suggested Fix:**
```java
// File: filepath:Lstart-Lend
[Code snippet showing fix]
```

**Priority:** P1 ([MUST_FIX])

---

### [P2] Issue Title

**Location:** `filepath:Lstart-Lend`
**Category:** Performance

**Description:**
[Clear description]

**Suggested Fix:**
```javascript
// File: filepath:Lstart-Lend
[Code snippet]
```

**Priority:** P2 (Should Fix)

---

## Next Steps

- P1 issues marked with `[MUST_FIX]`: Use `/code-flow writing-plans --fix-for <seq>-review-YYYY-MM-DD.md` to generate fix plan
- P2/P3 issues: Review and address at your discretion

---

📅 Generated: [MM-DD HH:mm]
🔍 Review ID: <seq>
```

### If No Issues

```markdown
# [Feature Name] Code Review

## ✅ No Issues Found

**Date:** [MM-DD HH:mm]
**Files Reviewed:** [List]
**Review Scope:** [Task scope / User-specified scope]
**Status:** Compilation passed, no issues detected.

---

📅 Generated: [MM-DD HH:mm]
🔍 Review ID: <seq>
```

---

## Output Path

`flow-docs/<feature-name>/01_dev/code_review/<seq>-review-YYYY-MM-DD.md`

---

## Integration with Workflows

### With executing-plans (Implicit Mode)

After each task completion:
1. Run code-review automatically on task files
2. **If P0 issues:** Fix immediately before continuing
3. **If P1-P3 issues:** Document and accumulate for final summary

### With writing-plans (Fix Plan Mode)

To generate fix plan from review:

```bash
/code-flow writing-plans --fix-for <seq>-review-YYYY-MM-DD.md
```

This will:
1. Load the review document
2. Extract `[MUST_FIX]` issues
3. Generate fix plan with prefix `fix-`

---

## Fix Plan Integration

When `writing-plans` is invoked with `--fix-for <review-doc>`:

### Step 1: Load Review Document

Read from `flow-docs/<feature-name>/01_dev/code_review/<seq>-review-YYYY-MM-DD.md`

### Step 2: Extract MUST_FIX Issues

Parse review document for issues marked with:
- `[MUST_FIX]` in issue title
- P1 priority level

### Step 3: Generate Fix Tasks

For each `[MUST_FIX]` issue:

```markdown
### Task N: Fix [Issue Title]

**Issue Reference:** [Original issue from review]
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

Use `/code-flow git-commit` sub-skill.
```

### Step 4: Output Path

Fix plan documents use `fix-` prefix:
`flow-docs/<feature-name>/01_dev/impl_plan/fix-<seq>-plan-YYYY-MM-DD.md`

---

## Important Notes

- Always check compilation first
- P0 issues must block continuation in plan execution
- Use `[MUST_FIX]` marker for P1 issues requiring fix plans
- Output format must be consistent
- Sequence numbers auto-increment based on existing files
- Ensure UTF-8 encoding
- Use user's language for descriptions
- In implicit mode, only review current task files
- In explicit mode, ask user for scope specification

---

## Handoff

After generating review document:

"**Code review complete and saved to `flow-docs/<feature-name>/01_dev/code_review/<seq>-review-YYYY-MM-DD.md`**"

"**Found N issues: P0: X, P1: Y, P2: Z, P3: W**"

If P1 issues exist: "**Use `/code-flow writing-plans --fix-for <seq>-review-YYYY-MM-DD.md` to generate fix plan**"

If no issues: "**No issues found. Code is ready for commit.**"
