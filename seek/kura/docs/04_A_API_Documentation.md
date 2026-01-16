# API Documentation

**Document Version:** 1.0
**Last Updated:** 2026-01-17
**API Version:** 1.0.0
**Base URL:** `http://localhost:3000`

---

## 1. API Overview

### 1.1 Purpose

Kura API 提供 Bun 后端服务与前端壳应用之间的接口，包括文件操作、应用管理、AI 生成等功能。

### 1.2 Target Audience

- 壳应用前端 (dashboard.html)
- 微应用 (通过 iframe 访问)
- 外部工具 (可选，通过 API 集成)

### 1.3 API Style

RESTful API，使用 JSON 格式进行数据交换。

### 1.4 Versioning Strategy

当前版本为 v1.0.0，通过 URL 路径进行版本控制 (未来支持)。

---

## 2. Authentication

### 2.1 Authentication Mechanism

当前为本地环境服务，无需认证。

| 机制 | 描述 |
|-----------|-------------|
| 无认证 | 本地 HTTP 服务，默认不启用认证 |

### 2.2 Obtaining Credentials

无需凭证，直接访问 `http://localhost:3000`。

### 2.3 Using Credentials

N/A

### 2.4 Token Management

N/A

---

## 3. Common Behavior

### 3.1 Request Format

标准 HTTP 请求，使用 JSON 格式发送请求体。

```http
POST /api/save
Content-Type: application/json

{
  "path": "apps/calc/index.html",
  "content": "<div>...</div>"
}
```

### 3.2 Response Format

成功响应返回相应数据，失败返回错误信息。

**成功响应示例:**
```json
{
  "status": "success",
  "data": {
    "message": "Saved"
  }
}
```

**错误响应示例:**
```json
{
  "status": "error",
  "error": {
    "code": "FILE_NOT_FOUND",
    "message": "文件不存在"
  }
}
```

### 3.3 Error Handling

参见 [Section 7: Error Codes](#7-error-codes)。

### 3.4 Rate Limiting

无限制 (本地环境)。

### 3.5 Pagination

暂不支持 (本地应用数量有限)。

### 3.6 Filtering & Sorting

暂不支持。

---

## 4. API Endpoints

### 4.1 应用管理

#### 获取应用列表

```http
GET /api/apps
```

**描述:** 获取工作区中所有微应用列表。

**响应:** `200 OK`

```json
{
  "status": "success",
  "data": ["calculator", "todo-list", "weather-app"]
}
```

---

#### 获取工作区路径

```http
GET /api/workspace
```

**描述:** 获取当前工作区路径配置。

**响应:** `200 OK`

```json
{
  "status": "success",
  "data": {
    "path": "./workspace"
  }
}
```

---

#### 设置工作区路径

```http
POST /api/workspace
```

**描述:** 更新工作区路径配置。

**请求体:**

```json
{
  "path": "D:/MyProjects"
}
```

**请求参数:**

| 参数 | 类型 | 必需 | 描述 |
|------|------|----------|-------------|
| path | string | 是 | 新的工作区路径 |

**响应:** `200 OK`

```json
{
  "status": "success",
  "data": {
    "message": "Workspace Updated"
  }
}
```

---

### 4.2 文件操作

#### 读取文件

```http
GET /api/read?path=apps/calc/index.html
```

**描述:** 读取指定文件的内容。

**查询参数:**

| 参数 | 类型 | 必需 | 描述 |
|------|------|----------|-------------|
| path | string | 是 | 文件相对路径 |

**响应:** `200 OK`

```json
{
  "status": "success",
  "data": {
    "content": "<div>...</div>"
  }
}
```

---

#### 保存文件

```http
POST /api/save
```

**描述:** 将内容保存到指定文件。

**请求体:**

```json
{
  "path": "apps/calc/index.html",
  "content": "<div>...</div>"
}
```

**请求参数:**

| 参数 | 类型 | 必需 | 描述 |
|------|------|----------|-------------|
| path | string | 是 | 文件相对路径 |
| content | string | 是 | 文件内容 |

**响应:** `200 OK`

```json
{
  "status": "success",
  "data": {
    "message": "Saved"
  }
}
```

---

#### 获取目录结构

```http
GET /api/tree?path=apps
```

**描述:** 递归获取指定目录的文件树结构。

**查询参数:**

| 参数 | 类型 | 必需 | 描述 |
|------|------|----------|-------------|
| path | string | 否 | 目录相对路径，默认为工作区根目录 |

**响应:** `200 OK`

```json
{
  "status": "success",
  "data": {
    "name": "apps",
    "type": "directory",
    "children": [
      {
        "name": "calculator",
        "type": "directory",
        "children": [
          {"name": "index.html", "type": "file"},
          {"name": "logic.js", "type": "file"}
        ]
      }
    ]
  }
}
```

---

### 4.3 微应用

#### 获取微应用主页 (动态注入)

```http
GET /apps/:name/index.html
```

**描述:** 获取微应用的完整 HTML (自动注入 Import Maps 和 CDN 链接)。

**路径参数:**

| 参数 | 类型 | 必需 | 描述 |
|------|------|----------|-------------|
| name | string | 是 | 应用名称 |

**响应:** `200 OK`

返回完整的 HTML 文档，包含:
- 自动注入的 Import Maps
- Tailwind + DaisyUI CDN 链接
- Alpine.js CDN 链接
- 用户的原始 HTML 内容

---

#### 获取微应用逻辑文件

```http
GET /apps/:name/logic.js
```

**描述:** 获取微应用的 logic.js 文件内容。

**路径参数:**

| 参数 | 类型 | 必需 | 描述 |
|------|------|----------|-------------|
| name | string | 是 | 应用名称 |

**响应:** `200 OK`

返回 ES Module 格式的 JavaScript 代码。

---

### 4.4 公共模块

#### 获取公共模块

```http
GET /api/shared/:module.js
```

**描述:** 获取 @shared 公共模块的内容。

**路径参数:**

| 参数 | 类型 | 必需 | 描述 |
|------|------|----------|-------------|
| module | string | 是 | 模块名称 (不含扩展名) |

**响应:** `200 OK`

返回 ES Module 格式的 JavaScript 代码。

---

### 4.5 AI 生成

#### 生成应用代码

```http
POST /api/ai/generate
```

**描述:** 调用 AI 生成微应用代码。

**请求体:**

```json
{
  "prompt": "创建一个计算器应用",
  "context": {
    "html": "<div>...</div>",
    "selector": "#btn-submit"
  }
}
```

**请求参数:**

| 参数 | 类型 | 必需 | 描述 |
|------|------|----------|-------------|
| prompt | string | 是 | 用户需求描述 |
| context | object | 否 | 上下文信息 (可选) |
| context.html | string | 否 | 选中的 HTML 片段 |
| context.selector | string | 否 | CSS 选择器 |

**响应:** `200 OK`

```json
{
  "status": "success",
  "data": {
    "html": "<div>...</div>",
    "js": "export default () => ({...})",
    "css": ".custom { ... }"
  }
}
```

---

#### 修正代码错误

```http
POST /api/ai/fix
```

**描述:** 将错误信息发送给 AI，请求修正代码。

**请求体:**

```json
{
  "error": "ReferenceError: x is not defined",
  "code": "const x = 1; console.log(y);",
  "filePath": "apps/calc/logic.js"
}
```

**响应:** `200 OK`

```json
{
  "status": "success",
  "data": {
    "code": "const x = 1; console.log(x);"
  }
}
```

---

### 4.6 静态文件服务

#### 获取壳应用主界面

```http
GET /
```

**描述:** 获取壳应用的主界面 (dashboard.html)。

**响应:** `200 OK`

返回 dashboard.html 的完整内容。

---

#### 获取其他静态资源

```http
GET /public/*
```

**描述:** 获取壳应用的其他静态资源 (CSS、图片等)。

**响应:** `200 OK` 或 `404 Not Found`

---

## 5. Data Models

### 5.1 应用 (App)

**描述:** 微应用的基本信息

**字段:**

| 字段 | 类型 | 必需 | 描述 | 验证规则 |
|------|------|----------|-------------|------------|
| name | string | 是 | 应用名称 (kebab-case) | 最小 2 字符 |
| icon | string | 否 | 应用图标 (emoji) | - |
| description | string | 否 | 应用描述 | - |
| createdAt | datetime | 是 | 创建时间 | ISO 8601 |

**示例:**

```json
{
  "name": "todo-list",
  "icon": "📝",
  "description": "待办事项管理",
  "createdAt": "2026-01-17T00:00:00Z"
}
```

### 5.2 标签页 (Tab)

**描述:** 标签页的状态信息

**字段:**

| 字段 | 类型 | 必需 | 描述 | 验证规则 |
|------|------|----------|-------------|------------|
| id | string | 是 | 标签唯一标识 | UUID 格式 |
| name | string | 是 | 显示名称 | - |
| url | string | 是 | iframe 地址 | 有效 URL |
| icon | string | 否 | 图标 (emoji) | - |

**示例:**

```json
{
  "id": "tab-123",
  "name": "计算器",
  "url": "/apps/calculator/index.html",
  "icon": "🧮"
}
```

### 5.3 AI 生成请求 (AIGenerateRequest)

**描述:** AI 代码生成请求

**字段:**

| 字段 | 类型 | 必需 | 描述 | 验证规则 |
|------|------|----------|-------------|------------|
| prompt | string | 是 | 用户需求描述 | 最小 5 字符 |
| context | object | 否 | 上下文信息 | - |
| context.html | string | 否 | HTML 片段 | - |
| context.selector | string | 否 | CSS 选择器 | - |

### 5.4 AI 生成响应 (AIGenerateResponse)

**描述:** AI 生成的代码

**字段:**

| 字段 | 类型 | 必需 | 描述 |
|------|------|----------|-------------|
| html | string | 是 | HTML 代码 |
| js | string | 是 | JavaScript 代码 (ES Module) |
| css | string | 否 | CSS 代码 (可选) |

---

## 6. Error Codes

### 6.1 HTTP Status Codes

| 代码 | 含义 | 使用场景 |
|------|---------|-------|
| 200 | OK | 请求成功 |
| 400 | Bad Request | 请求参数无效 |
| 404 | Not Found | 资源不存在 |
| 500 | Internal Server Error | 服务器内部错误 |

### 6.2 Error Response Format

```json
{
  "status": "error",
  "error": {
    "code": "ERROR_CODE",
    "message": "人类可读的错误消息",
    "details": {
      "field": "额外错误信息"
    }
  }
}
```

### 6.3 Common Error Codes

| 代码 | 消息 | 描述 |
|------|---------|-------------|
| FILE_NOT_FOUND | 文件不存在 | 请求的文件在文件系统中找不到 |
| INVALID_PARAMS | 请求参数无效 | 请求参数格式或内容不正确 |
| WORKSPACE_INVALID | 工作区路径无效 | 配置的工作区路径不存在 |
| AI_GENERATION_FAILED | AI 生成失败 | 调用 AI API 失败或超时 |
| SAVE_FAILED | 保存失败 | 写入文件失败 |

---

## 7. SDKs & Libraries

### 7.1 Official SDKs

当前无官方 SDK。

### 7.2 Community Libraries

社区可以基于此 API 文档创建客户端库。

---

## 8. Guides

### 8.1 Quick Start

1. 启动 Kura 服务: `bun run server.js`
2. 浏览器访问: `http://localhost:3000`
3. 调用 API 进行开发

**示例: 获取应用列表**

```javascript
const response = await fetch('http://localhost:3000/api/apps');
const data = await response.json();
console.log(data.data); // ["calculator", "todo-list"]
```

### 8.2 Common Use Cases

#### Use Case 1: 创建新应用

```javascript
// 1. 生成代码
const genResponse = await fetch('/api/ai/generate', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ prompt: '创建一个计数器' })
});
const { data } = await genResponse.json();

// 2. 保存 HTML
await fetch('/api/save', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    path: 'apps/counter/index.html',
    content: data.html
  })
});

// 3. 保存 JS
await fetch('/api/save', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    path: 'apps/counter/logic.js',
    content: data.js
  })
});
```

#### Use Case 2: DOM 锚定修改

```javascript
// 1. 获取元素代码
const element = document.querySelector('#btn-submit');
const htmlSnippet = element.outerHTML;

// 2. 发送给 AI
const response = await fetch('/api/ai/generate', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    prompt: '把按钮改成红色',
    context: {
      html: htmlSnippet,
      selector: '#btn-submit'
    }
  })
});

// 3. 保存修改后的代码
const { data } = await response.json();
// ... 保存文件
```

### 8.3 Best Practices

- 始终使用 `https://esm.sh` 引入外部库
- 使用 JSDoc 添加类型注解
- 遵循 Alpine.js 的响应式语法
- 使用 Tailwind 类进行样式设计
- 避免在 logic.js 中操作 DOM

---

## 9. Changelog

### Version 1.0.0 (2026-01-17)

初始版本，包含:
- 应用管理 API
- 文件操作 API
- AI 生成 API
- 静态文件服务

---

## Appendix

### A. Glossary

| 术语 | 定义 |
|------|------------|
| 壳应用 | 容器应用，负责管理和运行微应用 |
| 微应用 | 小型、独立的 Web 应用 |
| @shared | 公共模块的虚拟路径前缀 |
| DOM 锚定 | 点击界面元素获取代码片段 |

### B. Support & Contact

- **文档:** 详见 `docs/` 目录
- **问题反馈:** GitHub Issues
