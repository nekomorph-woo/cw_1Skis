# Vue - Technology Stack Guide

## Purpose

Technology-specific guidance for Vue development workflows. Use this as a supplement to core templates when working with Vue projects.

## Technology Detection {#vue-detection}

**Detect Vue when:**
- `package.json` contains `vue` dependency
- `src/App.vue`, `src/main.ts`, or `src/main.js` exist
- Files with `.vue` extension
- `vite.config.ts` with `@vitejs/plugin-vue`
- `nuxt.config.ts` or `vue.config.js`

**Vue Version Detection:**
```json
// package.json
{
  "dependencies": {
    "vue": "^3.4.0"    // Detected: Vue 3
  }
}
```

---

## Auto-Inferred Constraint Files {#vue-constraints}

Based on Vue detection, suggest these `cock-docs/tech-guidance` files:

| File | Description |
|------|-------------|
| `vue-composition-api-rules.md` | Composition API best practices, script setup |
| `vue-reactivity-rules.md` | Reactivity system, ref vs reactive |
| `vue-component-design-rules.md` | Component patterns, props, emits |
| `vue-state-management-rules.md` | Pinia patterns, state organization |
| `vue-testing-rules.md` | Vue Test Utils patterns |

---

## Mode Configuration {#vue-modes}

### Single-Stack (Frontend)

**Mode B: Frontend / UI Layer**
- **Trigger:** Working on `src/components/`, `src/views/`, `src/composables/`
- **File Extensions:** `*.vue`
- **Workflow:** VDD (Visually Driven Development)
- **Testing Framework:** Vitest + Vue Test Utils

**Component Categories:**
- Base Components: Reusable, presentational (buttons, inputs, cards)
- Feature Components: Business logic integration (user profiles, dashboards)
- Layout Components: Page structure (headers, sidebars, grids)
- Smart Components: Data fetching, state management

---

## Project Structure Patterns

### Standard Vue 3 (Vite)

```
project-root/
├── src/
│   ├── assets/              # Static assets (images, styles)
│   ├── components/          # Reusable components
│   │   ├── base/           # Basic UI elements
│   │   └── features/       # Feature-specific components
│   ├── views/              # Page-level components
│   ├── composables/        # Vue composables (reusable logic)
│   ├── stores/             # Pinia stores
│   ├── router/             # Vue Router configuration
│   ├── types/              # TypeScript types
│   ├── utils/              # Utility functions
│   ├── constants/          # Constants, config values
│   ├── App.vue             # Root component
│   └── main.ts             # Entry point
├── public/                 # Static assets
├── package.json
└── vite.config.ts          # Vite configuration
```

### Nuxt 3

```
project-root/
├── app/                    # Nuxt app directory
│   ├── components/         # Auto-imported components
│   ├── composables/        # Auto-imported composables
│   ├── pages/              # File-based routing
│   │   ├── index.vue
│   │   └── users/
│   │       └── [id].vue
│   └──.vue                # App-level component
├── server/                 # Nitro server routes
├── stores/                 # Pinia stores (auto-imported)
├── types/                  # TypeScript types
├── nuxt.config.ts          # Nuxt configuration
└── package.json
```

---

## Vue-Specific Standards

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Component | `PascalCase` or `kebab-case` | `UserProfile.vue`, `user-profile.vue` |
| Composable | `camelCase` with `use` prefix | `useUserData`, `useFormState` |
| Props | `camelCase` | `userName`, `isLoading` |
| Events | `kebab-case` | `user-updated`, `form-submitted` |
| CSS Classes | `kebab-case` | `user-profile`, `submit-button` |

### Code Style Guidelines

```vue
<!-- ✅ Good: Component with script setup and proper typing -->
<script setup lang="ts">
import { ref, computed, watch } from 'vue'

interface Props {
  userId: string
}

interface Emits {
  (e: 'update', id: string): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// Custom composable for data fetching
const { user, isLoading, error, fetchUser } = useUserData(props.userId)

// Computed properties
const displayName = computed(() => user.value?.name ?? 'Unknown')

// Watchers
watch(() => props.userId, (newId) => {
  fetchUser(newId)
}, { immediate: true })

// Event handlers
const handleUpdate = () => {
  emit('update', props.userId)
}
</script>

<template>
  <div class="user-profile">
    <template v-if="isLoading">
      <LoadingSpinner />
    </template>
    <template v-else-if="error">
      <ErrorMessage :message="error.message" />
    </template>
    <template v-else-if="user">
      <Avatar :src="user.avatarUrl" :alt="user.name" />
      <h2>{{ displayName }}</h2>
      <p>{{ user.email }}</p>
      <button @click="handleUpdate">Edit Profile</button>
    </template>
  </div>
</template>

<style scoped>
.user-profile {
  padding: 1rem;
}
</style>
```

```vue
<!-- ❌ Bad: Component with anti-patterns -->
<script>
export default {
  data() {
    return {
      user: null,
      isLoading: false,
      error: null
    }
  },
  watch: {
    userId(newId) {
      // ❌ Side effect in watcher without cleanup
      fetch(`/api/users/${newId}`)
        .then(res => res.json())
        .then(data => {
          this.user = data
          this.isLoading = false
        })
    }
  },
  methods: {
    // ❌ Direct DOM manipulation
    scrollToTitle() {
      document.getElementById('title').scrollIntoView()
    }
  }
}
</script>
```

---

## Composables Standards

### Composable Pattern

```typescript
// ✅ Good: Composable with proper lifecycle management
// composables/useUserData.ts
import { ref, watch } from 'vue'

export interface UseUserDataReturn {
  user: Ref<User | null>
  isLoading: Ref<boolean>
  error: Ref<Error | null>
  fetchUser: (id: string) => Promise<void>
}

export function useUserData(userId: MaybeRef<string>): UseUserDataReturn {
  const user = ref<User | null>(null)
  const isLoading = ref(false)
  const error = ref<Error | null>(null)

  const fetchUser = async (id: string) => {
    isLoading.value = true
    error.value = null

    try {
      const data = await userService.getUserById(id)
      user.value = data
    } catch (err) {
      error.value = err as Error
    } finally {
      isLoading.value = false
    }
  }

  // Auto-fetch when userId changes
  watch(
    () => unref(userId),
    (id) => {
      if (id) {
        fetchUser(id)
      }
    },
    { immediate: true }
  )

  return {
    user,
    isLoading,
    error,
    fetchUser
  }
}
```

---

## Testing Standards

### Vue Test Utils

```typescript
import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import UserProfile from './UserProfile.vue'

describe('UserProfile', () => {
  const mockUser = {
    id: '123',
    name: 'John Doe',
    email: 'john@example.com',
    avatarUrl: 'https://example.com/avatar.jpg'
  }

  it('should render user information', async () => {
    const wrapper = mount(UserProfile, {
      props: { userId: mockUser.id }
    })

    // Mock composable response
    await wrapper.vm.fetchUser(mockUser.id)

    expect(wrapper.text()).toContain(mockUser.name)
    expect(wrapper.text()).toContain(mockUser.email)
  })

  it('should emit update event when edit button is clicked', async () => {
    const wrapper = mount(UserProfile, {
      props: { userId: mockUser.id }
    })

    await wrapper.find('button').trigger('click')

    expect(wrapper.emitted('update')).toBeTruthy()
    expect(wrapper.emitted('update')?.[0]).toEqual([mockUser.id])
  })

  it('should show loading state', () => {
    const wrapper = mount(UserProfile, {
      props: { userId: mockUser.id },
      setup() {
        // Return loading state
        return { isLoading: true }
      }
    })

    expect(wrapper.find('[data-testid="loading-spinner"]').exists()).toBe(true)
  })
})
```

---

## Reactivity System

### ref vs reactive

```typescript
// ✅ Good: Using ref for primitives and reactive for objects
import { ref, reactive } from 'vue'

// ref for primitives
const count = ref(0)
const increment = () => {
  count.value++  // Access .value
}

// reactive for objects
const user = reactive<User>({
  id: '123',
  name: 'John',
  email: 'john@example.com'
})

const updateName = (name: string) => {
  user.name = name  // Direct access
}

// ❌ Bad: Destructuring reactive (loses reactivity)
const { name, email } = user  // ❌ Not reactive!

// ✅ Good: Use toRefs for destructuring
import { toRefs } from 'vue'
const { name, email } = toRefs(user)  // ✅ Reactive refs
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

### 1. Reactive Destructuring

```typescript
// ❌ Bad: Loses reactivity
const state = reactive({ count: 0 })
const { count } = state  // ❌ Not reactive!

// ✅ Good: Use toRefs
const { count } = toRefs(state)  // ✅ Reactive!
```

### 2. Mutating Props

```vue
<!-- ❌ Bad: Mutating props directly -->
<script setup lang="ts">
const props = defineProps<{ count: number }>()

const increment = () => {
  props.count++  // ❌ Mutation!
}
</script>

<!-- ✅ Good: Emit event instead -->
<script setup lang="ts">
const props = defineProps<{ count: number }>()
const emit = defineEmits<{ (e: 'update', value: number): void }>()

const increment = () => {
  emit('update', props.count + 1)  // ✅ Emit event
}
</script>
```

### 3. v-if vs v-show

```vue
<!-- ✅ Good: Use v-if for conditional rendering (expensive) -->
<HeavyComponent v-if="shouldShow" />

<!-- ✅ Good: Use v-show for toggle visibility (cheap) -->
<div v-show="isVisible">Content</div>

<!-- ❌ Bad: Using v-show for expensive components -->
<HeavyComponent v-show="shouldShow" />
```

---

## Integration with CLAUDE.md

### Knowledge Base Indexing

Add to **Tech Constraints** table:

```markdown
| `cock-docs/tech-guidance/vue-composition-api-rules.md` | Vue Composition API best practices, script setup |
| `cock-docs/tech-guidance/vue-reactivity-rules.md` | Reactivity system, ref vs reactive |
| `cock-docs/tech-guidance/vue-state-management-rules.md` | Pinia patterns, state organization |
| `cock-docs/tech-guidance/vue-testing-rules.md` | Vue Test Utils patterns |
```

### Self-Verification Loop

```markdown
- [ ] Vue: [OK/Unclear] - Checked `cock-docs/tech-guidance/vue-*-rules.md`?
- [ ] Composition API: [Yes/No] - Using script setup and composables?
- [ ] Reactivity: [Yes/No] - Proper use of ref vs reactive?
- [ ] Testing: [Yes/No] - Tests follow Vue Test Utils best practices?
```

---

## Additional Resources

- **Vue Documentation:** https://vuejs.org/
- **Vue Test Utils:** https://test-utils.vuejs.org/
- **Pinia:** https://pinia.vuejs.org/
- **Vite:** https://vitejs.dev/
- **Nuxt:** https://nuxt.com/docs
