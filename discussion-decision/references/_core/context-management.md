# Context Management - Decision Workspace

## Purpose

Define how the skill maintains topic context across session interactions.

## Context Storage

### File-Based Storage
- **Location:** `decision-doc/<topic-name>/.context-marker`
- **Format:** Plain text key-value
- **Purpose:** Persistent context across sessions

### In-Memory Storage
- **Scope:** Current AI session
- **Purpose:** Fast context access during conversation

## Context Rules (Priority Order)

| Priority | Condition | Action |
|----------|-----------|--------|
| 1 | User explicitly specifies topic | Switch to specified context |
| 2 | Relative path reference | Use current context (must exist) |
| 3 | No context information | Keep current context |
| 4 | No context exists | Show menu or ask user |

## Context Switching

### Explicit Switch
```
User: "切换到 tech-stack-selection"
→ Discard current context
→ Switch to "tech-stack-selection"
→ If not exists: "Topic not found. Create it? [y/N]"
→ Output: "**Context Switch:** ... → ..."
```

### No Context
```
→ Scan decision-doc/ for available topics
→ If topics exist: Show menu
→ If no topics: "请提供决策主题"
```

## Output Format

### Context Switch
```markdown
**Context Switch:** "old-topic" → "new-topic"

Working directory: decision-doc/new-topic/
```

### Context Confirmation
```markdown
**Current Context:** topic-name

Files:
- discussion.md (blank)
- decision.md (initialized)
```
