# Python - Technology Stack Guide

## Purpose

Technology-specific guidance for Python development workflows. Use this as a supplement to core templates when working with Python projects.

## Technology Detection {#python-detection}

**Detect Python when:**
- `requirements.txt`, `pyproject.toml`, or `setup.py` exists
- `*.py` source files
- `Pipfile` or `poetry.lock`
- Python virtual environment (`.venv/`, `venv/`)

**Python Version Detection:**
```toml
# pyproject.toml
[project]
requires-python = ">=3.12"  # Detected: Python 3.12+
```

```txt
# requirements.txt
Django==5.0.0  # Detected: Django project
fastapi==0.109.0  # Detected: FastAPI project
```

---

## Auto-Inferred Constraint Files {#python-constraints}

Based on Python detection, suggest these `cock-docs/tech-guidance` files:

| File | Description |
|------|-------------|
| `python-type-hinting-rules.md` | Type annotations, mypy configuration |
| `python-asyncio-rules.md` | Async/await, event loop management |
| `python-error-handling-rules.md` | Exception hierarchy, error propagation |
| `python-logging-rules.md` | Logging configuration, structured logging |
| `python-testing-rules.md` | Pytest patterns, fixtures, parametrization |

---

## Mode Configuration {#python-modes}

### Single-Stack (Backend/Scripting)

**Mode A: Backend / Core Logic**
- **Trigger:** Working on `*.py` files
- **File Extensions:** `*.py`
- **Workflow:** TDD (Test-Driven Development)
- **Testing Framework:** pytest + pytest-asyncio

**Layer Organization:**
- View Layer: HTTP handlers, controllers (Django/FastAPI)
- Service Layer: Business logic, use cases
- Repository Layer: Data access, ORM queries
- Model Layer: Domain models, Pydantic schemas

---

## Project Structure Patterns

### Standard Python Project

```
project-root/
├── src/
│   └── project/
│       ├── __init__.py
│       ├── api/              # API endpoints
│       │   ├── __init__.py
│       │   └── endpoints.py
│       ├── services/         # Business logic
│       │   ├── __init__.py
│       │   └── user_service.py
│       ├── repositories/     # Data access
│       │   ├── __init__.py
│       │   └── user_repository.py
│       ├── models/           # Domain models
│       │   ├── __init__.py
│       │   └── user.py
│       ├── config/           # Configuration
│       │   ├── __init__.py
│       │   └── settings.py
│       └── utils/            # Utilities
├── tests/                    # Test files
│   ├── __init__.py
│   ├── conftest.py          # Pytest fixtures
│   └── test_user_service.py
├── pyproject.toml
├── requirements.txt
└── .python-version
```

### Django Project

```
project-root/
├── manage.py
├── project/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── asgi.py
├── apps/
│   ├── users/
│   │   ├── __init__.py
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   └── urls.py
│   └── api/
│       ├── __init__.py
│       ├── views.py
│       └── urls.py
├── tests/
├── requirements.txt
└── pytest.ini
```

### FastAPI Project

```
project-root/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI app
│   ├── api/                 # API routes
│   │   ├── __init__.py
│   │   ├── v1/
│   │   │   ├── __init__.py
│   │   │   ├── endpoints.py
│   │   │   └── dependencies.py
│   ├── models/              # Pydantic models
│   │   ├── __init__.py
│   │   ├── user.py
│   │   └── error.py
│   ├── services/            # Business logic
│   │   ├── __init__.py
│   │   └── user_service.py
│   ├── repositories/        # Data access
│   │   ├── __init__.py
│   │   └── user_repository.py
│   └── config/              # Configuration
│       ├── __init__.py
│       └── settings.py
├── tests/
├── pyproject.toml
└── requirements.txt
```

---

## Python-Specific Standards

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Module | `lowercase_with_underscores` | `user_service`, `api_helpers` |
| Class | `PascalCase` | `UserService`, `APIError` |
| Function/Method | `lowercase_with_underscores` | `get_user`, `validate_input` |
| Constant | `UPPERCASE_WITH_UNDERSCORES` | `MAX_RETRIES`, `DEFAULT_TIMEOUT` |
| Private | `_leading_underscore` | `_internal_method` |
| Dunder | `__double_underscore__` | `__init__`, `__str__` |

### Code Style Guidelines

```python
# ✅ Good: Idiomatic Python with type hints
from dataclasses import dataclass
from typing import Optional

@dataclass
class User:
    id: str
    name: str
    email: str

class UserService:
    def __init__(self, repository: UserRepository) -> None:
        self._repository = repository

    def get_user(self, user_id: str) -> Optional[User]:
        if not user_id:
            raise ValueError("user_id cannot be empty")

        return self._repository.find_by_id(user_id)

    def get_user_or_raise(self, user_id: str) -> User:
        user = self.get_user(user_id)
        if user is None:
            raise UserNotFoundError(user_id)
        return user
```

```python
# ❌ Bad: Non-idiomatic Python
class userService:
    def __init__(self, repository):
        self.repository = repository

    def getUser(self, userId):
        # No type hints
        if not userId:
            print("Empty user ID")  # Should raise exception
            return None

        return self.repository.find(userId)
```

---

## Type Hints Standards

### Type Annotations

```python
# ✅ Good: Comprehensive type hints
from typing import Optional, List, Dict, Any, Callable
from dataclasses import dataclass

def process_users(
    users: List[User],
    callback: Callable[[User], bool]
) -> Dict[str, Any]:
    """Process users and return results."""
    results = {}
    for user in users:
        if callback(user):
            results[user.id] = user.to_dict()
    return results

# Generic types
from typing import TypeVar, Generic

T = TypeVar('T')

class Repository(Generic[T]):
    def find_by_id(self, id: str) -> Optional[T]:
        ...

# Union types
from typing import Union

Result = Union[User, Error]

# Python 3.10+ syntax
def process(value: int | str) -> str:
    return str(value)
```

---

## Testing Standards

### Pytest Patterns

```python
import pytest
from unittest.mock import Mock, patch
from user_service import UserService, UserNotFoundError

class TestUserService:
    @pytest.fixture
    def mock_repository(self):
        return Mock(spec=UserRepository)

    @pytest.fixture
    def service(self, mock_repository):
        return UserService(mock_repository)

    def test_get_user_success(self, service, mock_repository):
        # Arrange
        user = User(id="123", name="John", email="john@example.com")
        mock_repository.find_by_id.return_value = user

        # Act
        result = service.get_user("123")

        # Assert
        assert result == user
        mock_repository.find_by_id.assert_called_once_with("123")

    def test_get_user_not_found(self, service, mock_repository):
        # Arrange
        mock_repository.find_by_id.return_value = None

        # Act
        result = service.get_user("999")

        # Assert
        assert result is None

    def test_get_user_or_raise_not_found(self, service, mock_repository):
        # Arrange
        mock_repository.find_by_id.return_value = None

        # Act & Assert
        with pytest.raises(UserNotFoundError):
            service.get_user_or_raise("999")

    @pytest.mark.parametrize("user_id,expected", [
        ("123", True),
        ("", False),
        ("   ", False),
    ])
    def test_validate_user_id(self, service, user_id, expected):
        result = service._validate_user_id(user_id)
        assert result == expected
```

---

## Async Patterns

### Asyncio

```python
# ✅ Good: Proper async patterns
import asyncio
from typing import Optional

class AsyncUserService:
    def __init__(self, repository: AsyncUserRepository) -> None:
        self._repository = repository

    async def get_user(self, user_id: str) -> Optional[User]:
        if not user_id:
            raise ValueError("user_id cannot be empty")

        return await self._repository.find_by_id(user_id)

    async def get_multiple_users(self, user_ids: List[str]) -> List[User]:
        """Fetch multiple users concurrently."""
        tasks = [self.get_user(uid) for uid in user_ids]
        results = await asyncio.gather(*tasks, return_exceptions=True)

        # Filter out exceptions
        users = [
            user for user in results
            if isinstance(user, User)
        ]

        return users

    async def fetch_with_timeout(
        self,
        user_id: str,
        timeout: float = 5.0
    ) -> Optional[User]:
        """Fetch user with timeout."""
        try:
            return await asyncio.wait_for(
                self.get_user(user_id),
                timeout=timeout
            )
        except asyncio.TimeoutError:
            return None
```

---

## Build Commands

### pip / poetry / pdm

```bash
# pip
pip install -r requirements.txt
pip install -e .
python -m pytest
python -m pytest --cov=src tests/
python -m mypy src/
black src/
ruff check src/

# poetry
poetry install
poetry run pytest
poetry run pytest --cov=app tests/
poetry run mypy app/
poetry run black app/
poetry run ruff check app/

# pdm
pdm install
pdm run pytest
pdm run pytest --cov=src tests/
pdm run mypy src/
pdm run black src/
pdm run ruff check src/
```

### Common Commands

```bash
# Run
python main.py
python -m app.main

# Test
pytest
pytest -v
pytest --cov=src tests/
pytest -xvs  # Stop on first failure, verbose, show print

# Type checking
mypy src/
mypy --strict src/

# Format
black src/
black --check src/

# Lint
ruff check src/
ruff check --fix src/

# Import sorting
isort src/
isort --check-only src/
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Install | `pip install -r requirements.txt` |
| Run | `python main.py` |
| Test | `pytest` |
| Type check | `mypy src/` |
| Format | `black src/` |
| Lint | `ruff check src/` |
| Import sort | `isort src/` |
| Coverage | `pytest --cov=src tests/` |

---

## Common Pitfalls

### 1. Mutable Default Arguments

```python
# ❌ Bad: Mutable default argument
def process_users(user_ids: list = []):  # ❌ Shared across calls!
    user_ids.append("default")
    return user_ids

# ✅ Good: Use None as default
def process_users(user_ids: Optional[list] = None) -> list:
    if user_ids is None:
        user_ids = []
    user_ids.append("default")
    return user_ids

# Or use dataclass/factory
from dataclasses import dataclass, field

@dataclass
class Processor:
    user_ids: list = field(default_factory=list)
```

### 2. Exception Handling

```python
# ❌ Bad: Bare except
try:
    process_user(user)
except:  # ❌ Catches everything, including SystemExit
    pass

# ✅ Good: Specific exceptions
try:
    process_user(user)
except UserNotFoundError as e:
    logger.error(f"User not found: {e}")
except ValidationError as e:
    logger.warning(f"Validation failed: {e}")
```

### 3. Import Side Effects

```python
# ❌ Bad: Import side effects
# config.py
import database
database.connect()  # Runs on import!

# ✅ Good: Explicit initialization
# config.py
import database

def initialize():
    database.connect()

# main.py
from config import initialize
initialize()
```

---

## Integration with CLAUDE.md

### Knowledge Base Indexing

Add to **Tech Constraints** table:

```markdown
| `cock-docs/tech-guidance/python-type-hinting-rules.md` | Type annotations, mypy configuration |
| `cock-docs/tech-guidance/python-asyncio-rules.md` | Async/await, event loop management |
| `cock-docs/tech-guidance/python-error-handling-rules.md` | Exception hierarchy, error propagation |
| `cock-docs/tech-guidance/python-testing-rules.md` | Pytest patterns, fixtures, parametrization |
```

### Self-Verification Loop

```markdown
- [ ] Python: [OK/Unclear] - Checked `cock-docs/tech-guidance/python-*-rules.md`?
- [ ] Type Hints: [Yes/No] - All functions have type annotations?
- [ ] Async: [Yes/N/A] - Proper async/await usage?
- [ ] Tests: [Yes/No] - Tests follow pytest best practices?
- [ ] Linting: [Yes/No] - No ruff/black warnings?
```

---

## Additional Resources

- **Python Documentation:** https://docs.python.org/
- **Pytest Documentation:** https://docs.pytest.org/
- **Mypy:** https://mypy.readthedocs.io/
- **FastAPI:** https://fastapi.tiangolo.com/
- **Django:** https://docs.djangoproject.com/
