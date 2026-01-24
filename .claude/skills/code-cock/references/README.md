# Code Cock Reference Documentation

This directory contains reference documents for the code-cock skill. These documents serve as templates, protocols, and technology-specific guides for CLAUDE.md generation and maintenance.

## Directory Structure

```
references/
├── _core/                      # Universal templates (always use these)
│   ├── anchors.md              # Cross-document anchor definitions
│   ├── trigger-keywords.md    # Operation trigger keyword management
│   ├── lyra-protocol.md        # CLAUDE.md generation protocol
│   ├── claude-template.md      # CLAUDE.md base template
│   ├── tech-rule-template.md   # Technical rule document template
│   ├── menu-structure.md       # Interactive menu display and routing
│   └── operations-guide.md     # Detailed operation implementation guide
├── tech-stacks/                # Technology-specific guidance
│   ├── kotlin-jvm.md           # Kotlin/JVM patterns and constraints
│   ├── react.md                # React patterns and constraints
│   ├── vue.md                  # Vue patterns and constraints
│   ├── go.md                   # Go patterns and constraints
│   ├── rust.md                 # Rust patterns and constraints
│   └── python.md               # Python patterns and constraints
└── examples/                   # Example CLAUDE.md documents
    └── claude-bk-example.md    # Complete CLAUDE.md example
```

> **Note:** The `_core/` directory contains universal reference documents used across all operations:
> - `anchors.md` - Single source of truth for cross-document anchor definitions
> - `trigger-keywords.md` - Single source of truth for operation trigger keywords
> - `lyra-protocol.md` - Complete CLAUDE.md generation protocol
> - `claude-template.md` - Base template for all generated CLAUDE.md files
> - `tech-rule-template.md` - Template for technical rule documents

---

## Technology Stack Detection

When using code-cock, the skill automatically detects your project's technology stack and references the appropriate guide.

### Backend Detection

| Technology | Detection Signals |
|------------|-------------------|
| Java/Spring Boot | `pom.xml`, `build.gradle`, `@SpringBootApplication` |
| Node.js/Express | `package.json` with express, `server.js` or `app.js` |
| Python/Django | `manage.py`, `settings.py`, `requirements.txt` with Django |
| Python/FastAPI | `main.py` with FastAPI, pydantic models |
| Go/Gin | `go.mod`, `main.go` with gin framework |

### Frontend Detection

| Technology | Detection Signals |
|------------|-------------------|
| React | `package.json` with react, `.jsx` files, `src/App.js` |
| Vue | `package.json` with vue, `.vue` files, `src/App.vue` |
| Angular | `angular.json`, `.component.ts` files |
| Next.js | `next.config.js`, `app/` or `pages/` directory |
| Nuxt.js | `nuxt.config.ts`, `pages/` directory |

### JVM Detection

| Technology | Detection Signals |
|------------|-------------------|
| Kotlin | `build.gradle.kts`, `*.kt` files |
| Java | `pom.xml`, `build.gradle`, `*.java` files |
| IntelliJ Platform | `plugin.xml`, `@NotNull` annotations |

### Systems Detection

| Technology | Detection Signals |
|------------|-------------------|
| Rust | `Cargo.toml`, `*.rs` files |
| Go | `go.mod`, `*.go` files |

### Scripting Detection

| Technology | Detection Signals |
|------------|-------------------|
| Python | `requirements.txt`, `*.py` files, `pyproject.toml` |
| TypeScript | `tsconfig.json`, `*.ts` files |
| JavaScript | `package.json` without frameworks |

---

## How to Use These Guides

1. **Core templates in `_core/` are universal** - They apply to all technologies
2. **Technology-specific guides supplement the core** - They provide language/framework-specific patterns and constraints
3. **Auto-detection** - The skill will detect your tech stack and reference the appropriate guide
4. **Manual selection** - You can also explicitly specify a technology when invoking operations

---

## Core Reference Documents

### anchors.md

Defines standard anchor references for cross-document linking within the code-cock skill. Serves as the single source of truth for all anchor IDs.

**Key Sections:**
- Anchor Mapping Table (Document → Section → Anchor ID → Usage Example)
- Anchor Naming Convention
- How to Use Anchors
- Adding New Anchors

### trigger-keywords.md

Unified trigger keyword management for all code-cock operations.

**Key Sections:**
- Operation Trigger Keywords Table
- Keyword Matching Rules
- Fuzzy Matching Patterns
- Adding New Keywords

### lyra-protocol.md

Complete protocol for generating CLAUDE.md documents. Extracted and refined from Lyra meta-prompts.

**Key Sections:**
- Phase 1: Progressive Information Collection
- Phase 2: Architecture Detection
- Phase 3: Template Generation
- Technology Stack Specifics

### claude-template.md

Base template for all generated CLAUDE.md documents. Contains standard sections with placeholder values.

**Key Sections:**
- Role & Context
- Project Overview
- Context Switch Rules
- Knowledge Base Indexing
- Vibe Coding Workflow
- Coding Standards
- Communication Style
- File Management
- Self-Verification Loop
- Commit Message Rules
- Special Content

### tech-rule-template.md

Template for generating technical rule documents in `cock-docs/tech-guidance/`.

**Key Sections:**
- Axioms (Core Principles)
- Mapping Rules (Forbidden vs Required)
- Critical Snippets (Code Patterns)
- Verification Checklist
- Integration with CLAUDE.md

### menu-structure.md

Interactive menu structure and routing rules for user input handling.

**Key Sections:**
- Main Menu Display
- Input Handling Rules
- Skip Menu Display conditions

### operations-guide.md

Detailed implementation guide for all code-cock operations.

**Key Sections:**
- Operation Details (generate, refresh, analyze, tech-rule, validate)
- Process Steps for each operation
- Post-Operation Guidance
- Completion Summary Templates
- Quick Workflows
- Decision Guide

---

## Technology-Specific Guides

Each technology-specific guide contains:

**Common Sections:**
- Technology Detection Signals
- Project Structure Patterns
- Mode Configuration (Context Switch Rules)
- Auto-Inferred Constraint Files
- Code Style Guidelines
- Common Patterns
- Testing Approach
- Quick Reference

---

## Example Documents

The `examples/` directory contains complete CLAUDE.md examples:

- **claude-bk-example.md** - A comprehensive example from the Nekoama project demonstrating all sections in action

---

## Language & Encoding

All reference documentation uses **English** with UTF-8 encoding. Technical terms and code identifiers remain in original form.

---

## Version Management

**Current Version:** See `SKILL.md` for the current version number.

**Changelog:** See `CHANGELOG.md` for complete version history and changes.

**Auto-Update:** When making significant changes to the code-cock skill:

1. Use the bump-version script to update version and changelog:
   ```bash
   # Bash/Linux/macOS
   ./scripts/bump-version.sh minor "Add new technology stack support"

   # PowerShell/Windows
   ./scripts/bump-version.ps1 minor "Add new technology stack support"
   ```

2. The script will automatically:
   - Update version number in `SKILL.md`
   - Append change record to `CHANGELOG.md`

3. Commit the changes:
   ```bash
   git add .claude/skills/code-cock/SKILL.md .claude/skills/code-cock/CHANGELOG.md
   git commit -m "docs: Release version X.Y.Z"
   ```
