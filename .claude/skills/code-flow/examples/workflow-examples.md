# Workflow Examples - Code Flow Skill

## Overview

Complete workflow examples demonstrating how to use the code-flow skill for various development scenarios.

---

## Example 1: New Feature Development

### Scenario

User requests: "I need to add a new device control feature that supports remote on/off operations"

### Workflow

```
/code-flow feature-design
```

**Claude actions:**
1. Ask for requirements or existing insight document
2. Create `flow-docs/device-control/01_dev/feature_design/ft-2026-01-17-device-control.md`
3. Document: requirements, 3 technical approaches (MVP/Balanced/Advanced), API design, data design, risks

```
/code-flow writing-plans
```

**Claude actions:**
1. Read design document from `01_dev/feature_design/`
2. Create `flow-docs/device-control/01_dev/impl_plan/plan-2026-01-17-device-control.md`
3. Break down into bite-sized tasks with TDD approach

```
/code-flow executing-plans
```

**Claude actions:**
1. List available plans in `01_dev/impl_plan/`
2. Ask for confirmation
3. Execute tasks sequentially, checking completion status
4. Output code references for completed tasks

```
/code-flow git-commit
```

**Claude actions:**
1. Check `git status` and `git diff --cached`
2. Generate Conventional Commit message with emoji
3. Execute UTF-8 safe commit

```
/code-flow save-context
```

**Claude actions:**
1. Extract tasks, decisions, files from conversation
2. Create `flow-docs/device-control/02_memories/context_device-control/active_context.md`

### Result

```
flow-docs/device-control/
├── 01_dev/
│   ├── feature_design/ft-2026-01-17-device-control.md
│   └── impl_plan/plan-2026-01-17-device-control.md
└── 02_memories/
    └── context_device-control/active_context.md
```

---

## Example 2: Existing Code Modification

### Scenario

User requests: "I need to modify the scene creation functionality to add device online status validation"

### Workflow

```
/code-flow code-insight
```

**Claude actions:**
1. Ask: "What functionality needs exploration?"
2. Analyze scene creation code
3. Document call chain, key code, file inventory
4. Create `flow-docs/scene-online-check/01_dev/code_insight/insight-2026-01-17-scene-creation.md`

```
/code-flow feature-design
```

**Claude actions:**
1. Read insight document for context
2. Create design with 3 approaches for adding online check
3. Create `flow-docs/scene-online-check/01_dev/feature_design/ft-2026-01-17-online-validation.md`

```
/code-flow writing-plans
```
```
/code-flow executing-plans
```
```
/code-flow git-commit
```
```
/code-flow save-context
```

### Result

```
flow-docs/scene-online-check/
├── 01_dev/
│   ├── code_insight/insight-2026-01-17-scene-creation.md
│   ├── feature_design/ft-2026-01-17-online-validation.md
│   └── impl_plan/plan-2026-01-17-online-validation.md
└── 02_memories/
    └── context_scene-online-check/active_context.md
```

---

## Example 3: Code Migration

### Scenario

User requests: "I need to migrate changes from commit aa8db135 to another project"

### Workflow

```
/code-flow commit-change-log
```

**Claude actions:**
1. Ask: "Please provide commit hash"
2. User provides: `aa8db135ca4bde0d08c31c65bee27a088820b1b7`
3. Analyze commit, extract changes
4. Create `flow-docs/cloud-armed-migration/03_migration/commit-log-summary/001_aa8db13_commit_log.md`

```
/code-flow commit-migration
```

**Claude actions:**
1. Ask: "Please provide summary document path"
2. User provides: `flow-docs/cloud-armed-migration/03_migration/commit-log-summary/001_aa8db13_commit_log.md`
3. Analyze target project structure
4. Generate adapted migration plan
5. Create `flow-docs/cloud-armed-migration/03_migration/migration-plan/001_aa8db13_migration_plan.md`

```
/code-flow executing-plans
```

**Claude actions:**
1. Load migration plan from `03_migration/migration-plan/`
2. Execute tasks with target project adaptations
3. Verify compilation after each task

```
/code-flow git-commit
```

### Result

```
flow-docs/cloud-armed-migration/
└── 03_migration/
    ├── commit-log-summary/001_aa8db13_commit_log.md
    └── migration-plan/001_aa8db13_migration_plan.md
```

---

## Example 4: Quick Bug Fix

### Scenario

User requests: "Scene query API has a bug, needs fixing"

### Workflow

```
/code-flow writing-plans
```

**Claude actions:**
1. Ask for bug description
2. Create minimal plan for fix
3. No need for full design document for simple bug

```
/code-flow executing-plans
```
```
/code-flow git-commit
```

### Simplified Document Structure

```
flow-docs/scene-query-bug-fix/
└── 01_dev/
    └── impl_plan/plan-2026-01-17-scene-query-fix.md
```

---

## Example 5: Batch Commit Migration

### Scenario

User requests: "I need to migrate multiple commits: aa8db135 bb8db136 cc8db137"

### Workflow

```
/code-flow commit-change-log
```

**Claude actions:**
1. Accept multiple commit hashes
2. Pre-check: Calculate total changes
3. Ask if batch processing (if large)
4. Analyze each commit
5. Merge analysis for common files
6. Create single summary: `002_aa8db13-cc8db13_commit_log.md`

```
/code-flow commit-migration
```
```
/code-flow executing-plans
```

---

## Sub-Skill Standalone Usage

### Using code-insight Alone

```
User: "Help me understand how scene creation works"
```

```
/code-flow code-insight
```

**Output:** `01_dev/code_insight/insight-YYYY-MM-DD-scene-creation.md`

No other sub-skills invoked. User can review and decide next steps.

### Using save-context Alone

```
User: "Save current context"
```

```
/code-flow save-context
```

**Output:** `02_memories/context_<feature>/active_context.md`

Useful anytime during session to checkpoint state.

### Using git-commit Alone

```
User: "Commit code"
```

```
/code-flow git-commit
```

**Output:** Git commit (no document)

Can be used with any workflow or standalone.

---

## Document-Driven Decoupling Example

### Session Break Recovery

**Day 1:**
```
User: "I need to add device control feature"
/code-flow feature-design → ft-2026-01-17-device-control.md
/code-flow writing-plans → plan-2026-01-17-device-control.md
/code-flow save-context → active_context.md
```

**Day 2 (new session):**
```
User: "Continue device control feature development"
```

**Claude actions:**
1. Read `flow-docs/device-control/02_memories/context_device-control/active_context.md`
2. Understand: design complete, plan ready, ready to execute
3. Continue from:

```
/code-flow executing-plans
```

No need to repeat design or planning steps - documents carry the context.

---

## Workflow Decision Tree

```
Start
  │
  ├─ Need to understand existing code?
  │   └─ YES → code-insight
  │
  ├─ Have requirements for new feature?
  │   └─ YES → feature-design → writing-plans
  │
  ├─ Simple bug fix (1-2 files)?
  │   └─ YES → writing-plans (minimal)
  │
  ├─ Have plan ready?
  │   └─ YES → executing-plans
  │
  ├─ Need to migrate commits?
  │   └─ YES → commit-change-log → commit-migration
  │
  └─ Code ready to commit?
      └─ YES → git-commit
```

---

## Tips

1. **Start with save-context** - If resuming work, read context first
2. **Use code-insight before modifying** - Understand before changing
3. **Keep plans bite-sized** - Each task 10-20 minutes
4. **Commit frequently** - After each task or logical group
5. **End with save-context** - Capture session state for next time
