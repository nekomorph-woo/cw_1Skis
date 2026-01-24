# Code Cock Operations Guide

## Purpose

Detailed implementation guide for all code-cock operations. Refer to this when executing specific operations.

---

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
After generating `CLAUDE.md`:
1. Run `validate` to verify the document is correct
2. Review the generated content and adjust if needed
3. Consider generating `tech-rule` documents for specific technology areas

**Completion Summary:**
```
CLAUDE.md generated successfully at project root

Recommended next steps:
  • Run "/code-cock validate" to verify document consistency
  • Review the generated CLAUDE.md and request adjustments if needed
  • Use "/code-cock tech-rule <topic>" to add specific technical guidance
```

---

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
After refreshing `CLAUDE.md`:
1. Run `validate` to ensure the updates are consistent
2. Run `analyze` if you want to check for further quality improvements

**Completion Summary:**
```
CLAUDE.md refreshed with current project state

Recommended next steps:
  • Run "/code-cock validate" to verify consistency
  • Run "/code-cock analyze" to check for quality improvements
```

---

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
After analyzing `CLAUDE.md`:
1. Review the analysis report and identified issues
2. Decide whether to apply fixes manually or use `analyze --fix`
3. Run `refresh` to sync with any structural changes after fixes
4. Run `validate` to verify the improved document

**Completion Summary:**
```
Analysis complete - [X] issues found (P0: [n], P1: [n], P2: [n], P3: [n])

Recommended next steps:
  • Review issues and decide on fixes
  • Use "/code-cock analyze --fix" to apply improvements automatically
  • Run "/code-cock refresh" to sync with current state
  • Run "/code-cock validate" to verify improvements
```

---

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
After generating a tech rule document:
1. Run `refresh` to update the Knowledge Base table in `CLAUDE.md`
2. Run `validate` to verify the new reference is correctly linked

**Completion Summary:**
```
Technical rule document created: cock-docs/tech-guidance/<tech-point>-rules.md

Recommended next steps:
  • Run "/code-cock refresh" to update CLAUDE.md Knowledge Base
  • Run "/code-cock validate" to verify the reference is correctly linked
```

---

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

**If validation passed:**
- Document is consistent, proceed with development

**If validation failed:**
- Review the report and take recommended actions:
  - Fix broken references by running `refresh`
  - Add missing `tech-guidance` files using `tech-rule`
  - Update document structure manually if needed

**Completion Summary (Pass):**
```
Validation passed - CLAUDE.md is consistent with project state

No action required. You can proceed with development.
```

**Completion Summary (Fail):**
```
Validation failed - [n] issues found

Issues:
  • [Issue 1 description]
  • [Issue 2 description]

Recommended actions:
  • Run "/code-cock refresh" to fix broken references
  • Use "/code-cock tech-rule <topic>" to add missing guidance
  • Manually fix structural issues if suggested
```

---

## Quick Workflows

| Scenario | Workflow |
|----------|----------|
| New Project | `generate --new` → `validate` |
| Existing Project | `generate --legacy` → `refresh` → `validate` |
| Regular Maintenance | `analyze` → `refresh` → `validate` |
| Add Tech Rule | `tech-rule <point>` → `refresh` → `validate` |
| Before Major Work | `validate` → (fix issues if any) |

---

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

---

## Handoff

When executing operations:
1. Follow the process steps in order
2. Present completion summaries to user
3. Recommend next steps for post-operation guidance
4. Use the quick workflows for common scenarios
