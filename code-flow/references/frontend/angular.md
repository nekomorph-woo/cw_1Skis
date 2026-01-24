# Angular - Frontend Development Guide

## Purpose

Technology-specific guidance for Angular development workflows. Use this as a supplement to core templates when working with Angular projects.

## Technology Detection

**Detect Angular when:**
- `angular.json` configuration file
- `package.json` with `@angular/core`
- `.component.ts`, `.service.ts`, `.module.ts` files
- TypeScript files with Angular decorators: `@Component`, `@Injectable`

---

## Writing Plans - Angular Specific

### Angular CLI Commands

```bash
# Install dependencies
npm install

# Start development server
ng serve

# Build for production
ng build

# Run tests
ng test

# Run e2e tests
ng e2e

# Generate component
ng generate component components/user-profile

# Generate service
ng generate service services/user

# Generate module
ng generate module modules/user
```

---

## Code Style Guidelines

```typescript
// components/user-profile/user-profile.component.ts
import { Component, OnInit } from '@angular/core';
import { UserService } from '../../services/user.service';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.component.html',
  styleUrls: ['./user-profile.component.scss']
})
export class UserProfileComponent implements OnInit {
  user: User | null = null;
  loading = false;
  error: string | null = null;

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.loadUser();
  }

  private loadUser(): void {
    this.loading = true;
    this.userService.getUserById(1).subscribe({
      next: (data) => {
        this.user = data;
      },
      error: (err) => {
        this.error = err.message;
      },
      complete: () => {
        this.loading = false;
      }
    });
  }
}
```

## Quick Reference

| Action | Command |
|--------|---------|
| Dev server | `ng serve` |
| Build | `ng build` |
| Test | `ng test` |
| Lint | `ng lint` |

---

## Additional Resources

- **Angular Documentation:** https://angular.io/docs
