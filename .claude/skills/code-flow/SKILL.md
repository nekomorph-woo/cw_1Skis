# Code Flow - Development Workflow Skill

---
name: code-flow
description: Development workflow skill for code exploration, feature design, implementation planning, execution, code review, and migration. Use document-driven decoupling where sub-skills pass context through documents.
version: 0.5.0
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

**Detection Method:** Scans project root for characteristic files (`package.json`, `pom.xml`, `go.mod`, `pubspec.yaml`, etc.) and analyzes dependencies to identify the technology stack.

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

**Detailed rules:** See `references/_core/context-management.md` for:
- Priority order: User explicit > Relative path > Current context > Ask user
- Context switching patterns
- Special cases (path extraction, validation)

## Development Workflows

| Scenario | Workflow |
|----------|----------|
| New Feature | `feature-design` → `writing-plans` → `executing-plans` → `git-commit` |
| Modify Existing Code | `code-insight` → `feature-design` → `writing-plans` → `executing-plans` → `git-commit` |
| Quick Bug Fix | `writing-plans` → `executing-plans` → `git-commit` |
| Code Migration | `commit-change-log` → `commit-migration` → `executing-plans` → `git-commit` |
| Code Review | `code-review` → (if issues) → `writing-plans --fix-for` → `executing-plans` → `git-commit` |

## Sub-Skills

| Sub-Skill | Purpose | Triggers | Parameters | Output | Guide |
|-----------|---------|----------|------------|--------|-------|
| `code-insight` | Explore existing code structure, call chains, implementation | "explore code", "how is X implemented", "understand existing code", "trace call chain" | `<feature-name>` (optional) | `01_dev/code_insight/<seq>-insight-YYYY-MM-DD.md` | `code-insight.md` |
| `feature-design` | Design features with technical analysis, API design, risk assessment | "design feature", "create design doc", "technical approach", "API design" | `<feature-name>` (optional) | `01_dev/feature_design/<seq>-ft-YYYY-MM-DD.md` | `feature-design.md` |
| `writing-plans` | Convert designs into actionable implementation plans | "create plan", "write implementation plan", "generate fix plan", "break down tasks" | `<feature-name>` (optional), `--fix-for <review-doc>` (fix mode) | `01_dev/impl_plan/<seq>-plan-YYYY-MM-DD.md` or `fix-<seq>-plan-YYYY-MM-DD.md` | `writing-plans.md` |
| `executing-plans` | Execute plans task-by-task with completion verification | "execute plan", "implement this plan", "run implementation" | `<plan-path>` (optional, auto-select if omitted) | (code implementation) | `executing-plans.md` |
| `code-review` | Review code for bugs, security vulnerabilities, best practices | "review code", "code review", "check for issues" | `<feature-name>` (optional), `<scope>` (explicit mode only) | `01_dev/code_review/<seq>-review-YYYY-MM-DD.md` | `code-review.md` |
| `save-context` | Save session context including tasks, decisions, files | "save context", "save session", "save progress" | `<feature-name>` (optional) | `02_memories/active_context.md` | `save-context.md` |
| `commit-change-log` | Generate code change summaries from git commits | "summarize commits", "analyze commit", "generate change log" | `<feature-name>` (optional), `<commit-hash>` (required) | `03_migration/commit-log-summary/<seq>-<hash>-commit-log.md` | `commit-change-log.md` |
| `commit-migration` | Generate migration plans from change summaries | "create migration plan", "migrate changes", "generate migration" | `<summary-doc-path>` (required) | `03_migration/migration-plan/<seq>-<hash>-migration-plan.md` | `commit-migration.md` |
| `git-commit` | Generate Conventional Commit messages with emoji | "commit", "commit changes", "git commit" | none | (git commit) | `git-commit.md` |

## Decision Guide

### code-insight vs feature-design

Use `code-insight` when:
- Question is "How is this implemented?"
- Need to understand existing code structure
- Exploring call chains and dependencies
- Tracking bugs or performance issues in existing code

Use `feature-design` when:
- Question is "How should this be implemented?"
- Designing new functionality
- Need technical approach comparison (MVP vs Balanced vs Advanced)
- Require API design and data model specifications

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

### code-review vs Manual Review

Use `code-review` sub-skill when:
- Need structured review document
- Want issue categorization (P0-P3)
- Plan to generate fix plans from issues

Manual review is sufficient when:
- Quick sanity check
- Simple, isolated changes
- No need for documentation

## Document Paths

All documents use consistent structure under `flow-docs/<feature-name>/`:

**Sequence Number (`<seq>`) Rule:** Auto-increment based on existing files in the target directory. Pattern: find max `<seq>` in directory, next = max + 1. Start with `001` if no files exist.

| Type | Path |
|------|------|
| Code Insight | `01_dev/code_insight/<seq>-insight-YYYY-MM-DD.md` |
| Feature Design | `01_dev/feature_design/<seq>-ft-YYYY-MM-DD.md` |
| Implementation Plan | `01_dev/impl_plan/<seq>-plan-YYYY-MM-DD.md` |
| Fix Plan | `01_dev/impl_plan/fix-<seq>-plan-YYYY-MM-DD.md` |
| Code Review | `01_dev/code_review/<seq>-review-YYYY-MM-DD.md` |
| Context | `02_memories/active_context.md` |
| Commit Log | `03_migration/commit-log-summary/<seq>-<short-hash>-commit-log.md` |
| Migration Plan | `03_migration/migration-plan/<seq>-<short-hash>-migration-plan.md` |

## Additional Resources

### Reference Files Structure

**Universal Templates:** `references/_core/*.md` (apply to all technologies)

**Technology-Specific Guides:** Each guide contains:
- Compile/Build commands
- Test commands
- File naming conventions
- Language-specific patterns

**Detection Signals:** See `references/README.md` for how technology is detected.

**Backend:** `backend/*.md`
- Java/Spring Boot, Node/Express, Python/Django, Python/FastAPI, Go/Gin

**Frontend:** `frontend/*.md`
- React, Vue, Angular, Next.js, Nuxt.js

**Mobile:** `mobile/*.md`
- React Native, Flutter

**Full-Stack:** `fullstack/*.md`
- MERN, MEAN, T3 Stack (combine backend + frontend patterns)

### Example Files & Scripts

- `examples/workflow-examples.md` - Complete workflow demonstrations
- `scripts/init-flow-docs.sh` / `init-flow-docs.ps1` - Initialize directory structure

## Context Example

**Context Inheritance:**
```
User: "Explore scene creation code"
→ code-insight runs, context = "scene-creation"

User: "Develop an implementation plan"
→ writing-plans runs, inherits context = "scene-creation"
→ Output: flow-docs/scene-creation/01_dev/impl_plan/...
```

**Context Output:**
- Switch: `"**Context Switch:** scene-creation → user-management"`
- Confirm: `"**Current Context:** user-management"`

## Error Recovery & Edge Cases

For comprehensive error recovery strategies, see detailed documentation in each sub-skill guide.

### Code Review Failures
- **P0 issues found during executing-plans:** Fix immediately before continuing
- **Fix introduces new issues:** Re-run code-review, repeat until clean
- See `executing-plans.md:91-97` for detailed P0 handling flow

### Git Operation Failures
- **Commit fails:** Check for merge conflicts, unmerged files, or permission issues
- **Network issues:** Retry after checking connection, use `git fetch` to sync
- **UTF-8 encoding issues (Windows):** Always use file-based commit method
- See `git-commit.md:68-151` for platform-specific commit methods

### Edge Cases
- **Feature name with special characters:** Validate before directory creation
- **Manual document directory changes:** Warn user, recommend re-initializing
- **Git branch switch:** Context remains valid unless documents were deleted
- **Multiple tech stacks in monorepo:** Detect based on current working directory
- **executing-plans completion verification:** Never skip tasks without code references (`executing-plans.md:60-78`)

## Language Convention

All documentation, comments, and commit messages adaptively use **<user's language>** with UTF-8 encoding. Technical terms and code identifiers remain in original form.

**See `context-management.md:114-120` for detailed UTF-8 encoding rules.**

---

**Remember:** Sub-skills operate independently through document decoupling. Use standalone for specific tasks or combine for complete workflows. Documents serve as the context medium between skills.
