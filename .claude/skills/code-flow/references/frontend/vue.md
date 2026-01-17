# Vue - Frontend Development Guide

## Purpose

Technology-specific guidance for Vue.js development workflows. Use this as a supplement to core templates when working with Vue projects.

## Technology Detection

**Detect Vue when:**
- `package.json` with `vue`
- `.vue` files (Single File Components)
- `src/App.vue`
- Vue CLI or Vite configuration
- Options API or Composition API

---

## Project Structure

```
project-root/
├── src/
│   ├── components/        # Reusable components
│   │   ├── common/        # Shared components
│   │   └── features/      # Feature components
│   ├── views/             # Page components
│   ├── router/            # Vue Router config
│   ├── stores/            # Pinia stores (state management)
│   ├── composables/       # Vue composables (like React hooks)
│   ├── services/          # API calls
│   ├── utils/             # Utility functions
│   ├── types/             # TypeScript types
│   ├── assets/            # Images, styles
│   ├── App.vue            # Root component
│   └── main.js            # Entry point
├── public/
│   └── index.html
├── package.json
├── vite.config.js         # Vite config
└── vue.config.js          # Vue CLI config
```

---

## Writing Plans - Vue Specific

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
npm run test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Run E2E tests
npm run test:e2e
```

---

## Executing Plans - Vue Specific

### File Conventions

| Type | Convention | Example |
|------|------------|---------|
| Component | `PascalCase.vue` | `UserProfile.vue` |
| View | `PascalCase.vue` in views/ | `HomeView.vue` |
| Composable | `use*.js` | `useAuth.js` |
| Store | `*Store.js` | `userStore.js` |
| Service | `*Service.js` | `userService.js` |

### Code Style Guidelines

```vue
<!-- components/UserProfile.vue - Single File Component -->
<template>
  <div class="user-profile">
    <div v-if="loading" class="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else-if="user" class="user-info">
      <h1>{{ user.name }}</h1>
      <p>{{ user.email }}</p>
      <p>Joined: {{ formatDate(user.createdAt) }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { userService } from '@/services/userService';

const route = useRoute();
const userId = route.params.id;

const user = ref(null);
const loading = ref(true);
const error = ref(null);

onMounted(async () => {
  try {
    loading.value = true;
    user.value = await userService.getUserById(userId);
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
});

function formatDate(date) {
  return new Date(date).toLocaleDateString();
}
</script>

<style scoped>
.user-profile {
  padding: 20px;
}

.user-info h1 {
  color: #333;
}
</style>
```

```javascript
// composables/useAuth.js - Composable (like React hooks)
import { ref, computed } from 'vue';
import { useAuthStore } from '@/stores/authStore';

export function useAuth() {
  const authStore = useAuthStore();

  const user = computed(() => authStore.user);
  const isAuthenticated = computed(() => authStore.isAuthenticated);

  const hasRole = (role) => {
    return user.value?.roles?.includes(role);
  };

  return {
    user,
    isAuthenticated,
    hasRole,
    login: authStore.login,
    logout: authStore.logout
  };
}
```

```javascript
// stores/userStore.js - Pinia store
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import { userService } from '@/services/userService';

export const useUserStore = defineStore('user', () => {
  const users = ref([]);
  const currentUser = ref(null);
  const loading = ref(false);

  const totalCount = computed(() => users.value.length);

  async function fetchUsers() {
    loading.value = true;
    try {
      users.value = await userService.getAllUsers();
    } finally {
      loading.value = false;
    }
  }

  async function getUserById(id) {
    loading.value = true;
    try {
      currentUser.value = await userService.getUserById(id);
    } finally {
      loading.value = false;
    }
  }

  function clearUser() {
    currentUser.value = null;
  }

  return {
    users,
    currentUser,
    loading,
    totalCount,
    fetchUsers,
    getUserById,
    clearUser
  };
});
```

```javascript
// router/index.js - Router configuration
import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '@/stores/authStore';
import HomeView from '@/views/HomeView.vue';
import LoginView from '@/views/LoginView.vue';
import DashboardView from '@/views/DashboardView.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: { requiresAuth: false }
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: DashboardView,
      meta: { requiresAuth: true }
    }
  ]
});

// Navigation guard
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next({ name: 'login' });
  } else {
    next();
  }
});

export default router;
```

---

## Common Patterns

### Composable Pattern (Composition API)

```javascript
// composables/useForm.js
import { ref, reactive, computed } from 'vue';

export function useForm(initialValues, validate) {
  const form = reactive({ ...initialValues });
  const errors = ref({});
  const touched = ref({});

  const handleChange = (field, value) => {
    form[field] = value;
    touched.value[field] = true;
    errors.value = validate(form);
  };

  const handleBlur = (field) => {
    touched.value[field] = true;
    errors.value = validate(form);
  };

  const handleSubmit = async (callback) => {
    errors.value = validate(form);

    if (Object.keys(errors.value).length === 0) {
      await callback(form);
    }
  };

  const reset = () => {
    Object.assign(form, initialValues);
    errors.value = {};
    touched.value = {};
  };

  const isValid = computed(() => {
    return Object.keys(errors.value).length === 0;
  });

  return {
    form,
    errors,
    touched,
    isValid,
    handleChange,
    handleBlur,
    handleSubmit,
    reset
  };
}
```

### Provide/Inject Pattern

```javascript
// composables/useTheme.js
import { inject, computed } from 'vue';

const THEME_KEY = Symbol('theme');

export function provideTheme(theme) {
  provide(THEME_KEY, theme);
}

export function useTheme() {
  const theme = inject(THEME_KEY);

  if (!theme) {
    throw new Error('useTheme must be used within a theme provider');
  }

  const isDark = computed(() => theme.value === 'dark');

  const toggleTheme = () => {
    theme.value = theme.value === 'dark' ? 'light' : 'dark';
  };

  return {
    theme,
    isDark,
    toggleTheme
  };
}
```

---

## Common Dependencies

```json
{
  "dependencies": {
    "vue": "^3.3.0",
    "vue-router": "^4.2.0",
    "pinia": "^2.1.0",
    "axios": "^1.6.0",
    "@vueuse/core": "^10.5.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^4.5.0",
    "vite": "^5.0.0",
    "eslint": "^8.55.0",
    "prettier": "^3.1.0",
    "vitest": "^1.0.0",
    "@vue/test-utils": "^2.4.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}
```

---

## Git Commit - Vue Specific

```
✨ feat: Add user profile page with Composition API
- Implement UserProfile.vue with script setup
- Create useAuth composable
- Add Pinia store for user state

🐛 fix: Fix reactivity issue with props
- Use toRefs() for props destructuring
- Fix computed property not updating

♻️ refactor: Migrate from Options API to Composition API
- Convert components to use <script setup>
- Extract logic to composables
- Simplify component code

✨ test: Add component tests with Vue Test Utils
- Test UserProfile component mounting
- Test user interactions and events
- Add mocks for API calls
```

---

## Quick Reference

| Action | Command |
|--------|---------|
| Install deps | `npm install` |
| Dev server | `npm run dev` |
| Build | `npm run build` |
| Preview | `npm run preview` |
| Test | `npm run test` |
| Lint | `npm run lint` |

---

## Additional Resources

- **Vue Documentation:** https://vuejs.org/
- **Vue Router:** https://router.vuejs.org/
- **Pinia:** https://pinia.vuejs.org/
- **VueUse:** https://vueuse.org/
- **Vite:** https://vitejs.dev/
