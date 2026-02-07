# Topic Name Generation

## Purpose

Define rules for converting user input into kebab-case topic directory names.

## Generation Process

1. **Extract Core Concept**: 2-5 words from user input
2. **Translate to English**: Convert to English equivalent
3. **Convert to kebab-case**: Lowercase, spaces → hyphens
4. **Validate**: Max 50 chars, no reserved words

## Examples

| User Input | Core Concept | English | kebab-case |
|------------|--------------|---------|------------|
| "项目对齐" | 项目对齐 | project alignment | project-alignment |
| "Go vs Rust" | Go Rust 对比 | Go Rust comparison | go-rust-comparison |
| "招聘决定" | 招聘决定 | hiring decision | hiring-decision |

## Duplicate Handling

If directory exists:
```
project-alignment → project-alignment-2 → project-alignment-3...
```

## Reserved Words

Cannot use: `new`, `current`, `all`, `list`, `index`, `help`, `config`, `settings`
