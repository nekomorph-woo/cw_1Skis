# Git Commit - Commit Message Generator

## Purpose

Generate git commit messages following Conventional Commit format with emoji prefixes. Keep messages concise, focused on most relevant changes, and avoid excessive detail.

## When to Use

- Completed code changes requiring commit
- Need to follow project commit conventions

## Commit Message Format

**Language:** User's language with UTF-8 encoding

**Format:** Conventional Commit with emoji prefix

**Style:**
- Keep concise
- Use bullet points for multiple changes
- Focus on changes most relevant to current goal
- Avoid excessive detail

**CRITICAL:** Use file-based commit method on Windows to ensure UTF-8 encoding and avoid character corruption. **Always delete temporary commit file after commit.**

## Commit Types & Emojis

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
- Use **user's user's language**

### 4. Execute Commit

#### CRITICAL: Use file-based commit method for UTF-8 safety

**Linux / macOS (standard method):**

```bash
git commit -m "✨ feat: Add scene management API
- Implement scene creation endpoint
- Add scene query functionality
- Improve parameter validation"
```

**Windows PowerShell (UTF-8 safe method - 推荐):**

```powershell
# Step 1: Create UTF-8 encoded file
@"
✨ feat: Add scene management API
- Implement scene creation endpoint
- Add scene query functionality
- Improve parameter validation
"@ | Out-File -FilePath commit_msg.txt -Encoding UTF8

# Step 2: Commit using file (ensures UTF-8 encoding)
git commit -F commit_msg.txt

# Step 3: Delete temporary file (CRITICAL cleanup step)
Remove-Item commit_msg.txt
```

**Windows PowerShell (备选):**

```powershell
git commit -m @"
✨ feat: Add scene management API
- Implement scene creation endpoint
- Add scene query functionality
- Improve parameter validation
"@
```

**Important:** After commit, **ALWAYS delete the temporary `commit_msg.txt` file** to avoid cluttering the repository.

**Windows CMD (备选):**

```cmd
# Step 1: Create UTF-8 file with echo
echo ✨ feat: Add scene management API > commit_msg.txt
echo.>> commit_msg.txt
echo - Implement scene creation endpoint >> commit_msg.txt
echo.>> commit_msg.txt
echo.>> commit_msg.txt

# Step 2: Commit using file
git commit -F commit_msg.txt

# Step 3: Delete temporary file
del commit_msg.txt
```

**Cross-platform Bash (备选):**

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

**CRITICAL:** Always review `git diff --cached` before generating message.

**CRITICAL:** On Windows, ALWAYS use file-based commit with UTF-8 encoding to avoid character corruption.

**CRITICAL:** ALWAYS delete temporary `commit_msg.txt` file after commit.

**CRITICAL:** Use **user's language** for commit message content.

**CRITICAL:** Ensure UTF-8 encoding to avoid character corruption in commit messages.
