# Go - Technology Stack Guide

## Purpose

Technology-specific guidance for Go development workflows. Use this as a supplement to core templates when working with Go projects.

## Technology Detection {#go-detection}

**Detect Go when:**
- `go.mod` exists
- `main.go` entry point
- `*.go` source files
- `Makefile` with go commands
- Gin, Echo, or standard library `net/http` imports

**Go Version Detection:**
```go
// go.mod
module github.com/example/project

go 1.21  // Detected: Go 1.21
```

---

## Auto-Inferred Constraint Files {#go-constraints}

Based on Go detection, suggest these `cock-docs/tech-guidance` files:

| File | Description |
|------|-------------|
| `go-error-handling-rules.md` | Error wrapping, sentinel errors, error types |
| `go-goroutine-rules.md` | Goroutine usage, WaitGroup, context cancellation |
| `go-interface-rules.md` | Interface design, acceptance interfaces, nil interfaces |
| `go-channel-rules.md` | Channel usage, buffering, select patterns |
| `go-testing-rules.md` | Table-driven tests, test helpers, mocking |

---

## Mode Configuration {#go-modes}

### Single-Stack (Backend)

**Mode A: Backend / Core Logic**
- **Trigger:** Working on `*.go` files
- **File Extensions:** `*.go`
- **Workflow:** TDD (Test-Driven Development)
- **Testing Framework:** Standard `testing` package + `testify/assert`

**Layer Organization:**
- Handler Layer: HTTP handlers, request/response handling
- Service Layer: Business logic, use cases
- Repository Layer: Data access, queries
- Model Layer: Domain models, structs

---

## Project Structure Patterns

### Standard Go Project

```
project-root/
├── cmd/                    # Main applications
│   └── server/
│       └── main.go        # Entry point
├── internal/              # Private application code
│   ├── handler/           # HTTP handlers
│   ├── service/           # Business logic
│   ├── repository/        # Data access
│   └── model/             # Domain models
├── pkg/                   # Public library code
│   └── logger/
├── api/                   # API definitions
│   ├── http/              # HTTP transport
│   └── grpc/              # gRPC definitions
├── config/                # Configuration
├── migrations/            # Database migrations
├── scripts/               # Build and deploy scripts
├── go.mod
├── go.sum
└── Makefile
```

### Go Web Service (Gin)

```
project-root/
├── cmd/
│   └── api/
│       └── main.go       # Gin server setup
├── internal/
│   ├── handler/           # Gin handlers
│   │   ├── user_handler.go
│   │   └── auth_handler.go
│   ├── service/           # Business logic
│   │   ├── user_service.go
│   │   └── auth_service.go
│   ├── repository/        # Data access
│   │   ├── user_repository.go
│   │   └── db.go
│   └── model/             # Domain models
│       ├── user.go
│       └── error.go
├── pkg/                   # Public packages
│   ├── middleware/        # Gin middleware
│   └── response/          # Response helpers
├── config/
│   └── config.go          # Configuration loading
├── go.mod
└── Makefile
```

---

## Go-Specific Standards

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Package | `lowercase`, single word | `user`, `auth`, `handler` |
| Constant | `PascalCase` or `UPPER_SNAKE_CASE` | `MaxRetries`, `MAX_TIMEOUT` |
| Variable | `camelCase` | `userID`, `userName` |
| Function | `PascalCase` (exported), `camelCase` (private) | `GetUser`, `validateInput` |
| Interface | `PascalCase` with `-er` suffix | `Reader`, `Writer`, `UserService` |
| Test Function | `PascalCase` with `Test` prefix | `TestGetUser_Success`, `TestGetUser_NotFound` |

### Code Style Guidelines

```go
// ✅ Good: Idiomatic Go with proper error handling
package service

import (
    "context"
    "fmt"
)

type UserService struct {
    repo UserRepository
    log  Logger
}

func NewUserService(repo UserRepository, log Logger) *UserService {
    return &UserService{
        repo: repo,
        log:  log,
    }
}

func (s *UserService) GetUser(ctx context.Context, id string) (*User, error) {
    if id == "" {
        return nil, fmt.Errorf("user id cannot be empty")
    }

    user, err := s.repo.FindByID(ctx, id)
    if err != nil {
        return nil, fmt.Errorf("failed to find user: %w", err)
    }

    if user == nil {
        return nil, fmt.Errorf("user not found: %s", id)
    }

    return user, nil
}
```

```go
// ❌ Bad: Non-idiomatic Go
func GetUser(id string) (interface{}, error) {  // ❌ Return concrete type
    if id == "" {
        panic("user id cannot be empty")  // ❌ Don't panic in business logic
    }

    user, err := repo.FindByID(id)
    if err != nil {
        return nil, err  // ❌ No error wrapping
    }

    return user, nil
}
```

---

## Error Handling Standards

### Error Wrapping

```go
// ✅ Good: Error wrapping with context
import (
    "errors"
    "fmt"
)

// Sentinel errors
var (
    ErrUserNotFound = errors.New("user not found")
    ErrInvalidInput = errors.New("invalid input")
)

func (s *UserService) GetUser(ctx context.Context, id string) (*User, error) {
    user, err := s.repo.FindByID(ctx, id)
    if err != nil {
        return nil, fmt.Errorf("failed to find user: %w", err)
    }

    if user == nil {
        return nil, ErrUserNotFound  // Return sentinel error
    }

    return user, nil
}

// Check for specific error
user, err := service.GetUser(ctx, id)
if errors.Is(err, ErrUserNotFound) {
    // Handle not found
}
```

---

## Testing Standards

### Table-Driven Tests

```go
package service_test

import (
    "context"
    "testing"

    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/mock"
)

func TestUserService_GetUser(t *testing.T) {
    tests := []struct {
        name        string
        userID      string
        setupMock   func(*MockUserRepository)
        wantUser    *User
        wantErr     error
        errContains string
    }{
        {
            name:   "success - user found",
            userID: "123",
            setupMock: func(m *MockUserRepository) {
                m.On("FindByID", mock.Anything, "123").
                    Return(&User{ID: "123", Name: "John"}, nil)
            },
            wantUser: &User{ID: "123", Name: "John"},
            wantErr:  nil,
        },
        {
            name:   "error - user not found",
            userID: "999",
            setupMock: func(m *MockUserRepository) {
                m.On("FindByID", mock.Anything, "999").
                    Return(nil, ErrUserNotFound)
            },
            wantUser:    nil,
            wantErr:     ErrUserNotFound,
        },
        {
            name:   "error - empty user ID",
            userID: "",
            setupMock: func(m *MockUserRepository) {
                // No mock setup expected
            },
            wantUser:    nil,
            wantErr:     ErrInvalidInput,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            mockRepo := new(MockUserRepository)
            tt.setupMock(mockRepo)

            service := NewUserService(mockRepo, nil)
            user, err := service.GetUser(context.Background(), tt.userID)

            if tt.wantErr != nil {
                assert.Error(t, err)
                if tt.errContains != "" {
                    assert.Contains(t, err.Error(), tt.errContains)
                }
                assert.Nil(t, user)
            } else {
                assert.NoError(t, err)
                assert.Equal(t, tt.wantUser, user)
            }

            mockRepo.AssertExpectations(t)
        })
    }
}
```

---

## Goroutine Patterns

### Context and WaitGroup

```go
// ✅ Good: Proper goroutine management
func (s *Service) ProcessUsers(ctx context.Context, userIDs []string) error {
    var wg sync.WaitGroup
    errCh := make(chan error, len(userIDs))
    sem := make(chan struct{}, 10)  // Limit concurrency

    for _, id := range userIDs {
        wg.Add(1)
        sem <- struct{}{}  // Acquire semaphore

        go func(userID string) {
            defer wg.Done()
            defer func() { <-sem }()  // Release semaphore

            if err := s.processUser(ctx, userID); err != nil {
                errCh <- fmt.Errorf("failed to process user %s: %w", userID, err)
            }
        }(id)
    }

    // Wait for all goroutines to complete
    go func() {
        wg.Wait()
        close(errCh)
    }()

    // Collect errors
    var errors []error
    for err := range errCh {
        errors = append(errors, err)
    }

    if len(errors) > 0 {
        return fmt.Errorf("encountered %d errors: %v", len(errors), errors)
    }

    return nil
}
```

---

## Build Commands

### Makefile

```makefile
# Build
build:
	go build -o bin/server cmd/server/main.go

# Build for all platforms
build-all:
	go build -o bin/server-linux cmd/server/main.go
	GOOS=darwin go build -o bin/server-mac cmd/server/main.go
	GOOS=windows go build -o bin/server.exe cmd/server/main.go

# Run
run:
	go run cmd/server/main.go

# Test
test:
	go test -v ./...

# Test with coverage
test-coverage:
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out

# Lint
lint:
	golangci-lint run

# Format
fmt:
	go fmt ./...
	goimports -w .

# Clean
clean:
	rm -rf bin/

# Install dependencies
deps:
	go mod download
	go mod tidy

# Run with hot reload (using air)
dev:
	air
```

### Command Line

```bash
# Build
go build -o bin/server cmd/server/main.go

# Run
go run cmd/server/main.go

# Test
go test ./...
go test -v ./internal/service
go test -race ./...  # Race detection

# Test with coverage
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out

# Benchmark
go test -bench=. -benchmem

# Format
go fmt ./...
goimports -w .

# Lint
golangci-lint run

# Dependencies
go mod download
go mod tidy
go get -u ./...  # Update all dependencies
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Build | `go build` |
| Run | `go run` |
| Test | `go test ./...` |
| Test with coverage | `go test -coverprofile=coverage.out ./...` |
| Format | `go fmt ./...` |
| Lint | `golangci-lint run` |
| Tidy dependencies | `go mod tidy` |
| Benchmark | `go test -bench=. -benchmem` |

---

## Common Pitfalls

### 1. Goroutine Leaks

```go
// ❌ Bad: Goroutine leak - no way to cancel
func processData(ch <-chan Data) {
    go func() {
        for data := range ch {
            process(data)
        }
    }()
}

// ✅ Good: Use context for cancellation
func processData(ctx context.Context, ch <-chan Data) {
    go func() {
        for {
            select {
            case data := <-ch:
                process(data)
            case <-ctx.Done():
                return  // Clean exit
            }
        }
    }()
}
```

### 2. Nil Interface

```go
// ❌ Bad: Nil interface problem
var err error                     // nil interface value
var result *Result = nil         // nil concrete type
err = result                     // err != nil here!

if err != nil {
    fmt.Println("Error:", err)   // Prints: Error: <nil>
}

// ✅ Good: Return concrete nil
func process() (*Result, error) {
    if failed {
        return nil, fmt.Errorf("failed")
    }
    return nil, nil  // Both are nil
}
```

### 3. Channel Buffering

```go
// ❌ Bad: Unbuffered channel causing deadlock
ch := make(chan int)
ch <- 1  // Deadlock! No receiver

// ✅ Good: Use buffered channel or separate goroutine
ch := make(chan int, 1)
ch <- 1  // OK

// Or
go func() {
    ch <- 1
}()
```

---

## Integration with CLAUDE.md

### Knowledge Base Indexing

Add to **Tech Constraints** table:

```markdown
| `cock-docs/tech-guidance/go-error-handling-rules.md` | Error wrapping, sentinel errors, error types |
| `cock-docs/tech-guidance/go-goroutine-rules.md` | Goroutine usage, WaitGroup, context cancellation |
| `cock-docs/tech-guidance/go-interface-rules.md` | Interface design, acceptance interfaces |
| `cock-docs/tech-guidance/go-testing-rules.md` | Table-driven tests, test helpers |
```

### Self-Verification Loop

```markdown
- [ ] Go: [OK/Unclear] - Checked `cock-docs/tech-guidance/go-*-rules.md`?
- [ ] Error Handling: [Yes/No] - Proper error wrapping and context?
- [ ] Goroutines: [Yes/N/A] - Context and WaitGroup properly used?
- [ ] Tests: [Yes/No] - Table-driven tests with proper setup/teardown?
```

---

## Additional Resources

- **Go Documentation:** https://go.dev/doc/
- **Effective Go:** https://go.dev/doc/effective_go
- **Go by Example:** https://gobyexample.com/
- **testify:** https://github.com/stretchr/testify
