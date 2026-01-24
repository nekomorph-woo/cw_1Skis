# React - Frontend Development Guide

## Purpose

Technology-specific guidance for React development workflows. Use this as a supplement to core templates when working with React projects.

## Technology Detection

**Detect React when:**
- `package.json` with `react`, `react-dom`
- `src/App.jsx` or `src/App.js`
- JSX files: `.jsx` or `.tsx`
- `public/` directory with `index.html`
- Component-based architecture

---

## Project Structure

```
project-root/
├── src/
│   ├── components/        # Reusable components
│   │   ├── common/        # Shared UI components
│   │   └── features/      # Feature-specific components
│   ├── pages/             # Page components
│   ├── hooks/             # Custom React hooks
│   ├── services/          # API calls
│   ├── contexts/          # React Context
│   ├── utils/             # Utility functions
│   ├── types/             # TypeScript types (if using TS)
│   ├── App.jsx            # Root component
│   └── main.jsx           # Entry point
├── public/
│   └── index.html
├── package.json
├── vite.config.js         # Vite config (if using Vite)
└── tailwind.config.js     # Tailwind config (if using)
```

---

## Writing Plans - React Specific

### Install & Run

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

### Test Commands

```bash
# Run tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage

# Run tests using Vitest
npm run test:unit
```

### Code Quality

```bash
# Run ESLint
npm run lint

# Fix lint issues
npm run lint:fix

# Format code with Prettier
npm run format
```

---

## Executing Plans - React Specific

### File Conventions

| Type | Convention | Example |
|------|------------|---------|
| Component | `PascalCase.jsx/.tsx` | `UserProfile.jsx` |
| Hook | `use*.js` | `useAuth.js`, `useForm.js` |
| Service | `*Service.js` | `userService.js` |
| Type | `*.types.ts` | `user.types.ts` |
| Utility | `*.utils.js` | `format.utils.js` |
| Context | `*Context.jsx` | `AuthContext.jsx` |

### Code Style Guidelines

```jsx
// components/UserProfile.jsx - Component
import {useState, useEffect} from 'code-flow/references/frontend/react';
import {userService} from '../services/userService';

export function UserProfile({userId}) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchUser = async () => {
            try {
                setLoading(true);
                const data = await userService.getUserById(userId);
                setUser(data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        fetchUser();
    }, [userId]);

    if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error}</div>;

    return (
        <div className="user-profile">
            <h1>{user.name}</h1>
            <p>{user.email}</p>
        </div>
    );
}

// hooks/useAuth.js - Custom hook
import {useState, useEffect, useContext} from 'code-flow/references/frontend/react';
import {AuthContext} from '../contexts/AuthContext';

export function useAuth() {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth must be used within AuthProvider');
    }
    return context;
}

export function useAuthUser() {
    const {user, login, logout} = useAuth();

    const isAuthenticated = !!user;
    const hasRole = (role) => user?.roles?.includes(role);

    return {
        user,
        isAuthenticated,
        hasRole,
        login,
        logout
    };
}

// services/userService.js - API calls
import api from './api';

export const userService = {
    async getAllUsers() {
        const response = await api.get('/users');
        return response.data;
    },

    async getUserById(id) {
        const response = await api.get(`/users/${id}`);
        return response.data;
    },

    async createUser(userData) {
        const response = await api.post('/users', userData);
        return response.data;
    },

    async updateUser(id, userData) {
        const response = await api.put(`/users/${id}`, userData);
        return response.data;
    },

    async deleteUser(id) {
        const response = await api.delete(`/users/${id}`);
        return response.data;
    }
};

// contexts/AuthContext.jsx - Context provider
import {createContext, useState, useContext} from 'code-flow/references/frontend/react';

const AuthContext = createContext(null);

export function AuthProvider({children}) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // Check for stored token and validate
        const token = localStorage.getItem('token');
        if (token) {
            validateToken(token).then(setUser);
        }
        setLoading(false);
    }, []);

    const login = async (credentials) => {
        const response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(credentials)
        });
        const data = await response.json();
        setUser(data.user);
        localStorage.setItem('token', data.token);
    };

    const logout = () => {
        setUser(null);
        localStorage.removeItem('token');
    };

    return (
        <AuthContext.Provider value={{user, login, logout, loading}}>
            {children}
        </AuthContext.Provider>
    );
}

// App.jsx - Root component
import {BrowserRouter, Routes, Route} from 'react-router-dom';
import {QueryClient, QueryClientProvider} from '@tanstack/react-query';
import {AuthProvider} from './contexts/AuthContext';

const queryClient = new QueryClient();

function App() {
    return (
        <QueryClientProvider client={queryClient}>
            <AuthProvider>
                <BrowserRouter>
                    <Routes>
                        <Route path="/" element={<Home/>}/>
                        <Route path="/users" element={<UsersList/>}/>
                        <Route path="/users/:id" element={<UserProfile/>}/>
                    </Routes>
                </BrowserRouter>
            </AuthProvider>
        </QueryClientProvider>
    );
}

export default App;
```

### Common Patterns

#### Custom Hook Pattern

```jsx
// hooks/useForm.js
import { useState, useCallback } from 'react';

export function useForm(initialValues, validate) {
    const [values, setValues] = useState(initialValues);
    const [errors, setErrors] = useState({});
    const [touched, setTouched] = useState({});

    const handleChange = useCallback((e) => {
        const { name, value } = e.target;
        setValues(prev => ({ ...prev, [name]: value }));
    }, []);

    const handleBlur = useCallback((e) => {
        const { name } = e.target;
        setTouched(prev => ({ ...prev, [name]: true }));
        setErrors(validate(values));
    }, [values, validate]);

    const handleSubmit = useCallback((callback) => (e) => {
        e.preventDefault();
        const validationErrors = validate(values);
        setErrors(validationErrors);

        if (Object.keys(validationErrors).length === 0) {
            callback(values);
        }
    }, [values, validate]);

    const reset = useCallback(() => {
        setValues(initialValues);
        setErrors({});
        setTouched({});
    }, [initialValues]);

    return {
        values,
        errors,
        touched,
        handleChange,
        handleBlur,
        handleSubmit,
        reset
    };
}

// Usage
function LoginForm() {
    const {
        values,
        errors,
        handleChange,
        handleSubmit
    } = useForm(
        { email: '', password: '' },
        validateForm
    );

    return (
        <form onSubmit={handleSubmit(onSubmit)}>
            <input
                name="email"
                value={values.email}
                onChange={handleChange}
            />
            {errors.email && <span>{errors.email}</span>}
        </form>
    );
}
```

---

## Common Dependencies

```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0",
    "@tanstack/react-query": "^5.0.0",
    "axios": "^1.6.0",
    "zustand": "^4.4.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.0",
    "vite": "^5.0.0",
    "eslint": "^8.55.0",
    "prettier": "^3.1.0",
    "vitest": "^1.0.0",
    "@testing-library/react": "^14.0.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}
```

---

## Git Commit - React Specific

```
✨ feat: Add user profile page component
- Implement UserProfile component with user data display
- Add useAuth custom hook for authentication
- Create userService for API calls

🐛 fix: Fix useEffect infinite loop
- Fix missing dependency array in useEffect
- Add proper cleanup function

♻️ refactor: Refactor to use TanStack Query
- Replace useState with useQuery for data fetching
- Add proper caching and invalidation
- Remove unnecessary useEffect calls

✨ style: Add Tailwind CSS styling to components
- Apply Tailwind classes to all components
- Remove old CSS files
- Add dark mode support

✅ test: Add unit tests for custom hooks
- Test useAuth hook with mock context
- Test useForm with form validation
- Add test utilities for React Testing Library
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Install deps | `npm install` |
| Dev server | `npm run dev` |
| Build | `npm run build` |
| Preview | `npm run preview` |
| Test | `npm test` |
| Lint | `npm run lint` |
| Format | `npm run format` |

---

## Additional Resources

- **React Documentation:** https://react.dev/
- **React Router:** https://reactrouter.com/
- **TanStack Query:** https://tanstack.com/query/latest
- **Vite:** https://vitejs.dev/
