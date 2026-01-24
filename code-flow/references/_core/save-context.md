# Save Context - Session Context Saving Guide

## Purpose

Save current session context to `flow-docs/*/02_memories/context_*/active_context.md`. Auto-extract tasks, decisions, files, and issues from conversation.

## When to Use

- Completed important work in session
- Need to record current state for future reference
- Before switching tasks

## Trigger Keywords

> **Complete keyword list:** See `references/_core/trigger-keywords.md` for complete keyword list and routing logic.

**Common phrases that trigger this sub-skill:**
- "save context"
- "save session"
- "save progress"
- "checkpoint state"

## Context Determination

Follow context management rules: See `context-management.md`

**Quick reference:**
1. Check if user explicitly specified `<feature-name>`
2. If not, use current context from conversation
3. If no context, ask user to specify

## Announcement

Start with: "I'm using the save-context sub-skill to save the current session context..."

## Workflow

### Step 1: Read Current Context

- Read `flow-docs/*/02_memories/context_*/active_context.md`
- Create with template if doesn't exist

### Step 2: Extract Information

**Auto-extract from conversation:**

1. **Current Focus:** Main topic/feature being discussed
2. **Active Tasks:** Completed (✅), in-progress (🔄), pending (⏳)
3. **Key Decisions:** Keywords: "decide", "plan", "choose", "confirm", "correct"
4. **Known Issues:** Keywords: "issue", "bug", "todo", "fix", "problem"
5. **Recently Touched Files:** From git diff or mentions
6. **Pending Implementation:** Planned actions, TODO items
7. **Pending Questions:** Questions asked to user
8. **Recent Corrections:** Keywords: "correct", "fix", "update plan"

### Step 3: Update Strategy

**Deduplication:**
- Check if task exists → Update status
- Check if decision recorded → Skip if identical
- Check if file in recently touched → Update date

**Merging:**
- Same task: Update status and notes, keep date
- Same file: Update date to current
- Same decision: Skip if identical

### Step 4: Task Status Updates

**Automatic:**
- ✅ Done → Keep in Active Tasks, remove from Pending
- Resolved → Mark with ✅ in Known Issues
- Answered → Mark with ~~strikethrough~~ and ✅

### Step 5: Validate

**Required:**
- Current Focus: Cannot be empty
- Date format: YYYY-MM-DD
- Table format: Valid markdown

### Step 6: Generate Preview

Display changes in diff format:
```markdown
About to update:

📅 Last Updated
- Old: 2026-01-11
+ New: 2026-01-12

🎯 Current Focus
- Old: None
+ New: GetDeviceSceneSupport supports CloudArmed
```

### Step 7: User Confirmation

Ask: "Confirm saving above changes? (Y/N)"

### Step 8: Save

Write updated content:
- Preserve structure
- Update Last Updated
- Add/update sections

## Template Structure

```markdown
# Active Context

## 📅 Last Updated
YYYY-MM-DD

## 🎯 Current Focus
[Focus or "None"]

---

## 📌 Active Tasks

| Task | Status | Notes |
|------|--------|-------|
| [Task] | ✅ Done / 🔄 In Progress / ⏳ Pending | [Notes] |

---

## 🧠 Key Decisions Made

| Date | Decision | Reason |
|------|----------|--------|
| YYYY-MM-DD | [Decision] | [Reason] |

---

## ⚠️ Known Issues / Tech Debt

| Issue | Priority | Notes |
|-------|----------|-------|
| [Issue] | High/Medium/Low | [Notes] |

---

## 📚 Recently Touched Files

| File | Action | Date |
|------|--------|------|
| [File path] | Create/Modify/Delete | YYYY-MM-DD |

---

## 📋 Pending Implementation

| File | Planned Action | Priority |
|------|----------------|----------|
| [File path] | [Action] | P1/P2/P3 |

---

## 💡 Pending Questions for User

| Question | Context |
|----------|---------|
| [Question] | [Context] |

---

## 🔄 Recent Corrections

| Date | Correction | Reason |
|------|------------|--------|
| YYYY-MM-DD | [Correction] | [Reason] |
```

## Output Path

`flow-docs/<feature-name>/02_memories/active_context.md`

## Important Notes

- Always preserve structure
- Use YYYY-MM-DD consistently
- Check before adding to avoid duplicates
- Auto-manage task/issue/question status
- Always preview before saving
- Require confirmation before writing

## Handoff

After saving:

"**Context saved to `flow-docs/<feature-name>/02_memories/active_context.md`**"

"**Summary:** [X] active tasks, [Y] decisions, [Z] issues, [W] files touched"

"**Continue working or switch context?**"
