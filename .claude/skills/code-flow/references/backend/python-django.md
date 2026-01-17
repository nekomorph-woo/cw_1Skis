# Python / Django - Backend Development Guide

## Purpose

Technology-specific guidance for Python and Django development workflows. Use this as a supplement to core templates when working with Django projects.

## Technology Detection

**Detect Django when:**
- `manage.py` exists in project root
- `requirements.txt` with Django
- `settings.py` in project directory
- Django project structure: `apps/`, `templates/`, `static/`
- URL patterns in `urls.py`

---

## Project Structure

```
project-root/
├── manage.py              # Django management script
├── requirements.txt       # Python dependencies
├── project/               # Project configuration
│   ├── settings.py        # Django settings
│   ├── urls.py            # Root URL configuration
│   └── wsgi.py            # WSGI config
├── apps/
│   ├── __init__.py
│   ├── models.py          # Database models
│   ├── views.py           # View functions
│   ├── serializers.py     # DRF serializers
│   ├── urls.py            # App URLs
│   ├── admin.py           # Admin configuration
│   ├── forms.py           # Django forms
│   └── tests.py           # App tests
├── templates/             # HTML templates
├── static/                # CSS, JS, images
├── media/                 # User uploaded files
└── migrations/            # Database migrations
```

---

## Writing Plans - Django Specific

### Install Dependencies

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Install specific package
pip install djangorestframework
```

### Run Development Server

```bash
# Run development server
python manage.py runserver

# Run on specific port
python manage.py runserver 8001

# Run with 0.0.0.0 (allows external access)
python manage.py runserver 0.0.0.0:8000
```

### Database Operations

```bash
# Create migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Show migrations
python manage.py showmigrations

# Create migration for specific app
python manage.py makemigrations app_name

# Rollback migration
python manage.py migrate app_name zero
```

### Django Shell

```bash
# Open Django shell (with models loaded)
python manage.py shell

# Create superuser
python manage.py createsuperuser

# Collect static files
python manage.py collectstatic
```

### Test Commands

```bash
# Run all tests
python manage.py test

# Run specific app tests
python manage.py test app_name

# Run specific test
python manage.py test app_name.tests.TestClass

# Run with coverage
coverage run --source='.' manage.py test
coverage report
```

---

## Executing Plans - Django Specific

### File Conventions

| Type | Convention | Example |
|------|------------|---------|
| Model | `models.py` in app | `class User(models.Model)` |
| View | `views.py` in app | `def user_list(request)` |
| URL | `urls.py` in app | `path('users/', views.user_list)` |
| Form | `forms.py` in app | `class UserForm(forms.ModelForm)` |
| Serializer | `serializers.py` | `class UserSerializer(serializers.ModelSerializer)` |
| Template | `templates/app/*.html` | `templates/app/user_list.html` |

### Code Style Guidelines

```python
# models.py - Database models
from django.db import models
from django.contrib.auth.models import User

class Scene(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='scenes')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return self.name

# views.py - View functions (function-based)
from django.shortcuts import render, get_object_or_404
from django.http import JsonResponse
from .models import Scene

def scene_list(request):
    scenes = Scene.objects.filter(user=request.user)
    return render(request, 'scenes/scene_list.html', {'scenes': scenes})

def scene_detail(request, pk):
    scene = get_object_or_404(Scene, pk=pk, user=request.user)
    return render(request, 'scenes/scene_detail.html', {'scene': scene})

# views.py - View classes (class-based with DRF)
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Scene
from .serializers import SceneSerializer

class SceneViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    serializer_class = SceneSerializer

    def get_queryset(self):
        return Scene.objects.filter(user=self.request.user)

# serializers.py - DRF serializers
from rest_framework import serializers
from .models import Scene

class SceneSerializer(serializers.ModelSerializer):
    user_email = serializers.EmailField(source='user.email', read_only=True)

    class Meta:
        model = Scene
        fields = ['id', 'name', 'description', 'user_email', 'created_at']
        read_only_fields = ['id', 'created_at', 'user']

    def validate_name(self, value):
        if len(value) < 3:
            raise serializers.ValidationError("Name must be at least 3 characters")
        return value

# urls.py - URL configuration
from django.urls import path, include
from . import views

urlpatterns = [
    path('', views.scene_list, name='scene-list'),
    path('<int:pk>/', views.scene_detail, name='scene-detail'),
]

# Using ViewSets in urls
from rest_framework.routers import DefaultRouter
from .views import SceneViewSet

router = DefaultRouter()
router.register(r'scenes', SceneViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]
```

### Common Patterns

#### Service Layer Pattern

```python
# services/scene_service.py
from typing import List
from django.db import transaction
from .models import Scene

class SceneService:
    @staticmethod
    def get_user_scenes(user_id: int) -> List[Scene]:
        return Scene.objects.filter(user_id=user_id)

    @staticmethod
    @transaction.atomic
    def create_scene(user, data: dict) -> Scene:
        # Additional business logic
        if Scene.objects.filter(user=user, name=data['name']).exists():
            raise ValueError("Scene with this name already exists")

        scene = Scene.objects.create(user=user, **data)

        # Post-creation logic
        scene.initialize_default_actions()

        return scene

    @staticmethod
    def update_scene(scene_id: int, user, data: dict) -> Scene:
        scene = Scene.objects.get(id=scene_id, user=user)

        for key, value in data.items():
            setattr(scene, key, value)

        scene.save()
        return scene

# Using in views
from .services.scene_service import SceneService

def create_scene(request):
    try:
        scene = SceneService.create_scene(request.user, request.data)
        return render(request, 'scenes/success.html', {'scene': scene})
    except ValueError as e:
        return render(request, 'scenes/error.html', {'error': str(e)})
```

#### Middleware Pattern

```python
# middleware/authentication_middleware.py
from django.http import JsonResponse

class APIKeyAuthentication:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Check for API key in request
        api_key = request.META.get('HTTP_X_API_KEY')

        if not api_key:
            return JsonResponse({'error': 'API key required'}, status=401)

        # Validate API key
        if not self.validate_api_key(api_key):
            return JsonResponse({'error': 'Invalid API key'}, status=401)

        return self.get_response(request)

    def validate_api_key(self, key):
        # Validation logic
        return True

# settings.py
MIDDLEWARE = [
    # ...
    'django.middleware.common.CommonMiddleware',
    'apps.middleware.authentication_middleware.APIKeyAuthentication',
]
```

---

## Common Dependencies

```
# requirements.txt
Django>=4.2.0
djangorestframework>=3.14.0
django-cors-headers>=4.0.0
python-decouple>=3.8
psycopg2-binary>=2.9.0          # PostgreSQL
pymongo>=4.0.0                  # MongoDB
redis>=4.5.0
celery>=5.3.0
gunicorn>=21.0.0                 # Production server
pytest>=7.4.0
pytest-django>=4.5.0
coverage>=7.3.0
black>=23.7.0                    # Code formatter
flake8>=6.1.0                    # Linter
```

---

## Git Commit - Django Specific

### Commit Message Examples

```
✨ feat: Add user profile API endpoints
- Implement GET/PUT /api/users/profile/
- Add profile model with avatar upload
- Create profile serializer with validation

🐛 fix: Fix QuerySet evaluation in SceneView
- Lazy load QuerySet to prevent N+1 queries
- Add select_related for foreign keys
- Update test to verify query count

♻️ refactor: Refactor service layer to use class-based views
- Convert function views to class-based views
- Extract common logic to base view class
- Update URL patterns for class-based views

📝 docs: Update API documentation with DRF schemas
- Add AutoSchema for all endpoints
- Include request/response examples
- Document authentication requirements

✅ test: Add integration tests for user registration
- Test successful registration flow
- Test validation errors
- Test email uniqueness constraint
```

---

## Common Issues & Solutions

### Issue 1: Migrations Not Detected

**Solution:**
```bash
# Check for migrations
python manage.py showmigrations

# Make new migrations
python manage.py makemigrations

# Check what SQL migration will run
python manage.py sqlmigrate app_name 0001

# Fake initial migration (if tables already exist)
python manage.py migrate app_name zero --fake
python manage.py migrate app_name --fake-initial
```

### Issue 2: Static Files Not Loading

**Solution:**
```python
# settings.py
STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
STATICFILES_DIRS = [BASE_DIR / 'static']

# In templates
{% load static %}
<link href="{% static 'css/style.css' %}" rel="stylesheet">

# Collect static in production
python manage.py collectstatic --noinput
```

### Issue 3: ImportError for Apps

**Solution:**
```python
# settings.py - Add apps directory to Python path
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(BASE_DIR / 'apps'))

INSTALLED_APPS = [
    # ...
    'scenes',
    'users',
]
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Create project | `django-admin startproject project` |
| Create app | `python manage.py startapp app` |
| Run server | `python manage.py runserver` |
| Migrations | `python manage.py makemigrations && migrate` |
| Create superuser | `python manage.py createsuperuser` |
| Django shell | `python manage.py shell` |
| Collect static | `python manage.py collectstatic` |
| Run tests | `python manage.py test` |

---

## Additional Resources

- **Django Documentation:** https://docs.djangoproject.com/
- **DRF Documentation:** https://www.django-rest-framework.org/
- **Python Documentation:** https://docs.python.org/3/
