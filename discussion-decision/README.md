# Discussion & Decision

**Communication & Decision Architect Skill for Claude Code**

---

## Overview

Discussion & Decision is a skill that transforms vague communication needs into structured, actionable documents. It helps users prepare for high-stakes communication scenarios through systematic frameworks and preparation workflows.

---

## What It Does

### Communication Preparation
- **Email/Draft Writing**: Structure clear, actionable messages
- **Meeting Agendas**: Design productive meeting frameworks
- **Presentation Outlines**: Build persuasive narrative structures
- **Stakeholder Briefings**: Prepare targeted executive summaries

### Decision Support
- **Decision Matrices**: Create weighted comparison frameworks
- **Pros/Cons Analysis**: Structured benefit-cost evaluation
- **Consensus Building**: Facilitate group alignment tools
- **Risk Assessment**: Identify and mitigate decision risks

### Negotiation & Conflict
- **Negotiation Prep**: Build position and concession frameworks
- **Conflict Resolution**: Structure difficult conversations
- **Objection Handling**: Prepare response strategies
- **Proposal Defense**: Anticipate and counter challenges

---

## How to Use

### Decision Workspace (New in v0.2.0)

The decision workspace creates an isolated environment for each topic:

```
/discussion-decision 讨论项目技术栈选型
```

This creates:
```
decision-doc/tech-stack-selection/
├── discussion.md    # Your free-form notes
└── decision.md      # MADR format collaboration document
```

**Session Persistence:**
```
# Later in the same session
User: "继续"
AI: "**Current Context:** tech-stack-selection (continuing session)"
```

**Topic Switching:**
```
User: "切换到招聘决策"
AI: "**Context Switch:** tech-stack-selection → hiring-decision"
```

### Basic Invocation

```
/discussion-decision
```

This displays an interactive menu with available operations.

### Direct Invocation

```
Use discussion-decision to prepare a decision brief for hiring a new developer
```

This skips the menu and directly executes the appropriate workflow.

### Common Scenarios

```
# Decision Support
"Help me decide between Option A and Option B"
"I need to prepare a decision matrix for..."
"What are the pros and cons of...?"

# Communication
"I need to write an email to request approval"
"Prepare an agenda for the quarterly planning meeting"
"I need to tell a client we're going to be late"

# Negotiation
"Help me prepare for a salary negotiation"
"I need to negotiate scope with a client"
"How should I handle objections to...?"
```

---

## File Structure

```
discussion-decision/
├── SKILL.md                      # Main skill documentation
├── CHANGELOG.md                  # Version history
├── README.md                     # This file
├── references/                   # Detailed reference documents
│   ├── _core/
│   │   ├── communication-principles.md    # Universal guidelines
│   │   ├── decision-frameworks.md         # Decision methodologies
│   │   ├── stakeholder-analysis.md        # Audience analysis
│   │   ├── objection-handling.md          # Response strategies
│   │   ├── context-management.md          # Topic context management
│   │   └── name-generation.md             # Topic name generation
│   └── topic-workflows.md                 # Topic workflow descriptions
├── templates/                    # Ready-to-use templates
│   ├── decision-madr.md          # MADR decision record template
│   ├── decision-matrix.md        # Weighted decision matrix
│   ├── email-draft.md            # Email structure
│   └── meeting-agenda.md         # Meeting framework
└── examples/                     # Sample outputs
    ├── README.md                 # Examples overview
    ├── decision-request/         # Communication example
    │   ├── 01_decision_brief.md
    │   ├── 02_stakeholder_analysis.md
    │   └── 03_communication_draft.md
    └── topic-workspace/          # Decision workspace example
        └── project-alignment/
            ├── discussion.md
            └── decision.md
```

---

## Core Workflow

Discussion & Decision follows a systematic preparation process:

1. **Intent Confirmation** - Understand what communication scenario you're preparing for
2. **Type Selection** - Choose the appropriate framework for your situation
3. **Content Structuring** - Organize information using proven templates
4. **Stakeholder Analysis** - Understand your audience and their concerns
5. **Response Preparation** - Anticipate objections and prepare responses
6. **Output Generation** - Produce polished, actionable documents

See `SKILL.md` for detailed workflow documentation.

---

## Key Features

### Progressive Disclosure
- **Quick Start**: Menu-driven interface for common scenarios
- **Deep Dive**: Reference documents for advanced techniques
- **Templates**: Reusable frameworks for consistent output

### Evidence-Based Frameworks
All frameworks are based on established communication and decision-making methodologies:
- Pyramid Principle (McKinsey)
- RAPID Decision Model (Bain)
- Pre-Mortem Analysis (Klein)
- Interest-Based Negotiation (Harvard)

### Stakeholder-Centric
Every framework includes stakeholder analysis to ensure communication resonates with the audience.

---

## Version Information

**Current Version:** 0.2.0

**Stability:** Active development - Decision Workspace feature added

**Changelog:** See `CHANGELOG.md` for complete version history

---

## Contributing

This skill is designed to be extended. To add new capabilities:

1. Add new templates to `templates/`
2. Document new frameworks in `references/_core/`
3. Provide examples in `examples/`
4. Update `SKILL.md` to reference new content

---

## License

Part of the Claude Code skill ecosystem. Use and modify freely.

---

## Acknowledgments

Discussion & Decision incorporates best practices from:
- McKinsey & Company (Pyramid Principle)
- Bain & Company (RAPID Decision Model)
- Harvard Negotiation Project
- Project Management Institute (Communication standards)
