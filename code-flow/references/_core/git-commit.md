# Git Commit - Commit Message Generator

## Purpose

Generate git commit messages following Conventional Commit format with emoji prefixes. Keep messages concise, focused on most relevant changes, and avoid excessive detail.

## When to Use

- Completed code changes requiring commit
- Need to follow project commit conventions

## Trigger Keywords

> **Complete keyword list:** See `references/_core/trigger-keywords.md` for complete keyword list and routing logic.

**Common phrases that trigger this sub-skill:**
- "commit"
- "commit changes"
- "git commit"
- "create commit message"
- "generate commit"

## Commit Message Format

**Language:** User's language with UTF-8 encoding

**Format:** Conventional Commit with emoji prefix

**Style:**
- Keep concise
- Use bullet points for multiple changes
- Focus on changes most relevant to current goal
- Avoid excessive detail

**⚠️ CRITICAL (Windows):** Use file-based commit method to ensure UTF-8 encoding. **Always delete temporary `commit_msg.txt` file after commit** to avoid repository clutter.

## Commit Types & Emojis {#commit-types}

| Type | Emoji | Description |
|------|-------|-------------|
| feat | ✨ | New feature |
| fix | 🐛 | Bug fix |
| docs | 📝 | Documentation update |
| style | 💄 | Code format adjustment |
| refactor | ♻️ | Code refactoring |
| perf | ⚡ | Performance optimization |
| test | ✅ | Test related |
| chore | 🔧 | Build/toolchain |
| ci | 👷 | CI/CD related |

## Usage

When user requests commit:

### 1. Check Staged Files

```bash
git status
git diff --cached
```

### 2. Analyze Changes

Review diff to understand:
- What was modified
- Primary change type (feat/fix/docs/etc.)
- Most significant changes

### 3. Generate Message

Based on actual changes:
- Use appropriate emoji and type
- List key changes as bullet points
- Focus on most relevant
- Use **user's language**

### 4. Execute Commit {#execute-commit}

#### CRITICAL: Use file-based commit method for UTF-8 safety

**Linux / macOS (standard method):**

```bash
git commit -m "✨ feat: Add scene management API
- Implement scene creation endpoint
- Add scene query functionality
- Improve parameter validation"
```

**Windows Git Bash (Recommended - Cross-platform Compatible):**

> Use Unicode escape sequences `\uXXXX` to handle non-ASCII characters and avoid encoding issues

```bash
# Method 1: Using file (recommended for multi-line messages)
# Unicode escape example: 中文 → \u4e2d\u6587, ✨ → \u2728
printf '\u2728 feat: Add scene management API\n' > commit_msg.txt
printf '- Implement scene creation endpoint\n' >> commit_msg.txt
printf '- Add scene query functionality\n' >> commit_msg.txt
printf '- Improve parameter validation\n' >> commit_msg.txt
git commit -F commit_msg.txt
rm commit_msg.txt
```

```bash
# Method 2: Using pipe (recommended for single-line messages)
printf '\u2728 feat: Add scene management API\n' | git commit -F -
```

**Common Unicode Escape Sequences:**

| Character | Unicode Escape | Description |
|-----------|----------------|-------------|
| ✨ | `\u2728` | sparkles |
| 🐛 | `\u1f41b` | bug |
| 📝 | `\u1f4dd` | memo |
| 💄 | `\u1f484` | lipstick |
| ♻️ | `\u267b\ufe0f` | recycle |
| ⚡ | `\u26a1` | high voltage |
| ✅ | `\u2705` | check mark |
| 🔧 | `\u1f527` | wrench |
| 👷 | `\u1f477` | construction worker |

> **Note:** Search online for "Unicode escape converter" or "character to Unicode" to find escape sequences for any character

**跨平台 Bash (标准方式 - 适用于非中文场景):**

```bash
# Step 1: Create file
cat > commit_msg.txt << 'EOF'
✨ feat: Add scene management API
- Implement scene creation endpoint
- Add scene query functionality
- Improve parameter validation
EOF

# Step 2: Commit using file
git commit -F commit_msg.txt

# Step 3: Delete temporary file
rm commit_msg.txt
```

## Examples

### Feature

```
✨ feat: Add scene management API
- Implement scene creation endpoint
- Add scene query functionality
- Improve parameter validation
```

### Bugfix

```
🐛 fix: Fix scene conversion armed/disarmed action issue
- Correct enum value mapping logic
- Update action type judgment
```

### Refactor

```
♻️ refactor: Refactor scene service layer
- Extract common methods to base class
- Optimize method naming
- Reduce code duplication
```

## Quick Reference

### Technology-Specific Commit Patterns

**Java / Spring Boot:**

```
✨ feat: Add user management REST API
- Implement UserCrudController with CRUD endpoints
- Add UserService with business logic
- Add UserRepository with JPA entity
```

**Node.js / Express:**

```
✨ feat: Add authentication middleware
- Implement JWT token validation
- Add login/logout endpoints
- Create user authentication middleware
```

**Python / Django:**

```
✨ feat: Add Django view for data export
- Implement CSV export view
- Add Excel export view
- Add PDF export view
```

**React / Vue / Angular:**

```
✨ feat: Add user profile component
- Implement user profile card component
- Add user settings form
- Add activity timeline component
```

**Go / Gin:**

```
✨ feat: Add user management handlers
- Create user registration endpoint
- Add user list endpoint
- Implement user update endpoint
```

## Important

- Always review `git diff --cached` before generating message
- On Windows, use file-based commit with UTF-8 encoding
- Always delete temporary `commit_msg.txt` file after commit
- Use user's language for commit message content

## Handoff

After successful commit:

"**Commit created:** `[commit-hash]`"

"**Message:** [commit message preview]"

"**Files committed:** [X] files changed, [Y] insertions(+), [Z] deletions(-)"
