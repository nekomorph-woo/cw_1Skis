# Trigger Keywords - Unified Trigger Keyword Management

## Purpose

Define trigger keywords for all sub-skills to ensure format consistency and maintainability. This document serves as the single source of truth for keyword-based routing.

---

## Keyword Format Specification

**Format Requirements:**
- Each keyword is a lowercase English phrase
- Supports bilingual triggers (Chinese | English), separated by `|`
- Wrap complete phrases in quotes
- Separate multiple keywords with commas

**Example:**
```yaml
code-insight:
  - "explore code"
  - "how is this implemented"
  - "understand existing code|理解现有代码"
  - "trace call chain"
```

---

## Sub-Skill Trigger Keywords Table

| Sub-Skill | Trigger Keywords | Description |
|-----------|-----------------|-------------|
| `code-insight` | `"explore code"`, `"how is this implemented"`, `"understand existing code"`, `"trace call chain"`, `"analyze code structure"`, `"find where X is implemented"`, `"document existing implementation"` | Code exploration and analysis |
| `feature-design` | `"design feature"`, `"create design doc"`, `"technical approach"`, `"API design"`, `"design new functionality"`, `"feature specification"` | Feature design and specification |
| `writing-plans` | `"create plan"`, `"write implementation plan"`, `"generate fix plan"`, `"break down tasks"`, `"convert design to plan"`, `"create actionable tasks"` | Implementation plan creation |
| `executing-plans` | `"execute plan"`, `"implement this plan"`, `"run implementation"`, `"follow the plan"`, `"complete the tasks"`, `"step by step execution"` | Plan execution |
| `code-review` | `"review code"`, `"code review"`, `"check for issues"`, `"analyze issues"`, "check for bugs", `"find security issues"` | Code review and analysis |
| `save-context` | `"save context"`, `"save session"`, `"save progress"`, `"checkpoint state"` | Session context saving |
| `commit-change-log` | `"summarize commits"`, `"analyze commit"`, `"generate change log"`, `"commit summary"` | Git commit summarization |
| `commit-migration` | `"create migration plan"`, `"migrate changes"`, `"generate migration"`, `"port changes"` | Migration plan creation |
| `git-commit` | `"commit"`, `"commit changes"`, `"git commit"`, `"create commit message"` | Git commit message generation |

---

## Keyword Matching Priority

When processing user input:

1. **Exact Match**: Complete phrase matches exactly
2. **Partial Match**: Keyword exists as a substring of user input
3. **Fuzzy Match**: Considered a match when edit distance <= 2
4. **No Match**: Ask user for clarification

---

## Routing Decision Tree

```
User Input
    │
    ├─ Is it a number? (1-9)
    │   └─ YES → Route to corresponding sub-skill from selection menu
    │
    ├─ Matches trigger keyword?
    │   └─ YES → Route to matched sub-skill
    │
    ├─ Is "workflows"?
    │   └─ YES → Display detailed workflow examples
    │
    ├─ Is "help"?
    │   └─ YES → Display selection menu
    │
    └─ NO match found
        └─ Ask user for clarification
```

---

## Manual Sub-Skill Invocation

Users can also directly specify sub-skill names:

```bash
/code-flow code-insight
/code-flow feature-design
/code-flow writing-plans
/code-flow writing-plans --fix-for <review-doc>
/code-flow executing-plans
/code-flow code-review
/code-flow save-context
/code-flow commit-change-log <commit-hash>
/code-flow commit-migration <summary-doc-path>
/code-flow git-commit
```

---

## Bilingual Support

Keywords support Chinese and English triggers:

| English | Chinese | Mapped Sub-Skill |
|---------|---------|------------------|
| "explore code" | "探索代码" | code-insight |
| "design feature" | "设计功能" | feature-design |
| "create plan" | "创建计划" | writing-plans |
| "execute plan" | "执行计划" | executing-plans |
| "review code" | "审查代码" | code-review |
| "save context" | "保存上下文" | save-context |
| "summarize commits" | "总结提交" | commit-change-log |
| "migrate changes" | "迁移变更" | commit-migration |
| "commit" | "提交" | git-commit |

---

## Maintenance Rules

1. **When adding keywords:**
   - Update this document
   - Update SKILL.md Triggers column
   - Update individual sub-skill documents

2. **When modifying keywords:**
   - Update all references simultaneously
   - Ensure consistency across all documents

3. **When removing keywords:**
   - Verify no dependencies exist
   - Update all references

---

## Language Convention

All documentation, comments, and commit messages use **<user's language>** with UTF-8 encoding. Technical terms and code identifiers remain in their original form.

## Handoff

All sub-skill documents should reference this document in their "Trigger Keywords" section:

> See `trigger-keywords.md` for complete keyword list and routing logic.
