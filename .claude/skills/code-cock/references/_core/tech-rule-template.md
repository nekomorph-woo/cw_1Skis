# Technical Rule Template

## Purpose

Template for generating technical rule documents in `cock-docs/tech-guidance/`. These documents define technology-specific constraints and best practices for CLAUDE.md integration.

---

## Template Structure

```markdown
# [Technology Point] Technical Constraints

## 1. Axioms {#rule-axioms}

- **Status**: [Stable/Experimental/Deprecated]
- **Core Principle**: [One sentence summary of the fundamental rule]
- **Rationale**: [Why this rule exists - common pitfalls it prevents]

## 2. Mapping Rules {#rule-mapping}

| Category | ❌ Forbidden (Strict Ban) | ✅ Required (Pattern) |
|:---------||:---|:---|
| [Category 1] | `[Bad pattern example]` | `[Good pattern example]` |
| [Category 2] | `[Bad pattern example]` | `[Good pattern example]` |
| [Category 3] | `[Bad pattern example]` | `[Good pattern example]` |

## 3. Critical Snippets {#rule-snippets}

### ✅ Good Pattern

```[language]
// [Description of good pattern]
[code example demonstrating the correct approach]
```

### ❌ Bad Pattern

```[language]
// [Description of bad pattern - what to avoid]
[code example showing the problematic approach]
```

### Common Pitfalls

```[language]
// ❌ Pitfall: [Description]
[code]

// ✅ Fix: [Description]
[code]
```

## 4. How-to Verification {#rule-verification}

### Code Review Checklist

- [ ] [Check 1: What to look for]
- [ ] [Check 2: What to look for]
- [ ] [Check 3: What to look for]

### Automated Checks

```bash
# [Command to run automated linter/checker]
[Expected output]
```

### Testing Requirements

- [ ] [Test requirement 1]
- [ ] [Test requirement 2]

## 5. Integration (CLAUDE.md 集成) {#rule-integration}

### Knowledge Base Indexing

Add this entry to the **Tech Constraints** table in `## 3. 📚 Knowledge Base Indexing`:

```markdown
| `cock-docs/tech-guidance/[filename].md` | [Brief description] |
```

### Context Switch Rules

If this rule applies to a specific Mode, add reference:

```markdown
### Mode [X]: [Mode Name]
- **Constraint:** Follow `cock-docs/tech-guidance/[filename].md`
```

### Self-Verification Loop

Add to `## 8. 🤔 Self-Verification Loop`:

```markdown
- [ ] [Technology Point]: [OK/Unclear] - Checked `cock-docs/tech-guidance/[filename].md`?
```

## 6. Examples (示例)

### Scenario 1: [Common use case]

```[language]
// Before (Problematic)
[code]

// After (Correct)
[code]
```

### Scenario 2: [Another common use case]

```[language]
// Before (Problematic)
[code]

// After (Correct)
[code]
```

## 7. References (参考)

- [Official Documentation Link 1]
- [Official Documentation Link 2]
- [Related tech-guidance file]
- [Community best practice link]

---
```

---

## Technology-Specific Variations

### For UI Framework Rules

**Additional Sections:**
- Component Lifecycle Rules
- State Management Patterns
- Performance Optimization
- Accessibility Requirements

### For Threading/Concurrency Rules

**Additional Sections:**
- Thread Safety Guarantees
- Synchronization Primitives
- Deadlock Prevention
- Performance Considerations

### For Database/ORM Rules

**Additional Sections:**
- Query Optimization
- Transaction Boundaries
- N+1 Prevention
- Connection Management

### For API/HTTP Rules

**Additional Sections:**
- Endpoint Design
- Error Response Format
- Versioning Strategy
- Authentication/Authorization

---

## Example: React Hooks Rules

```markdown
# React Hooks Technical Constraints

## 1. Axioms (不可违背的公理)

- **Status**: Stable
- **Core Principle**: Hooks must be called in the same order every time a component renders
- **Rationale**: React relies on call order to associate hooks with component state

## 2. Mapping Rules (规则映射)

| Category | ❌ Forbidden (Strict Ban) | ✅ Required (Pattern) |
|:---------|:---|:---|
| Hook Placement | Inside loops, conditions, or nested functions | Only at the top level of functions |
| State Updates | `setState(count++)` | `setState(prev => prev + 1)` |
| Effect Dependencies | Missing dependencies | Include all referenced values |
| Custom Hooks | No `use` prefix | Name must start with `use` |

## 3. Critical Snippets (核心代码范式)

### ✅ Good Pattern

```tsx
// Always use dependency array
useEffect(() => {
  const subscription = props.source.subscribe();
  return () => subscription.unsubscribe();
}, [props.source]); // ✅ Props specified as dependency
```

### ❌ Bad Pattern

```tsx
// Missing dependency
useEffect(() => {
  const subscription = props.source.subscribe();
  return () => subscription.unsubscribe();
}); // ❌ No dependency array
```

## 4. Verification (如何验证)

### Code Review Checklist

- [ ] Hooks called at top level (not inside conditions/loops)
- [ ] Custom hooks named with `use` prefix
- [ ] Effect dependencies include all referenced values
- [ ] State updates use functional form when deriving from previous state

### Automated Checks

```bash
npm run lint
npm run test
```

## 5. Integration (CLAUDE.md 集成)

### Knowledge Base Indexing

```markdown
| `cock-docs/tech-guidance/react-hooks-rules.md` | React Hooks usage rules and ESLint configuration |
```
```

---

## Handoff

When generating technical rule documents:

1. **Use this template** as the starting point
2. **Fill in all sections** with technology-specific content
3. **Provide concrete examples** for both good and bad patterns
4. **Include verification methods** (manual checklist + automated checks)
5. **Update CLAUDE.md** integration sections with correct references
6. **Add to anchors.md** if creating new cross-document references
7. **Run refresh operation** to update Knowledge Base Indexing
