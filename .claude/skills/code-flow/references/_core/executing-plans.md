# Executing Plans - Plan Execution Guide

## Purpose

Execute implementation or migration plans step-by-step. Check task completion status before execution, output code references to prove completion, and execute only pending tasks.

## When to Use

- Have implementation plan requiring execution
- Have migration plan requiring execution

## Trigger Keywords

> **Complete keyword list:** See `references/_core/trigger-keywords.md` for complete keyword list and routing logic.

**Common phrases that trigger this sub-skill:**
- "execute plan"
- "implement this plan"
- "run implementation"
- "follow the plan"
- "complete the tasks"
- "step by step execution"

## Context Determination

**Extract context from plan document path:**

Parse plan document path to extract `<feature-name>`:
- Pattern: `flow-docs/<feature-name>/01_dev/impl_plan/<seq>-plan-YYYY-MM-DD.md`
- Pattern: `flow-docs/<feature-name>/03_migration/migration-plan/<seq>-<hash>-migration-plan.md`

**Output:** `"**Current Context:** <feature-name> (from plan document)"`

**Verify context:** Ensure all task file paths belong to the same context

## Announcement

Start with: "I'm using the executing-plans sub-skill to execute the implementation plan. First checking if a plan file is provided..."

## Workflow

### Step 1: Check for Plan File

List all `.md` files in plan directories:
- Implementation: `flow-docs/*/01_dev/impl_plan/`
- Migration: `flow-docs/*/03_migration/migration-plan/`

**Case 1: No plans (count = 0)**
- Prompt: "⚠️ No plan files found in the plan directory. Please provide a path or use `/code-flow writing-plans` to create one"

**Case 2: Single plan (count = 1)**
- Prompt: "Found plan file: `[filename]`. Confirm execution? (Y/N)"

**Case 3: Multiple plans (count > 1)**
- List numbered: `1. plan-xxx.md\n2. plan-yyy.md\n...`
- Prompt: "Please select (enter number or filename)"

### Step 2: Parse Plan File

Extract:
- **Goal:** Feature goal
- **Architecture:** Architecture approach
- **Tech Stack:** Technologies used (detected from project)
- **Tasks:** All tasks with steps

### Step 3: Create Task List

For each task:
- Title: `Task N: [Component Name]`
- Description: Files, steps, expected outcomes

### Step 3.5: Check Task Completion Status {#check-completion}

**Before executing each task, verify completion:**

For each task:
1. **Read relevant files:** Load files from "Files:" section
2. **Check code state:** For each modification:
   - Read file and check if expected changes exist
   - Match expected code patterns
   - Check Git history for matching commits
3. **Verify completion with code references:**
   - **CRITICAL:** If completed, output `[filepath]#LstartLine-endLine`
   - Example: `✅ Task N detected as completed, evidence: [filepath]#L45-50`
   - **DO NOT skip without evidence**
4. **Decision:**
   - **Completed:** Mark as completed, skip execution
   - **Incomplete:** Mark as pending, proceed to execution
   - **Ambiguous:** Ask user

**Important:** Never skip a task without code references.

### Step 4: Execute Tasks Sequentially {#execute-tasks}

For each pending task:
1. **Announce:** "Starting Task N: [Component Name]"
2. **Read files:** Load relevant files
3. **Execute steps:** Follow each step:
   - Write code (if "Write the failing test")
   - Run commands (if "Run test to verify it fails")
   - Implement (if "Write minimal implementation")
   - Verify (if "Run test to verify it passes")
   - **Code review** (if "Code review" step exists):
     a. Run `/code-flow code-review` (implicit mode - reviews current task files only)
     b. **Check for P0/Compilation/Runtime/Security issues:**
        - If found → **Fix immediately** before continuing to next task
        - Read the file, apply fix, verify compilation passes
        - Re-run code-review to confirm fix
     c. **Log P1-P3 issues:** Continue to next task, accumulate for final summary
   - Commit (if "Commit")
4. **Verify completion:** Check step success
5. **Output proof:** `[filepath]#LstartLine-endLine`
6. **Mark complete** and continue

### Step 5: Handle Code Review Issues {#code-review-issues}

After all tasks complete:

1. **Check for accumulated P1-P3 issues** from code reviews
2. **Generate summary:**
   ```markdown
   ## Code Review Summary

   | Task | P1 ([MUST_FIX]) | P2 | P3 |
   |------|-----------------|----|----|
   | Task 1 | 0 | 1 | 2 |
   | Task 2 | 1 | 0 | 0 |
   ```
3. **Ask user:** "Found N non-critical issues during code review. Review documents saved to `flow-docs/*/01_dev/code_review/`. Generate fix plans for [MUST_FIX] issues? (Y/N)"

If user confirms Y:
- Prompt: "Which review documents to generate fix plans for? (space-separated list or 'all')"
- Run `/code-flow writing-plans --fix-for <review-doc>` for each

### Step 6: Handle Errors

If a non-code-review step fails:
- Log error clearly
- Explain what went wrong
- Ask: "Continue to next task? (Y/N) or fix current task? (F)"

### Step 7: Final Summary

After completion:
- Display summary:
  - Total tasks: X
  - Completed: Y
  - Failed: Z
  - Skipped: W
- List remaining todos
- Ask: "Continue with remaining tasks? (Y/N)"

## Code Execution Rules {#code-execution}

> **Complete command reference:** See `tech-commands.md` for all technologies.

**Quick reference for plan execution:**

| Technology | Verify Command | Expected Output | Commit |
|------------|----------------|-----------------|--------|
| Java/Spring Boot | `mvn compile -DskipTests` | BUILD SUCCESS | `/code-flow git-commit` |
| Node.js/Express | `npm test` | tests pass | `/code-flow git-commit` |
| Python/Django | `pytest` | tests pass | `/code-flow git-commit` |
| Python/FastAPI | `pytest` | tests pass | `/code-flow git-commit` |
| Go/Gin | `go build` | build success | `/code-flow git-commit` |
| React | `npm run build` | build success | `/code-flow git-commit` |
| Vue | `npm run build` | build success | `/code-flow git-commit` |
| Angular | `ng build` | build success | `/code-flow git-commit` |
| Next.js | `npm run build` | build success | `/code-flow git-commit` |

> **See `tech-commands.md` for:**
> - Complete command matrix (Install, Dev Server, Test, Lint, etc.)
> - All supported technologies
> - Special handling notes

### File Modifications

- Read first → Edit tool → Preserve structure/style
- New files: Follow conventions for the detected technology

## Important Notes

- **Prove completion:** Always output `[filepath]#LstartLine-endLine` when skipping
- **Check before execute:** Verify completion status first
- **Plan validation:** No plans → prompt; Single → confirm; Multiple → select
- **Preserve code:** Follow existing maintenance rules
- **User's language:** Use user's language for all messages

## Output

Code implementation (no document created)

## Quick Reference

| Technology | Commands Summary |
|------------|-----------------|
| Java/Spring Boot | `mvn compile -DskipTests`, `mvn test` |
| Node.js/Express | `npm test`, `npm install` |
| Python/Django | `python manage.py test`, `pip install -r` |
| Python/FastAPI | `pytest`, `pip install -r` |
| Go/Gin | `go build`, `go test` |
| React/Vue/Angular | `npm run build`, `npm run test` |

---

## Handoff

After plan execution:

"**Plan execution complete. Summary:** Total: X, Completed: Y, Failed: Z, Skipped: W."

"**Continue with remaining tasks?**"
