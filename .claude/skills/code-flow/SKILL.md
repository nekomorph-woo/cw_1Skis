# Code Flow - Development Workflow Skill

---
name: code-flow
description: This skill should be used when the user asks to "explore code", "understand existing code", "design a feature", "write an implementation plan", "execute a plan", "save context", "generate commit message", "analyze git commits", "create migration plan", or mentions development workflow tasks like code-insight, feature-design, writing-plans, executing-plans, save-context, git-commit, commit-change-log, commit-migration. Provides comprehensive development workflow guidance for feature development, code migration, and session management.
version: 1.0.0
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

This skill supports multiple technology stacks. When invoked, it will:

1. **Auto-detect the project's technology stack** from project files
2. **Load appropriate technology-specific guidance** from `references/`
3. **Adapt commands, patterns, and examples** to the detected stack

**Supported Technology Stacks:**

**Backend:**
- Java / Spring Boot
- Node.js / Express (Pure JavaScript)
- Python / Django
- Python / FastAPI
- Go / Gin

**Frontend:**
- React
- Vue
- Angular
- Next.js (React SSR)
- Nuxt.js (Vue SSR)

**Mobile:**
- React Native
- Flutter

**Full-Stack:**
- MERN (MongoDB + Express + React + Node)
- MEAN (MongoDB + Express + Angular + Node)
- T3 Stack (TypeScript + tRPC + Tailwind + Next.js)

**Technology Detection Signals:**
| Stack | Detection Files |
|-------|----------------|
| Java/Spring Boot | `pom.xml`, `build.gradle`, `@SpringBootApplication` |
| Node/Express | `package.json` with express, `server.js` |
| Python/Django | `manage.py`, `settings.py` |
| Python/FastAPI | `main.py` with FastAPI import |
| Go/Gin | `go.mod`, `github.com/gin-gonic/gin` |
| React | `package.json` with react, `.jsx` files |
| Vue | `package.json` with vue, `.vue` files |
| Angular | `angular.json`, `.component.ts` |
| Next.js | `next.config.js`, `app/` directory |
| Nuxt.js | `nuxt.config.ts`, `pages/` directory |
| React Native | `react-native` in package.json |
| Flutter | `pubspec.yaml`, `lib/main.dart` |

See `references/README.md` for detailed technology-specific guidance.

## Development Workflows

### New Feature Development

```
User Request → feature-design → writing-plans → executing-plans → git-commit
              (optional: code-insight first if exploring existing code)
```

### Existing Code Modification

```
User Request → code-insight → feature-design → writing-plans → executing-plans → git-commit
```

### Code Migration

```
Git Commits → commit-change-log → commit-migration → executing-plans → git-commit
```

### Quick Bug Fix

```
Bug Report → writing-plans → executing-plans → git-commit
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
| Code Insight | `01_dev/code_insight/insight-YYYY-MM-DD-<name>.md` |
| Feature Design | `01_dev/feature_design/ft-YYYY-MM-DD-<name>.md` |
| Implementation Plan | `01_dev/impl_plan/plan-YYYY-MM-DD-<name>.md` |
| Context | `02_memories/context_<feature-name>/active_context.md` |
| Commit Log | `03_migration/commit-log-summary/<seq>_<short-hash>_commit_log.md` |
| Migration Plan | `03_migration/migration-plan/<seq>_<short-hash>_migration_plan.md` |

## Quick Reference

| Scenario | Sub-Skill | Output Location |
|----------|-----------|-----------------|
| Understand existing code | code-insight | `01_dev/code_insight/` |
| Design new feature | feature-design | `01_dev/feature_design/` |
| Plan implementation | writing-plans | `01_dev/impl_plan/` |
| Execute plan | executing-plans | (code) |
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
- `/code-flow save-context` - Save context
- `/code-flow commit-change-log` - Analyze commits
- `/code-flow commit-migration` - Create migration plan
- `/code-flow git-commit` - Generate commit message

## Language Convention

All documentation, comments, and commit messages adaptively use **<user's language>** with UTF-8 encoding. Technical terms and code identifiers remain in original form.

---

**Remember:** Sub-skills operate independently through document decoupling. Use standalone for specific tasks or combine for complete workflows. Documents serve as the context medium between skills.
