# Commit Change Log - Code Change Summary Generator

## Purpose

Generate code change summary documents from git commits. Focus on **what changed** and **why**, not exact implementation. Document intent and logic for migration to other projects.

## When to Use

- Need to migrate code changes to other projects
- Need to record commit intent and scope

## Trigger Keywords

> **Complete keyword list:** See `references/_core/trigger-keywords.md` for complete keyword list and routing logic.

**Common phrases that trigger this sub-skill:**
- "summarize commits"
- "analyze commit"
- "generate change log"
- "commit summary"

## Context Determination

Follow context management rules: See `context-management.md`

**Quick reference:**
1. Check if user explicitly specified `<feature-name>`
2. If not, use current context from conversation
3. If no context, ask user to specify

## Announcement

Start with: "I'm using the commit-change-log sub-skill to generate code change summary documents. Please provide commit hash..."

## Sequence Determination

See `SKILL.md#seq-rules` for sequence number rules: Auto-increment based on existing files in target directory.

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

### Step 3: Generate Document

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
