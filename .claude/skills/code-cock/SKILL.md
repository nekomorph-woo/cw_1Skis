# Code Cock - CLAUDE.md Generator & Maintainer

---
name: code-cock
description: CLAUDE.md generation and maintenance skill for project guidance documentation. Generate, refresh, analyze, and validate project documentation with intelligent tech stack detection.
version: 0.2.0
changelog: CHANGELOG.md
author: claude-code
---

## Purpose

Generate, maintain, and optimize `CLAUDE.md` project guidance documents. Automatically detect technology stacks, apply Vibe Coding principles, and keep documentation synchronized with codebase evolution.

## Skill Selection Menu

**When user invokes `/code-cock` without specific intent:**

Display this menu to help user select the appropriate operation:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Code Cock - CLAUDE.md Generator & Maintainer (v0.1.0)
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

**User Input Handling:**

- If user enters **number** → Route to corresponding operation
- If user **describes task** → Match to appropriate operation using trigger keywords
- If user input is **unclear** → Ask follow-up question to clarify intent

**Skip Menu Display:**

Do NOT show this menu when user's intent is already clear from their input:
- User: `/code-cock generate CLAUDE.md` → Skip menu, directly invoke generate
- User: `/code-cock refresh` → Skip menu, directly invoke refresh
- User: `/code-cock` or `/code-cock help` → Show menu above

## Core Concepts

### Technology Stack Auto-Detection {#tech-stack-detection}

The skill automatically detects project technology stack by scanning:
- Dependency files (`package.json`, `pom.xml`, `build.gradle`, `go.mod`, `pubspec.yaml`, etc.)
- Directory structure patterns (`src/main/java`, `src/components`, `app/`, etc.)
- Characteristic files (`@SpringBootApplication`, `App.vue`, `Cargo.toml`, etc.)

**Detection results** are used to:
- Generate appropriate Knowledge Base tables
- Suggest relevant `tech-guidance` files
- Configure Context Switch Rules (Mode A/B/C)
- Fill technology-specific coding standards

### Lyra Generation Protocol {#lyra-protocol}

The CLAUDE.md generation follows a three-phase protocol:

**Phase 1: Progressive Information Collection**
- Ask one question at a time with multiple choice options
- Detect tech stack automatically, ask for confirmation
- Gather project type (new/legacy), testing strategy, personalization

**Phase 2: Architecture Detection**
- Determine topology: Single-Stack vs Multi-Stack
- Single-Stack: Unified mode, deep workflow focus
- Multi-Stack: Mode 0 (Inception) + Mode A (Backend) + Mode B (Frontend) + Bridge mode

**Phase 3: Template Generation**
- Use `claude-template.md` as base
- Dynamically fill sections based on detected stack
- Generate `cock-docs/tech-guidance` suggestions

See `references/_core/lyra-protocol.md` for detailed protocol.

### Document State Management

The skill maintains awareness of existing `CLAUDE.md` state:
- **No CLAUDE.md exists** → Trigger `generate` operation
- **CLAUDE.md exists** → Check if refresh needed, offer `refresh` or `analyze`
- **Stale detection** → Compare document dates with file tree changes

## Operations

| Operation | Purpose | Triggers | Parameters | Output | Guide |
|-----------|---------|----------|------------|--------|-------|
| `generate` | Generate CLAUDE.md for projects | See `trigger-keywords.md` | `--new` / `--legacy` | `CLAUDE.md` | `lyra-protocol.md` |
| `refresh` | Sync CLAUDE.md with project state | See `trigger-keywords.md` | none | Updated `CLAUDE.md` | (inline logic) |
| `analyze` | Analyze quality and suggest improvements | See `trigger-keywords.md` | `--fix` | Analysis report | (inline logic) |
| `tech-rule` | Generate technical rule documents | See `trigger-keywords.md` | `<tech-point>` | `cock-docs/tech-guidance/*.md` | `tech-rule-template.md` |
| `validate` | Validate CLAUDE.md consistency | See `trigger-keywords.md` | none | Validation report | (inline logic) |

## Operation Details

### generate

Generate a new `CLAUDE.md` for the project.

**Modes:**
- `--new`: New project from scratch (clean slate Vibe Coding)
- `--legacy`: Existing codebase retrofit (progressive evolution approach)

**Process:**
1. Scan project structure and dependencies
2. Detect technology stack
3. Follow Lyra Protocol (Phase 1 → Phase 2 → Phase 3)
4. Generate `CLAUDE.md` at project root
5. Suggest `cock-docs/tech-guidance` files to create

**Output:** `CLAUDE.md` with Vibe Coding principles, Context Switch Rules, Knowledge Base Indexing, and technology-specific standards.

**Post-Operation Guidance:**
After generating `CLAUDE.md`, you should:
1. Run `validate` to verify the document is correct
2. Review the generated content and adjust if needed
3. Consider generating `tech-rule` documents for specific technology areas

**Completion Summary:**
```
✓ CLAUDE.md generated successfully at project root

Recommended next steps:
  • Run "/code-cock validate" to verify document consistency
  • Review the generated CLAUDE.md and request adjustments if needed
  • Use "/code-cock tech-rule <topic>" to add specific technical guidance
```

### refresh

Synchronize existing `CLAUDE.md` with current project state.

**Check Dimensions:**
- Project structure changes (new directories, removed files)
- Dependency updates (version changes in manifest files)
- New/removed `cock-docs/tech-guidance` files
- Code pattern drift (actual code vs documentation description)

**Process:**
1. Read existing `CLAUDE.md`
2. Scan current project state
3. Compare and identify differences
4. Present changes for confirmation
5. Apply updates

**Structure Stability Constraints:**
- **Preserve existing document structure** - Keep section order and hierarchy
- **Maintain writing style** - Use similar tone, phrasing, and level of detail
- **Concise updates only** - Modify only what actually changed, don't rewrite stable sections
- **Incremental changes** - Apply minimal diffs rather than full rewrites
- **Ask before major changes** - If a section requires significant restructuring, confirm with user first

**Post-Operation Guidance:**
After refreshing `CLAUDE.md`, you should:
1. Run `validate` to ensure the updates are consistent
2. Run `analyze` if you want to check for further quality improvements

**Completion Summary:**
```
✓ CLAUDE.md refreshed with current project state

Recommended next steps:
  • Run "/code-cock validate" to verify consistency
  • Run "/code-cock analyze" to check for quality improvements
```

### analyze

Analyze `CLAUDE.md` quality and suggest improvements.

**Analysis Dimensions:**
- Outdated rules (tech stack version mismatches)
- Redundant descriptions (duplicate or contradictory content)
- Missing rules (critical constraints not covered)
- Vague instructions (soft "should" statements without enforcement)

**Process:**
1. Parse `CLAUDE.md` sections
2. Check against detected tech stack
3. Identify issues with severity (P0-P3)
4. Generate improvement suggestions

**With `--fix`:** Apply improvements automatically after confirmation.

**Post-Operation Guidance:**
After analyzing `CLAUDE.md`, you should:
1. Review the analysis report and identified issues
2. Decide whether to apply fixes manually or use `analyze --fix`
3. Run `refresh` to sync with any structural changes after fixes
4. Run `validate` to verify the improved document

**Completion Summary:**
```
✓ Analysis complete - [X] issues found (P0: [n], P1: [n], P2: [n], P3: [n])

Recommended next steps:
  • Review issues and decide on fixes
  • Use "/code-cock analyze --fix" to apply improvements automatically
  • Run "/code-cock refresh" to sync with current state
  • Run "/code-cock validate" to verify improvements
```

### tech-rule

Generate a technical guidance rule document for a specific technology point.

**Parameters:**
- `<tech-point>`: Technology area (e.g., "React Hooks", "EDT Threading", "Coroutines")
- Auto-detected from context if not specified

**Process:**
1. Use `tech-rule-template.md` as base
2. Fill technology-specific constraints
3. Generate Mapping Rules table (Forbidden vs Required)
4. Add Critical Snippets with code examples
5. Include Verification checklist
6. Auto-trigger `refresh` to update `CLAUDE.md` Knowledge Base

**Output:** `cock-docs/tech-guidance/<tech-point>-rules.md`

**Post-Operation Guidance:**
After generating a tech rule document, you should:
1. Run `refresh` to update the Knowledge Base table in `CLAUDE.md`
2. Run `validate` to verify the new reference is correctly linked

**Completion Summary:**
```
✓ Technical rule document created: cock-docs/tech-guidance/<tech-point>-rules.md

Recommended next steps:
  • Run "/code-cock refresh" to update CLAUDE.md Knowledge Base
  • Run "/code-cock validate" to verify the reference is correctly linked
```

### validate

Validate `CLAUDE.md` consistency against project state.

**Validation Checks:**
- All `tech-guidance` files referenced exist
- Project structure matches Architecture Map
- Mode file extensions actually present in codebase
- Commit message format matches examples

**Output:** Validation report with pass/fail status and action items.

**Post-Operation Guidance:**
After validating `CLAUDE.md`:
- **If validation passed**: Document is consistent, you can proceed with development
- **If validation failed**: Review the report and take recommended actions:
  - Fix broken references by running `refresh`
  - Add missing `tech-guidance` files using `tech-rule`
  - Update document structure manually if needed

**Completion Summary (Pass):**
```
✓ Validation passed - CLAUDE.md is consistent with project state

No action required. You can proceed with development.
```

**Completion Summary (Fail):**
```
✗ Validation failed - [n] issues found

Issues:
  • [Issue 1 description]
  • [Issue 2 description]

Recommended actions:
  • Run "/code-cock refresh" to fix broken references
  • Use "/code-cock tech-rule <topic>" to add missing guidance
  • Manually fix structural issues if suggested
```

## Quick Workflows

| Scenario | Workflow |
|----------|----------|
| New Project | `generate --new` → `validate` |
| Existing Project | `generate --legacy` → `refresh` → `validate` |
| Regular Maintenance | `analyze` → `refresh` → `validate` |
| Add Tech Rule | `tech-rule <point>` → `refresh` → `validate` |
| Before Major Work | `validate` → (fix issues if any) |

## Technology Stack Support {#tech-stack-support}

**Supported Technology Categories:**

| Category | Technologies |
|----------|--------------|
| Backend | Java/Spring Boot, Node/Express, Python/Django, Python/FastAPI, Go/Gin |
| Frontend | React, Vue, Angular, Next.js, Nuxt.js |
| Mobile | React Native, Flutter |
| JVM Languages | Kotlin, Java |
| Systems | Rust, Go |
| Scripting | Python, TypeScript, JavaScript |

**Detection Signals:** See `references/README.md` for detailed detection patterns.

## Reference Files Structure

```
references/
├── _core/                      # Universal templates
│   ├── anchors.md              # Cross-document anchor definitions
│   ├── trigger-keywords.md    # Operation trigger keywords
│   ├── lyra-protocol.md        # CLAUDE.md generation protocol
│   ├── claude-template.md      # CLAUDE.md base template
│   └── tech-rule-template.md   # Tech rule document template
├── tech-stacks/                # Technology-specific guides
│   ├── kotlin-jvm.md           # Kotlin/JVM patterns
│   ├── react.md                # React patterns
│   ├── vue.md                  # Vue patterns
│   ├── go.md                   # Go patterns
│   ├── rust.md                 # Rust patterns
│   └── python.md               # Python patterns
└── examples/                   # Example CLAUDE.md files
    └── claude-bk-example.md    # Complete example
```

## Decision Guide

### generate --new vs --legacy

Use `--new` when:
- Starting a fresh project
- No existing codebase constraints
- Want to establish best practices from day one

Use `--legacy` when:
- Existing codebase needs documentation
- Need to understand current patterns before prescribing
- Want progressive evolution approach

### analyze vs validate

Use `analyze` when:
- Want to improve CLAUDE.md quality
- Suspect outdated or redundant content
- Need comprehensive review

Use `validate` when:
- Quick consistency check
- Verify documentation matches reality
- Before starting new work session

## Language Convention

All generated documentation uses **English** for:
- `CLAUDE.md` content
- Technical rule documents
- Code comments and documentation

Technical terms and code identifiers remain in original form.

---

## Version Information

**Current Version:** 0.1.0

**Changelog:** See [CHANGELOG.md](CHANGELOG.md) for complete version history and changes.

**Stability Status:** Pre-1.0 development - minor versions may include breaking changes. Always review changelog before updating.

---

**Remember:** CLAUDE.md is a living document. Keep it synchronized with your codebase through regular `refresh` and `analyze` operations.
