# Topic Workflows - Decision Workspace

## Overview

This document describes the standard workflows for creating, continuing, and switching decision topics.

---

## Workflow 1: Create New Topic (With Topic)

```
User: "我要讨论项目技术栈选型"
AI: "**Processing:** 技术栈选型 → tech-stack-selection
**Creating:** decision-doc/tech-stack-selection/
**Current Context:** tech-stack-selection
Files created:
- discussion.md (blank, ready for your notes)
- decision.md (template initialized)"
```

### Steps:
1. Extract core concept from user input
2. Generate kebab-case name (see `_core/name-generation.md`)
3. Create directory: `decision-doc/<topic-name>/`
4. Initialize `discussion.md` (blank)
5. Initialize `decision.md` (from `templates/decision-madr.md`)
6. Create `.context-marker`
7. Set as active context

---

## Workflow 2: First Call Without Topic → Reject

```
User: "我要做个决定"
AI: "I need more information. Please provide a topic, such as:
- 项目技术栈选型
- 团队招聘决策
- 优先级排序"
```

---

## Workflow 3: Continue Session

```
User: "继续"
AI: "**Current Context:** tech-stack-selection (continuing session)
Working in: decision-doc/tech-stack-selection/
What would you like to work on?"
```

### Prerequisite:
- Active context must exist in current session

---

## Workflow 4: Switch Topic (Menu)

```
User: "切换主题"
AI: "（显示交互式菜单，用户选择 [2]）
**Context Switch:** tech-stack-selection → hiring-decision"
```

---

## Menu Display Rules

| User Input | Has Context | Action |
|------------|-------------|--------|
| Specific topic (e.g., "讨论项目对齐") | Any | Skip menu → Create/switch to topic directly |
| "continue" / "继续" | Yes | Skip menu → Continue current context |
| "continue" / "继续" | No | Show menu (no context to continue) |
| No specific intent (e.g., "我要做决定") | Any | Show menu |
| "switch" / "切换" / "切换主题" | Any | Show menu |
