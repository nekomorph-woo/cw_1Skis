# Next.js - React Framework Guide

## Purpose

Technology-specific guidance for Next.js (React SSR framework) development workflows.

## Technology Detection

**Detect Next.js when:**
- `next.config.js`
- `pages/` directory (Pages Router) or `app/` directory (App Router)
- `package.json` with `next`
- Special files: `_app.js`, `_document.js`, `_error.js`

---

## Writing Plans - Next.js Specific

### Commands

```bash
# Development
npm run dev

# Build
npm run build

# Start production
npm start

# Lint
npm run lint
```

## Project Structure (App Router)

```
app/
├── layout.tsx
├── page.tsx
├── users/
│   ├── page.tsx
│   └── [id]/
│       └── page.tsx
```

## Quick Reference

| Action | Command |
|--------|---------|
| Dev | `npm run dev` |
| Build | `npm run build` |
| Start | `npm start` |

---

## Additional Resources

- **Next.js Documentation:** https://nextjs.org/docs
