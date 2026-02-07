# Changelog

All notable changes to the Dialogue Smith skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-01-29

### Added
- **Decision Workspace**: Topic-based document management system
- **MADR Template**: Decision template based on Markdown Any Decision Records format
- **Decision Process Section**: Track decision-making activities and key discussions
- **Decision Change Log**: Record status transitions and decision evolution
- **Context Management**: Session context persistence and switching
- **Interactive Menu**: Topic selection and switching interface with clear display rules
- **Auto-generated Topics**: kebab-case naming from user input

### Changed
- **Skill Description**: Updated to reflect workspace-based approach
- **File Structure**: Added `decision-doc/` base directory
- **Template System**: New `decision-madr.md` (MADR format) for topic initialization

### Files Added
- `references/_core/context-management.md`
- `references/_core/name-generation.md`
- `references/topic-workflows.md`
- `templates/decision-madr.md`
- `examples/topic-workspace/project-alignment/discussion.md`
- `examples/topic-workspace/project-alignment/decision.md`

## [0.1.0] - 2025-01-29

### Added
- Initial skill structure and core workflow
- Communication type frameworks (Information Sharing, Decision Request, Persuasion, Negotiation)
- Decision Matrix template with weighted criteria
- Stakeholder Analysis framework
- Objection Handling templates
- Question Preparation guidelines
- Output generation rules for different communication scenarios
- Usage examples for common scenarios

### Documentation
- SKILL.md with complete workflow documentation
- Reference files structure definition
- Writing style guidelines
- Version information section

---

## [Unreleased]

### Planned
- Validation scripts for communication effectiveness
- Multi-language support
- Integration with calendar/meeting tools
