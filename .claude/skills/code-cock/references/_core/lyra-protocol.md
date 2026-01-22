# Lyra Generation Protocol

## Purpose

Define the complete protocol for generating `CLAUDE.md` documents. This protocol is extracted and refined from Lyra meta-prompts, supporting both new projects and existing codebases.

**Philosophy:** "Vibe Coding" is **AI-Human Symbiosis**:
- **Human:** Strategy and Logic
- **AI:** Tactics, English Code, TDD/VDD Loops

---

## Protocol Overview

The Lyra Protocol consists of three phases:

| Phase | Purpose | Output |
|-------|---------|--------|
| Phase 1 | Progressive information collection | User preferences and project context |
| Phase 2 | Architecture detection | Topology type and Mode configuration |
| Phase 3 | Template generation | Complete `CLAUDE.md` document |

**Mode Selection:**
- `--new`: New project (clean slate, establish best practices)
- `--legacy`: Existing codebase (understand before prescribing, progressive evolution)

---

## Phase 1: Progressive Information Collection {#lyra-phase1}

**STOP & SCAN:** Do not generate CLAUDE.md immediately. Analyze the input for completeness.
If critical information is missing or ambiguous, you **MUST** ask clarifying questions.

### Principle

**🚨 CRITICAL RULE:**
- **Ask one question at a time; don't bombard the user with all your questions at once.**
- When asking, **always provide [multiple solutions or options]** to reduce user friction.

### Information Collection Order

1. **Project Name** (if not provided)
2. **Technology Stack** (auto-detect + confirm)
3. **Project Type** (new/legacy)
4. **Testing Strategy**
5. **Personalization** (how to address user)

### Question Templates

#### 1. Project Name

```
"What is your project name?"

• Enter project name (e.g., "MyAwesomeProject")
• Press Enter to use directory name: [detected-name]
```

#### 2. Technology Stack (Auto-Detect First)

**Scan for characteristic files:**
- `package.json` → Node.js ecosystem
- `pom.xml` / `build.gradle` → JVM ecosystem
- `go.mod` → Go
- `Cargo.toml` → Rust
- `requirements.txt` / `pyproject.toml` → Python
- `pubspec.yaml` → Flutter

**Confirmation prompt:**
```
"Detected technology stack: [Framework] [Language]

Is this correct?

  [1] Yes, proceed
  [2] No, let me specify
  [3] Multi-stack project"
```

**If user selects [2] - Specify:**
```
"Which technology stack are you using?

  Backend:
  [A] Java / Spring Boot    [B] Node.js / Express    [C] Python / Django
  [D] Python / FastAPI      [E] Go / Gin

  Frontend:
  [F] React                 [G] Vue                   [H] Angular
  [I] Next.js               [J] Nuxt.js

  Mobile:
  [K] React Native          [L] Flutter

  Other:
  [M] Specify custom stack"
```

#### 3. Project Type (if not determined by mode flag)

```
"Is this a new project or existing codebase?"

  [1] New Project - Clean slate, establish best practices from day one
  [2] Existing Codebase - Understand current patterns, evolve progressively
```

#### 4. Testing Strategy

```
"What is your testing approach?

  [A] Strict TDD - Test First, Then Implement (recommended for new code)
  [B] Integration Tests - Focus on end-to-end testing
  [C] Manual Testing - No automated tests (not recommended)
  [D] Legacy Retrofit - Add tests when modifying existing code"
```

#### 5. Personalization (Required)

```
"How should I address you in the documentation?

• Enter your preferred title (e.g., "Boss", "Architect", "Developer")
• Press Enter to use default: "Developer""
```

**IMPORTANT:** This value MUST be inserted into `## 6. 🤖 Communication Style` section:
```markdown
- **MUST** call user **[User Personalization title]** and Output **Current Mode** ...
```

**CONTINUE ONLY WHEN:** You have:
- [ ] Confirmed technology stack with user
- [ ] Identified project type (new/legacy)
- [ ] Understood testing strategy
- [ ] Obtained user personalization title

---

## Phase 2: Architecture Detection {#lyra-phase2}

### Purpose

Determine the **Project Topology** to configure Context Switch Rules appropriately.

### Detection Logic

**Single-Stack (Unified Mode)**
- *Scenario:* Pure Backend (Go/Java), Pure Frontend (React), or Pure Scripting
- *Action:* Collapse "Context Switching" sections. Focus on a single, deep Workflow.
- *Mode Configuration:* Single Mode with technology-specific workflow

**Multi-Stack (Hybrid/Bridge Mode)**
- *Scenario:* Full-Stack, Mobile+API, Plugin+Webview, Electron/Tauri
- *Action:* Enable "Context Switch Rules" with multiple Modes
- *Mode Configuration:*
  - Mode 0: Inception (Requirement Analysis)
  - Mode A: Backend / Core Logic
  - Mode B: Frontend / UI Layer
  - (Optional) Mode C: Bridge / Integration

### File Extension Binding

Each Mode MUST bind to specific file extensions to trigger context switching:

| Mode | Trigger File Extensions | Example |
|------|------------------------|---------|
| Mode A (Backend) | `*.kt`, `*.java`, `*.go`, `*.py`, `*.rs` | Working on backend logic |
| Mode B (Frontend) | `*.tsx`, `*.jsx`, `*.vue`, `*.svelte` | Working on UI components |
| Mode 0 (Inception) | (No extension - triggered by task type) | Planning new features |

### Topology Decision Table

| Pattern | Topology | Modes |
|---------|----------|-------|
| `src/main/java` + `src/main/resources` | Single-Stack (Backend) | Mode A only |
| `src/components` + `package.json` (react) | Single-Stack (Frontend) | Mode B only |
| `backend/` + `frontend/` directories | Multi-Stack | Mode 0 + A + B |
| `src/main/java` + `src/webview/` | Multi-Stack (Plugin) | Mode 0 + A + B |
| `ios/` + `android/` directories | Multi-Stack (Mobile) | Mode 0 + A + B |

---

## Phase 3: Template Generation {#lyra-phase3}

### Process

1. **Load Base Template** - Use `claude-template.md` as foundation
2. **Fill Detected Information** - Populate with gathered context
3. **Configure Modes** - Generate Context Switch Rules based on topology
4. **Generate Knowledge Base** - Create `cock-docs/tech-guidance` suggestions
5. **Apply Technology Constraints** - Add tech-specific rules

### Dynamic Section Generation

#### Role & Context

```markdown
## 0. 🧙‍♂️ Role & Context
You are a **Senior [Detected Language] Developer & [Specialization]**, with deep expertise in:
- [Framework 1] ([Version range])
- [Framework 2] ([Version range])
- [Key Pattern 1] (e.g., DDD, Clean Architecture)
- [Key Pattern 2] (e.g., Reactive Streams, Coroutines)
```

#### Project Overview

```markdown
## 1. 🏗️ Project Overview
**Name:** [Project Name]
**Type:** [Detected Type: REST API / SPA / Mobile App / Plugin / ...]
**Version:** [Detected from package.json / pom.xml / ...]
**Mission:** [Inferred from README or ask user]

**Architecture Map:**
[Generated tree structure based on actual project]
```

#### Context Switch Rules

**For Single-Stack:**
```markdown
## 2. 🚦 Development Workflow
[Single, deep workflow with tech-specific approach]
```

**For Multi-Stack:**
```markdown
## 2. 🚦 Context Switch Rules

### Mode 0: Inception (Requirement Analysis) ⚠️ **COPY VERBATIM**

**⚠️ IMPORTANT:** This section should be copied exactly as-is into all generated CLAUDE.md files.
[Standard Vibe Coding Inception protocol]

### Mode A: Backend / Core Logic
- **Trigger:** Working on [backend directories]
- **File Extensions:** `*.kt`, `*.java`, `*.go`, ...
- **Workflow:** [TDD approach]

### Mode B: Frontend / UI Layer
- **Trigger:** Working on [frontend directories]
- **File Extensions:** `*.tsx`, `*.jsx`, `*.vue`, ...
- **Workflow:** [VDD approach]
```

#### Knowledge Base Indexing

```markdown
## 3. 📚 Knowledge Base Indexing
**Always refer to these files first:**

### Tech Constraints (技术约束)
| File | Description |
|------|-------------|
| `cock-docs/tech-guidance/[tech]-rules.md` | [Description] |
| [Auto-generated based on detected stack] |
```

---

## Mode-Specific Guidelines {#mode-specific}

### New Project Mode {#lyra-new-mode}

**Characteristics:**
- Clean slate, no legacy constraints
- Establish best practices from day one
- Full Vibe Coding methodology (TDD for logic, VDD for UI)

**Approach:**
- Enforce strict standards from the start
- Generate comprehensive `tech-guidance` files
- Set up testing infrastructure
- Define clear architecture patterns

**CLAUDE.md Emphasis:**
- Strong coding standards section
- Comprehensive knowledge base
- Clear workflow definitions
- Self-verification loop with all checks

### Legacy Project Mode {#lyra-legacy-mode}

**Characteristics:**
- Existing codebase with established patterns
- Must understand before prescribing
- Progressive evolution over revolution

**Approach:**
- Phase 1: Forensic Analysis (scan and understand)
- Phase 2: Gap Analysis (discuss modernization strategy)
- Phase 3: Generation (hybrid workflow)

**Hybrid Workflow:**
- **For New Features:** Enforce Vibe Coding (TDD/VDD)
- **For Existing Code:** "Read-Analyze-SafeChange" workflow
  1. **Analysis:** Explain existing logic before touching it
  2. **Pinning Test:** Create test to lock down current behavior
  3. **Minimal Change:** Apply fix with caution
  4. **Verify:** Ensure no side effects

**Boy Scout Rule:** "Leave the campsite cleaner than you found it."

**CLAUDE.md Emphasis:**
- Mode L: Legacy Maintenance (The Safety Mode)
- `cock-docs/tech-guidance/legacy_patterns.md` - Document old patterns
- `cock-docs/tech-guidance/refactoring_rules.md` - Refactoring guidelines
- Stability over style for existing code

---

## Technology Stack Inference

### Auto-Inferred Constraint Files

Based on detected technology stack, suggest these `cock-docs/tech-guidance` files:

| Technology | Auto-Inferred Constraint Files |
|------------|------------------------------|
| Kotlin/JVM | `kotlin-coroutines-rules.md`, `intellij-edt-rules.md`, `kotlin-null-safety-rules.md` |
| Java/Spring | `spring-service-layer-rules.md`, `java-stream-rules.md`, `jpa-orm-rules.md` |
| React | `react-hooks-rules.md`, `react-state-management-rules.md`, `react-performance-rules.md` |
| Vue | `vue-composition-api-rules.md`, `vue-reactivity-rules.md`, `pinia-state-rules.md` |
| Go | `go-error-handling-rules.md`, `go-goroutine-rules.md`, `go-interface-rules.md` |
| Rust | `rust-ownership-rules.md`, `rust-lifetime-rules.md`, `rust-async-rules.md` |
| Python | `python-type-hinting-rules.md`, `python-asyncio-rules.md`, `python-logging-rules.md` |

### Testing Framework Mapping

| Technology | Primary Framework | Mocking | Assertions |
|------------|-------------------|---------|------------|
| Kotlin | JUnit 5 | MockK | AssertJ / Kotlin Assert |
| Java | JUnit 5 | Mockito | AssertJ |
| React | Jest | RTL | Jest Matchers |
| Vue | Vitest / Jest | Vue Test Utils | Vitest Matchers |
| Go | go test | testify | testify |
| Rust | cargo test | mockall | built-in |
| Python | pytest | unittest.mock | pytest asserts |

---

## Output Checklist

After Phase 3, verify:

- [ ] Project name correctly set
- [ ] Technology stack accurately detected and confirmed
- [ ] Architecture topology correctly identified
- [ ] Context Switch Rules configured (single or multi-stack)
- [ ] Knowledge Base table populated with relevant constraints
- [ ] User personalization inserted in Communication Style
- [ ] Testing strategy reflected in workflows
- [ ] File extension bindings defined for all Modes
- [ ] Self-Verification Loop includes all relevant checks
- [ ] Commit message format matches project conventions

---

## Handoff

When implementing this protocol:

1. **Follow the three phases in order** - Don't skip ahead
2. **STOP & SCAN first** - Analyze input completeness before generating
3. **Ask one question at a time** - Progressive disclosure reduces cognitive load
4. **Auto-detect before asking** - Reduce user input, confirm instead
5. **Provide multiple choices** - Always give options with clear descriptions
6. **Use the templates** - `claude-template.md` and `tech-rule-template.md`
7. **Copy Mode 0 verbatim** - The Inception section should be copied exactly
8. **Update anchors** - Add new anchors to `anchors.md` when creating new sections
