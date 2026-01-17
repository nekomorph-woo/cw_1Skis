# Node.js / Express - Pure JavaScript Backend Guide

## Purpose

Technology-specific guidance for Node.js and Express.js development workflows using pure JavaScript (no TypeScript). Use this as a supplement to core templates when working with Node.js backend projects.

## Technology Detection

**Detect Node.js/Express when:**
- `package.json` exists with Express dependency
- `server.js` or `app.js` or `index.js` entry point
- `node_modules/` directory
- Files in `routes/`, `controllers/`, `models/`, `services/` directories
- Middleware usage: `app.use()`, `app.get()`, `app.post()`

---

## Project Structure

```
project-root/
├── src/
│   ├── controllers/      # Request handlers
│   ├── services/         # Business logic
│   ├── models/           # Data models (Mongoose, Sequelize schemas)
│   ├── routes/           # Route definitions
│   ├── middlewares/      # Custom middleware
│   ├── utils/            # Utility functions
│   ├── config/           # Configuration files
│   └── app.js            # Express app setup
├── tests/                # Test files
├── package.json          # Dependencies & scripts
├── .env                  # Environment variables
└── server.js             # Entry point
```

---

## Writing Plans - Node.js/Express Specific

### Install Dependencies

```bash
# Install all dependencies
npm install

# Install specific package
npm install express

# Install dev dependency
npm install --save-dev jest

# Install and add to package.json
npm install --save mongoose
npm install --save-dev nodemon
```

### Run Development Server

```bash
# Using npm scripts
npm run dev

# Direct with nodemon
npx nodemon server.js

# Direct with node
node server.js

# With environment file
NODE_ENV=development node server.js
```

### Test Commands

```bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run specific test file
npm test -- tests/user.test.js

# Run tests with coverage
npm test -- --coverage

# Run tests using Jest directly
npx jest

# Run tests using Mocha
npx mocha tests/**/*.test.js
```

### Build Commands (if using Babel)

```bash
# Build for production
npm run build

# Build and watch
npm run build:watch

# Build output typically goes to: dist/
```

### Lint & Format

```bash
# Run ESLint
npm run lint

# Fix lint issues
npm run lint:fix

# Run Prettier
npm run format

# Format check
npm run format:check
```

---

## Executing Plans - Node.js/Express Specific

### File Conventions

| Type | Convention | Example |
|------|------------|---------|
| Route | `*.routes.js` or `routes/*.js` | `user.routes.js` |
| Controller | `*.controller.js` | `user.controller.js` |
| Service | `*.service.js` | `user.service.js` |
| Model | `*.model.js` | `user.model.js` |
| Middleware | `*.middleware.js` | `auth.middleware.js` |
| Utility | `*.utils.js` or `utils/*.js` | `logger.utils.js` |

### Code Style Guidelines

```javascript
// routes/user.routes.js - Route definitions
const express = require('express');
const userController = require('../controllers/user.controller');
const authMiddleware = require('../middlewares/auth.middleware');

const router = express.Router();

router.get('/', userController.getAllUsers);
router.get('/:id', userController.getUserById);
router.post('/', userController.createUser);
router.put('/:id', userController.updateUser);
router.delete('/:id', authMiddleware.authenticate, userController.deleteUser);

module.exports = router;

// controllers/user.controller.js - Request handlers
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
        res.status(200).json({
            success: true,
            data: user
        });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    getAllUsers,
    getUserById
};

// services/user.service.js - Business logic
const UserModel = require('../models/user.model');

const getAllUsers = async () => {
    const users = await UserModel.find().select('-password');
    return users.map(user => user.toObject());
};

const getUserById = async (id) => {
    const user = await UserModel.findById(id).select('-password');
    if (!user) {
        throw new Error('User not found');
    }
    return user.toObject();
};

module.exports = {
    getAllUsers,
    getUserById
};

// models/user.model.js - Data model (Mongoose)
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
```

### Common Middleware Pattern

```javascript
// middlewares/auth.middleware.js
const jwt = require('jsonwebtoken');

const authenticate = async (req, res, next) => {
    try {
        const token = req.header('Authorization')?.replace('Bearer ', '');

        if (!token) {
            return res.status(401).json({ error: 'Authentication required' });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        next();
    } catch (error) {
        res.status(401).json({ error: 'Invalid token' });
    }
};

const authorize = (...roles) => {
    return (req, res, next) => {
        if (!roles.includes(req.user.role)) {
            return res.status(403).json({ error: 'Insufficient permissions' });
        }
        next();
    };
};

module.exports = { authenticate, authorize };

// middlewares/errorHandler.middleware.js
const errorHandler = (err, req, res, next) => {
    console.error(err.stack);

    const statusCode = err.statusCode || 500;
    const message = err.message || 'Internal server error';

    res.status(statusCode).json({
        success: false,
        error: message,
        ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    });
};

module.exports = errorHandler;
```

### App Setup Pattern

```javascript
// src/app.js
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const userRoutes = require('./routes/user.routes');
const errorHandler = require('./middlewares/errorHandler.middleware');

const app = express();

// Security middleware
app.use(helmet());
app.use(cors());

// Body parsing middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Logging middleware
app.use(morgan('combined'));

// Routes
app.use('/api/users', userRoutes);

// Error handling (must be last)
app.use(errorHandler);

module.exports = app;

// server.js - Entry point
require('dotenv').config();
const app = require('./src/app');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
```

---

## Common Dependencies

```json
{
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.0.0",
    "jsonwebtoken": "^9.0.0",
    "bcryptjs": "^2.4.3",
    "dotenv": "^16.0.0",
    "cors": "^2.8.5",
    "helmet": "^7.0.0",
    "morgan": "^1.10.0",
    "joi": "^17.9.0",
    "express-validator": "^7.0.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.0",
    "jest": "^29.5.0",
    "supertest": "^6.3.0",
    "eslint": "^8.45.0",
    "prettier": "^3.0.0"
  }
}
```

### Common npm Scripts

```json
{
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "jest --coverage",
    "test:watch": "jest --watch",
    "lint": "eslint src/**/*.js",
    "lint:fix": "eslint src/**/*.js --fix",
    "format": "prettier --write src/**/*.js"
  }
}
```

---

## Git Commit - Node.js/Express Specific

### Commit Message Examples

```
✨ feat: Add user authentication API
- Implement POST /api/auth/login endpoint
- Add JWT token generation
- Create password hashing with bcrypt
- Add authentication middleware

🐛 fix: Fix async handler not catching errors
- Wrap async route handlers with error handling middleware
- Update error responses to include stack trace in dev

♻️ refactor: Refactor user service to use async/await
- Convert promise chains to async/await
- Improve error handling in service layer
- Add proper error messages

📦 chore: Update express to version 4.18.2
- Bump express version
- Update related dependencies

📝 docs: Add API documentation with Swagger
- Add swagger-ui-express
- Document all endpoints
- Add request/response schemas
```

---

## Testing Patterns

### Jest Test Example

```javascript
// tests/user.service.test.js
const userService = require('../src/services/user.service');
const UserModel = require('../src/models/user.model');

// Mock the model
jest.mock('../src/models/user.model');

describe('UserService', () => {
    afterEach(() => {
        jest.clearAllMocks();
    });

    describe('getAllUsers', () => {
        it('should return all users without passwords', async () => {
            const mockUsers = [
                { name: 'John', email: 'john@example.com' },
                { name: 'Jane', email: 'jane@example.com' }
            ];

            UserModel.find.mockReturnValue({
                select: jest.fn().mockReturnThis(),
                exec: jest.fn().mockResolvedValue(mockUsers)
            });

            const result = await userService.getAllUsers();

            expect(result).toHaveLength(2);
            expect(result[0]).not.toHaveProperty('password');
        });
    });
});
```

### Supertest Integration Test

```javascript
// tests/api/user.test.js
const request = require('supertest');
const app = require('../src/app');

describe('User API', () => {
    describe('POST /api/users', () => {
        it('should create a new user', async () => {
            const userData = {
                name: 'John Doe',
                email: 'john@example.com',
                password: 'password123'
            };

            const response = await request(app)
                .post('/api/users')
                .send(userData)
                .expect(201);

            expect(response.body).toHaveProperty('success', true);
            expect(response.body.data).toHaveProperty('email', userData.email);
        });

        it('should return 400 for invalid data', async () => {
            const invalidData = {
                name: 'John'
                // missing required fields
            };

            await request(app)
                .post('/api/users')
                .send(invalidData)
                .expect(400);
        });
    });
});
```

---

## Common Issues & Solutions

### Issue 1: Routes Not Working

**Error:** 404 on all routes

**Solution:**
1. Ensure routes are mounted in app.js: `app.use('/api', routes)`
2. Check if body parser middleware is added before routes
3. Verify route paths don't have conflicts

### Issue 2: Async/Await Not Catching Errors

**Solution:**
```javascript
// Create async handler wrapper
const asyncHandler = (fn) => (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
};

// Use in routes
router.get('/', asyncHandler(async (req, res) => {
    const data = await someAsyncOperation();
    res.json(data);
}));
```

### Issue 3: Environment Variables Not Loading

**Solution:**
1. Ensure `require('dotenv').config()` is at the top of entry file
2. Check `.env` file is in project root
3. Verify `.env` is in `.gitignore`
4. Add error handling: `require('dotenv').config({ error: process.env.NODE_ENV !== 'production' })`

---

## Quick Reference

| Action | Command |
|--------|---------|
| Install deps | `npm install` |
| Dev server | `npm run dev` |
| Production | `npm start` |
| Test | `npm test` |
| Lint | `npm run lint` |
| Build | `npm run build` (if using Babel) |

---

## Additional Resources

- **Express Documentation:** https://expressjs.com/
- **Node.js Documentation:** https://nodejs.org/docs/
- **npm Documentation:** https://docs.npmjs.com/
- **Jest Documentation:** https://jestjs.io/docs/getting-started
