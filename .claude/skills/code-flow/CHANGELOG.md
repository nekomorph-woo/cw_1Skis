# Code Flow Skill - Changelog

Version change record for tracking code-flow skill updates in this repository. Independent from skill functionality documentation.

---

## Version History

| Version | Date | Type | Description |
|---------|------|------|-------------|
| 0.5.0 | 2025-01-18 | Added | Unified trigger keyword management system (`references/_core/trigger-keywords.md`) |
| 0.5.0 | 2025-01-18 | Added | Unified technology stack commands reference (`references/_core/tech-commands.md`) |
| 0.5.0 | 2025-01-18 | Added | Anchor system replacing line-based references (`references/_core/anchors.md`) |
| 0.5.0 | 2025-01-18 | Refactored | Updated all sub-skill documents to use unified trigger keyword references |
| 0.5.0 | 2025-01-18 | Refactored | Simplified technology command tables with references to unified docs |
| 0.5.0 | 2025-01-18 | Fixed | Replaced line-based references (`file.md:130`) with anchor references (`file.md#seq-rules`) |
| 0.4.0 | 2024-XX-XX | Initial | Initial version features |

---

## Change Types

| Type | Description |
|------|-------------|
| Added | New features, files, or sections |
| Refactored | Improvements to existing functionality or structure |
| Fixed | Bug fixes or error corrections |
| Removed | Deleted features or files |
| Reorganized | Code or documentation restructuring |

---

## Auto-Update Rules

**Trigger Conditions (significant changes):**
- Modifications to core documents in `_core/` directory
- Structural changes to `SKILL.md`
- New or removed sub-skills
- Documentation directory structure changes

**Usage:**
```bash
# Bash
./scripts/bump-version.sh [minor|patch]

# PowerShell
./scripts/bump-version.ps1 [minor|patch]
```
