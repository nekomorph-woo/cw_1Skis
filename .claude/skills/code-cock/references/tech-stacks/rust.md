# Rust - Technology Stack Guide

## Purpose

Technology-specific guidance for Rust development workflows. Use this as a supplement to core templates when working with Rust projects.

## Technology Detection {#rust-detection}

**Detect Rust when:**
- `Cargo.toml` exists
- `src/main.rs` or `src/lib.rs` entry point
- `*.rs` source files
- `rust-toolchain.toml`

**Rust Version Detection:**
```toml
# Cargo.toml
[package]
name = "project"
version = "0.1.0"
edition = "2021"  # Detected: Rust 2021 edition
```

---

## Auto-Inferred Constraint Files {#rust-constraints}

Based on Rust detection, suggest these `agent_docs/tech_guidance` files:

| File | Description |
|------|-------------|
| `rust-ownership-rules.md` | Ownership, borrowing, lifetimes |
| `rust-error-handling-rules.md` | Result, Option, error propagation |
| `rust-async-rules.md` | Async/await, tokio, futures |
| `rust-unsafe-rules.md` | Unsafe code guidelines, FFI |
| `rust-testing-rules.md` | Unit tests, integration tests, property testing |

---

## Mode Configuration {#rust-modes}

### Single-Stack (Backend/Systems)

**Mode A: Backend / Core Logic**
- **Trigger:** Working on `src/`, `*.rs` files
- **File Extensions:** `*.rs`
- **Workflow:** TDD (Test-Driven Development)
- **Testing Framework:** Built-in `#[test]` + `proptest` for property testing

**Layer Organization:**
- API Layer: Public interfaces, structs, enums
- Domain Layer: Business logic, domain models
- Infrastructure Layer: Database, I/O, external services
- Error Layer: Error types, Result aliases

---

## Project Structure Patterns

### Standard Rust Binary

```
project-root/
├── src/
│   ├── main.rs              # Binary entry point
│   ├── lib.rs               # Library exports
│   ├── api/                 # Public API
│   │   ├── mod.rs
│   │   └── handlers.rs
│   ├── domain/              # Domain logic
│   │   ├── mod.rs
│   │   └── models.rs
│   ├── infrastructure/      # External dependencies
│   │   ├── mod.rs
│   │   └── database.rs
│   └── error/               # Error types
│       ├── mod.rs
│       └── result.rs
├── tests/                   # Integration tests
│   └── integration_test.rs
├── Cargo.toml
├── rust-toolchain.toml      # Toolchain specification
└── rustfmt.toml             # Formatting config
```

### Rust Web Service (Actix/Axum)

```
project-root/
├── src/
│   ├── main.rs              # Server setup
│   ├── handlers/            # HTTP handlers
│   │   ├── mod.rs
│   │   ├── user_handler.rs
│   │   └── health_handler.rs
│   ├── services/            # Business logic
│   │   ├── mod.rs
│   │   └── user_service.rs
│   ├── repositories/        # Data access
│   │   ├── mod.rs
│   │   └── user_repository.rs
│   ├── models/              # Domain models
│   │   ├── mod.rs
│   │   ├── user.rs
│   │   └── error.rs
│   └── config/              # Configuration
│       ├── mod.rs
│       └── app_config.rs
├── migrations/              # Database migrations
├── tests/                   # Integration tests
├── Cargo.toml
└── .env.example
```

---

## Rust-Specific Standards

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Crate | `snake_case` | `my_crate` |
| Module | `snake_case` | `user_service`, `database` |
| Type/Struct | `PascalCase` | `UserService`, `DatabaseConfig` |
| Function | `snake_case` | `get_user`, `validate_input` |
| Constant | `SCREAMING_SNAKE_CASE` | `MAX_RETRIES`, `DEFAULT_TIMEOUT` |
| Lifetime | Short, lowercase | `'a`, `'ctx`, `'data` |
| Generic Type | Short, uppercase | `T`, `U`, `E` |

### Code Style Guidelines

```rust
// ✅ Good: Idiomatic Rust with proper error handling
use anyhow::{Context, Result};

pub struct UserService<R> {
    repository: R,
}

impl<R> UserService<R>
where
    R: UserRepository,
{
    pub fn new(repository: R) -> Self {
        Self { repository }
    }

    pub fn get_user(&self, id: &str) -> Result<User> {
        let user = self
            .repository
            .find_by_id(id)
            .context("Failed to find user")?
            .ok_or_else(|| anyhow::anyhow!("User not found: {}", id))?;

        Ok(user)
    }
}
```

```rust
// ❌ Bad: Non-idiomatic Rust
pub struct UserService {
    repo: Box<dyn UserRepository>,  // ❌ Unnecessary boxing
}

impl UserService {
    pub fn get_user(&self, id: &str) -> Option<User> {  // ❌ No error context
        self.repo.find_by_id(id).ok()  // ❌ Loses error information
    }
}
```

---

## Error Handling Standards

### Result and Option

```rust
// ✅ Good: Proper error handling with context
use anyhow::{Context, Result, anyhow};

pub fn process_user(id: &str) -> Result<User> {
    let user = find_user(id)
        .context("Failed to find user")?;

    if !user.is_active {
        return Err(anyhow!("User is not active: {}", id));
    }

    Ok(user)
}

// Early return with ?
pub fn validate_user(user: &User) -> Result<()> {
    validate_email(&user.email)
        .context("Invalid email")?;

    validate_age(user.age)
        .context("Invalid age")?;

    Ok(())
}

// Option handling
pub fn find_user_by_id(id: u32) -> Option<User> {
    USERS.iter().find(|u| u.id == id).cloned()
}

// Combing Option with Result
pub fn get_user_email(id: u32) -> Result<String> {
    let user = find_user_by_id(id)
        .ok_or_else(|| anyhow!("User not found: {}", id))?;

    Ok(user.email)
}
```

---

## Testing Standards

### Unit Tests

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use anyhow::Result;

    #[test]
    fn test_get_user_success() -> Result<()> {
        let user = User::new("123", "John", "john@example.com");
        let service = UserService::new(MockRepository::with_user(user.clone()));

        let result = service.get_user("123")?;

        assert_eq!(result.id, "123");
        assert_eq!(result.name, "John");

        Ok(())
    }

    #[test]
    fn test_get_user_not_found() {
        let service = UserService::new(MockRepository::empty());

        let result = service.get_user("999");

        assert!(result.is_err());
        assert_eq!(
            result.unwrap_err().to_string(),
            "User not found: 999"
        );
    }

    #[test]
    fn test_get_user_empty_id() {
        let service = UserService::new(MockRepository::empty());

        let result = service.get_user("");

        assert!(result.is_err());
    }
}
```

---

## Async Patterns

### Tokio Async

```rust
// ✅ Good: Proper async patterns with tokio
use tokio::time::{timeout, Duration};

pub async fn fetch_user_with_timeout(
    client: &Client,
    id: &str,
) -> Result<User> {
    let operation = async {
        let response = client
            .get(&format!("/users/{}", id))
            .send()
            .await
            .context("Failed to send request")?;

        if !response.status().is_success() {
            return Err(anyhow!("Request failed with status: {}", response.status()));
        }

        response
            .json::<User>()
            .await
            .context("Failed to parse response")
    };

    timeout(Duration::from_secs(5), operation)
        .await
        .context("Request timed out")?
}
```

---

## Build Commands

### Cargo

```bash
# Build
cargo build
cargo build --release

# Run
cargo run
cargo run --bin server

# Test
cargo test
cargo test --test integration_test
cargo test -- --nocapture  # Show print output
cargo test -- --ignored     # Run ignored tests

# Test with coverage
cargo install cargo-tarpaulin
cargo tarpaulin --out Html

# Check (faster than build)
cargo check

# Format
cargo fmt
cargo fmt -- --check  # Check only

# Lint
cargo clippy
cargo clippy -- -D warnings  # Treat warnings as errors

# Update dependencies
cargo update

# Clean
cargo clean

# Document
cargo doc --open
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Build | `cargo build` |
| Build release | `cargo build --release` |
| Run | `cargo run` |
| Test | `cargo test` |
| Check | `cargo check` |
| Format | `cargo fmt` |
| Lint | `cargo clippy` |
| Update deps | `cargo update` |
| Clean | `cargo clean` |
| Docs | `cargo doc --open` |

---

## Common Pitfalls

### 1. String Allocations

```rust
// ❌ Bad: Unnecessary allocations
fn process(name: &str) -> String {
    format!("Hello, {}", name)  // Allocates new String
}

// ✅ Good: Return &str or use Cow
fn process(name: &str) -> &str {
    name  // No allocation
}

// Or use Cow for conditional ownership
use std::borrow::Cow;

fn process(input: &str) -> Cow<'_, str> {
    if needs_processing(input) {
        Cow::Owned(format!("Processed: {}", input))
    } else {
        Cow::Borrowed(input)
    }
}
```

### 2. Clone Instead of Borrow

```rust
// ❌ Bad: Unnecessary clone
fn process_user(user: &User) -> Result<String> {
    let id = user.id.clone();  // ❌ Unnecessary clone
    Ok(id)
}

// ✅ Good: Borrow instead
fn process_user(user: &User) -> Result<&str> {
    Ok(&user.id)
}
```

### 3. Unwrapped Values

```rust
// ❌ Bad: Using unwrap() in production code
let user = repository.find_by_id("123").unwrap();

// ✅ Good: Proper error handling
let user = repository
    .find_by_id("123")
    .context("Failed to find user")?;
```

---

## Ownership and Borrowing

### Common Patterns

```rust
// ✅ Good: Proper ownership transfer
pub struct User {
    id: String,
    name: String,
}

impl User {
    pub fn new(id: String, name: String) -> Self {
        Self { id, name }
    }

    // Borrow self immutably
    pub fn id(&self) -> &str {
        &self.id
    }

    // Borrow self mutably
    pub fn rename(&mut self, name: String) {
        self.name = name;
    }

    // Consume self
    pub fn into_parts(self) -> (String, String) {
        (self.id, self.name)
    }
}
```

---

## Integration with CLAUDE.md

### Knowledge Base Indexing

Add to **Tech Constraints** table:

```markdown
| `agent_docs/tech_guidance/rust-ownership-rules.md` | Ownership, borrowing, lifetimes |
| `agent_docs/tech_guidance/rust-error-handling-rules.md` | Result, Option, error propagation |
| `agent_docs/tech_guidance/rust-async-rules.md` | Async/await, tokio, futures |
| `agent_docs/tech_guidance/rust-testing-rules.md` | Unit tests, integration tests, property testing |
```

### Self-Verification Loop

```markdown
- [ ] Rust: [OK/Unclear] - Checked `agent_docs/tech_guidance/rust-*-rules.md`?
- [ ] Ownership: [Yes/No] - Proper ownership and borrowing?
- [ ] Error Handling: [Yes/No] - Using Result with context?
- [ ] Clippy: [Yes/No] - No clippy warnings?
- [ ] Tests: [Yes/No] - Adequate test coverage?
```

---

## Additional Resources

- **Rust Documentation:** https://doc.rust-lang.org/
- **The Rust Book:** https://doc.rust-lang.org/book/
- **Rust by Example:** https://doc.rust-lang.org/rust-by-example/
- ** anyhow: https://docs.rs/anyhow/
- **tokio:** https://tokio.rs/
