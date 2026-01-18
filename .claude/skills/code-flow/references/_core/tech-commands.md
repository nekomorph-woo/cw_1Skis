# Technology Commands - Unified Technology Stack Command Reference

## Purpose

Define compile, build, test, lint, and verification commands for all supported technology stacks. This serves as the single source of truth for technology-specific commands across all sub-skills.

---

## Backend Commands

| Technology | Install | Dev Server | Build | Test | Lint | Verify |
|------------|---------|------------|-------|------|------|--------|
| **Java/Spring Boot** | `mvn install` | `mvn spring-boot:run` | `mvn package` | `mvn test` | - | `mvn compile -DskipTests` |
| **Node.js/Express** | `npm install` | `npm start` / `npm run dev` | N/A | `npm test` | `npm run lint` | `npm test` |
| **Python/Django** | `pip install -r requirements.txt` | `python manage.py runserver` | N/A | `pytest` | `flake8` | `pytest` |
| **Python/FastAPI** | `pip install -r requirements.txt` | `uvicorn main:app --reload` | N/A | `pytest` | `ruff` | `pytest` |
| **Go/Gin** | `go mod download` | `air` | `go build` | `go test` | `golangci-lint run` | `go build` |

---

## Frontend Commands

| Technology | Install | Dev Server | Build | Test | Lint | Verify |
|------------|---------|------------|-------|------|------|--------|
| **React** | `npm install` | `npm run dev` | `npm run build` | `npm test` | `npm run lint` | `npm run build` |
| **Vue** | `npm install` | `npm run dev` | `npm run build` | `npm run test` | `npm run lint` | `npm run build` |
| **Angular** | `npm install` | `ng serve` | `ng build` | `ng test` | `ng lint` | `ng build` |
| **Next.js** | `npm install` | `npm run dev` | `npm run build` | `npm run test` | `npm run lint` | `npm run build` |
| **Nuxt.js** | `npm install` | `npm run dev` | `npm run build` | `npm run test` | `npm run lint` | `npm run build` |

---

## Mobile Commands

| Technology | Install | Dev Server | Build | Test | Lint | Verify |
|------------|---------|------------|-------|------|------|--------|
| **React Native** | `npm install` | `npx react-native start` | `npx react-native run-ios/android` | `npm test` | `npm run lint` | `npx react-native build` |
| **Flutter** | `flutter pub get` | `flutter run` | `flutter build apk/ipa` | `flutter test` | `flutter analyze` | `flutter build` |

---

## Full-Stack Commands

Full-stack projects combine backend + frontend commands. See individual stack guides:
- `fullstack/mern.md`
- `fullstack/mean.md`
- `fullstack/t3-stack.md`

---

## Command Purpose Definitions

| Command Type | Purpose | Used In Workflow |
|--------------|---------|------------------|
| **Install** | Install dependencies | Project initialization or dependency changes |
| **Dev Server** | Start development server | Local development and debugging |
| **Build** | Build production bundle | Verify code compiles, prepare for deployment |
| **Test** | Run test suite | TDD workflow verification step |
| **Lint** | Code style and quality check | Pre-commit quality verification |
| **Verify** | Verification step | Execute plan verification that code runs |

---

## Expected Output Definitions

| Term | Definition | Examples |
|------|------------|----------|
| `BUILD SUCCESS` | Maven build successful output | `mvn compile -DskipTests` → `BUILD SUCCESS` |
| `tests pass` | All test cases pass | `npm test` → `PASS: 15/15` |
| `build success` | Build process completes without errors | `npm run build` → `built in 1.23s` |
| `BUILD SUCCESSFUL` | Gradle build successful output | `./gradlew build` → `BUILD SUCCESSFUL` |

---

## Special Cases

### Windows PowerShell UTF-8 Encoding

Git commit requires file-based method to ensure UTF-8 encoding. See `git-commit.md` for detailed instructions.

### Node.js Package Managers

```bash
# Choose based on project lockfile
npm install        # package-lock.json exists
npm ci             # CI environment recommended
yarn install       # yarn.lock exists
pnpm install       # pnpm-lock.yaml exists
```

### Python Virtual Environments

```bash
# Activate venv before running commands
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
pip install -r requirements.txt
```

### Go Development Server

```bash
# Air provides hot reload for Go development
go install github.com/cosmtrek/air@latest
air
```

---

## In Sub-Skill Documents

### writing-plans.md

```markdown
## Technology-Specific Commands

> **Complete command reference:** See `tech-commands.md` for all technologies.

**Quick reference for plan writing:**

| Technology | Test Command | Expected Output |
|------------|-------------|-----------------|
| Java/Spring Boot | `mvn test` | Tests pass |
| Node.js/Express | `npm test` | Tests pass |
| Python/Django | `pytest` | Tests pass |
| Python/FastAPI | `pytest` | Tests pass |
| Go/Gin | `go test` | Tests pass |
| React | `npm test` | Tests pass |
| Vue | `npm run test` | Tests pass |
| Angular | `ng test` | Tests pass |
| Next.js | `npm run test` | Tests pass |

> **See `tech-commands.md` for:**
> - Install, Dev Server, Build commands
> - Linting and verification commands
> - Mobile and full-stack commands
> - Special handling (Windows UTF-8, virtual environments)
```

### executing-plans.md

```markdown
## Code Execution Rules

> **Complete command reference:** See `tech-commands.md` for all technologies.

**Quick reference for plan execution:**

| Technology | Verify Command | Expected Output | Commit |
|------------|----------------|-----------------|--------|
| Java/Spring Boot | `mvn compile -DskipTests` | BUILD SUCCESS | `/code-flow git-commit` |
| Node.js/Express | `npm test` | tests pass | `/code-flow git-commit` |
| Python/Django | `pytest` | tests pass | `/code-flow git-commit` |
| Python/FastAPI | `pytest` | tests pass | `/code-flow git-commit` |
| Go/Gin | `go build` | build success | `/code-flow git-commit` |
| React | `npm run build` | build success | `/code-flow git-commit` |
| Vue | `npm run build` | build success | `/code-flow git-commit` |
| Angular | `ng build` | build success | `/code-flow git-commit` |
| Next.js | `npm run build` | build success | `/code-flow git-commit` |

> **See `tech-commands.md` for:**
> - Complete command matrix (Install, Dev Server, Test, Lint, etc.)
> - All supported technologies
> - Special handling notes
```

### code-review.md

```markdown
## Compilation Check (P0) - CRITICAL

> **Complete command reference:** See `tech-commands.md` for all technologies.

| Technology | Verify Command |
|------------|----------------|
| Java/Spring Boot | `mvn compile -DskipTests` |
| Node.js/Express | `npm run build` |
| Python/Django | `python -m py_compile *.py` or `python manage.py check` |
| Python/FastAPI | `python -m py_compile *.py` |
| Go/Gin | `go build` |
| React/Vue/Angular/Next.js/Nuxt.js | `npm run build` |
```

---

## Language Convention

All documentation, comments, and commit messages use **<user's language>** with UTF-8 encoding. Technical terms and code identifiers remain in their original form.

## Handoff

All sub-skill documents that reference technology-specific commands should reference this document to ensure consistency and maintainability.
