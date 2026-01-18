# Code Cock Skill - Changelog

Version change record for tracking code-cock skill updates in this repository. Independent from skill functionality documentation.

---

## Version History

| Version | Date | Type | Description |
|---------|------|------|-------------|
| 0.1.0 | 2025-01-18 | Initial | Initial release with core operations (generate, refresh, analyze, tech-rule, validate) |

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
- New or removed operations
- Documentation directory structure changes

**Usage:**
```bash
# Bash
./scripts/bump-version.sh [minor|patch]

# PowerShell
./scripts/bump-version.ps1 [minor|patch]
```

The script will automatically:
- Update version number in `SKILL.md`
- Append change record to `CHANGELOG.md`
