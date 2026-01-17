# Commit Migration - Migration Plan Generator

## Purpose

Generate migration plans from code change summary documents. Analyze target project's codebase and create detailed migration plans adapted to target structure.

## When to Use

- Have code change summary requiring migration plan
- Preparing to migrate code to target project

## Trigger Keywords

Common phrases that indicate this sub-skill should be used:
- "create migration plan", "migrate changes", "generate migration"
- "adapt to target project", "port this code"

## Context Determination

**Extract context from commit-log document path:**

Parse commit-log document path to extract `<feature-name>`:
- Pattern: `flow-docs/<feature-name>/03_migration/commit-log-summary/<seq>-<hash>-commit-log.md`

**Output:** `"**Current Context:** <feature-name> (from commit-log document)"`

**Migration plan output:** `flow-docs/<feature-name>/03_migration/migration-plan/<seq>-<hash>-migration-plan.md`

## Announcement

Start with: "I'm using the commit-migration sub-skill to generate migration execution plan. Please provide summary document path..."

## Workflow

### Step 1: Request Summary

Prompt: "Please provide code change summary document path (e.g., `flow-docs/<feature-name>/03_migration/commit-log-summary/001_aa8db13_commit_log.md`)"

### Step 2: Analyze Target Project

**For each file in summary:**

1. **Check if exists in target:**
   - Search similar names/paths
   - Check package structure differences
   - Identify equivalent classes/methods

2. **Analyze code structure:**
   - Read target files
   - Identify differences from source
   - Check dependencies exist

3. **Identify adaptation points:**
   - File path differences
   - Package name differences
   - Method name differences
   - Missing dependencies

### Step 3: Generate Plan

```markdown
# [Feature Name] Migration Plan

> **For Claude:** REQUIRED SUB-SKILL: Use code-flow:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing migration goal]

**Source Commit:** `<commit-hash>` - [Commit message]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies from target]

**Migration Notes:** [Key adaptation points]

---

## Migration Context

### Source Project Changes
[Brief summary]

### Target Project Analysis
[Findings: file mapping, missing deps, differences]

### Migration Constraints

⚠️ **UNMIGRATABLE FEATURES** (if any):

> When source functionality cannot be adapted to target due to fundamental differences:

```markdown
- [Feature name] - **REASON:** [e.g., Target lacks equivalent dependency / Architecture fundamentally different]
- [Feature name] - **REASON:** [e.g., Technology stack incompatibility]
```

**Common reasons for unmigratable features:**
- Target project missing required dependencies/frameworks
- Fundamental architectural differences (e.g., sync vs async)
- Platform-specific features with no equivalent
- Deprecated APIs with no replacement
- Licensing or legal restrictions

---

## Task Structure

### Task N: [Component Name]

**Files:**
- Modify: `target/path/file.java` (from: `source/path/file.java`)
- Create: `target/path/new.java` (if needed)

**Step 1: Verify dependencies**

Check if required dependencies exist:
- [ ] `ClassX` exists at `path/to/ClassX.java`
- [ ] Method `methodY()` exists in `ClassX`

**Step 2: Locate target file**

Search for equivalent:
- Check package: `com.company.service`
- May be at: `src/main/java/com/company/service/Xxx.java`

**Step 3: Analyze current code**

Read target file to understand:
- Current implementation
- Method signatures
- Code style

**Step 4: Adapt and implement**

Based on summary intent (reference only). Adapt to target project's technology stack:

### Backend Syntax Comparison

| Technology | Method Signature Pattern | Key Characteristics |
|------------|--------------------------|---------------------|
| **Java / Spring Boot** | `public Response method(Request req)` | Synchronous, strongly typed |
| **Node.js / Express** | `async function method(req)` | async/await, dynamic typing |
| **Python / Django** | `def method(request)` | Synchronous, snake_case |
| **Python / FastAPI** | `async def method(request: Request) -> Response` | async + type hints |
| **Go / Gin** | `func (s *Service) Method(req Request) (Response, error)` | Receiver + error return |

### Frontend Syntax Comparison

| Technology | Component Pattern | Key Characteristics |
|------------|-------------------|---------------------|
| **React** | `function Component(props)` | Hooks, JSX, functional components |
| **Vue** | `<script setup>` | Composition API, SFC |
| **Angular** | `@Component() class Component` | TypeScript, decorators, RxJS |
| **Next.js** | `export default function Page()` | App Router, SSR/SSG |
| **Nuxt.js** | `<script setup>` | File-based routing, auto-imports |

### Mobile Syntax Comparison

| Technology | Component Pattern | Key Characteristics |
|------------|-------------------|---------------------|
| **React Native** | `function Component(props)` | React patterns, native modules |
| **Flutter** | `class Widget extends StatelessWidget` | Dart, widget composition |

> For detailed language-specific patterns, see:
> - Backend: `backend/<tech>.md`
> - Frontend: `frontend/<tech>.md`
> - Mobile: `mobile/<tech>.md`
> - Fullstack: `fullstack/<stack>.md`

**Implementation template (adapt to target syntax):**

```{java|js|py|go}
// File: path/to/TargetFile.{java|js|py|go}

// Adapted from source project
// Summary ref: [logic description]

// Implementation adapted to target:
[Actual code adapted to target structure and conventions]
```

**Key Adaptation Points:**
- [Adaptation 1: e.g., Method name differs]
- [Adaptation 2: Package structure difference]

**Step 5: Verify compilation**

Run: `mvn compile -DskipTests` / `npm run build` / `go build` / `pytest` (depending on technology)
Expected: BUILD SUCCESS / build success / tests pass

**Step 6: Code review**

Run: `/code-flow code-review`
Expected: Review document generated with no compilation errors

**Step 7: Commit**

Use `/code-flow git-commit` sub-skill to commit changes.

Follow git-commit workflow:
1. Check staged files with `git status`
2. Analyze changes with `git diff --cached`
3. Generate commit message with emoji prefix (following Conventional Commits)
4. Execute commit using file-based method on Windows for UTF-8 safety

---

## Verification Checklist

- [ ] All files modified per summary
- [ ] Code compiles without errors
- [ ] Dependencies resolved
- [ ] Functionality matches source intent
- [ ] Code style matches target conventions

---

## Technology Reference

> **Technology-Specific Commands:** See `writing-plans.md` → "Technology-Specific Commands Reference"
>
> **File Conventions:** See `writing-plans.md` → "File Conventions"
>
> **Detailed Guides:** See `backend/<tech>.md`, `frontend/<tech>.md`, `fullstack/<stack>.md`

---

## Plan Generation Rules

### File Path Adaptation

- Check target package structure
- Search for similar files
- Document mapping: `source → target`

### Code Adaptation

- **DO NOT copy directly**
- Use summary snippets as **reference only**
- Adapt to target's:
  - Package structure
  - Method names
  - Class names
  - Code style

### Task Granularity

Each task should be:
- Focused on one component/file
- 10-20 minutes of work
- Self-contained
- Includes verification

## Output Path

`flow-docs/<feature-name>/03_migration/migration-plan/<seq>-<short-hash>-migration-plan.md`

## Determine Sequence

See `SKILL.md:130` for sequence number rules: Auto-increment based on existing files in target directory.

## Important Notes

- **Always adapt, never copy**
- **Verify dependencies first**
- **Document adaptations**
- **Use codebase search**
- **Read before write**
- **Preserve code style**
- **Use user's language** for all generated content

## Handoff

After generating:

"**Migration plan generated and saved to `flow-docs/<feature-name>/03_migration/migration-plan/<seq>-<short-hash>-migration-plan.md`**"

"**Plan contains [N] tasks, adapted to target project code structure**"

"**Next step: Use `/code-flow executing-plans` to execute migration plan**"
