# Code Cock Menu Structure

## Purpose

Define the interactive menu displayed when users invoke `/code-cock` without specific intent.

---

## Main Menu

Display this menu when user intent is unclear:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Code Cock - CLAUDE.md Generator & Maintainer (v0.2.0)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Available Operations:

  [1] generate           - Generate CLAUDE.md for new or existing projects
                          Parameters: --new (clean slate) / --legacy (retrofit)
                          Example: "generate --new" or "generate --legacy"

  [2] refresh            - Sync CLAUDE.md with current project structure
                          Preserves existing structure and writing style
                          Example: "refresh CLAUDE.md"

  [3] analyze            - Analyze and optimize CLAUDE.md quality
                          Parameters: --fix (apply improvements automatically)
                          Example: "analyze" or "analyze --fix"

  [4] tech-rule          - Generate technical guidance rules
                          Parameters: <tech-point> (e.g., "React Hooks")
                          Example: "tech-rule React Hooks"

  [5] validate           - Validate CLAUDE.md against project state
                          Checks consistency and validity
                          Example: "validate CLAUDE.md"

Quick Workflows:
  • New Project:     [1] → [5]
  • Existing:        [1] (legacy mode) → [2] → [5]
  • Maintenance:     [3] → [2] → [5]
  • Add Rule:        [4] → [2] → [5]

────────────────────────────────────────────────────────────────────────────────

What would you like to do?

  • Enter number [1-5] to select operation
  • Describe your task (e.g., "generate CLAUDE.md for my React project")
  • Use parameters directly (e.g., "analyze --fix")
  • Type "help" for detailed documentation

────────────────────────────────────────────────────────────────────────────────
```

---

## Input Handling Rules

### Number Input
Route to corresponding operation when user enters [1-5].

### Descriptive Task
Match to appropriate operation using trigger keywords from `trigger-keywords.md`.

### Unclear Input
Ask follow-up question to clarify intent.

---

## Skip Menu Display

Do NOT show menu when user's intent is clear from input:

| User Input | Action |
|------------|--------|
| `/code-cock generate CLAUDE.md` | Skip menu, invoke generate |
| `/code-cock refresh` | Skip menu, invoke refresh |
| `/code-cock` or `/code-cock help` | Show menu |

---

## Handoff

When displaying menu:
1. Route to operation based on user input type
2. Use trigger keywords for descriptive input matching
3. Ask clarifying questions for ambiguous input
4. Skip menu when intent is explicitly clear
