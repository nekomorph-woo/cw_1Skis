# Go / Gin - Backend Development Guide

## Purpose

Technology-specific guidance for Go and Gin framework development workflows. Use this as a supplement to core templates when working with Go backend projects.

## Technology Detection

**Detect Go/Gin when:**
- `go.mod` exists
- `main.go` entry point
- Gin import: `github.com/gin-gonic/gin`
- Go package structure
- `.go` files with `package` declaration

---

## Project Structure

```
project-root/
├── cmd/
│   └── server/
│       └── main.go         # Entry point
├── internal/
│   ├── api/                # HTTP handlers (controllers)
│   │   ├── handlers/       # Request handlers
│   │   ├── middleware/     # Gin middleware
│   │   └── routes/          # Route definitions
│   ├── service/            # Business logic
│   ├── repository/         # Data access (DAO)
│   ├── model/              # Data models
│   └── dto/                # Data Transfer Objects
├── pkg/                    # Public packages
│   ├── config/             # Configuration
│   ├── database/           # DB connection
│   └── utils/              # Utilities
├── migrations/             # Database migrations
├── configs/                # Configuration files
├── go.mod                  # Go modules
├── go.sum                  # Dependencies checksum
├── Makefile                # Build commands
└── .air.toml               # Air hot reload config
```

---

## Writing Plans - Go/Gin Specific

### Install & Run

```bash
# Download dependencies
go mod download

# Run development server with hot reload (using Air)
air

# Run without hot reload
go run cmd/server/main.go

# Build
go build -o bin/server cmd/server/main.go

# Run built binary
./bin/server

# Run on specific port
PORT=8080 go run cmd/server/main.go
```

### Test Commands

```bash
# Run all tests
go test ./...

# Run tests with verbose output
go test -v ./...

# Run tests in specific package
go test ./internal/service/...

# Run tests with coverage
go test -cover ./...

# Generate coverage report
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

### Build Commands

```bash
# Build for current platform
go build -o bin/server cmd/server/main.go

# Build for Linux
GOOS=linux go build -o bin/server-linux cmd/server/main.go

# Build for Windows
GOOS=windows go build -o bin/server.exe cmd/server/main.go

# Build for macOS
GOOS=darwin go build -o bin/server-mac cmd/server/main.go

# Build with optimizations
go build -ldflags="-s -w" -o bin/server cmd/server/main.go
```

---

## Executing Plans - Go/Gin Specific

### File Conventions

| Type | Convention | Example |
|------|------------|---------|
| Handler | `handlers/*_handler.go` | `user_handler.go` |
| Service | `service/*_service.go` | `user_service.go` |
| Repository | `repository/*_repo.go` | `user_repo.go` |
| Model | `model/*.go` | `user.go` |
| DTO | `dto/*.go` | `user_dto.go` |
| Middleware | `middleware/*.go` | `auth.go` |

### Code Style Guidelines

```go
// main.go - Entry point
package main

import (
    "log"
    "my-project/internal/api/routes"
    "my-project/pkg/config"
    "my-project/pkg/database"

    "github.com/gin-gonic/gin"
)

func main() {
    // Load configuration
    cfg := config.Load()

    // Initialize database
    db := database.Connect(cfg.Database)
    database.Migrate(db)

    // Setup Gin
    if cfg.Environment == "production" {
        gin.SetMode(gin.ReleaseMode)
    }

    r := gin.Default()

    // Setup routes
    routes.Setup(r, db)

    // Start server
    log.Printf("Server starting on port %s", cfg.Port)
    r.Run(":" + cfg.Port)
}

// routes/routes.go - Route setup
package routes

import (
    "my-project/internal/api/handlers"
    "my-project/internal/api/middleware"

    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

func Setup(r *gin.Engine, db *gorm.DB) {
    // Middleware
    r.Use(middleware.CORS())
    r.Use(middleware.Logger())

    // Health check
    r.GET("/health", func(c *gin.Context) {
        c.JSON(200, gin.H{"status": "ok"})
    })

    // API v1
    v1 := r.Group("/api/v1")
    {
        // Initialize handlers
        userHandler := handlers.NewUserHandler(db)
        userRoutes := v1.Group("/users")
        {
            userRoutes.GET("", userHandler.GetUsers)
            userRoutes.GET("/:id", userHandler.GetUserByID)
            userRoutes.POST("", userHandler.CreateUser)
            userRoutes.PUT("/:id", userHandler.UpdateUser)
            userRoutes.DELETE("/:id", userHandler.DeleteUser)
        }
    }
}

// handlers/user_handler.go - Request handlers
package handlers

import (
    "my-project/internal/service"
    "my-project/internal/dto"
    "net/http"
    "strconv"

    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

type UserHandler struct {
    userService *service.UserService
}

func NewUserHandler(db *gorm.DB) *UserHandler {
    return &UserHandler{
        userService: service.NewUserService(db),
    }
}

func (h *UserHandler) GetUsers(c *gin.Context) {
    page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
    limit, _ := strconv.Atoi(c.DefaultQuery("limit", "10"))

    users, total, err := h.userService.GetUsers(page, limit)
    if err != nil {
        c.JSON(500, gin.H{"error": err.Error()})
        return
    }

    c.JSON(200, gin.H{
        "data": users,
        "total": total,
        "page": page,
        "limit": limit,
    })
}

func (h *UserHandler) CreateUser(c *gin.Context) {
    var req dto.CreateUserRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(400, gin.H{"error": err.Error()})
        return
    }

    user, err := h.userService.CreateUser(&req)
    if err != nil {
        c.JSON(400, gin.H{"error": err.Error()})
        return
    }

    c.JSON(201, gin.H{"data": user})
}

// service/user_service.go - Business logic
package service

import (
    "errors"
    "my-project/internal/model"
    "my-project/internal/repository"
    "my-project/internal/dto"

    "gorm.io/gorm"
)

type UserService struct {
    userRepo *repository.UserRepository
}

func NewUserService(db *gorm.DB) *UserService {
    return &UserService{
        userRepo: repository.NewUserRepository(db),
    }
}

func (s *UserService) GetUsers(page, limit int) ([]model.User, int64, error) {
    offset := (page - 1) * limit
    users, total, err := s.userRepo.FindAll(offset, limit)
    if err != nil {
        return nil, 0, err
    }
    return users, total, nil
}

func (s *UserService) CreateUser(req *dto.CreateUserRequest) (*model.User, error) {
    // Check if email exists
    existing, _ := s.userRepo.FindByEmail(req.Email)
    if existing != nil {
        return nil, errors.New("email already exists")
    }

    user := &model.User{
        Name:  req.Name,
        Email: req.Email,
    }

    if err := s.userRepo.Create(user); err != nil {
        return nil, err
    }

    return user, nil
}

// repository/user_repo.go - Data access
package repository

import (
    "my-project/internal/model"

    "gorm.io/gorm"
)

type UserRepository struct {
    db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
    return &UserRepository{db: db}
}

func (r *UserRepository) FindAll(offset, limit int) ([]model.User, int64, error) {
    var users []model.User
    var total int64

    if err := r.db.Model(&model.User{}).Count(&total).Error; err != nil {
        return nil, 0, err
    }

    if err := r.db.Offset(offset).Limit(limit).Find(&users).Error; err != nil {
        return nil, 0, err
    }

    return users, total, nil
}

func (r *UserRepository) FindByEmail(email string) (*model.User, error) {
    var user model.User
    err := r.db.Where("email = ?", email).First(&user).Error
    if err != nil {
        return nil, err
    }
    return &user, nil
}

func (r *UserRepository) Create(user *model.User) error {
    return r.db.Create(user).Error
}

// model/user.go - Data model
package model

import (
    "time"
    "gorm.io/gorm"
)

type User struct {
    ID        uint           `gorm:"primarykey" json:"id"`
    CreatedAt time.Time      `json:"created_at"`
    UpdatedAt time.Time      `json:"updated_at"`
    DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
    Name     string         `json:"name" binding:"required"`
    Email    string         `json:"email" gorm:"uniqueIndex" binding:"required,email"`
    Password string         `json:"-" binding:"required,min=8"`
}

// dto/user_dto.go - Data transfer objects
package dto

type CreateUserRequest struct {
    Name     string `json:"name" binding:"required,min=2"`
    Email    string `json:"email" binding:"required,email"`
    Password string `json:"password" binding:"required,min=8"`
}

type UpdateUserRequest struct {
    Name  string `json:"name" binding:"required,min=2"`
    Email string `json:"email" binding:"omitempty,email"`
}

type UserResponse struct {
    ID        uint      `json:"id"`
    Name      string    `json:"name"`
    Email     string    `json:"email"`
    CreatedAt time.Time `json:"created_at"`
}

// middleware/auth.go - Authentication middleware
package middleware

import (
    "net/http"
    "strings"

    "github.com/gin-gonic/gin"
)

func AuthMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        authHeader := c.GetHeader("Authorization")

        if authHeader == "" {
            c.JSON(401, gin.H{"error": "Authorization header required"})
            c.Abort()
            return
        }

        token := strings.TrimPrefix(authHeader, "Bearer ")

        // Validate token
        user, err := validateToken(token)
        if err != nil {
            c.JSON(401, gin.H{"error": "Invalid token"})
            c.Abort()
            return
        }

        c.Set("user", user)
        c.Next()
    }
}

// middleware/cors.go - CORS middleware
package middleware

import "github.com/gin-gonic/gin"

func CORS() gin.HandlerFunc {
    return func(c *gin.Context) {
        c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
        c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
        c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
        c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")

        if c.Request.Method == "OPTIONS" {
            c.AbortWithStatus(204)
            return
        }

        c.Next()
    }
}
```

### Common Patterns

#### Error Handling Pattern

```go
// pkg/utils/response.go
package utils

import (
    "net/http"

    "github.com/gin-gonic/gin"
)

type Response struct {
    Success bool        `json:"success"`
    Data    interface{} `json:"data,omitempty"`
    Message string      `json:"message,omitempty"`
    Error   string      `json:"error,omitempty"`
}

func Success(c *gin.Context, data interface{}) {
    c.JSON(http.StatusOK, Response{
        Success: true,
        Data:    data,
    })
}

func Error(c *gin.Context, statusCode int, message string) {
    c.JSON(statusCode, Response{
        Success: false,
        Error:   message,
    })
}

func Created(c *gin.Context, data interface{}) {
    c.JSON(http.StatusCreated, Response{
        Success: true,
        Data:    data,
    })
}
```

---

## Makefile Example

```makefile
# Makefile for Go project

.PHONY: run build test clean migrate-up migrate-down

run:
    @echo "Running server..."
    @air

build:
    @echo "Building..."
    @go build -o bin/server cmd/server/main.go

test:
    @echo "Running tests..."
    @go test -v ./...

test-coverage:
    @echo "Running tests with coverage..."
    @go test -coverprofile=coverage.out ./...
    @go tool cover -html=coverage.out -o coverage.html

clean:
    @echo "Cleaning..."
    @rm -rf bin/
    @rm -f coverage.out coverage.html

migrate-up:
    @echo "Running migrations..."
    @go run cmd/migrate/main.go up

migrate-down:
    @echo "Rolling back migrations..."
    @go run cmd/migrate/main.go down

deps:
    @echo "Installing dependencies..."
    @go mod download
    @go mod tidy
```

---

## Git Commit - Go/Gin Specific

```
✨ feat: Add user management API endpoints
- Implement GET/POST /api/v1/users
- Add user service with business logic
- Create user repository with GORM
- Add JWT authentication middleware

🐛 fix: Fix panic when user not found
- Add nil check in user handler
- Return 404 instead of panic
- Update tests for 404 scenario

♻️ refactor: Refactor to use service layer pattern
- Extract business logic from handlers to services
- Clean up repository layer
- Improve error handling

✅ test: Add integration tests for user endpoints
- Test user creation flow
- Test validation errors
- Add database test setup
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Run dev | `air` |
| Run | `go run cmd/server/main.go` |
| Build | `go build -o bin/server cmd/server/main.go` |
| Test | `go test ./...` |
| Coverage | `go test -cover ./...` |
| Clean | `go clean` |
| Format | `go fmt ./...` |
| Lint | `golangci-lint run` |

---

## Additional Resources

- **Gin Documentation:** https://gin-gonic.com/docs/
- **Go Documentation:** https://go.dev/doc/
- **GORM Documentation:** https://gorm.io/docs/
- **Air Live Reload:** https://github.com/cosmtrek/air
