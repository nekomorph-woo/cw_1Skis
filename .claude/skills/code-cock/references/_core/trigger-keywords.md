# Operation Trigger Keywords

## Purpose

Define and manage trigger keywords for all code-cock operations. Serves as the single source of truth for keyword matching when routing user input to appropriate operations.

---

## Operation Keywords {#operation-keywords}

### generate {#trigger-generate}

**Primary Keywords:**
- generate
- create
- new
- init
- initialize

**Secondary Keywords:**
- CLAUDE.md
- project guide
- documentation
- project doc
- system instruction

**Phrases:**
- "generate CLAUDE.md"
- "create project guide"
- "new CLAUDE.md"
- "initialize documentation"
- "generate documentation"
- "create system instruction"

**Parameters:**
- `--new`: For new projects (clean slate)
- `--legacy`: For existing codebases (retrofit mode)

**Examples:**
```
User: "generate CLAUDE.md"                    → generate --new (default)
User: "create project documentation"          → generate --new
User: "generate CLAUDE.md for existing"       → generate --legacy
User: "init CLAUDE.md"                        → generate --new
```

---

### refresh {#trigger-refresh}

**Primary Keywords:**
- refresh
- sync
- synchronize
- update
- renew

**Secondary Keywords:**
- project structure
- documentation
- CLAUDE.md
- doc structure

**Phrases:**
- "refresh CLAUDE.md"
- "sync documentation"
- "update project guide"
- "synchronize CLAUDE.md"
- "refresh project structure"

**Examples:**
```
User: "refresh CLAUDE.md"                    → refresh
User: "sync documentation with code"          → refresh
User: "update project guide structure"        → refresh
```

---

### analyze {#trigger-analyze}

**Primary Keywords:**
- analyze
- review
- audit
- check
- inspect

**Secondary Keywords:**
- quality
- CLAUDE.md
- documentation
- issues
- problems
- optimization

**Phrases:**
- "analyze CLAUDE.md"
- "review documentation quality"
- "check CLAUDE.md"
- "audit project guide"
- "inspect documentation"

**Parameters:**
- `--fix`: Apply fixes automatically after analysis

**Examples:**
```
User: "analyze CLAUDE.md"                     → analyze
User: "review documentation quality"          → analyze
User: "check CLAUDE.md for issues"            → analyze
User: "analyze and fix documentation"         → analyze --fix
```

---

### tech-rule {#trigger-tech-rule}

**Primary Keywords:**
- tech-rule
- tech rule
- technical rule
- constraint
- guidance
- tech guidance

**Secondary Keywords:**
- generate
- create
- add
- technical constraint
- coding rule
- best practice

**Phrases:**
- "generate tech rule"
- "create technical constraint"
- "add guidance for"
- "generate React hooks rule"
- "create threading constraints"

**Parameters:**
- `<tech-point>`: The technology area to generate rules for (e.g., "React Hooks", "Coroutines", "EDT Threading")

**Examples:**
```
User: "generate tech rule for React Hooks"    → tech-rule react-hooks
User: "create technical constraint"           → (ask for tech point)
User: "add threading guidance"                → tech-rule threading
```

---

### validate {#trigger-validate}

**Primary Keywords:**
- validate
- verify
- check
- confirm
- test

**Secondary Keywords:**
- CLAUDE.md
- documentation
- consistency
- validity

**Phrases:**
- "validate CLAUDE.md"
- "verify documentation"
- "check documentation consistency"
- "validate project guide"

**Examples:**
```
User: "validate CLAUDE.md"                    → validate
User: "verify documentation"                  → validate
User: "check if CLAUDE.md is valid"           → validate
```

---

## Keyword Matching Rules

### Priority Order

1. **Exact phrase match** - Highest priority
2. **Primary keyword + context** - High priority
3. **Primary keyword only** - Medium priority
4. **Secondary keyword combinations** - Lower priority
5. **Fuzzy match** - Lowest priority (with confirmation)

### Ambiguity Resolution

When input is ambiguous:

1. **Ask clarifying question** with multiple choice options
2. **Provide context** for each option
3. **Wait for user confirmation** before proceeding

**Example:**
```
User: "update documentation"

Ambiguity: Could mean "refresh" or "analyze --fix"

Response: "Did you mean:
  [1] Refresh - Sync CLAUDE.md with current project structure
  [2] Analyze with fix - Review and improve CLAUDE.md quality"
```

### Fuzzy Matching

For misspellings or partial matches:

1. **Detect similarity** using edit distance
2. **Confirm with user** before proceeding
3. **Suggest corrections** if confidence is high

**Example:**
```
User: "genrate CLAUDE.md"

Detection: Similar to "generate CLAUDE.md"

Response: "Did you mean 'generate CLAUDE.md'? [Y/n]"
```

---

## Adding New Keywords

When adding support for new trigger keywords:

1. **Add to appropriate operation section** above
2. **Update this table** in `anchors.md` with new anchor
3. **Consider ambiguity** with existing keywords
4. **Test matching** against common inputs
5. **Update examples** if needed

---

## Keyword Testing

Test these scenarios:

| Input | Expected Operation | Confidence |
|-------|-------------------|------------|
| "generate CLAUDE.md" | generate | High |
| "create project documentation" | generate | High |
| "refresh documentation" | refresh | High |
| "analyze CLAUDE.md" | analyze | High |
| "generate tech rule for hooks" | tech-rule | High |
| "validate documentation" | validate | High |
| "update docs" | Ambiguous | Low (ask) |
| "fix documentation" | analyze --fix | Medium |
| "add rule" | tech-rule | Medium (ask tech point) |

---

## Handoff

When implementing trigger keyword matching:
1. Use this document as the single source of truth
2. Implement priority order for matching
3. Handle ambiguity with user confirmation
4. Add new keywords to appropriate sections
5. Keep examples up to date
6. Test against common user inputs
