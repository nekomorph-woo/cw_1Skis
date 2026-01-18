# Document Anchor Definitions

## Purpose

Define standard anchor references for cross-document linking within the code-flow skill. This serves as the single source of truth for all anchor IDs.

## Why Anchors

- **Stability**: Anchors don't break when lines are added/removed
- **Clarity**: Descriptive anchor names are self-documenting
- **Maintainability**: Single place to define all cross-reference points

---

## Anchor Mapping Table

### Core Reference Documents

| Document | Section | Anchor ID | Usage Example |
|----------|---------|-----------|---------------|
| `SKILL.md` | Document Paths (序列号规则) | `seq-rules` | `SKILL.md#seq-rules` |
| `SKILL.md` | Technology Stack Adaptation | `tech-stack` | `SKILL.md#tech-stack` |
| `SKILL.md` | Error Recovery & Edge Cases | `error-recovery` | `SKILL.md#error-recovery` |

### Sub-Skill Guides

| Document | Section | Anchor ID | Usage Example |
|----------|---------|-----------|---------------|
| `executing-plans.md` | Step 3.5: Check Task Completion Status | `check-completion` | `executing-plans.md#check-completion` |
| `executing-plans.md` | Step 4: Execute Tasks Sequentially | `execute-tasks` | `executing-plans.md#execute-tasks` |
| `executing-plans.md` | Step 5: Handle Code Review Issues | `code-review-issues` | `executing-plans.md#code-review-issues` |
| `executing-plans.md` | Code Execution Rules | `code-execution` | `executing-plans.md#code-execution` |
| `git-commit.md` | 4. Execute Commit | `execute-commit` | `git-commit.md#execute-commit` |
| `git-commit.md` | Commit Types & Emojis | `commit-types` | `git-commit.md#commit-types` |
| `code-review.md` | Problem Categories | `problem-categories` | `code-review.md#problem-categories` |
| `code-review.md` | What to Review | `what-to-review` | `code-review.md#what-to-review` |
| `code-review.md` | Compilation Check (P0) | `compilation-check` | `code-review.md#compilation-check` |

### Core Templates

| Document | Section | Anchor ID | Usage Example |
|----------|---------|-----------|---------------|
| `context-management.md` | UTF-8 Encoding Reminder | `utf8-encoding` | `context-management.md#utf8-encoding` |
| `context-management.md` | Context Determination Rules | `context-rules` | `context-management.md#context-rules` |
| `context-management.md` | Context Propagation | `context-propagation` | `context-management.md#context-propagation` |
| `writing-plans.md` | Technology-Specific Commands | `tech-commands` | `writing-plans.md#tech-commands` |
| `writing-plans.md` | Task Structure | `task-structure` | `writing-plans.md#task-structure` |
| `writing-plans.md` | Fix Plan Mode | `fix-plan-mode` | `writing-plans.md#fix-plan-mode` |
| `commit-migration.md` | Migration Context | `migration-context` | `commit-migration.md#migration-context` |
| `commit-migration.md` | Task Structure | `migration-task-structure` | `commit-migration.md#migration-task-structure` |
| `commit-migration.md` | Backend Syntax Comparison | `backend-syntax` | `commit-migration.md#backend-syntax` |
| `commit-migration.md` | Frontend Syntax Comparison | `frontend-syntax` | `commit-migration.md#frontend-syntax` |

---

## Anchor Naming Convention

**Format:** `{section-purpose}` or `{step-number}-{purpose}`

**Examples:**
- `seq-rules` (sequence number rules)
- `check-completion` (check task completion)
- `utf8-encoding` (UTF-8 encoding)
- `execute-commit` (execute commit step)
- `problem-categories` (problem categories)

**Rules:**
- Use lowercase
- Use hyphens to separate words
- Be descriptive but concise
- Avoid numbers at the start (except for step prefixes like `step-`)

---

## How to Use Anchors

### In Markdown Documents

```markdown
<!-- Define anchor in heading -->
## Document Paths {#seq-rules}

<!-- Reference from other documents -->
See `SKILL.md#seq-rules` for sequence number rules.
```

### In Text References

```markdown
<!-- Before (line-based) -->
See `SKILL.md:130` for sequence number rules.

<!-- After (anchor-based) -->
See `SKILL.md#seq-rules` for sequence number rules.
```

### For Sub-Sections

```markdown
<!-- Define anchor -->
#### Code review {#code-review-issues}

<!-- Reference -->
See `executing-plans.md#code-review-issues` for P0 handling flow.
```

---

## Adding New Anchors

1. **Choose a descriptive name** following the naming convention
2. **Add to this table** in the appropriate section
3. **Add `{#anchor-id}` to the heading** in the target document
4. **Update all references** to use the new anchor

---

## Migration Log

| Date | Change | Files Affected |
|------|--------|----------------|
| 2025-01-18 | Initial anchor system creation | All cross-references |

---

## Handoff

When adding cross-references:
1. Check this table first for existing anchors
2. If no anchor exists, add one following the convention
3. Update this table as the single source of truth
4. Never use line-based references (`file.md:123`) in new content
