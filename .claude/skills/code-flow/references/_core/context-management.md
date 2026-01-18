# Context Management - Document Context Guide

## Purpose

Define how the code-flow skill manages document context (`<feature-name>`) across all sub-skills to ensure consistent document organization.

## Core Concept

The skill maintains a **current document context** to ensure all documents belong to the same feature during a session.

## Context Determination Rules {#context-rules}

### Priority Order

1. **User explicitly specifies** → Switch to specified context
2. **Relative path reference** → Use current context (must exist)
3. **No context information** → Keep current context
4. **No context exists** → Ask user

### When to Ask User

Prompt: "Which feature/context should I work with? Please provide `<feature-name>` or path to existing document."

**In these scenarios:**
- First sub-skill invocation in session
- User input is ambiguous (could match multiple features)
- No context can be determined from input

## Context Switching

### When User Explicitly Specifies `<feature-name>`

1. **Discard current context**
2. **Switch to specified context**
3. **Initialize if not exists:**
   ```bash
   mkdir -p flow-docs/<feature-name>/{01_dev/{code_insight,feature_design,impl_plan,code_review},02_memories,03_migration/{commit-log-summary,migration-plan}}
   ```

### When User Uses Relative Paths Without Explicit Context

- Use current context
- Error if no current context exists
- Ask: "No current context. Please specify `<feature-name>` or provide absolute path."

## Explicit Specification Patterns

**User input contains these patterns = explicit context specification:**

```markdown
1. Direct feature-name mention:
   - "为 [feature-name] 编写..." (Write for [feature-name]...)
   - "[feature-name] 的实现计划" ([feature-name] implementation plan)
   - "在 [feature-name] 功能中..." (In [feature-name] feature...)

2. Absolute path reference:
   - "读取 flow-docs/<feature-name>/..."
   - "打开 flow-docs/*/01_dev/feature_design/..."
```

## Context Propagation {#context-propagation}

**Sub-skills inherit context automatically:**

- `code-insight` → Sets initial context from exploration
- `feature-design` → Inherits from code-insight or user input
- `writing-plans` → Inherits from feature-design or user input
- `executing-plans` → Inherits from plan document path
- `code-review` → Inherits from executing-plans or user input

## Context Output Format

### When Switching Context

```markdown
**Context Switch:** "scene-creation" → "user-management"

All subsequent documents will be saved to:
flow-docs/user-management/
```

### When Confirming Context

```markdown
**Current Context:** user-management

Working directory: flow-docs/user-management/
```

## Special Cases

### Extracting Context from Document Path

**For executing-plans and commit-migration:**

Parse document path to extract context:
- Pattern: `flow-docs/<feature-name>/01_dev/impl_plan/<seq>-plan-YYYY-MM-DD.md`
- Pattern: `flow-docs/<feature-name>/03_migration/migration-plan/<seq>-<hash>-migration-plan.md`

**Example:**
```
Plan document: flow-docs/scene-creation/01_dev/impl_plan/001-plan-2024-01-15.md
→ Extract: feature-name = "scene-creation"
→ Switch context to "scene-creation"
→ Output: "**Current Context:** scene-creation (from plan document)"
```

### Context Validation

**When context is extracted from path:**
- Ensure all task file paths belong to the same context
- Warn if task paths reference different `<feature-name>`

## UTF-8 Encoding Reminder {#utf8-encoding}

**CRITICAL:** Always generate documentation in the USER'S LANGUAGE with UTF-8 encoding:
- Detect user language from request
- Generate all documentation content (descriptions, comments) in that language
- Keep technical terms and code identifiers in original form (English)
- Ensure UTF-8 encoding to prevent character corruption

## Handoff

After context is determined or switched, output the appropriate message and proceed with the sub-skill's main workflow.
