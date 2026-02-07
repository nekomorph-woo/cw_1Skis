---
name: discussion-decision
description: Decision workspace with topic-based document management. Creates isolated decision environments (discussion.md + decision.md) for each topic using MADR format. Maintains session context across interactions. Also supports communication preparation, decision frameworks, and negotiation tools.
version: 0.2.0
author: claude-code
changelog: CHANGELOG.md
---

# Discussion & Decision - Communication and Decision Architect

Structure communication scenarios into actionable frameworks. Transform vague communication needs into precise documents, decision matrices, and consensus-building tools.

---

## Core Philosophy

Effective communication follows **intentional preparation**:
1. **Clarify Purpose** - Define what needs to be achieved
2. **Identify Stakeholders** - Understand who needs to be influenced
3. **Structure Content** - Organize information logically
4. **Anticipate Responses** - Prepare for objections and questions
5. **Define Success** - Establish clear outcome criteria

---

## Decision Workspace Structure

### Base Directory
- **Location:** `decision-doc/`
- **Purpose:** Central repository for all decision documents

### Topic Subdirectories
Each topic creates an isolated workspace:

```
decision-doc/<topic-name>/
├── discussion.md       # Blank canvas for user's free-form notes
├── decision.md         # MADR format template for collaborative decision-making
└── .context-marker     # Hidden file for session tracking
```

### Topic Naming Convention
- **Format:** kebab-case (lowercase with hyphens)
- **Generation:** AI auto-generates from user input
- **Example:** "项目对齐" → `project-alignment`

---

## Skill Menu

When user invokes `/discussion-decision` without specific intent:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Discussion & Decision - Decision Workspace (v0.2.0)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Available Topics:

[1] project-alignment      # Project team alignment discussion
[2] tech-stack-selection  # Technology stack decision
[3] hiring-decision       # Senior engineer hiring decision

Actions:
[N] New Topic             # Create a new decision topic
[Q] Quit                  # Exit menu

Current Context: [project-alignment]

────────────────────────────────────────────────────────────────────────────────

What would you like to do?

• Enter number [1-3] to switch topic
• Enter [N] to create new topic
• Describe your topic to create directly

────────────────────────────────────────────────────────────────────────────────
```

**Menu Display Rules:**

| User Input | Has Context | Action |
|------------|-------------|--------|
| Specific topic (e.g., "讨论项目对齐") | Any | Skip menu → Create/switch to topic directly |
| "continue" / "继续" | Yes | Skip menu → Continue current context |
| "continue" / "继续" | No | Show menu (no context to continue) |
| No specific intent (e.g., "我要做决定") | Any | Show menu |
| "switch" / "切换" / "切换主题" | Any | Show menu |

---

## Context Management

### Session Context Rules

| Priority | Condition | Action |
|----------|-----------|--------|
| 1 | User explicitly specifies topic | Switch to specified context |
| 2 | Relative path reference | Use current context (must exist) |
| 3 | No context information | Keep current context |
| 4 | No context exists | Show menu or ask user |

### Topic Creation Workflow

**When user provides a topic:**
1. Extract core concept (2-5 words)
2. Translate to English
3. Convert to kebab-case
4. Create directory: `decision-doc/<topic-name>/`
5. Initialize `discussion.md` (blank)
6. Initialize `decision.md` (from `templates/decision-madr.md`)
7. Create `.context-marker`
8. Set as active context

### Initial Call Constraint

**No topic provided:**
```
User: "我要做个决定"
AI: "请提供一个决策主题，例如：项目技术栈选型、团队招聘决策等"
```

---

## Skill Menu (Legacy)

The following categories remain available for direct invocation:

```
[1] COMMUNICATION PREP
    Email/Draft Writing - Structure clear, actionable messages
    Meeting Agenda - Design productive meeting frameworks
    Presentation Outline - Build persuasive narrative structures
    Stakeholder Briefing - Prepare targeted executive summaries

[2] DECISION SUPPORT
    Decision Matrix - Create weighted comparison frameworks
    Pros/Cons Analysis - Structured benefit-cost evaluation
    Consensus Builder - Facilitate group alignment tools
    Risk Assessment - Identify and mitigate decision risks

[3] NEGOTIATION & CONFLICT
    Negotiation Prep - Build position and concession frameworks
    Conflict Resolution - Structure difficult conversations
    Objection Handling - Prepare response strategies
    Proposal Defense - Anticipate and counter challenges

[4] DOCUMENT TEMPLATES
    Custom Template - Create reusable communication templates
    Template Library - Browse available frameworks
```

---

## Phase 0: Intent Confirmation

1. **Identify Communication Scenario**
   - Ask: "What communication situation are you preparing for?"
   - Accept: Free-form description OR scenario type

2. **Clarify Stakeholders**
   - Who is the audience? (executives, team, client, cross-functional)
   - What is their decision power? (decision-maker, influencer, implementer)
   - What do they care about? (metrics, timeline, budget, risk)

3. **Define Success Criteria**
   - What decision needs to be made?
   - What action needs to be taken?
   - What consensus needs to be reached?

---

## Phase 1: Communication Type Selection

Based on scenario, select appropriate framework:

### Type A: Information Sharing
- Email announcement
- Status update
- Knowledge transfer
- **Framework:** What → Why → How → When → Who

### Type B: Decision Request
- Resource approval
- Strategy selection
- Go/No-Go decision
- **Framework:** Context → Options → Analysis → Recommendation → Ask

### Type C: Persuasion & Buy-In
- Change management
- Initiative pitch
- Cross-functional alignment
- **Framework:** Problem → Vision → Impact → Proof → Call to Action

### Type D: Negotiation
- Contract terms
- Scope definition
- Resource allocation
- **Framework:** Positions → Interests → Options → Trade-offs → Agreement

---

## Phase 2: Content Structuring

### Information Sharing Framework

```markdown
# [Subject]

## Context (Why this matters)
- Background: [1-2 sentences]
- Relevance: [Why audience should care]

## Key Information (What)
- [Point 1]: [Details]
- [Point 2]: [Details]
- [Point 3]: [Details]

## Implications (So what)
- Impact on [Stakeholder]: [Specific effect]
- Timeline: [When changes occur]
- Actions required: [Who needs to do what]

## Next Steps (What's next)
- [ ] [Action 1] - [Owner] - [Due date]
- [ ] [Action 2] - [Owner] - [Due date]

## Questions & Support
- Primary contact: [Name]
- FAQ: [Anticipated questions and answers]
```

### Decision Request Framework

```markdown
# [Decision Title]

## Context
- Current situation: [Description]
- Problem/Opportunity: [What needs to be addressed]
- Urgency: [Timeline pressure]

## Options Under Consideration

### Option A: [Name]
- Description: [Brief overview]
- Effort: [Time/cost/resources]
- Risk: [Key concerns]
- Expected Outcome: [Results]

### Option B: [Name]
- Description: [Brief overview]
- Effort: [Time/cost/resources]
- Risk: [Key concerns]
- Expected Outcome: [Results]

### Option C: [Name]
- Description: [Brief overview]
- Effort: [Time/cost/resources]
- Risk: [Key concerns]
- Expected Outcome: [Results]

## Comparative Analysis

| Criteria | Option A | Option B | Option C |
|----------|----------|----------|----------|
| [Metric 1] | [Score] | [Score] | [Score] |
| [Metric 2] | [Score] | [Score] | [Score] |
| [Metric 3] | [Score] | [Score] | [Score] |

## Recommendation
**Recommended: Option [X]**

**Rationale:**
- [Primary reason 1]
- [Primary reason 2]
- [Key differentiator]

## Requested Action
- Decision needed by: [Date]
- Decision-maker: [Role/Person]
- Approval mechanism: [How decision is recorded]

## If Approved
- Immediate next steps: [Actions 1-2-3]
- Owner: [Who leads implementation]
- Success metrics: [How we measure success]
```

### Decision Matrix Framework

```markdown
# [Decision Title] - Decision Matrix

## Decision Statement
[Clear statement of what decision needs to be made]

## Evaluation Criteria

| Criteria | Weight | Option A | Option B | Option C |
|----------|--------|----------|----------|----------|
| [Criteria 1] | [X%] | [Score 1-5] | [Score 1-5] | [Score 1-5] |
| [Criteria 2] | [X%] | [Score 1-5] | [Score 1-5] | [Score 1-5] |
| [Criteria 3] | [X%] | [Score 1-5] | [Score 1-5] | [Score 1-5] |
| **Total** | **100%** | **[Sum]** | **[Sum]** | **[Sum]** |

## Criteria Definitions
- **[Criteria 1]**: [Definition and what high/low scores mean]
- **[Criteria 2]**: [Definition and what high/low scores mean]
- **[Criteria 3]**: [Definition and what high/low scores mean]

## Sensitivity Analysis
- If [Criteria 1] weight increases to X%: [Impact on ranking]
- If [Criteria 2] is removed: [Impact on ranking]
- Critical assumption: [Key factor the decision depends on]

## Recommendation
**Selected: Option [X]** with score [Total]

**Confidence Level:** [High/Medium/Low]
**Key Risk:** [What could change the outcome]
**Mitigation:** [How to address the risk]
```

---

## Phase 3: Stakeholder Analysis

For each key stakeholder, document:

```markdown
## Stakeholder: [Name/Role]

### Perspective
- Primary concern: [What matters most to them]
- Decision criteria: [How they evaluate options]
- Communication style: [Detail level, format preference]

### Potential Objections
- Objection 1: [What they might push back on]
  - Response: [How to address it]
- Objection 2: [What they might push back on]
  - Response: [How to address it]

### Win Criteria
- What success looks like for them: [Their desired outcome]
- How to frame the proposal: [Messaging that resonates]
```

---

## Phase 4: Response Preparation

### Objection Handling Template

```markdown
## Anticipated Objections

### "[Objection 1]"
- **Underlying concern:** [What they're really worried about]
- **Acknowledge:** "I understand your concern about..."
- **Reframe:** "Another way to look at this is..."
- **Evidence:** [Data/supporting point]
- **Alternative:** "If that's a blocker, we could..."

### "[Objection 2]"
- **Underlying concern:** [What they're really worried about]
- **Acknowledge:** "I understand your concern about..."
- **Reframe:** "Another way to look at this is..."
- **Evidence:** [Data/supporting point]
- **Alternative:** "If that's a blocker, we could..."
```

### Question Preparation

```markdown
## Likely Questions & Answers

### Q: [Question 1]
**A:** [Concise answer with supporting detail]
- Key point 1: [Detail]
- Key point 2: [Detail]
- Backup: [Additional context if needed]

### Q: [Question 2]
**A:** [Concise answer with supporting detail]
- Key point 1: [Detail]
- Key point 2: [Detail]
- Backup: [Additional context if needed]
```

---

## Phase 5: Output Generation

Generate the appropriate document(s):

| Communication Type | Output Files |
|-------------------|--------------|
| Information Sharing | `01_communication_draft.md`, `02_stakeholder_notes.md` |
| Decision Request | `01_decision_brief.md`, `02_options_analysis.md`, `03_stakeholder_matrix.md` |
| Decision Matrix | `01_decision_matrix.md`, `02_sensitivity_analysis.md` |
| Negotiation | `01_position_summary.md`, `02_concession_plan.md`, `03_responses.md` |
| Presentation | `01_slide_outline.md`, `02_speaker_notes.md`, `03_qa_prep.md` |

---

## Reference Files Structure

```
# Runtime-generated in user's working directory:
# decision-doc/
# └── <topic-name>/
#     ├── discussion.md                      # User's free-form notes
#     ├── decision.md                        # MADR format decision record
#     └── .context-marker                    # Session tracking

references/
├── _core/
│   ├── communication-principles.md        # Universal communication guidelines
│   ├── decision-frameworks.md             # Decision-making methodologies
│   ├── stakeholder-analysis.md            # Audience analysis templates
│   ├── objection-handling.md              # Response strategies
│   ├── context-management.md              # Topic context management rules
│   └── name-generation.md                 # Topic name generation rules
├── topic-workflows.md                     # Topic workflow descriptions
├── scenarios/
│   ├── email-templates.md                 # Email structure patterns
│   ├── meeting-structures.md              # Meeting agenda designs
│   └── presentation-flows.md              # Presentation narrative arcs
└── examples/
    └── sample-outputs/                    # Real-world examples

templates/
├── decision-madr.md                       # MADR decision record template
├── decision-matrix.md                     # Weighted decision matrix
├── meeting-agenda.md                      # Meeting framework
└── email-draft.md                         # Email structure
```

---

## Usage Examples

### Example 1: Decision Request
```
User: "I need to ask my manager for approval to hire a new developer"

Discussion & Decision:
- Identifies: Decision Request scenario
- Applies: Decision Request Framework
- Generates: Decision brief with options (hire vs contractor vs redistribute)
- Includes: ROI analysis, risk assessment, approval pathway
```

### Example 2: Meeting Agenda
```
User: "Prepare an agenda for the quarterly planning meeting"

Discussion & Decision:
- Identifies: Information Sharing + Decision scenario
- Applies: Meeting Structure Framework
- Generates: Agenda with time blocks, prep materials, decision points
- Includes: Pre-read requirements, expected outcomes, follow-up actions
```

### Example 3: Difficult Conversation
```
User: "I need to tell a client we're going to be late on delivery"

Discussion & Decision:
- Identifies: Negotiation/Conflict scenario
- Applies: Bad News Delivery Framework
- Generates: Message script, FAQ, contingency options
- Includes: Root cause analysis, remediation plan, relationship preservation
```

---

## Writing Style Guidelines

- **Be specific** - Replace "soon" with "by Friday at 5 PM"
- **Lead with conclusion** - State the ask first, then support
- **Use active voice** - "We will" instead "It will be"
- **Quantify when possible** - "3 weeks" instead of "several weeks"
- **Assume good intent** - Frame stakeholders as allies, not adversaries
- **Focus on outcomes** - Describe results, not just activities

---

## Version Information

**Current Version:** 0.2.0

**Stability Status:** Active development - Decision Workspace feature added.

---

**Remember:** Good communication is prepared communication. Use structured frameworks to transform vague intent into clear, actionable messages.
