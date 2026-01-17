# Code Flow - Development Workflow Skill

---
name: code-flow
description: Development workflow skill for code exploration, feature design, implementation planning, execution, code review, and migration. Use document-driven decoupling where sub-skills pass context through documents.
version: 1.0.0
author: claude-code
---

## Purpose

Guide through complete development workflows including code exploration, feature design, implementation planning, execution, and code migration. Use document-driven decoupling where sub-skills pass context through documents, enabling both standalone and combined usage.

## Core Concepts

### Document-Driven Architecture

Sub-skills communicate through documents stored in `flow-docs/<feature-name>/`:
- `01_dev/` - Development documents (code insight, feature design, implementation plans)
- `02_memories/` - Session context and state
- `03_migration/` - Code migration documents (commit summaries, migration plans)

### Progressive Disclosure

Each sub-skill operates independently:
- Use sub-skills standalone for specific tasks
- Combine sub-skills for complete workflows
- Documents serve as the decoupling medium between skills

### Technology Stack Adaptation

This skill auto-detects project technology stack and adapts commands/patterns accordingly.

**Supported Stacks:**
- **Backend:** Java/Spring Boot, Node/Express, Python/Django, Python/FastAPI, Go/Gin
- **Frontend:** React, Vue, Angular, Next.js, Nuxt.js
- **Mobile:** React Native, Flutter
- **Full-Stack:** MERN, MEAN, T3 Stack

See `references/README.md` for detection signals and detailed guidance.

### Document Context Management

The skill maintains a **current document context** (`<feature-name>`) to ensure all documents belong to the same feature during a session.

**Key Rules:**
- User explicitly specifies → Switch context
- Relative path reference → Use current context (must exist)
- No context information → Keep current context
- No context exists → Ask user

**Context Propagation:** Sub-skills automatically inherit context. For example: `code-insight` sets initial context → `writing-plans` inherits → `executing-plans` inherits from plan path.

**Detailed rules:** See `references/_core/context-management.md`

## Development Workflows

### New Feature Development

```
User Request → feature-design → writing-plans → executing-plans (with code-review) → git-commit
              (optional: code-insight first if exploring existing code)
```

### Existing Code Modification

```
User Request → code-insight → feature-design → writing-plans → executing-plans (with code-review) → git-commit
```

### Code Migration

```
Git Commits → commit-change-log → commit-migration → executing-plans (with code-review) → git-commit
```

### Quick Bug Fix

```
Bug Report → writing-plans → executing-plans (with code-review) → git-commit
```

### Code Review Workflow

```
Code Review → code-review → (if issues) → writing-plans --fix-for → executing-plans → git-commit
```

## Sub-Skills

### code-insight

**Purpose:** Explore and understand existing codebase structure, call chains, and implementation details.

**When to use:**
- Need to modify existing code
- New feature depends on existing modules
- Tracking bugs or performance issues
- Understanding call flows and data paths

**Output:** `01_dev/code_insight/insight-YYYY-MM-DD-<name>.md`

**Detailed guidance:** `references/code-insight.md`

### feature-design

**Purpose:** Create comprehensive feature design documents with technical analysis, API design, and risk assessment.

**When to use:**
- Received new requirements requiring design
- Need to evaluate multiple technical approaches
- Need API design and data model specifications
- Require risk assessment and test planning

**Output:** `01_dev/feature_design/ft-YYYY-MM-DD-<name>.md`

**Detailed guidance:** `references/feature-design.md`

### writing-plans

**Purpose:** Convert design documents into actionable implementation plans with bite-sized tasks.

**When to use:**
- Have feature design document requiring implementation plan
- Have requirements needing multi-step implementation
- Preparing to start coding

**Output:** `01_dev/impl_plan/plan-YYYY-MM-DD-<name>.md`

**Detailed guidance:** `references/writing-plans.md`

### executing-plans

**Purpose:** Execute implementation or migration plans task-by-task with completion verification.

**When to use:**
- Have implementation plan requiring execution
- Have migration plan requiring execution

**Output:** Code implementation (no document created)

**Detailed guidance:** `references/executing-plans.md`

### save-context

**Purpose:** Save current session context including tasks, decisions, files, and issues.

**When to use:**
- Completed important work in session
- Need to record current state for future reference
- Before switching tasks

**Output:** `02_memories/context_<feature-name>/active_context.md`

**Detailed guidance:** `references/save-context.md`

### commit-change-log

**Purpose:** Generate code change summary documents from git commits for migration purposes.

**When to use:**
- Need to migrate code changes to other projects
- Need to record commit intent and scope

**Output:** `03_migration/commit-log-summary/<seq>_<short-hash>_commit_log.md`

**Detailed guidance:** `references/commit-change-log.md`

### commit-migration

**Purpose:** Generate migration plans from code change summary documents.

**When to use:**
- Have code change summary requiring migration plan
- Preparing to migrate code to target project

**Output:** `03_migration/migration-plan/<seq>_<short-hash>_migration_plan.md`

**Detailed guidance:** `references/commit-migration.md`

### git-commit

**Purpose:** Generate git commit messages following Conventional Commit format with emoji prefixes.

**When to use:**
- Completed code changes requiring commit
- Need to follow project commit conventions

**Output:** Git commit (no document created)

**Detailed guidance:** `references/git-commit.md`

### code-review

**Purpose:** Review code changes for compilation issues, bugs, security vulnerabilities, and best practice violations.

**When to use:**
- After completing implementation tasks (implicit)
- Need comprehensive code review before committing (explicit)
- Generating fix plans for identified issues

**Output:** `01_dev/code_review/<seq>-review-YYYY-MM-DD.md`

**Detailed guidance:** `references/code-review.md`

## Decision Guide

### code-insight vs feature-design

Use `code-insight` when:
- Question is "How is this implemented?"
- Need to understand existing code structure
- Exploring call chains and dependencies

Use `feature-design` when:
- Question is "How should this be implemented?"
- Designing new functionality
- Need technical approach comparison

### When to Plan

Skip planning for:
- Single-line or trivial fixes
- Adding single function with clear requirements
- Tasks where user provides specific, detailed instructions

Use planning for:
- Multi-file changes
- New feature implementation
- Architectural decisions required
- Tasks touching 2-3+ files

## Document Paths

All documents use consistent structure under `flow-docs/<feature-name>/`:

| Type | Path |
|------|------|
| Code Insight | `01_dev/code_insight/<seq>-insight-YYYY-MM-DD.md` |
| Feature Design | `01_dev/feature_design/<seq>-ft-YYYY-MM-DD.md` |
| Implementation Plan | `01_dev/impl_plan/<seq>-plan-YYYY-MM-DD.md` |
| Fix Plan | `01_dev/impl_plan/fix-<seq>-plan-YYYY-MM-DD.md` |
| Code Review | `01_dev/code_review/<seq>-review-YYYY-MM-DD.md` |
| Context | `02_memories/context_<feature-name>/active_context.md` |
| Commit Log | `03_migration/commit-log-summary/<seq>-<short-hash>-commit-log.md` |
| Migration Plan | `03_migration/migration-plan/<seq>-<short-hash>-migration-plan.md` |

## Quick Reference

| Scenario | Sub-Skill | Output Location |
|----------|-----------|-----------------|
| Understand existing code | code-insight | `01_dev/code_insight/` |
| Design new feature | feature-design | `01_dev/feature_design/` |
| Plan implementation | writing-plans | `01_dev/impl_plan/` |
| Execute plan | executing-plans | (code) |
| Review code | code-review | `01_dev/code_review/` |
| Save session | save-context | `02_memories/context_*/` |
| Analyze commits | commit-change-log | `03_migration/commit-log-summary/` |
| Create migration plan | commit-migration | `03_migration/migration-plan/` |
| Commit changes | git-commit | (git commit) |

## Additional Resources

### Reference Files Structure

**Universal Templates (apply to all technologies):**
- **`references/_core/code-insight.md`** - Code exploration template
- **`references/_core/feature-design.md`** - Feature design document template
- **`references/_core/writing-plans.md`** - Implementation plan template
- **`references/_core/executing-plans.md`** - Plan execution guide
- **`references/_core/code-review.md`** - Code review guide
- **`references/_core/save-context.md`** - Context saving guide
- **`references/_core/commit-change-log.md`** - Commit analysis and summary
- **`references/_core/commit-migration.md`** - Migration plan generation
- **`references/_core/git-commit.md`** - Conventional Commit format

**Technology-Specific Guides:**

**Backend:**
- **`references/backend/java-spring-boot.md`** - Java/Spring Boot guide
- **`references/backend/node-express.md`** - Node.js/Express (Pure JS) guide
- **`references/backend/python-django.md`** - Python/Django guide
- **`references/backend/python-fastapi.md`** - Python/FastAPI guide
- **`references/backend/go-gin.md`** - Go/Gin guide

**Frontend:**
- **`references/frontend/react.md`** - React guide
- **`references/frontend/vue.md`** - Vue guide
- **`references/frontend/angular.md`** - Angular guide
- **`references/frontend/nextjs.md`** - Next.js guide
- **`references/frontend/nuxtjs.md`** - Nuxt.js guide

**Mobile:**
- **`references/mobile/react-native.md`** - React Native guide
- **`references/mobile/flutter.md`** - Flutter guide

**Full-Stack:**
- **`references/fullstack/mern.md`** - MERN Stack guide
- **`references/fullstack/mean.md`** - MEAN Stack guide
- **`references/fullstack/t3-stack.md`** - T3 Stack guide

**Index:**
- **`references/README.md`** - Technology detection and quick reference matrix

### Example Files

Working examples in `examples/`:
- **`workflow-examples.md`** - Complete workflow demonstrations

### Scripts

Utility scripts in `scripts/`:
- **`init-flow-docs.sh`** - Initialize flow-docs directory structure

## Usage Patterns

Invoke sub-skills directly:
- `/code-flow code-insight` - Explore code
- `/code-flow feature-design` - Design feature
- `/code-flow writing-plans` - Write plan
- `/code-flow executing-plans` - Execute plan
- `/code-flow code-review` - Review code
- `/code-flow save-context` - Save context
- `/code-flow commit-change-log` - Analyze commits
- `/code-flow commit-migration` - Create migration plan
- `/code-flow git-commit` - Generate commit message

## Context Examples

### Scenario 1: First Invocation with Context
```
User: "探索 scene creation 代码"
→ code-insight runs, context = "scene-creation"
→ Output: flow-docs/scene-creation/01_dev/code_insight/...
```

### Scenario 2: Context Inheritance
```
User: "编写实现计划"
→ writing-plans runs, uses context = "scene-creation" (from previous)
→ Output: flow-docs/scene-creation/01_dev/impl_plan/...
```

### Scenario 3: Explicit Context Switch
```
User: "为 user-management 编写实现计划"
→ writing-plans runs, switches context to "user-management" (explicit)
→ Output: flow-docs/user-management/01_dev/impl_plan/...
```

### Scenario 4: Absolute Path (Auto Switch)
```
User: "读取 flow-docs/scene-creation/01_dev/code_insight/..."
→ Extracts "scene-creation" from absolute path
→ Switches context to "scene-creation"
→ Reads the specified document
```

### Scenario 5: No Context - Ask User
```
User: "编写实现计划" (session first invocation)
→ No current context, no feature-name specified
→ Asks: "Which feature/context should I work with? Please provide `<feature-name>` or document path."
```

### Context Output Format

**When switching context:**
```markdown
**Context Switch:** "scene-creation" → "user-management"
All subsequent documents will be saved to:
flow-docs/user-management/
```

**When confirming context:**
```markdown
**Current Context:** user-management
Working directory: flow-docs/user-management/
```

## Error Recovery & Edge Cases

### Code Review Failures
- **P0 issues found during executing-plans:** Fix immediately before continuing
- **Fix introduces new issues:** Re-run code-review, repeat until clean

### Git Operation Failures
- **Commit fails:** Check for merge conflicts, unmerged files, or permission issues
- **Network issues:** Retry after checking connection, use `git fetch` to sync
- **UTF-8 encoding issues (Windows):** Always use file-based commit method

### Edge Cases
- **Feature name with special characters:** Validate before directory creation
- **Manual document directory changes:** Warn user, recommend re-initializing
- **Git branch switch:** Context remains valid unless documents were deleted
- **Multiple tech stacks in monorepo:** Detect based on current working directory

## Language Convention

All documentation, comments, and commit messages adaptively use **<user's language>** with UTF-8 encoding. Technical terms and code identifiers remain in original form.

---

**Remember:** Sub-skills operate independently through document decoupling. Use standalone for specific tasks or combine for complete workflows. Documents serve as the context medium between skills.
