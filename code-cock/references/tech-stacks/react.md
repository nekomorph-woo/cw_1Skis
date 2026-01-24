# React - Technology Stack Guide

## Purpose

Technology-specific guidance for React development workflows. Use this as a supplement to core templates when working with React projects.

## Technology Detection {#react-detection}

**Detect React when:**
- `package.json` contains `react` and `react-dom` dependencies
- `src/App.js`, `src/App.jsx`, `src/App.tsx` exist
- `public/index.html` with root div
- Files with `.jsx` or `.tsx` extensions
- `vite.config.js`, `next.config.js`, or `craco.config.js`

**React Version Detection:**
```json
// package.json
{
  "dependencies": {
    "react": "^18.3.0",    // Detected: React 18
    "react-dom": "^18.3.0"
  }
}
```

---

## Auto-Inferred Constraint Files {#react-constraints}

Based on React detection, suggest these `cock-docs/tech-guidance` files:

| File | Description |
|------|-------------|
| `react-hooks-rules.md` | Hooks usage rules, ESLint configuration |
| `react-performance-rules.md` | Optimization patterns, memoization |
| `react-state-management-rules.md` | State management patterns (Context, Zustand, Redux) |
| `react-component-design-rules.md` | Component composition, props vs state |
| `react-testing-rules.md` | RTL patterns, test organization |

---

## Mode Configuration {#react-modes}

### Single-Stack (Frontend)

**Mode B: Frontend / UI Layer**
- **Trigger:** Working on `src/components/`, `src/pages/`, `src/hooks/`
- **File Extensions:** `*.tsx`, `*.jsx`
- **Workflow:** VDD (Visually Driven Development)
- **Testing Framework:** Jest + React Testing Library

**Component Categories:**
- UI Components: Reusable, presentational (buttons, inputs, cards)
- Feature Components: Business logic integration (user profiles, dashboards)
- Layout Components: Page structure (headers, sidebars, grids)
- Container/Smart Components: Data fetching, state management

---

## Project Structure Patterns

### Standard React (Vite/CRA)

```
project-root/
├── src/
│   ├── components/           # Reusable UI components
│   │   ├── ui/              # Basic UI elements (Button, Input, Card)
│   │   └── features/        # Feature-specific components
│   ├── pages/               # Page-level components
│   ├── hooks/               # Custom React hooks
│   ├── services/            # API calls, external services
│   ├── store/               # State management (Context, Zustand, Redux)
│   ├── types/               # TypeScript types/interfaces
│   ├── utils/               # Utility functions
│   ├── constants/           # Constants, config values
│   ├── App.tsx              # Root component
│   └── main.tsx             # Entry point
├── public/                  # Static assets
├── package.json
└── vite.config.ts           # Vite configuration
```

### Next.js (App Router)

```
project-root/
├── app/
│   ├── (auth)/             # Route group
│   │   ├── login/
│   │   └── register/
│   ├── (dashboard)/        # Route group
│   │   ├── dashboard/
│   │   └── settings/
│   ├── api/                # API routes
│   │   └── users/
│   ├── layout.tsx          # Root layout
│   └── page.tsx            # Home page
├── components/             # React components
├── lib/                    # Utility functions
├── hooks/                  # Custom hooks
├── types/                  # TypeScript types
└── public/                 # Static assets
```

---

## React-Specific Standards

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Component | `PascalCase` | `UserProfile`, `DataTable` |
| Hook | `camelCase` with `use` prefix | `useUserData`, `useFormState` |
| Event Handler | `handle` prefix + `camelCase` | `handleSubmit`, `handleClick` |
| Boolean Props | `is/has/should` prefix | `isLoading`, `hasError`, `shouldRender` |
| Test File | `*.test.tsx`, `*.spec.tsx` | `UserProfile.test.tsx` |

### Code Style Guidelines

```tsx
// ✅ Good: Component with proper typing and hooks
interface UserProfileProps {
  userId: string;
  onEdit?: (id: string) => void;
}

export function UserProfile({ userId, onEdit }: UserProfileProps) {
  // Custom hook for data fetching
  const { user, isLoading, error } = useUserData(userId);

  // Event handlers
  const handleEdit = useCallback(() => {
    onEdit?.(userId);
  }, [userId, onEdit]);

  // Early returns for loading/error states
  if (isLoading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error.message} />;
  if (!user) return <EmptyState />;

  return (
    <div className="user-profile">
      <Avatar src={user.avatarUrl} alt={user.name} />
      <h2>{user.name}</h2>
      <p>{user.email}</p>
      {onEdit && (
        <Button onClick={handleEdit}>Edit Profile</Button>
      )}
    </div>
  );
}
```

```tsx
// ❌ Bad: Component with anti-patterns
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);  // ❌ Should use custom hook

  // ❌ Effect for data fetching (should use custom hook)
  useEffect(() => {
    fetch(`/api/users/${userId}`)
      .then(res => res.json())
      .then(data => setUser(data));
  }, [userId]);

  // ❌ Direct DOM manipulation
  useEffect(() => {
    document.getElementById('title').scrollIntoView();
  }, []);

  if (!user) return <div>Loading...</div>;

  return (
    <div>
      {/* ❌ Missing error handling */}
      <h2>{user.name}</h2>
    </div>
  );
}
```

---

## Hooks Standards

### Custom Hook Pattern

```tsx
// ✅ Good: Custom hook with proper error handling
interface UseUserDataResult {
  user: User | null;
  isLoading: boolean;
  error: Error | null;
  refetch: () => void;
}

export function useUserData(userId: string): UseUserDataResult {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  const fetchUser = useCallback(async () => {
    setIsLoading(true);
    setError(null);

    try {
      const data = await userService.getUserById(userId);
      setUser(data);
    } catch (err) {
      setError(err as Error);
    } finally {
      setIsLoading(false);
    }
  }, [userId]);

  useEffect(() => {
    fetchUser();
  }, [fetchUser]);

  return { user, isLoading, error, refetch: fetchUser };
}
```

### Rules of Hooks

```tsx
// ❌ Bad: Violating Rules of Hooks
function BadComponent({ condition }) {
  if (condition) {
    const [value, setValue] = useState(0);  // ❌ Conditional hook
  }

  useEffect(() => {
    // ...
  }, []);  // ❌ Hook after early return

  return <div>...</div>;
}

// ✅ Good: Following Rules of Hooks
function GoodComponent({ condition }) {
  const [value, setValue] = useState(0);  // ✅ Always called

  useEffect(() => {
    // ...
  }, []);  // ✅ Always called

  if (condition) {
    return <div>{value}</div>;
  }

  return <div>...</div>;
}
```

---

## Testing Standards

### React Testing Library

```tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { UserProfile } from './UserProfile';

describe('UserProfile', () => {
  const mockUser = {
    id: '123',
    name: 'John Doe',
    email: 'john@example.com',
    avatarUrl: 'https://example.com/avatar.jpg'
  };

  it('should render user information', () => {
    render(<UserProfile userId={mockUser.id} />);

    expect(screen.getByText(mockUser.name)).toBeInTheDocument();
    expect(screen.getByText(mockUser.email)).toBeInTheDocument();
  });

  it('should call onEdit when edit button is clicked', async () => {
    const onEdit = vi.fn();
    render(<UserProfile userId={mockUser.id} onEdit={onEdit} />);

    const editButton = screen.getByRole('button', { name: /edit profile/i });
    fireEvent.click(editButton);

    expect(onEdit).toHaveBeenCalledWith(mockUser.id);
  });

  it('should show loading state', () => {
    // Mock loading state
    vi.mock('./hooks/useUserData', () => ({
      useUserData: () => ({ user: null, isLoading: true, error: null })
    }));

    render(<UserProfile userId={mockUser.id} />);
    expect(screen.getByTestId('loading-spinner')).toBeInTheDocument();
  });

  it('should show error state', () => {
    // Mock error state
    vi.mock('./hooks/useUserData', () => ({
      useUserData: () => ({ user: null, isLoading: false, error: new Error('Failed') })
    }));

    render(<UserProfile userId={mockUser.id} />);
    expect(screen.getByText(/failed/i)).toBeInTheDocument();
  });
});
```

---

## Performance Optimization

### Memoization

```tsx
// ✅ Good: Proper memoization
import { memo, useMemo, useCallback } from 'react';

// Memoize expensive child component
const ExpensiveChild = memo(function ExpensiveChild({ data, onUpdate }) {
  return (
    <div>
      {data.map(item => (
        <div key={item.id}>{item.name}</div>
      ))}
      <button onClick={onUpdate}>Update</button>
    </div>
  );
});

function ParentComponent() {
  const [items, setItems] = useState<Item[]>([]);

  // Memoize computed value
  const processedData = useMemo(() => {
    return items.map(item => ({
      ...item,
      processed: true
    }));
  }, [items]);

  // Memoize callback to prevent child re-render
  const handleUpdate = useCallback(() => {
    setItems(prev => [...prev, { id: Date.now(), name: 'New' }]);
  }, []);

  return <ExpensiveChild data={processedData} onUpdate={handleUpdate} />;
}
```

---

## Build Commands

### npm/pnpm/yarn

```bash
# Install dependencies
npm install
# or: pnpm install
# or: yarn install

# Development server
npm run dev
# or: pnpm dev
# or: yarn dev

# Build for production
npm run build
# or: pnpm build
# or: yarn build

# Run tests
npm run test
# or: pnpm test
# or: yarn test

# Run tests in watch mode
npm run test:watch
# or: pnpm test:watch
# or: yarn test:watch

# Lint code
npm run lint
# or: pnpm lint
# or: yarn lint

# Format code
npm run format
# or: pnpm format
# or: yarn format

# Type check (TypeScript)
npm run type-check
# or: pnpm type-check
# or: yarn type-check
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Install | `npm install` |
| Dev Server | `npm run dev` |
| Build | `npm run build` |
| Test | `npm run test` |
| Lint | `npm run lint` |
| Format | `npm run format` |
| Type Check | `npm run type-check` |

---

## Common Pitfalls

### 1. Missing Dependencies

```tsx
// ❌ Bad: Missing dependencies
useEffect(() => {
  fetchUser(userId);
}, []);  // Missing userId dependency!

// ✅ Good: Include all dependencies
useEffect(() => {
  fetchUser(userId);
}, [userId]);
```

### 2. Stale Closures

```tsx
// ❌ Bad: Stale closure
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      console.log(count);  // Always logs 0 (stale closure!)
    }, 1000);
    return () => clearInterval(timer);
  }, []);  // Empty deps

  return <div>{count}</div>;
}

// ✅ Good: Use functional updates
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setCount(prev => prev + 1);  // ✅ Functional update
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  return <div>{count}</div>;
}
```

### 3. Prop Drilling

```tsx
// ❌ Bad: Prop drilling
function App() {
  const [user, setUser] = useState(null);
  return <Layout user={user} setUser={setUser} />;
}

function Layout({ user, setUser }) {
  return <Header user={user} setUser={setUser} />;
}

function Header({ user, setUser }) {
  return <UserProfile user={user} setUser={setUser} />;
}

// ✅ Good: Use Context
const UserContext = createContext<UserContextValue | null>(null);

function App() {
  const [user, setUser] = useState(null);
  return (
    <UserContext.Provider value={{ user, setUser }}>
      <Layout />
    </UserContext.Provider>
  );
}

function Header() {
  const { user } = useContext(UserContext)!;
  return <UserProfile user={user} />;
}
```

---

## Integration with CLAUDE.md

### Knowledge Base Indexing

Add to **Tech Constraints** table:

```markdown
| `cock-docs/tech-guidance/react-hooks-rules.md` | React Hooks usage rules, ESLint configuration |
| `cock-docs/tech-guidance/react-performance-rules.md` | Performance optimization, memoization patterns |
| `cock-docs/tech-guidance/react-state-management-rules.md` | State management patterns (Context, Zustand, Redux) |
| `cock-docs/tech-guidance/react-testing-rules.md` | React Testing Library patterns |
```

### Self-Verification Loop

```markdown
- [ ] React: [OK/Unclear] - Checked `cock-docs/tech-guidance/react-*-rules.md`?
- [ ] Hooks: [Yes/No] - Following Rules of Hooks?
- [ ] Performance: [Yes/No] - Proper memoization where needed?
- [ ] Testing: [Yes/No] - Tests follow RTL best practices?
```

---

## Additional Resources

- **React Documentation:** https://react.dev/
- **React Testing Library:** https://testing-library.com/docs/react-testing-library/intro/
- **Vite:** https://vitejs.dev/
- **Next.js:** https://nextjs.org/docs
