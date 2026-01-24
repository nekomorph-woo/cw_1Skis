# Python / FastAPI - Modern Backend Guide

## Purpose

Technology-specific guidance for Python FastAPI development. FastAPI is a modern, fast web framework for building APIs with Python 3.7+ based on standard Python type hints.

## Technology Detection

**Detect FastAPI when:**
- `main.py` or `app.py` with FastAPI import
- `requirements.txt` with `fastapi`
- `pyproject.toml` with fastapi dependency
- Pydantic models usage
- Decorator patterns: `@app.get()`, `@app.post()`

---

## Project Structure

```
project-root/
├── app/
│   ├── __init__.py
│   ├── main.py             # FastAPI app initialization
│   ├── api/                # API routes
│   │   ├── __init__.py
│   │   ├── deps.py         # Dependencies (auth, db)
│   │   └── v1/             # API v1 routes
│   │       ├── endpoints/
│   │       └── api.py      # Router aggregation
│   ├── core/               # Core functionality
│   │   ├── config.py       # Settings
│   │   ├── security.py     # Authentication
│   │   └── database.py     # DB connection
│   ├── models/             # DB models (SQLAlchemy)
│   ├── schemas/            # Pydantic schemas (DTOs)
│   ├── services/           # Business logic
│   ├── crud/               # CRUD operations
│   └── utils/              # Utilities
├── tests/
├── alembic/                # Database migrations
├── requirements.txt
└── pyproject.toml          # Poetry dependencies (optional)
```

---

## Writing Plans - FastAPI Specific

### Install & Run

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate   # Windows

# Install dependencies
pip install -r requirements.txt

# Run development server with auto-reload
uvicorn app.main:app --reload

# Run on specific port
uvicorn app.main:app --port 8001

# Run with 0.0.0.0 (external access)
uvicorn app.main:app --host 0.0.0.0 --port 8000

# Production
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

### Test Commands

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html

# Run specific test file
pytest tests/test_users.py

# Run with verbose output
pytest -v

# Run and stop on first failure
pytest -x
```

### Database Operations

```bash
# Alembic migrations
alembic revision --autogenerate -m "Description"
alembic upgrade head
alembic downgrade -1
alembic history
```

---

## Executing Plans - FastAPI Specific

### File Conventions

| Type | Convention | Example |
|------|------------|---------|
| Route | `api/v1/endpoints/*.py` | `users.py`, `scenes.py` |
| Schema | `schemas/*.py` | `user.py`, `scene.py` |
| Model | `models/*.py` | `user.py`, `scene.py` |
| CRUD | `crud/*.py` | `crud_user.py`, `crud_scene.py` |
| Service | `services/*.py` | `user_service.py` |

### Code Style Guidelines

```python
# main.py - App initialization
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.api import api_router
from app.core.config import settings

app = FastAPI(
    title="My API",
    description="API description",
    version="1.0.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(api_router, prefix="/api/v1")

# models/user.py - SQLAlchemy model
from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.sql import func
from app.core.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

# schemas/user.py - Pydantic schemas
from pydantic import BaseModel, EmailStr
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    username: str

class UserCreate(UserBase):
    password: str

class UserUpdate(UserBase):
    pass

class UserInDB(UserBase):
    id: int
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True  # Pydantic v2 (orm_mode = True)

class User(UserInDB):
    pass

# api/v1/endpoints/users.py - Route endpoints
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import crud, models, schemas
from app.api.deps import get_db

router = APIRouter()

@router.get("/", response_model=List[schemas.User])
def read_users(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    users = crud.user.get_multi(db, skip=skip, limit=limit)
    return users

@router.post("/", response_model=schemas.User)
def create_user(
    user_in: schemas.UserCreate,
    db: Session = Depends(get_db)
):
    user = crud.user.get_by_email(db, email=user_in.email)
    if user:
        raise HTTPException(status_code=400, detail="Email already registered")
    user = crud.user.create(db, obj_in=user_in)
    return user

@router.get("/{user_id}", response_model=schemas.User)
def read_user(
    user_id: int,
    db: Session = Depends(get_db)
):
    user = crud.user.get(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# crud/crud_user.py - CRUD operations
from sqlalchemy.orm import Session
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate
from typing import Optional

def get(db: Session, user_id: int) -> Optional[User]:
    return db.query(User).filter(User.id == user_id).first()

def get_by_email(db: Session, email: str) -> Optional[User]:
    return db.query(User).filter(User.email == email).first()

def get_multi(db: Session, skip: int = 0, limit: int = 100) -> List[User]:
    return db.query(User).offset(skip).limit(limit).all()

def create(db: Session, obj_in: UserCreate) -> User:
    db_obj = User(
        email=obj_in.email,
        username=obj_in.username,
        hashed_password=obj_in.password  # Hash in real app!
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

# api/deps.py - Dependencies
from fastapi import Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from app.core.database import get_db

security = HTTPBearer()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
):
    token = credentials.credentials
    # Validate token and return user
    return user
```

### Common Patterns

#### Service Layer Pattern

```python
# services/user_service.py
from typing import List, Optional
from app import models, schemas
from app.crud import crud_user

class UserService:
    @staticmethod
    def create_user(db, user_in: schemas.UserCreate) -> models.User:
        # Check if user exists
        existing = crud_user.get_by_email(db, email=user_in.email)
        if existing:
            raise ValueError("Email already registered")

        # Additional validation
        if len(user_in.password) < 8:
            raise ValueError("Password must be at least 8 characters")

        # Create user
        user = crud_user.create(db, obj_in=user_in)

        # Post-creation logic
        send_welcome_email(user.email)

        return user

# Using in routes
from app.services.user_service import UserService

@router.post("/users")
def create_user(
    user_in: schemas.UserCreate,
    db: Session = Depends(get_db)
):
    try:
        user = UserService.create_user(db, user_in)
        return user
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
```

---

## Common Dependencies

```
# requirements.txt
fastapi>=0.104.0
uvicorn[standard]>=0.24.0
pydantic>=2.0.0
sqlalchemy>=2.0.0
alembic>=1.12.0
psycopg2-binary>=2.9.0
python-jose[cryptography]>=3.3.0
passlib[bcrypt]>=1.7.4
python-multipart>=0.0.6
pytest>=7.4.0
pytest-asyncio>=0.21.0
httpx>=0.25.0
black>=23.7.0
ruff>=0.1.0
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Run dev | `uvicorn app.main:app --reload` |
| Run prod | `uvicorn app.main:app --host 0.0.0.0 --workers 4` |
| Test | `pytest` |
| Coverage | `pytest --cov=app --cov-report=html` |
| Migration | `alembic revision --autogenerate -m "msg"` |
| Migrate | `alembic upgrade head` |

---

## Additional Resources

- **FastAPI Documentation:** https://fastapi.tiangolo.com/
- **Pydantic Documentation:** https://docs.pydantic.dev/
- **SQLAlchemy Documentation:** https://docs.sqlalchemy.org/
