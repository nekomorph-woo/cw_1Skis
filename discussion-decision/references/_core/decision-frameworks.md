# Decision Frameworks

Methodologies for structured decision-making in technical and business contexts.

---

## Decision Types Classification

| Type | Characteristics | Time Horizon | Reversibility |
|------|----------------|--------------|---------------|
| **Tactical** | Routine, operational | Days to weeks | Easily reversible |
| **Strategic** | Direction-setting, high-impact | Months to years | Difficult to reverse |
| **Crisis** | Urgent, high-stakes | Immediate | Variable |

---

## Framework 1: Weighted Decision Matrix

Best for: Comparing 3-5 options across multiple criteria

### Steps
1. List options (A, B, C...)
2. Define evaluation criteria (5-7 max)
3. Assign weights to criteria (sum = 100%)
4. Score each option on each criterion (1-5)
5. Calculate weighted scores
6. Analyze sensitivity to weight changes

### When to Use
- Multiple options with different trade-offs
- Stakeholders disagree on priorities
- Decision needs justification for others
- Quantitative comparison needed

### When NOT to Use
- Only two options (use pros/cons instead)
- One criterion dominates (just use that)
- Decision is urgent (matrix takes time)

---

## Framework 2: Pros-Cons Analysis

Best for: Binary decisions (go/no-go, this/that)

### Enhanced Pros-Cons Structure

```
Option: [Name]

PROS (Benefits)                  IMPACT    EFFORT    CONFIDENCE
--------------------------------|---------|---------|----------
[Benefit 1]                     | [H/M/L] | [H/M/L] | [H/M/L]
[Benefit 2]                     | [H/M/L] | [H/M/L] | [H/M/L]

CONS (Risks/Costs)              IMPACT    MITIGATION
--------------------------------|---------|------------------
[Con 1]                         | [H/M/L] | [Mitigation]
[Con 2]                         | [H/M/L] | [Mitigation]

NET ASSESSMENT:
Total Benefit Score: [Sum]
Total Risk Score: [Sum]
Recommendation: [Proceed/Reject/Defer]
```

### When to Use
- Simple binary choices
- Quick assessment needed
- Intuitive verification
- Stakeholder alignment

---

## Framework 3: Eisenhower Matrix

Best for: Prioritization decisions

```
           URGENT                  NOT URGENT
  +-----------------------+-----------------------+
  |                       |                       |
  | IMPORTANT | Do First | Schedule |
  |           | - Crisis  | - Planning            |
  |           | - Deadlines | - Skill building   |
  +-----------------------+-----------------------+
  |                       |                       |
  | NOT       | Delegate  | Eliminate |
  | IMPORTANT | - Interruptions | - Trivia        |
  |           | - Some meetings | - Time wasters  |
  +-----------------------+-----------------------+
```

---

## Framework 4: RAPID Decision Model

Assign clear roles for organizational decisions

| Role | Responsibility | Who |
|------|----------------|-----|
| **R**ecommend | Proposes decision, gathers input | |
| **A**gree | Has veto power, must agree | |
| **P**erform | Implements decision | |
| **I**nput | Provides data and perspective | |
| **D**ecide | Makes final decision | |

**Rule:** Only one D per decision

---

## Framework 5: OODA Loop

For fast-paced, evolving situations

```
┌─────────┐
│ OBSERVE │  → Gather information, assess situation
└────┬────┘
     ↓
┌─────────┐
│ ORIENT  │  → Analyze, synthesize, update mental model
└────┬────┘
     ↓
┌─────────┐
│ DECIDE  │  → Select course of action
└────┬────┘
     ↓
┌─────────┐
│ ACT     │  → Execute, observe results, loop back
└─────────┘
```

**Speed:** Faster cycles = competitive advantage

---

## Framework 6: Pre-Mortem Analysis

Identify risks before committing to a decision

### Process
1. Assume the decision has failed catastrophically
2. Ask: "What went wrong?"
3. Brainstorm failure modes
4. Develop preventive measures
5. Re-evaluate decision with new insights

### Example Questions
- "It's 6 months from now and this project is a disaster. What happened?"
- "The client rejected the proposal. Why?"
- "The technical solution failed in production. What was the cause?"

---

## Decision Quality Checklist

Before finalizing any decision, verify:

- [ ] **Problem Definition**: Are we solving the right problem?
- [ ] **Options Explored**: Did we consider at least 3 alternatives?
- [ ] **Information Quality**: Is our data reliable and sufficient?
- [ ] **Stakeholder Input**: Have key perspectives been included?
- [ ] **Consequences Considered**: Do we understand second-order effects?
- [ ] **Reversibility**: Can we change course if wrong?
- [ ] **Implementation**: Do we have a clear action plan?
- [ ] **Metrics**: How will we measure success?

---

## Common Decision Biases

| Bias | Description | Mitigation |
|------|-------------|------------|
| **Confirmation** | Seeking only confirming evidence | Assign devil's advocate |
| **Anchoring** | Overweighting first information | Gather data before forming opinion |
| **Sunk Cost** | Continuing due to past investment | Evaluate only future costs/benefits |
| **Availability** | Overweighting recent/vivid examples | Use base rates and statistics |
| **Groupthink** | Prioritizing harmony over critique | Anonymous feedback, structured dissent |

---

## Decision Documentation Template

```markdown
# [Decision Title]

## Decision
[Clear statement of what was decided]

## Context
- Background: [Why this decision was needed]
- Constraints: [Budget, time, resource limits]
- Stakeholders: [Who is affected]

## Options Considered
- Option A: [Summary and key points]
- Option B: [Summary and key points]
- Option C: [Summary and key points]

## Rationale
- Primary reason for decision: [Key factor]
- Secondary reasons: [Supporting factors]
- Alternatives rejected: [Why they weren't chosen]

## Implications
- Positive impacts: [Expected benefits]
- Risks: [Potential downsides]
- Mitigation: [How risks will be addressed]

## Implementation
- Owner: [Who is responsible]
- Timeline: [Key milestones]
- Success metrics: [How we measure outcomes]

## Reversibility
- This decision is [reversible/irreversible]
- Review date: [When we reassess]
- Exit criteria: [Conditions for changing course]
```
