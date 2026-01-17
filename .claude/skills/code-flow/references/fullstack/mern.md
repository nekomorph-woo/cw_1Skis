# MERN Stack - Full-Stack Development Guide

## Purpose

Technology-specific guidance for MERN Stack (MongoDB, Express, React, Node.js) development workflows. Use this as a supplement to core templates when working with full-stack MERN projects.

## Technology Detection

**Detect MERN Stack when:**
- Both `package.json` in root and client/ subdirectory
- Backend: Express server, MongoDB (Mongoose)
- Frontend: React, CRA or Vite
- Full-stack project structure

---

## Project Structure (Monorepo)

```
mern-project/
├── backend/               # Express/Node.js backend
│   ├── src/
│   │   ├── config/        # Database, environment config
│   │   ├── controllers/   # Request handlers
│   │   ├── models/        # Mongoose models
│   │   ├── routes/        # API routes
│   │   ├── middlewares/   # Custom middleware
│   │   ├── services/      # Business logic
│   │   └── utils/         # Utilities
│   ├── package.json
│   └── server.js
├── frontend/              # React frontend
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/      # API calls
│   │   ├── hooks/         # Custom hooks
│   │   ├── contexts/      # React Context
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── package.json
│   └── vite.config.js
├── shared/                # Shared types, constants
│   └── types/
└── package.json           # Root workspace
```

---

## Writing Plans - MERN Specific

### Install & Run

```bash
# Install all dependencies (root)
npm install

# Install backend dependencies
cd backend && npm install

# Install frontend dependencies
cd frontend && npm install

# Run both (using concurrent package)
npm run dev

# Or run separately:
# Terminal 1: Backend
cd backend && npm run dev

# Terminal 2: Frontend
cd frontend && npm run dev
```

### Backend Commands

```bash
cd backend

# Development
npm run dev          # Nodemon server
npm start           # Node server

# Database
npm run db:seed      # Seed database
npm run db:migrate   # Run migrations

# Testing
npm test
npm run test:watch
```

### Frontend Commands

```bash
cd frontend

# Development
npm run dev

# Build
npm run build
npm run preview

# Testing
npm test
npm run lint
```

---

## Executing Plans - MERN Specific

### Full-Stack File Conventions

| Type | Location | Convention |
|------|----------|------------|
| Backend Model | `backend/src/models/` | `user.model.js` |
| Backend Route | `backend/src/routes/` | `user.routes.js` |
| Backend Controller | `backend/src/controllers/` | `user.controller.js` |
| Backend Service | `backend/src/services/` | `user.service.js` |
| Frontend Component | `frontend/src/components/` | `UserProfile.jsx` |
| Frontend Service | `frontend/src/services/` | `user.service.js` |
| Frontend Page | `frontend/src/pages/` | `UsersPage.jsx` |
| Shared Types | `shared/types/` | `user.types.ts` |

### Code Style - Backend

```javascript
// backend/src/models/User.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true
    },
    password: {
        type: String,
        required: true,
        minlength: 6
    }
}, {
    timestamps: true
});

module.exports = mongoose.model('User', userSchema);

// backend/src/routes/user.routes.js
const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const { authenticate } = require('../middlewares/auth.middleware');

router.get('/', userController.getAllUsers);
router.get('/:id', userController.getUserById);
router.post('/', userController.createUser);
router.put('/:id', authenticate, userController.updateUser);
router.delete('/:id', authenticate, userController.deleteUser);

module.exports = router;

// backend/src/controllers/user.controller.js
const userService = require('../services/user.service');

const getAllUsers = async (req, res, next) => {
    try {
        const users = await userService.getAllUsers();
        res.status(200).json({
            success: true,
            data: users
        });
    } catch (error) {
        next(error);
    }
};

const getUserById = async (req, res, next) => {
    try {
        const user = await userService.getUserById(req.params.id);
        if (!user) {
            return res.status(404).json({
                success: false,
                error: 'User not found'
            });
        }
        res.status(200).json({
            success: true,
            data: user
        });
    } catch (error) {
        next(error);
    }
};

module.exports = { getAllUsers, getUserById };
```

### Code Style - Frontend

```jsx
// frontend/src/services/userService.js
import api from './api';

export const userService = {
    async getAllUsers() {
        const response = await api.get('/api/users');
        return response.data.data;
    },

    async getUserById(id) {
        const response = await api.get(`/api/users/${id}`);
        return response.data.data;
    },

    async createUser(userData) {
        const response = await api.post('/api/users', userData);
        return response.data.data;
    },

    async updateUser(id, userData) {
        const response = await api.put(`/api/users/${id}`, userData);
        return response.data.data;
    },

    async deleteUser(id) {
        const response = await api.delete(`/api/users/${id}`);
        return response.data;
    }
};

// frontend/src/api/index.js
import axios from 'axios';

const api = axios.create({
    baseURL: import.meta.env.VITE_API_URL || 'http://localhost:5000/api',
    headers: {
        'Content-Type': 'application/json'
    }
});

// Request interceptor
api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

// Response interceptor
api.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response?.status === 401) {
            localStorage.removeItem('token');
            window.location.href = '/login';
        }
        return Promise.reject(error);
    }
);

export default api;

// frontend/src/pages/UsersPage.jsx
import { useEffect, useState } from 'react';
import { userService } from '../services/userService';
import UserCard from '../components/UserCard';

export function UsersPage() {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchUsers = async () => {
            try {
                setLoading(true);
                const data = await userService.getAllUsers();
                setUsers(data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        fetchUsers();
    }, []);

    if (loading) return <div>Loading users...</div>;
    if (error) return <div>Error: {error}</div>;

    return (
        <div className="users-page">
            <h1>Users</h1>
            <div className="users-grid">
                {users.map(user => (
                    <UserCard key={user._id} user={user} />
                ))}
            </div>
        </div>
    );
}
```

---

## Shared Types

```typescript
// shared/types/user.types.ts
export interface User {
    _id: string;
    name: string;
    email: string;
    createdAt: string;
    updatedAt: string;
}

export interface CreateUserRequest {
    name: string;
    email: string;
    password: string;
}

export interface UpdateUserRequest {
    name?: string;
    email?: string;
}

export interface ApiResponse<T> {
    success: boolean;
    data?: T;
    error?: string;
    message?: string;
}
```

---

## Root Package.json (Workspace)

```json
{
  "name": "mern-project",
  "private": true,
  "workspaces": [
    "backend",
    "frontend"
  ],
  "scripts": {
    "dev": "concurrently \"npm run dev:backend\" \"npm run dev:frontend\"",
    "dev:backend": "npm run dev --workspace=backend",
    "dev:frontend": "npm run dev --workspace=frontend",
    "build": "npm run build --workspace=frontend",
    "install": "npm install && npm run install:backend && npm run install:frontend",
    "test": "npm run test --workspace=backend && npm run test --workspace=frontend"
  },
  "devDependencies": {
    "concurrently": "^8.2.0"
  }
}
```

---

## Git Commit - MERN Specific

```
✨ feat: Add full-stack user management feature
- Backend: Implement user CRUD API endpoints
- Backend: Add Mongoose user model with validation
- Frontend: Create UsersPage component with user cards
- Frontend: Add userService for API calls
- Shared: Add TypeScript types for user data

🐛 fix: Fix CORS issues between frontend and backend
- Add CORS middleware to Express server
- Configure allowed origins for frontend URL
- Update API base URL in frontend service

♻️ refactor: Extract shared types to workspace
- Move shared types to shared/types/ directory
- Update backend to use shared types
- Update frontend to use shared types

✨ fullstack: Add authentication flow
- Backend: Implement JWT authentication
- Backend: Add auth middleware for protected routes
- Frontend: Create login form component
- Frontend: Add useAuth hook for authentication state
- Frontend: Implement protected route logic
```

---

## Common Issues & Solutions

### Issue 1: CORS Errors

**Solution:**
```javascript
// backend/src/middleware/cors.middleware.js
const cors = require('cors');

const corsOptions = {
    origin: process.env.FRONTEND_URL || 'http://localhost:5173',
    credentials: true
};

module.exports = cors(corsOptions);

// server.js
app.use(cors());
```

### Issue 2: Proxy Issues in Development

**Solution:**
```javascript
// frontend/vite.config.js
export default defineConfig({
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:5000',
        changeOrigin: true
      }
    }
  }
});
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Install all | `npm run install` |
| Dev both | `npm run dev` |
| Backend only | `cd backend && npm run dev` |
| Frontend only | `cd frontend && npm run dev` |
| Build | `npm run build` |
| Test all | `npm test` |

---

## Additional Resources

- **MERN Tutorial:** https://www.mongodb.com/mern-stack/
- **React Docs:** https://react.dev/
- **Express Docs:** https://expressjs.com/
- **MongoDB Docs:** https://www.mongodb.com/docs/
