# Document Anchor Definitions

## Purpose

Define standard anchor references for cross-document linking within the code-cock skill. This serves as the single source of truth for all anchor IDs.

## Why Anchors

- **Stability**: Anchors don't break when lines are added/removed
- **Clarity**: Descriptive anchor names are self-documenting
- **Maintainability**: Single place to define all cross-reference points

---

## Anchor Mapping Table

### Main Skill Document (SKILL.md)

| Section | Anchor ID | Usage Example |
|---------|-----------|---------------|
| Technology Stack Auto-Detection | `tech-stack-detection` | `SKILL.md#tech-stack-detection` |
| Lyra Generation Protocol | `lyra-protocol` | `SKILL.md#lyra-protocol` |
| Technology Stack Support | `tech-stack-support` | `SKILL.md#tech-stack-support` |

### Core Reference Documents

| Document | Section | Anchor ID | Usage Example |
|----------|---------|-----------|---------------|
| `lyra-protocol.md` | Phase 1: Progressive Information Collection | `lyra-phase1` | `lyra-protocol.md#lyra-phase1` |
| `lyra-protocol.md` | Phase 2: Architecture Detection | `lyra-phase2` | `lyra-protocol.md#lyra-phase2` |
| `lyra-protocol.md` | Phase 3: Template Generation | `lyra-phase3` | `lyra-protocol.md#lyra-phase3` |
| `lyra-protocol.md` | New Project Mode | `lyra-new-mode` | `lyra-protocol.md#lyra-new-mode` |
| `lyra-protocol.md` | Legacy Project Mode | `lyra-legacy-mode` | `lyra-protocol.md#lyra-legacy-mode` |
| `claude-template.md` | Role & Context Section | `claude-role-context` | `claude-template.md#claude-role-context` |
| `claude-template.md` | Context Switch Rules | `claude-context-switch` | `claude-template.md#claude-context-switch` |
| `claude-template.md` | Knowledge Base Indexing | `claude-kb-indexing` | `claude-template.md#claude-kb-indexing` |
| `claude-template.md` | Vibe Coding Workflow | `claude-workflow` | `claude-template.md#claude-workflow` |
| `claude-template.md` | Coding Standards | `claude-coding-standards` | `claude-template.md#claude-coding-standards` |
| `claude-template.md` | Communication Style | `claude-communication` | `claude-template.md#claude-communication` |
| `claude-template.md` | Self-Verification Loop | `claude-self-verification` | `claude-template.md#claude-self-verification` |
| `tech-rule-template.md` | Axioms Section | `rule-axioms` | `tech-rule-template.md#rule-axioms` |
| `tech-rule-template.md` | Mapping Rules Section | `rule-mapping` | `tech-rule-template.md#rule-mapping` |
| `tech-rule-template.md` | Critical Snippets Section | `rule-snippets` | `tech-rule-template.md#rule-snippets` |
| `tech-rule-template.md` | Verification Section | `rule-verification` | `tech-rule-template.md#rule-verification` |
| `tech-rule-template.md` | Integration Section | `rule-integration` | `tech-rule-template.md#rule-integration` |
| `trigger-keywords.md` | Generate Operation Keywords | `trigger-generate` | `trigger-keywords.md#trigger-generate` |
| `trigger-keywords.md` | Refresh Operation Keywords | `trigger-refresh` | `trigger-keywords.md#trigger-refresh` |
| `trigger-keywords.md` | Analyze Operation Keywords | `trigger-analyze` | `trigger-keywords.md#trigger-analyze` |
| `trigger-keywords.md` | Tech-Rule Operation Keywords | `trigger-tech-rule` | `trigger-keywords.md#trigger-tech-rule` |
| `trigger-keywords.md` | Validate Operation Keywords | `trigger-validate` | `trigger-keywords.md#trigger-validate` |
| `menu-structure.md` | Menu Display Rules | `menu-rules` | `menu-structure.md#menu-rules` |
| `menu-structure.md` | Input Handling | `menu-input-handling` | `menu-structure.md#menu-input-handling` |
| `operations-guide.md` | Generate Operation | `ops-generate` | `operations-guide.md#ops-generate` |
| `operations-guide.md` | Refresh Operation | `ops-refresh` | `operations-guide.md#ops-refresh` |
| `operations-guide.md` | Analyze Operation | `ops-analyze` | `operations-guide.md#ops-analyze` |
| `operations-guide.md` | Tech-Rule Operation | `ops-tech-rule` | `operations-guide.md#ops-tech-rule` |
| `operations-guide.md` | Validate Operation | `ops-validate` | `operations-guide.md#ops-validate` |
| `operations-guide.md` | Quick Workflows | `ops-workflows` | `operations-guide.md#ops-workflows` |

### Technology Stack Guides

| Document | Section | Anchor ID | Usage Example |
|----------|---------|-----------|---------------|
| `kotlin-jvm.md` | Detection Signals | `kotlin-detection` | `kotlin-jvm.md#kotlin-detection` |
| `kotlin-jvm.md` | Mode Configuration | `kotlin-modes` | `kotlin-jvm.md#kotlin-modes` |
| `kotlin-jvm.md` | Auto-Inferred Constraints | `kotlin-constraints` | `kotlin-jvm.md#kotlin-constraints` |
| `react.md` | Detection Signals | `react-detection` | `react.md#react-detection` |
| `react.md` | Mode Configuration | `react-modes` | `react.md#react-modes` |
| `react.md` | Auto-Inferred Constraints | `react-constraints` | `react.md#react-constraints` |
| `vue.md` | Detection Signals | `vue-detection` | `vue.md#vue-detection` |
| `vue.md` | Mode Configuration | `vue-modes` | `vue.md#vue-modes` |
| `vue.md` | Auto-Inferred Constraints | `vue-constraints` | `vue.md#vue-constraints` |

---

## Anchor Naming Convention

**Format:** `{document-purpose}-{section-purpose}` or `{section-purpose}`

**Examples:**
- `tech-stack-detection` (tech stack detection section)
- `lyra-phase1` (Lyra protocol phase 1)
- `claude-role-context` (CLAUDE template role & context)
- `rule-axioms` (rule template axioms section)
- `kotlin-constraints` (Kotlin inferred constraints)

**Rules:**
- Use lowercase
- Use hyphens to separate words
- Be descriptive but concise
- Avoid numbers at the start
- Use document prefix for document-specific anchors (e.g., `claude-`, `lyra-`, `rule-`)
- Use generic names for universal concepts

---

## How to Use Anchors

### In Markdown Documents

```markdown
<!-- Define anchor in heading -->
## Technology Stack Auto-Detection {#tech-stack-detection}

<!-- Reference from other documents -->
See `SKILL.md#tech-stack-detection` for detection details.
```

### In Text References

```markdown
<!-- Before (line-based - AVOID) -->
See SKILL.md:45 for detection details.

<!-- After (anchor-based) -->
See `SKILL.md#tech-stack-detection` for detection details.
```

### For Sub-Sections

```markdown
<!-- Define anchor -->
#### Phase 1: Progressive Information Collection {#lyra-phase1}

<!-- Reference -->
Follow the protocol in `lyra-protocol.md#lyra-phase1` for information collection.
```

---

## Adding New Anchors

1. **Choose a descriptive name** following the naming convention
2. **Add to this table** in the appropriate section
3. **Add `{#anchor-id}` to the heading** in the target document
4. **Update all references** to use the new anchor
5. **Verify no broken references** exist

---

## Migration Log

| Date | Change | Files Affected |
|------|--------|----------------|
| 2025-01-18 | Initial anchor system creation | All cross-references |

---

## Handoff

When adding cross-references:
1. Check this table first for existing anchors
2. If no anchor exists, add one following the convention
3. Update this table as the single source of truth
4. Never use line-based references (`file.md:123`) in new content
5. When updating existing line-based refs, replace with anchors and update this table
