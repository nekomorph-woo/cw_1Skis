# Workflow Examples - Code Flow Skill

## Overview

Complete workflow examples demonstrating how to use the code-flow skill for various development scenarios.

**Key Concepts:**
- **Document-Driven Decoupling:** Sub-skills communicate through documents
- **Context Propagation:** Context automatically flows between sub-skills
- **Progressive Disclosure:** Use sub-skills standalone or combine for complete workflows

---

## Example 1: New Feature Development

### Scenario

User requests: "I need to add a new device control feature that supports remote on/off operations"

### Workflow

```
User: "I need to add a new device control feature"
→ Trigger: "design feature" → feature-design sub-skill
```

**Claude actions (feature-design):**
1. Determine context: No context exists → Ask user for `<feature-name>`
2. User provides: "device-control"
3. Create directory structure: `flow-docs/device-control/`
4. Ask for requirements
5. Create `flow-docs/device-control/01_dev/feature_design/001-ft-2026-01-18.md`
6. Document: requirements, 3 approaches (MVP/Balanced/Advanced), API design, data design, risks

```
User: "Create implementation plan"
→ Trigger: "create plan" → writing-plans sub-skill
→ Context inherited: device-control
```

**Claude actions (writing-plans):**
1. Read design document from `01_dev/feature_design/001-ft-2026-01-18.md`
2. Determine sequence: Check existing files → `001`
3. Create `flow-docs/device-control/01_dev/impl_plan/001-plan-2026-01-18.md`
4. Break down into bite-sized tasks (10-20 min each) with TDD approach

```
User: "Execute the plan"
→ Trigger: "execute plan" → executing-plans sub-skill
→ Context: Extracted from plan document path
```

**Claude actions (executing-plans):**
1. Parse plan path → Extract context: "device-control"
2. List available plans in `01_dev/impl_plan/`
3. Single plan found → Confirm: "Execute 001-plan-2026-01-18.md? (Y/N)"
4. Check task completion status before executing
5. For each task:
   - Read relevant files
   - Verify if already completed (check code + git history)
   - If completed: Output `filepath#Lstart-end` and skip
   - If pending: Execute steps
   - Run code-review after each task
   - Fix P0 issues immediately
   - Log P1-P3 issues
   - Commit after task completion

```
User: "Commit code"
→ Trigger: "commit" → git-commit sub-skill
```

**Claude actions (git-commit):**
1. Check `git status` and `git diff --cached`
2. Generate Conventional Commit message with emoji
3. Execute UTF-8 safe commit (file-based method on Windows)
4. **Delete temporary `commit_msg.txt` file**

```
User: "Save context"
→ Trigger: "save context" → save-context sub-skill
```

**Claude actions (save-context):**
1. Extract tasks, decisions, files from conversation
2. Create `flow-docs/device-control/02_memories/active_context.md`

### Result

```
flow-docs/device-control/
├── 01_dev/
│   ├── feature_design/
│   │   └── 001-ft-2026-01-18.md
│   ├── impl_plan/
│   │   └── 001-plan-2026-01-18.md
│   └── code_review/
│       └── 001-review-2026-01-18.md  (auto-generated during execution)
└── 02_memories/
    └── active_context.md
```

---

## Example 2: Existing Code Modification

### Scenario

User requests: "I need to modify the scene creation functionality to add device online status validation"

### Workflow

```
User: "How is scene creation implemented?"
→ Trigger: "how is this implemented" → code-insight sub-skill
```

**Claude actions (code-insight):**
1. Determine context: No context → Ask user
2. User provides: "scene-online-check"
3. Ask: "What functionality needs exploration?"
4. Analyze scene creation code
5. Document call chain (mermaid diagram), key code, file inventory
6. Create `flow-docs/scene-online-check/01_dev/code_insight/001-insight-2026-01-18.md`

```
User: "Design the online validation feature"
→ Trigger: "design feature" → feature-design sub-skill
→ Context inherited: scene-online-check
```

**Claude actions (feature-design):**
1. Read insight document for context
2. Create design with 3 approaches for adding online check
3. Create `flow-docs/scene-online-check/01_dev/feature_design/001-ft-2026-01-18.md`

```
User: "Write implementation plan"
→ Trigger: "write implementation plan" → writing-plans sub-skill
→ Context inherited: scene-online-check
```

```
User: "Execute"
→ Trigger: "execute plan" → executing-plans sub-skill
→ Context: Extracted from plan path
```

```
User: "Commit"
→ Trigger: "commit" → git-commit sub-skill
```

```
User: "Save progress"
→ Trigger: "save session" → save-context sub-skill
```

### Result

```
flow-docs/scene-online-check/
├── 01_dev/
│   ├── code_insight/
│   │   └── 001-insight-2026-01-18.md
│   ├── feature_design/
│   │   └── 001-ft-2026-01-18.md
│   ├── impl_plan/
│   │   └── 001-plan-2026-01-18.md
│   └── code_review/
│       └── 001-review-2026-01-18.md
└── 02_memories/
    └── active_context.md
```

---

## Example 3: Code Review with Fix Plan

### Scenario

User requests: "Review the current changes"

### Workflow (Explicit Mode)

```
User: "Review code"
→ Trigger: "code review" → code-review sub-skill
```

**Claude actions (code-review):**
1. Determine context following `context-management.md` rules
2. Ask: "Please specify review scope:"
   ```
   1. Local unpushed commits (current branch vs remote)
   2. Local uncommitted changes (working directory + staged)
   3. Specific commit hash (provide hash)
   4. Branch diff from origin (branch name)
   5. Specific files (provide paths)
   6. Type any (describe your scope)
   ```
3. User selects: "1" (Local unpushed commits)
4. Run compilation check first (P0 check)
5. If compilation passes → Analyze code for issues
6. Determine sequence: Check existing review docs → Next = max + 1
7. Create `flow-docs/<feature>/01_dev/code_review/001-review-2026-01-18.md`
8. Output issue summary with P0/P1/P2/P3 categories

```
User: "Generate fix plan for the issues"
→ Trigger: "generate fix plan" → writing-plans --fix-for
```

**Claude actions (writing-plans fix mode):**
1. Parse `--fix-for 001-review-2026-01-18.md`
2. Extract context from review document path → feature-name
3. Extract all `[MUST_FIX]` issues (P1)
4. Generate fix tasks for each issue
5. Create `flow-docs/<feature>/01_dev/impl_plan/fix-001-plan-2026-01-18.md`

```
User: "Execute the fix plan"
→ Trigger: "execute plan" → executing-plans sub-skill
```

**Claude actions (executing-plans):**
1. Load fix plan
2. Execute fix tasks
3. After each fix → Re-run code-review
4. Repeat until clean

### Result

```
flow-docs/<feature>/
├── 01_dev/
│   ├── code_review/
│   │   └── 001-review-2026-01-18.md
│   └── impl_plan/
│       └── fix-001-plan-2026-01-18.md  (fix plan)
```

---

## Example 4: Code Migration

### Scenario

User requests: "I need to migrate changes from commit aa8db135 to another project"

### Workflow

```
User: "Summarize this commit: aa8db135ca4bde0d08c31c65bee27a088820b1b7"
→ Trigger: "analyze commit" → commit-change-log sub-skill
```

**Claude actions (commit-change-log):**
1. Determine context: No context → Ask user
2. User provides: "cloud-armed-migration"
3. Accept commit hash
4. Get metadata: `git log -1 --format="%H%n%an%n%ae%n%ad%n%s" <hash>`
5. Get changed files: `git show <hash> --name-status`
6. Get full diff: `git show <hash>`
7. Determine sequence: Check existing commit-log-summary → Next = `001`
8. Create `flow-docs/cloud-armed-migration/03_migration/commit-log-summary/001-aa8db13-commit-log.md`

```
User: "Create migration plan"
→ Trigger: "create migration plan" → commit-migration sub-skill
```

**Claude actions (commit-migration):**
1. Ask: "Please provide summary document path"
2. User provides: `flow-docs/cloud-armed-migration/03_migration/commit-log-summary/001-aa8db13-commit-log.md`
3. Extract context from path → "cloud-armed-migration"
4. Analyze target project structure
5. Check if files exist in target (search similar names/paths)
6. Identify adaptation points (file paths, package names, method names)
7. Determine sequence: Check existing migration plans → Next = `001`
8. Create `flow-docs/cloud-armed-migration/03_migration/migration-plan/001-aa8db13-migration-plan.md`

```
User: "Execute migration"
→ Trigger: "execute plan" → executing-plans sub-skill
→ Context: Extracted from migration plan path
```

**Claude actions (executing-plans):**
1. Load migration plan from `03_migration/migration-plan/`
2. For each task:
   - Verify dependencies exist in target
   - Adapt code to target's technology stack
   - Use syntax comparison tables for reference
   - Verify compilation
   - Run code-review
   - Commit

```
User: "Commit migration"
→ Trigger: "commit" → git-commit sub-skill
```

### Result

```
flow-docs/cloud-armed-migration/
└── 03_migration/
    ├── commit-log-summary/
    │   └── 001-aa8db13-commit-log.md
    └── migration-plan/
        └── 001-aa8db13-migration-plan.md
```

---

## Example 5: Quick Bug Fix

### Scenario

User requests: "Scene query API has a bug, needs fixing"

### Workflow

```
User: "Create plan to fix scene query bug"
→ Trigger: "create plan" → writing-plans sub-skill
```

**Claude actions (writing-plans):**
1. Determine context: No context → Ask user
2. User provides: "scene-query-bug-fix"
3. Ask for bug description
4. Create minimal plan (no full design needed for simple bug)
5. Create `flow-docs/scene-query-bug-fix/01_dev/impl_plan/001-plan-2026-01-18.md`

```
User: "Execute"
→ Trigger: "execute plan" → executing-plans sub-skill
→ Context: Extracted from plan path
```

```
User: "Commit"
→ Trigger: "commit" → git-commit sub-skill
```

### Simplified Document Structure

```
flow-docs/scene-query-bug-fix/
└── 01_dev/
    └── impl_plan/
        └── 001-plan-2026-01-18.md
```

---

## Example 6: Context Switching

### Scenario

User switches between multiple features in a single session

### Workflow

```
User: "Design user management feature"
→ Context: "user-management"
→ Output: "**Current Context:** user-management"

[Work on user-management...]

User: "Now I need to work on device control"
→ Explicit context specification
→ Output: "**Context Switch:** user-management → device-control"
→ All subsequent documents go to: flow-docs/device-control/

[Work on device-control...]

User: "Go back to user management"
→ Explicit context specification
→ Output: "**Context Switch:** device-control → user-management"
→ All subsequent documents go to: flow-docs/user-management/
```

---

## Example 7: Session Recovery (Document-Driven Decoupling)

### Day 1 Session

```
User: "I need to add device control feature"

/code-flow feature-design
→ Creates: flow-docs/device-control/01_dev/feature_design/001-ft-2026-01-18.md

/code-flow writing-plans
→ Creates: flow-docs/device-control/01_dev/impl_plan/001-plan-2026-01-18.md

/code-flow save-context
→ Creates: flow-docs/device-control/02_memories/active_context.md
```

**Session End - Day 1**

### Day 2 Session (New Claude Session)

```
User: "Continue device control feature development"
```

**Claude actions:**
1. Check existing context: Read `flow-docs/device-control/02_memories/active_context.md`
2. Understand state: Design complete, plan ready, ready to execute
3. Output: `"**Current Context:** device-control (from saved context)"`

```
User: "Execute the plan"
→ Context already loaded
→ executing-plans continues from where Day 1 left off
```

**No need to repeat design or planning** - documents carry the context forward.

---

## Sub-Skill Standalone Usage

### Using code-insight Alone

```
User: "Help me understand how scene creation works"
→ Trigger: "understand existing code" → code-insight
```

**Output:** `flow-docs/<feature>/01_dev/code_insight/001-insight-YYYY-MM-DD.md`

No other sub-skills invoked. User can review and decide next steps.

### Using save-context Alone

```
User: "Save current context"
→ Trigger: "save context" → save-context
```

**Output:** `flow-docs/<feature>/02_memories/active_context.md`

Useful anytime during session to checkpoint state.

### Using git-commit Alone

```
User: "Commit code"
→ Trigger: "commit" → git-commit
```

**Output:** Git commit (no document)

Can be used with any workflow or standalone.

### Using code-review Alone (Implicit during execution)

```
User: "Execute plan"
→ executing-plans runs code-review after each task automatically
```

**Implicit Mode:**
- Triggered automatically during plan execution
- Only reviews files modified in current task
- P0 issues → Fix immediately
- P1-P3 issues → Accumulate for summary

**Explicit Mode:**
```
User: "Review code"
→ code-review asks for scope
```

---

## Workflow Decision Tree

```
Start
  │
  ├─ Need to understand existing code?
  │   └─ YES → code-insight
  │         └─ Then decide: modify existing or new feature?
  │
  ├─ Have requirements for new feature?
  │   └─ YES → feature-design → writing-plans → executing-plans → git-commit
  │
  ├─ Need to modify existing code?
  │   └─ YES → code-insight → feature-design → writing-plans → executing-plans → git-commit
  │
  ├─ Simple bug fix (1-2 files, clear requirements)?
  │   └─ YES → writing-plans (minimal) → executing-plans → git-commit
  │
  ├─ Have plan ready?
  │   └─ YES → executing-plans → git-commit
  │
  ├─ Need to review code?
  │   └─ YES → code-review
  │         ├─ Issues found? → writing-plans --fix-for → executing-plans
  │         └─ Clean → git-commit
  │
  ├─ Need to migrate commits?
  │   └─ YES → commit-change-log → commit-migration → executing-plans → git-commit
  │
  ├─ Code ready to commit?
  │   └─ YES → git-commit
  │
  └─ Need to save session state?
      └─ YES → save-context
```

---

## Sequence Number Rules

All documents use auto-increment sequence numbers:

**Rule:** Find max `<seq>` in target directory, next = max + 1. Start with `001` if no files exist.

**Examples:**
- `001-insight-2026-01-18.md` (first document)
- `002-insight-2026-01-18.md` (second document)
- `fix-001-plan-2026-01-18.md` (fix plan, separate sequence)

**Patterns:**
- Code Insight: `<seq>-insight-YYYY-MM-DD.md`
- Feature Design: `<seq>-ft-YYYY-MM-DD.md`
- Implementation Plan: `<seq>-plan-YYYY-MM-DD.md`
- Fix Plan: `fix-<seq>-plan-YYYY-MM-DD.md`
- Code Review: `<seq>-review-YYYY-MM-DD.md`
- Commit Log: `<seq>-<short-hash>-commit-log.md`
- Migration Plan: `<seq>-<short-hash>-migration-plan.md`

---

## Tips & Best Practices

1. **Start with save-context** - If resuming work, read context first to understand state
2. **Use code-insight before modifying** - Understand existing code before making changes
3. **Keep plans bite-sized** - Each task should be 10-20 minutes of work
4. **Commit frequently** - After each task or logical group of changes
5. **End with save-context** - Capture session state for next time
6. **Let context flow** - Don't re-specify context; sub-skills inherit automatically
7. **Review P0 issues immediately** - Blockers must be fixed before continuing
8. **Use fix plans for P1 issues** - Generate structured fix plans from code-review
9. **Adapt, don't copy** - When migrating, always adapt to target project structure
10. **Use UTF-8 safe commits on Windows** - File-based method + delete temp file

---

## Technology Stack Adaptation

The skill auto-detects technology stack and adapts:

**Detection:** Scans for `package.json`, `pom.xml`, `go.mod`, `pubspec.yaml`, etc.

**Adaptations:**
- Compile/build commands
- Test commands
- File naming conventions
- Code syntax patterns

**Supported:**
- Backend: Java/Spring Boot, Node/Express, Python/Django, Python/FastAPI, Go/Gin
- Frontend: React, Vue, Angular, Next.js, Nuxt.js
- Mobile: React Native, Flutter
- Full-stack: MERN, MEAN, T3 Stack
