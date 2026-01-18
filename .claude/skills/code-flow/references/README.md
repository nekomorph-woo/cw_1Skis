# Technology Stack Guides

This directory contains technology-specific guides for the code-flow skill. Use these guides as supplements to the core templates when working with different technology stacks.

## Directory Structure

```
references/
├── _core/              # Universal templates (always use these)
│   ├── anchors.md              # Cross-document anchor definitions
│   ├── trigger-keywords.md    # Unified trigger keyword management
│   ├── tech-commands.md        # Unified technology stack commands
│   ├── context-management.md   # Document context management rules
│   ├── code-insight.md         # Code exploration template
│   ├── feature-design.md       # Feature design template
│   ├── writing-plans.md        # Implementation plan template
│   ├── executing-plans.md      # Plan execution guide
│   ├── code-review.md          # Code review guide
│   ├── save-context.md         # Session context saving
│   ├── commit-change-log.md    # Commit summarization
│   ├── commit-migration.md     # Migration plan generation
│   └── git-commit.md           # Git commit message generator
├── backend/           # Backend technology-specific guides
├── frontend/          # Frontend technology-specific guides
├── mobile/            # Mobile development guides
└── fullstack/         # Full-stack framework guides
```

> **Note:** The `_core/` directory contains unified reference documents that are used across all sub-skills:
> - `anchors.md` - Single source of truth for cross-document anchor definitions
> - `trigger-keywords.md` - Single source of truth for sub-skill trigger keywords
> - `tech-commands.md` - Single source of truth for technology-specific commands

---

## Technology Stack Detection

When using code-flow, the skill will automatically detect your project's technology stack and reference the appropriate guide:

### Backend Detection

| Technology | Detection Signals |
|------------|-------------------|
| Java/Spring Boot | `pom.xml`, `build.gradle`, `@SpringBootApplication` |
| Node.js/Express | `package.json` with express, `server.js` or `app.js` |
| Python/Django | `manage.py`, `settings.py`, `requirements.txt` with Django |
| Python/FastAPI | `main.py` with FastAPI, pydantic models |
| Go/Gin | `go.mod`, `main.go` with gin framework |

### Frontend Detection

| Technology | Detection Signals |
|------------|-------------------|
| React | `package.json` with react, `.jsx` files, `src/App.js` |
| Vue | `package.json` with vue, `.vue` files, `src/App.vue` |
| Angular | `angular.json`, `.component.ts` files |
| Next.js | `next.config.js`, `app/` or `pages/` directory |
| Nuxt.js | `nuxt.config.ts`, `pages/` directory |

### Mobile Detection

| Technology | Detection Signals |
|------------|-------------------|
| React Native | `package.json` with react-native, `ios/` and `android/` folders |
| Flutter | `pubspec.yaml`, `lib/main.dart` |

### Full-Stack Detection

| Technology | Detection Signals |
|------------|-------------------|
| MERN | Backend: Express + Mongo / Frontend: React |
| MEAN | Backend: Express + Mongo / Frontend: Angular |
| T3 Stack | `next.config.js`, tRPC, TypeScript, Tailwind |

---

## How to Use These Guides

1. **Core templates in `_core/` are universal** - They apply to all technologies
2. **Technology-specific guides supplement the core** - They provide language/framework-specific commands and patterns
3. **Auto-detection** - The skill will detect your tech stack and reference the appropriate guide
4. **Manual selection** - You can also explicitly specify a technology when invoking sub-skills

---

## Backend Guides

### Java / Spring Boot
- Maven/Gradle build commands
- Spring Boot project structure
- Service layer patterns
- MyBatis/JPA usage

### Node.js / Express (Pure JavaScript)
- npm/yarn/pnpm package management
- Express middleware patterns
- Mongoose ODM for MongoDB
- Common Node.js patterns

### Python / Django
- Django project structure
- Models, Views, Templates (MVT)
- Django ORM and migrations
- Management commands

### Python / FastAPI
- FastAPI project structure
- Pydantic schemas
- Async/await patterns
- Dependency injection

### Go / Gin
- Go modules and project structure
- Gin framework patterns
- GORM for database
- Standard lib HTTP server

---

## Frontend Guides

### React
- Component-based architecture
- Hooks (useState, useEffect, custom hooks)
- State management (Context, Zustand, Redux)
- React Router
- Vite or CRA build

### Vue
- Single File Components (.vue)
- Composition API (script setup)
- Pinia state management
- Vue Router
- Options API vs Composition API

### Angular
- TypeScript components
- Services and Dependency Injection
- RxJS observables
- Modules and Lazy loading
- Angular CLI

### Next.js (React SSR)
- App Router and Pages Router
- Server components
- API routes
- SSR and SSG
- Image optimization

### Nuxt.js (Vue SSR)
- File-based routing
- Auto-imports
- Server modules
- Pinia integration

---

## Mobile Guides

### React Native
- Native components
- Navigation (React Navigation)
- Platform-specific code
- Expo vs CLI

### Flutter
- Dart language basics
- Widget composition
- State management (Provider, Riverpod)
- Platform channels

---

## Full-Stack Guides

### MERN Stack
- MongoDB + Express + React + Node
- Monorepo structure
- Shared TypeScript types
- Full-stack CRUD example

### MEAN Stack
- MongoDB + Express + Angular + Node
- Angular CLI patterns
- Full-stack patterns

### T3 Stack
- TypeScript + tRPC + Tailwind + Next.js
- Type-safe APIs
- Server components
- Prisma ORM

---

## Quick Reference Matrix

> **For complete command reference, see:** `_core/tech-commands.md`

**Quick summary for common technologies:**

| Technology | Install | Dev Server | Build | Test | Lint |
|------------|---------|------------|-------|------|------|
| Java Spring | `mvn install` | `mvn spring-boot:run` | `mvn package` | `mvn test` | - |
| Node Express | `npm install` | `npm start` | N/A | `npm test` | `npm run lint` |
| Python Django | `pip install -r` | `python manage.py runserver` | N/A | `pytest` | `flake8` |
| Python FastAPI | `pip install -r` | `uvicorn main:app --reload` | N/A | `pytest` | `ruff` |
| Go Gin | `go mod download` | `air` | `go build` | `go test` | `golangci-lint` |
| React | `npm install` | `npm run dev` | `npm run build` | `npm test` | `npm run lint` |
| Vue | `npm install` | `npm run dev` | `npm run build` | `npm test` | `npm run lint` |
| Angular | `npm install` | `ng serve` | `ng build` | `ng test` | `ng lint` |
| Next.js | `npm install` | `npm run dev` | `npm run build` | `npm test` | `npm run lint` |

> **See `_core/tech-commands.md` for:**
> - Complete command matrix including Mobile and Full-stack technologies
> - Expected output definitions
> - Special handling notes (Windows UTF-8, virtual environments, etc.)

---

## Language & Encoding

Generate documentation in the USER'S LANGUAGE with UTF-8 encoding. Keep technical terms and code identifiers in original form.
