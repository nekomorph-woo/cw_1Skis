# Code Cock - CLAUDE.md Generator & Maintainer

---
name: code-cock
description: This skill should be used when the user asks to "generate CLAUDE.md", "create project documentation", "refresh CLAUDE.md", "analyze project guide", "validate documentation", or "generate technical rule". Automatically detects technology stacks and applies Vibe Coding principles for project guidance maintenance.
version: 0.3.0
changelog: CHANGELOG.md
author: claude-code
---

## Purpose

Generate, maintain, and optimize `CLAUDE.md` project guidance documents. Automatically detect technology stacks, apply Vibe Coding principles, and keep documentation synchronized with codebase evolution.

## Skill Selection Menu

When user invokes `/code-cock` without specific intent, display the interactive menu defined in `references/_core/menu-structure.md`.

**Menu Display Rules:**
- Show menu when intent is unclear (e.g., `/code-cock`, `/code-cock help`)
- Skip menu when intent is explicit (e.g., `/code-cock generate`, `/code-cock refresh`)
- Route to operation based on user input (number, description, or parameters)

## Core Concepts

### Technology Stack Auto-Detection {#tech-stack-detection}

The skill automatically detects project technology stack by scanning:
- Dependency files (`package.json`, `pom.xml`, `build.gradle`, `go.mod`, `pubspec.yaml`, etc.)
- Directory structure patterns (`src/main/java`, `src/components`, `app/`, etc.)
- Characteristic files (`@SpringBootApplication`, `App.vue`, `Cargo.toml`, etc.)

**Detection results** serve to:
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

For detailed implementation guidance of each operation, refer to `references/_core/operations-guide.md`.

**Operation Summary:**

| Operation | Purpose | Triggers | Parameters | Output | Guide |
|-----------|---------|----------|------------|--------|-------|
| `generate` | Generate CLAUDE.md for projects | See `trigger-keywords.md` | `--new` / `--legacy` | `CLAUDE.md` | `lyra-protocol.md` |
| `refresh` | Sync CLAUDE.md with project state | See `trigger-keywords.md` | none | Updated `CLAUDE.md` | (inline logic) |
| `analyze` | Analyze quality and suggest improvements | See `trigger-keywords.md` | `--fix` | Analysis report | (inline logic) |
| `tech-rule` | Generate technical rule documents | See `trigger-keywords.md` | `<tech-point>` | `cock-docs/tech-guidance/*.md` | `tech-rule-template.md` |
| `validate` | Validate CLAUDE.md consistency | See `trigger-keywords.md` | none | Validation report | (inline logic) |

## Quick Workflows

For common scenarios and recommended workflows, see `operations-guide.md#ops-workflows`.

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
│   ├── tech-rule-template.md   # Tech rule document template
│   ├── menu-structure.md       # Interactive menu and routing
│   └── operations-guide.md     # Detailed operation guide
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

**Use `--new` when:**
- Starting a fresh project
- No existing codebase constraints
- Establishing best practices from day one

**Use `--legacy` when:**
- Existing codebase needs documentation
- Understanding current patterns before prescribing
- Progressive evolution approach preferred

### analyze vs validate

**Use `analyze` when:**
- Improving CLAUDE.md quality
- Suspecting outdated or redundant content
- Comprehensive review needed

**Use `validate` when:**
- Quick consistency check required
- Verifying documentation matches reality
- Before starting new work session

## Language Convention

Generate all documentation using **English** for:
- `CLAUDE.md` content
- Technical rule documents
- Code comments and documentation

Keep technical terms and code identifiers in original form.

---

## Version Information

**Current Version:** 0.3.0

**Changelog:** See [CHANGELOG.md](CHANGELOG.md) for complete version history and changes.

**Stability Status:** Pre-1.0 development - minor versions may include breaking changes. Always review changelog before updating.

---

**Remember:** CLAUDE.md is a living document. Keep it synchronized with the codebase through regular `refresh` and `analyze` operations.
