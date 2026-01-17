# Commit Change Log - Code Change Summary Generator

## Purpose

Generate code change summary documents from git commits. Focus on **what changed** and **why**, not exact implementation. Document intent and logic for migration to other projects.

## When to Use

- Need to migrate code changes to other projects
- Need to record commit intent and scope

## Context Determination

**Step 0: Determine document context**

1. **Check if user explicitly specified `<feature-name>`:**
   - Pattern: "为 [feature-name] 分析提交...", "[feature-name] 的提交日志..."
   - Pattern: Absolute path like `flow-docs/<feature-name>/...`

2. **If explicitly specified:**
   - Switch to specified context
   - Initialize directory structure if not exists:
     ```bash
     mkdir -p flow-docs/<feature-name>/03_migration/commit-log-summary
     ```
   - Output: `"**Context Switch:** → <feature-name>"`
   - Proceed with specified context

3. **If not explicitly specified:**
   - Check for current context from recent documents in conversation
   - If exists → Use current context
     - Output: `"**Current Context:** <feature-name>"`
   - If not exists → Ask user:
     - "No current context. Please specify `<feature-name>` or provide absolute path to existing document."

4. **If user input is ambiguous:**
   - Ask: "Which feature/context should I analyze commits for? Please provide `<feature-name>`."

## Announcement

Start with: "I'm using the commit-change-log sub-skill to generate code change summary documents. Please provide commit hash..."

## Workflow

### Step 1: Request Commit Hash

Prompt: "Please provide commit hash (e.g., `aa8db135ca4bde0d08c31c65bee27a088820b1b7`), multiple hashes separated by space or newline"

### Step 2: Analyze Commits

**Single commit:**
1. Get metadata: `git log -1 --format="%H%n%an%n%ae%n%ad%n%s" <hash>`
2. Get changed files: `git show <hash> --name-status`
3. Get statistics: `git show <hash> --stat`
4. Get full diff: `git show <hash>`

**Multiple commits:**
1. Analyze each commit individually
2. Identify common files across commits
3. Analyze commit relationships

### Step 3: Determine Sequence

Check existing files in `flow-docs/*/03_migration/commit-log-summary/`:
- Extract sequence numbers from filenames
- Next sequence = max + 1
- Start with `001` if no files exist

### Step 4: Generate Document

**For single commit:**

```markdown
# Code Change Summary Document

## Basic Information

| Field | Value |
|------|-------|
| Commit Hash | `<commit-hash>` |
| Commit Message | `<commit message>` |
| Commit Date | `<YYYY-MM-DD HH:mm:ss>` |
| Author | `<author>` |
| Change Type | Feature / Bugfix / Refactor / Enhancement / Other |
| Change Scope | [Brief description] |

---

## Change Intent

### Feature Description
[1-2 sentences describing implemented functionality]

### Business Value
[Explain business value]

---

## Change Scope

### File Change Statistics

| Type | Count | File List |
|------|-------|-----------|
| New | X | `path/to/file1.java` |
| Modified | Y | `path/to/file2.java` |
| Deleted | Z | `path/to/file3.java` |

---

## Change Details

### Core Change Logic

1. **[Change point 1]** - [Describe logic]
2. **[Change point 2]** - [Describe logic]

### Key Method Signatures (Reference)

```java
// File: path/to/File.java
public ReturnType methodName(ParamType param1);
```

> ⚠️ **Note:** Above is for reference only. Actual implementation needs adaptation to target project.

---

## Dependencies

| Dependency | Description | Required |
|------------|-------------|----------|
| [Dependency] | [Description] | Yes/No |

---

## Migration Notes

### Target Project Adaptation Points

1. **[Adaptation point 1]** - [Explain differences]
2. **[Adaptation point 2]** - [Explain what to confirm]
```

**For multiple commits:**

Include additional sections:
- Commit details table
- Commit relationships
- Merged core change logic

## Key Principles

- **Focus on intent, not implementation** - Describe what and why
- **Code snippets are reference only** - Mark clearly
- **Document key decisions** - Help migration team
- **Highlight adaptation points** - Clearly mark needs
- **Keep concise** - Clear guidance, not exhaustive

## Output Path

`flow-docs/<feature-name>/03_migration/commit-log-summary/<seq>-<short-hash>-commit-log.md`

## Handoff

After generating:

"**✅ Code change summary document generated and saved to `flow-docs/<feature-name>/03_migration/commit-log-summary/<seq>-<short-hash>-commit-log.md`**"

"**Document includes change intent, scope, key logic, and migration notes**"

"**Next step: Use `/code-flow commit-migration` command to generate migration execution plan based on this summary**"
